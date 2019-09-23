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

<img src="image/wiki/Redis/scheduling_example.png" width=700 alt="调度例子">



# 参考

[1.云栖社区推文](https://mp.weixin.qq.com/s/avLAGdLw210BOKn-aaFvIw)