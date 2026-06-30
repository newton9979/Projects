# Amazon CloudWatch Alarms

## Objective

In this section, we will configure Amazon CloudWatch Alarms to continuously monitor the health of our EC2 instance and automatically notify administrators when predefined thresholds are exceeded.

By the end of this guide, you will learn how to:

- Understand Amazon CloudWatch Alarms
- Configure alarms for EC2 metrics
- Monitor CPU utilization
- Understand alarm states
- Integrate alarms with Amazon SNS
- Test alarm functionality
- Apply production monitoring best practices

---

# Prerequisites

Before continuing, ensure the following components have already been configured:

- AWS Account
- Running EC2 Instance
- IAM Role attached to the EC2 instance
- Amazon CloudWatch Agent installed
- Metrics visible in CloudWatch
- CloudWatch Dashboard created

> **Note**
>
> This document continues from **10-CloudWatch.md**.

---

# What are Amazon CloudWatch Alarms?

Amazon CloudWatch Alarms continuously monitor CloudWatch metrics and compare them against thresholds that you define.

When a threshold is reached, the alarm automatically changes state and can trigger actions such as:

- Sending an email notification
- Publishing a message to Amazon SNS
- Triggering an AWS Lambda function
- Starting Auto Scaling actions
- Recovering an EC2 instance

Instead of waiting for users to report problems, CloudWatch Alarms notify administrators immediately when abnormal conditions occur.

---

# Why Are We Using CloudWatch Alarms in This Project?

Our project is a **Server Monitoring & Log Backup System**.

Monitoring metrics alone is not enough.

If CPU usage suddenly reaches 95% at midnight, no one may notice unless they are actively viewing the dashboard.

CloudWatch Alarms solve this problem by continuously monitoring server metrics and notifying administrators automatically.

This enables:

- Faster incident response
- Reduced downtime
- Improved application availability
- Proactive infrastructure management

---

# CloudWatch Alarm States

Each CloudWatch Alarm can exist in one of three states.

| State | Description |
|--------|-------------|
| OK | Metric is within the defined threshold. |
| ALARM | Threshold has been exceeded and the configured action is triggered. |
| INSUFFICIENT_DATA | CloudWatch does not yet have enough data to evaluate the alarm. |

Example workflow:

```text
CPU < 80%
      │
      ▼
     OK

CPU ≥ 80%
      │
      ▼
   ALARM
      │
      ▼
Send Email (SNS)

Metric Returns to Normal
      │
      ▼
      OK
```

---

# Real-Time Production Scenarios

## Scenario 1: High CPU Utilization

During a seasonal sale, traffic increases dramatically.

CPU utilization rises above 80%.

CloudWatch Alarm changes to the **ALARM** state.

The DevOps team receives an email notification and launches additional EC2 instances before customers experience slow response times.

---

## Scenario 2: Disk Usage Critical

Application log files continue growing throughout the day.

Disk utilization reaches 90%.

CloudWatch Alarm immediately notifies the operations team.

The team archives logs to Amazon S3 and prevents the server from running out of disk space.

---

## Scenario 3: Memory Utilization

A memory leak causes RAM usage to increase continuously.

CloudWatch Alarm detects memory usage above the defined threshold.

Administrators restart the affected application before it crashes.

---

## Scenario 4: Instance Failure

An EC2 instance becomes unreachable because of an operating system issue.

CloudWatch detects failed status checks.

The operations team receives an alert and begins investigating immediately.

---

# Architecture Overview

```text
                 Amazon CloudWatch
                      Metrics
                         │
                         ▼
                CloudWatch Alarm
                         │
              Threshold Evaluation
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
        OK                           ALARM
                                         │
                                         ▼
                                 Amazon SNS (Next Step)
                                         │
                                         ▼
                                 Email Notification
```

---

# Architecture Diagram

<p align="center">
  <img src="../architecture/aws-project-1-architecture.png" width="900" alt="CloudWatch Alarm Architecture">
</p>

---

# Screenshots

### CloudWatch Alarms Dashboard

<p align="center">
  <img src="../screenshots/CloudWatch/21-cloudwatch-alarms-home.png" width="900" alt="CloudWatch Alarms Dashboard">
</p>

### Alarm States Overview

<p align="center">
  <img src="../screenshots/CloudWatch/22-alarm-states.png" width="900" alt="CloudWatch Alarm States">
</p>

---

# Step 1: Navigate to CloudWatch Alarms

1. Sign in to the **AWS Management Console**.
2. Search for **CloudWatch**.
3. In the left navigation pane, select **Alarms**.
4. Click **All alarms**.
5. Click **Create alarm**.

<p align="center">
  <img src="../screenshots/CloudWatch/23-create-alarm.png" width="900" alt="Create CloudWatch Alarm">
</p>

---

# Step 2: Select a Metric

CloudWatch Alarms monitor CloudWatch Metrics.

Click **Select metric**.

Navigate to:

```text
EC2
→ Per-Instance Metrics
```

Select your EC2 instance.

Choose the following metric:

```text
CPUUtilization
```

Click **Select metric**.

<p align="center">
  <img src="../screenshots/CloudWatch/24-select-metric.png" width="900" alt="Select CPU Utilization Metric">
</p>

---

# Why CPU Utilization?

CPU utilization is one of the most important health indicators for an EC2 instance.

High CPU usage may indicate:

- High application traffic
- Inefficient application code
- Infinite loops
- Background processes consuming resources
- Need for Auto Scaling

Monitoring CPU helps detect performance issues before users notice them.

---

# Step 3: Configure the Metric

Configure the following settings.

| Setting | Value |
|----------|-------|
| Statistic | Average |
| Period | 5 Minutes |
| Threshold Type | Static |
| Condition | Greater than |
| Threshold Value | 80 |

This means the alarm enters the **ALARM** state when the average CPU utilization exceeds **80%** during the evaluation period.

<p align="center">
  <img src="../screenshots/CloudWatch/25-configure-threshold.png" width="900" alt="Configure Alarm Threshold">
</p>

---

# Step 4: Configure Additional Settings

Define the evaluation behavior.

| Setting | Value |
|----------|-------|
| Evaluation Periods | 2 |
| Datapoints to Alarm | 2 out of 2 |

This configuration reduces false alarms by ensuring that the threshold is exceeded consistently before the alarm changes state.

> **Production Tip**
>
> Avoid triggering alarms based on a single data point. Using multiple evaluation periods helps filter out temporary spikes.

---

# Step 5: Configure Alarm Actions

In this project, we will integrate Amazon SNS in the next document.

For now, you have two options:

### Option 1 (Recommended)

Select:

```text
In alarm
→ Select an existing SNS topic
```

If your SNS topic is not yet created, you can return and attach it later.

### Option 2

Select:

```text
No action
```

This allows you to continue testing the alarm before configuring notifications.

<p align="center">
  <img src="../screenshots/CloudWatch/26-configure-actions.png" width="900" alt="Configure CloudWatch Alarm Actions">
</p>

---

# Step 6: Configure Alarm Details

Provide a meaningful alarm name and description.

Example:

| Field | Value |
|-------|-------|
| Alarm Name | EC2-High-CPU-Alarm |
| Description | Triggers when CPU utilization exceeds 80% for 10 minutes |

Click **Next**.

<p align="center">
  <img src="../screenshots/CloudWatch/27-review-alarm.png" width="900" alt="Review CloudWatch Alarm">
</p>

---

# Step 7: Create the Alarm

Review all settings carefully.

Verify:

- Correct EC2 instance selected
- CPUUtilization metric selected
- Threshold configured correctly
- Evaluation periods configured
- Alarm name is meaningful

Click **Create alarm**.

<p align="center">
  <img src="../screenshots/CloudWatch/28-alarm-created.png" width="900" alt="CloudWatch Alarm Created Successfully">
</p>

---

# Step 8: Verify the Alarm

Navigate to:

```text
CloudWatch
→ Alarms
→ All alarms
```

Verify that the new alarm appears in the list.

Initially, the alarm may display:

```text
INSUFFICIENT_DATA
```

This is expected because CloudWatch needs time to collect enough metric data.

After sufficient data is available, the alarm transitions to either:

- **OK** (metric is within threshold)
- **ALARM** (threshold exceeded)

<p align="center">
  <img src="../screenshots/CloudWatch/29-alarm-list.png" width="900" alt="CloudWatch Alarm List">
</p>

---

# Real-Time Production Scenario: Online Learning Platform

A company hosts an online learning platform on Amazon EC2.

During exam periods, thousands of students access the platform simultaneously.

As demand increases:

- CPU utilization rises rapidly.
- CloudWatch continuously evaluates the CPU metric.
- When CPU utilization remains above **80%** for two consecutive evaluation periods, the alarm changes to the **ALARM** state.
- The operations team receives an alert and adds additional EC2 instances behind the Load Balancer.

Because the issue is detected early, students continue using the platform without noticeable performance degradation.

---

# Best Practices

- Use meaningful alarm names.
- Avoid very low thresholds that generate unnecessary alerts.
- Configure multiple evaluation periods to reduce false positives.
- Review alarm history regularly.
- Use SNS notifications for critical production alarms.
- Document the purpose of each alarm.

---

## Alarm Creation Summary

At this point, you have:

- ✔ Created your first CloudWatch Alarm
- ✔ Selected the CPUUtilization metric
- ✔ Configured threshold values
- ✔ Configured evaluation periods
- ✔ Reviewed and created the alarm
- ✔ Verified the alarm state
- ✔ Learned a real-world production use case

Next, we will test the alarm by generating CPU load, observe state transitions (**OK → ALARM → OK**), create additional alarms for memory and disk utilization, and prepare the monitoring system for Amazon SNS email notifications.

---

# Testing CloudWatch Alarms

Creating an alarm is only the first step. In a production environment, every alarm should be tested to ensure it behaves as expected.

In this section, we will:

- Generate high CPU utilization
- Observe alarm state transitions
- Review alarm history
- Create additional production alarms
- Understand real-world monitoring scenarios

---

# Step 9: Verify the Initial Alarm State

Navigate to:

```text
CloudWatch
→ Alarms
→ All Alarms
```

Initially, your alarm should display one of the following states:

| Alarm State | Meaning |
|-------------|---------|
| OK | Metric is within the configured threshold |
| ALARM | Threshold exceeded |
| INSUFFICIENT_DATA | CloudWatch is collecting initial metric data |

<p align="center">
  <img src="../screenshots/CloudWatch/30-alarm-ok.png" width="900" alt="CloudWatch Alarm in OK State">
</p>

---

# Step 10: Generate High CPU Utilization

To test the alarm, connect to your EC2 instance.

Install the **stress** utility.

Amazon Linux 2:

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
```

Run the following command:

```bash
stress --cpu 2 --timeout 300
```

Explanation:

| Option | Description |
|---------|-------------|
| --cpu 2 | Creates two CPU workers |
| --timeout 300 | Runs the test for 5 minutes |

This artificially increases CPU utilization, allowing the CloudWatch Alarm to detect the threshold breach.

<p align="center">
  <img src="../screenshots/CloudWatch/31-stress-test.png" width="900" alt="Generating High CPU Load">
</p>

---

# Step 11: Observe the Alarm State

After a few minutes:

Navigate to:

```text
CloudWatch
→ Alarms
```

The alarm should transition:

```text
OK
      │
      ▼
ALARM
```

CloudWatch records:

- Alarm trigger time
- Metric value
- Threshold exceeded
- State change reason

<p align="center">
  <img src="../screenshots/CloudWatch/32-alarm-triggered.png" width="900" alt="CloudWatch Alarm Triggered">
</p>

---

# Step 12: Review Alarm History

Open the alarm.

Select the **History** tab.

You can view:

- State changes
- Trigger times
- Recovery times
- Alarm actions
- Evaluation details

This history is extremely valuable when troubleshooting production incidents.

<p align="center">
  <img src="../screenshots/CloudWatch/33-alarm-history.png" width="900" alt="CloudWatch Alarm History">
</p>

---

# Step 13: Verify Recovery

When the stress test completes:

CPU utilization gradually decreases.

CloudWatch automatically changes the alarm state:

```text
ALARM
      │
      ▼
OK
```

No manual action is required.

<p align="center">
  <img src="../screenshots/CloudWatch/34-alarm-recovered.png" width="900" alt="CloudWatch Alarm Returned to OK">
</p>

---

# Additional Production Alarms

CPU monitoring alone is not sufficient in production.

The following alarms are commonly configured.

| Alarm | Threshold | Purpose |
|---------|----------|----------|
| CPU Utilization | > 80% | Detect high CPU usage |
| Memory Utilization | > 80% | Detect memory pressure |
| Disk Usage | > 85% | Prevent disk exhaustion |
| Status Check Failed | > 0 | Detect EC2 health issues |
| Network In | Sudden spike | Detect unusual incoming traffic |
| Network Out | Sudden spike | Detect abnormal outbound traffic |

> **Note:** Memory and Disk alarms require the CloudWatch Agent because these metrics are not available through default EC2 monitoring.

---

# Real-Time Production Scenarios: Additional Alarms

## Scenario 1: E-Commerce Website During a Sale

An online store launches a festival sale.

Traffic increases from hundreds to thousands of users.

CloudWatch detects sustained CPU utilization above 80%.

The alarm changes to **ALARM**, notifying the operations team.

The team scales the application before customers experience slow response times.

---

## Scenario 2: Disk Space Running Out

An application writes logs continuously.

Disk usage reaches 90%.

CloudWatch Alarm alerts administrators.

The team archives old logs to Amazon S3 and expands the EBS volume, preventing application failures.

---

## Scenario 3: Memory Leak

A Java application contains a memory leak.

RAM usage increases over several hours.

The Memory Utilization alarm detects the issue before the application crashes.

Engineers restart the service and investigate the root cause.

---

## Scenario 4: EC2 Instance Failure

The operating system encounters an issue, causing the EC2 status check to fail.

CloudWatch triggers an alarm.

The operations team receives an alert and begins recovery immediately, reducing downtime.

---

# Best Practices: Testing & Multi-Metric Monitoring

- Test every alarm after creating it.
- Configure meaningful threshold values.
- Avoid alert fatigue by choosing appropriate evaluation periods.
- Monitor memory and disk usage in addition to CPU.
- Review alarm history during incident investigations.
- Integrate CloudWatch Alarms with Amazon SNS for immediate notifications.
- Periodically review and update alarm thresholds as application workloads change.

---

# Interview Questions: Testing Alarms

### 1. Why should CloudWatch Alarms be tested?

**Answer:**

Testing verifies that alarms trigger correctly, change state appropriately, and perform the configured actions, such as sending notifications. This ensures the monitoring system works as expected before a production incident occurs.

---

### 2. Why use multiple evaluation periods?

**Answer:**

Using multiple evaluation periods helps avoid false alarms caused by brief or temporary spikes in resource usage. It ensures alerts are triggered only when an issue is sustained.

---

### 3. Why monitor memory usage if CPU is already monitored?

**Answer:**

High memory utilization can lead to application instability or crashes even when CPU usage is normal. Monitoring both provides a more complete picture of system health.

---

## Testing & Recovery Summary

At this point, you have:

- ✔ Tested the CloudWatch Alarm
- ✔ Generated CPU load
- ✔ Observed alarm state transitions
- ✔ Reviewed alarm history
- ✔ Verified automatic recovery
- ✔ Explored additional production alarms
- ✔ Learned real-world monitoring scenarios
- ✔ Reviewed monitoring best practices

Next, we will cover troubleshooting, cleanup, AWS CLI commands, cost optimization, security best practices, and prepare for **12-SNS.md**.

---

# Troubleshooting

Even after correctly configuring Amazon CloudWatch Alarms, you may encounter issues. The following table lists common problems and their solutions.

| Issue | Possible Cause | Solution |
|--------|----------------|----------|
| Alarm remains in **INSUFFICIENT_DATA** | CloudWatch has not collected enough metrics | Wait several minutes and verify the metric is being published. |
| Alarm never changes to **ALARM** | Threshold is too high | Lower the threshold temporarily and test again. |
| Alarm remains in **OK** | CPU or other metric never exceeds the configured threshold | Generate load using the `stress` command or simulate the required condition. |
| Memory alarm does not work | CloudWatch Agent is not publishing memory metrics | Verify the CloudWatch Agent configuration and restart the agent. |
| Disk usage alarm shows no data | Disk metrics are not configured | Update `cloudwatch/cloudwatch-agent-config.json` to collect disk metrics. |
| Alarm action not triggered | SNS topic not configured or action missing | Verify the alarm action configuration and SNS subscription. |

---

# Useful Verification Commands

The following commands help verify the CloudWatch Agent and system status.

## Verify CloudWatch Agent Status

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Expected Output:

```text
Active: active (running)
```

<p align="center">
  <img src="../screenshots/CloudWatch/35-agent-status.png" width="900" alt="CloudWatch Agent Status">
</p>

---

## Verify CloudWatch Agent Control Status

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-m ec2 \
-a status
```

Expected Output:

```json
{
  "status": "running"
}
```

---

## Verify CPU Usage

```bash
top
```

or

```bash
htop
```

Observe CPU utilization while the stress test is running.

---

## Verify Memory Usage

```bash
free -h
```

---

## Verify Disk Usage

```bash
df -h
```

---

## Verify CloudWatch Metrics

Navigate to:

```text
CloudWatch
→ Metrics
→ CWAgent
```

Ensure metrics are updating successfully.

<p align="center">
  <img src="../screenshots/CloudWatch/36-verify-metrics.png" width="900" alt="Verify CloudWatch Metrics">
</p>

---

# AWS CLI Commands

List CloudWatch Alarms:

```bash
aws cloudwatch describe-alarms
```

Describe a specific alarm:

```bash
aws cloudwatch describe-alarms \
--alarm-names EC2-High-CPU-Alarm
```

Delete an alarm:

```bash
aws cloudwatch delete-alarms \
--alarm-names EC2-High-CPU-Alarm
```

These commands are useful for automation and Infrastructure as Code workflows.

---

# Cost Optimization

To reduce CloudWatch costs in production:

- Monitor only the metrics that are necessary.
- Delete unused alarms.
- Remove obsolete dashboards.
- Configure appropriate log retention periods.
- Avoid creating duplicate alarms for the same metric.
- Review monitoring resources periodically.

> **Tip:** Effective monitoring doesn't mean monitoring everything—it means monitoring what matters most.

---

# Security Best Practices

Follow these recommendations when configuring CloudWatch Alarms:

- Use IAM Roles instead of long-term access keys.
- Apply the principle of least privilege.
- Restrict permissions for creating and deleting alarms.
- Enable encryption where applicable.
- Monitor authentication logs using CloudWatch Logs.
- Regularly review alarm configurations.

---

# Project Use Case

In this project, CloudWatch Alarms continuously monitor the health of the EC2 instance.

When a monitored metric exceeds its threshold:

1. CloudWatch evaluates the metric.
2. The alarm changes from **OK** to **ALARM**.
3. An action is triggered.
4. Amazon SNS (configured in the next document) sends an email notification.
5. The DevOps team investigates the issue before it impacts users.

This proactive monitoring approach reduces downtime and improves application availability.

---

# Real-Time Production Scenario: Late-Night CPU Spike

A company hosts a customer-facing web application on Amazon EC2.

Late at night, a background process begins consuming excessive CPU resources.

CloudWatch detects that CPU utilization remains above **80%** for two consecutive evaluation periods.

The alarm changes to the **ALARM** state.

Amazon SNS immediately sends an email notification to the operations team.

An engineer connects to the server, identifies the process, restarts the affected service, and restores normal operation before customers notice any performance issues.

Without CloudWatch Alarms, the issue might have remained undetected until users reported problems.

---

# Interview Questions: Alarms Overview

## 1. What are the three CloudWatch Alarm states?

**Answer**

- **OK** – Metric is within the configured threshold.
- **ALARM** – Threshold has been exceeded.
- **INSUFFICIENT_DATA** – CloudWatch does not yet have enough data to evaluate the metric.

---

## 2. Why do we use evaluation periods?

**Answer**

Evaluation periods reduce false alarms by ensuring that a condition persists before an alarm changes state.

---

## 3. Can CloudWatch Alarms monitor memory usage by default?

**Answer**

No. Memory utilization is an operating system metric and requires the Amazon CloudWatch Agent to collect and publish it.

---

## 4. Why integrate CloudWatch Alarms with Amazon SNS?

**Answer**

Amazon SNS enables CloudWatch Alarms to send notifications automatically, allowing administrators to respond quickly without continuously monitoring dashboards.

---

## 5. What metrics should every production EC2 instance monitor?

**Answer**

Recommended metrics include:

- CPU Utilization
- Memory Utilization
- Disk Usage
- Network In
- Network Out
- EC2 Status Checks
- Application Logs

---

# Cleanup

If you no longer need the alarm:

Delete the CloudWatch Alarm from the AWS Console:

```text
CloudWatch
→ Alarms
→ Select Alarm
→ Delete
```

Or use the AWS CLI:

```bash
aws cloudwatch delete-alarms \
--alarm-names EC2-High-CPU-Alarm
```

> **Note:** Delete alarms only when they are no longer required. Historical monitoring configurations can be valuable for future reference.

---

# Conclusion

In this document, we successfully configured Amazon CloudWatch Alarms to monitor our EC2 instance proactively.

We learned how to:

- Create CloudWatch Alarms
- Configure CPU thresholds
- Test alarms using simulated load
- Monitor alarm state transitions
- Review alarm history
- Apply production best practices
- Troubleshoot common issues

CloudWatch Alarms now provide automated monitoring and are ready to integrate with Amazon SNS for real-time email notifications.

---

# Screenshot Checklist

| Screenshot | File Name |
|------------|-----------|
| CloudWatch Alarms Home | `21-cloudwatch-alarms-home.png` |
| Alarm States | `22-alarm-states.png` |
| Create Alarm | `23-create-alarm.png` |
| Select Metric | `24-select-metric.png` |
| Configure Threshold | `25-configure-threshold.png` |
| Configure Actions | `26-configure-actions.png` |
| Review Alarm | `27-review-alarm.png` |
| Alarm Created | `28-alarm-created.png` |
| Alarm List | `29-alarm-list.png` |
| Alarm OK | `30-alarm-ok.png` |
| Stress Test | `31-stress-test.png` |
| Alarm Triggered | `32-alarm-triggered.png` |
| Alarm History | `33-alarm-history.png` |
| Alarm Recovered | `34-alarm-recovered.png` |
| Agent Status | `35-agent-status.png` |
| Verify Metrics | `36-verify-metrics.png` |

---

# Next Document

## 12-SNS.md

In the next document, we will:

- Understand Amazon SNS
- Create an SNS Topic
- Configure Email Subscriptions
- Connect CloudWatch Alarms to SNS
- Receive Email Notifications
- Test the Complete Monitoring Pipeline

By the end of the next guide, our monitoring solution will automatically notify administrators whenever critical server events occur.
