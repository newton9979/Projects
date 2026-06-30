# Amazon Machine Image (AMI)

## Objective

In this section, we will create a **Custom Amazon Machine Image (AMI)** from our fully configured EC2 instance.

This AMI will allow us to launch identical EC2 instances with all required software, configurations, and monitoring components already installed.

By the end of this guide, you will learn how to:

- Understand Amazon Machine Images (AMI)
- Learn the components of an AMI
- Understand different AMI types
- Compare AMIs and Snapshots
- Create a reusable Golden AMI
- Understand production use cases
- Prepare for disaster recovery scenarios

---

# Prerequisites

Before proceeding, ensure the following components have already been configured.

- AWS Account
- EC2 Instance Running
- Apache Web Server Installed
- Web Application Deployed
- EBS Volume Mounted
- Amazon EFS Mounted
- CloudWatch Agent Configured
- CloudWatch Dashboard Created
- CloudWatch Alarm Configured
- Amazon SNS Notifications Working

> **Note**
>
> This document continues from **12-SNS.md**.

---

# What is an Amazon Machine Image (AMI)?

An **Amazon Machine Image (AMI)** is a pre-configured template used to launch Amazon EC2 instances.

It contains everything required to start a new instance, including:

- Operating System
- Installed Software
- Application Files
- System Configuration
- Security Updates
- Block Device Mapping

Instead of configuring a new server from scratch every time, you can launch an EC2 instance from an AMI in just a few minutes.

---

# Why Are We Using an AMI in This Project?

Our EC2 instance is no longer a basic server.

It already contains:

- Apache Web Server
- Sample Web Application
- EBS Storage Configuration
- Amazon EFS Mount
- CloudWatch Agent
- CloudWatch Dashboard Configuration
- CloudWatch Alarms
- Amazon SNS Integration
- Monitoring Scripts
- Backup Scripts

Rebuilding all these components manually would take considerable time.

Creating a **Custom AMI** allows us to recreate the same environment quickly and consistently.

---

# Components of an AMI

An Amazon Machine Image consists of several components.

## 1. Root Volume Snapshot

The AMI includes a snapshot of the root EBS volume.

This snapshot stores:

- Operating System
- Installed Packages
- Configuration Files
- Application Data

---

## 2. Block Device Mapping

Block Device Mapping defines which storage volumes are attached when a new EC2 instance is launched.

Examples include:

- Root Volume
- Additional EBS Volumes

---

## 3. Launch Permissions

Launch permissions determine who can use the AMI.

An AMI can be:

- Private
- Shared with specific AWS accounts
- Public

---

# Types of Amazon AMIs

AWS provides several types of AMIs.

| AMI Type | Description |
|-----------|-------------|
| Amazon AMI | Official AMIs maintained by AWS |
| Community AMI | Created and shared by AWS users |
| AWS Marketplace AMI | Commercial AMIs provided by software vendors |
| Custom AMI | Created from your own EC2 instance |

For this project, we will create a **Custom AMI**.

---

# AMI vs Snapshot

Many beginners confuse AMIs with EBS Snapshots.

The following table highlights the differences.

| Amazon AMI | EBS Snapshot |
|-------------|--------------|
| Used to launch EC2 instances | Backup of a single EBS volume |
| Includes launch configuration | Stores only volume data |
| Can create multiple EC2 instances | Used to restore storage volumes |
| Contains boot information | Does not contain boot configuration |

---

# AMI vs Launch Template

| Amazon AMI | Launch Template |
|-------------|-----------------|
| Stores the operating system and software | Stores EC2 launch configuration |
| Used to create identical servers | Used to standardize deployment settings |
| Includes EBS snapshots | References an AMI during launch |

---

# Architecture Overview

```text
                 Configured EC2 Instance
                           │
                           ▼
                 Create Amazon Machine Image
                           │
                           ▼
                    EBS Snapshot Created
                           │
                           ▼
                     Custom Amazon AMI
                           │
                           ▼
               Launch New EC2 Instances
```

---

# Architecture Diagram

<p align="center">
  <img src="../architecture/aws-project-1-architecture.png"
       alt="Amazon Machine Image Architecture"
       width="900">
</p>

---

# Real-Time Production Scenarios

## Scenario 1: Disaster Recovery

A production EC2 instance becomes unavailable due to an operating system failure.

Instead of rebuilding the server manually, the operations team launches a new EC2 instance from the latest Custom AMI.

Within minutes, the application is available again.

---

## Scenario 2: Auto Scaling

An application experiences a sudden increase in traffic.

Auto Scaling launches additional EC2 instances using the approved Custom AMI.

Each new instance already contains the required software and monitoring tools.

---

## Scenario 3: Development Environment

A development team needs ten identical servers.

Instead of configuring each server individually, the team launches ten EC2 instances from the same AMI.

Every instance has identical software versions and configurations.

---

## Scenario 4: Production Deployment

Before deploying a major application update, the DevOps team creates a new AMI.

If the deployment fails, they can launch a replacement instance from the AMI and quickly restore service.

---

# Benefits of Using AMIs

Creating and maintaining Custom AMIs provides several advantages.

- Rapid server deployment
- Consistent server configuration
- Faster disaster recovery
- Simplified scaling
- Reduced manual configuration
- Improved operational efficiency
- Easier environment replication

---

# Screenshots

## EC2 Instances

<p align="center">
  <img src="../screenshots/AMI/01-ec2-instance.png"
       alt="Running EC2 Instance"
       width="900">
</p>

---

## Amazon AMIs Page

<p align="center">
  <img src="../screenshots/AMI/02-ami-page.png"
       alt="Amazon AMIs Console"
       width="900">
</p>

---

# Part 1 Summary

In this section, you learned:

- ✔ What an Amazon Machine Image (AMI) is
- ✔ Why AMIs are important
- ✔ Components of an AMI
- ✔ Types of AMIs
- ✔ AMI vs Snapshot
- ✔ AMI vs Launch Template
- ✔ Production use cases
- ✔ Benefits of creating a Custom AMI

In **Part 2**, we will create a Custom AMI from our fully configured EC2 instance and verify the image creation process.

---

# Part 2: Creating a Custom Amazon Machine Image (AMI)

In this section, we will create a **Custom AMI** from our fully configured EC2 instance.

This AMI will capture our server, including:

- Operating System
- Apache Web Server
- Sample Web Application
- EBS Configuration
- Amazon EFS Mount Configuration
- CloudWatch Agent
- Monitoring Configuration
- Backup Scripts
- Installed Packages

The resulting AMI can be used to launch identical EC2 instances whenever required.

---

# Before Creating the AMI

Before creating an AMI, verify that the server is functioning correctly.

## Verify Apache Web Server

```bash
sudo systemctl status httpd
```

Expected Output

```text
Active: active (running)
```

---

## Verify CloudWatch Agent

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Expected Output

```text
Active: active (running)
```

---

## Verify EBS Volume

```bash
df -h
```

Ensure your EBS volume is mounted correctly.

---

## Verify Amazon EFS

```bash
mount | grep efs
```

Confirm the EFS file system is mounted successfully.

---

## Verify Website

Open your EC2 Public IP.

Example

```text
http://<EC2-Public-IP>
```

Verify that your sample web application loads successfully.

<p align="center">
  <img src="../screenshots/AMI/03-server-verification.png"
       alt="Verify EC2 Server Before Creating AMI"
       width="900">
</p>

---

# Step 1: Navigate to EC2 Instances

Open the AWS Management Console.

Navigate to:

```text
EC2
→ Instances
```

Select the instance that has been configured throughout this project.

<p align="center">
  <img src="../screenshots/AMI/04-select-instance.png"
       alt="Select EC2 Instance"
       width="900">
</p>

---

# Step 2: Create an Image

With the EC2 instance selected:

```text
Actions
→ Image and templates
→ Create image
```

This opens the **Create Image** page.

<p align="center">
  <img src="../screenshots/AMI/05-create-image-menu.png"
       alt="Create Image Menu"
       width="900">
</p>

---

# Step 3: Configure the AMI

Provide the following details.

| Setting | Example Value |
|----------|---------------|
| Image Name | Server-Monitoring-System-v1 |
| Image Description | Golden AMI for AWS Project 1 |
| Reboot Instance | Enabled (Recommended) |

---

## Why Reboot the Instance?

AWS provides two options when creating an AMI.

### Reboot Enabled (Recommended)

- Flushes cached data to disk
- Ensures file system consistency
- Produces a cleaner and more reliable AMI

### No Reboot

- Faster image creation
- Suitable for applications that cannot tolerate downtime
- May capture data that has not yet been written to disk

> **Production Recommendation:** Enable reboot unless your application has strict availability requirements.

<p align="center">
  <img src="../screenshots/AMI/06-image-settings.png"
       alt="AMI Configuration"
       width="900">
</p>

---

# Step 4: Create the Image

After reviewing the configuration, click:

```text
Create Image
```

AWS immediately begins creating the AMI.

Behind the scenes, AWS performs the following actions:

1. Creates snapshots of the attached EBS volumes.
2. Registers a new Amazon Machine Image.
3. Stores metadata about the image.
4. Makes the AMI available for launching new EC2 instances.

<p align="center">
  <img src="../screenshots/AMI/07-image-creating.png"
       alt="AMI Creation In Progress"
       width="900">
</p>

---

# Step 5: Monitor Image Creation

Navigate to:

```text
EC2
→ AMIs
```

Initially, the AMI status will be:

```text
Pending
```

After AWS completes the snapshot process, the status changes to:

```text
Available
```

<p align="center">
  <img src="../screenshots/AMI/08-ami-pending.png"
       alt="AMI Pending"
       width="900">
</p>

---

# Step 6: Verify the Snapshot

Navigate to:

```text
EC2
→ Snapshots
```

You should see a new EBS Snapshot created automatically.

This snapshot stores the data required to recreate the EC2 instance.

<p align="center">
  <img src="../screenshots/AMI/09-ebs-snapshot.png"
       alt="EBS Snapshot Created"
       width="900">
</p>

---

# Step 7: Verify the AMI

Return to:

```text
EC2
→ AMIs
```

Verify that:

- State is **Available**
- Name is correct
- Creation date is accurate
- Architecture matches the source instance
- Root device type is correct

<p align="center">
  <img src="../screenshots/AMI/10-ami-available.png"
       alt="AMI Available"
       width="900">
</p>

---

# What Happens Behind the Scenes?

When you create an AMI, AWS performs the following process.

```text
Configured EC2 Instance
          │
          ▼
Pause Writes (Optional Reboot)
          │
          ▼
Create EBS Snapshot
          │
          ▼
Register New AMI
          │
          ▼
AMI Status = Available
```

The original EC2 instance continues to exist after the AMI is created.

Creating an AMI does **not** replace or terminate the source instance.

---

# Real-Time Production Scenario

A company is preparing to deploy a new version of its web application.

Before making any changes, the DevOps team creates a Custom AMI of the production server.

The deployment unexpectedly fails due to an application configuration issue.

Instead of reinstalling the operating system, web server, monitoring tools, and application components, the team launches a new EC2 instance from the Custom AMI.

Within minutes, the original production environment is restored, significantly reducing downtime.

---

# Best Practices

- Create AMIs only after validating the server configuration.
- Use meaningful and versioned AMI names.
- Remove temporary files before creating an AMI.
- Apply system updates before image creation.
- Verify the AMI by launching a test instance.
- Tag AMIs with project name, version, and environment.

---

# Part 2 Summary

In this section, you have:

- ✔ Verified the EC2 instance
- ✔ Created a Custom AMI
- ✔ Understood the reboot option
- ✔ Monitored AMI creation
- ✔ Verified the EBS Snapshot
- ✔ Confirmed the AMI is available
- ✔ Learned how AWS creates an AMI behind the scenes

In **Part 3**, we will launch a brand-new EC2 instance from this AMI and verify that Apache, CloudWatch Agent, EBS, EFS, and our web application are all available without additional configuration.

---

# Part 3: Launching an EC2 Instance from the Custom AMI

Now that our Custom AMI has been created successfully, let's use it to launch a brand-new EC2 instance.

The goal is to verify that our entire server configuration has been preserved.

This includes:

- Operating System
- Apache Web Server
- Sample Web Application
- CloudWatch Agent
- Monitoring Configuration
- Installed Packages
- Backup Scripts

---

# Step 1: Launch a New EC2 Instance

Navigate to:

```text
EC2
→ AMIs
```

Select your Custom AMI.

Click:

```text
Launch Instance from AMI
```

<p align="center">
  <img src="../screenshots/AMI/11-launch-from-ami.png"
       alt="Launch Instance from AMI"
       width="900">
</p>

---

# Step 2: Configure the New Instance

Configure the instance as required.

Example configuration:

| Setting | Value |
|----------|-------|
| Name | Server-Monitoring-Clone |
| Instance Type | t2.micro |
| Key Pair | Existing Key Pair |
| VPC | Default VPC |
| Security Group | Existing Security Group |

Click:

```text
Launch Instance
```

<p align="center">
  <img src="../screenshots/AMI/12-instance-configuration.png"
       alt="Configure EC2 Instance"
       width="900">
</p>

---

# Step 3: Wait for the Instance

AWS launches the instance using the Custom AMI.

Wait until:

```text
Instance State
Running
```

and

```text
Status Checks
2/2 Passed
```

<p align="center">
  <img src="../screenshots/AMI/13-instance-running.png"
       alt="EC2 Running"
       width="900">
</p>

---

# Step 4: Verify Apache

Connect using SSH.

Run:

```bash
sudo systemctl status httpd
```

Expected Output

```text
Active: active (running)
```

Open the Public IP.

Your website should load immediately without reinstalling Apache.

<p align="center">
  <img src="../screenshots/AMI/14-website-working.png"
       alt="Website Running"
       width="900">
</p>

---

# Step 5: Verify CloudWatch Agent

Run:

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Expected Output

```text
Active: active (running)
```

Verify new metrics appear in CloudWatch after a few minutes.

<p align="center">
  <img src="../screenshots/AMI/15-cloudwatch-agent.png"
       alt="CloudWatch Agent Running"
       width="900">
</p>

---

# Step 6: Verify Storage

Check mounted storage.

```bash
df -h
```

Example Output

```text
/dev/xvda1

/dev/nvme1n1

127.0.0.1:/efs
```

Verify:

- Root Volume
- Additional EBS Volume
- Amazon EFS Mount

---

## Important Note About EBS

Additional EBS volumes that were attached separately to the original EC2 instance are **not automatically recreated** when launching from an AMI.

The AMI preserves the root volume image. If your application depends on separate EBS volumes, attach and mount them after launching the new instance or include them in your launch configuration.

---

## Important Note About Amazon EFS

Amazon EFS is a managed network file system.

The AMI does **not** contain the EFS data.

However, if:

- `/etc/fstab` contains the EFS mount entry
- Security Groups allow NFS (2049)
- The EFS Mount Target is available

then the new EC2 instance can reconnect to the existing EFS automatically after boot.

Verify:

```bash
mount | grep efs
```

or

```bash
df -h
```

<p align="center">
  <img src="../screenshots/AMI/16-storage-verification.png"
       alt="Verify EBS and EFS"
       width="900">
</p>

---

# Step 7: Verify Project Files

Navigate to the project directory.

Example:

```bash
cd /var/www/html
```

Verify:

- Web Application
- HTML Files
- CSS
- JavaScript
- Images

Also verify your backup and monitoring scripts.

Example:

```bash
ls ~/scripts
```

Expected files:

```text
install-apache.sh

install-cloudwatch-agent.sh

mount-ebs.sh

mount-efs.sh

backup-logs.sh

health-check.sh
```

---

# Validation Checklist

| Component | Status |
|-----------|--------|
| EC2 Running | ✅ |
| Apache Running | ✅ |
| Website Accessible | ✅ |
| CloudWatch Agent Running | ✅ |
| Root Volume Available | ✅ |
| EFS Connected | ✅ (if configured) |
| Project Files Present | ✅ |
| Monitoring Ready | ✅ |

---

# Real-Time Production Scenario

A production EC2 instance becomes unavailable because of an operating system issue.

Instead of manually:

- Installing Apache
- Configuring CloudWatch Agent
- Restoring application files
- Recreating monitoring
- Reconfiguring scripts

the DevOps engineer launches a new EC2 instance from the approved Golden AMI.

Within a few minutes:

- Apache starts successfully.
- The web application is available.
- CloudWatch begins collecting metrics.
- Existing EFS storage is mounted.
- Monitoring resumes with minimal downtime.

This significantly reduces recovery time and ensures configuration consistency.

---

# Best Practices

- Always test a newly created AMI by launching an instance.
- Keep AMIs versioned (for example, `Server-Monitoring-v1.0`).
- Remove outdated AMIs and snapshots when they are no longer needed.
- Tag AMIs with project, owner, and environment information.
- Validate applications and monitoring after launching from an AMI.
- Document any manual post-launch tasks, such as attaching additional EBS volumes.

---

# Interview Questions

## 1. Does an AMI include attached EBS volumes?

**Answer:**

An AMI always includes the root EBS volume. Additional EBS volumes may require separate snapshots or launch configuration, depending on how they are attached and configured.

---

## 2. Does an AMI contain Amazon EFS?

**Answer:**

No. Amazon EFS is a separate managed file system. The AMI can preserve the mount configuration, but not the EFS data itself.

---

## 3. Why should you test an AMI after creating it?

**Answer:**

Testing verifies that the operating system, applications, monitoring agents, and required configurations work correctly before the AMI is used in production.

---

# Part 3 Summary

In this section, you have:

- ✔ Launched an EC2 instance from the Custom AMI
- ✔ Verified Apache and the web application
- ✔ Verified the CloudWatch Agent
- ✔ Validated storage configuration
- ✔ Understood the differences between EBS and EFS during AMI-based recovery
- ✔ Learned how Golden AMIs simplify disaster recovery and server replacement

In **Part 4**, we will cover troubleshooting, AWS CLI commands, security and cost optimization, cleanup, interview questions, conclusion, and complete the AMI documentation.

---

# Part 4: Troubleshooting, Best Practices, and Conclusion

In this final section, we will review common AMI issues, useful AWS CLI commands, production best practices, security recommendations, cost optimization tips, and interview questions.

---

# Troubleshooting

The following table lists common issues encountered when working with Amazon Machine Images (AMIs).

| Issue | Possible Cause | Solution |
|--------|----------------|----------|
| AMI remains in **Pending** | Large EBS volume or snapshot creation in progress | Wait until snapshot creation completes |
| New instance fails to launch | Incorrect permissions or unavailable AMI | Verify AMI permissions and region |
| Website not accessible | Apache service not running or Security Group issue | Start Apache and verify inbound HTTP rules |
| CloudWatch metrics missing | CloudWatch Agent not running | Start and verify the CloudWatch Agent service |
| EFS not mounted | Missing `/etc/fstab` entry or NFS port blocked | Verify mount configuration and allow TCP 2049 |
| Additional EBS volume missing | Secondary EBS volume was not attached | Attach and mount the required EBS volume manually |

---

# Verification Checklist

Before considering the AMI ready for production, verify the following.

| Component | Status |
|-----------|--------|
| Custom AMI Created | ✅ |
| EBS Snapshot Created | ✅ |
| New EC2 Instance Launched | ✅ |
| Apache Running | ✅ |
| Website Accessible | ✅ |
| CloudWatch Agent Running | ✅ |
| EFS Mounted | ✅ |
| Monitoring Functional | ✅ |

---

# Useful AWS CLI Commands

## List Available AMIs

```bash
aws ec2 describe-images --owners self
```

---

## Create an AMI

```bash
aws ec2 create-image \
--instance-id i-xxxxxxxxxxxxxxxxx \
--name "Server-Monitoring-v1.0"
```

---

## Describe Snapshots

```bash
aws ec2 describe-snapshots --owner-ids self
```

---

## Deregister an AMI

```bash
aws ec2 deregister-image \
--image-id ami-xxxxxxxxxxxxxxxxx
```

> **Note:** Deregistering an AMI does not automatically delete the associated EBS snapshots.

---

## Delete an EBS Snapshot

```bash
aws ec2 delete-snapshot \
--snapshot-id snap-xxxxxxxxxxxxxxxxx
```

---

# Golden AMI Lifecycle

Many organizations maintain **Golden AMIs** to ensure every new server is built from a secure, tested, and standardized image.

```text
Base Operating System
        │
        ▼
Install Security Updates
        │
        ▼
Install Apache & Applications
        │
        ▼
Configure Monitoring
        │
        ▼
Validate Server
        │
        ▼
Create Golden AMI v1.0
        │
        ▼
Testing & Approval
        │
        ▼
Production Deployment
        │
        ▼
Golden AMI v1.1 (After Future Updates)
```

This approach improves consistency, simplifies deployments, and speeds up disaster recovery.

---

# Security Best Practices

To secure your AMIs:

- Share AMIs only with authorized AWS accounts.
- Encrypt EBS volumes and snapshots whenever possible.
- Remove sensitive information (temporary files, SSH keys, credentials) before creating an AMI.
- Apply the latest operating system and application updates.
- Use IAM policies to control who can create, share, or delete AMIs.
- Tag AMIs with project, environment, and version information.

---

# Cost Optimization

To reduce storage costs:

- Deregister AMIs that are no longer required.
- Delete unused EBS snapshots.
- Avoid creating duplicate AMIs.
- Follow a versioning and retention policy.
- Periodically review stored AMIs and snapshots.

---

# Real-Time Production Scenario

A company maintains a Golden AMI named **Server-Monitoring-v1.0** for all production web servers.

Whenever a new application server is required:

1. A new EC2 instance is launched from the Golden AMI.
2. The server already includes:
   - Apache Web Server
   - Monitoring tools
   - CloudWatch Agent
   - Required configurations
3. The instance joins the production environment within minutes.

This approach eliminates manual configuration and ensures all servers remain consistent.

---

# Interview Questions

## 1. What is an Amazon Machine Image (AMI)?

**Answer:**

An AMI is a pre-configured template containing the operating system, installed software, configuration, and boot information required to launch an EC2 instance.

---

## 2. What is the difference between an AMI and an EBS Snapshot?

**Answer:**

An AMI is used to launch EC2 instances and includes launch metadata. An EBS Snapshot is a backup of a single EBS volume and does not contain EC2 launch configuration.

---

## 3. Can one AMI launch multiple EC2 instances?

**Answer:**

Yes. A single AMI can be used to launch multiple EC2 instances with identical configurations.

---

## 4. Does deleting an AMI delete its snapshots?

**Answer:**

No. Deregistering an AMI removes the image registration, but associated EBS snapshots remain until they are deleted separately.

---

## 5. What is a Golden AMI?

**Answer:**

A Golden AMI is a standardized, fully configured, tested image that organizations use to launch consistent and secure EC2 instances.

---

# Cleanup

If you no longer need the resources created during testing, clean them up to avoid unnecessary charges.

## Deregister the AMI

```text
EC2
→ AMIs
→ Select Custom AMI
→ Actions
→ Deregister AMI
```

---

## Delete the Snapshot

```text
EC2
→ Snapshots
→ Select Snapshot
→ Delete
```

---

## Terminate the Test EC2 Instance

```text
EC2
→ Instances
→ Select Test Instance
→ Instance State
→ Terminate Instance
```

---

# Conclusion

In this document, we created a **Custom Amazon Machine Image (AMI)** from our fully configured monitoring server.

We learned how to:

- Understand Amazon Machine Images
- Create a Custom AMI
- Verify AMI creation
- Launch EC2 instances from an AMI
- Validate applications and monitoring
- Understand EBS Snapshot relationships
- Apply security, versioning, and cost optimization best practices

Our project now includes a reusable **Golden AMI**, allowing rapid deployment and faster disaster recovery for the complete monitoring environment.

---

# Screenshot Checklist

| Screenshot | File Name |
|------------|-----------|
| EC2 Instance | `01-ec2-instance.png` |
| AMIs Page | `02-ami-page.png` |
| Server Verification | `03-server-verification.png` |
| Select Instance | `04-select-instance.png` |
| Create Image Menu | `05-create-image-menu.png` |
| Image Settings | `06-image-settings.png` |
| Image Creating | `07-image-creating.png` |
| AMI Pending | `08-ami-pending.png` |
| EBS Snapshot | `09-ebs-snapshot.png` |
| AMI Available | `10-ami-available.png` |
| Launch from AMI | `11-launch-from-ami.png` |
| Instance Configuration | `12-instance-configuration.png` |
| Instance Running | `13-instance-running.png` |
| Website Working | `14-website-working.png` |
| CloudWatch Agent | `15-cloudwatch-agent.png` |
| Storage Verification | `16-storage-verification.png` |

---

# Project Progress

Our infrastructure is now fully standardized.

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
Rapid Recovery & Consistent Deployments
```

---

# Next Document

## 14-S3-Backup.md

In the next document, we will build an automated log backup solution that includes:

- Creating an S3 bucket for backups
- Writing a backup script
- Compressing Apache logs
- Uploading logs to Amazon S3
- Automating backups using Cron
- Verifying uploaded backup files
- Applying lifecycle policies for long-term storage

This will complete the **Log Backup** portion of the **AWS Project 1 – Server Monitoring & Log Backup System**.
