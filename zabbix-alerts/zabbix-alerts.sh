#!/usr/bin/env ksh
IFS_DEFAULT=${IFS}

#################################################################################

#################################################################################
#
#  Variable Definition
# ---------------------
#
APP_NAME=$(basename $0)
APP_DIR=$(dirname $0)
APP_VER="1.0.0"
APP_WEB="http://www.sergiotocalini.com.ar/"
NOTIFY=""
LOG_FILE="/var/log/zabbix/zabbix-alerts.log"

#
#################################################################################

#################################################################################
#
#  Load Environment Variables
# ----------------------------
#
[ -f ${APP_DIR}/${APP_NAME%.*}.conf ] && . ${APP_DIR}/${APP_NAME%.*}.conf

#
#################################################################################

#################################################################################
#
#  Function Definition
# ---------------------
#
usage() {
    echo "Usage: ${APP_NAME%.*} [Options]"
    echo ""
    echo "Options:"
    echo "  -h            Displays this help message."
    echo "  -v            Show the script version."
    echo ""
    echo "Please send any bug reports to sergiotocalini@gmail.com"
    exit 1
}

version() {
    echo "${APP_NAME%.*} ${APP_VER}"
    exit 1
}

join() {
    delimiter=${1}
    shift
    array=( ${@} )

    str=""
    length=$(( ${#array[@]} - 1 ))
    for idx in ${!array[@]}; do
	if [[ ${array[${idx}]} != '' && ${array[${idx}]} != ${delimiter} ]]; then
	    str+="${array[${idx}]}"
	    if [[ ${idx} < ${length} ]]; then
		str+="${delimiter}"
	    fi
	fi
    done
    echo "${str}"
}

ifArrayHas() {
    item=${1}
    shift
    array=( "${@}" )
    for i in ${!array[@]}; do
	[[ ${array[${i}]} == ${item} ]] && return 0
    done
    return 1
}

#
#################################################################################

#################################################################################
#
#  Main loop
# -----------
#

for i in "${@}"; do
    case ${i} in
	--profile=*|--channel-profile=*)
	    CHANNEL_PROFILE="${i#*=}"
	    ;;	
	--channel-type=*)
	    CHANNEL_TYPE="${i#*=}"
	    ;;
	--channel-api-url=*)
	    CHANNEL_API_URL="${i#*=}"
	    ;;
	--channel-api-key=*)
	    CHANNEL_API_KEY="${i#*=}"
	    ;;
	--channel-api-username=*)
	    CHANNEL_API_USERNAME="${i#*=}"
	    ;;
	--channel-api-password=*)
	    CHANNEL_API_PASSWORD="${i#*=}"
	    ;;
	--payload=*)
	    PAYLOAD="${i#*=}"
	    ;;
	--date=*)
	    DATE="${i#*=}"
	    ;;
	--time=*)
	    TIME="${i#*=}"
	    ;;
	--event-id=*)
	    EVENT_ID="${i#*=}"
	    ;;
	--event-date=*)
	    EVENT_DATE="${i#*=}"
	    ;;
	--event-time=*)
	    EVENT_TIME="${i#*=}"
	    ;;
	--event-age=*)
	    EVENT_AGE="${i#*=}"
	    ;;	
	--event-status=*)
	    EVENT_STATUS="${i#*=}"
	    ;;
	--event-value=*)
	    EVENT_VALUE="${i#*=}"
	    ;;
	--event-tags=*)
	    EVENT_TAGS="${i#*=}"
	    ;;
	--event-recovery-id=*)
	    EVENT_RECOVERY_ID="${i#*=}"
	    ;;
	--event-recovery-date=*)
	    EVENT_RECOVERY_DATE="${i#*=}"
	    ;;
	--event-recovery-time=*)
	    EVENT_RECOVERY_TIME="${i#*=}"
	    ;;
	--event-recovery-status=*)
	    EVENT_RECOVERY_STATUS="${i#*=}"
	    ;;
	--event-recovery-tags=*)
	    EVENT_RECOVERY_TAGS="${i#*=}"
	    ;;
	--event-recovery-value=*)
	    EVENT_RECOVERY_VALUE="${i#*=}"
	    ;;
	--host-id=*)
	    HOST_ID="${i#*=}"
	    ;;
	--host-name=*)
	    HOST_NAME="${i#*=}"
	    ;;
	--host-description=*)
	    HOST_DESC="${i#*=}"
	    ;;
	--host-ip=*)
	    HOST_ADDR="${i#*=}"
	    ;;
	--host-dns=*)
	    HOST_DNS="${i#*=}"
	    ;;
	--host-conn=*)
	    HOST_CONN="${i#*=}"
	    ;;
	--item-id=*)
	    ITEM_ID="${i#*=}"
	    ;;
	--item-key=*)
	    ITEM_KEY="${i#*=}"
	    ;;
	--item-value=*)
	    ITEM_VALUE="${i#*=}"
	    ;;
	--trigger-id=*)
	    TRIGGER_ID="${i#*=}"
	    ;;
	--trigger-severity=*)
	    TRIGGER_SEVERITY="${i#*=}"
	    ;;
	--trigger-nseverity=*)
	    TRIGGER_NSEVERITY="${i#*=}"
	    ;;
	--trigger-name=*)
	    TRIGGER_NAME="${i#*=}"
	    ;;
	--trigger-description=*)
	    TRIGGER_DESCRIPTION="${i#*=}"
	    ;;
	--trigger-value=*)
	    TRIGGER_VALUE="${i#*=}"
	    ;;
	--trigger-status=*)
	    TRIGGER_STATUS="${i#*=}"
	    ;;
	--trigger-url=*)
	    TRIGGER_URL="${i#*=}"
	    ;;
	--trigger-hostgroup-name=*)
	    TRIGGER_HOSTGROUP_NAME="${i#*=}"
	    ;;
	--zabbix-url=*)
	    ZABBIX_URL="${i#*=}"
	    ;;
	--ack-date=*)
	    ACK_DATE="${i#*=}"
	    ;;
	--ack-time=*)
	    ACK_TIME="${i#*=}"
	    ;;
	--ack-message=*)
	    ACK_MESSAGE="${i#*=}"
	    ;;
	--inventory-hardware-full=*)
	    INVENTORY_HW_FULL="${i#*=}"
	    ;;
	--inventory-software-full=*)
	    INVENTORY_SW_FULL="${i#*=}"
	    ;;
    esac
done

[[ -z ${ZABBIX_URL} ]] && ZABBIX_URL="http://localhost/zabbix"

INV_HW_SITE=`echo "${INVENTORY_HW_FULL}" | jq -r .site 2>/dev/null`
INV_SW_ENV=`echo "${INVENTORY_SW_FULL}" | jq -r .env 2>/dev/null`

IFS=":" NOTIFY=( ${NOTIFY} )
IFS=${IFS_DEFAULT}

IFS=", " EVENT_TAGS=( ${EVENT_TAGS} )
IFS=${IFS_DEFAULT}

[[ -n ${INV_HW_SITE} ]] && TAGS[${#TAGS[@]}]="site:${INV_HW_SITE:-UNKNOWN}"
[[ -n ${INV_SW_ENV} ]] && TAGS[${#TAGS[@]}]="env:${INV_SW_ENV:-UNKNOWN}"
for t in ${!EVENT_TAGS[@]}; do
    IFS=":" values=( ${EVENT_TAGS[${t}]} )
    IFS=${IFS_DEFAULT}
    for v in ${!values[@]}; do
	if [[ ${v} == 0 ]]; then
	    label="${values[${v}]}"
	    continue
	fi
	if [[ ${label} =~ (teams|notify) ]]; then
	    if ! ifArrayHas "${values[${v}]}" "${NOTIFY[@]}"; then
		NOTIFY[${#NOTIFY[@]}]="${values[${v}]}"
	    fi
	else
	    if ! ifArrayHas "${label}:${values[${v}]}" "${TAGS[@]}"; then
		TAGS[${#TAGS[@]}]="${label}:${values[${v}]}"
	    fi
	fi
    done
done

echo "${DATE} ${TIME} -- ${INV_HW_SITE:-UNKNOWN} -- ${INV_SW_ENV:-UNKNOWN} -- ${HOST_NAME} -- ${EVENT_STATUS} -- ${EVENT_AGE} -- ${TRIGGER_NAME} -- ${ZABBIX_URL}/tr_events.php?triggerid=${TRIGGER_ID}&eventid=${EVENT_ID}" >> "${LOG_FILE}"

if [[ ${CHANNEL_TYPE:-zabbix2opsgenie} =~ (opsgenie|zabbix2opsgenie) ]]; then
    OPSGENIE_PRIORITY=`jq -r ".opsgenie.priority.\"${TRIGGER_NSEVERITY}\".code" ${APP_DIR}/mapper.json 2>/dev/null`
    OPSGENIE_PRIORITY="${OPSGENIE_PRIORITY//null/}"
fi

if [[ ${CHANNEL_TYPE:-zabbix2opsgenie} == "zabbix2opsgenie" ]]; then
    /etc/opsgenie/zabbix2opsgenie -hostName="${HOST_NAME}" \
				  -ipAddress="${HOST_ADDR}" \
				  -eventId="${EVENT_ID}" \
				  -date="${DATE}" \
				  -time="${TIME}" \
				  -triggerName="${TRIGGER_NAME}" \
				  -triggerId="${TRIGGER_ID}" \
				  -triggerStatus="${TRIGGER_STATUS}" \
				  -triggerSeverity="${OPSGENIE_PRIORITY:-P3}" \
				  -triggerDescription="${TRIGGER_DESCRIPTION}" \
				  -triggerUrl="${TRIGGER_URL}" \
				  -triggerValue="${TRIGGER_VALUE}" \
				  -triggerHostGroupName="${TRIGGER_HOSTGROUP_NAME}" \
				  -itemKey="${ITEM_KEY}" \
				  -itemValue="${ITEM_VALUE}" \
				  -recoveryEventStatus="${EVENT_RECOVERY_STATUS}" \
				  -tags="`join ', ' ${TAGS[@]}`" \
				  -teams="`join ',' ${NOTIFY[@]}`"
fi
