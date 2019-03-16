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
* 前提

Ubuntu内核版本高于3.10

* 脚本安装

1.更新到最新软件

```shell
$ sudo apt-get update
```

2.	安装Docker

```shell
$ sudo apt-get install -y docker.io
```

3.启动Docker

```shell
$ sudo service docker start
```

## 2.2 CentOS下安装

[CentOs安装Docker](https://www.w3cschool.cn/docker/centos-docker-install.html)

## 2.3 Win下安装




