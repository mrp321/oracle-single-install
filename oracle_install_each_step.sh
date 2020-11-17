#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错

# 公共参数配置与校验
source common_param_config.sh
# 判断是否已经开启监听
# 如果已经开启监听, 且监听状态为READY, 则认为oracle已经安装成功, 跳过oracle的安装过程
su - oracle -c "lsnrctl status | grep -q 'READY'"
if [ $? -ne 0 ]; then
  # 安装离线依赖包
  source pkg_install.sh
  # oracle配置与安装
  source oracle_config_install.sh
else
  # oracle服务安装与自启
  source oracle_service_config.sh
  # 创建用户和表空间
  source user_tablespace_create.sh
fi