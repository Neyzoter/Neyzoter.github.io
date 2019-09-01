---
layout: wiki
title: Kafka
categories: bigdata
description: Kafka学习笔记
keywords: Big data, Kafka, MQ
---

> 摘自http://kafka.apachecn.org/

# 1、Kafka介绍

Kafka实现了生产者（收集信息）和消费者（分析信息）之间的无缝衔接，即不同的系统之间如何传递消息，是一种高产出的分布式消息系统（A high-throughput distributed messaging system）。

## 1.1 Kafka组件

<img src="/images/wiki/Kafka/kafka_conn.webp" width="700" alt="Kafka组件">

- topic：消息存放的目录即主题
- Producer：生产消息到topic的一方
- Consumer：订阅topic消费消息的一方
- Broker：Kafka的服务实例就是一个broker

Producer生产的消息通过网络发送给Kafka cluster，而Consumer从其中消费消息

**Topic 和Partition**

消息发送时都被发送到一个topic，其本质就是一个目录，而topic由是由一些Partition Logs(分区日志)组成

<img src="/images/wiki/Kafka/kafka-log-data-partitions.png" width="700" alt="topic结构">

## 1.2 安装

[参考](http://www.54tianzhisheng.cn/2018/01/04/Kafka/)

**1.前期准备**

[下载kafka](https://kafka.apache.org/downloads)

**2.解压**

```bash
$ tar -zxvf kafka_*.tgz
```

并移动到要安装目录。

**3.修改 kafka-server 的配置文件**

```bash
$ vim kafka_home/config/server.properties
```

修改

```
broker.id=1       # 刚开始是id = 0
log.dirs=/data/kafka/logs-1   # 刚开始log存放在/tmp中
```

**4.功能验证**

* 启动zookeeper

```bash
# 默认zookeeper的客户端网络端口为2181
# clientPort=2181
$ bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
```

* 启动kafka

```bash
# 默认连接zookeeper的端口为2181
# zookeeper.connect=localhost:2181
$ bin/kafka-server-start.sh  config/server.properties
```

* 创建 topic

```bash
# 创建
$ bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
# 查看
$ bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

* 产生消息

```bash
$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
```

输入要产生的消息。

* 消费消息

```bash
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```

打印消息。

* 查看topic信息

```bash
$ bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
```

```
Topic:test	PartitionCount:1	ReplicationFactor:1	Configs:
	Topic: test	Partition: 0	Leader: 1	Replicas: 1	Isr: 1
```

* 设置多代理集群

```bash
# 拷贝设置文件
$ cp config/server.properties config/server-1.properties
$ cp config/server.properties config/server-2.properties
```

然后修改属性文件

```
config/server-2.properties:
    broker.id=2
    listeners=PLAINTEXT://:9093
    log.dirs=/tmp/kafka-logs-2
 
config/server-3.properties:
    broker.id=3
    listeners=PLAINTEXT://:9094
    log.dirs=/tmp/kafka-logs-3
```

运行

```bash
$ bin/kafka-server-start.sh config/server-2.properties &
...
$ bin/kafka-server-start.sh config/server-3.properties &
...
```

创建**复制**因子为3的topic

```bash
$ bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 3 --partitions 1 --topic my-replicated-topic
```

查看信息

```bash
$ bin/kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic my-replicated-topic
```

```
Topic:my-replicated-topic	PartitionCount:1	ReplicationFactor:3	Configs:segment.bytes=1073741824
	Topic: my-replicated-topic	Partition: 0	Leader: 2	Replicas: 2,3,1	Isr: 2,3,1
```

> "leader" is the node responsible for all reads and writes for the given partition. Each node will be the leader for a randomly selected portion of the partitions.
> "replicas" is the list of nodes that replicate the log for this partition regardless of whether they are the leader or even if they are currently alive.
> "isr" is the set of "in-sync" replicas. This is the subset of the replicas list that is currently alive and caught-up to the leader.

*节点2是topic唯一的分区Leader*

验证（待验证，*发现PID一直变动*）

```bash
# 消息生成
$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-replicated-topic
...
# 消费消息
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic my-replicated-topic
...
# 容错验证
## 关闭Leader节点
$ ps aux | grep server-1.properties
$ sudo kill -9 [PID]

# 查看topic信息
$ bin/kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic my-replicated-topic
```

# 2.Kafka 技术

## 2.1 API

kafka的API包括Producer、Consumer、Streams、Connector、AdminClient。

<img src="/images/wiki/Kafka/kafka-apis.png" width="500" alt="kafka接口" />

Producer用于应用（Application）生成消息至topic；

Consumer用于应用订阅一个或者多个topic，并进行流数据处理；

Streams用于应用作为流数据处理器，处理来自topic的数据，处理后，输出到topic。

Connector用于构建和运行可重用生产者或者消费者，连接Kafka topic和应用，如连接了DB的connector会记录变化。

## 2.2 Topics和日志

Topic 就是数据主题，是数据记录发布的地方,可以用来区分业务系统。

<img src="/images/wiki/Kafka/log_anatomy.png" width="500" alt="Kafka topic" />

* Kafka 集群保留所有发布的记录—无论他们是否已被消费—并通过一个可配置的参数——保留期限来控制，如设置有效时间

* 每一个消费者中唯一保存的元数据是offset（偏移量）即消费在log中的位置.偏移量由消费者所控制:通常在读取记录后，消费者会以线性的方式增加偏移量，也可以以任意偏移量访问数据

  <img src="/images/wiki/Kafka/log_consumer.png" width="500" alt="Kafka offset" />

* partition的作用：第一，当日志大小超过了单台服务器的限制，允许日志进行扩展。每个单独的分区都必须受限于主机的文件限制，不过一个主题可能有多个分区，因此可以处理无限量的数据。第二，可以作为并行的单元集

## 2.3 分布式

日志的分区partition （分布）在Kafka集群的服务器上。每个服务器在处理数据和请求时，共享这些分区。每一个分区都会在已配置的服务器上进行备份，确保容错性.

每个分区都有一台 **server(broker) 作为 “leader”**，**零台或者多台server作为 follwers** 。leader server 处理一切对 partition （分区）的读写请求，而follwers只需被动的同步leader上的数据。当leader宕机了，followers 中的一台服务器会自动成为新的 leader。每台 server 都会成为某些分区的 leader 和某些分区的 follower，因此集群的负载是平衡的。

## 2.4 生产者

生产者可以将数据发布到所选择的topic（主题）中。生产者负责将记录分配到topic的哪一个 partition（分区）中。可以使用循环的方式来简单地实现负载均衡，也可以根据某些语义分区函数(例如：记录中的key)来完成。下面会介绍更多关于分区的使用。

## 2.5 消费者

消费者使用一个 *消费组* 名称来进行标识，发布到topic中的每条记录被分配给订阅消费组中的一个消费者实例.消费者实例可以分布在多个进程中或者多个机器上。

如果所有的消费者实例在同一消费组中，消息记录会负载平衡到每一个消费者实例.

如果所有的消费者实例在不同的消费组中，每条消息记录会广播到所有的消费者进程.

<img src="/images/wiki/Kafka/consumer-groups.png" width="500" alt="Kafka offset" />

如图，这个 Kafka 集群有两台 server 的，四个分区(p0-p3)和两个消费者组。消费组A有两个消费者，消费组B有四个消费者。

通常情况下，每个 topic 都会有一些消费组，一个消费组对应一个"逻辑订阅者"。一个消费组由许多消费者实例组成，便于扩展和容错。这就是发布和订阅的概念，只不过订阅者是一组消费者而不是单个的进程。

在Kafka中实现消费的方式是将日志中的分区划分到每一个消费者实例上，以便在任何时间，每个实例都是分区唯一的消费者。维护消费组中的消费关系由Kafka协议动态处理。如果新的实例加入组，他们将从组中其他成员处接管一些 partition 分区;如果一个实例消失，拥有的分区将被分发到剩余的实例。

Kafka 只保证分区内的记录是有序的，而不保证主题中不同分区的顺序。每个 partition 分区按照key值排序足以满足大多数应用程序的需求。但如果你需要总记录在所有记录的上面，可使用仅有一个分区的主题来实现，这意味着每个消费者组只有一个消费者进程。

## 2.6 保证

- 生产者发送到特定topic partition 的消息将按照发送的顺序处理。 也就是说，如果记录M1和记录M2由相同的生产者发送，并先发送M1记录，那么M1的偏移比M2小，并在日志中较早出现
- 一个消费者实例按照日志中的顺序查看记录.
- 对于具有N个副本的主题，我们最多容忍N-1个服务器故障，从而保证不会丢失任何提交到日志中的记录.

# 3.Kafka使用

