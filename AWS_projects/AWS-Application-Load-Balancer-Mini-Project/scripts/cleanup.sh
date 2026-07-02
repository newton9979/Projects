#!/bin/bash

# ============================================
# AWS Application Load Balancer Mini Project
# Cleanup Script
# ============================================

echo "Stopping Apache..."
sudo systemctl stop httpd

echo "Disabling Apache..."
sudo systemctl disable httpd

echo "Removing Apache..."
sudo yum remove -y httpd

echo "Removing web page..."
sudo rm -f /var/www/html/index.html

echo "Cleaning yum cache..."
sudo yum clean all

echo "Cleanup completed successfully."
