# Architecture

The architecture of the **AWS Project 1 – Server Monitoring & Log Backup System** is designed to demonstrate how multiple AWS services work together to provide a secure, monitored, automated, and recoverable cloud infrastructure.

Rather than focusing on a single AWS service, this project integrates compute, storage, monitoring, notification, backup, and disaster recovery into one complete solution.

The architecture follows AWS best practices wherever applicable while remaining simple enough for learning and portfolio development.

---

# Architecture Objectives

The primary goals of the architecture are:

- Deploy a secure Linux web server.
- Provide persistent storage for application data.
- Configure shared storage for future scalability.
- Continuously monitor server health.
- Generate alerts when resource thresholds are exceeded.
- Automate log backups.
- Prepare for disaster recovery.
- Maintain operational visibility.
- Document every component for future maintenance.

---

# High-Level Architecture Diagram

The complete project architecture is shown below.

<p align="center">
<img src="../architecture/aws-project-1-architecture.png" width="1000">
</p>

---

# High-Level Architecture

```text
                           Internet
                               │
                               ▼
                    Amazon EC2 Instance
                  (Apache Web Server)
                               │
            ┌──────────────────┴──────────────────┐
            ▼                                     ▼
      Amazon EBS                           Amazon EFS
 (Application Storage)              (Shared File Storage)
            │                                     │
            └──────────────────┬──────────────────┘
                               ▼
                    CloudWatch Agent
                               │
          ┌────────────────────┼────────────────────┐
          ▼                    ▼                    ▼
 CloudWatch Metrics     CloudWatch Dashboard   CloudWatch Alarms
                                                       │
                                                       ▼
                                                  Amazon SNS
                                                       │
                                                       ▼
                                              Email Notification

                    Apache & Linux Logs
                               │
                               ▼
                     backup-logs.sh Script
                               │
                               ▼
                           Amazon S3
                      (Log Backup Storage)

                               │
                               ▼
                           Golden AMI
                               │
                               ▼
                      Disaster Recovery
```

---

# Architecture Components

The solution consists of the following major components.

| Layer | AWS Service | Purpose |
|--------|-------------|---------|
| Security | IAM | Secure access using IAM Roles |
| Compute | Amazon EC2 | Linux web server hosting |
| Storage | Amazon EBS | Persistent block storage |
| Shared Storage | Amazon EFS | Shared network file system |
| Monitoring | Amazon CloudWatch | Metrics and dashboards |
| Alerting | CloudWatch Alarms | Threshold-based monitoring |
| Notification | Amazon SNS | Email alerts |
| Backup | Amazon S3 | Log archive storage |
| Auditing | AWS CloudTrail | AWS API activity logging |
| Recovery | Amazon Machine Image (AMI) | Disaster recovery |

---

# Architecture Principles

The architecture was designed using the following principles.

## Security

- IAM Role-based authentication
- No long-term access keys
- Least privilege access
- Security Group-based network control

---

## Reliability

- Persistent storage using Amazon EBS
- Shared storage using Amazon EFS
- Automated monitoring
- Automated notifications
- Backup automation
- Disaster recovery planning

---

## Operational Excellence

- Automated deployment scripts
- Continuous monitoring
- Operational documentation
- Troubleshooting procedures
- Infrastructure validation

---

## Simplicity

The project intentionally focuses on core AWS services without introducing unnecessary complexity, making it easier to understand how each component contributes to the overall solution.

---

# Real-World Business Scenario

Imagine a company hosting an internal employee portal on AWS.

The infrastructure must:

- Host the application reliably.
- Preserve application data.
- Share files across servers.
- Monitor infrastructure health.
- Notify administrators about issues.
- Back up important logs automatically.
- Recover quickly after server failures.

This architecture implements these operational requirements using AWS services and automation.

---

# Architecture Goals

This solution demonstrates how to build an infrastructure that is:

- Secure
- Reliable
- Monitored
- Automated
- Recoverable
- Well documented

---

# Screenshots Used in This Section

Store these screenshots in:

```text
screenshots/
└── Architecture/
    ├── 01-high-level-architecture.png
    ├── 02-architecture-components.png
    ├── 03-business-use-case.png
    └── 04-architecture-overview.png
```

---

# Architecture Component Overview

The architecture consists of the following layers:

```text
Security Layer
        │
        ▼
Compute Layer
        │
        ▼
Storage Layer
        │
        ▼
Monitoring Layer
        │
        ▼
Notification Layer
        │
        ▼
Backup Layer
        │
        ▼
Disaster Recovery Layer
```

Each layer performs a specific function while working together to provide a reliable and maintainable infrastructure.

---

# 1. IAM (Identity and Access Management)

## Purpose

IAM provides secure access to AWS resources by assigning an IAM Role to the EC2 instance.

## Responsibilities

- Authenticate AWS API requests
- Authorize access to AWS services
- Eliminate the need for access keys
- Enforce the principle of least privilege

## Interactions

```text
EC2 Instance
      │
      ▼
IAM Role
      │
      ├── Amazon S3
      ├── CloudWatch
      ├── CloudTrail
      └── Amazon EC2 APIs
```

## Why IAM Roles?

Using IAM Roles improves security by providing temporary credentials and avoiding hardcoded access keys.

---

# 2. Amazon EC2

## Purpose

Amazon EC2 hosts the Linux operating system, Apache Web Server, and the sample web application.

## Responsibilities

- Serve web content
- Execute automation scripts
- Collect monitoring metrics
- Generate system and application logs

## Connected Services

- IAM
- Amazon EBS
- Amazon EFS
- CloudWatch Agent
- Amazon S3
- Amazon SNS
- Amazon Machine Image (AMI)

---

# 3. Amazon EBS

## Purpose

Amazon EBS provides persistent block storage for the EC2 instance.

## Stores

- Operating system
- Apache configuration
- Website files
- Application data

## Characteristics

- Persistent storage
- Attached to one EC2 instance
- Snapshot support
- High durability

## Architecture Position

```text
Amazon EC2
      │
      ▼
Amazon EBS
```

---

# 4. Amazon EFS

## Purpose

Amazon EFS provides a shared network file system.

## Stores

- Shared application files
- Common configuration files
- Shared uploads
- Team-accessible resources

## Benefits

- Shared across multiple EC2 instances
- Automatically scalable
- Managed by AWS
- Highly available

## Architecture Position

```text
Amazon EC2
      │
      ▼
Amazon EFS
```

---

# 5. Amazon S3

## Purpose

Amazon S3 stores compressed Apache and Linux log backups.

## Backup Workflow

```text
Apache Logs
      │
Linux Logs
      │
      ▼
backup-logs.sh
      │
      ▼
Amazon S3 Bucket
```

## Benefits

- Durable object storage
- Cost-effective backup solution
- Easy restoration
- Long-term retention

---

# 6. Amazon CloudWatch

## Purpose

CloudWatch collects infrastructure metrics and provides operational visibility.

## Metrics Collected

- CPU Utilization
- Memory Utilization
- Disk Usage
- Network Traffic

## Dashboard

The dashboard provides a centralized view of server health.

```text
CloudWatch Dashboard

CPU
Memory
Disk
Network
```

---

# 7. CloudWatch Alarms

## Purpose

CloudWatch Alarms monitor metrics and trigger alerts when thresholds are exceeded.

## Example

```text
CPU > 70%
      │
      ▼
Alarm State
      │
      ▼
Amazon SNS
```

---

# 8. Amazon SNS

## Purpose

Amazon SNS sends email notifications whenever CloudWatch Alarms enter the **ALARM** state.

## Notification Flow

```text
CloudWatch Alarm
        │
        ▼
Amazon SNS
        │
        ▼
Email Notification
```

This enables administrators to respond quickly to operational issues.

---

# 9. AWS CloudTrail

## Purpose

CloudTrail records AWS API activity for auditing and governance.

## Captures

- Console logins
- Resource creation
- Resource deletion
- IAM activity
- API requests

CloudTrail helps track administrative actions performed within the AWS account.

---

# 10. Amazon Machine Image (AMI)

## Purpose

The Golden AMI provides a reusable image of the configured EC2 instance.

## Contains

- Operating system
- Apache installation
- Website
- Configuration
- Installed packages

## Recovery Workflow

```text
Golden AMI
      │
      ▼
Launch EC2
      │
      ▼
Recovered Server
```

---

# Service Interaction Summary

| AWS Service | Interacts With | Purpose |
|-------------|----------------|---------|
| IAM | EC2, S3, CloudWatch | Secure access |
| EC2 | EBS, EFS, CloudWatch | Application hosting |
| EBS | EC2 | Persistent storage |
| EFS | EC2 | Shared storage |
| CloudWatch | EC2 | Monitoring |
| CloudWatch Alarms | CloudWatch, SNS | Alerting |
| SNS | CloudWatch Alarms | Notifications |
| S3 | EC2 | Backup storage |
| CloudTrail | AWS Account | Auditing |
| AMI | EC2 | Disaster recovery |

---

# Component Relationship Diagram

```text
                 IAM
                  │
                  ▼
             Amazon EC2
      ┌─────────┼─────────┐
      ▼         ▼         ▼
 Amazon EBS  Amazon EFS CloudWatch Agent
                           │
                           ▼
                    CloudWatch
                           │
                   CloudWatch Alarms
                           │
                           ▼
                      Amazon SNS

Apache Logs
      │
      ▼
backup-logs.sh
      │
      ▼
 Amazon S3

Amazon EC2
      │
      ▼
 Golden AMI
```

---

# Screenshots Used in This Section

Store these screenshots in:

```text
screenshots/
└── Architecture/
    ├── 05-iam-role.png
    ├── 06-ec2-overview.png
    ├── 07-ebs-efs-storage.png
    ├── 08-cloudwatch-monitoring.png
    ├── 09-s3-backup.png
    ├── 10-ami-recovery.png
```

---

# End-to-End Request Flow

The following diagram illustrates how a user request is processed.

```text
                User Browser
                     │
                     ▼
             HTTP Request (Port 80)
                     │
                     ▼
           Amazon EC2 (Apache Server)
                     │
                     ▼
             Apache Web Service
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
   Website Files           Shared Files
      (Amazon EBS)         (Amazon EFS)
                     │
                     ▼
             HTTP Response
                     │
                     ▼
                User Browser
```

---

# Data Storage Flow

The application stores data across different AWS storage services depending on the purpose.

## Amazon EBS

Stores:

- Linux Operating System
- Apache Installation
- Website Files
- Application Configuration
- System Packages

```text
EC2 Instance
      │
      ▼
 Amazon EBS
      │
      ├── Operating System
      ├── Apache
      ├── Website Files
      └── Configuration
```

---

## Amazon EFS

Stores:

- Shared Documents
- Common Application Files
- Team Uploads
- Shared Resources

```text
EC2 Instance
      │
      ▼
 Amazon EFS
      │
      ├── Shared Files
      ├── Uploads
      └── Common Resources
```

---

# Monitoring Flow

CloudWatch continuously collects infrastructure metrics through the CloudWatch Agent.

```text
Linux Server
      │
      ▼
CloudWatch Agent
      │
      ▼
Amazon CloudWatch
      │
      ├── CPU Utilization
      ├── Memory Usage
      ├── Disk Usage
      └── Network Traffic
```

Metrics are collected at regular intervals and displayed on the CloudWatch Dashboard.

---

# Dashboard Flow

```text
EC2 Metrics
      │
      ▼
CloudWatch
      │
      ▼
Dashboard Widgets
      │
      ├── CPU
      ├── Memory
      ├── Disk
      └── Network
```

The dashboard provides administrators with a centralized view of infrastructure health.

---

# Alert Flow

CloudWatch continuously evaluates resource metrics against predefined thresholds.

```text
CloudWatch Metrics
        │
        ▼
CloudWatch Alarm
        │
 CPU > 70%
 Disk > 80%
 Memory > 75%
        │
        ▼
Alarm State
        │
        ▼
Amazon SNS
        │
        ▼
Administrator Email
```

This proactive monitoring enables administrators to respond before resource exhaustion affects users.

---

# Log Collection Flow

Apache and Linux generate operational logs continuously.

```text
Apache Access Log
Apache Error Log
Linux System Log
Application Log
        │
        ▼
Backup Script
        │
        ▼
Compressed Archive
```

These logs provide valuable information for troubleshooting and auditing.

---

# Backup Workflow

The backup script runs on a schedule using Cron.

```text
Cron Job
      │
      ▼
backup-logs.sh
      │
      ▼
Compress Logs
      │
      ▼
Upload to Amazon S3
      │
      ▼
Backup Completed
```

Benefits:

- Automated operation
- Centralized log storage
- Long-term retention
- Easier troubleshooting

---

# Disaster Recovery Workflow

The Golden AMI enables rapid recovery when an EC2 instance becomes unavailable.

```text
Running EC2
      │
      ▼
Create Golden AMI
      │
      ▼
AMI Stored
      │
      ▼
Instance Failure
      │
      ▼
Launch New EC2
      │
      ▼
Application Restored
```

Recovery time is significantly reduced because the new instance already contains the operating system, Apache configuration, website files, and application settings.

---

# Operational Workflow

The following sequence illustrates normal daily operations.

```text
User Access
      │
      ▼
Apache Processes Request
      │
      ▼
Website Response
      │
      ▼
Metrics Generated
      │
      ▼
CloudWatch Collects Metrics
      │
      ▼
Dashboard Updated
      │
      ▼
Threshold Evaluated
      │
      ▼
Alarm Triggered (If Required)
      │
      ▼
SNS Sends Notification
      │
      ▼
Administrator Investigates
```

---

# Architecture Data Flow Summary

| Activity | AWS Service |
|----------|-------------|
| User Request | Amazon EC2 |
| Website Storage | Amazon EBS |
| Shared Storage | Amazon EFS |
| Metrics Collection | CloudWatch Agent |
| Monitoring | Amazon CloudWatch |
| Alert Evaluation | CloudWatch Alarms |
| Notifications | Amazon SNS |
| Log Backup | Amazon S3 |
| Disaster Recovery | Amazon AMI |

---

# Real-World Scenario — Data Flow

Imagine an e-commerce company hosting its web application on AWS.

During a peak sales event:

1. Customers access the website hosted on Amazon EC2.
2. Apache serves the application.
3. Product images are stored on Amazon EBS.
4. Shared reports are available through Amazon EFS.
5. CloudWatch monitors CPU, memory, and disk usage.
6. CPU utilization exceeds the configured threshold.
7. CloudWatch Alarm enters the **ALARM** state.
8. Amazon SNS immediately sends an email notification.
9. The operations team investigates the issue before customers experience downtime.
10. At midnight, logs are compressed and uploaded to Amazon S3.
11. If the server fails, a replacement instance is launched from the Golden AMI.

This workflow demonstrates how monitoring, automation, and disaster recovery improve operational reliability.

---

# Screenshots Used in This Section

Store the screenshots in:

```text
screenshots/
└── Architecture/
    ├── 11-request-flow.png
    ├── 12-monitoring-flow.png
    ├── 13-alert-flow.png
    ├── 14-backup-workflow.png
    ├── 15-disaster-recovery-flow.png
    └── 16-operational-workflow.png
```

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

---

# Production Architecture, Security, Scalability, and Best Practices

This section explains how the current architecture aligns with AWS best practices and how it can be enhanced for production environments.

---

# Current Project Architecture

This project demonstrates a production-inspired architecture using a single Amazon EC2 instance integrated with storage, monitoring, alerting, backup, and disaster recovery services.

```text
                    Internet
                        │
                        ▼
                  Amazon EC2
                        │
      ┌─────────────────┼──────────────────┐
      ▼                 ▼                  ▼
 Amazon EBS        Amazon EFS        CloudWatch Agent
                                             │
                                             ▼
                                      Amazon CloudWatch
                                             │
                        ┌────────────────────┴───────────────────┐
                        ▼                                        ▼
                CloudWatch Dashboard                   CloudWatch Alarm
                                                                │
                                                                ▼
                                                           Amazon SNS
                                                                │
                                                                ▼
                                                        Email Notification

Apache & Linux Logs
        │
        ▼
backup-logs.sh
        │
        ▼
Amazon S3

        │
        ▼
Golden AMI
```

Although designed for learning, this architecture follows many operational principles used in real AWS environments.

---

# Security Architecture

Security is implemented at multiple layers.

## Identity Security

- IAM Roles attached to Amazon EC2
- No hardcoded AWS credentials
- Temporary security credentials
- Least privilege access

---

## Network Security

Security Groups control inbound and outbound traffic.

Example:

```text
Inbound Rules

HTTP (80)
SSH (22)
ICMP (Optional)

Outbound

Allow All
```

Only required ports are opened.

---

## Storage Security

### Amazon EBS

- Persistent block storage
- Supports encryption
- Snapshot capability

### Amazon EFS

- Shared file storage
- Mount target security
- Security Group protection

### Amazon S3

- Private bucket
- IAM-controlled access
- Lifecycle policy support

---

# Monitoring Architecture

Monitoring operates continuously.

```text
Linux Server
      │
      ▼
CloudWatch Agent
      │
      ▼
CloudWatch Metrics
      │
      ▼
Dashboard
      │
      ▼
Alarm Evaluation
      │
      ▼
SNS Notification
```

This allows administrators to identify problems before they affect users.

---

# Backup Architecture

Backup is fully automated.

```text
Cron Job
     │
     ▼
backup-logs.sh
     │
     ▼
Compress Logs
     │
     ▼
Amazon S3
```

Benefits include:

- Reduced manual effort
- Consistent backups
- Long-term log retention
- Faster troubleshooting

---

# Disaster Recovery Strategy

Recovery is based on a Golden AMI.

```text
Configured EC2
       │
       ▼
Create Golden AMI
       │
       ▼
AMI Stored
       │
       ▼
Server Failure
       │
       ▼
Launch Replacement EC2
```

Recovery Benefits:

- Faster server restoration
- Consistent configuration
- Reduced downtime
- Simplified recovery process

---

# Scalability Considerations

The current implementation uses a single EC2 instance, which is suitable for learning and small workloads.

For larger environments, consider:

- Auto Scaling Groups
- Application Load Balancer (ALB)
- Multiple Availability Zones
- Shared Amazon EFS storage
- Elastic IP replacement strategies

---

# High Availability Improvements

A production architecture could include:

```text
                Internet
                    │
                    ▼
        Application Load Balancer
                    │
      ┌─────────────┴─────────────┐
      ▼                           ▼
Amazon EC2 (AZ-1)          Amazon EC2 (AZ-2)
      │                           │
      └─────────────┬─────────────┘
                    ▼
               Amazon EFS
```

Advantages:

- No single point of failure
- Automatic traffic distribution
- Improved application availability
- Better fault tolerance

---

# Cost Optimization

Several AWS cost optimization practices can be applied.

- Stop unused EC2 instances.
- Delete unused EBS volumes.
- Remove obsolete AMIs and snapshots.
- Apply S3 Lifecycle Policies.
- Monitor CloudWatch custom metrics usage.
- Review AWS Cost Explorer regularly.

---

# Operational Best Practices

Follow these operational guidelines:

- Monitor infrastructure continuously.
- Test CloudWatch Alarms regularly.
- Verify Amazon SNS notifications.
- Rotate Golden AMIs after major updates.
- Validate backup restoration.
- Review CloudTrail logs periodically.
- Keep documentation updated.

---

# Architecture Design Decisions

The following design choices were made intentionally.

| Decision | Reason |
|----------|--------|
| IAM Roles | Secure AWS access |
| EC2 | Flexible Linux server |
| Amazon EBS | Persistent storage |
| Amazon EFS | Shared storage |
| CloudWatch | Centralized monitoring |
| SNS | Immediate notifications |
| Amazon S3 | Durable backup storage |
| AMI | Rapid disaster recovery |

---

# Production vs Learning Architecture

| Component | Current Project | Production Environment |
|-----------|-----------------|------------------------|
| EC2 | Single Instance | Auto Scaling Group |
| Load Balancer | Not Used | Application Load Balancer |
| Availability Zones | Single AZ | Multi-AZ |
| Database | Not Included | Amazon RDS |
| Monitoring | CloudWatch | CloudWatch + X-Ray |
| Backup | S3 Script | AWS Backup |
| Infrastructure | Manual | Terraform / CloudFormation |

---

# Real-World Scenario — Production Architecture

A company's internal HR portal experiences increased traffic during payroll processing.

Using this architecture:

1. Employees access the application hosted on Amazon EC2.
2. CloudWatch monitors system resources.
3. CPU utilization rises above the configured threshold.
4. CloudWatch Alarm changes to **ALARM**.
5. Amazon SNS sends an email notification.
6. The operations team investigates the issue.
7. Logs stored in Amazon S3 are reviewed for analysis.
8. If recovery is required, a new server is launched from the Golden AMI.

This demonstrates how monitoring, backup, and disaster recovery work together to maintain service reliability.

---

# Screenshots Used in This Section

Store these screenshots in:

```text
screenshots/
└── Architecture/
    ├── 17-security-architecture.png
    ├── 18-monitoring-architecture.png
    ├── 19-backup-architecture.png
    ├── 20-high-availability.png
    ├── 21-production-vs-learning.png
    └── 22-cost-optimization.png
```

---

# Architecture Advantages, Limitations, Design Decisions, Interview Questions, and Final Summary

This final section summarizes the overall architecture, highlights its strengths and limitations, explains the key design decisions, and provides interview-focused questions to help reinforce the concepts covered throughout this document.

---

# Architecture Advantages

This project demonstrates several real-world AWS operational practices while keeping the infrastructure simple enough for learning and portfolio development.

## Security

- IAM Roles eliminate hardcoded AWS credentials.
- Security Groups restrict unnecessary network access.
- AWS CloudTrail records account activities for auditing.
- Amazon S3 securely stores log backups.

---

## Reliability

- Amazon EBS provides persistent storage.
- Amazon EFS enables shared storage for future scalability.
- Amazon CloudWatch continuously monitors infrastructure health.
- Amazon SNS provides immediate notifications.
- Golden AMI enables rapid disaster recovery.

---

## Automation

The project automates several operational tasks:

- Infrastructure monitoring
- Resource alerting
- Log backup
- Disaster recovery preparation
- Operational visibility

Automation reduces manual effort while improving consistency and reliability.

---

## Operational Visibility

Administrators can monitor the infrastructure using:

- CloudWatch Dashboards
- CloudWatch Metrics
- CloudWatch Alarms
- Amazon SNS Email Notifications
- AWS CloudTrail Logs

---

## Disaster Recovery Readiness

Using a Golden AMI significantly reduces recovery time.

Benefits include:

- Faster server restoration
- Consistent server configuration
- Reduced downtime
- Simplified infrastructure recovery

---

# Architecture Limitations

Since this project is designed for learning purposes, several enterprise-level features are intentionally excluded.

| Current Design | Production Recommendation |
|---------------|---------------------------|
| Single EC2 Instance | Auto Scaling Group |
| Single Availability Zone | Multi-AZ Deployment |
| No Load Balancer | Application Load Balancer |
| Manual Infrastructure | Terraform / CloudFormation |
| Script-Based Backup | AWS Backup |
| No Database Layer | Amazon RDS / DynamoDB |

These enhancements can be implemented in future versions of the project.

---

# Why These AWS Services Were Selected

| AWS Service | Purpose |
|-------------|---------|
| Amazon EC2 | Hosts the Linux web server |
| IAM | Provides secure AWS authentication |
| Amazon EBS | Persistent block storage |
| Amazon EFS | Shared network storage |
| Amazon CloudWatch | Infrastructure monitoring |
| CloudWatch Alarms | Automated threshold monitoring |
| Amazon SNS | Email notifications |
| Amazon S3 | Log backup storage |
| AWS CloudTrail | API auditing |
| Amazon AMI | Disaster recovery |

Each AWS service fulfills a specific operational requirement while integrating seamlessly with the others.

---

# Key Architecture Design Decisions

## IAM Roles Instead of Access Keys

IAM Roles provide temporary credentials, eliminate the need to store access keys on the EC2 instance, and follow AWS security best practices.

---

## Amazon EBS for Application Storage

Amazon EBS stores:

- Operating System
- Installed Software
- Website Files
- Configuration Files
- Application Data

---

## Amazon EFS for Shared Storage

Amazon EFS allows multiple EC2 instances to access the same files simultaneously, making it ideal for scalable environments.

---

## CloudWatch for Monitoring

CloudWatch was selected because it provides:

- Infrastructure Metrics
- Dashboards
- Alarms
- Centralized Monitoring

---

## Amazon SNS for Notifications

Amazon SNS delivers real-time email notifications whenever CloudWatch Alarms enter the **ALARM** state.

---

## Amazon S3 for Log Backup

Amazon S3 provides:

- High Durability
- Cost-Effective Storage
- Long-Term Retention
- Easy Restoration

---

## Golden AMI for Disaster Recovery

Instead of manually rebuilding servers, a Golden AMI allows a fully configured EC2 instance to be launched quickly, significantly reducing recovery time.

---

# End-to-End Architecture Lifecycle

```text
                User Request
                     │
                     ▼
          Amazon EC2 (Apache Server)
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
     Amazon EBS           Amazon EFS
                     │
                     ▼
             CloudWatch Agent
                     │
                     ▼
           Amazon CloudWatch
                     │
                     ▼
          CloudWatch Dashboard
                     │
                     ▼
          CloudWatch Alarm
                     │
                     ▼
              Amazon SNS
                     │
                     ▼
          Email Notification


Apache & Linux Logs
        │
        ▼
 backup-logs.sh
        │
        ▼
    Amazon S3


Configured EC2
        │
        ▼
   Golden AMI
        │
        ▼
Disaster Recovery
```

---

# Interview Questions

## 1. Why did you use IAM Roles instead of Access Keys?

IAM Roles provide temporary credentials, improve security, and eliminate the need to store AWS access keys on the EC2 instance.

---

## 2. Why are both Amazon EBS and Amazon EFS used?

Amazon EBS stores the operating system and application files, while Amazon EFS provides shared storage that can be accessed by multiple EC2 instances.

---

## 3. What is the purpose of Amazon CloudWatch?

CloudWatch collects infrastructure metrics, displays dashboards, and generates alarms whenever configured thresholds are exceeded.

---

## 4. Why is Amazon SNS integrated with CloudWatch?

Amazon SNS sends email notifications whenever CloudWatch Alarms enter the **ALARM** state, allowing administrators to respond quickly.

---

## 5. Why are logs backed up to Amazon S3?

Amazon S3 provides durable, highly available, and cost-effective storage for long-term log retention and troubleshooting.

---

## 6. What is the purpose of the Golden AMI?

The Golden AMI stores a fully configured EC2 instance image that can be used to rapidly launch replacement servers during failures.

---

## 7. How would you improve this architecture for production?

Possible improvements include:

- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- Multi-AZ Deployment
- Amazon RDS
- AWS Backup
- AWS Systems Manager
- AWS WAF
- Infrastructure as Code (Terraform or CloudFormation)
- CI/CD Pipeline
- AWS Secrets Manager

---

# Skills Demonstrated

This project demonstrates hands-on experience with:

- Amazon EC2
- IAM Roles
- Amazon EBS
- Amazon EFS
- Amazon S3
- Amazon CloudWatch
- CloudWatch Alarms
- Amazon SNS
- AWS CloudTrail
- Amazon Machine Image (AMI)
- Linux Administration
- Bash Scripting
- Monitoring & Alerting
- Backup Automation
- Disaster Recovery
- AWS Architecture Design

---

# Final Architecture Summary

The **AWS Project 1 – Server Monitoring & Log Backup System** demonstrates how multiple AWS services can be integrated into a complete operational solution.

The project includes:

- Secure infrastructure using IAM Roles
- Reliable compute using Amazon EC2
- Persistent storage using Amazon EBS
- Shared storage using Amazon EFS
- Continuous monitoring with Amazon CloudWatch
- Automated alerts using CloudWatch Alarms and Amazon SNS
- Automated log backups to Amazon S3
- Auditing with AWS CloudTrail
- Rapid disaster recovery using a Golden AMI

Although simplified for learning purposes, this architecture closely reflects the operational practices commonly used in production AWS environments.

---

# Future Enhancements

The knowledge gained from this project forms a strong foundation for more advanced AWS architectures.

Future enhancements include:

- Application Load Balancer (ALB)
- Auto Scaling Groups (ASG)
- Amazon RDS
- Amazon Route 53
- AWS WAF
- AWS Systems Manager
- AWS Backup
- Terraform
- AWS CloudFormation
- Docker
- Amazon ECS
- Amazon EKS
- GitHub Actions CI/CD
- AWS CodePipeline

---

# Screenshots Used in This Section

Store the screenshots in the following directory:

```text
screenshots/
└── Architecture/
    ├── 23-architecture-lifecycle.png
    ├── 24-service-selection.png
    ├── 25-design-decisions.png
    ├── 26-advantages-limitations.png
    ├── 27-interview-questions.png
    └── 28-final-summary.png
```

---

# Complete Document Summary

This architecture documentation covered:

- ✅ Architecture Overview
- ✅ AWS Services and Component Interactions
- ✅ Data Flow, Monitoring, Backup, and Disaster Recovery
- ✅ Production Architecture, Security, Scalability, and Best Practices
- ✅ Architecture Advantages, Design Decisions, Interview Questions, and Final Summary

This document serves as a complete reference for understanding, implementing, and presenting the **AWS Project 1 – Server Monitoring & Log Backup System**, making it suitable for GitHub portfolios, technical interviews, and practical AWS learning.
