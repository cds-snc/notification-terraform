#!/bin/bash

# Script to display DNS records needed for AWS SES custom sending domain.
# Requires AWS CLI and jq to be installed and configured.
# Region is hardcoded to ca-central-1.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <yourdomain.com>"
    echo "Example: $0 example.com"
    exit 1
fi

DOMAIN="$1"
REGION="ca-central-1" # Hardcoded region

echo "==================================================================="
echo "Fetching SES configuration for domain: $DOMAIN in region: $REGION"
echo "==================================================================="

# --- 1. Get SESv2 Email Identity details (for MailFromDomain and potentially Easy DKIM) ---
# echo -e "\n>>> Phase 1: Checking SESv2 Email Identity (aws sesv2 get-email-identity)"
SESV2_IDENTITY_JSON=$(aws sesv2 get-email-identity --email-identity "$DOMAIN" --region "$REGION" 2>&1)

MAIL_FROM_DOMAIN=""
VERIFICATION_STATUS_V2="Not Found"
EASY_DKIM_TOKENS_V2=""

if ! echo "$SESV2_IDENTITY_JSON" | jq -e . > /dev/null 2>&1; then
    echo "Error: Failed to fetch or parse SESv2 email identity for $DOMAIN."
    echo "$SESV2_IDENTITY_JSON"
    # Attempt to continue for SES Classic DKIM as it might be configured independently
else
    MAIL_FROM_DOMAIN=$(echo "$SESV2_IDENTITY_JSON" | jq -r '.MailFromAttributes.MailFromDomain // empty')
    VERIFICATION_STATUS_V2=$(echo "$SESV2_IDENTITY_JSON" | jq -r '.VerificationStatus // "Not Found"')
    EASY_DKIM_TOKENS_V2=$(echo "$SESV2_IDENTITY_JSON" | jq -r '.DkimAttributes.Tokens[]? // empty')

    echo "   SESv2 Verification Status: $VERIFICATION_STATUS_V2"

    if [ -n "$MAIL_FROM_DOMAIN" ] && [ "$MAIL_FROM_DOMAIN" != "null" ]; then
        echo -e "\n\n   Custom MAIL FROM Domain Records (for $MAIL_FROM_DOMAIN):"
        echo "   ---------------------------------------------------------"
        echo "   Record Type: MX"
        echo "   Name/Host:   $MAIL_FROM_DOMAIN"
        echo "   Value:       10 feedback-smtp.$REGION.amazonses.com"
        echo -e "\n\n   SPF Domain Records "
        echo "   ---------------------------------------------------------"
        echo "   Record Type: TXT"
        echo "   Name/Host:   $MAIL_FROM_DOMAIN"
        echo "   Value:       \"v=spf1 include:amazonses.com ~all\""
        echo ""
        echo "   Record Type: TXT"
        echo "   Name/Host:   $DOMAIN"
        echo "   Value:       \"v=spf1 include:amazonses.com ~all\""
    else
        echo "   No Custom MAIL FROM domain configured or found via SESv2 get-email-identity."
    fi

    # DKIM CNAMEs from this phase are not printed here directly.
    # They are considered in the "Consolidated DKIM CNAME Records" section.
    # Diagnostic notes are still useful.
    if [ -n "$EASY_DKIM_TOKENS_V2" ]; then
        if [ "$VERIFICATION_STATUS_V2" != "SUCCESS" ]; then
             echo -e "\n   NOTE (from SESv2 Easy DKIM check): If SESv2 Domain Verification Status is not 'SUCCESS',"
             echo "         ensure the DKIM CNAMEs (listed in the consolidated section below) are correctly published,"
             echo "         as they often handle domain verification for SESv2 identities."
        fi
    elif [ "$VERIFICATION_STATUS_V2" != "SUCCESS" ]; then
        echo -e "\n   SESv2 Domain Verification Note:"
        echo "   -------------------------------"
        echo "   SESv2 Verification Status is '$VERIFICATION_STATUS_V2' and no Easy DKIM tokens were found via get-email-identity."
        echo "   SES might require a specific TXT record for verification if not using DKIM CNAMEs for it."
        echo "   The AWS SES Console for $DOMAIN in $REGION is the best place to find the exact TXT record details if needed."
        echo "   Alternatively, publishing the DKIM CNAMEs from 'get-identity-dkim-attributes' (see Phase 2 / Consolidated section) often satisfies verification."
    fi
fi

# --- 2. Get SES Classic DKIM Attributes (as per your Terraform `aws_ses_domain_dkim`) ---
# echo -e "\n>>> Phase 2: Checking SES Classic DKIM Attributes (aws ses get-identity-dkim-attributes)"
SES_CLASSIC_DKIM_JSON=$(aws ses get-identity-dkim-attributes --identities "$DOMAIN" --region "$REGION" 2>&1)

DKIM_TOKENS_CLASSIC=""
DKIM_VERIFICATION_STATUS_CLASSIC="Not Found"

if ! echo "$SES_CLASSIC_DKIM_JSON" | jq -e ".DkimAttributes[\"$DOMAIN\"]" > /dev/null 2>&1; then
    echo "Error: Failed to fetch or parse SES Classic DKIM attributes for $DOMAIN."
    echo "$SES_CLASSIC_DKIM_JSON"
else
    # echo "Successfully fetched SES Classic DKIM attributes."
    DKIM_TOKENS_CLASSIC=$(echo "$SES_CLASSIC_DKIM_JSON" | jq -r ".DkimAttributes[\"$DOMAIN\"].DkimTokens[]? // empty")
    DKIM_VERIFICATION_STATUS_CLASSIC=$(echo "$SES_CLASSIC_DKIM_JSON" | jq -r ".DkimAttributes[\"$DOMAIN\"].DkimVerificationStatus // \"Not Found\"")
    # echo "   SES Classic DKIM Verification Status: $DKIM_VERIFICATION_STATUS_CLASSIC"
fi

# --- Consolidated DKIM CNAME Records ---
echo -e "\n\n   Consolidated DKIM CNAME Records to Implement"
echo "   ---------------------------------------------"
# Prioritize Classic DKIM tokens if available, as they align with 'locals.custom_sending_domain_dkim_records' in your ses.tf
if [ -n "$DKIM_TOKENS_CLASSIC" ]; then
    # echo "   (Sourced from SES Classic DKIM configuration - 'aws_ses_domain_dkim' resource)"
    # echo "   These tokens align with what 'locals.custom_sending_domain_dkim_records' would use."
    echo "$DKIM_TOKENS_CLASSIC" | while read -r token; do
        if [ -n "$token" ]; then
            echo ""
            echo "   Record Type: CNAME"
            echo "   Name/Host:   ${token}._domainkey.${DOMAIN}"
            echo "   Value:       ${token}.dkim.amazonses.com"
        fi
    done
    if [ "$DKIM_VERIFICATION_STATUS_CLASSIC" != "Success" ]; then
        echo ""
        echo "   NOTE: SES Classic DKIM Verification Status is '$DKIM_VERIFICATION_STATUS_CLASSIC'."
        echo "   Ensure these CNAME records are correctly published in your DNS."
        echo "   These records are also often used for overall domain verification."
    fi
elif [ -n "$EASY_DKIM_TOKENS_V2" ]; then
    # echo "   (Sourced from SESv2 Easy DKIM - 'aws_sesv2_email_identity' resource)"
    echo "   No tokens found from SES Classic DKIM, using SESv2 Easy DKIM tokens instead."
    echo "$EASY_DKIM_TOKENS_V2" | while read -r token; do
        if [ -n "$token" ]; then
            echo ""
            echo "   Record Type: CNAME"
            echo "   Name/Host:   ${token}._domainkey.${DOMAIN}"
            echo "   Value:       ${token}.dkim.amazonses.com"
        fi
    done
    # The note for SESv2 verification status when Easy DKIM tokens are used is handled in Phase 1.
else
    echo "   No DKIM tokens found from either SES Classic DKIM configuration or SESv2 Easy DKIM."
    echo "   Check your SES configuration for $DOMAIN in $REGION."
fi
echo ""


# --- 3. DMARC Record (User-defined) ---
# echo -e "\n>>> Phase 3: DMARC Record (User-Defined - Highly Recommended)"
# echo "   ------------------------------------------------------------"
# echo "   AWS SES does not generate DMARC records. You must create one for your domain ($DOMAIN)."
# echo "   A DMARC record helps prevent spoofing and tells receivers how to handle mail that fails authentication."
# echo ""

# NOTE: We dont need to provide this, so we can comment it out
# echo -e "\n   Example DMARC TXT Record (start with a monitoring policy, then add reporting):"
# echo "   ---------------------------------------------"
# echo "   Record Type: TXT"
# echo "   Name/Host:   _dmarc.$DOMAIN"
# echo "   Value:       \"v=DMARC1; p=none;\""
# echo "   (Consider adding rua/ruf tags for reporting: e.g., rua=mailto:dmarc-reports@$DOMAIN)"
# echo ""
# echo "   Explanation of common DMARC parts:"
# echo "     v=DMARC1          - Protocol version."
# echo "     p=none            - Policy for messages that fail DMARC (none, quarantine, reject). Start with 'none'."
# echo "     rua=mailto:...    - URI to send aggregate reports to (recommended)."
# echo "     ruf=mailto:...    - URI to send forensic (failure) reports to (optional)."
# echo ""
# echo "   IMPORTANT: Customize your DMARC policy based on your organization's needs."
# echo "   Start with p=none to monitor, then gradually move to p=quarantine and p=reject as you gain confidence."
# echo "   Ensure any mailboxes for rua/ruf reports exist and are monitored."


echo -e "\n\n==================================================================="
echo "Script finished."
echo "Ensure the relevant records listed above are created in your DNS provider for $DOMAIN."
echo "DNS propagation can take some time. Always verify the status in the AWS SES Console."
echo "If your Terraform setup for 'ses_validation_dns_entries' handles DNS creation, these records should match what it provisions."