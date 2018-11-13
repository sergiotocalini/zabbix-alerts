#!/usr/bin/env ksh

APP_DIR=$(dirname $0)

webhook="${1}"
incomming="${2}"
payload=`echo "${3}" | jq -c . 2>/dev/null`

[[ -n ${payload} ]] && pyteams --url="https://outlook.office.com/webhook/${webhook}/IncomingWebhook/${incomming}" --payload="${payload}"
