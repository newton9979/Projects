# AWS CloudTrail

This document explains how AWS CloudTrail is used in the **AWS Project 1 – Server Monitoring & Log Backup System**, why it was included in the architecture, and how it integrates with the rest of the infrastructure.

---

# Purpose

AWS CloudTrail records all AWS API activity within the account, providing visibility into who did what, when, and from where. It acts as the auditing and governance layer of the architecture, complementing the operational monitoring provided by CloudWatch.

While CloudWatch focuses on **infrastructure health** (CPU, memory, disk, network), CloudTrail focuses on **account-level activity** (console logins, resource changes, API calls).

---

# Why CloudTrail Was Selected

- Provides a complete audit history of account activity.
- Helps detect unauthorized or unexpected changes.
- Supports security investigations and troubleshooting.
- Required for compliance and governance best practices.
- Works automatically in the background with no impact on EC2 performance.

---

# What CloudTrail Captures

CloudTrail logs every API call made within the AWS account, including:

- Console sign-in events
- IAM activity (role creation, policy changes, permission updates)
- EC2 activity (instance launch, stop, terminate, AMI creation)
- S3 activity (bucket creation, object uploads, permission changes)
- CloudWatch and SNS configuration changes
- Any other AWS service API request made using the account's credentials or IAM role

---

# Architecture Position

```text
                AWS Account
                     │
                     ▼
              AWS CloudTrail
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   Console Logins  IAM Activity  Resource Changes
                     │
                     ▼
              Event History
                     │
                     ▼
         (Optional) Amazon S3 Bucket
              for Long-Term Log Storage
```

CloudTrail operates independently of the EC2 instance and does not depend on the Apache server, EBS, or EFS. It monitors the **AWS account itself**, not the application running on it.

---

# How CloudTrail Fits Into the Overall Architecture

```text
EC2 Instance
      │
      ▼
  IAM Role
      │
      ├── Amazon S3        (log backups)
      ├── Amazon CloudWatch (metrics)
      └── AWS CloudTrail    (API auditing)
```

Every action taken by the IAM Role attached to the EC2 instance — such as uploading logs to S3 or publishing CloudWatch metrics — is itself recorded as an event in CloudTrail. This creates a traceable record of automated activity, not just manual console actions.

---

# Event History vs. Trail

CloudTrail offers two ways to view activity:

| Feature | Event History | Trail |
|---------|---------------|-------|
| Retention | Last 90 days | Configurable (long-term) |
| Storage Location | AWS-managed | Amazon S3 bucket |
| Setup Required | None (enabled by default) | Must be created manually |
| Use Case | Quick lookups, recent troubleshooting | Long-term auditing, compliance |

For this project, **Event History** is sufficient for day-to-day review. Creating a **Trail** that delivers logs to an S3 bucket is recommended as an enhancement for long-term retention and compliance.

---

# Setup Steps (Console)

1. Open the **CloudTrail** console.
2. CloudTrail is enabled by default and automatically records the last 90 days of account activity under **Event History** — no setup is required to view recent events.
3. (Optional, recommended) Create a **Trail**:
   - Go to **Trails → Create trail**.
   - Provide a trail name (e.g., `project1-management-events`).
   - Choose **Apply trail to all regions** for full account visibility.
   - Select or create an S3 bucket to store the log files (a dedicated bucket, separate from the log-backup bucket, is recommended).
   - Enable **Log file validation** to detect tampering.
   - Save the trail.
4. Verify events are being delivered to the S3 bucket after a few minutes of account activity.

---

# Sample Event Lookup

Using the AWS CLI, recent IAM and EC2 activity can be queried directly:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventSource,AttributeValue=ec2.amazonaws.com \
  --max-results 10
```

This returns a JSON list of recent EC2-related API calls, including the event name, user identity, source IP, and timestamp.

---

# Security Benefits

- **No hardcoded credentials needed** — CloudTrail relies on the same IAM Role-based permissions already used throughout the project.
- **Tamper detection** — log file validation ensures stored CloudTrail logs have not been altered.
- **Accountability** — every change to IAM, EC2, S3, or other resources is attributed to a specific identity.
- **Faster incident response** — administrators can quickly determine the root cause of unexpected changes (e.g., a terminated instance or a modified security group).

---

# Real-World Scenario

An administrator notices that a CloudWatch Alarm threshold was unexpectedly changed, causing missed notifications during a recent CPU spike.

Using CloudTrail, the administrator:

1. Opens **Event History** in the CloudTrail console.
2. Filters events by **Event source: monitoring.amazonaws.com**.
3. Locates the `PutMetricAlarm` event.
4. Identifies the IAM identity and timestamp associated with the change.
5. Confirms whether the change was authorized or requires further investigation.

This demonstrates how CloudTrail provides accountability and traceability across the entire architecture.

---

# Operational Best Practices

- Enable a multi-region Trail rather than relying solely on 90-day Event History.
- Store CloudTrail logs in a dedicated, access-restricted S3 bucket.
- Enable log file validation to detect tampering.
- Periodically review CloudTrail logs for unusual or unauthorized activity.
- Consider integrating CloudTrail with CloudWatch Logs and a metric filter/alarm for real-time alerting on sensitive actions (e.g., IAM policy changes, root login).

---

# Screenshots Used in This Section

Store these screenshots in:

```text
screenshots/
└── CloudTrail/
    ├── 01-cloudtrail-overview.png
    ├── 02-event-history.png
    ├── 03-trail-creation.png
    └── 04-event-lookup-example.png
```

---

# Summary

AWS CloudTrail adds an essential governance and auditing layer to the architecture. While EC2, EBS, EFS, CloudWatch, SNS, and the Golden AMI handle hosting, storage, monitoring, and recovery, CloudTrail ensures that every administrative and automated action taken within the AWS account is recorded, attributable, and reviewable — a key requirement for any secure, production-aligned environment.

---

> **Related Documentation**
>
> - IAM Configuration → `03-IAM.md`
> - Amazon EBS → `08-EBS.md`
> - Amazon EFS → `09-EFS.md`
> - CloudWatch → `10-CloudWatch.md`
> - CloudWatch Alarms → `11-CloudWatch-Alarms.md`
> - Amazon SNS → `12-SNS.md`
> - Amazon AMI → `13-AMI.md`
