# VPN and Internal Tools

## Overview

GC Notify uses an AWS VPN to access internal tools and perform administrative tasks. This increases security, and ease of use for connecting to our various utilities. 

## Setup

### Pre-Requisites

[Download and install the AWS VPN Client](https://aws.amazon.com/vpn/client-vpn-download/)

### Profile Setup

Each environment has its own VPN, and thus you must set up 3 VPN profiles. Repeat the following steps for each environment.

1. Navigate to the [AWS Console](https://cds-snc-ct.awsapps.com/start#/)
2. Log in to the account for the environment you would like to set up
3. Search for "Client VPN Endpoints" or once you've done the above, simply [click here](https://ca-central-1.console.aws.amazon.com/vpc/home?region=ca-central-1#ClientVPNEndpoints:)
4. Select the radio button beside the only available endpoint
5. Click the "Download Client Configuration" button at the top right
6. Open the AWS VPN Client
7. Choose File -> Manage Profiles
8. Click "Add Profile"
9. Provide a display name - the name of the environment is recommended ex "Notify Staging"
10. Click the folder button and select the previously downloaded VPN Client Configuration
11. Click Done


## Tools Currently Available

* Blazer (use the start-blazer.sh script in the attic to connect)
* Kubernetes
* Database and redis (not recommended; no audits)

Connecting to redis and postgres directly would be using their respective CLI from your local machine

Redis:
``` shell
redis-cli -h notify-dev-cluster-cache-az.<amazon-generated>.amazonaws.com -p 6379
```

Postgres:
``` shell
psql  -h notification-canada-ca-dev-cluster.<amazon-generated>.rds.amazonaws.com -p 5432 -U username notificationcanadacadev
```

### Important Notes

- The internal DNS for each environment is not a standard DNS and thus will not be resolvable
without connecting to the appropriate VPN. 
- You MUST connect to the corresponding environment VPN to reach that DNS (ex staging for *.staging.notification.internal)
- Since the DNS is not standard, you MUST enter the https:// in the URL (at least the first time you navigate to it), or else you will be sent to search results. Bookmarking sites is recommended for ease of use.
- The SSL Certificate for these internal addresses is a self-signed certificate. You will have to accept and continue when you are warned about insecure connections. 

### Links

#### Dev

- https://blazer.dev.notification.internal.com

#### Staging

- https://blazer.staging.notification.internal.com

#### Production

- Coming soon

## Tools coming soon

- Graylog (Logs in Dev)
- Any other handy tools you would like to see?? Message @notifycore in Slack.
