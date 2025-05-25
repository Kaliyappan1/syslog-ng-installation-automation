#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Run as root
sudo su -

# Enable required repositories
subscription-manager repos --enable codeready-builder-for-rhel-9-noarch-rpms

# Install EPEL repo
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Navigate to yum repos directory
cd /etc/yum.repos.d/

# Install wget
yum install -y wget

# Add Syslog-ng COPR repo
wget https://copr.fedorainfracloud.org/coprs/czanik/syslog-ng336/repo/epel-8/czanik-syslog-ng41-epel-8.repo

# Install syslog-ng with --nobest to avoid version conflicts
yum install -y syslog-ng --nobest

# Enable and start syslog-ng service
systemctl enable syslog-ng
systemctl start syslog-ng

# Show syslog-ng status
systemctl status syslog-ng
