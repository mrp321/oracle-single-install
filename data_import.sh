#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错
source common_param_config.sh

# TODO 待完善

IMPORT_DATA_TYPE="impdp"
IMPORT_DATA_PATH=""
IMPORT_DATA_LOG=""

import_sql=""

if [[ ${IMPORT_DATA_TYPE} == "impdp" ]]; then
  import_sql="impdp ISMPDATA/ISMPDATA@orcl directory=datadp_dir dumpfile=ISMPDATA.dump full=y logfile=impdp.log"
else
  import_sql="imp ISMPDATA/ISMPDATA@orcl file=/home/oracle/ISMPDATA.dmp log=/home/oracle/imp.log full=y ignore=y"
fi

su - oracle -c "${import_sql}"
