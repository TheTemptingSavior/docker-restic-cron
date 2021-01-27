#!/bin/bash

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

do_print "Running restic backup of $RESTIC_REPOSITORY"

# check for a hostname in env, if not present use container hostname
[[ -z "$RESTIC_HOSTNAME" ]] && $RESTIC_HOSTNAME=$(hostname)

restic \
    -r $RESTIC_REPOSITORY \
    -H $RESTIC_HOSTNAME \
    $RESTIC_OPTIONAL_ARGS \
    backup \
    /data

do_print "Running post-backup scripts"
# Run post-backup scripts
for f in /config/scripts/after/*; do
    if [ -f $f -a -x $f ]; then
        bash $f
    fi
done
