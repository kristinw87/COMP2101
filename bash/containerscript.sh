#!/bin/bash

#this is my testing script for playing with containers

#use the which command to see if lxd exists on the system already

which lxd > /dev/null

if [ $? -ne 0 ]; then
#need to install lxd
	echo "Installing lxd - you may need to input password"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
	#failed to install lxd - exit with error message and status
	echo "Failed to install lxd"
	exit 1
	fi
fi

#lxd software install complete


#check to see if lxdbr0 interface exists using "ip link show"

ip link show | grep -w "lxdbr0" > /dev/null

#if not, need to run lxd init --auto

if [ $? -ne 0 ]; then
	echo "Interface lxdbr0 does not exist - creating it now"
	lxd init --auto
	if [ $? -ne 0 ]; then
		echo "Failed to initialize setup."
		exit 1
	fi
else
	echo "lxdbr0 already exists on this machine."
	
fi


#does the container exist? check with lxc list and grep, dont show output, move to /dev/null

lxc list | grep -w "COMP2101-S22 | RUNNING" > /dev/null

#if not, create and launch container

if [ $? -ne 0 ]; then
	echo "Launching Ubuntu container and naming it COMP2101-S22"
	lxc launch ubuntu:20.04 COMP2101-S22
	if [ $? -ne 0 ]; then
		echo "Failed to launch Ubuntu container."
		exit 1
	fi

fi

#script runs too fast and doesn't give the container enough time to grab an IP, use sleep command to slow it down

echo "Gathering IP information..."
sleep 8

#we want to know the IP and Hostname of our container so we can add it to the /etc/hosts file. Put it into a variable to make it easier later

IpContainer=$(lxc list | grep -w "COMP2101-S22" | awk '{print $6}')
IpHostname=$(lxc list | grep -w "COMP2101-S22" | awk '{print $2}')

#since our /etc/hosts file lists IP first and then Hostname, we'll combine both variables into one to neatly insert this info into the file

IpAndHostname="$IpContainer      $IpHostname"

#does the IP address exist in /etc/hosts? If not, create the entry on the third line of the file (under the 2 current entries). Otherwise, go onto the next step

grep "$IpContainer" /etc/hosts > /dev/null

if [ $? -ne 0 ]; then
	echo "No IP detected for this container, creating an entry. Sudo permissions may be required."
	sudo sed -i "3i$IpAndHostname" /etc/hosts
	if [ $? -ne 0 ]; then
		echo "Failed to add entry to /etc/hosts"
		exit 1
	fi
else
	echo "IP and Hostname already exist in this file."
fi


#does Apache2 exist in the container? enter the container, use which command, dont show output, redirect to /dev/null

lxc exec COMP2101-S22 -- which apache2 > /dev/null

#if Apache2 does not exist in container, install. Otherwise, move onto the next step

if [ $? -ne 0 ]; then
	echo "Apache2 does not exist; installing now"
	lxc exec COMP2101-S22 -- apt install apache2
	if [ $? -ne 0 ]; then
	echo "Failed to install Apache2 successfully."
	exit 1
	fi
else
	echo "Apache2 already exists in this container."
	
fi


#curl is not always installed by default so we should check to see if it is before running this command

which curl > /dev/null

#if it's not installed, install curl

if [ $? -ne 0 ]; then
	echo "Installing curl onto your system. Sudo permissions may be required."
	sudo snap install curl
	if [ $? -ne 0 ]; then
		echo "Failed to install curl."
		exit 1
	fi
fi

#retrieve the default web page from Apache

curl http://COMP2101-S22 > /dev/null

#if retrieval is unsuccessful, notify user. Otherwise, tell user it succeeded

if [ $? -ne 0 ]; then
	echo "Uh oh! Failed to retrieve web page."
	exit 1
else
	echo "Success! Web page retrieved. Good job."
	
fi
