#!/bin/bash
# Author: Luka Stajkovic
# Title: Send out email about breached threshold
# Description: This script sends out email with data
# from cluster-health.sh script
# kredencijali u /etc/monitor/mail.env

if [[ -z "$1" ]];then
    exit 1
fi

source /etc/monitor/mail.env

{
    echo "From: $MAIL_USER"
    echo "To: $MAIL_USER"
    echo "Subject: [ALERT] cluster-health"
    echo ""
    echo -e "$1"

} > /tmp/alert-body.txt


curl -sS --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from "$MAIL_USER" \
    --mail-rcpt "$MAIL_USER" \
    --user "$MAIL_USER:$MAIL_PASS" \
    -T /tmp/alert-body.txt
