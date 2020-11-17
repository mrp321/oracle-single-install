#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错
source common_param_config.sh

# drop user and tablespaces
# 删除用户及其表空间
function drop_user_tablespaces() {
  echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m Starting droping user and tablespaces .\033[0m"
  DBS_DROP_FILE="${root_path}/conf/dbs_drop.txt"
  DATA_FILE_PATH="/data/app/oracle/oradata/orcl"
  # 判断指定配置文件是否存在
  if [[ ! -f ${DBS_DROP_FILE} ]]; then
    echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m ${DBS_DROP_FILE} file not found.\033[0m"
    exit
  fi

  index=0
  # 遍历读取配置文件中的每一行
  cat ${DBS_DROP_FILE} | while read line || [[ -n ${line} ]]; do
    # 每一行用":"进行分隔, 生成一个数组
    param_array=(${line//:/ })
    # 数组第0个元素为用户名
    username=${param_array[0]}
    # 数组第1个元素为表空间名
    tablespace=${param_array[1]}

    ts_arr[index]=${tablespace}
    index=$((index+1))

    echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m current username is : '${username}', tablespace is : '${tablespace}'.\033[0m"

    # 删除用户及其表空间sql
    # 1. 删除用户, 如果用户的schema中有objects ，需要加cascade参数
    # 2. 删除表空间时,INCLUDING CONTENTS AND DATAFILES:删除表空间及其数据文件;如果其他表空间中的表有外键等约束关联到了本表空间中的表的字段，就要加上CASCADE CONSTRAINTS
    # 2.1. 表空间drop前先offline
    # 2.2. 临时表空间不用offline ，可以直接drop
    db_sql="sqlplus / as sysdba<<EOF
DROP USER ${username} CASCADE;
ALTER TABLESPACE ${tablespace} OFFLINE;
DROP TABLESPACE ${tablespace} INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
DROP TABLESPACE ${tablespace}_TEMP INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
exit
EOF"
    echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m now start executing sql : '${db_sql}'.\033[0m"
    su - oracle -c "${db_sql}"
  done

  # 遍历表空间名称数组, 查询对应表空间数据文件是否已删除
  is_exists='N'
  for ts in "${ts_arr[@]}"; do
    data_file_name=${DATA_FILE_PATH}/${ts}.dbf
    if [[ -f ${data_file_name} ]]; then
      is_exists='Y'
      break
    fi
  done
  # 如果没有删除, 则后续重启数据库
  if [[ ${is_exists} == 'Y' ]]; then
    echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m Trying to restart oracle to release data files.\033[0m"
    # 关闭后重启数据库,使得磁盘空间得以释放
    free_sql="sqlplus / as sysdba<<EOF
shutdown
startup
exit
EOF"
    su - oracle -c "${free_sql}"
  fi
  echo -e "\033[34mDroping oracle user and tablespaces >>\033[0m \033[32m Finishing creating user and tablespaces .\033[0m"
}

function main() {
  drop_user_tablespaces
}

#run script
main
