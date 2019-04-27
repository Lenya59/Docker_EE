#!/bin/bash

sudo su -

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"
yum install epel-release
yum update
reboot
yum install wget
# JAVA #########################################################################
echo -e "-- Installing JAVA packages\n"

yum install java-1.8.0-openjdk.x86_64

java -version

# JENKINS #########################################################################
echo -e "-- Including Jenkins packages\n"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key


echo -e "-- Updating packages list\n"
yum update
echo -e "-- Installing Jenkins automation server\n"
yum install jenkin

# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"

systemctl enable jenkins
systemctl jenkins status
