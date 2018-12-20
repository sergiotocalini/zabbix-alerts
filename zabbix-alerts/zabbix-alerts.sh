#!/usr/bin/env ksh

# TEAMS="Sysadmin"
# /etc/opsgenie/zabbix2opsgenie


# -triggerName='{TRIGGER.NAME}'
# -triggerId='{TRIGGER.ID}'
# -triggerStatus='{TRIGGER.STATUS}'
# -triggerSeverity='{TRIGGER.SEVERITY}'
# -triggerDescription='{TRIGGER.DESCRIPTION}'
# -triggerUrl='{TRIGGER.URL}'
# -triggerValue='{TRIGGER.VALUE}'
# -triggerHostGroupName='{TRIGGER.HOSTGROUP.NAME}'
# -hostName='{HOST.NAME}'
# -ipAddress='{IPADDRESS}'
# -eventId='{EVENT.ID}'
# -date='{DATE}'
# -time='{TIME}'
# -itemKey='{ITEM.KEY}'
# -itemValue='{ITEM.VALUE}'
# -recoveryEventStatus='{EVENT.RECOVERY.STATUS}'
# -tags='{EVENT.TAGS}'
# -teams="${TEAMS}"



# --channel
# --event-date
# --event-id
# --event-recovery-id
# --event-recovery-status
# --event-recovery-value
# --event-time
# --host-conn
# --host-description
# --host-ip
# --host-name
# --item-id
# --item-key
# --item-value
# --trigger-description
# --trigger-hostgroup-name
# --trigger-id
# --trigger-name
# --trigger-severity
# --trigger-status
# --trigger-tags
# --trigger-url
# --trigger-value

# /etc/zabbix/scripts/server/alertscripts/zabbix-alerts/zabbix-alerts.sh --channel=opsgenie --date='{DATE}' --time='{TIME}' --event-date='{EVENT.DATE}' --event-id='{EVENT.ID}' --event-status='{EVENT.STATUS}' --event-tags='{EVENT.TAGS}' --event-value='{EVENT.VALUE}' --event-time='{EVENT.TIME}' --event-recovery-date='{EVENT.RECOVERY.DATE}' --event-recovery-id='{EVENT.RECOVERY.ID}' --event-recovery-status='{EVENT.RECOVERY.STATUS}' --event-recovery-value='{EVENT.RECOVERY.VALUE}' --event-recovery-time='{EVENT.RECOVERY.TIME}' --host-id='{HOST.ID}' --host-description='{HOST.DESCRIPTION}' --host-dns='{HOST.DNS}' --host-ip='{HOST.IP}' --host-name='{HOST.NAME}' --item-id='{ITEM.ID}' --item-key='{ITEM.KEY}' --item-value='{ITEM.VALUE}' --trigger-description='{TRIGGER.DESCRIPTION}' --trigger-hostgroup-name='{TRIGGER.HOSTGROUP.NAME}' --trigger-id='{TRIGGER.ID}' --trigger-name='{TRIGGER.NAME}' --trigger-severity='{TRIGGER.NSEVERITY}' --trigger-status='{TRIGGER.STATUS}' --trigger-url='{TRIGGER.URL}' --trigger-value='{TRIGGER.VALUE}'

for i in "${@}"; do
    case ${i} in
	--channel=*)
	    CHANNEL="${i#*=}"
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
	--event-status=*)
	    EVENT_STATUS="${i#*=}"
	    ;;
	--event-value=*)
	    EVENT_VALUE="${i#*=}"
	    ;;
	--event-tags=*)
	    EVENT_TAGS="${i#*=}"
	    ;;
	--event-recovery-date=*)
	    EVENT_RECOVERY_DATE="${i#*=}"
	    ;;
	--event-recovery-time=*)
	    EVENT_RECOVERY_TIME="${i#*=}"
	    ;;
	--event-recovery-tags=*)
	    EVENT_RECOVERY_TAGS="${i#*=}"
	    ;;
	--time=*)
	    TIME="${i#*=}"
	    ;;
	--time=*)
	    TIME="${i#*=}"
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
    esac
done

echo "${CHANNEL} -- ${HOST_NAME} -- ${EVENT_DATE} -- ${EVENT_TIME} -- ${EVENT_STATUS} -- ${EVENT_RECOVERY_DATE} -- ${EVENT_RECOVERY_TIME} - ${EVENT_RECOVERY_STATUS}" >> /var/log/zabbix/zabbix-alerts.log
