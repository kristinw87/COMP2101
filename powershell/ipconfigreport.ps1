#this is my script for lab 3
#it will grab specific properties for only IP-enabled adapters on this system

get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | format-table description,index,ipaddress,ipsubnet,dnsdomain,dnsserver