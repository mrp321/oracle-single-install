#!/bin/bash

root_path=`pwd`

Operate_Sql=""

############################################配置解析##############################################

# 根据配置文件中的操作类型决定是导入还是导出数据
function operateByType() {
  echo -e "\033[34mOperateData >>\033[0m \033[31mStarting operating data, your current operate type is: '${Operate_Data_Type}'.\033[0m"
  # 判断导出的数据的方式
  if [[ ${Operate_Data_Type} == "expdp" || ${Operate_Data_Type} == "exp" || ${Operate_Data_Type} == "impdp" || ${Operate_Data_Type} == "imp" ]]; then
    eval "${Operate_Data_Type}"
  else
    echo -e "\033[34mOperateData >>\033[0m \033[31mThe operate data type is not specified.\033[0m"
    exit
  fi
  echo -e "\033[34mOperateData >>\033[0m \033[31mStarting executing operate data sql: '${Operate_Sql}'.\033[0m"
  # 执行sql
  su - oracle -c "${Operate_Sql}"
  echo -e "\033[34mOperateData >>\033[0m \033[31mOperating data successfully.\033[0m"
}
##########################################数据导出#############################################

# 数据泵导出
function expdp() {
  Operate_Sql="expdp ${Username}/${Password}@${Sid} directory=${Operate_Data_Dir} dumpfile=${Operate_Data_File} logfile=${Operate_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Operate_Sql="${Operate_Sql}  full=y "
  fi
  if [[ ${Tables} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tables=(${Tables}) "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tablespaces=${Tablespaces} "
  fi
  # 用户
  if [[ ${Schemas} != "" ]]; then
    Operate_Sql="${Operate_Sql}  schemas=${Schemas} "
  fi
  # 查询条件
  if [[ ${Query} != "" ]]; then
    Operate_Sql="${Operate_Sql}  query=${Query} "
  fi
}

# 数据导出
function exp() {
  Operate_Sql="exp ${Username}/${Password}@${Sid} file=${Operate_Data_Dir}/${Operate_Data_File} log=${Operate_Data_Dir}/${Operate_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Operate_Sql="${Operate_Sql}  full=y "
  fi
  if [[ ${Tables} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tables=(${Tables}) "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tablespaces=(${Tablespaces}) "
  fi
  # 所有者
  if [[ ${Schemas} != "" ]]; then
    Operate_Sql="${Operate_Sql}  owner=(${Owner}) "
  fi
  # 查询条件
  if [[ ${Query} != "" ]]; then
    Operate_Sql="${Operate_Sql}  query='${Query}' "
  fi
}

##########################################数据导入#############################################

# 数据泵导入
function impdp() {
  Operate_Sql="impdp ${Username}/${Password}@${Sid} directory=${Operate_Data_Dir} dumpfile=${Operate_Data_File} logfile=${Operate_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Operate_Sql="${Operate_Sql}  full=y "
  fi
  if [[ ${Tables} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tables=(${Tables}) "
  fi
  if [[ ${Ignore} == "y" ]]; then
    Operate_Sql="${Operate_Sql} ignore=y "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tablespaces=${Tablespaces} "
  fi
  # 修改表的所有者
  if [[ ${Remap_Schema} != "" ]]; then
    Operate_Sql="${Operate_Sql}  remap_schema=${Remap_Schema} "
  fi
  # 追加数据
  if [[ ${Table_Exists_Action} == "y" ]]; then
    Operate_Sql="${Operate_Sql}  table_exists_action"
  fi
}

# 数据导入
function imp() {
  Operate_Sql="imp ${Username}/${Password}@${Sid} file=${Operate_Data_Dir}/${Operate_Data_File} log=${Operate_Data_Dir}/${Operate_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Operate_Sql="${Operate_Sql}  full=y "
  fi
  if [[ ${Tables} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tables=(${Tables}) "
  fi
  if [[ ${Ignore} == "y" ]]; then
    Operate_Sql="${Operate_Sql} ignore=y "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Operate_Sql="${Operate_Sql}  tablespaces=(${Tablespaces}) "
  fi
  # 所有者
  if [[ ${Schemas} != "" ]]; then
    Operate_Sql="${Operate_Sql}  owner=(${Owner}) "
  fi
}

function parseConfig() {
  # 检测配置文件是否存在
  Config_File="${root_path}/conf/data_operate.txt"
  if [ ! -f ${Config_File} ]; then
    echo -e "\033[34mOperateData >>\033[0m \033[31mConfig file not exists.\033[0m"
    exit
  fi
  # 解析配置文件
  declare -A config_array
  oldIFS=$IFS
  IFS=\=
  while read key value; do
    config_array[$key]=$value
    echo -e "\033[34mOperateData >>\033[0m \033[31mParsing config pairs: '${key}=${value}'.\033[0m"
  done <"${Config_File}"
  IFS=$oldIFS
  # 变量赋值
  Operate_Data_Type=${config_array[Operate_Data_Type]}
  Operate_Data_Dir=${config_array[Operate_Data_Dir]}
  Operate_Data_File=${config_array[Operate_Data_File]}
  Operate_Data_Log=${config_array[Operate_Data_Log]}
  Full=${config_array[Full]}
  Tables=${config_array[Tables]}
  Username=${config_array[Username]}
  Password=${config_array[Password]}
  Sid=${config_array[Sid]}
  Schemas=${config_array[Schemas]}
  Tablespaces=${config_array[Tablespaces]}
  Owner=${config_array[Owner]}
  Query=${config_array[Query]}
  Ignore=${config_array[Ignore]}
  Remap_Schema=${config_array[Remap_Schema]}
  Table_Exists_Action=${config_array[Table_Exists_Action]}

  # tables 和 schemas 和 tablespaces 以及 full 不能同时配置, 否则会报错
  if [[ ${Full} == "y" && "${Tables}${Schemas}${Tablespaces}" == "" ]] || [[ "${Tables}${Schemas}${Tablespaces}" == "${Tables}" || "${Tables}${Schemas}${Tablespaces}" == "${Schemas}" || "${Tables}${Schemas}${Tablespaces}" == "${Tablespaces}" && ${Full} != "y" ]]; then
    echo -e "\033[34mOperateData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' check ok.\033[0m"
  else
    echo -e "\033[34mOperateData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' can't exist at the same time, PLEASE check your configuration.\033[0m"
    exit
  fi
}

# 从用户输入中获取操作类型
function readOperateType() {
  echo -n -e "\033[34mExportData >>\033[0m \033[31mPlease enter operate type: \033[0m"
  read -r Export_Data_Type
  echo -e "\033[34mExportData >>\033[0m \033[31mHello, current operate type is: ${Export_Data_Type}: \033[0m"
}

function main() {
  # 解析配置
  parseConfig && \
  # 导出数据
  operateByType
}

#run script
main
