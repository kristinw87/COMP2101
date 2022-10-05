#!/bin/bash

#gather the data for my report
source /etc/os-release

#define some variables for my report

#this is the hostname variable
HostName=$(hostname)

#this is the OS name and version variables
OsName=$NAME
OsVersion=$VERSION

#this is the IP address variable
IpAddress=$(hostname -I)

#this is the freespace variable
FreeSpace=$(df -h | grep -w "/" | awk '{print $4}')

#print out the report using the data

cat <<EOF

 
Report for $HostName
==========

FQDN: $HostName 
OS name and version: $OsName $OsVersion
IP Address: $IpAddress
Root Filesystem Free Space: $FreeSpace

==========

EOF
