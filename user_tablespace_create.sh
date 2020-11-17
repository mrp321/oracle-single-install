#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错
source common_param_config.sh

# create user and tablespaces
function create_user_tablespaces() {
  echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m Starting creating user and tablespaces .\033[0m"
  DBS_FILE="${root_path}/conf/dbs.txt"

  # 判断指定配置文件是否存在
  if [[ ! -f ${DBS_FILE} ]]; then
    echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m ${DBS_FILE} file not found.\033[0m"
    exit
  fi

  # 路径不存在, 则创建(用于数据泵导入导出)
  DATADP_PATH="/data/app/datadp"
  if [ ! -d ${DATADP_PATH} ]; then
    mkdir -p ${DATADP_PATH}
  fi

  echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m creating datadp directory.\033[0m"
  datadp_sql="sqlplus / as sysdba<<EOF
create or replace directory datadp_dir as '${DATADP_PATH}';
exit
EOF"
  su - oracle -c "${datadp_sql}"

  cat ${DBS_FILE} | while read line || [[ -n ${line} ]]; do
    param_array=(${line//:/ })
    username=${param_array[0]}
    password=${param_array[1]}
    tablespace=${param_array[2]}
    echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m current username is : '${username}', password is : '${password}', tablespace is : '${tablespace}'.\033[0m"
    db_sql="sqlplus / as sysdba<<EOF
create tablespace ${tablespace} datafile '/data/app/oracle/oradata/orcl/${tablespace}.dbf' size 2048M AUTOEXTEND ON NEXT 200M;
create temporary tablespace ${tablespace}_TEMP tempfile '/data/app/oracle/oradata/orcl/${tablespace}_TEMP.dbf' size 2048M AUTOEXTEND ON NEXT 200M;
create user ${username} identified by ${password} default tablespace ${tablespace} temporary tablespace ${tablespace}_TEMP;
grant read,write on directory datadp_dir to ${username};
grant dba,resource,unlimited tablespace to ${username};
exit
EOF"
    echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m now start executing sql : '${db_sql}'.\033[0m"
    su - oracle -c "${db_sql}"
  done
  echo -e "\033[34mCreating oracle user and tablespaces >>\033[0m \033[32m Finishing creating user and tablespaces .\033[0m"
}

function main() {
  create_user_tablespaces
}

#run script
main
