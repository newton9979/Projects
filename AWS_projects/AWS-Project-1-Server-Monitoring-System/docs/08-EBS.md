# Amazon EBS (Elastic Block Store)

> **Project:** AWS Project 1 – Server Monitoring & Log Backup System

Learn how to create, attach, configure, and manage Amazon EBS volumes to provide persistent block storage for Amazon EC2 instances.

---

## Table of Contents

* Introduction
* What is Amazon EBS?
* Why Amazon EBS?
* Key Features
* Amazon EBS Architecture
* Volume Types
* EBS Snapshots
* EBS vs Instance Store
* Use Cases
* Pricing
* Project Architecture
* Prerequisites
* Implementation Workflow
* Deployment Process
* Best Practices
* Security Best Practices
* Cost Optimization
* Real-World Scenario
* Common Troubleshooting
* Interview Questions
* Key Takeaways
* Summary
* Next Document

---

## Introduction

Amazon Elastic Block Store (Amazon EBS) is a high-performance block storage service designed for use with Amazon EC2 instances. It provides persistent storage that remains available even if an EC2 instance is stopped or restarted.

Unlike the root volume of an EC2 instance, additional EBS volumes can be attached to expand storage capacity without replacing the server. This makes Amazon EBS an ideal solution for hosting application data, databases, log files, backups, and other persistent workloads.

In this project, Amazon EBS is used to provide additional storage for the web server. The attached volume can be used for application data, log storage, or future project requirements.

---

## What is Amazon EBS?

Amazon Elastic Block Store (EBS) is a durable block storage service that provides virtual hard disks for Amazon EC2 instances. Each EBS volume behaves like a physical storage disk attached to a server.

After attaching the volume to an EC2 instance, it can be partitioned, formatted, mounted, and used like a local disk. Unlike temporary instance storage, Amazon EBS preserves data even when an EC2 instance is stopped.

---

## Why Amazon EBS?

Amazon EBS provides reliable and scalable storage for cloud applications.

**Benefits:**

* Persistent storage
* High availability
* High durability
* Easy volume expansion
* Snapshot support
* Encryption support
* High performance
* Integration with EC2
* Backup and disaster recovery

---

## Key Features

### Persistent Storage

Data remains available after stopping or restarting an EC2 instance.

### High Availability

Amazon EBS automatically replicates data within the same Availability Zone to protect against hardware failures.

### Snapshots

Create point-in-time backups of EBS volumes using Amazon EBS Snapshots stored in Amazon S3.

### Encryption

EBS volumes can be encrypted using AWS Key Management Service (KMS) without affecting application performance.

### Scalability

Storage size and performance can be increased with minimal downtime.

### Performance

Amazon EBS provides low-latency storage suitable for production workloads.

---

## Amazon EBS Architecture

```text
                    AWS Region
                         │
        ┌─────────────────────────────────┐
        │                                 │
        │       Availability Zone         │
        │                                 │
        │     Amazon EC2 Instance         │
        │             │                   │
        │             │                   │
        │      Root EBS Volume            │
        │             │                   │
        │             │                   │
        │      Additional EBS Volume      │
        │             │                   │
        └─────────────┼───────────────────┘
                      │
                      ▼
              Mounted File System
                      │
                      ▼
         Application Data / Logs / Backups
```

---

## Amazon EBS Volume Types

Amazon EBS offers different volume types based on workload requirements.

| Volume Type | Best For                 | Description                                                         |
| ----------- | ------------------------ | ------------------------------------------------------------------- |
| gp3         | General Purpose          | Recommended for most workloads with independent performance tuning. |
| gp2         | General Purpose          | Previous-generation SSD volume.                                     |
| io2         | High Performance         | Mission-critical applications requiring high IOPS and durability.   |
| io1         | Provisioned IOPS         | Legacy high-performance SSD volume.                                 |
| st1         | Throughput Optimized HDD | Frequently accessed large datasets.                                 |
| sc1         | Cold HDD                 | Infrequently accessed data with the lowest storage cost.            |

**Recommended for This Project:**

| Setting     | Value                 |
| ----------- | --------------------- |
| Volume Type | gp3                   |
| Size        | 10 GB                 |
| Encryption  | Enabled (Recommended) |

---

## Amazon EBS Snapshots

Snapshots are incremental backups of EBS volumes.

Benefits include disaster recovery, data protection, volume restoration, migration, and backup automation. Snapshots are stored in Amazon S3 and can be used to create new EBS volumes whenever needed.

---

## Amazon EBS vs Instance Store

| Feature            | Amazon EBS  | Instance Store |
| ------------------ | ----------- | -------------- |
| Persistent         | ✅ Yes       | ❌ No           |
| Stop/Start Support | ✅ Yes       | ❌ Data Lost    |
| Snapshot Support   | ✅ Yes       | ❌ No           |
| Encryption         | ✅ Supported | Limited        |
| Resize Volume      | ✅ Yes       | ❌ No           |
| Backup             | ✅ Easy      | ❌ Difficult    |
| Recommended        | Production  | Temporary Data |

---

## Real-World Use Cases

Amazon EBS is widely used for web servers, database servers, application servers, log storage, file storage, backup storage, virtual machines, and enterprise applications.

In this project, the additional EBS volume can store Apache logs, application logs, backup files, future project data, and monitoring data generated by CloudWatch.

---

## Pricing

Amazon EBS pricing depends on volume type, provisioned storage (GB), provisioned IOPS (if applicable), snapshot storage, and data transfer.

**Cost Optimization Tips:**

* Use **gp3** for general-purpose workloads.
* Delete unused volumes.
* Remove outdated snapshots.
* Monitor storage usage regularly.
* Resize volumes only when required.

---

## Project Architecture

```text
                     Internet
                         │
                         ▼
                  User Browser
                         │
                         ▼
                  Apache Web Server
                         │
                         ▼
                 Amazon EC2 Instance
                (Amazon Linux 2023)
                 ┌─────────┴─────────┐
                 │                   │
                 ▼                   ▼
         Root EBS Volume      Additional EBS Volume
          Operating System    Logs / Backups / Data
                 │                   │
                 └─────────┬─────────┘
                           ▼
                 AWS Project Services
        CloudWatch • CloudTrail • S3 • SNS
```

---

## Prerequisites

### AWS Requirements

* AWS Account
* Running Amazon EC2 instance
* Appropriate IAM permissions
* Amazon VPC configured

### EC2 Requirements

* EC2 instance is in the **Running** state.
* SSH access is working.
* Root EBS volume is healthy.
* Security Group is configured correctly.

### Knowledge Requirements

Basic understanding of Linux commands, EC2, SSH, file systems, and mount points.

---

## Implementation Workflow

```text
Create EBS Volume
        │
        ▼
Attach Volume to EC2
        │
        ▼
Verify New Disk
        │
        ▼
Create Partition
        │
        ▼
Format File System
        │
        ▼
Create Mount Point
        │
        ▼
Mount Volume
        │
        ▼
Verify Storage
        │
        ▼
Configure Persistent Mount
```

---

## Deployment Process

### Step 1 – Create an Amazon EBS Volume

Navigate to: AWS Console → EC2 Dashboard → Elastic Block Store → Volumes → Create Volume

Use the following configuration:

| Setting           | Value                 |
| ----------------- | --------------------- |
| Volume Type       | gp3                   |
| Size              | 10 GiB                |
| Availability Zone | Same as EC2 Instance  |
| Snapshot          | None                  |
| Encryption        | Enabled (Recommended) |

> **Important:** The EBS volume **must** be created in the **same Availability Zone** as the EC2 instance. Otherwise, it cannot be attached.

Click **Create Volume**.

![Create EBS Volume](screenshots/EBS/01-Create-Volume.png)

---

### Step 2 – Verify the Volume

After creation, verify the volume details.

| Property   | Example   |
| ---------- | --------- |
| State      | Available |
| Size       | 10 GiB    |
| Type       | gp3       |
| Attachment | None      |

The volume status should display `Available`.

![Volume Created](screenshots/EBS/02-Volume-Created.png)

---

### Step 3 – Attach the Volume

Select the newly created volume, then choose Actions → Attach Volume. Select your EC2 instance and set the device name to the recommended value:

```text
/dev/xvdf
```

Click **Attach Volume**.

![Attach Volume](screenshots/EBS/03-Attach-Volume.png)

---

### Step 4 – Connect to the EC2 Instance

```bash
ssh -i "aws-project.pem" ec2-user@<Public-IP>
```

Verify the connection.

```bash
hostname
```

---

### Step 5 – Verify the Attached Disk

List block devices.

```bash
lsblk
```

Example Output:

```text
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk
└─xvda1 202:1    0   8G  0 part /

xvdf    202:80   0  10G  0 disk
```

Notice that **xvdf** has no partition and no mount point. You can also verify using:

```bash
sudo fdisk -l
```

![lsblk Output](screenshots/EBS/04-lsblk.png)

---

### Step 6 – Create a Partition

Launch the partition utility.

```bash
sudo fdisk /dev/xvdf
```

Create a new partition using the following commands:

```text
n
p
1


w
```

| Command | Purpose              |
| ------- | -------------------- |
| n       | New partition        |
| p       | Primary partition    |
| 1       | Partition number     |
| Enter   | Default first sector |
| Enter   | Default last sector  |
| w       | Save changes         |

![fdisk Partition](screenshots/EBS/05-fdisk.png)

---

### Step 7 – Verify the Partition

```bash
lsblk
```

Example:

```text
NAME    SIZE TYPE
xvda      8G disk
└─xvda1   8G part /

xvdf     10G disk
└─xvdf1  10G part
```

The partition **xvdf1** is now available.

---

### Step 8 – Format the Partition

Create an XFS file system (recommended for Amazon Linux 2023).

```bash
sudo mkfs -t xfs /dev/xvdf1
```

Alternatively, use EXT4.

```bash
sudo mkfs.ext4 /dev/xvdf1
```

Verify:

```bash
sudo blkid
```

Example Output:

```text
/dev/xvdf1: UUID="xxxxxxxx-xxxx-xxxx" TYPE="xfs"
```

![Format File System](screenshots/EBS/06-mkfs.png)

---

### Step 9 – Create a Mount Point

```bash
sudo mkdir /data
```

Verify.

```bash
ls /
```

The `/data` directory should now appear in the output.

---

### Step 10 – Mount the Volume

```bash
sudo mount /dev/xvdf1 /data
```

Verify.

```bash
df -h
```

Example Output:

```text
Filesystem      Size Used Avail Use% Mounted on
/dev/xvda1      8G   2G    6G   25% /
/dev/xvdf1     10G  100M  10G    1% /data
```

The EBS volume is now mounted successfully.

![Mount Volume](screenshots/EBS/07-mount.png)

---

### Step 11 – Configure Automatic Mount

Retrieve the UUID.

```bash
sudo blkid
```

Open the fstab file.

```bash
sudo vi /etc/fstab
```

Append the following line (replace with your actual UUID):

```text
UUID=xxxxxxxx-xxxx-xxxx   /data   xfs   defaults,nofail   0   2
```

Save and exit.

![fstab Configuration](screenshots/EBS/09-fstab.png)

---

### Step 12 – Verify the Configuration

Reload the mount table.

```bash
sudo mount -a
```

If no error appears, the configuration is correct. Verify:

```bash
df -h
```

Restart the instance to confirm the persistent mount survives a reboot.

```bash
sudo reboot
```

After reconnecting, run `df -h` again. The volume should still be mounted at `/data`.

![df -h Output](screenshots/EBS/08-df-h.png)

---

### Step 13 – Test the Volume

Navigate to the mounted directory.

```bash
cd /data
```

Create a test file and write data to it.

```bash
touch ebs-test.txt
echo "Amazon EBS Working Successfully" > ebs-test.txt
cat ebs-test.txt
```

Expected Output:

```text
Amazon EBS Working Successfully
```

---

## Useful Commands

| Command               | Description                          |
| --------------------- | ------------------------------------ |
| `lsblk`               | Check block devices                  |
| `sudo fdisk -l`       | View partitions                      |
| `df -h`               | Display mounted file systems         |
| `sudo blkid`          | Display UUID information             |
| `sudo mount -a`       | Mount all entries from `/etc/fstab`  |
| `sudo umount /data`   | Unmount the volume                   |
| `du -sh /data`        | View disk usage                      |

---

## Verification Checklist

After completing the implementation, verify the following:

* ✅ EBS volume created.
* ✅ Volume attached to EC2.
* ✅ Disk detected using `lsblk`.
* ✅ Partition created successfully.
* ✅ File system formatted.
* ✅ Mount point created.
* ✅ Volume mounted successfully.
* ✅ `/etc/fstab` configured.
* ✅ Persistent mount verified after reboot.
* ✅ Test file created successfully.

---

## Best Practices

### 1. Use gp3 Volumes

For most workloads, **gp3** provides the best balance of performance, scalability, and cost. It is the recommended volume type for this project.

### 2. Enable Encryption

Always encrypt EBS volumes using **AWS Key Management Service (AWS KMS)**. This protects sensitive data, meets compliance requirements, and has no noticeable performance impact.

### 3. Create Regular Snapshots

Schedule regular snapshots to protect against accidental deletion or corruption. Snapshots support disaster recovery, point-in-time restoration, and backup automation.

### 4. Monitor Volume Performance

Use Amazon CloudWatch to monitor Read/Write Operations, Read/Write Latency, Queue Length, and Burst Balance. Monitoring helps identify storage bottlenecks before they affect applications.

### 5. Avoid Unused Volumes

Delete unattached EBS volumes that are no longer required. Unused volumes continue to incur storage charges.

### 6. Use Meaningful Tags

| Key         | Value         |
| ----------- | ------------- |
| Name        | Project1-EBS  |
| Project     | AWS Project 1 |
| Environment | Lab           |
| Owner       | Newton        |

### 7. Use Separate Volumes

Avoid storing everything on the root volume. Recommended layout:

```text
/ (Root Volume)
│
├── Operating System
├── Apache
└── System Files

/data (Additional EBS)
│
├── Application Data
├── Apache Logs
├── Backup Files
└── Monitoring Data
```

This separation improves maintainability and simplifies backup strategies.

---

## Security Best Practices

* Enable EBS encryption.
* Restrict IAM permissions using least privilege.
* Avoid public snapshots unless absolutely necessary.
* Regularly audit snapshots and volumes.
* Delete unused snapshots.
* Monitor API activity with AWS CloudTrail.
* Monitor storage health with Amazon CloudWatch.

---

## Cost Optimization

Choose **gp3** unless higher performance is required. Delete unattached volumes, remove obsolete snapshots, and resize volumes only when necessary. Monitor storage utilization before increasing capacity. For development or lab environments, stop EC2 instances when not in use to reduce overall project costs.

---

## Real-World Scenario

A software company hosts its web application on Amazon EC2. Initially, the root volume contains both the operating system and application logs. As traffic increases, log files grow rapidly and consume most of the available storage, affecting server performance.

To solve this issue, the operations team creates a new Amazon EBS volume, attaches it to the EC2 instance, mounts it at `/data`, stores application logs and backup files on the new volume, configures automatic snapshots, and monitors disk usage using Amazon CloudWatch.

This approach separates application data from the operating system, improves performance, simplifies backups, and makes future storage expansion easier.

---

## Common Troubleshooting

### Issue 1 – Volume Not Visible

**Symptom:** `lsblk` does not display the new disk.

**Solution:** Verify the volume is attached, ensure the correct Availability Zone, and reattach the volume if necessary.

### Issue 2 – Mount Failed

**Symptom:** `mount: wrong fs type`

**Solution:** Verify that the partition has been formatted using `sudo blkid`. If no filesystem is present, format the partition again.

### Issue 3 – Volume Missing After Reboot

**Cause:** `/etc/fstab` is not configured correctly.

**Solution:** Verify the UUID with `sudo blkid`, then test the configuration with `sudo mount -a`. If no errors appear, the configuration is correct.

### Issue 4 – Permission Denied

Check the mount point ownership.

```bash
ls -ld /data
```

Correct ownership if required.

```bash
sudo chown -R ec2-user:ec2-user /data
```

### Issue 5 – No Free Disk Space

Check available storage with `df -h` and identify large files with `du -sh /data/*`. Delete unnecessary files or increase the EBS volume size.

---

## Interview Questions

### Beginner

1. What is Amazon EBS?
2. What is block storage?
3. Is Amazon EBS persistent?
4. Can one EBS volume be attached to multiple EC2 instances?
5. What is an EBS Snapshot?

### Intermediate

6. What is the difference between gp2 and gp3?
7. Why must an EBS volume be in the same Availability Zone as the EC2 instance?
8. Explain the steps to attach an EBS volume.
9. Why is `/etc/fstab` used?
10. How do you verify a mounted volume?

### Advanced

11. Explain EBS encryption.
12. How do you increase the size of an existing EBS volume?
13. What happens if an EC2 instance is stopped?
14. What happens if an EC2 instance is terminated?
15. How do snapshots support disaster recovery?
16. Explain the difference between EBS and EFS.
17. How does CloudWatch monitor EBS performance?
18. What is the purpose of UUID in `/etc/fstab`?
19. How would you migrate data from one EBS volume to another?
20. Describe a production use case for Amazon EBS.

---

## Key Takeaways

After completing this chapter, you should be able to:

* Explain Amazon EBS and its architecture.
* Select the appropriate EBS volume type.
* Create and attach an EBS volume.
* Partition and format a Linux disk.
* Mount an EBS volume.
* Configure automatic mounting after reboot.
* Verify storage using Linux commands.
* Troubleshoot common EBS issues.
* Apply security and cost optimization best practices.

---

## Summary

Amazon Elastic Block Store (Amazon EBS) provides durable, high-performance block storage for Amazon EC2 instances and is a fundamental service for running production workloads on AWS.

In this project, an additional EBS volume was created, attached to an existing EC2 instance, partitioned, formatted, mounted, and configured for persistent mounting using `/etc/fstab`. This additional storage can be used for application data, Apache logs, monitoring information, and backups, keeping the operating system separate from project data.

By following AWS and Linux best practices—including encryption, regular snapshots, CloudWatch monitoring, and proper permissions—you can build a secure and scalable storage solution.

---

## Next Document

**📄 09-EFS.md**

Topics include:

* Introduction to Amazon EFS
* EFS Architecture
* EFS vs EBS
* Create an EFS File System
* Configure Mount Targets
* Mount EFS on EC2
* Persistent Mount Configuration
* Real-World Use Cases
* Best Practices
* Troubleshooting
* Interview Questions
* Summary

