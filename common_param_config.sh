#!/bin/bash


# IP地址, 这里通过命令来读取, 但是不适用多网卡情况
HostIP=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
#oracle user password
OracleUserPasswd="oracle.com"
#default `systemOracle.com`
# sys用户密码
ORACLE_DB_PASSWD=""
#SID/SERVERNAME,default `oriedb`
# oracle 实例名称
SID="orcl"
# Install single instance choose charset
# 1-AL32UTF8(default), 2-ZHS16GBK
# Currently only supports single instance, does not support pdb
# 字符集
SINGLE_CHARSET='1'
# Install instance
#0-no,1-singleInstance,2-cdb
# oracle实例类型
IS_INSTANCE='1'
# Choose configure file path
# 0-remote(default)  1-local
# 配置文件来源
Get_Config_Method="1"
# install package online or offline
# online-online,offline-offline,default online
# 安装依赖包类型
Install_Package_Mode="offline"
# offline package path where you install packages from
# when the value of "Install_Package_Mode" is offline, the config can't be empty
# 离线依赖包路径
Offline_Package_Path="/tmp"
# start at boot whether or not
# 是否开机自启
# Y:是
Startup_At_Boot="Y"
# config oracle service whether or not
# 是否创建oracle服务
# Y: 是
Config_Oracle_Service="Y"


#---------------------------------------------------------------------------------#
#Global environment variable
if [[ ${SID} == "" ]];then
  SID="oriedb"
fi
root_path=`pwd`
response='/home/oracle/response'
MemTotle=$(grep -r 'MemTotal' /proc/meminfo | awk -F ' ' '{print int($2/1024/1024+1)}')
ORACLE_HOME='/data/app/oracle/product/12.2.0/db_1'
con_name="
sqlplus / as sysdba<< EOF
show con_name;
exit;
EOF
"
web_plugin="
sqlplus / as sysdba<< EOF
exec dbms_xdb_config.sethttpport(1522);
exit;
EOF
"
cdb_sql="
sqlplus / as sysdba<< EOF
shutdown abort;
create spfile from pfile='"$ORACLE_HOME/dbs/initcdb.ora"';
startup nomount;
CREATE DATABASE ${SID}
USER SYS IDENTIFIED BY pass
USER SYSTEM IDENTIFIED BY pass
LOGFILE GROUP 1 ('"/data/app/oracle/oradata/${SID}/redo01a.log"','"/data/app/oracle/oradata/${SID}/redo01b.log"')
SIZE 100M BLOCKSIZE 512,
GROUP 2 ('"/data/app/oracle/oradata/${SID}/redo02a.log"','"/data/app/oracle/oradata/${SID}/redo02b.log"')
SIZE 100M BLOCKSIZE 512
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
EXTENT MANAGEMENT LOCAL
DATAFILE '"/data/app/oracle/oradata/${SID}/system01.dbf"' SIZE 700M
SYSAUX DATAFILE '"/data/app/oracle/oradata/${SID}/sysaux01.dbf"' SIZE 550M
DEFAULT TABLESPACE deftbs
DATAFILE '"/data/app/oracle/oradata/${SID}/deftbs01.dbf"' SIZE 500M
DEFAULT TEMPORARY TABLESPACE tempts1
TEMPFILE '"/data/app/oracle/oradata/${SID}/temp01.dbf"' SIZE 20M
UNDO TABLESPACE undotbs1
DATAFILE '"/data/app/oracle/oradata/${SID}/undotbs01.dbf"' SIZE 200M
ENABLE PLUGGABLE DATABASE
SEED
FILE_NAME_CONVERT = ('"/data/app/oracle/oradata/${SID}/"',
'/data/app/oracle/oradata/pdbseed/')
SYSTEM DATAFILES SIZE 125M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
SYSAUX DATAFILES SIZE 100M
USER_DATA TABLESPACE usertbs
DATAFILE '/data/app/oracle/oradata/pdbseed/usertbs01.dbf' SIZE 200M;
exit
EOF
"


#Judgment parameter
# 参数校验
function j_para() {
  #判断必要参数是否存在
  if [[ ${HostIP} == '' ]];then
    echo -e "\033[34mInstallNotice >>\033[0m \033[31mPlease config HostIP\033[0m"
    exit
  fi
  #判断数据库包文件是否存在
  if [ ! -f "/tmp/linuxx64_12201_database.zip" ]; then
    echo -e "\033[34mInstallNotice >>\033[0m \033[31mlinuxx64_12201_database.zip not found\033[0m"
    exit
  fi
  # 判断oracle配置文件是否存在
  if [[ ${Get_Config_Method} == "1" ]]; then
    if [[ ${IS_INSTANCE} == '1' ]]; then
      if [[ ! -f ${root_path}/conf/db_install.rsp || ! -f ${root_path}/conf/dbca_single.rsp ]]; then
        echo -e "\033[34mInstallNotice >>\033[0m \033[31m ./conf/db_install.rsp or ./conf/dbca_single.rsp file not found\033[0m"
        exit
      fi
    elif [[ ${IS_INSTANCE} == '2' ]]; then
      if [[ ! -f ${root_path}/conf/initcdb.ora ]]; then
        echo -e "\033[34mInstallNotice >>\033[0m \033[31m ./conf/initcdb.ora file not found\033[0m"
        exit
      fi
    else
      if [[ ! -f ${root_path}/conf/db_install.rsp ]]; then
        echo -e "\033[34mInstallNotice >>\033[0m \033[31m ./conf/db_install.rsp file not found\033[0m"
        exit
      fi
    fi
  fi
  # 判断依赖包安装形式
  if [[ ${Install_Package_Mode} == 'offline' && ! -f ${Offline_Package_Path}/oralibs.tar.gz ]]; then
    echo -e "\033[34mInstallNotice >>\033[0m \033[31m ${Offline_Package_Path}/oralibs.tar.gz file not found\033[0m"
    exit
  fi
}

function main() {
    # 参数校验
    j_para
}

#run script
main
