# Application Deployment

> **Project:** AWS Project 1 – Server Monitoring & Log Backup System

Deploying the **Prism Design Studio** application on an Amazon EC2 instance using the Apache HTTP Server.

---

## Table of Contents

* Introduction
* Deployment Overview
* Deployment Architecture
* Prerequisites
* Project Structure
* Deployment Workflow
* Deployment Methods
* Deployment Process
* Best Practices
* Security Considerations
* Common Deployment Issues
* Rollback Procedure
* Real-World Deployment Scenario
* Interview Questions
* Key Takeaways
* Summary
* Next Steps

---

## Introduction

Deployment is the process of transferring an application from a development environment to a production server where it becomes accessible to end users. A well-defined deployment process ensures consistency, minimizes errors, and simplifies future updates.

In this project, the **Prism Design Studio** application is deployed from the project repository to an **Amazon EC2** instance running **Apache HTTP Server**. The deployment process focuses on copying the application files, configuring the web server, verifying the deployment, and preparing the application for monitoring, logging, and backup using AWS services.

Unlike the previous document (**06-EC2.md**), which covered launching and configuring the EC2 instance, this guide assumes that the server is already operational and ready to host the application.

---

## Deployment Overview

The deployment process consists of the following stages:

1. Verify that the EC2 instance is running.
2. Access the EC2 instance using SSH.
3. Obtain the latest application source code.
4. Copy the application files to the Apache document root.
5. Configure file ownership and permissions.
6. Restart Apache to load the latest files.
7. Verify the application in a web browser.
8. Validate the deployment before proceeding with monitoring and backup.

The deployment workflow is designed to be repeatable and can be used whenever a new version of the application is released.

---

## Deployment Architecture

```text
                 Developer
                     │
                     ▼
            GitHub Repository
                     │
          (Clone / Download)
                     │
                     ▼
             Amazon EC2 Instance
             Amazon Linux 2023
                     │
                     ▼
            Apache HTTP Server
                     │
                     ▼
             /var/www/html/
                     │
                     ▼
        Prism Design Studio Website
                     │
                     ▼
              End Users (Browser)
```

---

## Prerequisites

Before deploying the application, ensure the following requirements are met.

### Infrastructure

* Amazon EC2 instance is running.
* Apache HTTP Server is installed and active.
* Security Group allows HTTP (Port 80).
* SSH access to the EC2 instance is available.

### Local Requirements

* Git installed
* SSH client
* Internet connectivity
* Access to the project repository

### Application Source

The application source code is stored in the project repository.

```text
AWS-Project-1-Server-Monitoring-System/
│
├── app/
│   ├── index.html
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── script.js
│   └── images/
│
├── docs/
├── scripts/
├── architecture/
├── screenshots/
└── assets/
```

Only the contents of the **app/** directory are deployed to the Apache web root.

---

## Project Structure After Deployment

After deployment, the Apache document root will contain the application files.

```text
/var/www/html/
│
├── index.html
├── css/
│   └── style.css
├── js/
│   └── script.js
└── images/
```

Apache serves these files directly to users when they access the EC2 Public IP address.

---

## Deployment Workflow

The following workflow describes the deployment process used in this project.

```text
Developer
     │
     ▼
Update Source Code
     │
     ▼
Push Changes to GitHub
     │
     ▼
Connect to Amazon EC2
     │
     ▼
Copy Application Files
     │
     ▼
Configure Permissions
     │
     ▼
Restart Apache
     │
     ▼
Verify Website
     │
     ▼
Production Ready
```

This workflow ensures that every deployment follows the same sequence, reducing the possibility of configuration errors.

---

## Deployment Methods

This project supports two deployment approaches.

### Method 1 – Deploy from Local Machine

The application files are copied directly from the local development machine to the EC2 instance using secure file transfer.

**Advantages:**

* Fast deployment
* Simple workflow
* Ideal for development and testing

### Method 2 – Deploy from GitHub Repository

The application source code is pulled directly from the GitHub repository onto the EC2 instance using Git.

**Advantages:**

* Version-controlled deployment
* Easier collaboration
* Suitable for production environments
* Simplifies application updates

This guide demonstrates both approaches so that you can choose the method best suited to your environment.

---

## Deployment Process

This section demonstrates how to deploy the **Prism Design Studio** application from the project repository to an Amazon EC2 instance running the Apache HTTP Server.

The deployment assumes that:

* Amazon EC2 is already running.
* Apache HTTP Server is installed and configured.
* Port **80 (HTTP)** is open in the Security Group.
* You can connect to the EC2 instance using SSH.

### Step 1 – Connect to the EC2 Instance

Connect to your EC2 instance using SSH.

```bash
ssh -i "aws-project.pem" ec2-user@<Public-IP>
```

Example:

```bash
ssh -i "aws-project.pem" ec2-user@13.xxx.xxx.xxx
```

Verify the connection.

```bash
hostname
```

Example Output:

```text
ip-172-31-23-118
```

---

### Step 2 – Clone the Project Repository

Navigate to your home directory.

```bash
cd ~
```

Clone the project repository.

```bash
git clone https://github.com/newton9979/Projects.git
```

Move into the project directory.

```bash
cd Projects/AWS_projects/AWS-Project-1-Server-Monitoring-System
```

Verify the repository.

```bash
tree -L 2
```

Expected Output:

```text
AWS-Project-1-Server-Monitoring-System
├── app
├── architecture
├── assets
├── cloudwatch
├── docs
├── screenshots
└── scripts
```

---

### Step 3 – Verify the Application Files

Navigate to the application directory.

```bash
cd app
```

List the application files.

```bash
tree
```

Expected Output:

```text
app/
├── index.html
├── css
│   └── style.css
├── js
│   └── script.js
└── images
```

Ensure all required files are available before deployment.

---

### Step 4 – Backup Existing Website

Before replacing the current website, create a backup.

Create a backup directory.

```bash
mkdir -p ~/backup
```

Copy the existing website.

```bash
sudo cp -r /var/www/html ~/backup/html-backup
```

Verify the backup.

```bash
tree ~/backup
```

Backing up the existing application allows you to restore the previous version if necessary.

---

### Step 5 – Remove Existing Website Files

Clean the Apache document root.

```bash
sudo rm -rf /var/www/html/*
```

Verify the directory is now empty.

```bash
ls -la /var/www/html
```

---

### Step 6 – Deploy the Application

Copy the application files to the Apache document root.

```bash
sudo cp -r app/* /var/www/html/
```

If you are already inside the `app/` directory, use:

```bash
sudo cp -r * /var/www/html/
```

---

### Step 7 – Configure Ownership

Assign ownership to the Apache service account.

```bash
sudo chown -R apache:apache /var/www/html
```

Verify ownership.

```bash
ls -l /var/www/html
```

Expected Output:

```text
apache apache index.html
apache apache css
apache apache js
apache apache images
```

---

### Step 8 – Configure File Permissions

Grant appropriate permissions.

Directories:

```bash
sudo find /var/www/html -type d -exec chmod 755 {} \;
```

Files:

```bash
sudo find /var/www/html -type f -exec chmod 644 {} \;
```

Verify permissions.

```bash
ls -lR /var/www/html
```

---

### Step 9 – Restart Apache

Restart Apache to load the new application.

```bash
sudo systemctl restart httpd
```

Verify the service.

```bash
sudo systemctl status httpd
```

Expected Status:

```text
Active: active (running)
```

---

### Step 10 – Verify Deployment

Open your browser and navigate to:

```text
http://<EC2-Public-IP>
```

Example:

```text
http://13.xxx.xxx.xxx
```

If the deployment is successful, the **Prism Design Studio** homepage will be displayed.

Verify:

* Homepage loads successfully.
* CSS styles are applied.
* JavaScript functionality works correctly.
* Images load without errors.
* Navigation links function as expected.

---

## Updating the Application

Whenever changes are made to the application:

Pull the latest code.

```bash
cd ~/Projects
git pull origin main
```

Copy the updated files.

```bash
sudo cp -r AWS_projects/AWS-Project-1-Server-Monitoring-System/app/* /var/www/html/
```

Restart Apache.

```bash
sudo systemctl restart httpd
```

Refresh the browser to verify the latest version.

---

## Deployment Verification Checklist

After deployment, confirm the following:

* ✅ Repository cloned successfully.
* ✅ Application files copied to `/var/www/html`.
* ✅ Ownership set to `apache:apache`.
* ✅ File permissions configured correctly.
* ✅ Apache restarted successfully.
* ✅ Website accessible using the EC2 Public IP.
* ✅ CSS, JavaScript, and images load correctly.
* ✅ Browser displays the Prism Design Studio homepage.

---

## Deployment Workflow Summary

```text
GitHub Repository
        │
        ▼
Clone Repository
        │
        ▼
Verify Application Files
        │
        ▼
Backup Existing Website
        │
        ▼
Copy Files to /var/www/html
        │
        ▼
Configure Ownership
        │
        ▼
Configure Permissions
        │
        ▼
Restart Apache
        │
        ▼
Verify Deployment
        │
        ▼
Website Available to Users
```

---

## Best Practices

Following a standardized deployment process improves application reliability, security, and maintainability. The following best practices are recommended for this project and production environments.

### 1. Maintain Source Code in GitHub

Always keep the latest version of the application in the GitHub repository instead of modifying files directly on the EC2 instance.

**Benefits:**

* Version control
* Easy rollback
* Team collaboration
* Deployment history

### 2. Backup Before Every Deployment

Before replacing application files, create a timestamped backup of the existing website.

```bash
sudo cp -r /var/www/html ~/backup/html-$(date +%F-%H-%M)
```

This allows quick recovery if deployment fails.

### 3. Use Proper File Permissions

Assign the correct ownership.

```bash
sudo chown -R apache:apache /var/www/html
```

Recommended permissions — directories: **755**, files: **644**. Never use `chmod -R 777` as it creates unnecessary security risks.

### 4. Verify Every Deployment

After each deployment, verify that the website loads successfully, CSS files are applied, JavaScript functions correctly, images load properly, Apache service is running, and the browser console contains no errors.

### 5. Monitor Application Health

After deployment, monitor the server using:

* Amazon CloudWatch Metrics
* CloudWatch Logs
* AWS CloudTrail
* Amazon SNS Alerts

### 6. Maintain Deployment Documentation

Document the deployment date, version, changes made, rollback procedure, and any known issues. Maintaining deployment records simplifies troubleshooting and auditing.

---

## Security Considerations

Secure deployments protect both the application and the underlying infrastructure.

**Recommended Practices:**

* Use SSH Key Pair authentication.
* Restrict SSH access to trusted IP addresses.
* Keep Amazon Linux updated.
* Use IAM Roles instead of AWS Access Keys.
* Enable HTTPS when using a custom domain.
* Review Security Group rules regularly.
* Avoid running services as the root user.

---

## Common Deployment Issues

### Issue 1 – Website Not Loading

**Possible Causes:** Apache service stopped, Port 80 blocked, incorrect Public IP, or files not copied.

**Solution:** Verify Apache status and confirm the Security Group allows HTTP traffic.

```bash
sudo systemctl status httpd
```

### Issue 2 – CSS Not Applied

**Possible Cause:** Incorrect CSS path. Verify the file exists at `/var/www/html/css/style.css` and use the browser Developer Tools to identify missing resources.

### Issue 3 – JavaScript Not Working

Verify the file exists at `/var/www/html/js/script.js` and review the browser console for JavaScript errors.

### Issue 4 – Images Not Displaying

Ensure all images exist inside `/var/www/html/images/` and verify file names match the HTML image paths.

### Issue 5 – Permission Denied

Correct ownership and permissions.

```bash
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
```

### Issue 6 – Repository Clone Failed

Verify internet connectivity, Git installation, the repository URL, and repository permissions (if private).

---

## Rollback Procedure

If a deployment introduces unexpected issues, restore the previous version of the application.

Navigate to the backup directory.

```bash
cd ~/backup
```

Remove the current deployment.

```bash
sudo rm -rf /var/www/html/*
```

Restore the backup.

```bash
sudo cp -r html-backup/* /var/www/html/
```

Restart Apache.

```bash
sudo systemctl restart httpd
```

Verify the application in a web browser. Rollback minimizes downtime and provides a safe recovery mechanism.

---

## Real-World Deployment Scenario

A software company develops a new version of its corporate website. The development team pushes the latest code to GitHub after completing testing.

A system administrator connects to an Amazon EC2 instance, pulls the latest changes, backs up the existing website, deploys the updated application to the Apache document root, configures permissions, restarts the web server, and verifies the deployment.

After deployment:

* Amazon CloudWatch monitors server performance.
* AWS CloudTrail records infrastructure-related API activity.
* Amazon SNS sends alerts if resource thresholds are exceeded.
* Amazon S3 stores application log backups.
* Amazon AMI provides disaster recovery.
* Amazon EBS stores persistent application data.

This workflow closely resembles deployment practices used in production environments.

---

## Interview Questions

### Basic

1. What is application deployment?
2. What is the Apache document root?
3. Why is `/var/www/html` used?
4. How do you restart Apache?
5. Why are file permissions important?

### Intermediate

6. How do you deploy a static website to Amazon EC2?
7. What is the difference between SCP and Git deployment?
8. Why should you back up an application before deployment?
9. How do you troubleshoot a website that is not loading?
10. How do you verify a successful deployment?

### Advanced

11. Explain a blue-green deployment strategy.
12. What is a rolling deployment?
13. How would you automate deployments using a CI/CD pipeline?
14. How would you secure a production deployment?
15. How would you monitor deployments using Amazon CloudWatch?
16. How would you recover from a failed deployment?
17. How do IAM Roles improve deployment security?
18. How would you deploy a new application version with minimal downtime?
19. What AWS services support deployment automation?
20. Explain the complete deployment workflow used in this project.

---

## Key Takeaways

After completing this document, you should be able to:

* Deploy a static web application to Amazon EC2.
* Organize application files within the Apache document root.
* Configure ownership and permissions correctly.
* Verify successful deployments.
* Perform application updates safely.
* Roll back to a previous version when necessary.
* Apply deployment best practices.
* Troubleshoot common deployment issues.
* Prepare the application for monitoring and backup using AWS services.

---

## Summary

This document demonstrated the complete deployment lifecycle for the **Prism Design Studio** application within the **AWS Project 1 – Server Monitoring & Log Backup System**.

The deployment process covered obtaining the application source code, copying files to the Apache document root, configuring ownership and permissions, restarting the web server, and verifying that the application was successfully deployed.

By separating **infrastructure setup (EC2)** from **application deployment**, the project follows a modular documentation approach that closely reflects real-world DevOps practices. This separation improves maintainability, simplifies future updates, and makes the deployment process repeatable.

The deployed application now serves as the workload for the remaining phases of the project. In the upcoming sections, additional AWS services—including Amazon EBS, Amazon EFS, Amazon CloudWatch, Amazon SNS, Amazon S3, and Amazon AMI—will be integrated to build a secure, monitored, and resilient cloud environment.

---

## Next Steps

With the application successfully deployed, continue with the next document in the project:

**📄 08-EBS.md**

Topics covered:

* Amazon EBS Overview
* Create an EBS Volume
* Attach the Volume to EC2
* Format the Volume
* Mount the File System
* Configure Persistent Mount (`/etc/fstab`)
* Verify the Storage
* Real-World Use Cases
* Best Practices
* Troubleshooting
* Interview Questions
* Summary
