#!/bin/bash

# Runs an incremental backup of all the data within the 
# `/data` directory to the remote repository

set -e

function do_print() {
    NOW=$(date +"%Y-%m-%d_%T")
    echo "[$NOW] $1"
}

do_print "Starting new restic backup"


do_print "Running pre-backup scripts"
# Run pre-backup scripts
for f in /config/scripts/before/*; do
    if [ -f $f -a -x $f ]; then
        bash $f
    fi
done


# check for a hostname in env, if not present exit because the hostname is
# tied to the repository name
[[ -z "$RESTIC_HOSTNAME" ]] && exit 1


do_print "Running restic backup of $RESTIC_REPOSITORY"
restic \
    --repo $RESTIC_REPOSITORY \
    $RESTIC_OPTIONAL_ARGS \
    backup \
    --host $RESTIC_HOSTNAME \
    $RESTIC_OPTIONAL_BACKUP_ARGS \
    /data


do_print "Running restic forget of $RESTIC_REPOSITORY"
restic \
    --repo $RESTIC_REPOSITORY/$RESTIC_HOSTNAME \
    $RESTIC_OPTIONAL_ARGS \
    forget \
    --host=$RESTIC_HOSTNAME \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    --keep-yearly 2 \


do_print "Running post-backup scripts"
# Run post-backup scripts
for f in /config/scripts/after/*; do
    if [ -f $f -a -x $f ]; then
        bash $f
    fi
done


do_print "Completed restic backup of $RESTIC_REPOSITORY"