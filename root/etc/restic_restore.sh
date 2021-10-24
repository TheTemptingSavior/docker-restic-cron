#!/bin/bash

# Runs an incremental backup of all the data within the 
# `/data` directory to the remote repository

set -e

function do_print() {
    NOW=$(date +"%Y-%m-%d_%T")
    echo "[$NOW] $1"
}

do_print "This will restore all the data from the last snapshot into the `/data/` directory"
do_print "This operation is irreversible. Type 'yes' to continue"

read $USER_INPUT
if [ "$USER_INPUT" = "yes" ]; then
    do_print "Continuing with the restic restore"
else
    do_print "You must type 'yes' to continue this operation"
    exit 1
fi


do_print "Beginning restore now"
restic \
    --repo $RESTIC_REPOSITORY:$RESTIC_HOSTNAME \
    $RESTIC_OPTIONAL_ARGS \
    restore \
    --host $RESTIC_HOSTNAME \
    --target /data \
    --verfiy \
    latest


do_print "Restore complete!"
