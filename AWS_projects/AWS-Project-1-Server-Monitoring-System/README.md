# 🚀 AWS Project 1 - Server Monitoring & Log Backup System

> A real-world AWS project demonstrating monitoring, logging, storage, backup, security, and automation using core AWS services.

---

## 📖 Project Overview

This project demonstrates how multiple AWS services work together to build a secure, monitored, and highly available server environment.

The project simulates a production-like Linux web server hosted on Amazon EC2, where application logs are monitored, AWS activities are audited, automated backups are performed, and administrators receive email notifications whenever critical events occur.

This repository is designed for hands-on AWS practice and showcases real-world cloud administration concepts commonly used by Cloud Engineers and DevOps Engineers.

---

# 🎯 Project Objectives

* Launch and configure an Amazon EC2 instance
* Secure access using IAM Roles
* Store application backups in Amazon S3
* Monitor server metrics using Amazon CloudWatch
* Track AWS API activities using AWS CloudTrail
* Receive email notifications using Amazon SNS
* Configure Amazon EBS for persistent storage
* Configure Amazon EFS for shared storage
* Create an Amazon Machine Image (AMI) for disaster recovery
* Automate log backups using Shell Scripts and Cron Jobs

---

# 🛠 AWS Services Used

| AWS Service       | Purpose                               |
| ----------------- | ------------------------------------- |
| Amazon EC2        | Host the web application              |
| IAM               | Secure permissions using IAM Roles    |
| Amazon S3         | Store application and CloudTrail logs |
| Amazon EBS        | Persistent block storage              |
| Amazon EFS        | Shared file storage                   |
| Amazon CloudWatch | Monitoring, metrics, logs, and alarms |
| AWS CloudTrail    | Audit AWS API activities              |
| Amazon SNS        | Email notifications                   |
| Amazon AMI        | Backup and recovery of EC2 instances  |

---

# 📂 Repository Structure

```text
AWS-Project-1-Server-Monitoring-System/
│
├── README.md
├── architecture/
├── app/
├── assets/
├── cloudwatch/
├── docs/
├── scripts/
└── screenshots/
```

For the complete directory structure, refer to the **Repository Structure** section in this repository.

---

# 🏗 Project Architecture

> **Architecture diagram will be added here**

```text
                Internet
                    │
                    ▼
              Amazon EC2
                    │
      ┌─────────────┼──────────────┐
      │             │              │
      ▼             ▼              ▼
    Amazon EBS   Amazon EFS   CloudWatch Agent
                                      │
                                      ▼
                               CloudWatch Alarm
                                      │
                                      ▼
                                 Amazon SNS
                                      │
                                      ▼
                                 Email Alert

        CloudTrail ─────► Amazon S3 ◄──── Log Backups
                               │
                               ▼
                         Amazon AMI Backup
```

---

# ✨ Features

* Secure EC2 deployment using IAM Roles
* Web application hosting on Apache
* CloudWatch monitoring and dashboards
* CloudWatch alarms for CPU utilization
* Email notifications using SNS
* CloudTrail audit logging
* Log backup automation to Amazon S3
* Persistent storage using Amazon EBS
* Shared storage using Amazon EFS
* AMI creation for disaster recovery
* Shell script automation
* Cron job scheduling
* Step-by-step documentation with screenshots

---

# 📚 Documentation

| Document                | Description                    |
| ----------------------- | ------------------------------ |
| 01-Introduction.md      | Project overview               |
| 02-Architecture.md      | Solution architecture          |
| 03-IAM.md               | IAM Role configuration         |
| 04-S3.md                | Amazon S3 configuration        |
| 05-CloudTrail.md        | CloudTrail setup               |
| 06-EC2.md               | Launch EC2 instance            |
| 07-Web-Application.md   | Deploy Apache web application  |
| 08-EBS.md               | Configure EBS storage          |
| 09-EFS.md               | Configure EFS storage          |
| 10-CloudWatch.md        | Install CloudWatch Agent       |
| 11-CloudWatch-Alarms.md | Configure alarms               |
| 12-SNS.md               | Email notifications            |
| 13-AMI.md               | Create AMI backup              |
| 14-S3-Backup.md         | Automate log backups           |
| 15-Testing.md           | Validate the complete solution |
| 16-Troubleshooting.md   | Common issues and fixes        |
| 17-Project-Summary.md   | Project conclusion             |

---

# 🧪 What You'll Learn

* AWS infrastructure deployment
* IAM security best practices
* Linux server administration
* Apache web server deployment
* AWS monitoring and logging
* Cloud security fundamentals
* Storage management
* Backup and recovery
* Automation with Shell Scripts
* AWS operational best practices

---

# 📸 Project Screenshots

Screenshots for each implementation step will be available in the `screenshots/` directory.

---

# 🚀 Future Enhancements

* AWS Lambda automation
* Amazon EventBridge integration
* AWS Systems Manager (SSM)
* Application Load Balancer (ALB)
* Auto Scaling Group (ASG)
* AWS Backup
* AWS Config
* Amazon VPC with public and private subnets

---

# 👨‍💻 Author

**Newton N**

Cloud & DevOps Engineer | AWS Enthusiast

---

# ⭐ Support

If you find this project helpful:

* ⭐ Star this repository
* 🍴 Fork it
* 💡 Share your feedback
* 🤝 Connect and collaborate

---

## 📄 License

This project is licensed under the MIT License.
---

## 📁 Repository Structure

```text
AWS-Project-1-Server-Monitoring-System/
│
├── README.md                           # Project overview and setup guide
├── LICENSE                             # Project license
├── .gitignore                          # Git ignore rules
│
├── architecture/
│   ├── aws-project-1-architecture.png  # Overall AWS architecture diagram
│   ├── aws-project-1-workflow.png      # Project workflow diagram
│   └── diagrams.drawio                 # Editable Draw.io diagrams
│
├── app/
│   ├── index.html                      # Sample web application
│   ├── css/
│   │   └── style.css                   # Website styles
│   ├── js/
│   │   └── script.js                   # JavaScript functionality
│   └── images/
│       └── logo.png                    # Website images
│
├── cloudwatch/
│   ├── cloudwatch-agent-config.json    # CloudWatch Agent configuration
│   └── dashboard.json                  # CloudWatch dashboard configuration
│
├── scripts/
│   ├── install-apache.sh               # Install Apache Web Server
│   ├── install-cloudwatch-agent.sh     # Install CloudWatch Agent
│   ├── mount-ebs.sh                    # Mount EBS volume
│   ├── mount-efs.sh                    # Mount EFS file system
│   ├── backup-logs.sh                  # Backup logs to Amazon S3
│   ├── create-ami.sh                   # Create EC2 AMI
│   └── health-check.sh                 # Basic server health check
│
├── docs/
│   ├── 01-Introduction.md
│   ├── 02-Architecture.md
│   ├── 03-IAM.md
│   ├── 04-S3.md
│   ├── 05-CloudTrail.md
│   ├── 06-EC2.md
│   ├── 07-Web-Application.md
│   ├── 08-EBS.md
│   ├── 09-EFS.md
│   ├── 10-CloudWatch.md
│   ├── 11-CloudWatch-Alarms.md
│   ├── 12-SNS.md
│   ├── 13-AMI.md
│   ├── 14-S3-Backup.md
│   ├── 15-Testing.md
│   ├── 16-Troubleshooting.md
│   └── 17-Project-Summary.md
│
├── screenshots/
│   ├── IAM/
│   ├── S3/
│   ├── CloudTrail/
│   ├── EC2/
│   ├── WebApp/
│   ├── EBS/
│   ├── EFS/
│   ├── CloudWatch/
│   ├── SNS/
│   ├── AMI/
│   └── Testing/
│
└── assets/
    ├── banner.png                      # README banner
    ├── aws-icons.png                   # AWS service icons
    └── project-cover.png               # Project cover image
```
