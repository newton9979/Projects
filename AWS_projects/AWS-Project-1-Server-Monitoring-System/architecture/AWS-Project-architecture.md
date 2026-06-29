# 🏗️ Architecture Diagram

The following architecture illustrates how the AWS services work together to provide a secure, monitored, and automated server environment.

```text
                                           +----------------------+
                                           |        User          |
                                           | (Browser / SSH)      |
                                           +----------+-----------+
                                                      |
                                                      |
                                           HTTP (80) / SSH (22)
                                                      |
                                                      ▼
                                  +------------------------------------+
                                  |         Amazon EC2 Instance        |
                                  |                                    |
                                  |  • Apache Web Server               |
                                  |  • Sample Web Application          |
                                  |  • CloudWatch Agent                |
                                  |  • Backup Scripts                  |
                                  +--------+--------------+------------+
                                           |              |
                              Read/Write   |              | Mount
                                           |              |
                                           ▼              ▼
                              +------------------+   +------------------+
                              |   Amazon EBS     |   |   Amazon EFS     |
                              | Persistent Disk  |   | Shared Storage   |
                              +------------------+   +------------------+
                                           |
                                           |
                                           ▼
                              +------------------------------+
                              |       Amazon S3 Bucket       |
                              |------------------------------|
                              | • Log Backups               |
                              | • CloudTrail Logs           |
                              | • Archived Files            |
                              +--------------+--------------+
                                             ▲
                                             |
                                 Stores Audit Logs
                                             |
                              +--------------+--------------+
                              |      AWS CloudTrail         |
                              | Records AWS API Activity    |
                              +-----------------------------+

      +-------------------------------------------------------------+
      |                     Amazon CloudWatch                       |
      |-------------------------------------------------------------|
      | • CPU Monitoring                                            |
      | • Memory Monitoring                                         |
      | • Disk Monitoring                                           |
      | • Application Logs                                          |
      | • CloudWatch Alarms                                         |
      +-------------------------+-----------------------------------+
                                |
                                | Alarm Trigger
                                ▼
                      +--------------------------+
                      |       Amazon SNS         |
                      |--------------------------|
                      | Email Notifications      |
                      +------------+-------------+
                                   |
                                   ▼
                           Administrator Email

                      +--------------------------+
                      |      Amazon AMI          |
                      |--------------------------|
                      | Server Backup Image      |
                      | Disaster Recovery        |
                      +--------------------------+
```

---

## 🔄 Architecture Workflow

1. A user accesses the web application hosted on the Amazon EC2 instance.
2. The web application stores data on Amazon EBS and can use Amazon EFS for shared file storage.
3. AWS CloudWatch Agent collects server metrics and application logs.
4. CloudWatch monitors CPU, memory, disk utilization, and log files.
5. CloudWatch Alarms trigger when predefined thresholds are exceeded.
6. Amazon SNS sends email notifications to administrators.
7. AWS CloudTrail records every AWS API call and stores audit logs in Amazon S3.
8. Backup scripts archive application logs and upload them to Amazon S3.
9. Amazon AMI is created periodically to provide a complete backup of the EC2 instance for disaster recovery.

---

## 🎯 Architecture Highlights

* Secure access using IAM Roles
* Persistent storage with Amazon EBS
* Shared storage with Amazon EFS
* Continuous monitoring using Amazon CloudWatch
* AWS API auditing using CloudTrail
* Email alerts through Amazon SNS
* Automated log backups to Amazon S3
* Disaster recovery using Amazon AMIs

---

## 🏗️ Architecture Diagram

The following architecture illustrates how the AWS services work together to provide a secure, monitored, and automated server environment.

<div align="center">

<img src="./architecture/aws-project-1-architecture.png"
  alt="AWS Project 1 - Server Monitoring & Log Backup System Architecture"
  width="100%">

<br>

<p><strong>Figure 1:</strong> AWS Project 1 – Server Monitoring & Log Backup System Architecture</p>

</div>

---

### 📌 Architecture Overview

The solution consists of an Amazon EC2 instance running a sample Apache web application. The EC2 instance uses an IAM Role for secure access to AWS services without storing access keys.

The application stores persistent data on Amazon EBS and uses Amazon EFS for shared file storage. AWS CloudWatch continuously collects CPU, memory, disk, and application log metrics through the CloudWatch Agent.

CloudWatch Alarms monitor these metrics and trigger Amazon SNS to send email notifications whenever predefined thresholds are exceeded.

AWS CloudTrail records every AWS API activity and stores audit logs in an Amazon S3 bucket. The same S3 bucket is also used to store automated application log backups generated by shell scripts.

Finally, an Amazon Machine Image (AMI) is created after the server configuration is complete, enabling rapid disaster recovery by launching identical EC2 instances whenever required.

---
