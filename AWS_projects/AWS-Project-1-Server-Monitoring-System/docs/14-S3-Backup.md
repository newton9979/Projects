# Amazon S3 Log Backup

## Objective

In this section, we will build an automated log backup solution using Amazon S3.

The solution will periodically collect server logs, compress them, and upload them to an Amazon S3 bucket for secure storage.

By the end of this guide, you will learn how to:

- Understand log backups
- Configure an S3 bucket for backups
- Create an automated backup script
- Upload log files to Amazon S3
- Automate backups using Cron
- Restore backup files when required
- Apply production best practices

---

# Prerequisites

Before proceeding, ensure the following components have already been configured.

- AWS Account
- EC2 Instance Running
- IAM Role Attached
- Amazon S3 Bucket Created
- Apache Installed
- CloudWatch Agent Running
- Amazon SNS Configured
- AWS CLI Installed

---

# Why Do We Need Log Backups?

Server logs contain valuable information about:

- User requests
- Application errors
- Security events
- Performance issues
- System failures

If an EC2 instance fails, these logs may be lost unless they are backed up.

Amazon S3 provides durable, scalable, and cost-effective storage for log retention.

---

# What Will We Back Up?

For this project, we will back up:

- Apache Access Logs
- Apache Error Logs
- Custom Application Logs (if available)

Example log locations:

```text
/var/log/httpd/access_log
/var/log/httpd/error_log
```

---

# Project Workflow

```text
Apache Server
       │
       ▼
Log Files Generated
       │
       ▼
backup-logs.sh
       │
       ▼
Compress Logs (.tar.gz)
       │
       ▼
AWS CLI
       │
       ▼
Amazon S3 Bucket
       │
       ▼
Long-Term Storage
```

---

# Architecture Diagram

<p align="center">
  <img src="../architecture/aws-project-1-architecture.png"
       alt="S3 Backup Architecture"
       width="900">
</p>

---

# Real-Time Production Scenarios

## Scenario 1: Server Failure

A production EC2 instance unexpectedly crashes.

Although the server is lost, all Apache logs are already backed up to Amazon S3.

The operations team downloads the logs and investigates the root cause.

---

## Scenario 2: Security Investigation

The security team detects suspicious login attempts.

Instead of relying on logs stored on the server, investigators retrieve archived log files from Amazon S3.

This allows them to analyze events even after log rotation or server replacement.

---

## Scenario 3: Compliance Requirements

Many organizations must retain logs for several months or years.

Amazon S3 provides durable storage and lifecycle policies to help meet compliance requirements.

---

## Scenario 4: Disaster Recovery

A new EC2 instance is launched from the Golden AMI.

The application is restored quickly.

Historical logs are downloaded from Amazon S3 whenever required.

---

# Benefits

Using Amazon S3 for log backups provides:

- Highly durable storage
- Low storage cost
- Automatic scalability
- Easy retrieval
- Integration with AWS services
- Long-term log retention
- Improved disaster recovery

---

# Screenshots

## Amazon S3 Bucket

<p align="center">
  <img src="../screenshots/S3/01-backup-bucket.png"
       alt="Amazon S3 Backup Bucket"
       width="900">
</p>

---

## Log Files on EC2

<p align="center">
  <img src="../screenshots/S3/02-log-files.png"
       alt="Apache Log Files"
       width="900">
</p>

---

# Part 1 Summary

In this section, you learned:

- ✔ Why log backups are important
- ✔ What files will be backed up
- ✔ The backup workflow
- ✔ Production use cases
- ✔ Benefits of storing logs in Amazon S3

In **Part 2**, we will configure the backup bucket, verify IAM permissions, prepare the log directory, and test access to Amazon S3.

---

# Part 2: Configure Amazon S3 for Log Backups

In this section, we will prepare our EC2 instance for automated log backups.

By the end of this section, we will have:

- Verified IAM permissions
- Confirmed AWS CLI access
- Verified the S3 backup bucket
- Created a local backup directory
- Tested uploading a sample file to Amazon S3

---

# Step 1: Verify the IAM Role

Our backup script will upload files to Amazon S3.

Instead of storing AWS Access Keys on the server, we will use an **IAM Role** attached to the EC2 instance.

The IAM Role should have permissions similar to:

- ListBucket
- GetObject
- PutObject

Example IAM Policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::your-backup-bucket",
                "arn:aws:s3:::your-backup-bucket/*"
            ]
        }
    ]
}
```

> **Production Tip**
>
> Follow the Principle of Least Privilege by granting only the permissions required for log backups.

<p align="center">
  <img src="../screenshots/S3/03-iam-role.png"
       alt="IAM Role with S3 Permissions"
       width="900">
</p>

---

# Step 2: Verify AWS CLI Access

Confirm that the AWS CLI is installed.

```bash
aws --version
```

Example Output

```text
aws-cli/2.x.x
```

Next, verify that the EC2 instance can access AWS services using its IAM Role.

```bash
aws sts get-caller-identity
```

Example Output

```json
{
  "UserId": "...",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/EC2-S3-Backup-Role/i-xxxxxxxx"
}
```

This confirms that the instance is authenticated without storing access keys.

---

# Step 3: Verify the S3 Backup Bucket

List available buckets.

```bash
aws s3 ls
```

Example Output

```text
2026-06-29  aws-project1-log-backup
```

Verify the backup bucket exists.

```bash
aws s3 ls s3://aws-project1-log-backup
```

Initially, the bucket may be empty.

<p align="center">
  <img src="../screenshots/S3/04-s3-bucket.png"
       alt="Amazon S3 Backup Bucket"
       width="900">
</p>

---

# Step 4: Create a Local Backup Directory

Create a directory to temporarily store compressed backups before uploading them to Amazon S3.

```bash
sudo mkdir -p /opt/server-backups
```

Set appropriate permissions.

```bash
sudo chmod 755 /opt/server-backups
```

Verify the directory.

```bash
ls -ld /opt/server-backups
```

Example Output

```text
drwxr-xr-x
```

---

# Step 5: Verify Apache Log Files

Confirm that Apache log files are available.

```bash
ls -lh /var/log/httpd/
```

Example Output

```text
access_log
error_log
```

These files will be included in our automated backups.

<p align="center">
  <img src="../screenshots/S3/05-apache-logs.png"
       alt="Apache Log Files"
       width="900">
</p>

---

# Step 6: Test Upload to Amazon S3

Create a sample test file.

```bash
echo "S3 Backup Test" > test-backup.txt
```

Upload it to the backup bucket.

```bash
aws s3 cp test-backup.txt s3://aws-project1-log-backup/
```

Expected Output

```text
upload: ./test-backup.txt to s3://aws-project1-log-backup/test-backup.txt
```

Verify the upload.

```bash
aws s3 ls s3://aws-project1-log-backup
```

You should see:

```text
test-backup.txt
```

<p align="center">
  <img src="../screenshots/S3/06-upload-test-file.png"
       alt="Upload Test File to Amazon S3"
       width="900">
</p>

---

# Project Directory Preparation

Our backup workflow will use the following structure.

```text
/opt/server-backups/
├── server-logs-2026-06-30_09-00-00.tar.gz
├── server-logs-2026-06-30_15-00-00.tar.gz
└── backup.log
```

The backup script created in the next section will automatically generate timestamped archives in this directory before uploading them to Amazon S3.

---

# Real-Time Production Scenario

A company stores daily Apache and system logs in an Amazon S3 bucket.

Every backup server authenticates using an IAM Role attached to the EC2 instance.

Because no access keys are stored on the server, the risk of credential exposure is minimized.

The uploaded log archives are retained in Amazon S3 for future troubleshooting, auditing, and disaster recovery.

---

# Best Practices

- Use IAM Roles instead of Access Keys.
- Create a dedicated S3 bucket for backups.
- Organize backups using timestamped filenames.
- Store temporary backup files outside the web root.
- Verify S3 uploads before automating the process.
- Apply bucket versioning and lifecycle rules for long-term storage.

---

# Part 2 Summary

In this section, you have:

- ✔ Verified IAM permissions
- ✔ Confirmed AWS CLI authentication
- ✔ Verified the S3 backup bucket
- ✔ Created a local backup directory
- ✔ Verified Apache log files
- ✔ Successfully uploaded a test file to Amazon S3

In **Part 3**, we will build the **backup-logs.sh** script to automatically collect logs, compress them into a timestamped archive, upload the archive to Amazon S3, and record the backup status in a log file.

---

# Part 3: Create the Automated Log Backup Script

In this section, we will create a Bash script that:

- Collects important log files
- Compresses them into a timestamped archive
- Uploads the archive to Amazon S3
- Records backup activity
- Reports success or failure

This script can later be scheduled using **Cron** for automatic execution.

---

# Backup Workflow

```text
Generate Logs
      │
      ▼
backup-logs.sh
      │
      ▼
Create Timestamp
      │
      ▼
Compress Logs (.tar.gz)
      │
      ▼
Upload to Amazon S3
      │
      ▼
Write Backup Status
      │
      ▼
Delete Local Archive
```

---

# Step 1: Create the Backup Script

Navigate to your project scripts directory.

```bash
cd ~/AWS-Project-1-Server-Monitoring-System/scripts
```

Create the script.

```bash
touch backup-logs.sh
chmod +x backup-logs.sh
```

---

# Step 2: Backup Script

```bash
#!/bin/bash

# ==========================================
# AWS Project 1 - Server Monitoring System
# Automated Log Backup Script
# ==========================================

# Variables
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BUCKET_NAME="aws-project1-log-backup"

BACKUP_DIR="/opt/server-backups"
BACKUP_FILE="server-logs-${DATE}.tar.gz"

LOG_FILE="/opt/server-backups/backup.log"

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

echo "==========================================" >> ${LOG_FILE}
echo "Backup Started : ${DATE}" >> ${LOG_FILE}

# Create compressed archive
tar -czf ${BACKUP_DIR}/${BACKUP_FILE} \
/var/log/httpd \
/var/log/messages \
/var/log/secure

# Verify archive creation
if [ $? -ne 0 ]; then
    echo "Archive creation failed." >> ${LOG_FILE}
    exit 1
fi

echo "Archive Created Successfully." >> ${LOG_FILE}

# Upload to Amazon S3
aws s3 cp \
${BACKUP_DIR}/${BACKUP_FILE} \
s3://${BUCKET_NAME}/

# Verify upload
if [ $? -eq 0 ]; then
    echo "Upload Successful." >> ${LOG_FILE}

    # Remove local archive
    rm -f ${BACKUP_DIR}/${BACKUP_FILE}

    echo "Local backup deleted." >> ${LOG_FILE}

else
    echo "Upload Failed." >> ${LOG_FILE}
    exit 1
fi

echo "Backup Completed : $(date)" >> ${LOG_FILE}
echo "==========================================" >> ${LOG_FILE}
```

Save the file.

---

# Step 3: Understand the Script

The script performs the following operations.

| Step | Description |
|--------|-------------|
| Create timestamp | Generates unique backup filename |
| Create backup directory | Stores temporary backup archive |
| Compress logs | Creates `.tar.gz` archive |
| Upload archive | Sends backup to Amazon S3 |
| Verify upload | Confirms successful transfer |
| Delete local copy | Saves disk space |
| Write backup log | Records backup history |

---

# Step 4: Run the Script

Execute the script manually.

```bash
./backup-logs.sh
```

No output usually indicates successful execution.

---

# Step 5: Verify Upload

List objects in the backup bucket.

```bash
aws s3 ls s3://aws-project1-log-backup/
```

Example Output

```text
2026-06-30 15:45:10
server-logs-2026-06-30_15-45-10.tar.gz
```

<p align="center">
  <img src="../screenshots/S3/07-s3-upload-success.png"
       alt="Backup Uploaded Successfully"
       width="900">
</p>

---

# Step 6: Verify Backup Log

Display the backup log.

```bash
cat /opt/server-backups/backup.log
```

Example Output

```text
==========================================
Backup Started : 2026-06-30_15-45-10

Archive Created Successfully.

Upload Successful.

Local backup deleted.

Backup Completed : Tue Jun 30 15:45:14 UTC 2026

==========================================
```

<p align="center">
  <img src="../screenshots/S3/08-backup-log.png"
       alt="Backup Log File"
       width="900">
</p>

---

# Directory Structure After Execution

```text
/opt/server-backups/
│
├── backup.log
└── (temporary archive removed after upload)
```

Amazon S3

```text
aws-project1-log-backup
│
├── server-logs-2026-06-30_09-00-00.tar.gz
├── server-logs-2026-06-30_15-45-10.tar.gz
└── server-logs-2026-07-01_09-00-00.tar.gz
```

---

# Real-Time Production Scenario

A company operates multiple production web servers.

Every six hours:

- Apache generates access and error logs.
- The backup script compresses the logs.
- The archive is uploaded to Amazon S3.
- The local archive is deleted to conserve disk space.
- A backup log records the operation.

If a server fails, administrators retrieve the archived logs from Amazon S3 for troubleshooting or compliance purposes.

---

# Best Practices

- Use timestamped filenames to prevent overwriting backups.
- Keep backup scripts in a dedicated `scripts/` directory.
- Log every backup attempt.
- Remove temporary files after successful uploads.
- Test backup restoration regularly.
- Restrict S3 access using IAM Roles.

---

# Part 3 Summary

In this section, you have:

- ✔ Created an automated backup script
- ✔ Compressed Apache and system logs
- ✔ Uploaded backups to Amazon S3
- ✔ Logged backup operations
- ✔ Deleted local archives after successful uploads
- ✔ Verified backups in Amazon S3

In **Part 4**, we will automate the script using **Cron**, verify scheduled backups, restore archived logs from Amazon S3, and implement lifecycle policies for long-term log retention.

---

# Part 4: Automate Log Backups Using Cron

So far, we have manually executed the backup script.

In a production environment, backups should run automatically without administrator intervention.

In this section, we will:

- Schedule the backup using Cron
- Verify Cron execution
- Restore backup files from Amazon S3
- Configure Amazon S3 Lifecycle Rules
- Understand production automation

---

# Why Use Cron?

Cron is a Linux scheduling service that automatically executes commands or scripts at predefined intervals.

Common examples include:

- Daily log backups
- Weekly database backups
- Monthly cleanup tasks
- Automated health checks

For this project, Cron will automatically execute our **backup-logs.sh** script.

---

# Step 1: Open the Crontab

Edit the current user's crontab.

```bash
crontab -e
```

If prompted, choose your preferred editor.

---

# Step 2: Schedule the Backup Script

Add the following entry.

```bash
0 */6 * * * /home/ec2-user/AWS-Project-1-Server-Monitoring-System/scripts/backup-logs.sh
```

### Cron Expression Breakdown

| Field | Value | Meaning |
|--------|-------|---------|
| Minute | `0` | At minute 0 |
| Hour | `*/6` | Every 6 hours |
| Day | `*` | Every day |
| Month | `*` | Every month |
| Weekday | `*` | Every day of the week |

This schedule runs at:

```text
00:00
06:00
12:00
18:00
```

Save and exit the editor.

<p align="center">
  <img src="../screenshots/S3/09-crontab.png"
       alt="Configure Cron Job"
       width="900">
</p>

---

# Step 3: Verify the Cron Schedule

Display the configured cron jobs.

```bash
crontab -l
```

Expected Output

```text
0 */6 * * * /home/ec2-user/AWS-Project-1-Server-Monitoring-System/scripts/backup-logs.sh
```

This confirms that the backup schedule is active.

---

# Step 4: Verify Scheduled Backups

After the scheduled execution time, verify that new backup files have been uploaded.

```bash
aws s3 ls s3://aws-project1-log-backup/
```

Example Output

```text
2026-06-30_00-00-00.tar.gz

2026-06-30_06-00-00.tar.gz

2026-06-30_12-00-00.tar.gz
```

<p align="center">
  <img src="../screenshots/S3/10-scheduled-backups.png"
       alt="Scheduled Backups in Amazon S3"
       width="900">
</p>

---

# Step 5: Restore a Backup

Sometimes administrators need to retrieve archived logs for troubleshooting or audits.

Download a backup archive from Amazon S3.

```bash
aws s3 cp \
s3://aws-project1-log-backup/server-logs-2026-06-30_12-00-00.tar.gz \
.
```

Extract the archive.

```bash
tar -xzf server-logs-2026-06-30_12-00-00.tar.gz
```

Verify the restored files.

```bash
ls -R
```

You should see the original log directory structure.

<p align="center">
  <img src="../screenshots/S3/11-restore-backup.png"
       alt="Restore Backup from Amazon S3"
       width="900">
</p>

---

# Step 6: Configure an S3 Lifecycle Rule

Over time, log backups accumulate and consume storage.

Amazon S3 Lifecycle Rules help manage storage automatically.

Navigate to:

```text
Amazon S3
→ Backup Bucket
→ Management
→ Lifecycle Rules
→ Create Lifecycle Rule
```

Example configuration:

| Setting | Value |
|----------|-------|
| Rule Name | LogBackupLifecycle |
| Scope | Entire Bucket |
| Transition | Move to S3 Standard-IA after 30 days |
| Expiration | Delete after 365 days |

This reduces storage costs while meeting retention requirements.

<p align="center">
  <img src="../screenshots/S3/12-lifecycle-rule.png"
       alt="Amazon S3 Lifecycle Rule"
       width="900">
</p>

---

# Backup Workflow After Automation

```text
Apache Logs
      │
      ▼
Cron Scheduler
      │
      ▼
backup-logs.sh
      │
      ▼
Compress Logs
      │
      ▼
Amazon S3
      │
      ▼
Lifecycle Policy
      │
      ▼
Archive / Delete
```

---

# Real-Time Production Scenario

A software company manages multiple production web servers.

Every six hours:

1. Cron automatically executes the backup script.
2. The script compresses Apache and system logs.
3. The archive is uploaded to Amazon S3.
4. Local temporary files are removed.
5. Lifecycle Rules transition older backups to lower-cost storage.
6. Backups older than one year are automatically deleted.

This process provides reliable backups while minimizing operational effort and storage costs.

---

# Best Practices

- Test scheduled jobs after configuration.
- Monitor Cron execution logs regularly.
- Verify backup restoration periodically.
- Use Lifecycle Rules to optimize storage costs.
- Document backup schedules and retention policies.
- Store backup scripts in version control.

---

# Part 4 Summary

In this section, you have:

- ✔ Automated backups using Cron
- ✔ Verified scheduled execution
- ✔ Restored backup files from Amazon S3
- ✔ Configured Lifecycle Rules
- ✔ Learned production backup automation
- ✔ Improved storage cost management

In **Part 5**, we will cover troubleshooting, AWS CLI commands, security recommendations, interview questions, cleanup procedures, and conclude the Amazon S3 Log Backup implementation.

---

# Part 5: Troubleshooting, Best Practices, and Conclusion

This section covers common issues, AWS CLI commands, security recommendations, cost optimization, interview questions, cleanup procedures, and concludes the Amazon S3 Log Backup implementation.

---

# Troubleshooting

The following table lists common issues encountered when backing up logs to Amazon S3.

| Issue | Possible Cause | Solution |
|--------|----------------|----------|
| Upload failed | IAM Role missing S3 permissions | Verify IAM Role and S3 policy |
| AccessDenied | Incorrect bucket permissions | Update IAM policy or Bucket Policy |
| Bucket not found | Incorrect bucket name | Verify bucket name and AWS Region |
| Backup script not running | Incorrect script path or permissions | Check file path and make executable (`chmod +x`) |
| Cron job not executing | Cron service or crontab issue | Verify `crontab -l` and Cron logs |
| No logs in backup | Incorrect log file path | Verify `/var/log/httpd/` exists |
| Archive creation failed | Insufficient disk space | Free up storage before creating the archive |
| AWS CLI command failed | AWS CLI not configured or IAM Role unavailable | Verify `aws sts get-caller-identity` |

---

# Verification Checklist

Before considering the backup solution production-ready, verify the following.

| Component | Status |
|-----------|--------|
| IAM Role Attached | ✅ |
| AWS CLI Working | ✅ |
| S3 Bucket Accessible | ✅ |
| Backup Script Created | ✅ |
| Script Executed Successfully | ✅ |
| Archive Uploaded to S3 | ✅ |
| Backup Log Generated | ✅ |
| Cron Job Configured | ✅ |
| Restore Test Completed | ✅ |
| Lifecycle Rule Enabled | ✅ |

---

# Useful AWS CLI Commands

## List S3 Buckets

```bash
aws s3 ls
```

---

## List Backup Files

```bash
aws s3 ls s3://aws-project1-log-backup/
```

---

## Upload a File

```bash
aws s3 cp backup.tar.gz s3://aws-project1-log-backup/
```

---

## Download a Backup

```bash
aws s3 cp \
s3://aws-project1-log-backup/server-logs-2026-06-30_12-00-00.tar.gz \
.
```

---

## Delete a Backup File

```bash
aws s3 rm \
s3://aws-project1-log-backup/server-logs-2026-06-30_12-00-00.tar.gz
```

---

## Synchronize a Directory

```bash
aws s3 sync /opt/server-backups \
s3://aws-project1-log-backup/
```

---

# Security Best Practices

To keep backup data secure:

- Use IAM Roles instead of Access Keys.
- Grant only the minimum required S3 permissions.
- Enable S3 Server-Side Encryption (SSE).
- Enable Bucket Versioning.
- Block Public Access on the backup bucket.
- Rotate IAM credentials where applicable.
- Monitor S3 activity using AWS CloudTrail.

---

# Cost Optimization

To reduce storage costs:

- Compress log files before uploading.
- Use Amazon S3 Lifecycle Rules.
- Transition older backups to S3 Standard-IA or Glacier.
- Delete obsolete backups after the retention period.
- Monitor bucket usage regularly.

---

# Real-Time Production Scenario

A financial services company stores web server logs in Amazon S3 every six hours.

Their process includes:

1. Cron executes the backup script.
2. Logs are compressed into a timestamped archive.
3. The archive is uploaded to Amazon S3.
4. Lifecycle Rules move backups to lower-cost storage after 30 days.
5. Backups older than one year are deleted automatically.
6. During security audits, archived logs are downloaded from Amazon S3 for analysis.

This approach improves operational efficiency while supporting compliance and disaster recovery.

---

# Interview Questions

## 1. Why use Amazon S3 for log backups?

**Answer:**

Amazon S3 provides highly durable, scalable, and cost-effective object storage, making it ideal for retaining application and system logs.

---

## 2. Why use an IAM Role instead of Access Keys?

**Answer:**

IAM Roles provide temporary credentials automatically, eliminating the need to store long-term AWS access keys on the EC2 instance.

---

## 3. Why compress logs before uploading?

**Answer:**

Compression reduces storage consumption, decreases upload time, and lowers Amazon S3 storage costs.

---

## 4. What is the purpose of a Lifecycle Rule?

**Answer:**

Lifecycle Rules automatically transition or delete objects based on age, helping optimize storage costs and enforce retention policies.

---

## 5. How do you verify a backup?

**Answer:**

Verify that the archive exists in Amazon S3, review the backup log, and perform a restore test to ensure the backup is usable.

---

# Cleanup

If these resources are no longer required, remove them to avoid unnecessary charges.

## Remove Test Files

```bash
rm -f test-backup.txt
```

---

## Delete Backup Objects

```bash
aws s3 rm s3://aws-project1-log-backup/ --recursive
```

---

## Remove Local Backup Directory

```bash
sudo rm -rf /opt/server-backups
```

---

## Remove the Cron Job

Edit the crontab.

```bash
crontab -e
```

Delete the backup entry and save the file.

---

# Conclusion

In this document, we implemented an automated log backup solution using Amazon S3.

We learned how to:

- Prepare Amazon S3 for backups
- Verify IAM permissions
- Create an automated backup script
- Compress log files
- Upload backups to Amazon S3
- Schedule backups using Cron
- Restore archived logs
- Configure Lifecycle Rules
- Apply security and cost optimization best practices

Our **AWS Project 1 – Server Monitoring & Log Backup System** now provides both continuous monitoring and automated log protection.

---

# Screenshot Checklist

| Screenshot | File Name |
|------------|-----------|
| Backup Bucket | `01-backup-bucket.png` |
| Apache Logs | `02-log-files.png` |
| IAM Role | `03-iam-role.png` |
| S3 Bucket | `04-s3-bucket.png` |
| Apache Log Files | `05-apache-logs.png` |
| Test Upload | `06-upload-test-file.png` |
| Upload Success | `07-s3-upload-success.png` |
| Backup Log | `08-backup-log.png` |
| Cron Job | `09-crontab.png` |
| Scheduled Backups | `10-scheduled-backups.png` |
| Restore Backup | `11-restore-backup.png` |
| Lifecycle Rule | `12-lifecycle-rule.png` |

---

# Project Progress

```text
IAM Role
     │
     ▼
EC2 Instance
     │
     ▼
Apache Web Server
     │
     ▼
EBS Storage
     │
     ▼
Amazon EFS
     │
     ▼
CloudWatch Agent
     │
     ▼
CloudWatch Metrics
     │
     ▼
CloudWatch Alarms
     │
     ▼
Amazon SNS Notifications
     │
     ▼
Golden AMI
     │
     ▼
Automated Log Backup to Amazon S3
     │
     ▼
Production-Ready Monitoring & Backup Solution
```

---

# Next Document

## 15-Testing.md

In the next document, we will validate every component of the project through structured testing, including:

- Apache availability testing
- EBS and EFS verification
- CloudWatch metrics validation
- CloudWatch Alarm testing
- SNS notification testing
- AMI launch verification
- S3 backup validation
- End-to-end workflow testing
- Production validation checklist

This document will demonstrate that every component of the project works together as expected, making the project suitable for GitHub, interviews, and real-world portfolio demonstrations.
