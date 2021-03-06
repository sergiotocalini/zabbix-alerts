#!/usr/bin/env ksh
SOURCE_DIR=$(dirname $0)
ZABBIX_DIR=/etc/zabbix
PREFIX_DIR="${ZABBIX_DIR}/scripts/server/alertscripts/zabbix-alerts"

LOG_FILE="${1:-/var/log/zabbix/zabbix-alerts.log}"
NOTIFY="${2}"

mkdir -p "${PREFIX_DIR}/profile.d" "${PREFIX_DIR}/templates" 2>/dev/null

SCRIPT_CONFIG="${PREFIX_DIR}/zabbix-alerts.conf"
[[ -f ${SCRIPT_CONFIG} ]] && SCRIPT_CONFIG="${SCRIPT_CONFIG}.new"

cp -rp ${SOURCE_DIR}/LICENSE                                      ${PREFIX_DIR}/LICENSE
cp -rp ${SOURCE_DIR}/README.md                                    ${PREFIX_DIR}/README.md
cp -rp ${SOURCE_DIR}/zabbix-alerts/zabbix-alerts.sh               ${PREFIX_DIR}/zabbix-alerts.sh
cp -rp ${SOURCE_DIR}/zabbix-alerts/zabbix-alerts.conf.example     ${SCRIPT_CONFIG}
cp -rp ${SOURCE_DIR}/zabbix-alerts/mapper.json                    ${PREFIX_DIR}/mapper.json
cp -rp ${SOURCE_DIR}/zabbix-alerts/actionCommand.txt              ${PREFIX_DIR}/actionCommand.txt
cp -rp ${SOURCE_DIR}/zabbix-alerts/profile.d/example.json.save    ${PREFIX_DIR}/profile.d/example.json.save
cp -rp ${SOURCE_DIR}/zabbix-alerts/templates/*                    ${PREFIX_DIR}/templates/

chown -R zabbix: "${PREFIX_DIR}"
chmod -R 755     "${PREFIX_DIR}"

regex_array[0]="s|LOG_FILE=.*|LOG_FILE=\"${LOG_FILE}\"|g"
regex_array[1]="s|NOTIFY=.*|NOTIFY=\"${NOTIFY}\"|g"
for index in ${!regex_array[*]}; do
    sed -i "${regex_array[${index}]}" ${SCRIPT_CONFIG}
done

if [[ ${SCRIPT_CONFIG} =~ .*.new$ ]]; then
    if diff ${SCRIPT_CONFIG} ${SCRIPT_CONFIG%.new} > /dev/null; then
	rm ${SCRIPT_CONFIG}
    fi
fi

pip install -r ${SOURCE_DIR}/requirements.txt
