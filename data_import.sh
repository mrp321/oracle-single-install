#!/bin/bash

root_path=`pwd`

# TODO 待完善

# 导入数据方式
Import_Data_Type="impdp"
# 导入数据目录
Import_Data_Dir=""
# 导入数据文件名
Import_Data_File=""
# 导入数据日志文件名
Import_Data_Log="import.log"
# 是否全库导入
Full="y"
# 指定要导入的表, 表之间用逗号分隔
Tables="tb1,tb2"
# 是否忽略已导入的数据
Ignore="y"
# 用户名
Username="ISMPDATA"
# 密码
Password="ISMPDATA"
# 数据库实例名
Sid="orcl"
# 模式
Schemas="ISMPDATA"
# 表空间
Tablespaces="ISMPDATA_DATA"
# 所有者
Owner=""
# 修改后的所有者
Remap_Schema=""
# 是否追加数据
Table_Exists_Action="y"

Import_sql=""

function importByType() {
  echo -n -e "\033[34mImportData >>\033[0m \033[31mPlease enter import type: \033[0m"
  read -r Import_Data_Type
  echo -e "\033[34mImportData >>\033[0m \033[31mHello, current import type is: ${Import_Data_Type}: \033[0m"
  echo -e "\033[34mImportData >>\033[0m \033[31mStarting importing data.\033[0m"
  # 判断导入的数据的方式
  if [[ ${Import_Data_Type} == "impdp" ]]; then
    Config_File="${root_path}/conf/data_import_impdp.txt"
    parseConfig
    impdp
  elif [[ ${Import_Data_Type} == "imp" ]]; then
    Config_File="${root_path}/conf/data_import_imp.txt"
    parseConfig
    imp
  else
    echo -e "\033[34mImportData >>\033[0m \033[31mThe import data type is not specified.\033[0m"
    exit
  fi
  echo -e "\033[34mImportData >>\033[0m \033[31mStarting executing import data sql: '${Import_sql}'.\033[0m"
  # 执行sql
  su - oracle -c "${Import_sql}"
  echo -e "\033[34mImportData >>\033[0m \033[31mImporting data successfully.\033[0m"
}

function impdp() {
  Import_sql="impdp ${Username}/${Password}@${Sid} directory=${Import_Data_Dir} dumpfile=${Import_Data_File} logfile=${Import_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Import_sql="${Import_sql}  full=y "
  elif [[ ${Tables} != "" ]]; then
    Import_sql="${Import_sql}  tables=${Tables} "
  else
    echo -e "\033[34mImportData >>\033[0m \033[31mThe imported table is not specified.\033[0m"
    exit
  fi
  if [[ ${Ignore} == "y" ]]; then
    Import_sql="${Import_sql} ignore=y "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Import_sql="${Import_sql}  tablespaces=${Tablespaces} "
  fi
  # 修改表的所有者
  if [[ ${Remap_Schema} != "" ]]; then
    Import_sql="${Import_sql}  remap_schema=${Remap_Schema} "
  fi
  # 追加数据
  if [[ ${Table_Exists_Action} == "y" ]]; then
    Import_sql="${Import_sql}  table_exists_action"
  fi
}

function imp() {
  Import_sql="imp ${Username}/${Password}@${Sid} file=${Import_Data_Dir}/${Import_Data_File} log=${Import_Data_Dir}/${Import_Data_Log} "
  # 是否完全导入
  if [[ ${Full} == "y" ]]; then
    Import_sql="${Import_sql}  full=y "
  elif [[ ${Tables} != "" ]]; then
    Import_sql="${Import_sql}  tables=(${Tables}) "
  else
    echo -e "\033[34mImportData >>\033[0m \033[31mThe imported table is not specified.\033[0m"
    exit
  fi
  if [[ ${Ignore} == "y" ]]; then
    Import_sql="${Import_sql} ignore=y "
  fi
  # 表空间
  if [[ ${Tablespaces} != "" ]]; then
    Import_sql="${Import_sql}  tablespaces=(${Tablespaces}) "
  fi
  # 所有者
  if [[ ${Schemas} != "" ]]; then
    Import_sql="${Import_sql}  owner=(${Owner}) "
  fi
}

function parseConfig() {
  #  # 导出数据方式
  #  Import_Data_Type=$(cat ${Config_File} | grep Import_Data_Type | cut -d'=' -f2)
  Import_Data_Dir=$(cat ${Config_File} | grep Import_Data_Dir | cut -d'=' -f2)
  Import_Data_File=$(cat ${Config_File} | grep Import_Data_File | cut -d'=' -f2)
  Import_Data_Log=$(cat ${Config_File} | grep Import_Data_Log | cut -d'=' -f2)
  Full=$(cat ${Config_File} | grep Full | cut -d'=' -f2)
  Tables=$(cat ${Config_File} | grep Tables | cut -d'=' -f2)
  Ignore=$(cat ${Config_File} | grep Ignore | cut -d'=' -f2)
  Username=$(cat ${Config_File} | grep Username | cut -d'=' -f2)
  Password=$(cat ${Config_File} | grep Password | cut -d'=' -f2)
  Sid=$(cat ${Config_File} | grep Sid | cut -d'=' -f2)
  Schemas=$(cat ${Config_File} | grep Schemas | cut -d'=' -f2)
  Tablespaces=$(cat ${Config_File} | grep Tablespaces | cut -d'=' -f2)
  Owner=$(cat ${Config_File} | grep Owner | cut -d'=' -f2)
  Remap_Schema=$(cat ${Config_File} | grep Remap_Schema | cut -d'=' -f2)
  Table_Exists_Action=$(cat ${Config_File} | grep Table_Exists_Action | cut -d'=' -f2)
  # tables 和 schemas 和 tablespaces 以及 full 不能同时配置, 否则会报错
  if [[ ${Full} == "y" && "${Tables}${Schemas}${Tablespaces}" == "" ]] || [[ "${Tables}${Schemas}${Tablespaces}" == "${Tables}" || "${Tables}${Schemas}${Tablespaces}" == "${Schemas}" || "${Tables}${Schemas}${Tablespaces}" == "${Tablespaces}" && ${Full} != "y" ]]; then
    echo -e "\033[34mImportData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' check ok.\033[0m"
  else
    echo -e "\033[34mImportData >>\033[0m \033[31m'Tables' or 'Schemas' or 'Tablespaces' or 'Full' can't exist at the same time, PLEASE check your configuration.\033[0m"
    exit
  fi
}

function main() {
  # 导入数据
  importByType
}

#run script
main
