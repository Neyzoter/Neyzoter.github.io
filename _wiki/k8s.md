---
layout: wiki
title: Kubernetes
categories: Kubernetes
description: Kubernetes学习笔记
keywords: 分布式, 容器, Kubernetes
---

# 1.Kubernetes介绍

Kubernetes = K8(个单词)s，希腊语，表示舵手。Kubernetes是一个自动化的容器编排平台，负责应用的部署、应用的弹性以及应用的管理，均基于容器。

## 1.1 Kubernetes核心功能

- 服务的发现与负载的均衡；
- 容器的自动装箱，就是“调度”，把一个容器放到一个集群的某一个机器上，Kubernetes 会帮助我们去做存储的编排，让存储的声明周期与容器的生命周期能有一个连接；
- Kubernetes 会帮助我们去做自动化的容器的恢复。在一个集群中，经常会出现宿主机的问题或者说是 OS 的问题，导致容器本身的不可用，Kubernetes 会自动地对这些不可用的容器进行恢复；
- Kubernetes 会帮助我们去做应用的自动发布与应用的回滚，以及与应用相关的配置密文的管理；
- 对于 job 类型任务，Kubernetes 可以去做批量的执行；
- 为了让这个集群、这个应用更富有弹性，Kubernetes 也支持水平的伸缩。

### 1.1.1 调度

Kubernetes调度器可以将用户提交的容器分配到Kubernetes管理的集群的某一个节点上。比如调度器会根据容器所需的CPU和内存来寻找较为空闲的机器，进行放置（placement）操作。比如下图中的正在调度的容器（红色）很有可能放置到第二个空闲的机器上。

<img src="/images/wiki/k8s/scheduling_example.png" width="500" alt="调度例子">

### 1.1.2 自动修复

Kubernetes具备节点健康检查的功能，监测集群中所有的宿主机，宿主机出现故障时，或者软件出现故障时，健康节点会自动对它进行发现。如果发现则，将容器部署到另外的节点运行，如下所示：

<img src="/images/wiki/k8s/repair.png" width="500" alt="自动修复例子">

### 1.1.3 水平伸缩

Kubernetes会检查业务的负载，CPU负载过高，或者响应时间过长，则会对该业务进行扩容。比如下图，黄色过度忙碌，K8s吧黄色负载从**1份分成3份**，通过负载均衡把原来一个黄色负载上的负载分配到三个黄色的负载，进而提高响应速度和降低CPU负载。

<img src="/images/wiki/k8s/horizonal_extention.png" width="600" alt="水平伸缩例子">

## 1.2 K8s的架构

### 1.2.1 总体架构

K8s架构是一个典型的二层架构和server-client架构。Master作为中央的管控节点，会连接所有Node。UI、clients（CLI）这类组件**只**会和Master进行连接，把希望的状态或者想执行的命令下发给Master，Master会将命令和状态下发给相应的节点执行。

<img src="/images/wiki/k8s/structure_k8s.png" width="500" alt="k8s架构">

### 1.2.2 Master组件

K8s的Master包括四个主要的组件：API Server、Controller、Scheduler 以及 etcd。

<img src="/images/wiki/k8s/structure_k8s_master_detail.png" width="500" alt="包括Master细节的k8s架构">

* **API Server**

  用于处理API操作，组件之间一般不进行独立连接，依赖于API Server的消息传达。*本身在部署结构上可以水平拓展的组件。*

* **Controller**

  管理集群状态，如自动容器修复、自动水平扩张。*可进行热备的部署组件，只有一个激活。*

* **Scheduler**

  把一个用户提交的 Container，依据它对 CPU、对 memory 请求大小，找一台合适的节点，进行放置

* **etcd**

  高可用的分布式存储系统，API Server中所需要的原信息都被放置在etcd。

### 1.2.3 Node

Node在Kubernetes集群中运行业务负载，每个业务负载都会一Pod的形式运行。**一个Pod中运行一个或者多个容器，**而Kubelet是真正运行Pod的组件。Kubelet通过API Server接收到所需要Pod运行的状态，然后提交到Container Runtime组件中。

<img src="/images/wiki/k8s/structure_k8s_node_details.png" width="500" alt="包括Node细节的k8s架构">

Storage Plugin完成存储操作，Network Plugin完成网络操作。

### 1.2.4 部署过程

* 1.UI或者CLI提交一个Pod给Kubernetes的API Server
* 2.API Server将信息写入到存储系统etcd
* 3.调度器（Scheduler）通过API Server的watch或者notification机制得到该消息，即一个Pod需要被调度
* 4.Scheduler根据内存状态进行调度决策，并给API Server返回状态
* 5.API Server将此次操作写入到etcd，并通知相应节点进行Pod的真正启动
* 6.kubelet得到通知，调Container runtime来真正启动配置容器和容器的运行环境
* 7.kubelet调度Storage Plugin存储存储，Network Plugin配置网络

<img src="/images/wiki/k8s/Run_Task_Process.webp" width="800" alt="Pod运行过程">

## 1.3 K8s的核心概念

### 1.3.1 Pod

Pod是K8s的最小调度以及资源单元。用户可通过K8s的Pod API胜场Pod，让Kubernetes对Pod进行调度，即放到某一个节点上运行。一个Pod中会包含一个或者多个容器。一个Pod还包括Volume存储资源。

<img src="/images/wiki/k8s/Pod_structure.png" width="300" alt="Pod结构">

**Pod给Pod内容器提供共享的运行环境，共享同一个网络环境（localhost）。**Pod和Pod之间，互相隔离。

### 1.3.2 Volume

Volume是卷，管理Kubernetes存储，可以访问文件目录。一个卷可以被挂载在Pod中一个或者多个容器的制定路劲下面。K8s的Volume支持很多存储插件，可以支持本地存储，如ceph、GlusterFS，云存储如阿里云云盘、AWS的云盘和Google的云盘。

### 1.3.3 Deployment

Deployment可以定义一组Pod的副本数目以及Pod版本，实现应用的真正管理，而Pod是组成Deployment的最小单元。

Controller来维护Deployment中Pod的数目，帮助Deployment自动回复失败的Pod。

<img src="/images/wiki/k8s/Deployment_Pods.png" width="450" alt="Pod结构">

### 1.3.4 Service

Service提供一个或者多个Pod实例的稳定访问地址。

实现Service由多种方式，K8s支持Cluster IP，比如kuber-proxy组网、nodePort、LoadBalancer。

<img src="/images/wiki/k8s/Service_Virtual_IP.png" width="450" alt="Service提供访问地址">

### 1.3.5 Namespace

Namespace用于实现集群内部的逻辑隔离，包括鉴权、资源管理。Kubernetes的每个资源，如Pod、Deployment、Service都属于一个Namespace，**同一个Namespace内的资源需要唯一命名**。Alibaba内部会有多个business units，每个之间都有视图上的隔离，并且在鉴权上不一样。

<img src="/images/wiki/k8s/Two_Namespace.png" width="400" alt="2个Namespace">

### 1.3.6 K8s的API

K8s的API由HTTP+JSON组成，通过HTTP访问，content的内容是JSON格式。

以下是访问路劲和content内容。

<img src="/images/wiki/k8s/api_format.png" width="500" alt="api格式">

**kind**表述要操作的资源。

**Metadate**中包括Pod的名字，如nginx。

**Spec**的status，表达该资源当前的状态，如正在被调度、running、terminates或者执行完毕。

# 2、K8S集群搭建

* 准备工作

  ```bash
  # 1、关闭防火墙、selinux
  # selinux(Security-Enhanced Linux)：加强安全性的一个组件，但非常容易出错且难以定位
  # k8s是需要用防火墙做ip转发和修改的，当然也看使用的网络模式，如果采用的网络模式不需要防火墙也是可以直接关闭的
  $ systemctl disable --now firewalld
  # 2、setenforce 0 (临时生效可以直接用setenforce 0 ) 1 启用  0 告警，不启用
  $ setenforce 0
  setenforce: SELinux is disabled
  # 3、将/etc/selinux/config文件中的SELINUX参数数值改为disabled
  # 4、关闭swap分区，提高性能
  swapoff -a
  ## 未知作用，待考证
  ## /etc/fstab文件包含众多文件系统的描述信息
  sed -i.bak 's/^.*centos-swap/#&/g' /etc/fstab
  ```

* 

# 参考

[1.云栖社区推文](https://mp.weixin.qq.com/s/avLAGdLw210BOKn-aaFvIw)