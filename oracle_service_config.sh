#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错
source common_param_config.sh

# config oracle start up at boot TODO
# 配置开机自启
function config_startup_at_boot() {
  ORATAB_FILE="/etc/oratab"
  if [[ ${Startup_At_Boot} == 'Y' ]]; then
    sed -i "s/:N/:Y/g" ${ORATAB_FILE}
    echo -e "\033[34mConfig startup at boot >>\033[0m \033[32mConfig startup at boot successfully.\033[0m"
  else
    echo -e "\033[34mConfig startup at boot >>\033[0m \033[32mSkip config startup at boot.\033[0m"
  fi
}

# config oracle service TODO
# 配置oracle服务以及开机启动
function config_oracle_service() {
  if [[ ${Config_Oracle_Service} == 'Y' ]]; then
    ORACLE_SERVICE_FILE="/usr/lib/systemd/system/oracle.service"
    touch ${ORACLE_SERVICE_FILE}
    echo "[Unit]" >${ORACLE_SERVICE_FILE}
    echo "Description=Oracle Database 12c Startup/Shutdown Service" >>${ORACLE_SERVICE_FILE}
    echo "After=syslog.target network.target" >>${ORACLE_SERVICE_FILE}
    echo "[Service]" >>${ORACLE_SERVICE_FILE}
    echo "LimitMEMLOCK=infinity" >>${ORACLE_SERVICE_FILE}
    echo "LimitNOFILE=65535" >>${ORACLE_SERVICE_FILE}
    echo "Type=oneshot" >>${ORACLE_SERVICE_FILE}
    echo "RemainAfterExit=yes" >>${ORACLE_SERVICE_FILE}
    echo "User=oracle" >>${ORACLE_SERVICE_FILE}
    echo "Environment=\"ORACLE_HOME=${ORACLE_HOME}\"" >>${ORACLE_SERVICE_FILE}
    echo "ExecStart=${ORACLE_HOME}/bin/dbstart $ORACLE_HOME >> 2>&1 &" >>${ORACLE_SERVICE_FILE}
    echo "ExecStop=${ORACLE_HOME}/bin/dbshut $ORACLE_HOME 2>&1 &" >>${ORACLE_SERVICE_FILE}
    echo "[Install]" >>${ORACLE_SERVICE_FILE}
    echo "WantedBy=multi-user.target" >>${ORACLE_SERVICE_FILE}

    systemctl enable oracle.service
  else
    echo -e "\033[34mConfig oracle service >>\033[0m \033[32mSkip config oracle service.\033[0m"
  fi
}

function main() {
  # 配置开机自启
  config_startup_at_boot && \
  # 配置oracle服务
  config_oracle_service
}

#run script
main
