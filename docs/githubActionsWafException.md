# GitHub Actions WAF Exception

This configuration adds an exception to the `CanadaUSOnlyGeoRestriction` WAF rule to allow GitHub Actions runners to access the API even when they're running from outside Canada/US.

## How it works

1. **Dynamic IP Fetching**: `github_actions_ipset.tf` uses a Terraform `external` data source to automatically fetch current GitHub Actions runner IP ranges from `https://api.github.com/meta`
2. **IP Set Creation**: Creates an AWS WAF IP set containing the dynamically fetched GitHub Actions runner IP ranges
3. **WAF Rule Modification**: The geo-restriction rule now uses an AND statement that blocks traffic that is:
   - NOT from Canada/US AND
   - NOT from GitHub Actions IP ranges

## Logic Flow

```
IF (NOT from CA/US) AND (NOT from GitHub Actions IPs) 
THEN block 
ELSE allow
```

This means traffic is allowed if it's either:
- From Canada or US, OR
- From GitHub Actions IP ranges (regardless of geography)

## Automatic Updates

The IP ranges are automatically fetched from GitHub's API on every `terraform plan` or `terraform apply`. This ensures:

- **Always current**: No manual intervention needed to keep IP ranges up to date
- **Immediate updates**: New GitHub Actions IP ranges are included automatically
- **Reliability**: GitHub's API is the authoritative source

## How the Data Source Works

```hcl
data "external" "github_actions_ips" {
  program = ["bash", "${path.module}/../../scripts/update_github_actions_ips.sh"]
  
  query = {
    timestamp = timestamp()  # Forces refresh on every plan/apply
  }
}
```

The external data source:
1. Runs the shell script that calls GitHub's API
2. Returns JSON with the IP ranges array
3. Refreshes on every Terraform operation (due to timestamp query)
4. Handles errors gracefully if GitHub's API is unavailable

## Security Considerations

- **Scope**: This exception only applies to the geo-restriction rule. All other WAF rules (rate limiting, malicious IP blocking, etc.) still apply to GitHub Actions traffic.

- **Risk**: GitHub Actions runners are managed by GitHub and could theoretically be used by anyone with access to your repository. Ensure your repository access controls are appropriate.

- **Monitoring**: Consider adding CloudWatch alarms to monitor traffic from GitHub Actions IP ranges.

- **API Dependency**: The solution depends on GitHub's API being available during Terraform operations. If the API is down, Terraform will fail.

## Alternative Approaches

If you prefer more restrictive access, consider:

1. **Self-hosted runners** in Canadian infrastructure
2. **VPN/Private networking** for GitHub Actions
3. **API authentication** to validate legitimate GitHub Actions requests
4. **Webhook validation** using GitHub's webhook signatures

## Maintenance

- **No manual maintenance required**: IP ranges update automatically
- Monitor CloudWatch metrics for the `CanadaUSOnlyGeoRestriction` rule
- Monitor Terraform runs to ensure GitHub API availability
- Current IP range count: ~5,600+ ranges (as of 2024)

## Troubleshooting

If Terraform fails during planning/applying:

1. **Check GitHub API status**: Visit https://www.githubstatus.com/
2. **Manual fallback**: Temporarily disable the timestamp query to use cached results
3. **Test script manually**: Run `./scripts/update_github_actions_ips.sh` to verify API connectivity

## Outputs

The configuration provides useful outputs:

- `github_actions_ip_set_arn`: ARN of the created IP set
- `github_actions_ip_count`: Number of IP ranges (useful for monitoring)