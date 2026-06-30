# Amazon SNS (Simple Notification Service)

## Objective

In this section, we will configure **Amazon Simple Notification Service (SNS)** to send real-time email notifications whenever a CloudWatch Alarm detects an issue with our EC2 instance.

By the end of this guide, you will learn how to:

- Understand Amazon SNS
- Create an SNS Topic
- Create an Email Subscription
- Confirm the Subscription
- Integrate SNS with CloudWatch Alarms
- Test Email Notifications
- Apply production best practices

---

# Prerequisites

Before proceeding, ensure the following components have already been configured.

- AWS Account
- Running EC2 Instance
- IAM Role attached to EC2
- CloudWatch Agent installed
- CloudWatch Metrics available
- CloudWatch Dashboard created
- CloudWatch Alarm configured

> **Note**
>
> This document continues from **11-CloudWatch-Alarms.md**.

---

# What is Amazon SNS?

Amazon Simple Notification Service (Amazon SNS) is a fully managed messaging service that enables applications and AWS services to send notifications to multiple subscribers.

SNS follows a **Publish/Subscribe (Pub/Sub)** messaging model.

A publisher sends a message to an SNS Topic, and SNS automatically delivers the message to all subscribed endpoints.

Supported endpoints include:

- Email
- SMS
- AWS Lambda
- HTTP/HTTPS
- Amazon SQS
- Mobile Push Notifications

In this project, we will use **Email Notifications**.

---

# Why Are We Using SNS in This Project?

Our project focuses on **Server Monitoring & Log Backup**.

CloudWatch can detect server issues, but administrators also need to be notified immediately.

Amazon SNS provides that notification mechanism.

When CloudWatch detects:

- High CPU Utilization
- High Memory Usage
- Low Disk Space
- EC2 Status Check Failure

SNS sends an email to the administrator.

This allows rapid response without continuously monitoring the AWS Console.

---

# Key Components of Amazon SNS

Amazon SNS consists of three main components.

## 1. Topic

A Topic is a communication channel.

Publishers send messages to a Topic.

Example:

```
Server-Monitoring-Alerts
```

---

## 2. Publisher

The Publisher sends messages to the SNS Topic.

In our project:

```
Amazon CloudWatch Alarm
```

acts as the Publisher.

---

## 3. Subscriber

Subscribers receive notifications from the SNS Topic.

In this project:

```
Administrator Email
```

is the Subscriber.

---

# SNS Workflow

```text
CloudWatch Alarm
        │
        ▼
    SNS Topic
        │
        ▼
 Email Subscription
        │
        ▼
 Administrator
```

Whenever the CloudWatch Alarm enters the **ALARM** state, a notification is published to the SNS Topic and delivered to all confirmed subscribers.

---

# Architecture Overview

```text
                Amazon EC2
                     │
                     ▼
        CloudWatch Agent Collects Metrics
                     │
                     ▼
          Amazon CloudWatch Metrics
                     │
                     ▼
          CloudWatch Alarm Evaluates
                     │
              Threshold Exceeded
                     │
                     ▼
             Amazon SNS Topic
                     │
          Email Subscription
                     │
                     ▼
         Administrator Receives Email
```

---

# Architecture Diagram

<p align="center">
  <img src="../architecture/aws-project-1-architecture.png" width="900" alt="Amazon SNS Architecture">
</p>

---

# Real-Time Production Scenarios: Why SNS Matters

## Scenario 1: High CPU Utilization

A production web application experiences a sudden increase in traffic.

CPU utilization exceeds 80%.

CloudWatch Alarm changes to the **ALARM** state.

Amazon SNS immediately sends an email notification to the DevOps team.

The team investigates and scales the application before users experience slow response times.

---

## Scenario 2: Low Disk Space

Application logs continue growing throughout the day.

Disk utilization reaches 90%.

CloudWatch Alarm publishes a notification to Amazon SNS.

Administrators archive old logs to Amazon S3 and expand the EBS volume before the server runs out of storage.

---

## Scenario 3: Apache Web Server Failure

The Apache service stops unexpectedly.

CloudWatch detects the issue through monitoring and log analysis.

Amazon SNS sends an email notification.

The support team restarts the service, minimizing downtime.

---

## Scenario 4: Security Monitoring

Multiple failed SSH login attempts are detected.

CloudWatch Logs collect authentication events.

CloudWatch Alarm identifies abnormal activity.

Amazon SNS immediately notifies the security team for further investigation.

---

# Benefits of Amazon SNS

Using Amazon SNS provides several advantages.

- Near real-time notifications
- Fully managed AWS service
- Supports multiple notification protocols
- Easy integration with CloudWatch
- Improves incident response time
- Highly scalable
- Reliable message delivery

---

# Screenshots

## Amazon SNS Home

<p align="center">
  <img src="../screenshots/SNS/01-sns-home.png" width="900" alt="Amazon SNS Home">
</p>

---

## SNS Dashboard Overview

<p align="center">
  <img src="../screenshots/SNS/02-sns-dashboard.png" width="900" alt="Amazon SNS Dashboard">
</p>

---

## Concepts Summary

At this point, you have learned:

- ✔ What Amazon SNS is
- ✔ Why SNS is used in this project
- ✔ SNS Topics, Publishers, and Subscribers
- ✔ SNS workflow
- ✔ Real-world production scenarios
- ✔ Benefits of Amazon SNS

Next, we will create an SNS Topic, create an email subscription, confirm the subscription, verify the topic, and prepare SNS for CloudWatch Alarm integration.

---

# Create an Amazon SNS Topic and Email Subscription

In this section, we will create an Amazon SNS Topic, subscribe an email address, and verify the subscription.

After completing this section, Amazon SNS will be ready to receive notifications from CloudWatch Alarms.

---

# Step 1: Open the Amazon SNS Console

1. Sign in to the **AWS Management Console**.
2. Search for **Simple Notification Service (SNS)**.
3. Open the **Amazon SNS Console**.
4. From the left navigation pane, select **Topics**.

Click **Create topic**.

<p align="center">
  <img src="../screenshots/SNS/03-create-topic.png" width="900" alt="Create Amazon SNS Topic">
</p>

---

# Step 2: Create an SNS Topic

Configure the topic with the following settings.

| Setting | Value |
|----------|-------|
| Type | Standard |
| Name | Server-Monitoring-Alerts |
| Display Name | (Optional) Server Alerts |

Click **Create topic**.

> **Why Standard?**
>
> Standard topics provide high throughput and are suitable for monitoring and alerting workloads. FIFO topics are designed for ordered message processing and are not required for this project.

<p align="center">
  <img src="../screenshots/SNS/04-topic-created.png" width="900" alt="Amazon SNS Topic Created">
</p>

---

# Step 3: Create an Email Subscription

Open the newly created topic.

Select the **Subscriptions** tab.

Click **Create subscription**.

Configure the subscription as follows.

| Setting | Value |
|----------|-------|
| Protocol | Email |
| Endpoint | your-email@example.com |

Replace **your-email@example.com** with your email address.

Click **Create subscription**.

<p align="center">
  <img src="../screenshots/SNS/05-create-subscription.png" width="900" alt="Create SNS Email Subscription">
</p>

---

# Step 4: Confirm the Email Subscription

Amazon SNS immediately sends a confirmation email to the subscribed address.

Open your email inbox.

Locate the message from Amazon SNS.

Click the **Confirm subscription** link.

> **Important**
>
> Until the subscription is confirmed, Amazon SNS cannot deliver notifications to your email address.

<p align="center">
  <img src="../screenshots/SNS/06-confirm-email.png" width="900" alt="SNS Confirmation Email">
</p>

---

# Step 5: Verify the Subscription

Return to the Amazon SNS Console.

Navigate to:

```text
SNS
→ Topics
→ Server-Monitoring-Alerts
→ Subscriptions
```

Verify that the subscription status is:

```text
Confirmed
```

<p align="center">
  <img src="../screenshots/SNS/07-subscription-confirmed.png" width="900" alt="SNS Subscription Confirmed">
</p>

---

# Step 6: Test the SNS Topic

Open the SNS Topic.

Click **Publish message**.

Enter the following sample message.

**Subject**

```text
Test Notification
```

**Message**

```text
This is a test notification from Amazon SNS.

If you received this email, your SNS topic and email subscription are working correctly.
```

Click **Publish message**.

<p align="center">
  <img src="../screenshots/SNS/08-publish-message.png" width="900" alt="Publish Test Message">
</p>

---

# Step 7: Verify Email Delivery

Check your email inbox.

You should receive the test notification from Amazon SNS.

This confirms:

- SNS Topic is working.
- Email Subscription is confirmed.
- Notifications are delivered successfully.

<p align="center">
  <img src="../screenshots/SNS/09-test-email.png" width="900" alt="SNS Test Email Received">
</p>

---

# Real-Time Production Scenario: Peak Traffic Event

A company's production application runs on Amazon EC2.

During a peak traffic event:

- CPU utilization exceeds 80%.
- CloudWatch Alarm changes to the **ALARM** state.
- The alarm publishes a message to the **Server-Monitoring-Alerts** SNS Topic.
- Amazon SNS instantly delivers an email notification to the operations team.
- Engineers investigate the issue and scale the infrastructure before customers experience downtime.

This workflow enables proactive monitoring and rapid incident response.

---

# Best Practices

- Use meaningful topic names such as **Server-Monitoring-Alerts**.
- Confirm every subscription before testing.
- Use distribution lists or team email addresses for production alerts.
- Separate alert topics by environment (Development, Testing, Production).
- Periodically review and remove unused subscriptions.
- Protect SNS topics with appropriate IAM permissions.

---

## Topic & Subscription Summary

At this point, you have:

- ✔ Created an Amazon SNS Topic
- ✔ Configured an Email Subscription
- ✔ Confirmed the subscription
- ✔ Published a test message
- ✔ Verified email delivery
- ✔ Learned a production monitoring use case

Next, we will connect the **CloudWatch Alarm** created in the previous document to the **SNS Topic**, trigger an alarm, receive real email notifications, and complete the end-to-end monitoring and alerting workflow.

> **Note:** Since this repository also includes a `scripts/` directory, the AWS CLI Commands section later in this document shows how to create an SNS topic, list topics, publish a message, and delete a topic — useful if you want to automate this setup instead of using the console.

---

# Integrate CloudWatch Alarms with Amazon SNS

In this section, we will connect the CloudWatch Alarm created in the previous document to our Amazon SNS Topic.

When the alarm enters the **ALARM** state, Amazon SNS will automatically send an email notification to the subscribed administrator.

---

# Complete Monitoring Workflow

```text
                Amazon EC2
                     │
                     ▼
         CloudWatch Agent Collects Metrics
                     │
                     ▼
          Amazon CloudWatch Metrics
                     │
                     ▼
         CloudWatch Alarm Evaluation
                     │
          CPU > 80% (Threshold)
                     │
                     ▼
        Amazon SNS Topic Publishes Message
                     │
                     ▼
          Email Subscription Receives Alert
                     │
                     ▼
          Administrator Takes Action
```

---

# Step 8: Open the Existing CloudWatch Alarm

Navigate to:

```text
CloudWatch
→ Alarms
→ All Alarms
```

Select the alarm created in the previous document.

Example:

```
EC2-High-CPU-Alarm
```

Click **Actions → Edit**.

<p align="center">
  <img src="../screenshots/SNS/10-edit-alarm.png" width="900" alt="Edit CloudWatch Alarm">
</p>

---

# Step 9: Configure the Alarm Action

Locate the **Notification** section.

Configure the following settings.

| Setting | Value |
|----------|-------|
| Alarm State Trigger | In Alarm |
| Send Notification To | Existing SNS Topic |
| Topic | Server-Monitoring-Alerts |

Save the changes.

<p align="center">
  <img src="../screenshots/SNS/11-attach-sns-topic.png" width="900" alt="Attach SNS Topic to CloudWatch Alarm">
</p>

---

# Step 10: Verify Alarm Configuration

Open the alarm details.

Verify that the **Notification Action** displays:

```text
Server-Monitoring-Alerts
```

This confirms that CloudWatch will publish notifications to the SNS Topic whenever the alarm enters the **ALARM** state.

<p align="center">
  <img src="../screenshots/SNS/12-alarm-action.png" width="900" alt="Alarm Notification Configuration">
</p>

---

# Step 11: Trigger the Alarm

Connect to the EC2 instance.

Generate CPU load using the following command.

```bash
stress --cpu 2 --timeout 300
```

The CPU utilization should increase above the configured threshold.

CloudWatch evaluates the metric and changes the alarm state from:

```text
OK
        │
        ▼
ALARM
```

<p align="center">
  <img src="../screenshots/SNS/13-trigger-alarm.png" width="900" alt="Trigger CloudWatch Alarm">
</p>

---

# Step 12: Verify the Email Notification

After the alarm enters the **ALARM** state:

Open your email inbox.

You should receive a notification similar to:

**Subject**

```text
ALARM: "EC2-High-CPU-Alarm" in Asia Pacific (Mumbai)
```

The email includes:

- Alarm Name
- AWS Region
- Metric Name
- Current Metric Value
- Threshold
- Alarm State
- Timestamp

<p align="center">
  <img src="../screenshots/SNS/14-email-alert.png" width="900" alt="CloudWatch Alarm Email Notification">
</p>

---

# Step 13: Verify Recovery Notification

When the stress test completes:

CPU utilization returns to normal.

CloudWatch automatically changes the alarm state:

```text
ALARM
        │
        ▼
OK
```

If **OK notifications** are configured, Amazon SNS sends another email indicating that the alarm has returned to a healthy state.

<p align="center">
  <img src="../screenshots/SNS/15-alarm-recovery.png" width="900" alt="Alarm Recovery Notification">
</p>

---

# End-to-End Verification

The monitoring pipeline is now complete.

| Component | Status |
|-----------|--------|
| EC2 Instance | ✅ Running |
| CloudWatch Agent | ✅ Collecting Metrics |
| CloudWatch Metrics | ✅ Available |
| CloudWatch Alarm | ✅ Monitoring |
| Amazon SNS Topic | ✅ Configured |
| Email Subscription | ✅ Confirmed |
| Email Notification | ✅ Delivered |

---

# Real-Time Production Scenarios: End-to-End Pipeline

## Scenario 1: High CPU Usage

A web application receives unexpected traffic.

CloudWatch Alarm detects CPU utilization above 80%.

Amazon SNS immediately emails the DevOps team.

Engineers scale the application before users notice performance issues.

---

## Scenario 2: Critical Disk Usage

Application logs consume nearly all available disk space.

The disk usage alarm publishes a message to Amazon SNS.

Administrators clean up old logs and extend the EBS volume before the application fails.

---

## Scenario 3: EC2 Health Check Failure

An EC2 instance fails a status check.

CloudWatch Alarm changes to **ALARM**.

Amazon SNS notifies the operations team immediately.

The team investigates and restores the instance.

---

## Scenario 4: Security Incident

A large number of failed SSH login attempts are detected.

CloudWatch Alarm publishes an alert to Amazon SNS.

The security team reviews authentication logs and blocks suspicious IP addresses.

---

# Best Practices: Production Notification Workflow

- Create separate SNS topics for Development, Testing, and Production.
- Use team distribution email addresses instead of personal email addresses.
- Test alarms regularly.
- Document each notification workflow.
- Review alarm history after every incident.
- Keep subscriber lists up to date.

---

# Interview Questions: Integration

## 1. Why do we integrate CloudWatch with Amazon SNS?

**Answer**

CloudWatch detects events, while Amazon SNS delivers notifications. Together, they provide automated alerting so administrators can respond quickly without manually monitoring dashboards.

---

## 2. What happens if the SNS subscription is not confirmed?

**Answer**

Amazon SNS will not deliver notifications to that endpoint until the subscription has been confirmed.

---

## 3. What information is included in a CloudWatch Alarm email?

**Answer**

The notification typically includes:

- Alarm Name
- Alarm State
- Metric Name
- Threshold
- Current Metric Value
- AWS Region
- Timestamp
- Reason for the alarm

---

## Integration Summary

At this point, you have:

- ✔ Connected CloudWatch Alarms to Amazon SNS
- ✔ Configured alarm notifications
- ✔ Triggered a CPU alarm
- ✔ Verified email delivery
- ✔ Verified recovery notifications
- ✔ Completed the end-to-end monitoring workflow
- ✔ Learned production monitoring scenarios

Next, we will cover troubleshooting, AWS CLI commands, cost optimization, security best practices, cleanup, the conclusion, and the screenshot checklist before moving on to **13-AMI.md**.

---

# Troubleshooting

Amazon SNS is a highly reliable messaging service. However, configuration issues may prevent notifications from being delivered.

The following table lists common issues and their recommended solutions.

| Issue | Possible Cause | Solution |
|--------|----------------|----------|
| Email notification not received | Subscription not confirmed | Open the confirmation email and click **Confirm subscription** |
| CloudWatch Alarm triggered but no email received | Alarm is not connected to the SNS Topic | Edit the CloudWatch Alarm and attach the correct SNS Topic |
| Subscription status is **Pending Confirmation** | Confirmation link not clicked | Check your inbox (or spam folder) and confirm the subscription |
| Test message not delivered | Incorrect email address | Create a new subscription with the correct email address |
| No CloudWatch notifications | Alarm threshold never exceeded | Generate CPU load using the **stress** command |
| Email marked as spam | Email provider filtered the notification | Add Amazon SNS to the safe sender list |

---

# Verification Checklist

Before moving to the next project phase, verify the following.

| Component | Status |
|-----------|--------|
| SNS Topic Created | ✅ |
| Email Subscription Confirmed | ✅ |
| Test Message Delivered | ✅ |
| CloudWatch Alarm Attached | ✅ |
| Alarm Triggered Successfully | ✅ |
| Email Notification Received | ✅ |
| Alarm Recovery Verified | ✅ |

---

# Useful AWS CLI Commands

## List SNS Topics

```bash
aws sns list-topics
```

---

## List Topic Subscriptions

```bash
aws sns list-subscriptions
```

---

## Publish a Test Message

```bash
aws sns publish \
--topic-arn <TOPIC_ARN> \
--subject "SNS Test" \
--message "This is a test notification."
```

---

## List CloudWatch Alarms

```bash
aws cloudwatch describe-alarms
```

---

## Delete an SNS Topic

```bash
aws sns delete-topic \
--topic-arn <TOPIC_ARN>
```

> **Note:** Deleting an SNS Topic also removes all associated subscriptions.

---

# Security Best Practices

Follow these recommendations when using Amazon SNS in production.

- Apply the Principle of Least Privilege using IAM policies.
- Restrict permissions for creating, deleting, and publishing to SNS Topics.
- Avoid using personal email addresses for production alerts.
- Use team distribution lists for operational notifications.
- Review SNS access policies regularly.
- Monitor SNS usage with AWS CloudTrail.

---

# Cost Optimization

Amazon SNS is a cost-effective service, but the following practices help minimize unnecessary charges.

- Delete unused Topics.
- Remove inactive subscriptions.
- Avoid sending duplicate notifications.
- Consolidate related alerts into shared Topics.
- Review notification frequency regularly.

---

# Real-Time Production Scenario: 2 AM Traffic Spike

A financial services company hosts a customer-facing application on Amazon EC2.

At 2:15 AM, CPU utilization rises above 85% because of an unexpected spike in traffic.

CloudWatch detects the sustained increase and changes the alarm state to **ALARM**.

The alarm publishes a notification to the **Server-Monitoring-Alerts** SNS Topic.

Amazon SNS immediately sends email notifications to the on-call DevOps engineers.

The engineer investigates the issue, scales the infrastructure, and restores normal performance before customers experience service disruption.

This proactive alerting process reduces downtime and improves customer satisfaction.

---

# Interview Questions: SNS Fundamentals

## 1. What is Amazon SNS?

**Answer**

Amazon Simple Notification Service (SNS) is a fully managed publish/subscribe messaging service that delivers notifications to multiple subscribers using protocols such as Email, SMS, HTTP/HTTPS, AWS Lambda, Amazon SQS, and Mobile Push.

---

## 2. What is an SNS Topic?

**Answer**

An SNS Topic is a logical communication channel where publishers send messages and subscribers receive notifications.

---

## 3. What happens if an email subscription is not confirmed?

**Answer**

Amazon SNS does not deliver notifications until the subscription has been confirmed by the recipient.

---

## 4. Can one SNS Topic have multiple subscribers?

**Answer**

Yes. A single SNS Topic can deliver notifications to multiple email addresses, Lambda functions, SQS queues, HTTP endpoints, and other supported subscribers.

---

## 5. Why is Amazon SNS commonly used with CloudWatch?

**Answer**

CloudWatch detects events and alarm conditions, while Amazon SNS distributes notifications to administrators or applications. Together they provide an automated monitoring and alerting solution.

---

# Cleanup

If you no longer require Amazon SNS resources, perform the following steps.

## Delete Email Subscription

```text
SNS
→ Topics
→ Server-Monitoring-Alerts
→ Subscriptions
→ Delete
```

---

## Delete SNS Topic

```text
SNS
→ Topics
→ Server-Monitoring-Alerts
→ Delete
```

Or use the AWS CLI.

```bash
aws sns delete-topic \
--topic-arn <TOPIC_ARN>
```

---

# Conclusion

In this document, we successfully integrated Amazon SNS with Amazon CloudWatch Alarms to build a real-time monitoring and notification system.

We learned how to:

- Create an SNS Topic
- Configure an Email Subscription
- Confirm the Subscription
- Connect CloudWatch Alarms to SNS
- Receive automated email notifications
- Test the complete monitoring workflow
- Apply security and cost optimization best practices

Our monitoring solution now provides immediate alerts whenever important server events occur, enabling faster response times and improving operational reliability.

---

# Screenshot Checklist

| Screenshot | File Name |
|------------|-----------|
| SNS Home | `01-sns-home.png` |
| SNS Dashboard | `02-sns-dashboard.png` |
| Create Topic | `03-create-topic.png` |
| Topic Created | `04-topic-created.png` |
| Create Subscription | `05-create-subscription.png` |
| Confirmation Email | `06-confirm-email.png` |
| Subscription Confirmed | `07-subscription-confirmed.png` |
| Publish Test Message | `08-publish-message.png` |
| Test Email | `09-test-email.png` |
| Edit Alarm | `10-edit-alarm.png` |
| Attach SNS Topic | `11-attach-sns-topic.png` |
| Alarm Action | `12-alarm-action.png` |
| Trigger Alarm | `13-trigger-alarm.png` |
| Email Alert | `14-email-alert.png` |
| Alarm Recovery | `15-alarm-recovery.png` |

---

# Project Progress

At this stage, our monitoring solution is fully operational.

```text
Amazon EC2
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
      │
      ▼
Administrator Response
```

---

# Next Document

## 13-AMI.md

In the next document, we will learn how to:

- Understand Amazon Machine Images (AMI)
- Create a custom AMI from our configured EC2 instance
- Launch new EC2 instances from the AMI
- Understand AMI storage and snapshots
- Apply AMI best practices for backup and disaster recovery

The AMI created in the next section will allow us to quickly recover or replicate our fully configured monitoring server whenever required.
