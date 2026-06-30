# AWS Project 1 – Server Monitoring & Log Backup System

## Executive Summary

The **AWS Project 1 – Server Monitoring & Log Backup System** is a production-inspired AWS infrastructure project that demonstrates how to deploy, monitor, secure, back up, and recover a Linux-based web server using core AWS services.

The project was designed to simulate a real-world operational environment where system administrators and DevOps engineers are responsible for ensuring high availability, monitoring infrastructure health, protecting application data, automating operational tasks, and preparing for disaster recovery.

The solution integrates multiple AWS services into a single workflow, providing hands-on experience with cloud infrastructure management, monitoring, automation, and operational best practices.

This project emphasizes practical implementation rather than theoretical concepts, making it suitable for learning, portfolio development, and technical interview preparation.

---

# Project Objectives

The primary objectives of this project are:

- Deploy a web application on an Amazon EC2 instance.
- Secure AWS resource access using IAM Roles.
- Store application data using Amazon EBS.
- Configure shared file storage using Amazon EFS.
- Monitor system health using Amazon CloudWatch.
- Configure CloudWatch Alarms for proactive monitoring.
- Send email notifications using Amazon SNS.
- Automate log backups to Amazon S3.
- Create a Golden AMI for disaster recovery.
- Validate the infrastructure through comprehensive testing.
- Document deployment, troubleshooting, and operational procedures.

---

# Project Scope

This project covers the complete lifecycle of deploying and operating a monitored web server environment on AWS.

The implementation includes:

### Infrastructure

- IAM Role configuration
- Amazon EC2 deployment
- Apache Web Server installation
- Web application deployment

### Storage

- Amazon EBS for persistent block storage
- Amazon EFS for shared network file storage
- Amazon S3 for log backups

### Monitoring

- Amazon CloudWatch Agent
- CloudWatch Metrics
- CloudWatch Dashboard
- CloudWatch Alarms

### Notifications

- Amazon SNS Email Notifications

### Disaster Recovery

- Golden Amazon Machine Image (AMI)
- EC2 instance recovery

### Operations

- Bash automation scripts
- Scheduled backups using Cron
- Infrastructure validation
- Troubleshooting documentation

---

# Project Architecture

The following diagram illustrates the overall architecture of the project.

<p align="center">
<img src="../architecture/aws-project-1-architecture.png" width="1000">
</p>

---

# End-to-End Architecture Workflow

```text
                     Internet Users
                           │
                           ▼
                    Amazon EC2 Instance
                 (Apache Web Server + Website)
                           │
          ┌────────────────┴────────────────┐
          ▼                                 ▼
    Amazon EBS                      Amazon EFS
(Application Storage)          (Shared File Storage)
          │                                 │
          └────────────────┬────────────────┘
                           ▼
                 CloudWatch Agent
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   CloudWatch         CloudWatch      CloudWatch
     Metrics           Dashboard        Alarms
                                              │
                                              ▼
                                         Amazon SNS
                                              │
                                              ▼
                                      Email Notification

                Apache & System Logs
                           │
                           ▼
                    backup-logs.sh
                           │
                           ▼
                       Amazon S3
                     (Log Backups)

                           │
                           ▼
                     Golden AMI
                           │
                           ▼
                  Disaster Recovery
```

---

# AWS Services Used

| AWS Service | Purpose |
|-------------|---------|
| IAM | Secure access using IAM Roles |
| Amazon EC2 | Linux web server hosting |
| Amazon EBS | Persistent block storage |
| Amazon EFS | Shared network file system |
| Amazon S3 | Automated log backups |
| Amazon CloudWatch | Monitoring and dashboards |
| CloudWatch Alarms | Infrastructure alerting |
| Amazon SNS | Email notifications |
| Amazon Machine Image (AMI) | Disaster recovery |
| CloudTrail | AWS API activity logging |

---

# Project Highlights

This project demonstrates:

- Production-style AWS architecture
- Linux system administration
- Secure IAM Role implementation
- Persistent and shared storage management
- Infrastructure monitoring
- Automated alerting
- Log backup automation
- Disaster recovery planning
- End-to-end infrastructure testing
- Operational troubleshooting

---

# Business Use Case

A company hosts an internal web application on Amazon EC2.

To ensure reliable operations, the infrastructure must:

- Continuously monitor server health.
- Alert administrators when issues occur.
- Back up server logs automatically.
- Store backups securely.
- Recover quickly from server failures.
- Maintain shared storage across replacement servers.

This project provides a practical implementation of these operational requirements using AWS services.

---

# Real-Time Production Scenario

An organization runs a customer-facing web application on Amazon EC2.

During peak business hours:

- CloudWatch monitors CPU, memory, disk, and network usage.
- CloudWatch Alarms detect abnormal resource utilization.
- Amazon SNS immediately notifies the operations team.
- Scheduled scripts back up application and system logs to Amazon S3.
- If the EC2 instance becomes unavailable, a replacement server is launched from the Golden AMI.
- Amazon EFS reconnects shared application files, allowing the service to resume with minimal downtime.

This workflow reflects common operational practices used by cloud operations and DevOps teams.

---

# Repository Structure

```text
AWS-Project-1-Server-Monitoring-System/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── architecture/
├── app/
├── cloudwatch/
├── scripts/
├── docs/
├── screenshots/
└── assets/
```

---

# Screenshots Used in This Section

Store these screenshots in the following directory:

```text
screenshots/
└── Project-Summary/
    ├── 01-project-overview.png
    ├── 02-project-architecture.png
    ├── 03-aws-services.png
    └── 04-project-workflow.png
```

---

# Part 1 Summary

In this section, we covered:

- ✅ Executive Summary
- ✅ Project Objectives
- ✅ Project Scope
- ✅ Architecture Overview
- ✅ AWS Services Used
- ✅ Business Use Case
- ✅ Real-Time Production Scenario
- ✅ Repository Structure

In **Part 2**, we will cover:

- Project Folder Structure
- Scripts Overview
- Documentation Overview
- Key Features
- Security Implementation
- Automation Components
- Monitoring Features
- Backup Strategy

---

# Part 2: Repository Structure, Features, and Components

This section provides an overview of the project organization, supporting scripts, documentation, and core features implemented throughout the project.

---

# Repository Structure

The project follows a modular directory structure to separate application code, documentation, automation scripts, architecture diagrams, and screenshots.

```text
AWS-Project-1-Server-Monitoring-System/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── architecture/
│   ├── aws-project-1-architecture.png
│   ├── aws-project-1-workflow.png
│   └── diagrams.drawio
│
├── app/
│   ├── index.html
│   ├── css/
│   ├── js/
│   └── images/
│
├── cloudwatch/
│   ├── cloudwatch-agent-config.json
│   └── dashboard.json
│
├── scripts/
├── docs/
├── screenshots/
└── assets/
```

This structure keeps the repository clean, scalable, and easy to navigate.

---

# Documentation Overview

The project documentation is divided into dedicated sections covering each stage of implementation.

| Document | Description |
|----------|-------------|
| 01-Introduction.md | Project overview and objectives |
| 02-Architecture.md | AWS architecture and workflow |
| 03-IAM.md | IAM Roles and permissions |
| 04-S3.md | Amazon S3 configuration |
| 05-CloudTrail.md | CloudTrail setup and auditing |
| 06-EC2.md | EC2 deployment |
| 07-Web-Application.md | Apache and web application deployment |
| 08-EBS.md | Amazon EBS configuration |
| 09-EFS.md | Amazon EFS configuration |
| 10-CloudWatch.md | CloudWatch monitoring |
| 11-CloudWatch-Alarms.md | Alarm configuration |
| 12-SNS.md | Email notifications |
| 13-AMI.md | Golden AMI creation |
| 14-S3-Backup.md | Automated log backups |
| 15-Testing.md | Infrastructure validation |
| 16-Troubleshooting.md | Common issues and resolutions |
| 17-Project-Summary.md | Final project summary |

---

# Automation Scripts

The project includes reusable Bash scripts to automate common administrative tasks.

| Script | Purpose |
|---------|---------|
| install-apache.sh | Install and configure Apache HTTP Server |
| install-cloudwatch-agent.sh | Install and configure CloudWatch Agent |
| mount-ebs.sh | Mount Amazon EBS volume |
| mount-efs.sh | Mount Amazon EFS file system |
| backup-logs.sh | Compress and upload logs to Amazon S3 |
| create-ami.sh | Create a Golden AMI |
| health-check.sh | Perform basic server health checks |

---

# Monitoring Components

The monitoring solution includes the following services:

### Amazon CloudWatch

- CPU utilization monitoring
- Memory utilization monitoring
- Disk usage monitoring
- Network traffic monitoring
- Dashboard visualization

### CloudWatch Alarms

Configured to detect abnormal resource utilization and automatically trigger notifications.

### Amazon SNS

Delivers email notifications whenever a CloudWatch Alarm changes to the **ALARM** state.

---

# Storage Components

The project uses multiple AWS storage services for different purposes.

## Amazon EBS

Used for:

- Operating system storage
- Application files
- Persistent block storage

## Amazon EFS

Used for:

- Shared application files
- Multi-instance file access
- Persistent network storage

## Amazon S3

Used for:

- Automated log backups
- Long-term storage
- Backup retention

---

# Security Implementation

Security was implemented using AWS best practices.

### IAM Roles

- Temporary credentials
- No hardcoded access keys
- Least privilege principle

### Security Groups

Configured to allow only required traffic:

- SSH (22)
- HTTP (80)
- NFS (2049) for EFS

### CloudTrail

Enabled to audit AWS API activity and improve operational visibility.

---

# Automation Features

Several operational tasks are automated.

- Apache installation
- CloudWatch Agent installation
- Storage mounting
- Log compression
- Log upload to Amazon S3
- Scheduled backups using Cron
- Golden AMI creation

Automation reduces manual effort and improves consistency.

---

# Key Features

The project includes the following capabilities:

- Secure AWS infrastructure
- Linux-based web server deployment
- Persistent block storage
- Shared network file system
- Infrastructure monitoring
- Dashboard visualization
- Automated alerting
- Email notifications
- Automated log backups
- Disaster recovery
- Infrastructure validation
- Troubleshooting documentation

---

# Project Deliverables

The completed project includes:

- Fully documented implementation
- Architecture diagrams
- Automation scripts
- Configuration files
- Testing documentation
- Troubleshooting guide
- Supporting screenshots
- GitHub-ready repository

---

# Screenshots Used in This Section

Store the screenshots in:

```text
screenshots/
└── Project-Summary/
    ├── 05-folder-structure.png
    ├── 06-documentation-overview.png
    ├── 07-automation-scripts.png
    ├── 08-monitoring-components.png
    ├── 09-storage-components.png
    └── 10-security-overview.png
```

---

# Part 2 Summary

In this section, we covered:

- ✅ Repository Structure
- ✅ Documentation Overview
- ✅ Automation Scripts
- ✅ Monitoring Components
- ✅ Storage Components
- ✅ Security Implementation
- ✅ Automation Features
- ✅ Key Features
- ✅ Project Deliverables

In **Part 3**, we will cover:

- End-to-End Project Workflow
- Deployment Timeline
- Skills Demonstrated
- Real-World Implementation Flow
- Production Architecture Summary
- Project Outcomes

---

# Part 3: End-to-End Workflow, Implementation Timeline, and Skills Demonstrated

This section provides a complete overview of how the project was implemented, how the AWS services interact, and the practical skills demonstrated throughout the project.

---

# End-to-End Project Workflow

The following workflow illustrates the complete lifecycle of the project.

```text
                     User Accesses Website
                              │
                              ▼
                    Amazon EC2 Instance
                  (Apache Web Server)
                              │
          ┌───────────────────┴───────────────────┐
          ▼                                       ▼
   Amazon EBS                              Amazon EFS
(OS & Application Data)              (Shared File Storage)
          │                                       │
          └───────────────────┬───────────────────┘
                              ▼
                    CloudWatch Agent
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      CloudWatch         CloudWatch      CloudWatch
        Metrics           Dashboard        Alarms
                                                 │
                                                 ▼
                                            Amazon SNS
                                                 │
                                                 ▼
                                         Email Notification

                    Apache & System Logs
                              │
                              ▼
                      backup-logs.sh
                              │
                              ▼
                         Amazon S3
                     (Log Archive Storage)

                              │
                              ▼
                         Golden AMI
                              │
                              ▼
                    Disaster Recovery
```

---

# Project Implementation Timeline

The project was implemented in the following sequence.

| Phase | Activity |
|--------|----------|
| Phase 1 | Project planning and architecture design |
| Phase 2 | IAM Role configuration |
| Phase 3 | Amazon S3 bucket creation |
| Phase 4 | CloudTrail configuration |
| Phase 5 | Amazon EC2 deployment |
| Phase 6 | Apache Web Server installation |
| Phase 7 | Web application deployment |
| Phase 8 | Amazon EBS configuration |
| Phase 9 | Amazon EFS configuration |
| Phase 10 | CloudWatch Agent installation |
| Phase 11 | CloudWatch Dashboard creation |
| Phase 12 | CloudWatch Alarm configuration |
| Phase 13 | Amazon SNS integration |
| Phase 14 | Automated log backup to Amazon S3 |
| Phase 15 | Golden AMI creation |
| Phase 16 | Infrastructure testing |
| Phase 17 | Troubleshooting and validation |
| Phase 18 | Final project documentation |

---

# Deployment Workflow

The deployment process followed a structured sequence.

```text
Plan
   │
   ▼
Design
   │
   ▼
Deploy Infrastructure
   │
   ▼
Configure Storage
   │
   ▼
Deploy Application
   │
   ▼
Enable Monitoring
   │
   ▼
Configure Alerts
   │
   ▼
Automate Backups
   │
   ▼
Create Golden AMI
   │
   ▼
Testing
   │
   ▼
Troubleshooting
   │
   ▼
Production Ready
```

---

# Skills Demonstrated

This project demonstrates practical experience in the following areas.

## AWS Services

- Amazon EC2
- Amazon EBS
- Amazon EFS
- Amazon S3
- Amazon CloudWatch
- CloudWatch Alarms
- Amazon SNS
- IAM
- CloudTrail
- Amazon Machine Image (AMI)

---

## Linux Administration

- User and permission management
- Package installation
- Service management
- Storage administration
- File system management
- Log management
- Cron job scheduling
- Shell scripting

---

## Monitoring and Operations

- Infrastructure monitoring
- Dashboard creation
- Alert configuration
- Performance monitoring
- Incident response
- Log analysis
- Backup verification

---

## Automation

- Bash scripting
- Automated backups
- Health check scripts
- Service configuration
- Scheduled task execution

---

## Documentation

- Architecture documentation
- Deployment guides
- Testing procedures
- Troubleshooting guides
- Operational runbooks

---

# Real-World Operational Flow

The following sequence represents how the solution operates in a production environment.

1. Users access the web application hosted on Amazon EC2.
2. Apache processes incoming requests.
3. Application and system data are stored on Amazon EBS.
4. Shared files are stored on Amazon EFS.
5. CloudWatch Agent collects system metrics.
6. CloudWatch Dashboards display real-time performance.
7. CloudWatch Alarms monitor predefined thresholds.
8. Amazon SNS sends email notifications when alarms are triggered.
9. Scheduled scripts compress application and system logs.
10. Log archives are uploaded to Amazon S3.
11. A Golden AMI enables rapid recovery if the server fails.

---

# Key Project Outcomes

By completing this project, the following outcomes were achieved:

- Successfully deployed a Linux web server on AWS.
- Implemented secure IAM Role-based access.
- Configured persistent and shared storage.
- Enabled infrastructure monitoring and visualization.
- Implemented automated alerting.
- Automated log backup and archival.
- Created a reusable Golden AMI.
- Validated the environment through structured testing.
- Documented troubleshooting procedures.
- Produced a GitHub-ready portfolio project.

---

# Operational Benefits

The implemented solution provides several operational advantages.

- Improved infrastructure visibility.
- Faster issue detection.
- Automated operational tasks.
- Reduced manual intervention.
- Secure access management.
- Simplified disaster recovery.
- Better documentation and maintainability.
- Scalable architecture for future enhancements.

---

# Screenshots Used in This Section

Store the screenshots in:

```text
screenshots/
└── Project-Summary/
    ├── 11-end-to-end-workflow.png
    ├── 12-deployment-timeline.png
    ├── 13-deployment-workflow.png
    ├── 14-skills-demonstrated.png
    ├── 15-operational-flow.png
    └── 16-project-outcomes.png
```

---

# Part 3 Summary

In this section, we covered:

- ✅ End-to-End Project Workflow
- ✅ Implementation Timeline
- ✅ Deployment Workflow
- ✅ Skills Demonstrated
- ✅ Real-World Operational Flow
- ✅ Key Project Outcomes
- ✅ Operational Benefits

In **Part 4**, we will cover:

- Challenges Faced During the Project
- Lessons Learned
- Resume-Ready Project Description
- Interview Talking Points
- GitHub Portfolio Highlights

---

# Part 4: Challenges, Lessons Learned, Resume Summary, and Interview Preparation

This section summarizes the practical challenges encountered during the project, the knowledge gained, and provides a concise project description suitable for resumes, LinkedIn, and technical interviews.

---

# Challenges Faced During the Project

Building this project involved several real-world challenges that required investigation, troubleshooting, and validation.

## Challenge 1: IAM Role Configuration

### Issue

AWS CLI commands failed because the EC2 instance did not have an IAM Role attached.

### Resolution

- Verified instance metadata.
- Attached the correct IAM Role.
- Confirmed temporary credentials were available.
- Successfully tested AWS CLI access.

---

## Challenge 2: Amazon EFS Mount Configuration

### Issue

The Amazon EFS file system could not be mounted initially.

### Resolution

- Installed `amazon-efs-utils`.
- Verified mount targets.
- Confirmed Security Group rules allowed TCP port **2049**.
- Successfully mounted the file system.

---

## Challenge 3: CloudWatch Agent Configuration

### Issue

Memory and disk metrics were not visible in CloudWatch.

### Resolution

- Reviewed the CloudWatch Agent configuration.
- Restarted the service.
- Verified IAM permissions.
- Confirmed custom metrics were published successfully.

---

## Challenge 4: Amazon SNS Notifications

### Issue

CloudWatch Alarms were triggered, but no email notifications were received.

### Resolution

- Confirmed the SNS subscription.
- Verified the CloudWatch Alarm action.
- Successfully tested email delivery.

---

## Challenge 5: Automated S3 Backup

### Issue

Backup uploads initially failed because of incorrect permissions.

### Resolution

- Updated the IAM policy.
- Verified S3 bucket access.
- Confirmed successful uploads using the backup script.

---

# Lessons Learned

This project provided valuable practical experience in cloud infrastructure management.

Key lessons include:

- Apply the principle of least privilege using IAM Roles.
- Validate configurations incrementally.
- Monitor infrastructure continuously using CloudWatch.
- Test alarm notifications before production deployment.
- Automate repetitive administrative tasks.
- Verify backups by performing restoration tests.
- Keep detailed documentation for deployment and troubleshooting.
- Create reusable machine images for disaster recovery.

---

# Technical Skills Demonstrated

## AWS

- IAM
- Amazon EC2
- Amazon EBS
- Amazon EFS
- Amazon S3
- Amazon CloudWatch
- CloudWatch Alarms
- Amazon SNS
- CloudTrail
- Amazon Machine Images (AMI)

---

## Linux

- Apache HTTP Server
- Bash scripting
- Cron scheduling
- System monitoring
- Storage management
- Log management
- Service administration

---

## DevOps Practices

- Infrastructure monitoring
- Backup automation
- Disaster recovery
- Operational documentation
- Troubleshooting
- Validation and testing

---

# Resume-Ready Project Description

**Project Title**

AWS Server Monitoring & Log Backup System

**Description**

Designed and implemented a production-inspired AWS infrastructure project that hosts a Linux-based web application on Amazon EC2, integrates monitoring through Amazon CloudWatch, sends automated alerts using Amazon SNS, stores persistent and shared data using Amazon EBS and Amazon EFS, automates log backups to Amazon S3, and enables disaster recovery through a Golden AMI. The project also includes comprehensive deployment documentation, testing procedures, and troubleshooting guides.

---

# Key Achievements

- Successfully deployed a complete AWS infrastructure.
- Implemented secure IAM Role-based access.
- Configured automated monitoring and alerting.
- Automated log backup to Amazon S3.
- Created a Golden AMI for disaster recovery.
- Produced comprehensive technical documentation.
- Validated all infrastructure components through structured testing.

---

# Interview Talking Points

When discussing this project during an interview, focus on:

## Project Overview

Explain the overall objective and architecture.

---

## Security

Describe how IAM Roles were used instead of long-term access keys.

---

## Monitoring

Explain how CloudWatch collects metrics, how alarms work, and how Amazon SNS delivers notifications.

---

## Storage

Discuss the difference between Amazon EBS and Amazon EFS and why each service was selected.

---

## Backup Strategy

Explain how application and system logs are compressed and uploaded to Amazon S3 using automation scripts.

---

## Disaster Recovery

Describe how a Golden AMI allows rapid recovery of a failed EC2 instance.

---

## Troubleshooting Experience

Share examples of real issues encountered during the project, such as:

- IAM Role verification
- EFS mount configuration
- CloudWatch Agent troubleshooting
- SNS subscription validation
- S3 permission troubleshooting

---

# GitHub Portfolio Highlights

This repository demonstrates:

- Practical AWS implementation
- Linux administration
- Monitoring and alerting
- Infrastructure automation
- Disaster recovery planning
- Professional documentation
- Troubleshooting methodology
- End-to-end project execution

---

# Screenshots Used in This Section

Store the screenshots in:

```text
screenshots/
└── Project-Summary/
    ├── 17-challenges.png
    ├── 18-lessons-learned.png
    ├── 19-resume-project.png
    ├── 20-interview-topics.png
    └── 21-github-highlights.png
```

---

# Part 4 Summary

In this section, we covered:

- ✅ Challenges Faced
- ✅ Lessons Learned
- ✅ Technical Skills Demonstrated
- ✅ Resume-Ready Project Description
- ✅ Key Achievements
- ✅ Interview Talking Points
- ✅ GitHub Portfolio Highlights

In **Part 5**, we will complete the project with:

- Future Enhancements
- Project Statistics
- Final Project Checklist
- Acknowledgements
- Final Conclusion
