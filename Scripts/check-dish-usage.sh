#!/bin/bash

FILESYSTEM=$(df -hl --output=source,avail,pcent,target | sort -k3 -hr | head -n 1 | awk '{ print $1 }')
AVAILABLE_SPACE=$(df -hl --output=source,avail,pcent,target | sort -k3 -hr | head -n 1 | awk '{ print $2 }' | sed 's/G//')
USE_PRECENTAGE=$(df -hl --output=source,avail,pcent,target | sort -k3 -hr | head -n 1 | awk '{ print $3 }' | sed 's/%//')
MOUNT_POINT=$(df -hl --output=source,avail,pcent,target | sort -k3 -hr | head -n 1 | awk '{ print $4 }')

echo " FILESYSTEM : ${FILESYSTEM} "
echo " USE_PRECENTAGE : ${USE_PRECENTAGE}% "
echo " AVAILABLE_SPACE : ${AVAILABLE_SPACE}G "
echo " MOUNT_POINT : ${MOUNT_POINT} "
echo ""

#If disk usage is greater than "80%" and "/" is the mount point .
if [ "$USE_PRECENTAGE" -ge 80 ] && [ "$AVAILABLE_SPACE" -le 2 ] && [ "$MOUNT_POINT" = "/" ]; 
then 
    sudo du -hax --max-depth=2 / | sort -hr | head -n 5
    exit 0
    fi


#If disk usage is greater than "80%" and "/home" is the mount point .
if [ "$USE_PRECENTAGE" -ge 80 ] && [ "$AVAILABLE_SPACE" -le 2 ] && [ "$MOUNT_POINT" = "/home" ]; 
then 
    DIRECTORY=$(sudo du -hax --max-depth=1 /home | sort -hr | head -n 5)
    
    echo "Hi <RECIPTANTS> ,

Following directory is consuming maximum space on this server , please take a look and do the needful, let us know in case there is any assistance is needed.

Directories:
$DIRECTORY

<RECIPTANTS> : Kindly create a incident for <RECIPTANTS> Team."
    fi


#If disk usage is greater than "80%" and "/boot" is the mount point .
if [ "$USE_PRECENTAGE" -ge 80 ] && [ "$MOUNT_POINT" = "/boot" ]; 
then 
    echo "Check boot as its consuming maximum space "
    exit 0
    fi

#If disk usage is greater than "80%" and "/apps" is the mount point .
if [ "$USE_PRECENTAGE" -ge 80 ] && [ "$AVAILABLE_SPACE" -le 2 ] && [ "$MOUNT_POINT" = "/apps" ]; 
then 
    echo "Hi <RECIPTANTS> ,

Following directory is consuming maximum space on this server , please take a look and do the needful, let us know in case there is any assistance is needed.

Details:

"Used : ${USE_PRECENTAGE}% "
"Available space : ${AVAILABLE_SPACE}G "
"Mount Point : ${MOUNT_POINT} "

<RECIPTANTS> : Kindly create a incident for <RECIPTANTS>."
    exit 0
    fi
