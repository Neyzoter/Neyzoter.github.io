---
layout: wiki
title: Linux
categories: Linux
description: 类 Unix 系统下的一些常用命令和用法。
keywords: Linux
---

类 Unix 系统下的一些常用命令和用法。

# 1、远程控制相关
## 1.1 登录远程服务器
1、登录远程服务器

```bash
$ ssh <username>@<hostname or ip_address> -p <port>
```

我的IP是：`115.159.154.***`,域名是`neyzoter.cn`,(`-p port` 可以省略，表示端口)

2、退出远程服务器

`Ctrl+D`

## 1.2 scp上传/下载文件
```bash
$ scp 本地文件地址+文件名  远程用户名@IP地址:+服务器内存放文件的地址。（这里用户名用root）
```

例如：scp /home/wj/桌面/aa.txt root@111.231.1.101:/home/aa.txt

```bash
$ scp -r 远程用户名@IP地址:+服务器内存放文件的地址 本地文件地址
```

## 1.2 发送udp包

```bash
$ echo "hello" |socat - udp4-datagram:115.159.154.xxx:8080
```

## 1.3 关掉某个端口的进程

```bash
$ netstat -tlnp   # 查看正在监听的端口
$ sudo lsof -i:端口号    # 查看某个端口号 的PID
$ sudo kill -9 端口的PID    # 根据端口的PID来关闭端口监听
```

## 1.x 安装java
1、查看有java包

```bash
$ java
```
腾讯提供的一些包——

>default-jre
gcj-5-jre-headless
openjdk-8-jre-headless
gcj-4.8-jre-headless
gcj-4.9-jre-headless
openjdk-9-jre-headless

2、安装java8

```bash
sudo apt-get install openjdk-8-jre-headless
```

3、查看java版本

```
$ java -version
```

## 1.x 安装mysql-server
1、apt安装
```bash
$ sudo apt-get install mysql-server
```

不需要安装mysql-client。

2、登录MySQL并更改用户授权

```bash
$ mysql -u root -p
```

输入密码。

```bash
$ use mysql
```

```
mysql> $ update user set host='%' whereuser='root';
```

```
myslq> $ grant all privileges on  *.* TO 'root'@'%' identified by 'XXX' WITHGRANT OPTION;
```

XXX的位置是root的密码

```
myslq> $ FLUSH PRIVILEGES;
```
exit退出。

3、修改本地访问的3306端口

首先，修改配置文件：

```bash
$ vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

首先输入上面的的命令打开文本文件，输入 i 进入编辑状态。

然后注释掉bind-address   =127.0.0.1这一句。

编辑完成后按ESC键退出编辑，然后输入 :wq 敲回车保存退出

4、重启MySQL

重启：

```bash
$ service mysql restart
```

查看状态：

```bash
$ systemctl status mysql.service
```

5、云服务器配置安全组

到云服务器中添加安全组规则，协议选择3306，优先级100，授权对象0.0.0.0/0


## 1.x 分盘与格式化
购买了数据盘，需要先分区、格式化。

1、查看磁盘

```bash
$ fdisk -l
```

看到/dev/vdb有50GB。

2、分区
>输入fdisk /dev/vdb(对数据盘进行分区)，回车；
输入n(新建分区)，回车；
输入p(新建扩展分区)，回车；
输入1(使用第 1 个主分区)，回车；
输入回车(使用默认配置)；
再次输入回车(使用默认配置)；
输入wq(保存分区表)，回车开始分区。

3、格式化数据盘

格式化分区，ext1、ext2、ext3均可。

```bash
$ mkfs.ext3 /dev/vdb1
```


挂载分区。

```bash
$ mkdir /mydata
$ mount /dev/vdb1 /mydata
```

使用命令查看挂载。

```bash
$ df -h
```

3、设置自动挂载

见腾讯文档。

https://cloud.tencent.com/document/product/213/2936



# 2、 实用命令
## 2.1 系统状态
* uptime

查看系统运行时间

输出：

```
当前时间、已运行时间、用户登录数、1分钟、5分钟和15分钟内系统的平均负载
```

* who -a

查看系统已登录用户

输出：
哪些用户通过哪个ip登录到了这台主机

* uname -a

查看系统信息

输出：

```
Linux VM-0-11-ubuntu 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:00 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

* export

当前环境变量

* df -h

各个挂载点空间

* netstat

网络状态

* pstree

进程间关系

```
pstree
systemd─┬─ModemManager─┬─{gdbus}
        │              └─{gmain}
        ├─NetworkManager─┬─dhclient
        │                ├─dnsmasq
        │                ├─{gdbus}
        │                └─{gmain}
        ├─accounts-daemon─┬─{gdbus}
        │                 └─{gmain}
        ├─acpid
        ├─atd
        ├─avahi-daemon───avahi-daemon
        ├─bluetoothd

```

## 2.2 awk指令
awk其实不仅仅是工具软件，还是一种编程语言。

1、基本用法

```bash
$ awk 动作 文件名
```

实例：

```bash
# $0表示当前行，print打印出当前行，结果是将每一行都打印出来（自动光标移动）
$ awk '{print $0}' demo.txt
```

```bash
# 输出  this is a test
$ echo 'this is a test' | awk '{print $0}'

# 输出第3个字段——a
$ echo 'this is a test' | awk '{print $3}'
```

```bash
# 以:为分隔符，得到每一行的第1个字段
$ awk -F ':' '{ print $1 }' demo.txt
```

2、变量

变量NF表示当前行有多少个字段，因此`$NF`就代表最后一个字段。$(NF-1)代表倒数第二个字段。

```bash
# 输出最后一个字段——test
$ echo 'this is a test' | awk '{print $NF}'
```

```bash
# NR表示当前处理的第几行
$ awk -F ':' '{print NR ") " $1}' demo.txt
```
## 2.3 删除文件/文件夹

```bash
$ sudo rm -r 文件夹名
```

```bash
$ sudo rm 文件名
```

## 2.4 修改/移动文件
修改文件名：

```bash
$ rm 旧文件名 新文件名
```

移动文件：

```bash
$ rm 文件 目标文件
```
## 2.5 卸载程序
`sudo apt-get purge <程序名>`

eg，卸载firefox。

```bash
$ dpkg --get-selections |grep firefox
```

firefox

firefox-locale-en

...

```bash
$ sudo apt-get purge firefox firefox-locale-en
```

## 2.6 进程的状态

```bash
ps -auxf
```

ps：表示process status，进程状态

参数：

A ：所有的进程均显示出来，与 -e 具有同样的效用；

-a ： 显示现行终端机下的所有进程，包括其他用户的进程；

-u ：以用户为主的进程状态 ；

x ：通常与 a 这个参数一起使用，可列出较完整信息。

输出格式规划：

l ：较长、较详细的将该 PID 的的信息列出；

j ：工作的格式 (jobs format)

-f ：做一个更为完整的输出。

## 2.7 文件连锁
cat = concatenate,连锁


## 2.8 vim使用
```bash
$ vi <file>
```

首先输入上面的的命令打开文本文件，输入 i 进入编辑状态，编辑完成后按ESC键退出编辑，然后输入 :wq 敲回车保存退出

## 2.9 fuser

查看文件被谁占用。

```bash
$ fuser -u .linux.md.swp
```

## 2.10 id

查看当前用户、组 id。

## 2.11 lsof

查看打开的文件列表。

> An  open  file  may  be  a  regular  file,  a directory, a block special file, a character special file, an executing text reference, a library, a stream or a network file (Internet socket, NFS file or UNIX domain socket.)  A specific file or all the files in a file system may be selected by path.

### 查看网络相关的文件占用

```bash
$ lsof -i
```

### 查看端口占用

```bash
$ lsof -i tcp:5037
```

### 查看某个文件被谁占用

```bash
$ lsof .linux.md.swp
```

### 查看某个用户占用的文件信息

```bash
$ lsof -u mazhuang
```

`-u` 后面可以跟 uid 或 login name。

### 查看某个程序占用的文件信息

```bash
$ lsof -c Vim
```

注意程序名区分大小写。

### 读取文件的不同方式

1、cat和tac

```bash
$ cat/tac myfile
```

cat：从前往后读取该文件。

tac：从后往前读取该文件。

注：全部读取出来，然后指令自动结束。

```bash
$ cat -n myfile  #n表示输出n行
```

输出前n行

2、less

```bash
$ less myfile
```

注：读取出来后，可以一行一行翻。通过Ctrl+c退出less。

3、head/tail

```bash
$ head/tail -n 2 myfile  # 输出文件头部/末尾2行
```

## 2.12 tcpdump

**小结**

```
(1)tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
(2)-i eth1 : 只抓经过接口eth1的包
(3)-t : 不显示时间戳
(4)-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
(5)-c 100 : 只抓取100个数据包
(6)dst port ! 22 : 不抓取目标端口是22的数据包
(7)src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
(8)-w ./target.cap : 保存成cap文件，方便用ethereal(即wireshark)分析
```

**实例**

（1）监视指定网络接口的数据包

```bash
$ tcpdump -i eth1
```

如果不指定网卡，默认`tcpdump`只会监视第一个网络接口，一般是`eth0`，下面的例子都没有指定网络接口

（2）监视指定主机的数据包

```bash
# 打印所有进入或离开sundown的数据包
$ tcpdump host sundown
# 可以指定ip,例如截获所有210.27.48.1 的主机收到的和发出的所有的数据包
$ tcpdump host 210.27.48.1
# 打印helios 与 hot 或者与 ace 之间通信的数据包
$ tcpdump host helios and \( hot or ace \)
# 截获主机210.27.48.1 和主机210.27.48.2 或210.27.48.3的通信
$ tcpdump host 210.27.48.1 and \ (210.27.48.2 or 210.27.48.3 \)
# 打印ace与任何其他主机之间通信的IP 数据包, 但不包括与helios之间的数据包
$ tcpdump ip host ace and not helios
# 如果想要获取主机210.27.48.1除了和主机210.27.48.2之外所有主机通信的ip包，使用命令
$ tcpdump ip host 210.27.48.1 and ! 210.27.48.2
# 截获主机hostname发送的所有数据
$ tcpdump -i eth0 src host hostname
# 监视所有送到主机hostname的数据包
$ tcpdump -i eth0 dst host hostname
```

（3）监视指定主机和端口的数据包

```bash
# 如果想要获取主机210.27.48.1接收或发出的telnet包，使用如下命令
$ tcpdump tcp port 23 and host 210.27.48.1
# 对本机的udp 123 端口进行监视 123 为ntp的服务端口
tcpdump udp port 123 
```

## 2.13 crontab

周期性有规律地执行某项任务。

**crontab格式**

```
# 分钟  小时(*/3表示每3分钟执行一次)  日(-表示2至4日)  月(,表示或)  星期(*表示没有指定) 运行命令
50 */3 2-4 1,3 * RUN_CMD
```

注意：“分”字段必须有数值，绝对不能为空或者\*号；而“日”和“星期”字段不能同时使用，否则会发生冲突。

**创建和编辑计划任务**

```bash
# 创建和编辑计划任务
crontab -e
# 查看当前计划任务的命令
crontab -l
# 删除某条计划任务
crontab -r
```

**一个定时删除数据库历史数据的样例**

`mongo_swepper.sh`

```bash
#!/bash/bin

#删除创建时间在30天前的数据
MIN_DATE_NANO=`date -d \`date -d '30 days ago' +%Y%m%d\` +%s%N`;
MIN_DATE_MILL=`expr $MIN_DATE_NANO / 1000000`

echo "[`date '+%Y-%m-%d %H:%M:%S'`] start............................................."  >> ~/shell/mongo_swepper.log

mongo mongo_server_ip:27017<<EOF 
use admin;
db.auth("user","password");
db.dbIndicators.find({"CREATE_TIME":{\$lt:$MIN_DATE_MILL}},{"_id":1}).forEach(function(item){db.dbIndicators.remove({"_id":item._id});});
exit;
EOF

echo "[`date '+%Y-%m-%d %H:%M:%S'`] end............................................."  >> /root/cron_config/mongo_sweeper/mongo_swepper.log
```

启动crontab

```bash
crontab -e

# 添加一行
# 每天凌晨两点执行
#input>>>>>>>>>>>>>
0 2 * * * sh ~/shell/mongo_swepper.sh >> ~/shell/mongo_swepper.log
#input>>>>>>>>>>>>>
# OK
```

# 3、ubuntu目录

## 3.1 整体目录

1、/    这是根目录，一个Ubuntu系统下只有一个根目录。

2、/root  系统管理员的目录

3、/boot   系统启动文件

4、/bin  存放系统程序

5、/etc   存放系统配置方面的文件

6、/dev   存放与设备有观点文件 ，例如：USB驱动、磁盘驱动等。

7、/home   存放个人数据。每个用户的设置文件、用户桌面文件夹、用户数据都放在这里。

8、/tmp   临时目录。有些文件被用过一两次之后，就不会再用到，像这样的文件就存放在这里。

9、/usr   这个目录下存放着不适合放在/bin或/etc目录下的额外工具。/usr 目录包含了许多子目录：/usr/bin目录下用 于存放程序；/usr/share 用于存放一些共享数据

/usr/lib 用于存放那些不能直接运行的，但是许多程序所必需的一些库文件（就是库）。

10、/opt   存放一些可选的程序。如果想尝试新的东西，就存放在/opt 下，这样当你想就可以直接删除，不会影 响其他任何设置。安装在/opt 目录下的程序，它的所有数据和库文件等都放在这个目录下。

11、/media   这个目录是用来挂载那些USB接口的移动硬盘、cd/dvd驱动等。

12、/usr/local 存放那些手动安装的软件，即不是通过“新立得”或apt-get安装的软件。它和/usr目录具有相类似      的目录结构。让软件包管理器来管理/usr目录，而把自定义的脚本（scripts）放到/usr/local目录下面。

## 3.2 系统环境变量配置文件

`/etc/profile` : 在登录时,操作系统定制用户环境时使用的第一个文件 ,此文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行。 

`/etc/environment `: 在登录时操作系统使用的第二个文件, 系统在读取你自己的profile前,设置环境文件的环境变量。 

`~/.profile` :  在登录时用到的第三个文件 是.profile文件,每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的`.bashrc`文件。 

`/etc/bashrc` : 为每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取. 

`~/.bashrc` : 该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该该文件被读取。 

# 4、问题解决

## Ubuntu 16.04 python升级后terminal终端无法打开
```bash
$ sudo rm /usr/bin/python3
$ sudo ln -s python3.5 /usr/bin/python3
```

# 5、安装教程
## 5.1 ubuntu安装java8和java9
* 导入Webupd8 PPA

说明：安装java9的时候，这里的webupd8team不用改成9
```bash
$ sudo add-apt-repository ppa:webupd8team/java
```

```bash
$ sudo apt-get update
```

* 安装

说明：安装java9的话，把8改成9
```
sudo apt-get install oracle-java8-installer
```

* 设置为默认jdk
说明：安装java9的话，把8改成9
```bash
$ sudo apt install oracle-java8-set-default
```

## 5.2 ubuntu安装C++
* 安装

```bash
$ sudo apt-get install g++ build-essential
```

* gedit编写C++

* 编译

```bash
$ g++ <CPP文件名(如helloworld.cpp)> -o <输出.out文件名(如helloworld.out)>
```

* 运行

```bash
$ ./<.out文件名>
```

## 5.3 git安装
```bash
$ sudo apt install git
```

## 5.4 axel安装
axel是Linux命令行界面的多线程下载工具，比wget的好处就是可以指定多个线程同时在命令行终端里

```bash
$ sudo apt-get install axel
```

## 5.5 Ubuntu安装tomcat9
* 下载tomcat
[tomcat官方下载地址](https://tomcat.apache.org/download-90.cgi)

* tomcat的tar.gz文件移动到/opt/tomcat中

* 解压tar.gz文件

```
$ sudo tar -zvxf 文件名
```

* 全局环境

```bash
$ sudo vi /etc/profile
```

添加tomcat环境变量。如果java没有安装的话，需要安装java，添加java环境。

```bash
#Java 
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JRE_HOME}/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:$PATH

#tomcat environment
export CATALINA_HOME=/opt/tomcat/apache-tomcat-9.0.12
export CLASSPATH=.:${JRE_HOME}/lib:${JAVA_HOME}/lib:${CATALINA_HOME}/lib
export PATH=${CATALINA_HOME}/bin:$PATH
```

注：```${CATALINA_HOME}/bin:$PATH```表示不覆盖PATH，而是在原来的基础上加```${CATALINA_HOME}/bin```

* 给startup.sh文件添加环境

startup.sh用于启动tomcat。

1、打开tomcat文件夹中的startup.sh文件

```
$ sudo vi ./bin/startup.sh
```

* 添加环境

**注意**：

 1.在文件的```exec "$PRGDIR"/"$EXECUTABLE" start "$@"```**之前**添加以下内容

 2.JAVA_HOME、JRE_HOME等java的环境变量根据电脑情况填写相应地址。

ps：我这里的时用apt安装的java，java环境在```/usr/lib/jvm```中

 3.tomcat环境也要加入，具体地址根据tomcat位置确定

```bash
#Java
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export JRE_HOME=${JAVA_HOME}/jre
export PATH=${JAVA_HOME}/bin:${JRE_HOME}:$PATH
export CLASSPATH=.:${JRE_HOME}/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar

#tomcat
export TOMCAT_HOME=/opt/tomcat/apache-tomcat-9.0.12
```

* 给shutdown.sh文件添加环境
shutdown.sh用于关闭tomcat。

添加环境同startup.sh。

* 重启电脑

* 开启和关闭tomcat
1、进入tomcat安装包，即之前的/opt/tomcat/apache-tomcat-9.0.12

2、开启和关闭tomcat

```bash
$ sudo ./bin/startup.sh
$ sudo ./bin/shutdown.sh
```

* 在eclipse配置tomcat

1、右键，run as \-\> run on server

2、第一次需要添加tomcat

Apcache \-\> 选中tomcat版本。**eclipse pyoton只支持tomcat v8.0及以下**。

3、解决conf无法读取的问题 

改变tomcat安装目录下的conf文件夹权限。

```bash
$ chmod -R 777 conf
```

4、再次添加tomcat即可使用

- tomcat的server.xml

```bash
<!--name 是主机名-->
<!--appBase 是项目所在目录-->
<!-- appBase
1 这个目录下面的子目录将自动被部署为应用。 
2 这个目录下面的.war文件将被自动解压缩并部署为应用
-->
<!--
unpackWARs:是否解压appBase中的war包
-->
<!--
autoDeploy 则两次部署，
第一次因server.xml中的Context配置而被部署(因为deployOnStartup="true")
第二次因为autoDeploy="true"而发生自动部署(默认情况下，在没有显示Context的这些属性时，它们的默认值都是true)
-->
<Host name="localhost"  appBase="/home/ubuntu/"
      unpackWARs="true" autoDeploy="false" deployOnStartup="false" xmlValidation="false" xmlNamespaceAware="false">

  <!-- SingleSignOn valve, share authentication between web applications
       Documentation at: /docs/config/valve.html -->
  <!--
  <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
  -->

  <!-- Access log processes all example.
       Documentation at: /docs/config/valve.html
       Note: The pattern used is equivalent to using pattern="common" -->
  <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
         prefix="localhost_access_log" suffix=".txt"
         pattern="%h %l %u %t &quot;%r&quot; %s %b" />

  <!--用户自己的设置默认的欢迎界面-->
  <!--NettySpringWebServer 项目名-->
  <!--docBase只是指向了你某个应用的目录，这个可以和appBase没有任何关系-->
  <!--
  reloadable：Tomcat服务器在运行状态下会监视在WEB-INF/classes和WEB-INF/lib目录下class文件的改动，如果监测到有class文件被更新的，服务器会自动重新加载Web应用。
  reloadable="True"会加重服务器运行负荷
  -->
  <Context path="" docBase="/home/ubuntu/NettySpringWebServer" debug="0" reloadable="false"></Context>

</Host>

```

## 5.6 Linux下配置Eclipse+CPP+MySQL

想要在C++中调用mysql库函数，需要```#include <mysql.h>```

所以需要在eclipse中加上对mysql.h的路径

项目->属性->C/C++Build -> settings -> gcc c++ complier -> includes -> include paths 

添加两个路径：```/usr/lib/mysql```；```/usr/include/mysql```

对于64位的mysql：/usr/lib64/mysql ； /usr/include/mysql

要让eclipse工具能正确实现编译指令：

```bash
g++ -o test test.c -lmysqlclient -lm -I/usr/include/msqyl -L/usr/lib64/mysql
```

还需要添加对 -lmysqlclient -lm两个参数：

项目->属性->C/C++Build -> settings -> gcc c++ linker-> libraries 

在libraries(l) 中添加两个参数mysqlclient和m

从这里可以看出gcc l参数的作用。其中m是包含了数学方法 。


在libraryies search path (L)中添加/usr/lib/mysql

到这个地址去找libmysqlclient.a这个文件。

* 5.7 云端服务器安装Mongodb

* 下载到自己的电脑

找到mongdb对应的版本。

[mongodb的community-server](https://www.mongodb.com/download-center#community "mongodb的community-server")

eg

```bash
$ wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.0.2.tgz
```

也可以网页下载。

* scp发送到云端服务器

* 解压安装包

```bash
$ tar -xvf mongodb-linux-x86_64-ubuntu1604-4.0.2.tgz
```

* 解压包拷贝到/usr/local/mongodb

```bash
$ sudo mv mongodb-linux-x86_64-ubuntu1604-4.0.2 /usr/local/mongodb
```

* 设置环境变量
1、vi开始编辑

```bash
$ vi ~/.bashrc
```

2、insert

按下按键"i"，开始插入到文件末尾。

```bash
export PATH=/usr/local/mongodb/bin:$PATH
```

3、退出并保存

Ctrl+C：退出inster模式

输入":wq"+回车：保存并退出

4、刷新环境变量

```bash
$ source ~/.bashrc
```

* 创建MongoDB数据库目录

MongoDB的数据存储在Data目录的db目录下，但这些目录不会自动创建，需要手动创建/data/db目录，现在根目录(/)下创建data/db目录。

```bash
$ sudo mkdir -p /data/db
```

注：若用户在其他位置创建data/db目录，需要启动mongod 服务时用--dbpath=xxxx来制定数据库的存储目录。/data/db这里是默认的路径，所以不需要设置。

* 测试安装情况
Question1:

```bash
$ mongod

>>mongod: error while loading shared libraries: libcurl.so.4: cannot open shared object file: No such file or directory
```

Solve1:

```bash
$ sudo apt-get install libcurl4-openssl-dev
>>
```

Question2:

```bash
$ mongod

>>......
>>......
>>exception in initAndListen: IllegalOperation: Attempted to create a lock file on a read-only directory: /data/db, terminating
>>......
```

Solve2:

出现的原因是因为 /data/db的权限不足导致的。

```bash
$ sudo chmod 777 -R /data
```


以上问题解决，可以运行。

开两个ssh，一个打开mongod，一个测试mongo。

* 打开远程连接

**服务器端**

1、打开27017防火墙

```bash
$ sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 27017 -j ACCEPT
```

2、打开mongod并对所有ip开放

```bash
$ mongod --bind_ip 0.0.0.0
```

**客户端**

连接

```bash
$ mongo <远程IP>
```

# 5.7 安装shadowsocks-qt5
```bash
# 添加PPA源
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```

# 6、Linux shell的编写与使用

## 6.1 最简单的应用

编写run.sh，用于编译和运行java程序

```bash
#！./bin/bash
javac test.java
java test
```

运行sh，从而编译和运行java程序

```bash
$ source run.sh
```

## 6.2 给shell传递参数

例子

```bash
#!/bin/bash
# 提取第一个参数，表示从后往前读取n行catalina.out这个文件
n=$1

tail -n ${n} /opt/tomcat/apache-tomcat-8.0.53/logs/catalina.out
```

其中\$1表示提取第一个按数，而第0个参数是“当前脚本文件名”

## 6.3 shell变量

```bash
# “=”前后不能有空格
myText="hello world"
myNum=100

# $访问变量
## 输出hello world
echo $myText
## 输出myText
echo myText
```

注：变量赋值，“=”前后不能有空格

## 6.4 四则运算
```bash
#!/bin/bash
echo "Hello World !"
a=3
b=5
val=`expr $a + $b`
echo "Total value : $val"

val=`expr $a - $b`
echo "Total value : $val"

val=`expr $a * $b`
echo "Total value : $val"

val=`expr $a / $b`
echo "Total value : $val"
```

**注**：定义变量的时候“=”前后是不能有空格的，但是进行四则运算的时候运算符号前后一定要有空格，乘法的时候需要进行转义。

## 6.5 关系运算符

```bash
a=3
b=5
val=`expr $a / $b`
echo "Total value : $val"

# 取余
val=`expr $a % $b`
echo "Total value : $val"

# 判断语句
if [ $a == $b ]
then
   echo "a is equal to b"
fi
if [ $a != $b ]
then
   echo "a is not equal to b"
fi
```

|运算符	|含义|高级语言中的对应符号|
|-|-|-|
|\-eq	|两个数相等返回true|\=\=|
|-|-|-|
|\-ne	|两个数不相等返回true|\!\=|
|-|-|-|
|\-gt	|左侧数大于右侧数返回true|\>|
|-|-|-|
|\-lt	|左侧数小于右侧数返回true|\<|
|-|-|-|
|\-ge	|左侧数大于等于右侧数返回true|\>\=|
|-|-|-|
|\-le	|左侧数小于等于右侧数返回true|\<\=|

```bash
#!/bin/sh
a=10
b=20
# 相等
if [ $a -eq $b ]
then
   echo "true"
else
   echo "false"
fi

# 不相等
if [ $a -ne $b ]
then
   echo "true"
else
   echo "false"
fi

# >
if [ $a -gt $b ]
then
   echo "true"
else
   echo "false"
fi

# <
if [ $a -lt $b ]
then
   echo "true"
else
   echo "false"
fi

# >=
if [ $a -ge $b ]
then
   echo "true"
else
   echo "false"
fi

# <=
if [ $a -le $b ]
then
   echo "true"
else
   echo "false"
fi

```

## 6.6 字符串运算符

|运算符	|含义|
|-|-|
|\=	|两个字符串相等返回true|
|-|-|
|\!\=	|两个字符串不相等返回true|
|-|-|
|\-z	|字符串长度为0返回true|
|-|-|
|\-n	|字符串长度不为0返回true|

|运算符	|含义|
|-|-|
|\-d file	|检测文件是否是目录，如果是，则返回 true|
|-|-|
|\-r file	|检测文件是否可读，如果是，则返回 true|
|-|-|
|\-w file	|检测文件是否可写，如果是，则返回 true|
|-|-|
|\-x file	|检测文件是否可执行，如果是，则返回 true|
|-|-|
|\-s file	|检测文件是否为空（文件大小是否大于0，不为空返回 true|
|-|-|
|\-e file	|检测文件（包括目录）是否存在，如果是，则返回 true|

**字符串**

```bash
#!/bin/sh
mtext="hello"  #定义字符串
mtext2="world"
mtext3=$mtext" "$mtext2  #字符串的拼接
echo $mtext3  #输出字符串
echo ${#mtext3}  #输出字符串长度
echo ${mtext3:1:4}  #截取字符串
```

**字符串**

```bash
#!/bin/sh
array=(1 2 3 4 5)  #定义数组
array2=(aa bb cc dd ee)  #定义数组
value=${array[3]}  #找到某一个下标的数，然后赋值
echo $value  #打印
value2=${array2[3]}  #找到某一个下标的数，然后赋值
echo $value2  #打印
length=${#array[*]}  #获取数组长度
echo $length
```

**printf**

同C语言

## 6.7 判断语句
```bash
#!/bin/sh
a=10
b=20
if [ $a == $b ]
then
   echo "true"
fi


if [ $a == $b ]
then
   echo "true"
else
   echo "false"
fi


if [ $a == $b ]
then
   echo "a is equal to b"
elif [ $a -gt $b ]
then
   echo "a is greater than b"
elif [ $a -lt $b ]
then
   echo "a is less than b"
else
   echo "None of the condition met"
fi
```

## 6.8 test
```bash
test $[num1] -eq $[num2]  #判断两个变量是否相等
test num1=num2  #判断两个数字是否相等
```

|参数	|含义|
|-|-|
|\-e file	|文件存在则返回真|
|-|-|
|\-r file	|文件存在并且可读则返回真|
|-|-|
|\-w file	|文件存在并且可写则返回真|
|-|-|
|\-x file	|文件存在并且可执行则返回真|
|-|-|
|\-s file	|文件存在并且内容不为空则返回真|
|-|-|
|\-d file	|文件目录存在则返回真|

## 6.9 for循环

```bash
#!/bin/sh

# 1,2,3,4,5
for i in {1..5}
do
    echo $i
done

# 6,7,8,9
for i in 6 7 8 9
do
    echo $i
done

# 查找文件以.bash开头
for FILE in $HOME/.bash*
do
   echo $FILE
done
```

## 6.10 while循环
```bash
#!/bin/sh

# 执行循环，然后每次都把控制的数加1
COUNTER=0
while [ $COUNTER -lt 5 ]
do
    COUNTER=`expr $COUNTER + 1`
    echo $COUNTER
done

# 用户从键盘数据，然后把用户输入的文字输出出来。
echo '请输入。。。'
echo 'ctrl + d 即可停止该程序'
while read FILM
do
    echo "Yeah! great film the $FILM"
done
```

## 6.11 跳出循环
```bash
break  #跳出所有循环
break n  #跳出第n层f循环
continue  #跳出当前循环
```

## 6.12 函数创建

```bash
#!/bin/sh

test(){

    aNum=3
    anotherNum=5
    return $(($aNum+$anotherNum))
}
test
result=$?
echo $result
```

输出：

```
8
```

```bash
#!/bin/sh

test(){
    echo $1  #接收第一个参数
    echo $2  #接收第二个参数
    echo $3  #接收第三个参数
    echo $#  #接收到参数的个数
    echo $*  #接收到的所有参数
}

test aa bb cc
```

输出：

```
aa
bb
cc
3
aa bb cc
```

## 6.13 重定向

```bash
$echo result > file  #将结果写入文件，结果不会在控制台展示，而是在文件中，覆盖写
$echo result >> file  #将结果写入文件，结果不会在控制台展示，而是在文件中，追加写
echo input < file  #获取输入流
```

## 6.14 github自动push脚本

```bash
#!/bin/bash
echo "-------Begin-------"
git add .
git commit -m $1
echo $1
git push origin master
echo "--------End--------"
```

## 6.15 shell指令

### 6.15.1 sed

可以对来自文本文件以及标准输入的文本进行编辑，标准输入可以是键盘、文件重定向、字符串、变量或者管道的文本。

* **运行流程**：

1、从文件或者标准输入读取一行数据，复制到缓存区

2、读取命令行或者脚本的编辑子命令，对缓冲区的文本进行编辑

3、重复以上过程

* **格式**

```
sed [options] [script] [inputfile ...]
```

* **实例**

```shell
# 输出第1行，-n表示取消默认输出，1p即第一行
sed -n 1p text.txt
```



### 6.15.2 awk

## 6.16 sh小应用

**1.ssh免密登录**

```bash
#!/usr/bin/expect
spawn ssh username@your_server_ip
expect {
    "yes/no" { send "yes\n";exp_continue }      # 替你回答下载公钥是的提示
    "password" { send "your_password\n" }         # 提示输入密码
}
interact
expect eof 
```

# 7、make编译

## 7.1 make编译基础

### 7.1.1 编译规则

（1）如果工程没有编译过，则所有C文件都要编译并链接

（2）如果工程几个C文件被修改，则只编译被修改的C文件，并链接目标程序

（3）如果工程头文件改变，则需要编译引用几个头文件的C文件，并链接目标程序。

### 7.1.2 Makefile规则格式

```
# 目标和条件之间的关系：与更新目标，必须首先更新他的所有条件
# 所有条件中只要有一个更新，目标也必须随之更新
目标 ... ： 条件集合 ...
	# 命令列表必须以TAB开头，不能使用空格
	命令1
	命令2
	...
```

eg.

```bash
main:main.o getdata.o calc.o putdata.o
	gcc -o main main.o getdata.o calc.o putdata.o
main.o:main.c getdata.h calc.h putdata.h define.h
	gcc -c main.c
getdata.o:getdata.c getdata.h define.h
	gcc -c getdata.c
calc.o:calc.c calc.h
	gcc -c calc.c
putdata.o:putdata.c putdata.h
	gcc -c putdata.c
clean:
	rm *.o
	rm main
```

### 7.1.3 make如何工作

默认输入`make`

（1）make在当前目录查找名为Makefile或者makefile的文件；

（2）如果找到，则会进一步找到文件中的第一个目标文件，如上面的makefile文件中指明的**`main`文件**，并把该文件作为最终的目标文件；

（3）如果main文件不存在，或者main文件依赖的条件集合，即后面的.o文件修改时间比main文件晚（即生成main文件后，.o文件又进行了修改），则会执行后面所定义的命令来生成main文件；

（4）如果main所依赖的.o文件也存在，则make会在当前文件中查找目标为.o文件的依赖性（依赖于.c和.h文件），如果找到，则再根据规则生成.o文件

（5）如果.c和.h文件存在，make会生成.o文件，然后用.o文件生成make最终的终极任务，即执行文件main

`clean`这种没有被第一个目标，直接或者间接关联，那么它后面所定义的命令不会被自动执行。通过`make clean`，可以来执行——清除目标文件`*.o`和`main`（即所有目标文件）

**说明**：如果main.c修改，根据程序依赖性，目标main.o会被重新编译（`gcc -c main.c`），于是main.o也修改，则main.o文件修改时间晚于main，进而main也重新链接（`gcc -o main main.o getdata.o calc.o putdata.o`）。

### 7.1.4 Makefile中使用变量

```bash
objects=main.o getdata.o calc.o putdata.o
main:$(objects)
	gcc -o main $(objects)
```

### 7.1.5 make自动推导

GNU的make可以做到自动推导文件以及文件依赖关系后面的命令，于是就没有必要在每个.o文件后面写上类似的命令

```bash
# 只需要写目标和条件（依赖关系）即可
objects=main.o getdata.o calc.o putdata.o
main:$(objects)
main.o:main.c getdata.h calc.h putdata.h define.h
getdata.o:getdata.c getdata.h define.h
calc.o:calc.c calc.h
putdata.o:putdata.c putdata.h
clean:
	rm *.o
	rm main
```

### 7.1.6 清空目标文件

一般放在makefile最后，不要放在文件开头，不然会被当作默认目标。`.PHONY`只是在显式请求时执行命令的名字，有两种理由需要使用`PHONY` 目标：避免和同名文件冲突，改善性能。

```bash
# .PHONY表示clean是一个“伪目标”
.PHONY:clean
clean:
	# -表示不要管某些文件出现的问题，继续执行
	-rm *.o
	-rm main
```

## 7.2 make概述

### 7.2.1 命名

大多数make都支持`makefile`和`Makefile`这两种默认命名方式 。指定`makefile`文件

```bash
make -f {MAKEFILE_NAME}
```

### 7.2.2 包含其他makfile文件

include指示符告诉make暂停读取当前的Makefile，转而读取include指定的一个或者多个文件，完成所有这些文件以后再继续读取当前Makefile。

```bash
# 不能以TAB开始，不然会被当作一个命令
include {MAKEFILE_NAME}
```

**include的场合**

1、有很多个不同的程序，由不同目录下的几个独立的Makefile来描述其创建或者更新规则。

2、当根据源文件自动产生依赖文件时，可以将自动产生的依赖关系保存在另外一个文件中，主Makefile使用指示符include包含这些文件。

**include查找顺序**

1、如果没有指明绝对路径，而且当前目录下也不存在指定文件，make将根据文件名试图在以下几个目录中寻找；

2、查找使用命令行选项`"-I"`或者`"--include-dir"`指定的目录，如果找到指定的文件，则使用；否则进行第3步；

3、依次搜索`/usr/gnu/include`、`/usr/local/include`和`/usr/include`，如果搜索不到，则进行第4步；

4、make提示文件未找到，继续处理Makefile内容；

5、Makefile文件全部读取后，make试图使用规则来创建通过include指定但是未找到的文件，不能创建时，make提示致命错误并退出。

**-include**

`-include`包含的文件不存在，或者不存在一个规则创建，make程序仍然正常执行。只有因为Makefile的目标的规则不存在时，才会提示致命错误并退出。

### 7.2.3 变量MAKEFILES

如果当前环境定义了一个**MAKEFILES的环境变量**，make执行时就会首先将此变量的值作为需要读入的Makefile文件，并且多个文件之间使用空格分开。

变量MAKEFILES主要用在make的递归调用过程中的通信。实际应用中很少设置该**环境变量**，一旦设置了此变量，在多层make调用时，由于每一级make都会读取MAKEFILES环境变量指定的文件，这样可能导致执行的混乱。

### 7.2.4 变量MAKEFILE_LIST

make读取多个Makefile文件时，在对文件解析执行之前，make读取的文件名将会被自动追加到变量MAKEFILE_LIST的定义域中。

可以通过测试MAKEFILE_LIST变量中的最后一个字，来得到make程序正在处理哪个Makefile文件。

```makefile
name1:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
include inc.mk
name2:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
all:
	@echo name1 = $(name1)
	@echo name2 = $(name2)
```

输出

```
name1 = Makefile
name2 = inc.mk
```

### 7.2.5 其他特殊变量

GNU make支持一个特殊的变量，且不能通过任何途经给它赋值。此变量展开以后是一个特定的值。第一个重要的特殊变量是".VARIABLES"。表示此引用点之前Makefile文件中所定义的所有全局变量列表，包括空变量（未赋值的变量）和make的内嵌变量，但不包含目标制定的变量，目标指定变量值在特定目标的上下文有效。

### 7.2.6 Makefile文件的重建

Makefile可由其他文件生成，如果Makefile由其他文件重建，则在make开始解析Makefile时，需要读取的是更新后的Makefile，而不是那个没有更新的Makefile。具体的make处理过程：

1、make读入所有Makefile文件；

2、将所有读取的每个Makefile作为一个目标，试图更新。如果存在一个更新特定Makefile文件的明确规则或者隐含规则，则去更新这个Makefile文件；

3、完成所有Makefile文件的更新检查动作后，如果之前所读取的Makefile文件已经被更新，则make就清除本次执行状态，重新读取一遍Makefile文件

### 7.2.7 重载另外一个Makefile

问题：Makefile-A通过include包含Makefile-B，且两个文件包含同一个目标，则其描述规则汇总使用了不同的命令，这是Makefile不允许的。则使用include指示符行不通，GNU make提供了另外一种途径：

在需要包含的Makefile-A中，使用一个“**所有匹配模式**”的规则来描述在Makefile-A中没有明确定义的目标，make将会在给定的Makefile文件中寻找没有在当前Makefile文件中给出的目标更新规则。

```makefile
# sample GNUmakefile
foo:
	frobnicate > foo
%:force
	@$(MAKE) -f Makefile $@
force:;
```

*待重新学习*

### 7.2.8 make解析Makefile文件

第一阶段：读取所有Makefile文件（包括MAKEFILES指定的、指示符include指定的以及命令行选项`-f (--file)指定的`）内建所有变量、明确规则和隐含规则，并建立所有目标和依赖之间的关系结构链表；

第二阶段：根据第一阶段的依赖关系结构链表决定哪些目标需要更新，并使用对应的规则来重建这些目标。

### 7.2.9 make执行过程总结

1、一次读取变量MAKEFILES定义的Makefile文件；

2、读取工作目录下的Makefile文件（根据命名的查找顺序GNUmakefile、makefile、Makefile，首先找到那个就读取哪个）；

3、依次读取工作目录Makefile文件中使用指示符include包含的文件；

4、查找重建所有已读取的Makefile文件的规则（如果存在一个目标是当前读取的某一个Makefile文件，则执行此规则重建此Makefile文件，完成后从第一步开始执行）；

5、初始化变量值，展开需要立即展开的变量和函数，并根据预设条件确定执行分支；

6、根据“终极目标”以及其他目标的依赖关系建立依赖关系链表；

7、执行除“终极目标”以外的所有目标规则（规则中如果依赖文件中任何一个文件的时间戳比目标文件新，则使用规则所定义的命令重建目标文件）

8、执行“终极目标”所在的规则。

## 7.3 Makefile基本规则

Maefile规则描述了何种情况下使用什么指令来重建一个特定的文件，此文件被称为规则“**目标**”。规则罗列的其他文件称为“目标”的**依赖**，而规则的**命令**是用来更新或者创建此规则的目标。

### 7.3.1 规则举例

```makefile
foo.o:foo.c defs.h
	cc -c -g foo.c
```

`foo.o`：规则目标

`foo.c defs.h`：目标的依赖

`cc -c -g foo.c`：命令，描述如何使用规则中的依赖文件重建目标。

*关于cc的注释*：

cc（C Compiler）是Unix中的C语言编译器，gcc（GNU C Compiler）来自Linux。在Linux中cc会被定向到gcc。

*问题*

（1）如何确定目标文件是否过期。

目标文件不存在或者目标文件`foo.o`在时间戳上比依赖文件中任何一个“老”。

（2）如何重建目标文件`foo.o`

在上面的规则中，使用`cc`编译器，在命令中没有明确地使用到依赖文件`defs.h`，而是假设在源文件`foo.c`中已经包含了此头文件。**依赖文件包含某头文件，也需要加入到依赖文件列表中**

### 7.3.2 规则语法

```makefile
TARGETS:PREREQUISITES
COMMAND
...
```

或者

```makefile
TARGETS:PREREQUISITES;COMMAND
	COMMAND
	...
```

`TARGETS`可以是**空格**分开的多个文件名，也可以是一个标签（执行清空的clean）。格式A(M)表示档案文件A的成员M。

**书写规则**：

* 规则命令的两种写法：

1.命令`COMMAND`可以和目标`TARGETS`、依赖描述`PREREQUISITES`放在同一行，依赖描述和命令用"`;`"隔开

2.命令`COMMAND`在目标、依赖文件下一行，必须以TAB字符开始。

* `$`表示变量或者函数引用，其他时候使用需要`$$`来表示字符`$`
* `\`可以用于分割一个较长的行

### 7.3.3 依赖的类型

**常规依赖**（前面提到的依赖）和**order-only依赖**

```makefile
# 用|隔开常规依赖和order-only依赖
TARGETS:NORMAL-PREREQUISITES|ORDER_ONLY-PREREQUISITES
```

* 常规依赖

1.规则`A:B C`在重建A之前，需要先对B和C进行重建（执行Makefile中B和C所在的规则）

2.确定依赖关系：如果任意依赖文件比目标文件新，则认为规则的目标已经过期，需要重建

* order-only依赖

此类依赖更新不会导致目标被重建，只有目标不存在才会参与重建

```makefile
LIBS=libtest.a
# libtest.a被修改时，将不重建foo
# 只有foo不存在时，libtest.a才会参与规则执行
foo:foo.c|$(LIBS)
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)
```

### 7.3.4 文件名使用通配符

* 单一文件名中使用`*`、`?`和`[...]`

Makefile中表示一个单一文件名时可以使用通配符，如`*`、`?`和`[...]`。文件名中出现时，需要"`\`"来转义。

**可出现的场合**：

1.规则目标和依赖中，make会自动将其展开

2.规则命令中，在shell执行此命令时展开

* 路径中使用`~`

表示用户宿主目录：`/home/username/`

`~/bin`表示`/home/username/bin`

`~jack/bin`表示指定用户jack，`/home/jack/bin`

**通配符使用实例**

```makefile
# 清理过程文件
clean:
	rm -f *.o
```

```makefile
# 打印当前工作目录下所有的在上一次打印以后被修改过.c文件
# print是一个空目标文件（只记录了一个要执行的动作或者命令）
print:*.c
	# $?表示依赖文件列表中被修改过的所有文件
	lpr -p $?
	touch print
```

**wildcard函数**

`object=*.o`产生的效果是`object`变量数值就是`*.o`，`wildcard`函数可以实现变量代表文件列表，通配符自动展开。

```makefile
# wildcard函数获取工作目录下的.c文件列表，然后将列表中所有文件名的后缀.c替换为.o
# 即得到在当前目录下生成的.o文件列表
# 使用特殊的符号赋值:=，隐含规则编译.c文件
objects:=$(patsubst %.c %.o,$(wildcard *.c))
# 将工作目录下所有.c文件编译，最后链接成一个可执行文件
foo:$(objects)
	cc -o foo $(objects)
```

*`:=`和`=`的区别*

```makefile
x=foo
y=$(x) bar
x=f
```

最后y等于`f bar`，由最后的值决定

```makefile
x:=foo
y=$(x) bar
x=xyz
```

最后y等于`foo bar`，由当时右侧赋值时候的值决定。

### 7.3.5 目录搜索

**1.一般搜索（变量VPATH）**

make可以识别特殊变量`VPATH`，通过变量`VPATH`可以指定依赖文件的搜索路径。规则依赖文件在当前目录不存在时，make会在`VPATH`目录下寻找依赖文件。

```makefile
# 使用:分隔多个目录
# 按照先后顺序遍历
VPATH=src:../headers
```

**2.选择性搜索（关键字vpath）**

* `vpth PATTERN DIRECTORIES`

如果当前目录下没有找到文件，就到vpath中查找。为符合模式`PATTERN`的文件指定搜索目录`DIRECTORIES`。多个目录用空格或者"`:`"隔开。

```makefile
vpath %.h ../headers
```

如果多个`vpth`使用了相同的`PATTERN `，make则对这些`vpath`语句一个一个进行处理，顺序由`vpath`语句在Makefile文件中出现的次序决定。

* `vpth PATTERN`

清除之前为符合模式`PATTERN`的文件设置的搜索路径

* `vpth`

清除所有已被设置的文件搜索路径

**3.目标搜索的机制**

make在解析Makefile文件执行规则时，对文件路径保存或废弃所依据的算法：

（1）如果规则的目标文件在Makefile文件所在目录（工作目录）下不存在，那么就执行目录搜寻（可由VPATH、vpath指定）

（2）如果目录搜寻成功，并且在指定的目录下存在此规则的目标，那么搜索到的完整的路径名就被作为临时的目标文件被保存

（3）对于规则中的依赖文件，使用相同的方法处理

（4）规则的目标可能需要重建，可能不需要

4.1）规则的目标不需要重建，通过目录搜索得到的所有完整的**依赖文件和目标文件**的路径名有效。**已经存在的目标文件所在的目录不会被改变**

4.2）规则的目标需要重建，则通过目录搜索得到的**目标文件**的路径名无效，规则中的目标文件将会在**工作目录下**被重建。

**4.命令行和搜索目录**

依赖文件在其他目录（此时依赖文件为文件的完整路径名），但是已经存在的规则命令不能发生改变。书写命令时必须保证当依赖文件在其他目录下被发现了时，规则的命令能够正确执行。解决方法（自动化变量）：

```makefile
foo.o:foo.c
	# CFLAGS是编译.c文件时GCC命令行选项，可以在Makefile中给出制定明确的值，也可以使用隐含的定义值
	# $^代表所有同构目录搜索到的依赖文件的完整路径名（目录+一般文件名）列表
	# $@代表规则的目标foo.o
	cc -c $(CFLAGS) $^ -o $@
```

```makefile
VPATH=src:../headers
foo.o:foo.c defs.h hack.h
	# $^可以用$<代替，代表依赖文件列表的第一个依赖文件，因为.h在命令中不需要
	cc -c $(CFLAGS) $^ -o $@
```

**5.库文件和搜索目录**

Makefile中程序链接的静态库、共享库同样也可以由目录搜索得到，需要用户在书写规则的依赖时指定一个类似`-lNAME`的依赖文件名（`-lNAME`的表示方式和`GNU ld`链接器对库的引用方式完全一样）。

规则的依赖文件存在`-lNAME`形式的文件时，make将根据NAME首先搜索当前系统可提供的共享库。如果当前系统不能提供这个共享库，则搜索它的静态库。详细过程：

```
1.make在执行规则时会在当前目录下搜索一个名为libNAME.so的文件
2.如果当前工作目录下不存在libNAME.so，则make程序会继续搜索使用VPATH或者vpath指定的搜索目录
3.如果还不存在，make程序将搜索系统默认的目录，顺序是/lib、/usr/lib、和PREFIX/lib（Linux中是/usr/local/lib）
如果还没有找到libNAME.so，则按以上顺序搜索libNAME.a文件
```

例子：

```makefile
# 假设/usr/lib/libcurses.a存在，而不存在/usr/lib/libcurses.so
# -lNAME格式默认搜索libNAME.so和libNAME.a是由变量.LIBPATTERNS指定
foo:foo.c -lcurses
	cc $^ -o $@
```

### 7.3.6 Makefile伪目标

将一个目标声明为伪目标需要将其作为特殊目标"`.PHONY`"的依赖。

* **伪目标的2点作用**：

*1、避免只执行命令的目标和工作目录下的文件名出现冲突*

如果工作目录下没有clean文件，则`make clean`总是执行。（**问题**）如果工作目录下有clean文件，则`make clean`认为clean目标存在且没有依赖，而不会执行命令。

```makefile
clean:
	rm *.o temp
```

修改为

```makefile
# 伪目标，不管工作目录下是否有clean文件，make clean都会执行清除
.PHONY:clean
clean:
	rm *.o temp
```

*2、提高make的执行效率*

```makefile
SUBDIRS=foo bar baz
# 利用Shell循环来完成对多个目录进行make
subdirs:
for dir in $(SUBDIRS);do \
		$(MAKE) -C $$dir; \
	done
```

**问题**：1、子目录执行make错误时，make不会退出，需要加`-k`选项；2、Shell循环方式，没有用到make对目录的并行处理功能。克服以上2个问题，修改为：

```makefile
SUBDIRS=foo bar baz

.PHONY:subdirs $(SUBDIRS)

subdirs:$(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@
# 限制子目录make顺序：baz完成后才能foo
foo:baz
```

* **伪目标依赖**

伪目标运行前，需要执行其依赖。例子：

```makefile
# 伪目标依赖目标
all:prog1 prog2 prog3
.PHONY:all
prog1:prog1.o utils.o
	cc -o prog1 prog1.o utils.o
prog2:prog2.o
	cc -o prog2 prog2.o
prog3:prog3.o sort.o utils.o
	cc -o prog3 prog3.o	sort.o utils.o
```

```makefile
# 伪目标依赖伪目标
.PHONY:cleanall cleanobj cleandiff
cleanall:cleanobj cleandiff
	rm program
cleanobj:
	rm *.o
cleandiff:
	rm *.diff
```

注：`RM`变量等价于"`rm -f`"，可以用`$(RM)`

### 7.3.7 强制目标

FORCE总是被认为更新过，所以clean总是会执行，功能同于`.PHONY`

```makefile
clean:FORCE
	rm $(objects)
FORCE:
```

**推荐使用伪目标`.PHONY`**

### 7.3.8 空目标文件

空目标是伪目标的变种，**不同点在于空目标是一个存在的文件（记录上一次执行此规则定义命令的时间）**

```makefile
print:foo.c bar.c
	lpr -p $?
	touch print
```

### 7.3.9 Makefile符号

* **shell前的`@`、`-`、`+`**

1.makefile执行到某一行，都会打印改行命令，为了不打印命令，需要添加`@`

```makefile
clean_all:
	rm *.o
	# 输出
	# echo ">>>>>>>>  DONE  <<<<<<<"
	# >>>>>>>>  DONE  <<<<<<<
	echo ">>>>>>>>  DONE  <<<<<<<"
	
	# 输出
	# >>>>>>>>  DONE  <<<<<<<
	@echo ">>>>>>>>  DONE  <<<<<<<"
```

2.忽略错误需要添加`-`

3.只有某一些行被执行，其他行均为显示命令

命令行前的`+`表示改行执行，其它没有`+`的行是显示命令而不执行

* 等于号

`=`：最基本的赋值

`:=`：覆盖变量之前的值（`=`和`:=`的区别见**`:=`和`=`的区别**）

`?=`：变量为空，则赋值

`+=`：赋值添加到变量的后面

* obj-xxx

`obj-y`：编译进内核

`obj-m`：编译成模块

`obj-$(CONFIG_PPC) `中 ​`$(CONFIG_PPC)`表示一个变量

```
比如定义CONFIG_PPC=y

$(CONFIG_PPC)就是y

obj-$(CONFIG_PPC) 就是 obj-y
```

```makefile
# 目录下有一个名为foo.o的目标文件。foo.o将从foo.c或foo.S文件编译得到。
obj-y += foo.o
```

```makefile
# 如果foo.o要编译成一模块，那就要用obj-m了
# $(CONFIG_FOO)可以为y(编译进内核) 或m(编译成模块)
obj-$(CONFIG_FOO) += foo.o
```

* `$(eval ($call  xxx) )`

```$(eval $(call xxx))```: 调用函数xxx, 其中的值作用到本mk文件

### 7.3.10 多目标

一个规则中可以有个多个目标，相当于多个规则。

（1）仅需要一个描述依赖关系的规则，而不需要在规则中定义命令

```makefile
kbd.o command.o files.o:command.h
```

（2）对于多个具有类似重建命令的目标，重建这些目标的命令并不需要绝对相同

```makefile
bigoutput little output:text.g
	# generate 根据命令行参数来决定输出文件的类型
	generate text.g -$(subst output,,$@) > $@
```

### 7.3.11 多规则目标

一个文件可以作为多个规则的目标出现，目标文件的所有依赖将会被合并成此目标一个依赖文件列表。

* 一个仅描述依赖关系的描述规则可以用来给一个或者多个目标文件的依赖文件。

```makefile
objects=foo.o bar.o
foo.p:defs.h
bar.o:defs.h test.h
$(objects):config.h
```

* 可以通过一个变量来增加目标的依赖文件

```makefile
extradeps=
$(objects):$(extradeps)
```

如果`make extradeps=foo.h`，则foo.h将作为所有的（objects中的）.o文件的依赖文件。

### 7.3.12 静态模式

静态模式规则存在多个目标，并且不同的目标可以根据目标文件的名字来自动构造出依赖文件，

```makefile
# TARGET-PATTERN和PREREQ-PATTERNS说明了如何为每一个目标文件生成依赖文件
TARGETS ...:TARGET-PATTERN:PREREQ-PATTERNS ...
	COMMANDS
...
```

从目标模式`TARGET-PATTERN`的目标名字中抽取一部分字符串（称为“茎”），替代依赖模式`PREREQ-PATTERNS`中相应部分来产生对应目标的依赖文件。

例子：根据相应的.c文件来编译生成foo.o和bar.o文件

```makefile
objects = foo.o bar.o
all: $(objects)
# 规则描述了所有.o文件的依赖文件是对应的.c文件
# 对于目标foo.o，取其茎foo代替对应的依赖模式%.c中的模式字符%
# 可以得到目标的依赖文件foo.c
$(objects): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
```

### 7.3.13 双冒号规则

双冒号规则使用`::`代替普通的`:`得到的规则。双冒号规则允许在多个规则中为同一个目标指定不同的重建目标的命令。

（1）双冒号规则中，依赖文件比目标更新时，规则会被执行。对于一个没有依赖的命令，双冒号规则会无条件执行。而单冒号的无依赖规则，只要文件夹中有规则的目标文件存在，则认为目标条件最新，会不执行。

（2）当同一个文件作为多个双冒号规则的目标时，不同的规则会被独立处理，而不是像普通规则（单冒号）那样合并所有依赖到一个目标文件。意味着多个双冒号规则中的每个依赖文件被修改后，make只执行规则定义的命令，而其他的以这个文件作为目标的双冒号规则不执行。

```makefile
# 如果foo.c文件被修改，执行make后将根据foo.c重建Newprog。
# 如果bar.c被修改，则Newprog将根据bar.c重建
# 但是对于单冒号规则，就以上情况会报错
Newprog :: foo.c
	$(cc) $(CFLAGS) $< -o $@
Newprog :: bar.c
	$(cc) $(CFLAGS) $< -o $@	
```

