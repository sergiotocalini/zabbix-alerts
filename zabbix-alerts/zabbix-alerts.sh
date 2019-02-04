#!/usr/bin/env ksh
IFS_DEFAULT=${IFS}
TIMESTAMP=`date '+%s'`

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
LOG_FILE="/var/log/zabbix/zabbix_alerts.log"
TMP_DIR="${APP_DIR}/tmp"
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
JSON="{}"
for i in "${@}"; do
    case ${i} in
	--profile=*|--channel-profile=*)
	    CHANNEL_PROFILE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_PROFILE=\"${CHANNEL_PROFILE}\"" 2>/dev/null`
	    ;;	
	--channel-type=*)
	    CHANNEL_TYPE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_TYPE=\"${CHANNEL_TYPE}\"" 2>/dev/null`
	    ;;
	--channel-template=*)
	    CHANNEL_TEMPLATE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_TEMPLATE=\"${CHANNEL_TEMPLATE}\"" 2>/dev/null`
	    ;;	
	--channel-api-url=*)
	    CHANNEL_API_URL="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_API_URL=\"${CHANNEL_API_URL}\"" 2>/dev/null`
	    ;;
	--channel-api-key=*)
	    CHANNEL_API_KEY="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_API_KEY=\"${CHANNEL_API_KEY}\"" 2>/dev/null`
	    ;;
	--channel-api-username=*)
	    CHANNEL_API_USERNAME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_API_USERNAME=\"${CHANNEL_API_USERNAME}\"" 2>/dev/null`
	    ;;
	--channel-api-password=*)
	    CHANNEL_API_PASSWORD="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".CHANNEL_API_PASSWORD=\"${CHANNEL_API_PASSWORD}\"" 2>/dev/null`	    
	    ;;
	--action-color=*)
	    ACTION_COLOR="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ACTION_COLOR=\"${ACTION_COLOR}\"" 2>/dev/null`
	    ;;
	--action-image=*)
	    ACTION_IMAGE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ACTION_IMAGE=\"${ACTION_IMAGE}\"" 2>/dev/null`	    
	    ;;
	--payload=*)
	    PAYLOAD="${i#*=}"	    
	    ;;
	--date=*)
	    DATE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".DATE=\"${DATE}\"" 2>/dev/null`	    
	    ;;
	--time=*)
	    TIME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TIME=\"${TIME}\"" 2>/dev/null`	    
	    ;;
	--event-id=*)
	    EVENT_ID="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_ID=\"${EVENT_ID}\"" 2>/dev/null`	    
	    ;;
	--event-date=*)
	    EVENT_DATE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_DATE=\"${EVENT_DATE}\"" 2>/dev/null`	    
	    ;;
	--event-time=*)
	    EVENT_TIME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_TIME=\"${EVENT_TIME}\"" 2>/dev/null`	    
	    ;;
	--event-age=*)
	    EVENT_AGE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_AGE=\"${EVENT_AGE}\"" 2>/dev/null`	    
	    ;;	
	--event-status=*)
	    EVENT_STATUS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_STATUS=\"${EVENT_STATUS}\"" 2>/dev/null`	    
	    ;;
	--event-value=*)
	    EVENT_VALUE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_VALUE=\"${EVENT_VALUE}\"" 2>/dev/null`
	    ;;
	--event-tags=*)
	    EVENT_TAGS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_TAGS=\"${EVENT_TAGS}\"" 2>/dev/null`
	    ;;
	--event-recovery-id=*)
	    EVENT_RECOVERY_ID="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_ID=\"${EVENT_RECOVERY_ID}\"" 2>/dev/null`
	    ;;
	--event-recovery-date=*)
	    EVENT_RECOVERY_DATE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_DATE=\"${EVENT_RECOVERY_DATE}\"" 2>/dev/null`
	    ;;
	--event-recovery-time=*)
	    EVENT_RECOVERY_TIME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_TIME=\"${EVENT_RECOVERY_TIME}\"" 2>/dev/null`
	    ;;
	--event-recovery-status=*)
	    EVENT_RECOVERY_STATUS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_STATUS=\"${EVENT_RECOVERY_STATUS}\"" 2>/dev/null`
	    ;;
	--event-recovery-tags=*)
	    EVENT_RECOVERY_TAGS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_TAGS=\"${EVENT_RECOVERY_TAGS}\"" 2>/dev/null`
	    ;;
	--event-recovery-value=*)
	    EVENT_RECOVERY_VALUE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".EVENT_RECOVERY_VALUE=\"${EVENT_RECOVERY_VALUE}\"" 2>/dev/null`
	    ;;
	--host-id=*)
	    HOST_ID="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_ID=\"${HOST_ID}\"" 2>/dev/null`
	    ;;
	--host-name=*)
	    HOST_NAME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_NAME=\"${HOST_NAME}\"" 2>/dev/null`
	    ;;
	--host-description=*)
	    HOST_DESC="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_DESCRIPTION=\"${HOST_DESCRIPTION}\"" 2>/dev/null`
	    ;;
	--host-ip=*)
	    HOST_ADDR="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_IP=\"${HOST_IP}\"" 2>/dev/null`
	    ;;
	--host-dns=*)
	    HOST_DNS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_DNS=\"${HOST_DNS}\"" 2>/dev/null`
	    ;;
	--host-conn=*)
	    HOST_CONN="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".HOST_CONN=\"${HOST_CONN}\"" 2>/dev/null`
	    ;;
	--item-id=*)
	    ITEM_ID="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ITEM_ID=\"${ITEM_ID}\"" 2>/dev/null`
	    ;;
	--item-key=*)
	    ITEM_KEY="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ITEM_KEY=\"${ITEM_KEY}\"" 2>/dev/null`
	    ;;
	--item-value=*)
	    ITEM_VALUE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ITEM_VALUE=\"${ITEM_VALUE}\"" 2>/dev/null`
	    ;;
	--trigger-id=*)
	    TRIGGER_ID="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_ID=\"${TRIGGER_ID}\"" 2>/dev/null`
	    ;;
	--trigger-severity=*)
	    TRIGGER_SEVERITY="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_SEVERITY=\"${TRIGGER_SEVERITY}\"" 2>/dev/null`
	    ;;
	--trigger-nseverity=*)
	    TRIGGER_NSEVERITY="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_NSEVERITY=\"${TRIGGER_NSEVERITY}\"" 2>/dev/null`
	    ;;
	--trigger-name=*)
	    TRIGGER_NAME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_NAME=\"${TRIGGER_NAME}\"" 2>/dev/null`
	    ;;
	--trigger-description=*)
	    TRIGGER_DESCRIPTION="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_DESCRIPTION=\"${TRIGGER_DESCRIPTION}\"" 2>/dev/null`
	    ;;
	--trigger-value=*)
	    TRIGGER_VALUE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_VALUE=\"${TRIGGER_VALUE}\"" 2>/dev/null`
	    ;;
	--trigger-status=*)
	    TRIGGER_STATUS="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_STATUS=\"${TRIGGER_STATUS}\"" 2>/dev/null`
	    ;;
	--trigger-url=*)
	    TRIGGER_URL="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_URL=\"${TRIGGER_URL}\"" 2>/dev/null`
	    ;;
	--trigger-hostgroup-name=*)
	    TRIGGER_HOSTGROUP_NAME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".TRIGGER_HOSTGROUP_NAME=\"${TRIGGER_HOSTGROUP_NAME}\"" 2>/dev/null`
	    ;;
	--zabbix-url=*)
	    ZABBIX_URL="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ZABBIX_URL=\"${ZABBIX_URL}\"" 2>/dev/null`
	    ;;
	--ack-date=*)
	    ACK_DATE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ACK_DATE=\"${ACK_DATE}\"" 2>/dev/null`
	    ;;
	--ack-time=*)
	    ACK_TIME="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ACK_TIME=\"${ACK_TIME}\"" 2>/dev/null`
	    ;;
	--ack-message=*)
	    ACK_MESSAGE="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".ACK_MESSAGE=\"${ACK_MESSAGE}\"" 2>/dev/null`
	    ;;
	--inventory-hardware-full=*)
	    INVENTORY_HW_FULL="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".INVENTORY_HW_FULL=${INVENTORY_HW_FULL}" 2>/dev/null`
	    ;;
	--inventory-software-full=*)
	    INVENTORY_SW_FULL="${i#*=}"
	    JSON=`echo "${JSON}" | jq -c  ".INVENTORY_SW_FULL=${INVENTORY_SW_FULL}" 2>/dev/null`
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

echo "${DATE} ${TIME} -- ${INV_HW_SITE:-UNKNOWN} -- ${INV_SW_ENV:-UNKNOWN} -- ${HOST_NAME} -- ${EVENT_STATUS} -- ${EVENT_AGE} -- \"${TRIGGER_NAME}\"">> "${LOG_FILE}"

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
elif [[ ${CHANNEL_TYPE} == "teams" ]]; then
    WORK_DIR="${TMP_DIR}/teams/${TIMESTAMP}_${EVENT_ID}"
    mkdir -p "${WORK_DIR}" 2>/dev/null

    echo "${JSON}" | jq . > "${WORK_DIR}/data.json" 2>/dev/null || exit 1
    template="${APP_DIR}/templates/teams/fallback.j2"
    [[ -d "${APP_DIR}/templates/teams/${CHANNEL_TEMPLATE}" ]] || CHANNEL_TEMPLATE="default"
    if [[ ${EVENT_STATUS} == "PROBLEM" ]]; then
	file="${APP_DIR}/templates/teams/${CHANNEL_TEMPLATE}/problem.j2"
    elif [[ ${EVENT_STATUS} == "RESOLVED" ]]; then
	file="${APP_DIR}/templates/teams/${CHANNEL_TEMPLATE}/recovery.j2"
    else
	file="${APP_DIR}/templates/teams/${CHANNEL_TEMPLATE}/acknowledge.j2"
    fi
    [[ -n "${file}" && -f "${file}" ]] && template="${file}"
    
    payload=`j2 "${template}" "${WORK_DIR}/data.json" 2>/dev/null`
    if [[ -n ${payload} ]]; then
	pyteams --url="${CHANNEL_API_URL}" --payload="${payload}"
	if [[ ${?} == 0 ]]; then
	    rm -Rf "${WORK_DIR}" 2>/dev/null
	fi
    fi
fi
