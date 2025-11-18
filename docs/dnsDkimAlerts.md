# DNS/DKIM Record Alert Response Process

## Overview
This document describes the process to follow when receiving a Slack warning alert about missing or invalid DKIM/DNS records for SES domain identities.

## Monitoring Mechanism
The system monitors for SES-related issues through:
- **AWS Health Events**: Captures AWS notifications about SES reputation and domain identity issues
- **CloudWatch Alarms**: Monitors SES bounce rates, complaint rates, and sending metrics (already in place)
- **Manual Verification**: Periodic checks by the operations team (recommended)

## Alert Types
The system monitors for the following DNS/DKIM issues:
- **Domain Identity Issues**: Problems with domain verification records
- **DKIM Verification Issues**: Missing or invalid DKIM DNS records
- **Reputation Issues**: SES reputation problems that may indicate DNS/email configuration issues

## When You Receive an Alert

### 1. Identify the Affected Domain
The alert will contain information about which domain is experiencing verification issues. Review the alert details to identify:
- The domain name (e.g., `example.gov.ca`)
- The type of failure (domain verification or DKIM)
- The timestamp of the issue

### 2. Query for Domain Owners

#### Blazer Query
Use the following Blazer query to identify the domain owners and affected clients:

```sql
-- Query: Get Domain Owners for DNS/DKIM Alert
-- Description: Find all services using a specific sending domain
SELECT 
    s.id as service_id,
    s.name as service_name,
    s.email_from as email_domain,
    u.name as owner_name,
    u.email_address as owner_email,
    s.active as is_active,
    s.created_at
FROM 
    services s
    LEFT JOIN users u ON s.created_by_id = u.id
WHERE 
    s.email_from LIKE '%[DOMAIN]%'  -- Replace [DOMAIN] with the affected domain
    AND s.active = true
ORDER BY 
    s.created_at DESC;
```

**Note**: Replace `[DOMAIN]` in the query with the actual domain from the alert (e.g., `novascotia.ca`).

### 3. Verify the DNS Records
Check the current DNS configuration for the affected domain:

```bash
# Check DKIM records
dig TXT [token1]._domainkey.[domain]
dig TXT [token2]._domainkey.[domain]
dig TXT [token3]._domainkey.[domain]

# Check domain verification records (if applicable)
dig TXT _amazonses.[domain]

# Check MX records for bounce handling
dig MX bounce.[domain]
```

### 4. Create an Incident (if needed)
Based on the severity and impact:
- **High Impact** (production domain, multiple services affected): Create a P2 incident
- **Medium Impact** (single service affected): Create a P3 incident
- **Low Impact** (test/dev domain): Monitor and notify service owner

### 5. Notify Affected Clients

#### Freshdesk Canned Response
Use the following Freshdesk canned response template:

**Subject**: Action Required: DNS Configuration Issue for [DOMAIN]

**Body**:
```
Hello,

We have detected that DNS records for your domain ([DOMAIN]) used with GC Notify are missing or invalid. This may impact your ability to send emails through our service.

What happened:
AWS Simple Email Service (SES) has detected that critical DNS records (DKIM or verification records) for your domain are not properly configured. This typically occurs when DNS records are changed or removed.

Impact:
- Emails from your service may fail to send
- Email deliverability may be affected
- Domain reputation may be impacted

Required action:
Please verify that the following DNS records are correctly configured for your domain:

[Include specific DKIM tokens and DNS records from the SES console or terraform outputs]

If your organization recently made DNS changes, please restore the required records or contact us for assistance.

Next steps:
1. Verify the DNS records listed above are in place
2. Wait 24-48 hours for DNS propagation
3. Contact GC Notify support if you need assistance

We're here to help! Reply to this ticket if you have any questions.

Thank you,
GC Notify Support Team
```

### 6. Document Actions Taken
Record in the incident or ticket:
- Time alert was received
- Affected domain(s) and services
- Client contact information
- Actions taken
- Resolution time

## Prevention
To prevent future issues:
- Encourage clients to notify us before making DNS changes
- Document all custom domain configurations
- Set up monitoring for all production domains
- Maintain up-to-date contact information for domain owners

## Related Resources
- [AWS SES Domain Verification](https://docs.aws.amazon.com/ses/latest/dg/verify-domains.html)
- [AWS SES DKIM](https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim.html)
- [Terraform DNS Module](../aws/dns/)
- [SES Configuration](../aws/dns/ses.tf)

## Escalation
If you need additional support:
- **Technical Issues**: Contact the platform team via #notify-ops Slack channel
- **Client Communication**: Contact the support lead
- **After Hours (P1/P2)**: Follow the on-call escalation process
