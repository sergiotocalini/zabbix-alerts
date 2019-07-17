# zabbix-alerts
Zabbix Server - Alerts Scripts

This repository has several channels to integrate zabbix actions.

# Dependencies
## Packages
* curl
* jq
* [j2cli](https://github.com/kolypto/j2cli)

### Debian/Ubuntu

```
~# sudo apt install curl jq
~#
```

# Deploy
```
~# git clone https://github.com/sergiotocalini/zabbix-alerts
~# DEFAULT_TEAMS="devops:developers"
~# ./zabbix-alerts/install.sh "/var/log/zabbix/zabbix-alerts.log" "${DEFAULT_TEAMS}"
```

# How to use it
```
~# TEAMS_WEBHOOK="https://outlook.office.com/webhook/.../IncomingWebhook/.../..."
~# ACTION_IMAGE="https://www.kasa-solutions.com/wp-content/uploads/sites/2/2016/01/warning.png"
~# /etc/zabbix/scripts/server/alertscripts/zabbix-alerts/zabbix-alerts.sh \
       --payload="{ALERT.MESSAGE}" \
       --channel-type="teams" --channel-template="default" --channel-api-url="${TEAMS_WEBHOOK}" \
       --date="{DATE}" --time="{TIME}" --host-id="{HOST.ID}" --host-description="{HOST.DESCRIPTION}" \
       --host-dns="{HOST.DNS}" --host-ip="{HOST.IP}" --host-name="{HOST.NAME}" \
       --event-date="{EVENT.DATE}" --event-age="{EVENT.AGE}" --event-id="{EVENT.ID}" \
       --event-status="{EVENT.STATUS}" --event-tags="{EVENT.TAGS}" --event-value="{EVENT.VALUE}" \
       --event-time="{EVENT.TIME}" --event-recovery-date="{EVENT.RECOVERY.DATE}" \
       --event-recovery-id="{EVENT.RECOVERY.ID}" --event-recovery-status="{EVENT.RECOVERY.STATUS}" \
       --event-recovery-value="{EVENT.RECOVERY.VALUE}" --event-recovery-time="{EVENT.RECOVERY.TIME}" \
       --item-id="{ITEM.ID}" --item-key="{ITEM.KEY}" --item-value='{ITEM.VALUE}' \
       --trigger-value='{TRIGGER.VALUE}' --trigger-description="{TRIGGER.DESCRIPTION}" \
       --trigger-hostgroup-name='{TRIGGER.HOSTGROUP.NAME}' --trigger-id="{TRIGGER.ID}" \
       --trigger-name="{TRIGGER.NAME}" --trigger-severity='{TRIGGER.SEVERITY}' \
       --trigger-nseverity='{TRIGGER.NSEVERITY}' --trigger-status='{TRIGGER.STATUS}' --trigger-url="{TRIGGER.URL}" \
       --inventory-hardware-full='{INVENTORY.HARDWARE.FULL}' --inventory-software-full='{INVENTORY.SOFTWARE.FULL}' \
       --zabbix-url="{$ZABBIX_URL}" --ack-date="{ACK.DATE}" --ack-time="{ACK.TIME}" --ack-message="{ACK.MESSAGE}" \
       --action-image="${ACTION_IMAGE}"
~#
```
**Note**: Please take into account the quotes with the macros and the variables.

# Channels
## SMS
* ASPSMS: [pyaspsms](https://github.com/sergiotocalini/pyaspsms)

## Webhooks
* Microsoft Teams: [pyteams](https://github.com/sergiotocalini/pyteams)


