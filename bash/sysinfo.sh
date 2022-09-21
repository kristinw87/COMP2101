#!/bin/bash

# my first real script for lab 1

# this shows the fully qualified domain name
echo "FQDN:"
hostname 

# this is the OS and version
echo "Host Info:"
hostnamectl

# any IP addresses that are not on the 127 network
echo "IP Addresses:"
hostname -I

# the amount of space available in only the root filesystem
echo "Root Filesystem Status:"
df -h /dev/sda3

exit
