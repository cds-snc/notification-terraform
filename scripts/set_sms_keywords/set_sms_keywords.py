import boto3
import argparse
from typing import Any
from dotenv import load_dotenv

"""
Set the keywords for phone numbers and pools.
"""


def check_sms_length_warning(keyword: str, message: str) -> None:
    """
    Check if the SMS message would be split into multiple parts and warn if so.
    
    SMS limits:
    - Single SMS: 160 characters (GSM 7-bit) or 70 characters (Unicode)
    - Multi-part SMS: 153 characters per part (GSM) or 67 characters per part (Unicode)
    
    Args:
        keyword: The keyword being set
        message: The message content to check
    """
    # Check if message contains non-GSM characters (requires Unicode encoding)
    gsm_basic = set("@£$¥èéùìòÇ\nØø\rÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ !\"#¤%&'()*+,-./0123456789:;<=>?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà")
    gsm_extended = set("^{}\\[~]|€")
    
    is_unicode = any(char not in gsm_basic and char not in gsm_extended for char in message)
    
    if is_unicode:
        # Unicode encoding: 70 chars single, 67 chars per part for multi-part
        single_limit = 70
        multipart_limit = 67
        encoding = "Unicode"
        message_length = len(message)
    else:
        # GSM 7-bit encoding: 160 chars single, 153 chars per part for multi-part
        # Extended GSM characters count as 2 characters
        char_count = sum(2 if char in gsm_extended else 1 for char in message)
        single_limit = 160
        multipart_limit = 153
        encoding = "GSM 7-bit"
        message_length = char_count
    
    if message_length > single_limit:
        parts_needed = (message_length - 1) // multipart_limit + 1
        if parts_needed >= 2:
            print(f"⚠️  WARNING: Keyword '{keyword}' message is {message_length} characters ({encoding}) and will be split into {parts_needed} SMS parts")
            print(f"   Message: {message[:50]}{'...' if len(message) > 50 else ''}")
            if parts_needed == 2:
                print(f"   Consider shortening the message to stay within {single_limit} characters for a single SMS")
            print()


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
        "Keyword": "FIN",
        "KeywordMessage": "Le gouvernement du Canada ne vous textera plus via Notification GC. Textez ABONNER pour reprendre (frais standards de messages/données).",
        "KeywordAction": "OPT_OUT",
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
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pour vous désabonner, textez FIN (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "ABONER",
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pour vous désabonner, textez FIN (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "ABONNNER",
        "KeywordMessage": "Inscription réussie aux messages texte de Notification GC. Pour vous désabonner, textez FIN (frais standards de messages/données).",
        "KeywordAction": "OPT_IN",
    },
    {
        "Keyword": "AIDE",
        "KeywordMessage": "Notification GC: Visitez https://notification.canada.ca/contact Frais de msg/données std applicables. La fréquence des messages peut varier. Textez FIN pour annuler.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    },
    {
        "Keyword": "HELP",
        "KeywordMessage": "GC Notify: More support found at https://notification.canada.ca/contact Std msg & data rates apply, msg frequency varies. Reply STOP to cancel.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    },
    {
        "Keyword": "INFO",
        "KeywordMessage": "GC Notify: More info at https://notification.canada.ca Data rates apply. Notification GC: Plus d'informations à https://notification.canada.ca Frais de msg/données std applicables.",
        "KeywordAction": "AUTOMATIC_RESPONSE",
    }
]


def set_keywords(client: Any, origination_identity: str, keyword_list: list) -> None:
    """
    Set the keywords for the origination identity.
    
    client: Any
        The AWS Pinpoint client.
    origination_identity: str
        The origination identity (phone number or pool) to set the keywords for.
    keyword_list: list
        The keywords to set.
    """

    current_keywords = client.describe_keywords(OriginationIdentity=origination_identity)['Keywords']
    for keyword in current_keywords:
        if keyword['Keyword'] not in [k['Keyword'] for k in keyword_list]:
            client.delete_keyword(OriginationIdentity=origination_identity, Keyword=keyword['Keyword'])

    for keyword in keyword_list:
        # Check for SMS length warning before setting the keyword
        check_sms_length_warning(keyword["Keyword"], keyword["KeywordMessage"])
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
