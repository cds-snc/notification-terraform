"""
Updates a customer managed VPC prefix list with the valid Google service CIDR
ranges.  These are determined by retrieving Google"s service CIDR range and 
subtracting the Google Cloud Platform CIDR ranges.

Adapted from Google"s CIDR tool:
https://github.com/GoogleCloudPlatform/networking-tools-python/tree/main/tools/cidr
"""
import boto3
import json
import logging

from os import environ
from urllib.request import urlopen
from urllib.error import HTTPError
    

IPRANGE_URLS = {
    "goog": environ.get(GOOGLE_SERVICE_CIDR_URL, "https://www.gstatic.com/ipranges/goog.json"),
    "cloud": environ.get(GOOGLE_CLOUD_CIDR_URL, "https://www.gstatic.com/ipranges/cloud.json"),
}

PREFIX_LIST_ID=environ.get("PREFIX_LIST_ID") # "pl-09c49f553bedcf992"

def read_url(url):
    """Reads data from a URL and returns a JSON object."""
    try:
        return json.loads(urlopen(url).read())
    except (IOError, HTTPError):
        logging.error(f"ERROR: Invalid HTTP response from {url}")
    except json.decoder.JSONDecodeError:
        logging.error(f"ERROR: Could not parse HTTP response from {url}")


def get_data(link):
    """Returns a list of CIDRs from a Google IP ranges JSON object."""
    data = read_url(link)
    if data:
        logging.info(f"{link} published: {data.get("creationTime")}")
        cidrs = set([])
        for e in data["prefixes"]:
            if "ipv4Prefix" in e:
                cidrs.add(e.get("ipv4Prefix"))
        return cidrs


def get_google_cidrs():
    cidrs = {group: get_data(link) for group, link in IPRANGE_URLS.items()}
    if len(cidrs) != 2:
        raise ValueError("ERROR: Could not process data from Google")
    return cidrs["goog"] - cidrs["cloud"]


def get_prefix_list_version(ec2_client, prefix_list_id):
    """Returns the version of the prefix list"""
    response = ec2_client.describe_managed_prefix_lists(
        PrefixListIds=[
            prefix_list_id,
        ]
    )
    return response["PrefixLists"][0]["Version"]


def get_prefix_list_entries(ec2_client, prefix_list_id, version):
    """Returns the entries of the prefix list"""
    response = ec2_client.get_managed_prefix_list_entries(
        MaxResults=100,
        PrefixListId=prefix_list_id,
        TargetVersion=version
    )
    return [e["Cidr"] for e in response["Entries"]]


def modify_managed_prefix_list(ec2_client, prefix_list_id, version, google_cidrs, entries):
    entries_to_add = set(google_cidrs) - set(entries)
    entries_to_remove = set(entries) - set(google_cidrs)
    if entries_to_add or entries_to_remove:
        logging.info(f"Adding entries: {entries_to_add}")
        logging.info(f"Removing entries: {entries_to_add}")
        response = ec2_client.modify_managed_prefix_list(
            PrefixListId=prefix_list_id,
            CurrentVersion=version,
            AddEntries=[{"Cidr": e} for e in entries_to_add],
            RemoveEntries=[{"Cidr": e} for e in entries_to_remove]
        )
    else:
        logging.info("No changes to prefix list")


def get_boto_client(type):
    """Returns a boto3 client of the given type"""
    return boto3.client(type)


def handler(event, context):
    """Retrieves the list of public Google service CIDR ranges"""
    google_cidrs = get_google_cidrs()

    ec2_client = get_boto_client("ec2")
    version = get_prefix_list_version(ec2_client, PREFIX_LIST_ID)
    entries = get_prefix_list_entries(ec2_client, PREFIX_LIST_ID, version)
    modify_managed_prefix_list(ec2_client, PREFIX_LIST_ID, version, google_cidrs, entries)

    return "success"


if __name__ == "__main__":
    handler()