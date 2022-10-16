#!/bin/bash

#source the data for my report
source /etc/os-release

#define hostname/os name/os version/IP address/free space variables. use the info found in the /etc/os-release file to define the distro name and version variables

Host=$(hostname)
Distro_Name=$NAME
Distro_Version=$VERSION

#use ip route to see what the default route is to the internet, use grep to search for the line containing the word "default", use awk to print out the 3rd line of data

IP_Address=$(ip route | grep -w "default" | awk '{print $3}')

#check disk usage, use grep to search for the line containing only "/" (root), then use awk to print the 4th line of data (which is available space)

Free_Space=$(df -h | grep -w "/" | awk '{print $4}')

#print out the report using the data

cat <<EOF

 
Report for $Host
~~~~~~~~~~

FQDN: $Host 
Distro name and version: $NAME $VERSION
IP Address: $IP_Address
Root Filesystem Free Space: $Free_Space

~~~~~~~~~~

EOF
