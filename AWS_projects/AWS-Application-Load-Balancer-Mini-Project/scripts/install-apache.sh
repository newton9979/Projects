#!/bin/bash

# ==============================================
# AWS Application Load Balancer Mini Project
# Apache Installation Script
# Author: Newton Nandru
# ==============================================

set -e

echo "=========================================="
echo "Updating system packages..."
echo "=========================================="

sudo yum update -y

echo "=========================================="
echo "Installing Apache Web Server..."
echo "=========================================="

sudo yum install -y httpd

echo "=========================================="
echo "Enabling Apache service..."
echo "=========================================="

sudo systemctl enable httpd

echo "=========================================="
echo "Starting Apache service..."
echo "=========================================="

sudo systemctl start httpd

echo "=========================================="
echo "Configuring Firewall (if firewalld exists)..."
echo "=========================================="

if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --reload
fi

echo "=========================================="
echo "Verifying Apache Status..."
echo "=========================================="

sudo systemctl status httpd --no-pager

echo
echo "=========================================="
echo "Apache Installation Completed Successfully!"
echo "=========================================="

echo "Apache Version:"
httpd -v

echo
echo "Service Status:"
systemctl is-active httpd

echo
echo "Web Root Directory:"
echo "/var/www/html"

echo
echo "Default Test Page:"
echo "http://<EC2-Public-IP>/"
