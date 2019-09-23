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

<img src="image/wiki/k8s/scheduling_example.png" width="700" alt="调度例子">

### 1.1.2 自动修复

Kubernetes具备节点健康检查的功能，监测集群中所有的宿主机，宿主机出现故障时，或者软件出现故障时，健康节点会自动对它进行发现。如果发现则，将容器部署到另外的节点运行，如下所示：

<img src="image/wiki/k8s/repair.png" width="500" alt="自动修复例子">

### 1.1.3 水平伸缩

Kubernetes会检查业务的负载，CPU负载过高，或者响应时间过长，则会对该业务进行扩容。比如下图，黄色过度忙碌，K8s吧黄色负载从**1份分成3份**，通过负载均衡把原来一个黄色负载上的负载分配到三个黄色的负载，进而提高响应速度和降低CPU负载。

<img src="image/wiki/k8s/horizonal_extention.png" width="600" alt="水平伸缩例子">

## 1.2 K8s的架构

### 1.2.1 总体架构

K8s架构是一个典型的二层架构和server-client架构。Master作为中央的管控节点，会连接所有Node。UI、clients（CLI）这类组件**只**会和Master进行连接，把希望的状态或者想执行的命令下发给Master，Master会将命令和状态下发给相应的节点执行。

<img src="image/wiki/k8s/structure_k8s.png" width="600" alt="k8s架构">

### 1.2.2 Master组件

K8s的Master包括四个主要的组件：API Server、Controller、Scheduler 以及 etcd。

<img src="image/wiki/k8s/structure_k8s_master_detail.png" width="600" alt="包括Master细节的k8s架构">

* **API Server**

  用于处理API操作，组件之间一般不进行独立连接，依赖于API Server的消息传达。





# 参考

[1.云栖社区推文](https://mp.weixin.qq.com/s/avLAGdLw210BOKn-aaFvIw)