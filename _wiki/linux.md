---
layout: wiki
title: Linux/Unix
categories: Linux
description: 类 Unix 系统下的一些常用命令和用法。
keywords: Linux
---

类 Unix 系统下的一些常用命令和用法。

# 1、远程控制相关
## 1.1 登录远程服务器
1、登录远程服务器

```
$ ssh <username>@<hostname or ip_address> -p <port>
```

我的IP是：115.159.154.***,域名是neyzoter.cn,(-p port 可以省略，表示端口)

2、退出远程服务器

Ctrl+D

## 1.2 scp上传/下载文件
```
scp 本地文件地址+文件名  远程用户名@IP地址:+服务器内存放文件的地址。（这里用户名用root）
```

例如：scp /home/wj/桌面/aa.txt root@111.231.1.101:/home/aa.txt

```
scp -r 远程用户名@IP地址:+服务器内存放文件的地址 本地文件地址
```

## 1.2 发送udp包

```
$ echo "hello" |socat - udp4-datagram:115.159.154.xxx:8080
```

## 1.3 关掉某个端口的进程

```
$ netstat -tlnp   # 查看正在监听的端口
$ sudo lsof -i:端口号    # 查看某个端口号 的PID
$ sudo kill -9 端口的PID    # 根据端口的PID来关闭端口监听
```

## 1.x 安装java
1、查看有java包

```
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

```
sudo apt-get install openjdk-8-jre-headless
```

3、查看java版本

```
$ java -version
```

## 1.x 安装mysql-server
1、apt安装
```
$ sudo apt-get install mysql-server
```

不需要安装mysql-client。

2、登录MySQL并更改用户授权

```
$ mysql -u root -p
```

输入密码。

```
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

```
vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

首先输入上面的的命令打开文本文件，输入 i 进入编辑状态。

然后注释掉bind-address   =127.0.0.1这一句。

编辑完成后按ESC键退出编辑，然后输入 :wq 敲回车保存退出

4、重启MySQL

重启：

```
$ service mysql restart
```

查看状态：

```
$ systemctl status mysql.service
```

5、云服务器配置安全组

到云服务器中添加安全组规则，协议选择3306，优先级100，授权对象0.0.0.0/0


## 1.x 分盘与格式化
购买了数据盘，需要先分区、格式化。

1、查看磁盘

```
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

```
$ mkfs.ext3 /dev/vdb1
```


挂载分区。

```
$ mkdir /mydata
$ mount /dev/vdb1 /mydata
```

使用命令查看挂载。

```
$ df -h
```

3、设置自动挂载

见腾讯文档。

https://cloud.tencent.com/document/product/213/2936



# 2、 实用命令
## 系统状态
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


## 删除文件/文件夹

```
$ sudo rm -r 文件夹名
```

```
$ sudo rm 文件名
```

## 修改/移动文件
修改文件名：

```
$ rm 旧文件名 新文件名
```

移动文件：

```
$ rm 文件 目标文件
```
## 卸载程序
sudo apt-get purge <程序名>

eg，卸载firefox。

```
$ dpkg --get-selections |grep firefox
```

firefox

firefox-locale-en

...

```
$ sudo apt-get purge firefox firefox-locale-en
```

## 进程的状态

```
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

## 文件连锁
cat = concatenate,连锁


## vim使用
```
vm <file>
```

首先输入上面的的命令打开文本文件，输入 i 进入编辑状态，编辑完成后按ESC键退出编辑，然后输入 :wq 敲回车保存退出

## fuser

查看文件被谁占用。

```sh
fuser -u .linux.md.swp
```

## id

查看当前用户、组 id。

## lsof

查看打开的文件列表。

> An  open  file  may  be  a  regular  file,  a directory, a block special file, a character special file, an executing text reference, a library, a stream or a network file (Internet socket, NFS file or UNIX domain socket.)  A specific file or all the files in a file system may be selected by path.

### 查看网络相关的文件占用

```sh
lsof -i
```

### 查看端口占用

```sh
lsof -i tcp:5037
```

### 查看某个文件被谁占用

```sh
lsof .linux.md.swp
```

### 查看某个用户占用的文件信息

```sh
lsof -u mazhuang
```

`-u` 后面可以跟 uid 或 login name。

### 查看某个程序占用的文件信息

```sh
lsof -c Vim
```

注意程序名区分大小写。

### 读取文件的不同方式

1、cat和tac

```
cat/tac myfile
```

cat：从前往后读取该文件。

tac：从后往前读取该文件。

注：全部读取出来，然后指令自动结束。

```
cat -n myfile  #n表示输出n行
```

输出前n行

2、less

```
less myfile
```

注：读取出来后，可以一行一行翻。通过Ctrl+c退出less。

3、head/tail

```
head/tail -n 2 myfile  # 输出文件头部/末尾2行
```


# 3、ubuntu目录
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

# 4、问题解决
## Ubuntu 16.04 python升级后terminal终端无法打开
```
$ sudo rm /usr/bin/python3
$ sudo ln -s python3.5 /usr/bin/python3
```

# 5、安装教程
## 5.1 ubuntu安装java8和java9
* 导入Webupd8 PPA

说明：安装java9的时候，这里的webupd8team不用改成9
```
sudo add-apt-repository ppa:webupd8team/java
```

```
sudo apt-get update
```

* 安装

说明：安装java9的话，把8改成9
```
sudo apt-get install oracle-java8-installer
```

* 设置为默认jdk
说明：安装java9的话，把8改成9
```
sudo apt install oracle-java8-set-default
```

## 5.2 ubuntu安装C++
* 安装

```
$ sudo apt-get install g++ build-essential
```

* gedit编写C++

* 编译

```
$ g++ <CPP文件名(如helloworld.cpp)> -o <输出.out文件名(如helloworld.out)>
```

* 运行

```
$ ./<.out文件名>
```

## 5.3 git安装
```
$ sudo apt install git
```

## 5.4 axel安装
axel是Linux命令行界面的多线程下载工具，比wget的好处就是可以指定多个线程同时在命令行终端里

```
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

```
$ sudo vi /etc/profile
```

添加tomcat环境变量。如果java没有安装的话，需要安装java，添加java环境。

```
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

 1.在文件的```exec "$PRGDIR"/"$EXECUTABLE" start "$@"```**之前**添加一下内容

 2.JAVA_HOME、JRE_HOME等java的环境变量根据电脑情况填写相应地址。

ps：我这里的时用apt安装的java，java环境在```/usr/lib/jvm```中

 3.tomcat环境也要加入，具体地址根据tomcat位置确定

```
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

```
$ sudo ./bin/startup.sh
$ sudo ./bin/shutdown.sh
```

* 在eclipse配置tomcat

1、右键，run as \-\> run on server

2、第一次需要添加tomcat

Apcache \-\> 选中tomcat版本。**eclipse pyoton只支持tomcat v8.0及以下**。

3、解决conf无法读取的问题

改变tomcat安装目录下的conf文件夹权限。

```
$ chmod -R 777 conf
```

4、再次添加tomcat即可使用
## 5.6 Linux下配置Eclipse+CPP+MySQL

想要在C++中调用mysql库函数，需要```#include <mysql.h>```

所以需要在eclipse中加上对mysql.h的路径

项目->属性->C/C++Build -> settings -> gcc c++ complier -> includes -> include paths 

添加两个路径：```/usr/lib/mysql```；```/usr/include/mysql```

对于64位的mysql：/usr/lib64/mysql ； /usr/include/mysql

要让eclipse工具能正确实现编译指令：

```
g++ -o test test.c -lmysqlclient -lm -I/usr/include/msqyl -L/usr/lib64/mysql
```

还需要添加对 -lmysqlclient -lm两个参数：

项目->属性->C/C++Build -> settings -> gcc c++ linker-> libraries 

在libraries(l) 中添加两个参数mysqlclient和m

从这里可以看出gcc l参数的作用。其中m是包含了数学方法 。


在libraryies search path (L)中添加/usr/lib/mysql

到这个地址去找libmysqlclient.a这个文件。

## 5.7 云端服务器安装Mongodb

* 下载到自己的电脑

找到mongdb对应的版本。

[mongodb的community-server](https://www.mongodb.com/download-center#community "mongodb的community-server")

eg

```
$ wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.0.2.tgz
```

也可以网页下载。

* scp发送到云端服务器

* 解压安装包

```
$ tar -xvf mongodb-linux-x86_64-ubuntu1604-4.0.2.tgz
```

* 解压包拷贝到/usr/local/mongodb

```
$ sudo mv mongodb-linux-x86_64-ubuntu1604-4.0.2 /usr/local/mongodb
```

* 设置环境变量
1、vi开始编辑

```
$ vi ~/.bashrc
```

2、insert

按下按键"i"，开始插入到文件末尾。

```
export PATH=/usr/local/mongodb/bin:$PATH
```

3、退出并保存

Ctrl+C：退出inster模式

输入":wq"+回车：保存并退出

4、刷新环境变量

```
$ source ~/.bashrc
```

* 创建MongoDB数据库目录

MongoDB的数据存储在Data目录的db目录下，但这些目录不会自动创建，需要手动创建/data/db目录，现在根目录(/)下创建data/db目录。

```
$ sudo mkdir -p /data/db
```

注：若用户在其他位置创建data/db目录，需要启动mongod 服务时用--dbpath=xxxx来制定数据库的存储目录。/data/db这里是默认的路径，所以不需要设置。

* 测试安装情况
Question1:

```
$ mongod

>>mongod: error while loading shared libraries: libcurl.so.4: cannot open shared object file: No such file or directory
```

Solve1:

```
$ sudo apt-get install libcurl4-openssl-dev
>>
```

Question2:

```
$ mongod

>>......
>>......
>>exception in initAndListen: IllegalOperation: Attempted to create a lock file on a read-only directory: /data/db, terminating
>>......
```

Solve2:

出现的原因是因为 /data/db的权限不足导致的。

```
$sudo chmod 777 -R /data
```


以上问题解决，可以运行。

开两个ssh，一个打开mongod，一个测试mongo。

* 打开远程连接

**服务器端**

1、打开27017防火墙

```
$ sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 27017 -j ACCEPT
```

2、打开mongod并对所有ip开放

```
$ mongod --bind_ip 0.0.0.0
```

**客户端**

连接

```
$ mongo <远程IP>
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
```
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

## 6.12 函数
```
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

```
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





