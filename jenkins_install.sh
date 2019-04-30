#!/bin/bash

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"
sudo yum update
sudo yum install wget -y
# JAVA #########################################################################
echo -e "-- Installing JAVA packages\n"

sudo yum install java-1.8.0-openjdk -y

# JENKINS #########################################################################
echo -e "-- Including Jenkins packages\n"
sudo yum update
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

echo -e "-- Updating packages list\n"
sudo yum update
echo -e "-- Installing Jenkins automation server\n"
sudo yum install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"
