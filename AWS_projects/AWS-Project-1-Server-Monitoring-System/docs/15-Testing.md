# Project Testing and Validation

## Objective

The purpose of this document is to validate every component of the **AWS Project 1 – Server Monitoring & Log Backup System**.

Rather than assuming each service works correctly, we will perform structured testing and document the results.

This testing document demonstrates that:

- Infrastructure is deployed correctly
- Monitoring is functioning
- Storage is operational
- Notifications are delivered
- Backups are successful
- Disaster recovery is possible
- The complete solution is production-ready

---

# Testing Scope

The following AWS services and components will be validated.

| Component | Status |
|------------|--------|
| IAM Role | Pending |
| Amazon S3 | Pending |
| CloudTrail | Pending |
| EC2 Instance | Pending |
| Apache Web Server | Pending |
| Sample Web Application | Pending |
| Amazon EBS | Pending |
| Amazon EFS | Pending |
| CloudWatch Metrics | Pending |
| CloudWatch Dashboard | Pending |
| CloudWatch Alarm | Pending |
| Amazon SNS | Pending |
| Amazon Machine Image (AMI) | Pending |
| S3 Log Backup | Pending |

---

# Test Environment

| Item | Value |
|------|-------|
| Cloud Provider | AWS |
| Region | Your AWS Region |
| Operating System | Amazon Linux 2 |
| Web Server | Apache HTTP Server |
| Monitoring | Amazon CloudWatch |
| Storage | Amazon EBS + Amazon EFS |
| Backup | Amazon S3 |
| Notifications | Amazon SNS |
| Disaster Recovery | Amazon AMI |

---

# Testing Strategy

Our testing follows four stages:

## 1. Infrastructure Validation

Verify that all AWS resources are created and configured correctly.

Examples:

- EC2 running
- IAM Role attached
- S3 bucket exists
- EFS mounted

---

## 2. Functional Testing

Confirm that each component performs its intended function.

Examples:

- Website loads successfully
- CloudWatch collects metrics
- Log backups upload to S3
- SNS notifications are delivered

---

## 3. Integration Testing

Ensure AWS services work together as a complete solution.

Example:

```text
High CPU Usage
        │
        ▼
CloudWatch Alarm
        │
        ▼
Amazon SNS
        │
        ▼
Email Notification
```

Another example:

```text
Apache Logs
      │
      ▼
Backup Script
      │
      ▼
Amazon S3
```

---

## 4. Disaster Recovery Testing

Validate that production recovery procedures work.

Tests include:

- Launching a new EC2 instance from the Golden AMI
- Verifying the web application
- Verifying monitoring
- Verifying backup restoration

---

# Test Execution Flow

```text
Deploy Infrastructure
        │
        ▼
Verify Resources
        │
        ▼
Validate Storage
        │
        ▼
Validate Monitoring
        │
        ▼
Validate Notifications
        │
        ▼
Validate Backups
        │
        ▼
Validate Recovery
        │
        ▼
Project Passed
```

---

# Test Evidence

Every major test will include:

- Commands executed
- Expected result
- Actual result
- Pass/Fail status
- Supporting screenshots

This approach provides clear evidence that the implementation is functioning correctly.

---

# Screenshot Organization

All testing screenshots should be stored in:

```text
AWS-Project-1-Server-Monitoring-System/
└── screenshots/
    └── Testing/
```

Suggested file names:

```text
01-ec2-running.png
02-apache-status.png
03-website.png
[O04-ebs-mounted.png
05-efs-mounted.png
06-cloudwatch-dashboard.png
07-cloudwatch-alarm.png
08-sns-email.png
09-s3-backup.png
[I10-ami-launch.png
```

---

# Production Testing Best Practices

- Test one component at a time.
- Record every result.
- Capture screenshots for successful tests.
- Investigate failures before moving forward.
- Repeat tests after configuration changes.
- Maintain a consistent testing process.

---

# Part 1 Summary

In this section, you learned:

- ✔ The purpose of project testing
- ✔ The testing scope
- ✔ The testing strategy
- ✔ The execution flow
- ✔ How evidence will be collected

In **Part 2**, we will validate the infrastructure by testing:

- EC2 Instance
- Apache Web Server
- Website Accessibility
- Amazon EBS
- Amazon EFS

Test ID: TC-001
Component: Apache Web Server

Objective:
Verify that the Apache service is running.

Command:
sudo systemctl status httpd

Expected Result:
Service status is "active (running)".

Actual Result:
Service status is "active (running)".

Status:
✅ PASS

---

# Part 2: Infrastructure Validation

In this section, we will validate the core infrastructure components of the project.

The following components will be tested:

- EC2 Instance
- Apache Web Server
- Web Application
- Amazon EBS
- Amazon EFS

Each test case includes:

- Test Objective
- Commands
- Expected Result
- Actual Result
- Status
[O- Screenshot Evidence

---

# Test Case TC-001

## Verify EC2 Instance Status

### Objective

Verify that the EC2 instance is running and healthy.

### Steps

Navigate to:

```text
AWS Console
→ EC2
→ Instances
```

Verify:

- Instance State = Running
- Status Checks = 2/2 Passed

### Expected Result

The EC2 instance should be in the **Running** state with both status checks passing.

### Actual Result

The EC2 instance is running successfully and all status checks have passed.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/03-ec2-running.png"
width="900">
</p>

---

# Test Case TC-002

## Verify Apache Service

### Objective

Confirm that Apache Web Server is running.

### Command

```bash
sudo systemctl status httpd
```

### Expected Result

```text
Active: active (running)
```

### Actual Result

Apache service is active and accepting requests.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/04-apache-status.png"
width="900">
</p>

---

# Test Case TC-003

## Verify Website Accessibility

### Objective

Ensure that the deployed web application is accessible.

### Steps

Open the EC2 Public IP address.

Example:

```text
http://<EC2-Public-IP>
```

### Expected Result

The sample web application loads successfully.

### Actual Result

The website is displayed correctly in the browser.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/05-website.png"
width="900">
</p>

---

# Test Case TC-004

## Verify Amazon EBS Volume

### Objective

Confirm that the additional EBS volume is attached and mounted.

### Command

```bash
df -h
```

### Expected Result

The mounted EBS volume is displayed with the correct mount point.

Example:

```text
/dev/nvme1n1
```

### Actual Result

The EBS volume is mounted successfully and available for use.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/06-ebs-mounted.png"
width="900">
</p>

---

# Test Case TC-005

## Verify Amazon EFS Mount

### Objective

Verify that the Amazon EFS file system is mounted.

### Command

```bash
mount | grep efs
```

Alternative command:

```bash
df -h
```

### Expected Result

The EFS mount point is displayed.

Example:

```text
127.0.0.1:/ /mnt/efs
```

### Actual Result

The Amazon EFS file system is mounted successfully.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/07-efs-mounted.png"
width="900">
</p>

---

# Infrastructure Validation Summary

| Test ID | Component | Result |
|----------|-----------|--------|
| TC-001 | EC2 Instance | ✅ PASS |
| TC-002 | Apache Service | ✅ PASS |
| TC-003 | Web Application | ✅ PASS |
| TC-004 | Amazon EBS | ✅ PASS |
| TC-005 | Amazon EFS | ✅ PASS |

---

# Real-Time Production Scenario

Before deploying a new application release, the DevOps team performs infrastructure validation to ensure that all critical services are operational.

The validation confirms:

- The EC2 instance is healthy.
- Apache is running.
- The web application is accessible.
- Storage volumes are mounted correctly.
- Shared file storage (Amazon EFS) is available.

Only after these checks pass is the deployment approved for production.

---

# Best Practices

- Verify EC2 health before testing applications.
- Confirm that all required services are running.
- Validate storage mounts after every reboot.
- Record command outputs and screenshots.
- Resolve any failed tests before proceeding to monitoring validation.

---

# Part 2 Summary

In this section, you have successfully validated:

- ✔ EC2 Instance
- ✔ Apache Web Server
- ✔ Web Application
- ✔ Amazon EBS
- ✔ Amazon EFS

In **Part 3**, we will validate:

- Amazon CloudWatch Metrics
- CloudWatch Dashboard
- CloudWatch Alarm
- Amazon SNS Notifications
- Amazon S3 Log Backup

Test ID       : TC-002
Executed By   : Newton N
Execution Date: 2026-06-30
Environment   : AWS Production Lab
Result        : ✅ PASS
Evidence      : 04-apache-status.png

---

# Part 3: Monitoring and Backup Validation

In this section, we will validate the monitoring and backup components of the project.

The following components will be tested:

- Amazon CloudWatch Metrics
- CloudWatch Dashboard
- CloudWatch Alarm
- Amazon SNS Notifications
- Amazon S3 Log Backup

Each test case includes:

- Test Objective
- Test Steps
- Expected Result
- Actual Result
- Status
- Screenshot Evidence

---

# Test Case TC-006

## Verify CloudWatch Metrics

### Objective

Verify that the CloudWatch Agent is publishing EC2 metrics to Amazon CloudWatch.

### Test Steps

1. Log in to the AWS Management Console.
2. Navigate to:

```text
CloudWatch
→ Metrics
→ CWAgent
```

3. Select the EC2 instance.

### Expected Result

The following metrics should be visible:

- CPU Usage
- Memory Usage
- Disk Usage
- Disk I/O
- Network In/Out

### Actual Result

CloudWatch metrics are being collected successfully.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/08-cloudwatch-metrics.png"
width="900">
</p>

---

# Test Case TC-007

## Verify CloudWatch Dashboard

### Objective

Verify that the CloudWatch Dashboard displays live monitoring data.

### Test Steps

Navigate to:

```text
CloudWatch
→ Dashboards
```

Open the dashboard created during this project.

### Expected Result

Dashboard widgets display current metrics without errors.

### Actual Result

Dashboard displays live CPU, Memory, Disk, and Network statistics.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/09-cloudwatch-dashboard.png"
width="900">
</p>

---

# Test Case TC-008

## Verify CloudWatch Alarm

### Objective

Verify that CloudWatch Alarms trigger when CPU utilization exceeds the configured threshold.

### Test Steps

Generate CPU load on the EC2 instance.

Example:

```bash
yes > /dev/null &
yes > /dev/null &
```

Monitor the alarm state in:

```text
CloudWatch
→ Alarms
```

After confirming the alarm has triggered, stop the CPU load so the instance returns to normal.

```bash
pkill yes
```

### Expected Result

Alarm changes from:

```text
OK
```

to

```text
ALARM
```

### Actual Result

Alarm entered the **ALARM** state after CPU utilization exceeded the configured threshold.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/10-cloudwatch-alarm.png"
width="900">
</p>

---

# Test Case TC-009

## Verify Amazon SNS Notification

### Objective

Verify that Amazon SNS sends an email notification when the CloudWatch Alarm is triggered.

### Test Steps

1. Trigger the CloudWatch Alarm.
2. Open the subscribed email inbox.

### Expected Result

An email notification is received containing the alarm details.

### Actual Result

The notification email was received successfully.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/11-sns-email.png"
width="900">
</p>

---

# Test Case TC-010

## Verify Amazon S3 Log Backup

### Objective

Verify that the backup script uploads compressed log files to Amazon S3.

### Test Steps

Run the backup script.

```bash
./backup-logs.sh
```

Verify uploaded objects.

```bash
aws s3 ls s3://aws-project1-log-backup/
```

### Expected Result

A new timestamped archive is present in the S3 bucket.

Example:

```text
server-logs-2026-06-30_18-00-00.tar.gz
```

### Actual Result

Backup archive uploaded successfully.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/12-s3-backup.png"
width="900">
</p>

---

# Monitoring and Backup Validation Summary

| Test ID | Component | Result |
|----------|-----------|--------|
| TC-006 | CloudWatch Metrics | ✅ PASS |
| TC-007 | CloudWatch Dashboard | ✅ PASS |
| TC-008 | CloudWatch Alarm | ✅ PASS |
| TC-009 | Amazon SNS | ✅ PASS |
| TC-010 | Amazon S3 Backup | ✅ PASS |

---

# End-to-End Monitoring Workflow Validation

The following workflow has been successfully validated.

```text
EC2 Instance
      │
      ▼
CloudWatch Agent
      │
      ▼
CloudWatch Metrics
      │
      ▼
CloudWatch Alarm
      │
      ▼
Amazon SNS
      │
      ▼
Email Notification

Apache Logs
      │
      ▼
backup-logs.sh
      │
      ▼
Amazon S3
```

---

# Real-Time Production Scenario

A production web server experiences unusually high CPU utilization.

The CloudWatch Agent reports the increased usage.

CloudWatch detects that the CPU threshold has been exceeded and changes the alarm state to **ALARM**.

Amazon SNS immediately sends an email notification to the operations team.

At the same time, scheduled log backups continue uploading Apache and system logs to Amazon S3, ensuring that diagnostic data is available for troubleshooting and post-incident analysis.

---

# Best Practices

- Test alarm thresholds after configuration.
- Confirm email subscriptions before validating SNS.
- Verify CloudWatch metrics after every agent restart.
- Periodically test backup uploads and restoration.
- Document all monitoring validation results.

---

# Part 3 Summary

In this section, you successfully validated:

- ✔ CloudWatch Metrics
- ✔ CloudWatch Dashboard
- ✔ CloudWatch Alarm
- ✔ Amazon SNS Notifications
- ✔ Amazon S3 Log Backup

In **Part 4**, we will validate the **Golden AMI**, perform disaster recovery testing, launch a replacement EC2 instance, and execute an end-to-end validation of the complete Server Monitoring & Log Backup System.

---

# Part 4: Disaster Recovery and End-to-End Validation

In this section, we will verify that our disaster recovery strategy works correctly by launching a new EC2 instance from the **Golden AMI**.

We will also validate the complete workflow of the **AWS Project 1 – Server Monitoring & Log Backup System**.

---

# Test Case TC-011

## Verify EC2 Launch from Golden AMI

### Objective

Verify that a new EC2 instance can be launched successfully using the Custom Golden AMI.

### Test Steps

1. Open the AWS Management Console.
2. Navigate to:

```text
EC2
→ AMIs
```

3. Select the Custom AMI.
4. Click **Launch Instance from AMI**.
5. Wait until the instance reaches the **Running** state.

### Expected Result

A new EC2 instance launches successfully and passes both status checks.

### Actual Result

The EC2 instance launched successfully and reached the **Running** state.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/13-launch-from-ami.png"
width="900">
</p>

---

# Test Case TC-012

## Verify Application on the New Instance

### Objective

Confirm that the web application is available without reinstalling Apache or redeploying the application.

### Test Steps

1. Open the Public IP of the new EC2 instance.
2. Verify that the application loads successfully.

### Expected Result

The website is accessible immediately after launch.

### Actual Result

The application loaded successfully without additional configuration.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/14-website-after-ami.png"
width="900">
</p>

---

# Test Case TC-013

## Verify CloudWatch Agent

### Objective

Verify that the CloudWatch Agent is running on the new EC2 instance.

### Command

```bash
sudo systemctl status amazon-cloudwatch-agent
```

### Expected Result

```text
Active: active (running)
```

### Actual Result

The CloudWatch Agent started successfully and began publishing metrics.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/15-cloudwatch-after-ami.png"
width="900">
</p>

---

# Test Case TC-014

## Verify Amazon EFS Connectivity

### Objective

Verify that the new EC2 instance reconnects to the existing Amazon EFS file system.

### Command

```bash
df -h
```

or

```bash
mount | grep efs
```

### Expected Result

The EFS mount point is displayed and accessible.

### Actual Result

Amazon EFS mounted successfully after instance launch.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/16-efs-after-ami.png"
width="900">
</p>

---

# Test Case TC-015

## End-to-End Workflow Validation

### Objective

Verify that all major project components work together as an integrated solution.

### Workflow

```text
User Accesses Website
          │
          ▼
Apache Web Server
          │
          ▼
Application Generates Logs
          │
          ▼
CloudWatch Agent Collects Metrics
          │
          ▼
CloudWatch Dashboard Updates
          │
          ▼
CloudWatch Alarm Monitors CPU
          │
          ▼
Amazon SNS Sends Email Alert
          │
          ▼
backup-logs.sh Compresses Logs
          │
          ▼
Amazon S3 Stores Backups
          │
          ▼
Golden AMI Enables Rapid Recovery
```

### Expected Result

All services operate together without errors.

### Actual Result

The complete monitoring, alerting, backup, and recovery workflow functioned successfully.

### Status

✅ PASS

### Screenshot

<p align="center">
<img src="../screenshots/Testing/17-end-to-end-workflow.png"
width="900">
</p>

---

# Disaster Recovery Validation Summary

| Test ID | Component | Result |
|----------|-----------|--------|
| TC-011 | Launch EC2 from AMI | ✅ PASS |
| TC-012 | Web Application | ✅ PASS |
| TC-013 | CloudWatch Agent | ✅ PASS |
| TC-014 | Amazon EFS | ✅ PASS |
| TC-015 | End-to-End Workflow | ✅ PASS |

---

# Recovery Time Objective (RTO)

In this lab environment, disaster recovery demonstrated the following outcomes:

| Activity | Result |
|----------|--------|
| Launch EC2 from AMI | Successful |
| Application Availability | Successful |
| Monitoring Restored | Successful |
| Shared Storage Connected | Successful |
| Backup Process Ready | Successful |

This demonstrates that the project can be restored quickly using the Golden AMI with minimal manual configuration.

---

# Real-Time Production Scenario

A production monitoring server becomes unavailable because of an operating system failure.

The operations team performs the following recovery steps:

1. Launches a new EC2 instance from the approved Golden AMI.
2. Verifies that Apache starts correctly.
3. Confirms the web application is accessible.
4. Ensures the CloudWatch Agent resumes publishing metrics.
5. Verifies Amazon EFS connectivity.
6. Continues scheduled log backups to Amazon S3.

Within a short period, monitoring and backup services are fully restored with minimal downtime.

---

# Best Practices

- Test disaster recovery procedures regularly.
- Validate every new Golden AMI before production use.
- Keep AMIs versioned and documented.
- Verify monitoring after every recovery.
- Perform periodic backup restoration tests.

---

# Part 4 Summary

In this section, you successfully validated:

- ✔ EC2 recovery from the Golden AMI
- ✔ Web application availability
- ✔ CloudWatch Agent functionality
- ✔ Amazon EFS connectivity
- ✔ Complete end-to-end monitoring and backup workflow

In **Part 5**, we will complete the project with:

- Final production readiness checklist
- Overall testing summary
- Common troubleshooting observations
- Interview questions
- Lessons learned
- Project conclusion

---

# Part 5: Production Readiness, Final Validation, and Conclusion

In this final section, we summarize the testing results, confirm production readiness, document lessons learned, and conclude the validation of the **AWS Project 1 – Server Monitoring & Log Backup System**.

---

# Final Test Execution Summary

A total of **15 test cases** were executed during project validation.

| Category | Total Tests | Passed | Failed |
|-----------|------------:|--------:|--------:|
| Infrastructure | 5 | 5 | 0 |
| Monitoring & Alerting | 5 | 5 | 0 |
| Disaster Recovery | 5 | 5 | 0 |
| **Overall** | **15** | **15** | **0** |

---

# Production Readiness Checklist

The following checklist confirms that the project is ready for deployment in a production-like environment.

| Component | Status |
|-----------|--------|
| IAM Role Configured | ✅ |
| Least Privilege Applied | ✅ |
| EC2 Instance Running | ✅ |
| Apache Installed | ✅ |
| Web Application Deployed | ✅ |
| Additional EBS Mounted | ✅ |
| Amazon EFS Connected | ✅ |
| CloudWatch Agent Running | ✅ |
| CloudWatch Dashboard Created | ✅ |
| CloudWatch Alarm Configured | ✅ |
| Amazon SNS Notifications Working | ✅ |
| Golden AMI Created | ✅ |
| Automated S3 Backups Configured | ✅ |
| Cron Job Running | ✅ |
| Disaster Recovery Validated | ✅ |

---

# Project Validation Matrix

| Feature | Validation Result |
|----------|-------------------|
| Infrastructure Deployment | ✅ Successful |
| Storage Configuration | ✅ Successful |
| Monitoring | ✅ Successful |
| Alerting | ✅ Successful |
| Log Backup | ✅ Successful |
| Disaster Recovery | ✅ Successful |
| End-to-End Workflow | ✅ Successful |

---

# Lessons Learned

During this project, the following practical skills were developed:

- Creating and configuring IAM Roles
- Deploying and managing Amazon EC2 instances
- Hosting a web application using Apache
- Managing storage with Amazon EBS and Amazon EFS
- Configuring CloudWatch metrics and dashboards
- Creating CloudWatch Alarms
- Sending notifications using Amazon SNS
- Building a Golden AMI for disaster recovery
- Automating log backups using Amazon S3
- Scheduling recurring tasks using Cron
- Validating cloud infrastructure through structured testing

---

# Skills Demonstrated

This project demonstrates practical experience with:

### Compute

- Amazon EC2
- Amazon Machine Images (AMI)

### Storage

- Amazon EBS
- Amazon EFS
- Amazon S3

### Monitoring

- Amazon CloudWatch
- CloudWatch Agent
- CloudWatch Alarms

### Security

- IAM Roles
- Least Privilege Access

### Notification

- Amazon SNS

### Linux Administration

- Apache HTTP Server
- Bash Scripting
- Cron Scheduling
- Log Management
- System Monitoring

---

# Interview Questions

## 1. Why did you create a Golden AMI?

**Answer**

To create a reusable, fully configured server image that enables rapid deployment and faster disaster recovery.

---

## 2. Why use Amazon EFS instead of only Amazon EBS?

**Answer**

Amazon EFS provides shared network storage that can be accessed by multiple EC2 instances, while Amazon EBS is block storage attached to a single instance.

---

## 3. Why use CloudWatch Alarms?

**Answer**

CloudWatch Alarms monitor resource metrics and automatically notify administrators when thresholds are exceeded.

---

## 4. Why store logs in Amazon S3?

**Answer**

Amazon S3 provides durable, scalable, and cost-effective storage for long-term log retention and disaster recovery.

---

## 5. Why use IAM Roles instead of Access Keys?

**Answer**

IAM Roles provide temporary credentials automatically and eliminate the need to store long-term access keys on EC2 instances.

---

## 6. How does this project improve disaster recovery?

**Answer**

The Golden AMI enables rapid server recreation, Amazon EFS preserves shared files, and Amazon S3 stores historical logs for recovery and analysis.

---

# Overall Project Workflow

```text
                     User Request
                          │
                          ▼
                  Apache Web Server
                          │
                          ▼
                  Web Application
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
 CloudWatch Agent                  Apache Logs
          │                               │
          ▼                               ▼
 CloudWatch Metrics               backup-logs.sh
          │                               │
          ▼                               ▼
 CloudWatch Alarm                 Compress Logs
          │                               │
          ▼                               ▼
     Amazon SNS                    Amazon S3
          │
          ▼
 Email Notification

          EC2 Instance
                │
                ▼
           Golden AMI
                │
                ▼
      Disaster Recovery
```

---

# Repository Structure Validation

The project follows a well-organized directory structure.

```text
AWS-Project-1-Server-Monitoring-System/
│
├── README.md
├── architecture/
├── app/
├── cloudwatch/
├── scripts/
├── docs/
├── screenshots/
└── assets/
```

This structure separates documentation, scripts, application files, architecture diagrams, and screenshots, making the repository easy to maintain and navigate.

---

# Conclusion

This project successfully demonstrates the design and implementation of a production-style **Server Monitoring & Log Backup System** on AWS.

The solution includes:

- Secure access using IAM Roles
- Web hosting with Amazon EC2 and Apache
- Persistent and shared storage using Amazon EBS and Amazon EFS
- Infrastructure monitoring with Amazon CloudWatch
- Automated alerting using Amazon SNS
- Disaster recovery using a Golden AMI
- Automated log backups to Amazon S3
- Scheduled backup execution using Cron
- End-to-end testing and validation

The project provides hands-on experience with core AWS services and reflects common operational practices used in DevOps and Cloud Engineering environments.

---

# Screenshot Checklist

```text
01-test-plan.png
02-testing-overview.png
03-ec2-running.png
04-apache-status.png
05-website.png
06-ebs-mounted.png
07-efs-mounted.png
08-cloudwatch-metrics.png
09-cloudwatch-dashboard.png
10-cloudwatch-alarm.png
11-sns-email.png
12-s3-backup.png
13-launch-from-ami.png
14-website-after-ami.png
15-cloudwatch-after-ami.png
16-efs-after-ami.png
17-end-to-end-workflow.png
```

---

# Next Document

## 16-Troubleshooting.md

The next document will focus on diagnosing and resolving common issues encountered during deployment and operation, including:

- IAM permission issues
- EC2 connectivity problems
- Apache service failures
- EBS and EFS mount errors
- CloudWatch Agent troubleshooting
- CloudWatch Alarm issues
- Amazon SNS notification failures
- Amazon S3 backup failures
- AMI launch issues
- Linux command reference and recovery procedures
