import boto3
import argparse
from typing import Any, Dict
from dotenv import load_dotenv

"""
Set the keywords for phone numbers and pools.
"""


keywords_to_set = [
    {
        "Keyword": "STOP",
        "KeywordMessage": "The Government of Canada will no longer text you from GC Notify. To resubscribe, text START. Standard message and data rates apply.",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "START",
        "KeywordMessage": "You subscribed to texts from GC Notify. To unsubscribe, text STOP. Standard message and data rates apply.",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "ARRÊT",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ARÊT",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ARRRÊT",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ARRET",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ARET",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ARRRET",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
    },
    {
        "Keyword": "ABONNER",
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pourvous désabonner, textez ARRÊT (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "ABONER",
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pourvous désabonner, textez ARRÊT (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "ABONNNER",
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pourvous désabonner, textez ARRÊT (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "AIDE",
        "KeywordMessage": "GC Notify: Visitez https://notification.canada.ca/contact Frais de msg/donnée std applicables. La fréquence des messages peut varier. Textez ARRET pour annuler.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    },
    {
        "Keyword": "HELP",
        "KeywordMessage": "GC Notify: More support found at https://notification.canada.ca/contact Std msg & data rates apply, msg frequency varies. Reply STOP to cancel.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    },
    {
        "Keyword": "INFO",
        "KeywordMessage": "GC Notify: More info at https://notification.canada.ca Data rates apply. Plus d’informations à https://notification.canada.ca Frais de msg/donnée std applicables.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    }
]


def set_keywords(client: Any, origination_identity: str, keywords_to_set: Dict[str, str]) -> None:
    """
    Set the keywords for the origination identity.
    
    client: Any
        The AWS Pinpoint client.
    origination_identity: str
        The origination identity (phone number or pool) to set the keywords for.
    keywords_to_set: Dict[str, str]
        The keywords to set.
    """

    current_keywords = client.describe_keywords(OriginationIdentity=origination_identity)['Keywords']
    for keyword in current_keywords:
        if keyword['Keyword'] not in [k['Keyword'] for k in keywords_to_set]:
            client.delete_keyword(OriginationIdentity=origination_identity, Keyword=keyword['Keyword'])

    for keyword in keywords_to_set:
        client.put_keyword(OriginationIdentity=origination_identity, Keyword=keyword["Keyword"], KeywordMessage=keyword["KeywordMessage"], KeywordAction=keyword["KeywordAction"])


def main():
    load_dotenv()
    client = boto3.client('pinpoint-sms-voice-v2', region_name='ca-central-1')
    parser=argparse.ArgumentParser()
    parser.add_argument("--pools", help="Change keywords of pools", action="store_true", default=False)
    parser.add_argument("--phone_numbers", help="Change keywords of phone numbers not in a pool", action="store_true", default=False)
    args = parser.parse_args()

    if args.pools:
        for pool in client.describe_pools()['Pools']:
            print("Setting keywords for pool: " + pool['PoolId'])
            set_keywords(client, pool['PoolId'], keywords_to_set)
    
    if args.phone_numbers:
        for phone_number in client.describe_phone_numbers()['PhoneNumbers']:
            if phone_number.get('PoolId') is None:
                print("Setting keywords for phone number: " + phone_number['PhoneNumber'])    
                set_keywords(client, phone_number['PhoneNumberId'] , keywords_to_set)


if __name__ == "__main__":
    main()
