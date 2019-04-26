#!/bin/bash

sudo su -

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"
apt-get update -y -qq

# JAVA #########################################################################
echo -e "-- Installing JAVA packages\n"
apt-get install openjdk-8-jdk -y

# JENKINS #########################################################################
echo -e "-- Including Jenkins packages\n"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add - > /dev/null 2>&1
sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"

echo -e "-- Updating packages list\n"
apt-get update -y -qq
echo -e "-- Installing Jenkins automation server\n"
apt-get install jenkins -y -qq

# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"
