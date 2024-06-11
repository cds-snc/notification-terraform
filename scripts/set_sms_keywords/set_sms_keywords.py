import json
import boto3

from dotenv import load_dotenv

"""
Set the keywords for the phone numbers in the account that are not in a pool.
"""

def main():
    load_dotenv()

    # TODO: Do we want all these unicode characters? In particular the no break spaces \u202f 
    # TODO: Do we want to include the "GC Notify:" prefix in the messages?
    # TODO: Do we want a space in the INFO message ... applyPlus ...
    # TODO: Should "ARRET" be an "OPT_OUT"?

    keyword_data = [
        {
            "Keyword": "AIDE",
            "KeywordMessage": "GC Notify: Visitez https://notification.canada.ca/contact Frais de msg/donnée std applicables. La fréquence des messages peut varier. Textez ARRET pour annuler.",
            "KeywordAction": "AUTOMATIC_RESPONSE",
        },
        {
            "Keyword": "ARRET",
            "KeywordMessage": "GC Notify: Vous êtes désinscrit des notifications du gouvernement du Canada. Frais de msg/donnée std applicables.",
            "KeywordAction": "AUTOMATIC_RESPONSE",
        },
        {
            "Keyword": "HELP",
            "KeywordMessage": "GC Notify: More support found at https://notification.canada.ca/contact Std msg & data rates apply, msg frequency varies. Reply STOP to cancel.",
            "KeywordAction": "AUTOMATIC_RESPONSE",
        },
        {
            "Keyword": "INFO",
            "KeywordMessage": "GC Notify: More info at https://notification.canada.ca Data rates applyPlus d’informations à https://notification.canada.ca Frais de msg/donnée std applicables",
            "KeywordAction": "AUTOMATIC_RESPONSE",
        },
        {
            "Keyword": "STOP",
            "KeywordMessage": "GC Notify: You have been unsubscribed from the Government of Canada Notify. Std msg & data rates apply.",
            "KeywordAction": "OPT_OUT",
        },
    ]

    client = boto3.client('pinpoint-sms-voice-v2', region_name='ca-central-1')

    phone_numbers = client.describe_phone_numbers()['PhoneNumbers']

    for phone_number in phone_numbers:
        if phone_number.get('PoolId') is None:
            id = phone_number['PhoneNumberId']            
            keywords = client.describe_keywords(OriginationIdentity=id)['Keywords']
            print(json.dumps(keywords, indent=4))

            for keyword in keywords:
                if keyword['Keyword'] not in [k['Keyword'] for k in keyword_data]:
                    client.delete_keyword(OriginationIdentity=id, Keyword=keyword['Keyword'])

            for keyword in keyword_data:
                client.put_keyword(OriginationIdentity=id, Keyword=keyword["Keyword"], KeywordMessage=keyword["KeywordMessage"], KeywordAction=keyword["KeywordAction"])


if __name__ == "__main__":
    main()
