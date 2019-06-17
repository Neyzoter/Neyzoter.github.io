---
layout: wiki
title: Docker
categories: Docker
description: Docker学习笔记
keywords: Docker,虚拟机
---

# 1.Docker
## 1.1 简介
Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化，容器是完全使用**沙箱机制**，相互之间不会有任何接口。

**主要组件**：

|组件|作用|
|-|-|
|Docker 镜像(Images)|Docker 镜像是用于创建 Docker容器的模板|
|Docker 容器(Container)|容器是**独立运行**（有各自的网关、IP地址，比如mongo运行在127.0.0.2，应用运行在127.0.0.3，应用不能通过localhost来访问mongodb）的一个或一组应用|
|Docker客户端(Client) |Docker 客户端通过命令行或者其他工具使用[Docker API](https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。|
|Docker 主机(Host)|一个物理或者虚拟的机器用于执行 Docker 守护进程和容器|
|Docker 仓库(Registry)|Docker 仓库用来保存镜像，可以理解为代码控制中的代码仓库。[Docker Hub](https://hub.docker.com) 提供了庞大的镜像集合供使用。|
|Docker Machine|Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。|

我们通过客户端写命令，然后客户端将命令发送给守护进程，守护进程再将命令执行的结果返回给客户端，这就使我们能通过命令查看执行结果，镜像就是容器的源代码，容器通过镜像启动，使用仓库来保存用户构建的镜像，仓库分为共有和私有。

>**沙箱机制**
沙箱(Sandbox)是一种程序的隔离运行机制，其目的是限制不可信进程或不可信代码运行时的访问权限。沙箱技术经常被用于执行未经测试的或不可信的客户程序。为了阻止不可信程序可能破坏系统程序或破坏其它用户程序的运行，沙箱技术通过为不可信客户程序提供虚拟化的内存、文件系统、网络等资源，而这种虚拟化手段对客户程序来说是透明的。由于沙箱里的资源被虚拟化（或被间接化），所以沙箱里的不可信程序的恶意行为可以被限制在沙箱中，或者在沙箱里只允许执行在白名单里规定的有限的API。

## 1.2 Docker架构

Docker 使用客户端-服务器 (C/S) 架构模式，使用远程API来管理和创建Docker容器。

<img src="/images/wiki/Docker/structure.png" width="500" alt="Docker架构" />

# 2.Docker安装
## 2.1 Ubuntu下安装

英文安装导航：[Ubuntu下安装Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/ "Ubuntu下安装Docker")

* 前提

Ubuntu内核版本高于3.10

```bash
$ uname -r
```

* 脚本安装

1.卸载旧版本

Docker的旧版本名称为:docker、docker-engine或者docker-io

如果安装过旧版本则需要先卸载。

```bash
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

2.安装https相关的软件包

docker安装需要使用https，所以需要使 apt 支持 https 的拉取方式。

```bash
$ sudo apt-get update # 先更新一下软件源库信息

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

3、设置apt仓库地址

有多个来源，比如国外源、阿里源等。

**国外源（可能不稳定）**

```bash
# 添加 Docker 官方的 GPG 密钥（为了确认所下载软件包的合法性，需要添加软件源的 GPG 密钥）
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 设置稳定版本的apt仓库地址
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

**阿里源**

```bash
$ curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

$ sudo add-apt-repository \
     "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
```

4.	安装Docker

```bash
$ sudo apt-get update

$ sudo apt-get install docker-ce docker-ce-cli containerd.io # 安装最新版的docker
或者
$ sudo apt-get install docker-ce
```

5.docker版本

```bash
$ docker --version
```

6.启动Docker

```bash
$ sudo service docker start
```

## 2.2 CentOS下安装

[CentOs安装Docker](https://www.w3cschool.cn/docker/centos-docker-install.html)

## 2.3 Win下安装

### 2.3.1 方案1：Windows自带Hyper-V虚拟机

1、前期准备

电脑是windows10专业版或企业版，才有Hyper-V

2、[下载docker4win](https://store.docker.com/editions/community/docker-ce-desktop-windows)

3、安装

安装后会自动注销

4、开启Hyper-V

运行docker前需要开启Hyper-V（Docker自动提示），之前需要在**BIOS开启虚拟化技术**。

<img src="images/wiki/Docker/Hyper_V_Enable.png" width=500 alt="Hyper-V">

5、验证Docker

cmd查看Docker版本

```bash
$ docker --version
```

### 2.3.2 方案2：Virtual box创建虚拟机

[Win安装Docker](https://www.w3cschool.cn/docker/windows-docker-install.html)

## 2.4 以非ROOT方式管理Docker

1.创建一个docker group

```bash
$ sudo groupadd docker
```

2.添加用户到docker group中

```bash
$ sudo usermod -aG docker $USER
```

3.重启

4.验证（不使用sudo）

```bash
$ docker run hello-world
```

## 2.5 Docker开机启动

**systemd**

```bash
# systemctl enable XXX ： 开机自动启动
$ sudo systemctl enable docker
# systemctl disable XXX ： 开机不自动启动
$ sudo systemctl disable docker
```

# 3.Docker使用

**注意**：shell都基于ubuntu bash

## 3.1 hello world

```bash
sudo docker run hello-world
```

输出

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete 
Digest: sha256:2557e3c07ed1e38f26e389462d03ed943586f744621577a99efb77324b0fe535
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 3.2 Docker容器使用

**查看命令**

```bash
$ docker
```

**查看命令的具体使用方法**

```bash
# CMD：具体的命令名称
$ docker CMD --help
```

**运行一个web应用**

```bash
# -d：让容器在后台运行
# -P：将容器内部使用的网络端口映射到我们使用的主机上
$ docker run -d -P training/webapp python app.py
# 指定-p标识来绑定指定端口
$ docker run -d -p 5000:5000 training/webapp python app.py
```

**查看web应用容器**

```bash
# 查看容器运行情况
$ docker ps
# 查看某一个容器的端口映射情况
# CONTAINER_ID或者CONTAINER_NAME可以通过$ docker ps查看得到
$ docker port CONTAINER_ID/CONTAINER_NAME
```

**查看web应用程序的日志**

```bash
# -f：让docker logs 像使用tail -f一样来输出容器内部的标准输出
$ docker logs -f CONTAINER_ID/CONTAINER_NAME
```

**查看web应用程序容器的进程**

```bash
$ docker top CONTAINER_ID/CONTAINER_NAME
```

**检查web应用程序**

```bash
$ docker inspect CONTAINER_ID/CONTAINER_NAME
```

**停止/重启web应用容器**

```bash
# 停止
$ docker stop CONTAINER_ID/CONTAINER_NAME
# 开启
$ docker start CONTAINER_ID/CONTAINER_NAME
```

**移除web应用容器**

```bash
# 容器必须为停止状态
$ docker rm CONTAINER_ID/CONTAINER_NAME
```

# 4.Docker镜像使用

当运行容器时，使用的镜像如果在本地不存在，docker会自动从docker镜像仓库中下载，默认从Docker Hub镜像源下载。

## 4.1 列出镜像列表

```bash
# 输出，REPOSTITORY：表示镜像的仓库源；TAG：镜像的标签；IMAGE ID：镜像ID；CREATED：镜像创建时间；SIZE：镜像大小
$ docker images
```

说明：

> 同一仓库源可以有多个 TAG，代表这个仓库源的不同个版本，如ubuntu仓库源里，有15.10、14.04等多个不同的版本，我们使用 REPOSTITORY:TAG 来定义不同的镜像。我们如果要使用版本为15.10的ubuntu系统镜像来运行容器时，命令如下：```$ docker run -t -i ubuntu:15.10 /bin/bash ```。如果你不指定一个镜像的版本标签，例如你只使用 ubuntu，docker 将默认使用 ubuntu:latest 镜像。

## 4.2 查找并获取一个新的镜像

```bash
# 查找
## REPOSTITORY：镜像仓库源，如httpd
$ docker search REPOSTITORY
## 输出
NAME:镜像仓库源的名称
DESCRIPTION:镜像的描述
OFFICIAL:是否docker官方发布

# 获取
## REPOSTITORY：镜像仓库源
## TAG：镜像的标签
$ docker pull REPOSTITORY:TAG
## 例子
$ docker pull ubuntu:13.10
```

## 4.3 创建自己的镜像

当我们从docker镜像仓库中下载的镜像不能满足我们的需求时，我们可以通过以下两种方式对镜像进行更改。

（1）从已经创建的容器中更新镜像，并且提交这个镜像

```bash
# 1.更新镜像之前，使用镜像来创建一个容器
## 在运行的容器内使用 apt-get update 命令进行更新。
## 在完成操作之后，输入 exit命令来退出这个容器。
$ docker run -t -i ubuntu:15.10 /bin/bash

# 2.通过命令 docker commit来提交容器副本
## -m:提交的描述信息;-a:指定镜像作者;e218edb10161：容器ID;w3cschool/ubuntu:v2:指定要创建的目标镜像名
$ docker commit -m="has update" -a="youj" e218edb10161 w3cschool/ubuntu:v2

# 3.查看新镜像
$ docker images

# 4.新镜像 w3cschool/ubuntu 来启动一个容器
$ docker run -t -i w3cschool/ubuntu:v2 /bin/bash 
```

（2）使用 Dockerfile 指令来创建一个新的镜像

```bash
# 1.创建一个Dockerfile文件，包含一组指令来告诉Docker如何构建镜像
## Dockerfile文件
### FROM：指定使用哪个镜像源；RUN：告诉docker 在镜像内执行命令
FROM    centos:6.7
MAINTAINER      Fisher "fisher@sudops.com"

RUN     /bin/echo 'root:123456' |chpasswd
RUN     useradd youj
RUN     /bin/echo 'youj:123456' |chpasswd
RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" &gt; /etc/default/local
EXPOSE  22
EXPOSE  80
CMD     /usr/sbin/sshd -D

# 2.使用DockerFile文件构建一个镜像
## -t ：指定要创建的目标镜像名
## . ：Dockerfile 文件所在目录，可以指定Dockerfile 的绝对路径
$ docker build -t youj/centos:6.7 .

# 3.设置镜像标签
## 查看镜像ID
$ docker images
## 设置新的镜像标签，设置后会有两个tag不一样的youj/centos，分别为youj/centos:6.7和youj/centos:dev
### docker tag 镜像ID，这里是 860c279d2fec ,用户名称、镜像源名(repository name)和新的标签名(tag)。
$ docker tag 860c279d2fec youj/centos:dev
```

## 4.4 Docker容器连接

（1）端口连接到一个docker容器

```bash
# 开启一个python应用的  多种  方法
## 方法1.指定IP、Docker容器端口（5002）和主机端口（5001）
$ docker run -d -p 127.0.0.1:5001:5002 training/webapp python app.py
## 方法2.容器内端口5000（后面的5000）绑定到主机端口5000（前面的5000）
$ docker run -d -p 5000:5000 training/webapp python app.py
## 方法3.不指定，默认端口32768
$ docker run -d -P training/webapp python app.py
## 方法4.默认都是绑定 tcp 端口，如果要绑定 UPD 端口，可以在端口后面加上 /udp
$ docker run -d -p 127.0.0.1:5000:5000/udp training/webapp python app.py
```

（2）多个容器连接

docker有一个连接系统允许将多个容器连接在一起，共享连接信息。docker连接会创建一个父子关系，其中父容器可以看到子容器的信息。

```bash
# 1.容器命名(--name)，也可以自动命名
$ docker run -d -P --name youj training/webapp python app.py
```

## 4.5 Dockerfile文件解析

Dockfile是一种被Docker程序解释的脚本，Dockerfile由一条一条的指令组成，每条指令对应Linux下面的一条命令。Docker程序将这些Dockerfile指令翻译真正的Linux命令。Dockerfile有自己书写格式和支持的命令，Docker程序解决这些命令间的依赖关系，类似于Makefile。Docker程序将读取Dockerfile，根据指令生成定制的image。相比image这种黑盒子，Dockerfile这种显而易见的脚本更容易被使用者接受，它明确的表明image是怎么产生的。有了Dockerfile，当我们需要定制自己额外的需求时，只需在Dockerfile上添加或者修改指令，重新生成image即可，省去了敲命令的麻烦。

Dockerfile文件一共分为四个部分，分别是：**注释信息、基础镜像、创建者信息、构建镜像所需的命令***

在 Dockerfile 中用到的命令有

 **FROM**

FROM指定一个基础镜像， 一般情况下一个可用的 Dockerfile一定是 FROM 为第一个指令。至于image则可以是任何合理存在的image镜像。

FROM 一定是首个非注释指令 Dockerfile.

FROM 可以在一个 Dockerfile 中出现多次，以便于创建混合的images。

如果没有指定 tag ，latest 将会被指定为要使用的基础镜像版本。

**MAINTAINER**

这里是用于指定镜像制作者的信息

**RUN**

RUN命令将在当前image中执行任意合法命令并提交执行结果。命令执行提交后，就会自动执行Dockerfile中的下一个指令。

层级 RUN 指令和生成提交是符合Docker核心理念的做法。它允许像版本控制那样，在任意一个点，对image 镜像进行定制化构建。

RUN 指令缓存不会在下个命令执行时自动失效。比如 RUN apt-get dist-upgrade -y 的缓存就可能被用于下一个指令. --no-cache 标志可以被用于强制取消缓存使用。

**ENV**

ENV指令可以用于为docker容器设置环境变量

ENV设置的环境变量，可以使用 docker inspect命令来查看。同时还可以使用```docker run --env <key>=<value>```来修改环境变量。

**USER**

USER 用来切换运行属主身份的。Docker 默认是使用 root，但若不需要，建议切换使用者身分，毕竟 root 权限太大了，使用上有安全的风险。

**WORKDIR**

WORKDIR 用来切换工作目录的。Docker 默认的工作目录是/，只有 RUN 能执行 cd 命令切换目录，而且还只作用在当下下的 RUN，也就是说每一个 RUN 都是独立进行的。如果想让其他指令在指定的目录下执行，就得靠 WORKDIR。WORKDIR 动作的目录改变是持久的，不用每个指令前都使用一次 WORKDIR。

**COPY**

COPY 将文件从路径``` <src>``` 复制添加到容器内部路径 ```<dest>```。

```<src>``` 必须是想对于源文件夹的一个文件或目录，也可以是一个远程的url，```<dest>```是目标容器中的绝对路径。

所有的新文件和文件夹都会创建UID 和 GID 。事实上如果``` <src>``` 是一个远程文件URL，那么目标文件的权限将会是600。

**ADD**

 ADD 将文件从路径 ```<src> ```复制添加到容器内部路径 ```<dest>```。

```<src>``` 必须是想对于源文件夹的一个文件或目录，也可以是一个远程的url。```<dest> ```是目标容器中的绝对路径。

 所有的新文件和文件夹都会创建UID 和 GID。事实上如果 ```<src> ```是一个远程文件URL，那么目标文件的权限将会是600。

**VOLUME**

创建一个可以从本地主机或其他容器挂载的挂载点，一般用来存放数据库和需要保持的数据等。

**EXPOSE**

EXPOSE 指令指定在docker允许时指定的端口进行转发。

**CMD**

Dockerfile.中只能有一个CMD指令。 如果你指定了多个，那么最后个CMD指令是生效的。

CMD指令的主要作用是提供默认的执行容器。这些默认值可以包括可执行文件，也可以省略可执行文件。

当你使用shell或exec格式时，  CMD 会自动执行这个命令。

**ONBUILD**

ONBUILD 的作用就是让指令延迟執行，延迟到下一个使用 FROM 的 Dockerfile 在建立 image 时执行，只限延迟一次。

ONBUILD 的使用情景是在建立镜像时取得最新的源码 (搭配 RUN) 与限定系统框架。

**ARG**

ARG是Docker1.9 版本才新加入的指令。

ARG 定义的变量只在建立 image 时有效，建立完成后变量就失效消失

**LABEL**

定义一个 image 标签 Owner，并赋值，其值为变量 Name 的值。(LABEL Owner=$Name )

**ENTRYPOINT**

是指定 Docker image 运行成 instance (也就是 Docker container) 时，要执行的命令或者文件。

## 4.6 开启远程

**配置文件修改**

```bash
# /etc/default/docker 文件修改
# 最后一行添加，这里指定了端口2375
DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"
```

```bash
# /lib/systemd/system/docker.service
# ExecStart=/usr/bin/dockerd -H fd://后面添加-H tcp://0.0.0.0:2375
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
```

**重启docker**

```bash
systemctl daemon-reload
systemctl restart docker.service
```

```bash
netstat -plnt |grep 2375
```

**测试远程**

```bash
curl IP:PORT 
```



# 5.Docker实例

## 5.1 Ngnix

```bash
# 1.安装ngnix
$ docker search nginx
$ docker pull nginx
# 2.使用ngnix
## -p 80:80：将容器的80端口(后面的80)映射到主机的80端口(前面的80)
## --name mynginx：将容器命名为mynginx
## -v $PWD/www:/www：将主机中当前目录下的www挂载到容器的/www
## -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf：将主机中当前目录下的nginx.conf挂载到容器的/etc/nginx/nginx.conf
## -v $PWD/logs:/wwwlogs：将主机中当前目录下的logs挂载到容器的/wwwlogs
$ docker run -p 80:80 --name mynginx -v $PWD/www:/www -v
$ PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/logs:/wwwlogs  -d nginx
```

## 5.2 MySQL

```bash
# 1.安装Mysql
$ docker search mysql
## 获取5.6版本
$ docker pull mysql:5.6
# 2.使用MySQL
## -p 3306:3306：将容器的3306端口映射到主机的3306端口
## -v $PWD/conf/my.cnf:/etc/mysql/my.cnf：将主机当前目录下的conf/my.cnf挂载到容器的/etc/mysql/my.cnf
## -v $PWD/logs:/logs：将主机当前目录下的logs目录挂载到容器的/logs
## -v $PWD/data:/mysql_data：将主机当前目录下的data目录挂载到容器的/mysql_data
## -e MYSQL_ROOT_PASSWORD=123456：初始化root用户的密码
$ docker run -p 3306:3306 --name mymysql -v $PWD/conf/my.cnf:/etc/mysql/my.cnf -v 
$ PWD/logs:/logs -v $PWD/data:/mysql_data -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6
```

## 5.3 Tomcat

**简要安装说明**

往往不建议使用这种方法，因为设置参数不方便。

```bash
# 1.安装tomcat
$ docker search tomcat
## 拉取Tomcat-8.0版本
$ docker pull tomcat:8.0

# 2.使用tomcat
# -p 8080:8080：将容器的8080端口(后面的8080)映射到主机的8080端口(前面的8080)
# -v $PWD/test:/usr/local/tomcat/webapps/test：将主机中当前目录下的test挂载到容器的/test
$ docker run --name mytomcat -p 8080:8080 -v $PWD/test:/usr/local/tomcat/webapps/test -d tomcat:8.0
```

**Dockerfile安装**

Dockerfile安装可以配置各种参数，Dockfile可以从hub.docker.com的[tomcat](https://hub.docker.com/_/tomcat)下载

根据官方的dockerfile进行修改。

```bash
FROM ubuntu:16.04
MAINTAINER songchaochao "songchaochao@zju.edu.cn"

# 安装openjdk-8-jdk
RUN apt-get update
RUN apt-get install openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# 指定地址
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# runtime dependencies for Tomcat Native Libraries
# Tomcat Native 1.2+ requires a newer version of OpenSSL than debian:jessie has available
# > checking OpenSSL library version >= 1.0.2...
# > configure: error: Your version of OpenSSL is not compatible with this version of tcnative
# see http://tomcat.10.x6.nabble.com/VOTE-Release-Apache-Tomcat-8-0-32-tp5046007p5046024.html (and following discussion)
# and https://github.com/docker-library/tomcat/pull/31
ENV OPENSSL_VERSION 1.1.0j-1~deb9u1
RUN set -ex; \
	currentVersion="$(dpkg-query --show --showformat '${Version}\n' openssl)"; \
	if dpkg --compare-versions "$currentVersion" '<<' "$OPENSSL_VERSION"; then \
		if ! grep -q stretch /etc/apt/sources.list; then \
# only add stretch if we're not already building from within stretch
			{ \
				echo 'deb http://deb.debian.org/debian stretch main'; \
				echo 'deb http://security.debian.org stretch/updates main'; \
				echo 'deb http://deb.debian.org/debian stretch-updates main'; \
			} > /etc/apt/sources.list.d/stretch.list; \
			{ \
# add a negative "Pin-Priority" so that we never ever get packages from stretch unless we explicitly request them
				echo 'Package: *'; \
				echo 'Pin: release n=stretch*'; \
				echo 'Pin-Priority: -10'; \
				echo; \
# ... except OpenSSL, which is the reason we're here
				echo 'Package: openssl libssl*'; \
				echo "Pin: version $OPENSSL_VERSION"; \
				echo 'Pin-Priority: 990'; \
			} > /etc/apt/preferences.d/stretch-openssl; \
		fi; \
		apt-get update; \
		apt-get install -y --no-install-recommends openssl="$OPENSSL_VERSION"; \
		rm -rf /var/lib/apt/lists/*; \
	fi

RUN apt-get update && apt-get install -y --no-install-recommends \
		libapr1 \
	&& rm -rf /var/lib/apt/lists/*

# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "update.sh" (https://github.com/docker-library/tomcat/blob/master/update.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.39
ENV TOMCAT_SHA512 8396f526eca9b691931cfa773f43c5190e7002d938cb253335b65a32c7ef8acba2bf7c61f2ccffc4113a3ba0c46169a4e4797cdea73db32c5ba56156a9f49353

ENV TOMCAT_TGZ_URLS \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
	https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
# if the version is outdated, we might have to pull from the dist/archive :/
	https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV TOMCAT_ASC_URLS \
	https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
# not all the mirrors actually carry the .asc files :'(
	https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
	https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
	https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	\
	apt-get install -y --no-install-recommends gnupg dirmngr; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	for key in $GPG_KEYS; do \
		gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done; \
	\
	apt-get install -y --no-install-recommends wget ca-certificates; \
	\
	success=; \
	for url in $TOMCAT_TGZ_URLS; do \
		if wget -O tomcat.tar.gz "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum -c -; \
	\
	success=; \
	for url in $TOMCAT_ASC_URLS; do \
		if wget -O tomcat.tar.gz.asc "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz; \
	tar -xvf tomcat.tar.gz --strip-components=1; \
	rm bin/*.bat; \
	rm tomcat.tar.gz*; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME"; \
	\
	nativeBuildDir="$(mktemp -d)"; \
	tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	apt-get install -y --no-install-recommends \
		dpkg-dev \
		gcc \
		libapr1-dev \
		libssl-dev \
		make \
		"openjdk-${JAVA_VERSION%%[.~bu-]*}-jdk=$JAVA_DEBIAN_VERSION" \
	; \
	( \
		export CATALINA_HOME="$PWD"; \
		cd "$nativeBuildDir/native"; \
		gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
		./configure \
			--build="$gnuArch" \
			--libdir="$TOMCAT_NATIVE_LIBDIR" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$(which apr-1-config)" \
			--with-java-home="$(docker-java-home)" \
			--with-ssl=yes; \
		make -j "$(nproc)"; \
		make install; \
	); \
	rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
# sh removes env vars it doesn't support (ones with periods)
# https://github.com/docker-library/tomcat/issues/77
	find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +; \
	\
# fix permissions (especially for running as non-root)
# https://github.com/docker-library/tomcat/issues/35
	chmod -R +rX .; \
	chmod 777 logs work

# verify Tomcat Native is working properly
RUN set -e \
	&& nativeLines="$(catalina.sh configtest 2>&1)" \
	&& nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" \
	&& nativeLines="$(echo "$nativeLines" | sort -u)" \
	&& if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
		echo >&2 "$nativeLines"; \
		exit 1; \
	fi

EXPOSE 8080
CMD ["catalina.sh", "run"]
```

**具体使用**

```bash
# 1.启动tomcat:tag(8.0版本)
$ docker run -p 8080:8080 --name mytomcat -d tomcat:8.0 
# 2.进入容器，可以看到一个标准的tomcat目录
$ docker exec -it mytomcat bash
# 3.将war包部署到tomcat

```

## 5.4 Redis

**开启Redis**

```bash
docker run --name test-redis -d redis
```

**运行客户端**

```bash
docker run -it --link test-redis:redis --rm redis redis-cli -h redis -p 6379
```

**问题解决**

```
127.0.0.1:6379> config set notify-keyspace-events Egx
```

