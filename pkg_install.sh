#!/bin/bash

# 注意:需要通过`./xx.sh`方式执行脚本, 不能通过`sh xx.sh`方式执行脚本. 否则,脚本中执行`source xxx`时会报错
source common_param_config.sh


#install package TODO
# 安装依赖包
function install_package() {
  if [[ ${Install_Package_Mode} == 'online' || ${Install_Package_Mode} == '' ]]; then
    # 在线安装
    install_package_online
  elif [[ ${Install_Package_Mode} == 'offline' ]]; then
    # 离线安装
    install_package_offline
  else
    # 不安装
    # not install package
    echo -e "\033[34mInstall Package Offline >>\033[0m \033[32mSkip install package.\033[0m"
    exit
  fi
}

# install package online
# 在线安装依赖包
function install_package_online() {
  yum install -y binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 glibc glibc.i686 \
  glibc-devel glibc-devel.i686 ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libX11 libX11.i686 \
  libXau libXau.i686 libXi libXi.i686 libXtst libXtst.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 \
  libstdc++-devel libstdc++-devel.i686 libxcb libxcb.i686 make nfs-utils net-tools smartmontools sysstat \
  unixODBC unixODBC-devel gcc gcc-c++ libXext libXext.i686 zlib-devel zlib-devel.i686 unzip wget vim epel-release
}

# install package offline TODO
# 离线安装依赖包
function install_package_offline() {
  if [[ ${Offline_Package_Path} != '' ]]; then
    # 配置本地yum源
    config_local_repo
    # 解压离线安装依赖包
    tar -zvxf ${Offline_Package_Path}/oralibs.tar.gz -C ${Offline_Package_Path}
    # 安装离线依赖包
    rpm -ivh --force --nodeps /tmp/oralibs/*.rpm
    echo -e "\033[34mInstall Package Offline >>\033[0m \033[32mInstall package offline successfully.\033[0m"
  else
    # 跳过安装
    echo -e "\033[34mInstall Package Offline >>\033[0m \033[32mSkip install package offline.\033[0m"
  fi
}

# config local repo TODO
# 创建本地yum源
function config_local_repo() {
  echo "[local]" >/etc/yum.repos.d/local.repo
  echo "name=local" >>/etc/yum.repos.d/local.repo
  echo "enable=1" >>/etc/yum.repos.d/local.repo
  echo "baseurl=file:///${Offline_Package_Path}/oralibs" >>/etc/yum.repos.d/local.repo
  echo "gpgcheck=0" >>/etc/yum.repos.d/local.repo
  # 清空yum缓存
  yum clean all
  # 创建yum缓存
  yum makecache
}


function main() {
  # 安装依赖包
  install_package
}

#run script
main
