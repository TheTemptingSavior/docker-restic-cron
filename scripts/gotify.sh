#!/bin/bash

curl "https://gotify.example.com/message?token=asupersecrettoken" \
    -F "title=Restic Backup" \
    -F "message=special message here" \
    -F "priority=5"