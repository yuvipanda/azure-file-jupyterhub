#!/bin/bash
#
# Mounts a CIFS volume usable by a given UID + GID
# Then drops root and starts process given as args
#
# Takes the following parameters as environment variables
#
# CIFS_URL
# URL to mount
#
# MOUNT_POINT
# Path to mount whole share at
#
# UID
# UID the mount should be accessible to
#
# GID
# GID the mount should be accessible to
#
# CIFS_USERNAME
# Username to use for authenticating to CIFS server
# Is read from /etc/cifs/secrets/azurestorageaccountname
#
# CIFS_PASSWORD
# Password to use for authenticating to CIFS server
# Is read from /etc/cifs/secrets/azurestorageaccountkey
#
# This script is expected to run as root. It'll drop all privileges
# and exec the commands it is passed to at the end.
set -e

#CIFS_PASSWORD=$(cat /etc/cifs/secrets/azurestorageaccountkey)
#CIFS_USERNAME=$(cat /etc/cifs/secrets/azurestorageaccountname)

echo "Creating ${MOUNT_POINT}"
mkdir -p ${MOUNT_POINT}

echo "Trying to mount..."
mount -t cifs \
      ${CIFS_URL} \
      ${MOUNT_POINT} \
      -o vers=3.0,cache=strict,uid=${UID},noforceuid,gid=${GID},noforcegid,file_mode=0700,dir_mode=0700,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1,username=${CIFS_USERNAME},password=${CIFS_PASSWORD}
echo "Mounted!"

echo "Starting required process"
# Unset all the params we needed
CIFS_USERNAME= CIFS_PASSWORD= CIFS_URL= GID= UID= MOUNT_POINT= \
   exec sudo -E -H -u "#${UID}" PATH=$PATH $@

