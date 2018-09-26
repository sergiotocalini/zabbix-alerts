#!/usr/bin/env ksh

APP_DIR=$(dirname $0)

webhook="${1}"
incomming="${2}"
payload="${3}"

pyteams --url="https://outlook.office.com/webhook/${webhook}/IncomingWebhook/${incomming}" --payload="${payload}"
