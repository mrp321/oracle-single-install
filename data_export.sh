#!/bin/bash

root_path=`pwd`

# TODO 待完善

# 导出数据方式
Export_Data_Type="expdp"
# 导出数据目录
Export_Data_Dir=""
# 导出数据文件名
Export_Data_File=""
# 导出数据日志文件名
Export_Data_Log="export.log"
# 是否全库导出
Full="y"
# 指定要导出的表, 表之间用逗号分隔
Tables="tb1,tb2"
# 用户名
Username="ISMPDATA"
# 密码
Password="ISMPDATA"
# 数据库实例名
Sid="orcl"
# 模式
Schemas=""
# 表空间
Tablespaces="ISMPDATA_DATA"
# 所有者
Owner=""
# 查询条件
Query=""

Export_sql=""

function exportByType() {
  echo -n -e "\033[34mExportData >>\033[0m \033[31mPlease enter export type: \033[0m"
  read -r Export_Data_Type
  echo -e "\033[34mExportData >>\033[0m \033[31mHello, current export type is: ${Export_Data_Type}: \033[0m"
  echo -e "\033[34mExportData >>\033[0m \033[31mStarting exporting data.\033[0m"
  # 判断导出的数据的方式
  if [[ ${Export_Data_Type} == "expdp" ]]; then
    Config_File="${root_path}/conf/data_export_expdp.txt"
    parseConfig
    expdp
  elif [[ ${Export_Data_Type} == "exp" ]]; then
    Config_File="${root_path}/conf/data_export_exp.txt"
    parseConfig
    exp
  else
    echo -e "\033[34mExportData >>\033[0m \033[31mThe export data type is not specified.\033[0m"
    exit
  fi
  echo -e "\033[34mExportData >>\033[0m \033[31mStarting executing export data sql: '${Export_sql}'.\033[0m"
  # 执行sql
  su - oracle -c "${Export_sql}"
  echo -e "\033[34mExportData >>\033[0m \033[31mExporting data successfully.\033[0m"
}

function expdp() {
  Export_sql="expdp ${Username}/${Password}@${Sid} directory=${Export_Data_Dir} dumpfile=${Export_Data_File} logfile=${Export_Data_Log} "
  # 是否完全导出
  if [[ ${Full} == "y" ]]; then
    Export_sql="${Export_sql}  full=y "
  elif [[ ${Tables} != "" ]]; then
    Export_sql="${Export_sql}  tables=${Tables} "
  else
    echo -e "\033[34mExportData >>\033[0m \033[31mThe exported table is not specified.\033[0m"
    exit
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Export_sql="${Export_sql}  tablespaces=${Tablespaces} "
  fi
  # 用户
  if [[ ${Schemas} != "" ]]; then
    Export_sql="${Export_sql}  schemas=${Schemas} "
  fi
  # 查询条件
  if [[ ${Query} != "" ]]; then
    Export_sql="${Export_sql}  query=${Query} "
  fi
}

function exp() {
  Export_sql="exp ${Username}/${Password}@${Sid} file=${Export_Data_Dir}/${Export_Data_File} log=${Export_Data_Dir}/${Export_Data_Log} "
  # 是否完全导出
  if [[ ${Full} == "y" ]]; then
    Export_sql="${Export_sql}  full=y "
  elif [[ ${Tables} != "" ]]; then
    Export_sql="${Export_sql}  tables=(${Tables}) "
  else
    echo -e "\033[34mExportData >>\033[0m \033[31mThe exported table is not specified.\033[0m"
    exit
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Export_sql="${Export_sql}  tablespaces=(${Tablespaces}) "
  fi
  # 所有者
  if [[ ${Schemas} != "" ]]; then
    Export_sql="${Export_sql}  owner=(${Owner}) "
  fi
  # 查询条件
  if [[ ${Query} != "" ]]; then
    Export_sql="${Export_sql}  query=${Query} "
  fi
}

function parseConfig() {
  #  # 导出数据方式
  #  Export_Data_Type=$(cat ${Config_File} | grep Export_Data_Type | cut -d'=' -f2)
  # 导出数据目录
  Export_Data_Dir=$(cat ${Config_File} | grep Export_Data_Dir | cut -d'=' -f2)
  # 导出数据文件名
  Export_Data_File=$(cat ${Config_File} | grep Export_Data_File | cut -d'=' -f2)
  # 导出数据日志文件名
  Export_Data_Log=$(cat ${Config_File} | grep Export_Data_Log | cut -d'=' -f2)
  # 是否全库导出
  Full=$(cat ${Config_File} | grep Full | cut -d'=' -f2)
  # 指定要导出的表, 表之间用逗号分隔
  Tables=$(cat ${Config_File} | grep Tables | cut -d'=' -f2)
  # 用户名
  Username=$(cat ${Config_File} | grep Username | cut -d'=' -f2)
  # 密码
  Password=$(cat ${Config_File} | grep Password | cut -d'=' -f2)
  # 数据库实例名
  Sid=$(cat ${Config_File} | grep Sid | cut -d'=' -f2)
  # 模式
  Schemas=$(cat ${Config_File} | grep Schemas | cut -d'=' -f2)
  # 表空间
  Tablespaces=$(cat ${Config_File} | grep Tablespaces | cut -d'=' -f2)
  # 所有者
  Owner=$(cat ${Config_File} | grep Owner | cut -d'=' -f2)
  # 查询条件
  Query=$(cat ${Config_File} | grep Query | cut -d'=' -f2)
  # tables 和 schemas 和 tablespaces 以及 full 不能同时配置, 否则会报错
  if [[ ${Full} == "y" && "${Tables}${Schemas}${Tablespaces}" == "" ]] || [[ "${Tables}${Schemas}${Tablespaces}" == "${Tables}" || "${Tables}${Schemas}${Tablespaces}" == "${Schemas}" || "${Tables}${Schemas}${Tablespaces}" == "${Tablespaces}" && ${Full} != "y" ]]; then
    echo -e "\033[34mExportData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' check ok.\033[0m"
  else
    echo -e "\033[34mExportData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' can't exist at the same time, PLEASE check your configuration.\033[0m"
    exit
  fi
}

function main() {
  # 导出数据
  exportByType
}

#run script
main
