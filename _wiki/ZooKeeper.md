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

每个znode都维护着一个stat的数据结构，包括版本号、操作控制列表（ACL）、时间戳和数据长度组成：

* 版本号

  每个znode都有版本号，每当与znode相关联的数据发生变化时，对应的版本号也会变化

* 操作控制列表

  访问znode的认证机制，管理所有znode的写入和读取操作

* 时间戳

  时间戳表示创建和修改znode所经过的时间

* 数据长度

  存储在znode中的数据长度，最长1MB

## 2.2 ZooKeeper工作流

ZooKeeper集合创建好后，客户端的请求流程如下：

1. 客户端连接其中一个节点，可以是Leader，也可以是Follower
2. 节点向客户端发送会话ID和确认信息
3. 如果客户端未收到上述信息，则尝试重新连接ZooKeeper集合中的另外一个节点
4. 连接完成后，节点会不断向客户端发送心跳，以保证连接不丢失
5. 请求：
   * 客户端请求获取znode，（和客户端连接的）节点会返回所请求的znode
   * 客户端请求写入Zookeeper集合，则会将znode路径和数据发送到节点。如果节点不是Leader，则会将该请求转发给Leader节点，Leader节点将该请求发送给所有Follower节点。如果大部分Follower节点写入请求成功，则返回成功代码给客户端

## 2.3 ZooKeeper Leader选举

- **刚启动时的Leader选举**

  (1) 每个Server发出一个投票。由于是初始情况，Server1和Server2都会将自己作为Leader服务器来进行投票，每次投票会包含所推举的服务器的myid和ZXID，使用(myid, ZXID)来表示，此时Server1的投票为(1, 0)，Server2的投票为(2, 0)，然后各自将这个投票发给集群中其他机器。

  (2) 接受来自各个服务器的投票。集群的每个服务器收到投票后，首先判断该投票的有效性，如检查是否是本轮投票、是否来自LOOKING状态的服务器。

  (3) 处理投票。针对每一个投票，服务器都需要将别人的投票和自己的投票进行PK，PK规则如下

  · 优先检查ZXID。ZXID比较大的服务器优先作为Leader。

  · 如果ZXID相同，那么就比较myid。myid较大的服务器作为Leader服务器。

  对于Server1而言，它的投票是(1, 0)，接收Server2的投票为(2, 0)，首先会比较两者的ZXID，均为0，再比较myid，此时Server2的myid最大，于是更新自己的投票为(2, 0)，然后重新投票，对于Server2而言，其无须更新自己的投票，只是再次向集群中所有机器发出上一次投票信息即可。

  (4) 统计投票。每次投票后，服务器都会统计投票信息，判断是否已经有过半机器接受到相同的投票信息，对于Server1、Server2而言，都统计出集群中已经有两台机器接受了(2, 0)的投票信息，此时便认为已经选出了Leader。

  (5) 改变服务器状态。一旦确定了Leader，每个服务器就会更新自己的状态，如果是Follower，那么就变更为FOLLOWING，如果是Leader，就变更为LEADING。

- **运行时的Leader选举**

  (1) 变更状态。Leader挂后，余下的非Observer服务器都会讲自己的服务器状态变更为LOOKING，然后开始进入Leader选举过程。

  (2) 每个Server会发出一个投票。在运行期间，每个服务器上的ZXID可能不同，此时假定Server1的ZXID为123，Server3的ZXID为122；在第一轮投票中，Server1和Server3都会投自己，产生投票(1, 123)，(3, 122)，然后各自将投票发送给集群中所有机器。

  (3) 接收来自各个服务器的投票。与启动时过程相同。

  (4) 处理投票。与启动时过程相同，此时，Server1将会成为Leader。

  (5) 统计投票。与启动时过程相同。

  (6) 改变服务器的状态。与启动时过程相同。

## 3.ZooKeeper使用

## 3.1 Zookeeper安装

1. 安装Java

2. 安装zookeeper

   [下载地址](https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/)，其中带有bin的安装包表示Java文件是二进制的，而没有bin的安装包包含Java源码，故可以选择bin的安装包。解压后将`conf/zoo_sample.cfg`另存为`conf/zoo.cfg`，并配置参数。

    * **问题1：Error: Could not find or load main class org.apache.zookeeper.server.quorum.QuorumPeerMain**

      启动的时候出现以上问题，因为没有下载bin的文件包，故无法找到主类。

    * **问题2：org.apache.zookeeper.server.admin.AdminServer$AdminServerException: Problem starting**

      启动时出现以上问题，因为admin server默认使用8080端口，可能会被占用，可以更改为其他的端口——在`conf/zoo.cfg`中加入或者修改`admin.serverPort=XXXX`。

3. 启动和zookeeper

   ```shell
   # 启动
   $ bin/zkServer.sh start
   # 客户端连接
   $ bin/zkCli.sh
   # 关闭
   $ bin/zkServer.sh stop
   ```

## 3.2 zk客户端

* **创建znode**

  ```bash
  # 创建znode语法
  $ create /path /data
  ```

  举例1：

  ```bash
  # 举例1：创建节点
  $ create /FirstZnode "myfirstzookeeper-app"
  ```

  输出

  ```
  Created /FirstZnode
  ```

  举例2：

  ```bash
  # 举例2：使用参数-s，创建顺序节点，保证znode路径将是唯一的
  $ create -s /FirstZnode "myfirstzookeeper-app"
  ```

  输出：

  ```
  Created /FirstZnode0000000023
  ```

  举例3：

  ```bash
  # 举例3：使用参数-e，创建临时节点，在client断开后自动删除
  $ create -e /FirstZnode "myfirstzookeeper-app"
  ```

  输出：

  ```
  Created /SecondZnode
  ```

* **获取数据**

  ```bash
  # 语法
  # 要访问顺序节点，必须输入znode的完整路径。
  $ get /path
  ```

  输出举例

  ```
  “Myfirstzookeeper-app"
  cZxid = 0x7f
  ctime = Tue Sep 29 16:15:47 IST 2015
  mZxid = 0x7f
  mtime = Tue Sep 29 16:15:47 IST 2015
  pZxid = 0x7f
  cversion = 0
  dataVersion = 0
  aclVersion = 0
  ephemeralOwner = 0x0
  dataLength = 22
  numChildren = 0
  ```

  说明：`cZxid`表示该znode创建时间，`mZxid`表示该znode上次修改的时间，`pZxid`表示该节点的子节点（或该节点，非孙子节点）的最近一次 创建 / 删除 的时间戳对应。

* **监视**

  当指定的znode或znode的子数据更改时，监视器会显示通知（等待znode更改）。

  ```bash
  # 语法
  $ get /path [watch] 1
  # 举例
  $ get /FirstZnode 1
  ```

  输出：

  ```
  WATCHER: :
  
  WatchedEvent state:SyncConnected type:NodeDataChanged path:/FirstZnode
  cZxid = 0x7f
  ctime = Tue Sep 29 16:15:47 IST 2015
  mZxid = 0x84
  mtime = Tue Sep 29 17:14:47 IST 2015
  pZxid = 0x7f
  cversion = 0
  dataVersion = 1
  aclVersion = 0
  ephemeralOwner = 0x0
  dataLength = 23
  numChildren = 0
  ```

* **设置数据**

  ```bash
  # 语法
  $ set /path /data
  ```

* **创建子项/子节点**

  ```bash
  # 语法
  $ create /parent/path/subnode/path /data
  ```

  举例

  ```
  [zk: localhost:2181(CONNECTED) 16] create /FirstZnode/Child1 “firstchildren"
  created /FirstZnode/Child1
  [zk: localhost:2181(CONNECTED) 17] create /FirstZnode/Child2 “secondchildren"
  created /FirstZnode/Child2
  ```

* **列出子项**

  ```bash
  # 语法
  $ ls /path
  ```

  举例

  ```
  [zk: localhost:2181(CONNECTED) 2] ls /MyFirstZnode
  [mysecondsubnode, myfirstsubnode]
  ```

* **检查状态**

  状态描述指定的znode的元数据。它包含时间戳，版本号，ACL，数据长度和子znode等细项。

  ```bash
  # 语法
  $ stat /path
  ```

  