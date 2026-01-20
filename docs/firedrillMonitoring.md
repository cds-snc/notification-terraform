# Fire Drill External Monitoring Setup

## Overview
The fire drill Lambda sends test alerts to Slack (dev channel) daily at 9am ET. To ensure these tests actually run **and reach Slack**, we use a GitHub Action that runs independently of AWS to verify the messages appeared.

## How It Works
1. **Lambda runs** (9am ET daily) and sends test alerts to SNS → Slack
2. **GitHub Action runs** (every hour) and checks Slack for fire drill messages from the last 25 hours
3. **If messages missing** → GitHub Action fails and posts alert to ops Slack channel
4. **Completely independent** → Works even if AWS infrastructure is deleted or Slack integration breaks

## Why GitHub Actions?
- ✅ **External to AWS** - Monitors from outside your infrastructure
- ✅ **No secrets in Lambda** - Slack token stored securely in GitHub
- ✅ **Verifies end-to-end** - Confirms messages actually reach Slack, not just SNS
- ✅ **Simple setup** - Just add secrets, no heartbeat service needed
- ✅ **Built-in notifications** - Uses Slack webhook for alerts

## Setup

### Step 1: Create Slack Bot (for verification)

1. Go to https://api.slack.com/apps
2. Create a new app or use existing bot
3. Add OAuth scopes:
   - `channels:history` (to read public channels)
   - `groups:history` (if using private channels)
4. Install/reinstall app to workspace
5. Copy the "Bot User OAuth Token" (starts with `xoxb-`)
6. Get your Slack channel ID:
   - Right-click dev channel → View channel details → Copy ID
   - Or from URL: `https://app.slack.com/client/T.../C123ABC` (C123ABC is the ID)

### Step 2: Create Slack Webhook (for failure alerts)

1. Go to https://api.slack.com/apps → Your App → Incoming Webhooks
2. Activate Incoming Webhooks
3. Add New Webhook to Workspace
4. Select your ops/critical alerts channel (NOT the dev channel)
5. Copy the webhook URL (starts with `https://hooks.slack.com/...`)

### Step 3: Add GitHub Secrets

In your GitHub repository settings → Secrets and variables → Actions:

1. Add `SLACK_BOT_TOKEN` = `xoxb-your-bot-token-here`
2. Add `FIRE_DRILL_SLACK_CHANNEL_ID` = `C1234567890` (your dev channel ID)
3. Add `SLACK_OPS_WEBHOOK` = `https://hooks.slack.com/...` (for failure notifications to ops channel)

### Step 4: Enable GitHub Action

The workflow file is already in `.github/workflows/verify-fire-drill.yml`. It will:
- Run every hour at :30 past the hour
- Check for fire drill messages from the last 25 hours
- Fail and alert to ops channel if messages are missing
- Can be manually triggered from the Actions tab

## Testing

### Test the Fire Drill Lambda
```bash
cd env/dev/common
aws lambda invoke --function-name alarm-fire-drill response.json
cat response.json
```

Check dev Slack channel - you should see 3 test messages within a few seconds.

### Test the GitHub Action
1. Go to your GitHub repo → Actions tab
2. Select "Verify Fire Drill Alerts" workflow
3. Click "Run workflow" → Run
4. Check the logs - should show all 3 alerts found (✅)
5. Wait for next scheduled run (every hour at :30)

### Simulate Failure
1. Disable the EventBridge rule for the fire drill
2. Wait 26+ hours
3. GitHub Action will fail and post alert to ops Slack channel
4. GitHub Action run will show as failed with details

## What Gets Caught

This setup will alert you if:
- ✅ Fire drill Lambda doesn't run (EventBridge failure)
- ✅ Fire drill Lambda errors/crashes  
- ✅ SNS topics deleted or misconfigured
- ✅ Slack integration Lambda fails
- ✅ Slack webhook broken or revoked
- ✅ Slack API issues
- ✅ **Messages don't reach Slack for any reason**
- ✅ Entire AWS infrastructure deleted
- ✅ GitHub Action itself fails (you'll see failed workflow in GitHub)

## For Production

When you deploy to production:

1. Update the condition in `alarm_fire_drill.tf` to include production:
   ```hcl
   count = var.cloudwatch_enabled && (var.env == "dev" || var.env == "production") ? 1 : 0
   ```

2. Update the schedule to run in production channel as well

3. Modify the GitHub Action workflow to check both dev and prod channels:
   ```yaml
   # Add production channel ID to secrets
   PROD_FIRE_DRILL_SLACK_CHANNEL_ID: ${{ secrets.PROD_FIRE_DRILL_SLACK_CHANNEL_ID }}
   ```

4. Fire drills will run in both environments, verified independently by the same GitHub Action

## Troubleshooting

### GitHub Action fails with "Failed to fetch Slack messages"
- Check that `SLACK_BOT_TOKEN` is valid and not expired
- Verify the bot has `channels:history` permission
- Make sure the bot is added to the channel

### GitHub Action can't find fire drill messages
- Check Lambda CloudWatch logs - did it actually run?
- Verify EventBridge rule is enabled
- Check SNS topic subscriptions
- Verify Slack integration Lambda is working

### Ops channel doesn't receive failure alerts
- Verify `SLACK_OPS_WEBHOOK` is correct
- Check webhook hasn't been revoked
- Test webhook manually with `curl`
