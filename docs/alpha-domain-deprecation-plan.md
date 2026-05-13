# Alpha API Domain Deprecation Plan

## Scope
Deprecate `api.notification.alpha.canada.ca` and migrate all users to `api.notification.canada.ca` without leaving users behind.

## Goals
- Remove old, unused alpha API domain.
- Simplify DNS and reduce maintenance risk.
- Ensure users are on the recommended API domain.

## Success Criteria
- Build a verified list of users still using the alpha API domain.
- Communication is in place and complete for impacted users.
- No users left behind.
- Alpha API domain is removed.

## Workstream Plan

### 1. Discovery and Tracking
- Query request logs in Athena for traffic to `api.notification.alpha.canada.ca`.
- Build and maintain a tracker of impacted users/accounts, owner, and migration status.
- Re-run query regularly (for example: weekly, then daily during cutover week).

#### Athena Query Runbook
Use this sequence to produce and maintain the impacted-user list.

Preflight checks (run first):

~~~sql
show databases;
~~~

~~~sql
show tables in notification_athena;
~~~

~~~sql
select count(*) from notification_athena.waf_logs limit 1;
~~~

1. Confirm there is still alpha-domain traffic in the last 30 days.
2. Generate a caller fingerprint list (IP + user agent + method + top paths + first/last seen).
3. Create a high-confidence outreach list by grouping likely same callers and assigning owners.
4. Re-run daily during migration week and compare deltas.

##### Query 1: Daily volume for alpha domain (last 30 days)
~~~sql
with waf_data as (
	select
		date(from_unixtime("timestamp" / 1000)) as day,
		header.value as host,
		action
	from notification_athena.waf_logs
	cross join unnest(httprequest.headers) as t(header)
	where lower(header.name) = 'host'
		and lower(trim(both '/' from header.value)) = 'api.notification.alpha.canada.ca'
		and from_unixtime("timestamp" / 1000) >= current_timestamp - interval '30' day
)
select
	day,
	count(*) as total_requests,
	count_if(action = 'ALLOW') as allowed_requests,
	count_if(action = 'BLOCK') as blocked_requests
from waf_data
group by 1
order by 1 desc;
~~~

##### Query 2: Impacted caller fingerprints for outreach (last 30 days)
~~~sql
with req as (
	select
		from_unixtime("timestamp" / 1000) as request_ts,
		lower(trim(both '/' from host_header.value)) as host,
		httprequest.clientip as client_ip,
		httprequest.country as country,
		httprequest.httpmethod as http_method,
		coalesce(nullif(trim(httprequest.uri), ''), '(no-uri)') as uri,
		coalesce(nullif(trim(ua_header.value), ''), '(no-user-agent)') as user_agent,
		action
	from notification_athena.waf_logs
	cross join unnest(httprequest.headers) as t(host_header)
	cross join unnest(httprequest.headers) as u(ua_header)
	where lower(host_header.name) = 'host'
		and lower(ua_header.name) = 'user-agent'
		and lower(trim(both '/' from host_header.value)) = 'api.notification.alpha.canada.ca'
		and from_unixtime("timestamp" / 1000) >= current_timestamp - interval '30' day
)
select
	client_ip,
	country,
	user_agent,
	http_method,
	count(*) as request_count,
	min(request_ts) as first_seen_utc,
	max(request_ts) as last_seen_utc,
	array_join(slice(array_sort(array_distinct(array_agg(uri))), 1, 10), ', ') as sample_paths,
	count_if(action = 'BLOCK') as blocked_count
from req
group by 1,2,3,4
order by request_count desc;
~~~

##### Query 3: Very recent activity check (last 72 hours)
~~~sql
with req as (
	select
		from_unixtime("timestamp" / 1000) as request_ts,
		lower(trim(both '/' from host_header.value)) as host,
		httprequest.clientip as client_ip,
		coalesce(nullif(trim(ua_header.value), ''), '(no-user-agent)') as user_agent
	from notification_athena.waf_logs
	cross join unnest(httprequest.headers) as t(host_header)
	cross join unnest(httprequest.headers) as u(ua_header)
	where lower(host_header.name) = 'host'
		and lower(ua_header.name) = 'user-agent'
		and lower(trim(both '/' from host_header.value)) = 'api.notification.alpha.canada.ca'
		and from_unixtime("timestamp" / 1000) >= current_timestamp - interval '72' hour
)
select
	client_ip,
	user_agent,
	count(*) as requests_72h,
	max(request_ts) as last_seen_utc
from req
group by 1,2
order by requests_72h desc, last_seen_utc desc;
~~~

##### Optional Cross-check Query (ALB logs)
~~~sql
select
	substr(time, 1, 10) as day,
	domain_name,
	count(*) as request_count,
	approx_distinct(client_ip) as unique_client_ips
from notification_athena.alb_logs
where lower(domain_name) = 'api.notification.alpha.canada.ca'
	and from_iso8601_timestamp(time) >= current_timestamp - interval '30' day
group by 1,2
order by 1 desc;
~~~

##### Turning Query Output into a User List
- Use Query 2 output as the primary impacted list seed.
- Deduplicate by likely caller identity: same user agent family + same IP/CIDR + same top paths.
- Enrich each row with owner and contact by checking support records, known integrations, and internal service ownership context.
- Keep confidence levels in the tracker: High, Medium, Low.
- Prioritize outreach to rows with recent traffic (Query 3) and high request volume.

##### Caveat
Edge logs in this setup do not include a direct service owner identifier. The impacted list is therefore built as a high-confidence caller inventory first, then enriched into a contactable owner list.

#### Tracking Fields (recommended)
- Team / Service name
- Owner name
- Owner email
- Environment
- Last seen request timestamp
- Request volume (7d/30d)
- Contacted date
- Reminder sent date
- Confirmed migrated date
- Notes / risks

### 2. Coordination Channel (Slack)
Create a temporary channel (example: `#proj-alpha-api-deprecation`) with Growth, Product, Translation, Support.

#### Kickoff Message (draft)
> We are coordinating the deprecation of `api.notification.alpha.canada.ca` and migration to `api.notification.canada.ca`.
>
> Why: simplify DNS, reduce maintenance/risk, and keep users on the recommended API domain.
>
> Roles:
> - Support: flag tickets mentioning alpha domain or sudden API issues.
> - Translation: review and translate communication templates.
> - Product/Growth: validate outreach coverage and high-risk users.
>
> We will run a scream test before final removal and post updates here.

### 3. User Communication Plan
- Notify impacted users with timeline and required action.
- Send reminder before scream test and before final removal.
- Track acknowledgement and migration completion.

#### User Email Template (draft)
Subject: Action required: update your GC Notify API endpoint

Hello,

We noticed your integration is using our legacy domain `api.notification.alpha.canada.ca`.

We are retiring this domain on **[DATE]**. Please update your API base URL to:
`api.notification.canada.ca`

No other integration changes are expected beyond the domain update.
After **[DATE]**, requests to the alpha domain will fail.

If you need help, reply to this message or contact support.

### 4. System Status Updates
(You indicated you will publish these updates manually.)

#### Upcoming Work (draft)
Title: Deprecation of legacy alpha API domain  
Status: Scheduled  
Message: We are retiring `api.notification.alpha.canada.ca`. This affects users still configured to call the alpha domain. Please migrate to `api.notification.canada.ca` before [DATE]. A scream test is planned on [DATE], followed by final removal on [DATE].

#### Completion Update (draft)
Title: Alpha API domain deprecation complete  
Status: Resolved  
Message: The `api.notification.alpha.canada.ca` domain has been retired. The primary endpoint `api.notification.canada.ca` remains available and unchanged.

### 5. Scream Test
- Run a temporary disruption window (for example 1-2 hours) instead of immediate permanent removal.
- Monitor support channels, logs, and the Slack coordination channel.
- If critical impact occurs, rollback quickly and assist affected users.

#### Scream Test Checklist
- Internal stakeholders informed.
- Support prepared with response script.
- Monitoring dashboard/log query ready.
- Rollback owner and steps confirmed.
- Start/end timestamps recorded.

### 6. Final Validation and Removal
- Validate no meaningful traffic remains to alpha domain.
- Confirm no unresolved support incidents related to alpha domain.
- Proceed with domain removal work (handled separately).

## QA Steps
- Query Athena logs for requests to alpha domain.
- Verify no support issues are open for alpha domain usage.

## Milestone Checklist
- [ ] Impacted users list created and validated.
- [ ] Initial user comms sent.
- [ ] Reminder comms sent.
- [ ] System status upcoming notice posted.
- [ ] Scream test completed and monitored.
- [ ] Final validation complete (traffic + support).
- [ ] Alpha domain removed.
- [ ] System status completion notice posted.

## Owner Notes
Use this file as the canonical runbook for this card. Update dates, query outputs, and checklist state as work progresses.