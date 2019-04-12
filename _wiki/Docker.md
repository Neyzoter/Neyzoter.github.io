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
|-|-|
|Docker 容器(Container)|容器是独立运行的一个或一组应用|
|-|-|
|Docker客户端(Client) |Docker 客户端通过命令行或者其他工具使用[Docker API](https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。|
|-|-|
|Docker 主机(Host)|一个物理或者虚拟的机器用于执行 Docker 守护进程和容器|
|-|-|
|Docker 仓库(Registry)|Docker 仓库用来保存镜像，可以理解为代码控制中的代码仓库。[Docker Hub](https://hub.docker.com) 提供了庞大的镜像集合供使用。|
|-|-|
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
[Win安装Docker](https://www.w3cschool.cn/docker/windows-docker-install.html)

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

## 3.1 以非ROOT方式管理Docker

1.创建一个docker group

````bash
$ sudo groupadd docker
````

2.添加用户到docker group中

```bash
$ sudo usermod -aG docker $USER
```

3.重启

4.验证（不使用sudo）

```bash
$ docker run hello-world
```

