# Troubleshooting Guide

## Overview

This document provides a structured troubleshooting guide for the **AWS Project 1 – Server Monitoring & Log Backup System**.

During infrastructure deployment and day-to-day operations, issues may occur due to incorrect configurations, missing permissions, networking problems, or software failures.

This guide explains how to identify, diagnose, and resolve common issues encountered in this project.

---

# Troubleshooting Objectives

The goal of this guide is to help administrators:

- Quickly identify failures
- Understand root causes
- Apply the correct solution
- Verify successful recovery
- Reduce system downtime

---

# Troubleshooting Workflow

Every issue should be investigated using the following process.

```text
Problem Reported
        │
        ▼
Identify Symptoms
        │
        ▼
Collect Logs
        │
        ▼
Check Configuration
        │
        ▼
Identify Root Cause
        │
        ▼
Apply Fix
        │
        ▼
Verify Resolution
        │
        ▼
Document the Issue
```

---

# Diagnostic Tools Used

Throughout this project, the following tools are commonly used for troubleshooting.

| Tool | Purpose |
|------|---------|
| AWS Console | Resource verification |
| AWS CLI | Resource management |
| journalctl | Service logs |
| systemctl | Service status |
| df -h | Disk usage |
| lsblk | Block device information |
| mount | Mounted file systems |
| ping | Network connectivity |
| curl | HTTP endpoint testing |
| crontab | Scheduled jobs |
| CloudWatch Logs | Monitoring and diagnostics |
| CloudTrail | AWS API activity |
| Amazon S3 | Backup verification |

---

# General Troubleshooting Checklist

Before investigating a specific issue, verify the following:

- AWS Region is correct
- EC2 instance is running
- Security Groups allow required traffic
- IAM Role is attached
- Internet connectivity is available
- Required services are running
- File system mounts are present
- AWS CLI is functioning correctly

---

# Common Troubleshooting Principles

## 1. Verify Before Changing

Always confirm the current state before modifying configurations.

Example:

```bash
systemctl status httpd
```

---

## 2. Read Error Messages Carefully

Error messages often indicate the root cause.

Example:

```text
AccessDenied
```

Usually indicates an IAM permission issue.

---

## 3. Check Logs First
[O
Logs provide valuable information about failures.

Examples:

```bash
journalctl -u httpd
```

```bash
journalctl -u amazon-cloudwatch-agent
```

---

## 4. Test Incrementally

After applying a fix:

- Test the affected service.
- Verify expected behavior.
- Confirm dependent services are also functioning.

---

# Incident Severity Levels

| Severity | Description | Example |
|----------|-------------|---------|
| Low | Minor issue with minimal impact | Dashboard widget missing |
| Medium | Feature unavailable | CloudWatch metrics not updating |
| High | Core service failure | Apache service stopped |
| Critical | Complete system outage | EC2 instance unavailable |

---

# Evidence Collection

Whenever troubleshooting an issue, collect:

- Error messages
- Command outputs
- Service logs
- CloudWatch metrics
- CloudTrail events
- Screenshots (if applicable)

This information helps with root cause analysis and future reference.

---

# Screenshot Organization

Store troubleshooting screenshots in:

```text
AWS-Project-1-Server-Monitoring-System/
└── screenshots/
    └── Troubleshooting/
```

Suggested filenames:

```text
01-overview.png
02-diagnostic-workflow.png
03-error-message.png
04-log-analysis.png
```

---

# Best Practices

- Troubleshoot one issue at a time.
- Keep a record of changes made.
- Avoid making multiple configuration changes simultaneously.
- Validate fixes before closing the incident.
- Update documentation after resolving issues.

---

# Part 1 Summary

In this section, you learned:

- ✔ Troubleshooting methodology
- ✔ Diagnostic workflow
- ✔ Common troubleshooting tools
- ✔ General investigation checklist
- ✔ Incident severity levels

In **Part 2**, we will troubleshoot:

- IAM permission issues
- EC2 connectivity problems
- Apache failures
- Amazon EBS issues
- Amazon EFS mount problems

---

# Part 2: IAM, EC2, Apache, EBS, and EFS Troubleshooting

This section covers common issues related to infrastructure setup and storage configuration.

Each issue includes:

- Symptoms
- Possible Causes
- Diagnosis
- Resolution
- Verification
- Real-World Scenario

---

# Issue 1: IAM Role Not Attached to EC2

## Symptoms

- AWS CLI commands fail.
- Unable to upload files to Amazon S3.
- CloudWatch Agent cannot publish metrics.

Example:

```text
An error occurred (AccessDenied) when calling the PutObject operation
```

---

## Diagnosis

Check whether an IAM Role is attached.

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

If the command returns nothing, no IAM Role is attached.

Verify identity.

```bash
aws sts get-caller-identity
```

---

## Resolution

1. Open AWS Console.
2. Navigate to:

```text
EC2
→ Instances
→ Actions
→ Security
→ Modify IAM Role
```

3. Attach the correct IAM Role.
4. Wait 1–2 minutes for credentials to become available.

---

## Verification

```bash
aws sts get-caller-identity
```

Expected:

```text
{
  "Account": "XXXXXXXXXXXX",
  "Arn": "arn:aws:sts::XXXXXXXXXXXX:assumed-role/...",
  "UserId": "..."
}
```

---

## Real Issue Encountered

During this project, the EC2 instance returned an empty response for:

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

This indicated that no IAM Role was attached. After attaching the IAM Role, AWS CLI operations started working correctly.

---

# Issue 2: EC2 Instance Not Reachable

## Symptoms

- SSH connection fails.
- Website is inaccessible.
- Ping requests fail.

---

## Diagnosis

Check:

- EC2 instance state.
- Security Group rules.
- Public IP address.
- Internet Gateway.
- Route Table.

Verify connectivity.

```bash
ping google.com
```

---

## Resolution

- Start the instance if stopped.
- Allow SSH (22) in the Security Group.
- Allow HTTP (80) if hosting a website.
- Verify subnet routing.

---

## Verification

```bash
curl http://localhost
```

The Apache default page or your application should be displayed.

---

# Issue 3: Apache Service Not Running

## Symptoms

```text
ERR_CONNECTION_REFUSED
```

or

```text
Connection timed out
```

---

## Diagnosis

```bash
sudo systemctl status httpd
```

View logs.

```bash
sudo journalctl -u httpd
```

---

## Resolution

Start the service.

```bash
sudo systemctl start httpd
```

Enable it on boot.

```bash
sudo systemctl enable httpd
```

---

## Verification

```bash
sudo systemctl status httpd
```

Expected:

```text
Active: active (running)
```

---

# Issue 4: Amazon EBS Volume Not Mounted

## Symptoms

- Expected mount point is missing.
- Data directory unavailable.

---

## Diagnosis

Check attached block devices.

```bash
lsblk
```

Check mounted file systems.

```bash
df -h
```

---

## Resolution

Create a mount point if necessary.

```bash
sudo mkdir -p /data
```

Mount the volume.

```bash
sudo mount /dev/nvme1n1 /data
```

If the volume is new, format it first.

```bash
sudo mkfs.xfs /dev/nvme1n1
```

---

## Verification

```bash
df -h
```

Confirm that the EBS volume is mounted at the expected location.

---

# Issue 5: Amazon EFS Mount Failed

## Symptoms

```text
mount.nfs4: Connection timed out
```

or

```text
mount: wrong fs type
```

---

## Diagnosis

Verify EFS mount targets.

Check the security group:

- NFS (TCP 2049) must be allowed.

Verify DNS resolution.

```bash
nslookup <efs-dns-name>
```

Check mounts.

```bash
mount | grep efs
```

---

## Resolution

Install the EFS utilities if not already installed.

```bash
sudo yum install amazon-efs-utils -y
```

Mount the file system.

```bash
sudo mount -t efs fs-xxxxxxxx:/ /mnt/efs
```

---

## Verification

```bash
df -h
```

Expected:

```text
127.0.0.1:/  /mnt/efs
```

---

## Real Issue Encountered

During this project, the EFS mount initially failed because the required utilities and mount configuration were incomplete.

After:

- Installing `amazon-efs-utils`
- Verifying the security group allowed TCP port 2049
- Using the correct mount command

the file system mounted successfully and remained available after reboot.

---

# Infrastructure Troubleshooting Summary

| Issue | Resolution |
|--------|------------|
| IAM Role Missing | Attach the correct IAM Role |
| EC2 Unreachable | Verify networking and Security Groups |
| Apache Stopped | Start and enable the service |
| EBS Not Mounted | Format (if needed) and mount the volume |
| EFS Mount Failed | Install EFS utilities and verify NFS access |

---

# Best Practices

- Always verify IAM Roles before testing AWS CLI commands.
- Check service status before reviewing application logs.
- Use `lsblk` and `df -h` after attaching storage.
- Allow only the required ports in Security Groups.
- Test EFS mounts after every reboot.
- Document all troubleshooting steps for future reference.

---

# Part 2 Summary

In this section, you learned how to diagnose and resolve issues related to:

- ✔ IAM Roles
- ✔ EC2 connectivity
- ✔ Apache Web Server
- ✔ Amazon EBS
- ✔ Amazon EFS

In **Part 3**, we will troubleshoot:

- CloudWatch Agent
- CloudWatch Metrics
- CloudWatch Dashboards
- CloudWatch Alarms
- Amazon SNS Notifications

---

# Part 3: CloudWatch, CloudWatch Agent, Alarms, and Amazon SNS Troubleshooting

This section covers common issues related to monitoring, alerting, and notifications.

The following components are included:

- CloudWatch Agent
- CloudWatch Metrics
- CloudWatch Dashboard
- CloudWatch Alarms
- Amazon SNS Notifications

Each issue includes:

- Symptoms
- Possible Causes
- Diagnosis
- Resolution
- Verification
- Real-Time Production Scenario

---

# Issue 6: CloudWatch Agent Not Running

## Symptoms

- No Memory metrics
- No Disk metrics
- No custom metrics
- CloudWatch Dashboard shows missing data

---

## Diagnosis

Check the CloudWatch Agent service.

```bash
sudo systemctl status amazon-cloudwatch-agent
```

View agent logs.

```bash
sudo tail -50 \
/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

---

## Resolution

Restart the service.

```bash
sudo systemctl restart amazon-cloudwatch-agent
```

Enable automatic startup.

```bash
sudo systemctl enable amazon-cloudwatch-agent
```

---

## Verification

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Expected:

```text
Active: active (running)
```

After a few minutes, verify that metrics appear in CloudWatch.

---

## Real-Time Production Scenario

A monitoring dashboard suddenly stops displaying Memory Utilization.

Investigation reveals that the CloudWatch Agent service stopped after an unexpected reboot.

Restarting the service restores metric collection.

---

# Issue 7: CloudWatch Metrics Not Appearing

## Symptoms

- Dashboard widgets display "No data"
- CloudWatch Metrics page is empty
- Memory metrics unavailable

---

## Diagnosis

Verify IAM Role.

```bash
aws sts get-caller-identity
```

Check the CloudWatch Agent configuration.

```bash
cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

Review agent logs.

---

## Resolution

- Confirm the IAM Role includes CloudWatch permissions.
- Correct the agent configuration if necessary.
- Restart the CloudWatch Agent.

---

## Verification

Navigate to:

```text
CloudWatch
→ Metrics
→ CWAgent
```

Verify that new metrics are visible.

---

# Issue 8: CloudWatch Alarm Never Triggers

## Symptoms

- CPU usage increases.
- Alarm state remains **OK**.
- No notifications received.

---

## Diagnosis

Check the alarm configuration:

- Metric name
- Namespace
- Threshold
- Evaluation periods

Generate CPU load.

```bash
yes > /dev/null &
yes > /dev/null &
```

---

## Resolution

Verify:

- Correct metric selected
- Correct threshold configured
- Evaluation period is appropriate
- Alarm actions are enabled

Stop the CPU load after testing.

```bash
pkill yes
```

---

## Verification

Alarm transitions:

```text
OK
```

↓

```text
ALARM
```

↓

```text
OK
```

---

## Real-Time Production Scenario

A CPU threshold was configured as **95%**, but production servers typically peaked at **75%**.

Lowering the threshold to **70%** allowed the alarm to trigger correctly during high load.

---

# Issue 9: Amazon SNS Email Not Received

## Symptoms

- CloudWatch Alarm enters **ALARM** state.
- No email notification arrives.

---

## Diagnosis

Verify the SNS subscription.

Navigate to:

```text
Amazon SNS
→ Topics
→ Subscriptions
```

Check the subscription status.

---

## Resolution

If the status is **Pending Confirmation**:

1. Open the confirmation email.
2. Click the confirmation link.

Also verify:

- Spam/Junk folders
- Correct email address
- Alarm notification action

---

## Verification

Trigger the alarm again.

Expected:

```text
Email Received
```

---

## Real-Time Production Scenario

The operations team never confirmed the SNS subscription email.

Although alarms were triggering successfully, notifications were never delivered until the subscription was confirmed.

---

# Issue 10: CloudWatch Dashboard Shows "No Data"

## Symptoms

Dashboard widgets display:

```text
No data available
```

---

## Diagnosis

Verify:

- Widget configuration
- Metric namespace
- Selected Region
- Time range
- Instance ID

---

## Resolution

- Select the correct Region.
- Verify dashboard widgets.
- Ensure CloudWatch Agent is publishing metrics.
- Increase the dashboard time range if needed.

---

## Verification

Dashboard displays:

- CPU
- Memory
- Disk
- Network

without errors.

---

# Monitoring Troubleshooting Summary

| Issue | Resolution |
|--------|------------|
| CloudWatch Agent Stopped | Restart the service |
| Metrics Missing | Verify IAM Role and Agent configuration |
| Alarm Not Triggering | Check thresholds and evaluation periods |
| SNS Email Missing | Confirm subscription and alarm actions |
| Dashboard No Data | Verify widgets, Region, and metrics |

---

# Useful Commands

Check CloudWatch Agent status.

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Restart the CloudWatch Agent.

```bash
sudo systemctl restart amazon-cloudwatch-agent
```

Check agent logs.

```bash
sudo tail -50 \
/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

Generate CPU load.

```bash
yes > /dev/null &
```

Stop CPU load.

```bash
pkill yes
```

Verify AWS identity.

```bash
aws sts get-caller-identity
```

---

# Best Practices

- Restart the CloudWatch Agent after configuration changes.
- Confirm IAM permissions before troubleshooting metrics.
- Test CloudWatch Alarms regularly.
- Confirm SNS subscriptions immediately after creation.
- Monitor CloudWatch Agent logs for configuration errors.
- Validate dashboards after adding new widgets.

---

# Part 3 Summary

In this section, you learned how to troubleshoot:

- ✔ CloudWatch Agent
- ✔ CloudWatch Metrics
- ✔ CloudWatch Dashboard
- ✔ CloudWatch Alarms
- ✔ Amazon SNS Notifications

In **Part 4**, we will troubleshoot:

- Amazon S3 Backup
- Cron Jobs
- Golden AMI
- Linux system issues
- Backup restoration failures

---

# Part 4: Amazon S3 Backup, Cron, AMI, and Linux Troubleshooting

This section covers issues related to:

- Amazon S3 Backup
- Cron Jobs
- Amazon Machine Images (AMI)
- Linux System Administration

Each issue includes:

- Symptoms
- Possible Causes
- Diagnosis
- Resolution
- Verification
- Real-Time Production Scenario

---

# Issue 11: S3 Backup Upload Failed

## Symptoms

The backup script displays:

```text
upload failed
```

or

```text
AccessDenied
```

---

## Diagnosis

Verify AWS identity.

```bash
aws sts get-caller-identity
```

Verify bucket access.

```bash
aws s3 ls s3://aws-project1-log-backup/
```

Review the backup log.

```bash
cat /opt/server-backups/backup.log
```

---

## Resolution

- Verify the IAM Role has S3 permissions.
- Confirm the bucket name is correct.
- Ensure the bucket exists in the correct AWS Region.
- Verify network connectivity.

---

## Verification

Run the backup script again.

```bash
./backup-logs.sh
```

Verify upload.

```bash
aws s3 ls s3://aws-project1-log-backup/
```

---

## Real-Time Production Scenario

A server backup suddenly failed after an IAM policy update.

Investigation revealed that the `s3:PutObject` permission had been removed from the IAM Role.

After restoring the required permission, backups resumed successfully.

---

# Issue 12: Cron Job Not Executing

## Symptoms

- No scheduled backups.
- No new files uploaded to Amazon S3.
- Backup log is not updated.

---

## Diagnosis

Display configured cron jobs.

```bash
crontab -l
```

Check the system cron service.

```bash
sudo systemctl status crond
```

Verify script permissions.

```bash
ls -l backup-logs.sh
```

---

## Resolution

Ensure the script is executable.

```bash
chmod +x backup-logs.sh
```

Start the cron service if required.

```bash
sudo systemctl start crond
```

Enable it at boot.

```bash
sudo systemctl enable crond
```

Use the full script path in the cron entry.

---

## Verification

Wait for the scheduled time or temporarily schedule the job to run every minute for testing.

```cron
* * * * * /home/ec2-user/AWS-Project-1-Server-Monitoring-System/scripts/backup-logs.sh
```

After verification, restore the intended schedule.

---

# Issue 13: Unable to Launch EC2 from AMI

## Symptoms

- Instance launch fails.
- AMI not available.
- Boot process fails.

---

## Diagnosis

Verify:

- AMI status
- Selected Region
- Snapshot availability
- EC2 service quotas

---

## Resolution

- Ensure the AMI is in the correct AWS Region.
- Confirm that the associated snapshots still exist.
- Verify the selected instance type is compatible.
- Check account quotas if capacity errors occur.

---

## Verification

Launch a new EC2 instance from the Golden AMI and verify:

- Instance reaches **Running**
- Status checks pass
- Apache starts successfully

---

## Real-Time Production Scenario

An operations team attempted to launch a recovery server using an AMI from a different AWS Region.

After copying the AMI to the correct Region, the recovery instance launched successfully.

---

# Issue 14: Disk Space Full

## Symptoms

```text
No space left on device
```

Applications may stop writing logs or backups.

---

## Diagnosis

Check disk usage.

```bash
df -h
```

Identify large directories.

```bash
du -sh /var/log/*
```

---

## Resolution

Remove unnecessary temporary files.

```bash
sudo rm -rf /tmp/*
```

Rotate or archive old log files.

```bash
sudo journalctl --vacuum-time=7d
```

Delete obsolete backup archives if they are no longer required.

---

## Verification

Run:

```bash
df -h
```

Ensure sufficient free space is available.

---

# Issue 15: Backup Restore Failed

## Symptoms

Archive extraction fails.

Example:

```text
gzip: unexpected end of file
```

---

## Diagnosis

Verify the downloaded file size.

```bash
ls -lh
```

Check archive integrity.

```bash
tar -tzf server-logs.tar.gz
```

---

## Resolution

Download the backup again.

```bash
aws s3 cp \
s3://aws-project1-log-backup/server-logs.tar.gz \
.
```

Extract it.

```bash
tar -xzf server-logs.tar.gz
```

---

## Verification

Verify that the restored directory structure contains the expected log files.

---

# Backup and Recovery Troubleshooting Summary

| Issue | Resolution |
|--------|------------|
| S3 Upload Failed | Verify IAM Role, bucket, and connectivity |
| Cron Job Failed | Check cron service, schedule, and script permissions |
| AMI Launch Failed | Verify Region, snapshots, and instance type |
| Disk Full | Remove unnecessary files and manage logs |
| Restore Failed | Verify archive integrity and download again |

---

# Useful Linux Commands

Display disk usage.

```bash
df -h
```

Display block devices.

```bash
lsblk
```

Display mounted file systems.

```bash
mount
```

Check cron jobs.

```bash
crontab -l
```

Restart cron service.

```bash
sudo systemctl restart crond
```

Check backup log.

```bash
cat /opt/server-backups/backup.log
```

Check system logs.

```bash
sudo journalctl -xe
```

---

# Best Practices

- Test backups regularly by performing restore operations.
- Use absolute paths in cron jobs.
- Keep AMIs updated after major configuration changes.
- Monitor disk usage proactively.
- Review backup logs after every scheduled execution.
- Document all recovery procedures.

---

# Part 4 Summary

In this section, you learned how to troubleshoot:

- ✔ Amazon S3 Backup failures
- ✔ Cron scheduling issues
- ✔ Golden AMI launch problems
- ✔ Linux disk space issues
- ✔ Backup restoration failures

In **Part 5**, we will complete the guide with:

- Production troubleshooting checklist
- Incident response workflow
- Preventive maintenance
- AWS CLI quick reference
- Lessons learned
- Project conclusion

---

# Part 5: Incident Response, Preventive Maintenance, and Conclusion

This final section summarizes the troubleshooting process and provides operational best practices for maintaining the AWS Project 1 – Server Monitoring & Log Backup System.

---

# Incident Response Workflow

The following workflow should be followed whenever an incident occurs.

```text
Alert Received
      │
      ▼
Identify Affected Service
      │
      ▼
Check CloudWatch Metrics
      │
      ▼
Review System Logs
      │
      ▼
Identify Root Cause
      │
      ▼
Apply Corrective Action
      │
      ▼
Verify Service Recovery
      │
      ▼
Document Resolution
      │
      ▼
Close Incident
```

---

# Production Troubleshooting Checklist

Before escalating an issue, verify the following items.

| Component | Verification |
|-----------|--------------|
| EC2 Instance | Running and status checks passed |
| IAM Role | Correct role attached |
| Security Groups | Required ports open |
| Apache Service | Running |
| EBS Volume | Mounted successfully |
| Amazon EFS | Mounted and accessible |
| CloudWatch Agent | Running |
| CloudWatch Metrics | Updating |
| CloudWatch Alarms | Correct threshold and state |
| Amazon SNS | Subscription confirmed |
| Amazon S3 | Bucket accessible and backups present |
| Cron | Job configured and executing |
| Golden AMI | Available and launchable |

---

# Preventive Maintenance Checklist

Perform these tasks regularly to reduce operational issues.

## Daily

- Verify EC2 instance health.
- Check Apache service status.
- Review CloudWatch alarms.
- Confirm scheduled backups completed successfully.

## Weekly

- Test CloudWatch notifications.
- Verify Amazon EFS connectivity.
- Review disk utilization.
- Check backup logs for failures.

## Monthly

- Launch a test instance from the Golden AMI.
- Restore a backup from Amazon S3.
- Review IAM permissions.
- Update documentation if changes were made.

---

# AWS CLI Quick Reference

## Verify Identity

```bash
aws sts get-caller-identity
```

## List S3 Buckets

```bash
aws s3 ls
```

## List Backup Files

```bash
aws s3 ls s3://aws-project1-log-backup/
```

## Upload a File

```bash
aws s3 cp test.txt s3://aws-project1-log-backup/
```

## Download a Backup

```bash
aws s3 cp s3://aws-project1-log-backup/server-logs-2026-06-30_12-00-00.tar.gz .
```

## View CloudWatch Agent Status

```bash
sudo systemctl status amazon-cloudwatch-agent
```

## Restart CloudWatch Agent

```bash
sudo systemctl restart amazon-cloudwatch-agent
```

## View Apache Status

```bash
sudo systemctl status httpd
```

## Restart Apache

```bash
sudo systemctl restart httpd
```

## Check Mounted File Systems

```bash
df -h
```

## View Block Devices

```bash
lsblk
```

## Display Mounted File Systems

```bash
mount
```

## View Cron Jobs

```bash
crontab -l
```

---

# Linux Log Locations

| Log File | Purpose |
|----------|---------|
| `/var/log/messages` | General system messages |
| `/var/log/secure` | Authentication and security events |
| `/var/log/httpd/access_log` | Apache access log |
| `/var/log/httpd/error_log` | Apache error log |
| `/opt/server-backups/backup.log` | Backup script activity |
| `/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log` | CloudWatch Agent log |

---

# Lessons Learned

During this project, the following operational practices proved valuable:

- Always verify IAM permissions before troubleshooting AWS services.
- Use CloudWatch metrics as the first source of monitoring information.
- Review service logs before making configuration changes.
- Test backups by restoring them periodically.
- Automate recurring tasks using Cron.
- Maintain updated Golden AMIs for faster recovery.
- Document every issue and its resolution.

---

# Project Benefits

This project demonstrates practical experience in:

- Infrastructure deployment
- Linux administration
- Monitoring and alerting
- Backup automation
- Disaster recovery
- Operational troubleshooting
- AWS best practices
- Incident response

---

# Final Troubleshooting Summary

| Area | Status |
|------|--------|
| IAM | ✅ Verified |
| EC2 | ✅ Verified |
| Apache | ✅ Verified |
| Amazon EBS | ✅ Verified |
| Amazon EFS | ✅ Verified |
| CloudWatch | ✅ Verified |
| CloudWatch Alarms | ✅ Verified |
| Amazon SNS | ✅ Verified |
| Amazon S3 Backup | ✅ Verified |
| Cron Jobs | ✅ Verified |
| Golden AMI | ✅ Verified |

---

# Conclusion

This troubleshooting guide provides a practical reference for diagnosing and resolving common issues encountered while deploying and operating the **AWS Project 1 – Server Monitoring & Log Backup System**.

By following the diagnostic workflows, verification steps, and best practices documented here, administrators can reduce downtime, improve operational reliability, and maintain a stable production environment.

The combination of monitoring, automation, backups, and documented recovery procedures demonstrates a structured approach to managing cloud infrastructure using AWS services.

---

# Screenshot Checklist

```text
01-overview.png
02-diagnostic-workflow.png
03-error-message.png
04-log-analysis.png
05-iam-role-missing.png
06-apache-status.png
07-ebs-mount-error.png
08-efs-mount-error.png
09-efs-mounted-success.png
10-cloudwatch-agent-error.png
11-cloudwatch-metrics-missing.png
12-cloudwatch-alarm.png
13-sns-subscription.png
14-dashboard-no-data.png
15-s3-upload-error.png
16-cron-job.png
17-ami-launch.png
18-disk-space.png
19-backup-restore.png
```

---

# Next Document

## 17-Project-Summary.md

The final document will include:

- Project overview
- Architecture summary
- AWS services used
- End-to-end workflow
- Skills gained
- Repository structure
- Key achievements
- Resume-ready project description
- Interview talking points
- Future enhancements
- Final conclusion
