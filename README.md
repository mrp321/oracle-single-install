### oracle 12C 自动化静默安装脚本

#### 下载安装脚本
```bash
wget https://raw.githubusercontent.com/spdir/oracle-single-install/master/oracle_install.sh && \ 
chmod +x oracle_install.sh
```

#### 脚本使用安装前配置
> root用户执行(尽量系统为纯净环境)
1. 安装前请将Oracle 12C安装包放置在`/tmp`目录下
2. 系统需要具备512MB的交换分区
3. 系统可连通外网 <font color="red"> 当前测试环境无网络联网 </font>
4. 并配置以下信息
  - 本机IP地址 `HostIP` <font color="red"> => 已修改为"192.168.229.138" </font>
  - Oracle用户密码 `OracleUserPasswd` 默认为`oracle.com` <font color="red"> => 未修改 </font>
  - Oracle数据库管理员密码 `ORACLE_DB_PASSWD` 默认为 `systemOracle.com`  <font color="red"> => 未修改 </font>
  - Oracle SID/ServerName `SID` 默认为 `oriedb` <font color="red">  => 已修改为"orcl" </font>
  - 是否安装实例 `IS_INSTANCE` <font color="red">  => 已配置为"1" </font>
    - 0-不安装实例
    - 1-安装单实例
    - 2-安装cdb : 因为CDB在初始化过程中需要输入参数，需要手动初始化,具体步骤会在最后进行提示
  - 设置单实例默认字符编码`SINGLE_CHARSET` <font color="red"> => 未修改 </font>
    - 1-`AL32UTF8` 默认
    - 2-`ZHS16GBK`
  - 选择配置静默安装配置文件的获取方式`Get_Config_Method` <font color="red"> => 已修改为"2" </font>
    - 0-远程(默认)
    - 2-本地获取(脚本执行根目录下需要有`conf`目录存放配置文件)
      - `db_install.rsp`  数据库安装配置文件
      - `dbca_single.rsp`  数据库单实例初始化配置文件
      - `initcdb.ora`  CDB初始化配置文件
      
> 注意事项:
> 1. 去除脚本中安装依赖的方法, 改为手动安装离线依赖
> 2. 由于该脚本是在Windows下编辑的, 因此在Linux下执行前, 请先执行`sed -i 's/\r//' oracle_install.sh`


#### Oracle 12C安装包下载
[百度网盘](https://pan.baidu.com/s/1YvgmT0_Pm7y4O2XOxlFc3g)

#### 支持系统
<font color=red size=2>注: 脚本已在CentOS 7.x进行测试。如果有其他什么问题，请提交 `issues`反馈</font> 
- CentOS 7 64/32


>注意: 在初始化cdb过程中如果出现 `No options to container mapping specified, no options will be installed in any containers` 信息不是报错，因为cdb初始化时间比较长，可以通过查看以上提示下给出的日志路径查看初始化情况


#### 补充说明 

##### 脚本执行环境

* Linux => CentOS 7.5


* Oracle => Oracle 12c


* 虚拟机系统配置
    * 内存: 3G
    * 磁盘: 40G
    * CPU: 4核
    * 网络: NAT


* 操作系统安装设置
    * SOFTWARE SELECTION: Minimal Install
![](index_files/5f78029e-6cf0-49e0-b33c-32bdc15a2ff6.png)


* 操作系统网络设置
    * 无网络连接(通过是否配置DNS的方式来决定网络的通断)
    
    
##### 脚本执行所需离线依赖


```
binutils-2.27-43.base.el7_8.1.x86_64.rpm
compat-libcap1-1.10-7.el7.x86_64.rpm
compat-libstdc++-33-3.2.3-72.el7.i686.rpm
compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
cpp-4.8.5-39.el7.x86_64.rpm
epel-release-7-11.noarch.rpm
gcc-4.8.5-39.el7.x86_64.rpm
gcc-c++-4.8.5-39.el7.x86_64.rpm
glibc-2.17-307.el7.1.i686.rpm
glibc-2.17-307.el7.1.x86_64.rpm
glibc-common-2.17-307.el7.1.x86_64.rpm
glibc-devel-2.17-307.el7.1.i686.rpm
glibc-devel-2.17-307.el7.1.x86_64.rpm
glibc-headers-2.17-307.el7.1.x86_64.rpm
gpm-libs-1.20.7-6.el7.x86_64.rpm
gssproxy-0.7.0-28.el7.x86_64.rpm
kernel-headers-3.10.0-1127.19.1.el7.x86_64.rpm
keyutils-1.5.8-3.el7.x86_64.rpm
ksh-20120801-142.el7.x86_64.rpm
libaio-0.3.109-13.el7.i686.rpm
libaio-0.3.109-13.el7.x86_64.rpm
libaio-devel-0.3.109-13.el7.i686.rpm
libaio-devel-0.3.109-13.el7.x86_64.rpm
libbasicobjects-0.1.1-32.el7.x86_64.rpm
libcollection-0.7.0-32.el7.x86_64.rpm
libevent-2.0.21-4.el7.x86_64.rpm
libgcc-4.8.5-39.el7.i686.rpm
libgcc-4.8.5-39.el7.x86_64.rpm
libgomp-4.8.5-39.el7.x86_64.rpm
libini_config-1.3.1-32.el7.x86_64.rpm
libmpc-1.0.1-3.el7.x86_64.rpm
libnfsidmap-0.25-19.el7.x86_64.rpm
libpath_utils-0.2.1-32.el7.x86_64.rpm
libref_array-0.1.5-32.el7.x86_64.rpm
libstdc++-4.8.5-39.el7.i686.rpm
libstdc++-4.8.5-39.el7.x86_64.rpm
libstdc++-devel-4.8.5-39.el7.i686.rpm
libstdc++-devel-4.8.5-39.el7.x86_64.rpm
libtirpc-0.2.4-0.16.el7.x86_64.rpm
libverto-libevent-0.2.5-4.el7.x86_64.rpm
libX11-1.6.7-2.el7.i686.rpm
libX11-1.6.7-2.el7.x86_64.rpm
libX11-common-1.6.7-2.el7.noarch.rpm
libXau-1.0.8-2.1.el7.i686.rpm
libXau-1.0.8-2.1.el7.x86_64.rpm
libxcb-1.13-1.el7.i686.rpm
libxcb-1.13-1.el7.x86_64.rpm
libXext-1.3.3-3.el7.i686.rpm
libXext-1.3.3-3.el7.x86_64.rpm
libXi-1.7.9-1.el7.i686.rpm
libXi-1.7.9-1.el7.x86_64.rpm
libXtst-1.2.3-1.el7.i686.rpm
libXtst-1.2.3-1.el7.x86_64.rpm
lm_sensors-libs-3.4.0-8.20160601gitf9185e5.el7.
mailx-12.5-19.el7.x86_64.rpm
make-3.82-24.el7.x86_64.rpm
mpfr-3.1.1-4.el7.x86_64.rpm
net-tools-2.0-0.25.20131004git.el7.x86_64.rpm
nfs-utils-1.3.0-0.66.el7_8.x86_64.rpm
nspr-4.21.0-1.el7.x86_64.rpm
nss-softokn-freebl-3.44.0-8.el7_7.i686.rpm
nss-softokn-freebl-3.44.0-8.el7_7.x86_64.rpm
nss-util-3.44.0-4.el7_7.x86_64.rpm
perl-5.16.3-295.el7.x86_64.rpm
perl-Carp-1.26-244.el7.noarch.rpm
perl-constant-1.27-2.el7.noarch.rpm
perl-Encode-2.51-7.el7.x86_64.rpm
perl-Exporter-5.68-3.el7.noarch.rpm
perl-File-Path-2.09-2.el7.noarch.rpm
perl-File-Temp-0.23.01-3.el7.noarch.rpm
perl-Filter-1.49-3.el7.x86_64.rpm
perl-Getopt-Long-2.40-3.el7.noarch.rpm
perl-HTTP-Tiny-0.033-3.el7.noarch.rpm
perl-libs-5.16.3-295.el7.x86_64.rpm
perl-macros-5.16.3-295.el7.x86_64.rpm
perl-parent-0.225-244.el7.noarch.rpm
perl-PathTools-3.40-5.el7.x86_64.rpm
perl-Pod-Escapes-1.04-295.el7.noarch.rpm
perl-Pod-Perldoc-3.20-4.el7.noarch.rpm
perl-Pod-Simple-3.28-4.el7.noarch.rpm
perl-Pod-Usage-1.63-3.el7.noarch.rpm
perl-podlators-2.5.1-3.el7.noarch.rpm
perl-Scalar-List-Utils-1.27-248.el7.x86_64.rpm
perl-Socket-2.010-5.el7.x86_64.rpm
perl-Storable-2.45-3.el7.x86_64.rpm
perl-Text-ParseWords-3.29-4.el7.noarch.rpm
perl-threads-1.87-4.el7.x86_64.rpm
perl-threads-shared-1.43-6.el7.x86_64.rpm
perl-Time-HiRes-1.9725-3.el7.x86_64.rpm
perl-Time-Local-1.2300-2.el7.noarch.rpm
quota-4.01-19.el7.x86_64.rpm
quota-nls-4.01-19.el7.noarch.rpm
rpcbind-0.2.0-49.el7.x86_64.rpm
smartmontools-7.0-2.el7.x86_64.rpm
sysstat-10.1.5-19.el7.x86_64.rpm
tcp_wrappers-7.6-77.el7.x86_64.rpm
unixODBC-2.3.1-14.el7.x86_64.rpm
unixODBC-devel-2.3.1-14.el7.x86_64.rpm
unzip-6.0-21.el7.x86_64.rpm
vim-common-7.4.629-6.el7.x86_64.rpm
vim-enhanced-7.4.629-6.el7.x86_64.rpm
vim-filesystem-7.4.629-6.el7.x86_64.rpm
wget-1.14-18.el7_6.1.x86_64.rpm
zlib-1.2.7-18.el7.i686.rpm
zlib-1.2.7-18.el7.x86_64.rpm
zlib-devel-1.2.7-18.el7.i686.rpm
zlib-devel-1.2.7-18.el7.x86_64.rpm
```