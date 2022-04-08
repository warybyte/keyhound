#!/bin/bash

# --------------------------------------------------------------------------------------------------------
# OVERVIEW OF KEYHOUND
# -------------------------------------------------------------------------------------------------------- 
# KeyHound is a script which records SSH keyed connections to a linux system. Ideally it should can be 
# configured to run in a cronjob and should be run as root or under a user with sudo privs due to it need
# to scrape logs.
#
# When a public key login is detected, KeyHound logs the user, source IP, and fingerprint as a string value.
# This string value is compared to the keyhound.log file to see if it already exists. If not, it will be 
# appended to the log. If it has been previously recorded, the value is discarded.

 
# ---------------------------------------------------------------------------------------------------------
# VARIABLE NOTES
# ---------------------------------------------------------------------------------------------------------
# cdate: equals the current date in abbriviated month (Jan, Feb, ...), space, space, day-of-month (typical in security logs)
# logdump: a clean parsing of publickey transactions from the day stored in a blob

# Verify/Create keyhound log file

if ! test -f '/var/log/keyhound.log';
then
	touch /var/log/keyhound.log;
fi

cdate=$(date +%b" "%e);
logdump=$(sudo grep "$cdate" /var/log/secure | grep publickey | sed s/" "/,/g | awk -F ',' '{print $10","$12","$17}' | sort -u); 
keyhoundlog=/var/log/keyhound.log

# Append new connections to keyhound.log

for record in $(echo $logdump); 
do
   grep $record $keyhoundlog; 

   if [[ $? -eq 1 ]]; 
   then 
      echo $record >> $keyhoundlog; 
   fi; 
done

# Cleanup vars

record=0;
logdump=0;
cdate=0;
