#!/bin/bash

curl "https://gotify.example.com/message?token=$GOTIFY_TOKEN" \
    -F "title=Restic Backup Started" \
    -F "message=special message here" \
    -F "priority=5"