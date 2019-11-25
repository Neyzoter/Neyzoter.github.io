---
layout: wiki
title: ZooKeeper
categories: ZooKeeper
description: ZooKeeper框架使用
keywords: ZooKeeper, Bigdata, Kafka
---

# 1.ZooKeeper介绍

Zookepper是一种分布式协调服务，用于管理大型主机。分布式应用有两部分， **Server（服务器）** 和 **Client（客户端）** 应用程序。服务器应用程序实际上是分布式的，并具有通用接口，以便客户端可以连接到集群中的任何服务器并获得相同的结果。 客户端应用程序是与分布式应用进行交互的工具。ZooKeeper的常用服务：

- **命名服务** - 按名称标识集群中的节点。它类似于DNS，但仅对于节点。
- **配置管理** - 加入节点的最近的和最新的系统配置信息。
- **集群管理** - 实时地在集群和节点状态中加入/离开节点。
- **选举算法** - 选举一个节点作为协调目的的leader。
- **锁定和同步服务** - 在修改数据的同时锁定数据。此机制可帮助你在连接其他分布式应用程序（如Apache HBase）时进行自动故障恢复。
- **高度可靠的数据注册表** - 即使在一个或几个节点关闭时也可以获得数据。

# 2.ZooKeeper技术

## 2.1 ZK基础

### 2.1 架构

<img src="/images/wiki/ZooKeeper/Client-Server-Arch.jpg" width="600" alt="ZooKeeper的客户端-服务器架构" />

* 客户端

  客户端从服务器访问信息。当客户端连接时，服务器发送确认码。如果连接的服务器没有响应，则客户端会自动将消息重定向到另外一个服务器。

* 服务器

  Zookeeper集群中的一个节点，为客户端提供所有的服务。向客户端发送确认码以告知服务器是活跃的。

* Ensemble

  服务器组，最小节点数是3

* 主节点

  如果任何连接的节点失败，则执行自动恢复

* 从节点

  跟随主节点指令的服务器节点

### 2.2 层次命名空间

ZooKeeper节点称为 **znode** 。每个znode由一个名称标识，并用路径`/`序列分隔。

config（集中式配置管理）和workers（命名）是两个逻辑命名空间。config命名空间下，每个znode最多可以存储1MB的数据。

<img src="/images/wiki/ZooKeeper/namespace.jpg" width="600" alt="ZooKeeper的命名空间" />

