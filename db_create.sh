# create databases
function create_dbs() {
    root_path=`pwd`
    echo -e "\033[34mCreating oracle databases >>\033[0m \033[32m Starting creating databases .\033[0m"
    DBS_FILE="${root_path}/conf/dbs.txt"
    DATADP_PATH="/data/app/datadp"
    if [ ! -d ${DATADP_PATH} ];then
      mkdir -p ${DATADP_PATH}
    fi
    datadp_sql="sqlplus / as sysdba<<EOF
    create or replace directory datadp_dir as '/data/app/datadp';
    exit
    EOF"
    su - oracle -c "${db_sql}"

    cat ${DBS_FILE} | while read line
    do
      if [[ line == '' ]]; then
        exit
      fi
      param_array=(${line//:/ })
      username=${param_array[0]}
      password=${param_array[1]}
      tablespace=${param_array[2]}
      echo "current username is ${username}"
      echo "current password is ${password}"
      echo "current tablespace is ${tablespace}"
      db_sql="create tablespace ${tablespace} datafile '/data/app/oracle/oradata/orcl/${tablespace}.dbf' size 2048M AUTOEXTEND ON NEXT 200M;
      create temporary tablespace ${tablespace}_TEMP tempfile '/data/app/oracle/oradata/orcl/${tablespace}_TEMP.dbf' size 2048M AUTOEXTEND ON NEXT 200M;
      create user ${username} identified by ${password} default tablespace ${tablespace} temporary tablespace ${tablespace}_TEMP;
      grant read,write on directory datadp_dir to ${username};
      grant dba,resource,unlimited tablespace to ${username};
      exit
      EOF"
      echo -e "current sql is : ${db_sql}"
    done
    echo -e "\033[34mCreating oracle databases >>\033[0m \033[32m Finishing creating databases .\033[0m"
}

function main() {
  create_dbs
}

#run script
main
