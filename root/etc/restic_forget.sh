x#!/bin/bash

set -e

function do_print() {
    NOW=$(date +"%Y-%m-%d_%T")
    echo "[$NOW] $1"
}

do_print "Starting new restic forget job in $RESTIC_REPOSITORY"


# check for a hostname in env, if not present use container hostname
[[ -z "$RESTIC_HOSTNAME" ]] && $RESTIC_HOSTNAME=$(hostname)

restic \
    --repo $RESTIC_REPOSITORY \
    $RESTIC_OPTIONAL_ARGS \
    forget \
    --host=$RESTIC_HOSTNAME \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    --keep-yearly 2 \
