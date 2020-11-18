

# 1. 文件结构说明

```
|   common_param_config.sh => 公共参数配置脚本
|   db_create.sh => 用户名, 表空间创建脚本
|   oracle_config_install.sh => oracle配置与安装脚本
|   oracle_install.sh => oracle安装单脚本
|   oracle_install_each_step.sh => oracle安装多脚本
|   oracle_service_config.sh => oracle服务及自启配置脚本
|   pkg_install.sh => oracle依赖包安装脚本
|   README-summary.md => 描述文件
|   README.md => 描述文件
|
\---conf => oracle配置文件
        dbca_single.rsp
        dbs.txt => 用户名, 表空间创建配置文件
        dbs_drop.txt => 用户名, 表空间删除配置文件
        db_install.rsp
        initcdb.ora
```

# 2. 环境说明

* Linux: CentOS7.5

* Oracle: Oracle12C


# 3. 使用说明

## 3.1. 修改脚本配置, 数据库安装配置

### 3.1.1. 修改脚本配置

```
# 数据库实例名称
SID="orcl"
# 安装oracle单实例
IS_INSTANCE='1'
# 离线获取配置文件
Get_Config_Method="1"
# 离线安装依赖包(需要提前准备好离线依赖包, 并放置在执行路径下)
Install_Package_Mode="offline"
# 离线安装依赖包放置路径
Offline_Package_Path="/tmp"
```


### 3.1.2. 数据库安装配置

* conf/下新建文件dbs.txt, 内容如下

```
ACTDATA:ACTDATA:ACTDATA_DATA
ISMPDATA:ISMPDATA:ISMPDATA_DATA
```

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/b5a023cb-7785-4558-a94c-9e7ad929cc33.png)


* 该文件内容的格式为

```
用户名1:密码1:表空间名1
用户名2:密码2:表空间名2
```


* 注意,文件中不能有空行,否则脚本可能会执行失败, 比如

```
ACTDATA:ACTDATA:ACTDATA_DATA
ISMPDATA:ISMPDATA:ISMPDATA_DATA

```

## 3.2. 放置数据库安装包, 离线依赖包, 安装脚本


* `/tmp`下放置数据库安装包`linuxx64_12201_database.zip`, 离线依赖包`oralibs.tar.gz`


![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/fe298e48-44a8-4de6-9c41-044d15c55476.png)


* `/root`下放置自动化安装脚本以及`conf/`目录

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/c9ba98d9-4d65-4e47-bac8-9afa228150bb.png)

* 安装脚本名称为`oracle_install.sh`

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/fe175a3b-9cdb-4b9f-afeb-b5889b0a9eed.png)

* `conf/`目录中包含3个oracle相关配置文件以及一个自定义配置文件

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/c5d256fb-e900-4c73-8515-17e348ee8cf5.png)

## 3.3. 执行脚本(oracle_install.sh)

### 3.3.1. 安装脚本授权

```
# 去除脚本中可能存在的\r字符
[root@localhost ~]# sed -i 's/\r//' oracle_install.sh
[root@localhost ~]# sed -i 's/\r//' *.sh
# 去除配置文件中可能存在的\r字符
[root@localhost ~]# sed -i 's/\r//' conf/dbs.txt
[root@localhost ~]# sed -i 's/\r//' conf/*.txt
# 授权
[root@localhost ~]# chmod 777 -R conf/ oracle_install.sh 
[root@localhost ~]# chmod 777 -R conf/ *.sh
```

### 3.3.2. 执行安装脚本

* 执行安装脚本, 等待执行完毕

```
[root@localhost ~]# sh oracle_install.sh
```


![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/56dc40ca-5dad-4cdf-aa25-eda6c00dc4f3.png)

* 自动解压安装离线依赖

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/cf28eee7-13ac-4f13-8cd3-d6e3d1267bb6.png)

* 自动解压缩安装包

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/ef5160b0-5cc4-49c7-80e6-0d796225ed08.png)

* 自动安装oracle

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/0c992ff2-c801-46fa-b8f7-5e908f0152a0.png)

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/2dcd20a8-3764-4e7b-96dd-bd046bdd4d44.png)

* 自动创建用户, 表空间

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/496950bf-994b-47c6-b3e1-73dfc63b23b8.png)

![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/d555b1b5-5a8f-4e84-ac1b-ba81ed938008.png)

## 3.4. 执行脚本(其他脚本)

* 由于`oracle_install.sh`包含了oracle安装的所有配置以及安装操作, 因此为了防止执行脚本的任意过程中出现问题, 将该脚本拆分成了多个独立的脚本


```
|   common_param_config.sh => 公共参数配置脚本
|   user_tablespace_create.sh => 用户名, 表空间创建脚本
|   user_tablespace_drop.sh => 用户名, 表空间删除脚本
|   oracle_config_install.sh => oracle配置与安装脚本
|   oracle_install_each_step.sh => oracle安装多脚本组合
|   oracle_service_config.sh => oracle服务及自启配置脚本
|   pkg_install.sh => oracle依赖包安装脚本

```

* **注意:** 需要通过`./xx.sh`方式执行这些独立的脚本, 不能通过`sh xx.sh`方式执行. 否则,脚本中执行到`source xxx`时会报错


## 3.5. 数据库数据导入(仅供参考, 不代表实际执行情况)


* 切换至oracle用户

```
su - oracle
```

### 3.5.1. impdp命令导入

* 将通过`expdp`命令导出的数据文件`ISMPDATA.dump`放置到`/data/app/datadp`下, 后执行

```
# impdp 用户名/密码@数据库实例名 directory=逻辑目录名称 dumpfile=待导入数据文件 full=y logfile=日志文件
impdp ISMPDATA/ISMPDATA@orcl directory=datadp_dir dumpfile=ISMPDATA.dump full=y logfile=impdp.log
```

### 3.5.2. imp命令导入

* 将通过`exp`命令导出的数据文件`ISMPDATA.dmp`

```
# imp 用户名/密码 file=dmp文件路径 log=输出日志路径 full=y(是否完全导入) ignore=y(是否忽略异常信息);
imp ISMPDATA/ISMPDATA@orcl file=/home/oracle/ISMPDATA.dmp log=/home/oracle/imp.log full=y ignore=y;
```


### 3.5.3. 图形化工具导入(PLSQL Developer)

* 工具 -> 导入表


![](http://vipkshttp1.wiz.cn/ks/share/resources/48b72e29-29a8-44aa-98fe-efd1ed56a782/b72947d9-be13-4e1f-992d-157dfdf864dd/index_files/a77ab5b2-b2ed-4ead-9baa-1c811f5ee969.png)