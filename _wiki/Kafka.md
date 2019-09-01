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

## 2.1 介绍

### 2.1.1 API

kafka的API包括Producer、Consumer、Streams、Connector、AdminClient。

<img src="/images/wiki/Kafka/kafka-apis.png" width="500" alt="kafka接口" />

Producer用于应用（Application）生成消息至topic；

Consumer用于应用订阅一个或者多个topic，并进行流数据处理；

Streams用于应用作为流数据处理器，处理来自topic的数据，处理后，输出到topic。

Connector用于构建和运行可重用生产者或者消费者，连接Kafka topic和应用，如连接了DB的connector会记录变化。

### 2.1.2 Topics和日志

Topic 就是数据主题，是数据记录发布的地方,可以用来区分业务系统。

<img src="/images/wiki/Kafka/log_anatomy.png" width="500" alt="Kafka topic" />

* Kafka 集群保留所有发布的记录—无论他们是否已被消费—并通过一个可配置的参数——保留期限来控制，如设置有效时间

* 每一个消费者中唯一保存的元数据是offset（偏移量）即消费在log中的位置.偏移量由消费者所控制:通常在读取记录后，消费者会以线性的方式增加偏移量，也可以以任意偏移量访问数据

  <img src="/images/wiki/Kafka/log_consumer.png" width="500" alt="Kafka offset" />

* partition的作用：第一，当日志大小超过了单台服务器的限制，允许日志进行扩展。每个单独的分区都必须受限于主机的文件限制，不过一个主题可能有多个分区，因此可以处理无限量的数据。第二，可以作为并行的单元集

### 2.1.3 分布式

日志的分区partition （分布）在Kafka集群的服务器上。每个服务器在处理数据和请求时，共享这些分区。每一个分区都会在已配置的服务器上进行备份，确保容错性.

每个分区都有一台 **server(broker) 作为 “leader”**，**零台或者多台server作为 follwers** 。leader server 处理一切对 partition （分区）的读写请求，而follwers只需被动的同步leader上的数据。当leader宕机了，followers 中的一台服务器会自动成为新的 leader。每台 server 都会成为某些分区的 leader 和某些分区的 follower，因此集群的负载是平衡的。

### 2.1.4 生产者

生产者可以将数据发布到所选择的topic（主题）中。生产者负责将记录分配到topic的哪一个 partition（分区）中。可以使用循环的方式来简单地实现负载均衡，也可以根据某些语义分区函数(例如：记录中的key)来完成。下面会介绍更多关于分区的使用。

### 2.1.5 消费者

消费者使用一个 *消费组* 名称来进行标识，发布到topic中的每条记录被分配给订阅消费组中的一个消费者实例.消费者实例可以分布在多个进程中或者多个机器上。

如果所有的消费者实例在同一消费组中，消息记录会负载平衡到每一个消费者实例.

如果所有的消费者实例在不同的消费组中，每条消息记录会广播到所有的消费者进程.

<img src="/images/wiki/Kafka/consumer-groups.png" width="500" alt="Kafka offset" />

如图，这个 Kafka 集群有两台 server 的，四个分区(p0-p3)和两个消费者组。消费组A有两个消费者，消费组B有四个消费者。

通常情况下，每个 topic 都会有一些消费组，一个消费组对应一个"逻辑订阅者"。一个消费组由许多消费者实例组成，便于扩展和容错。这就是发布和订阅的概念，只不过订阅者是一组消费者而不是单个的进程。

在Kafka中实现消费的方式是将日志中的分区划分到每一个消费者实例上，以便在任何时间，每个实例都是分区唯一的消费者。维护消费组中的消费关系由Kafka协议动态处理。如果新的实例加入组，他们将从组中其他成员处接管一些 partition 分区;如果一个实例消失，拥有的分区将被分发到剩余的实例。

Kafka 只保证分区内的记录是有序的，而不保证主题中不同分区的顺序。每个 partition 分区按照key值排序足以满足大多数应用程序的需求。但如果你需要总记录在所有记录的上面，可使用仅有一个分区的主题来实现，这意味着每个消费者组只有一个消费者进程。

### 2.1.6 保证

- 生产者发送到特定topic partition 的消息将按照发送的顺序处理。 也就是说，如果记录M1和记录M2由相同的生产者发送，并先发送M1记录，那么M1的偏移比M2小，并在日志中较早出现
- 一个消费者实例按照日志中的顺序查看记录.
- 对于具有N个副本的主题，我们最多容忍N-1个服务器故障，从而保证不会丢失任何提交到日志中的记录.

### 2.1.7 Kafka作为消息系统

传统的消息系统有两个模块: 队列 和 发布-订阅。 在队列中，消费者池从server读取数据，每条记录被池子中的一个消费者消费; 在发布订阅中，记录被广播到所有的消费者。两者均有优缺点。 队列的优点在于它允许你将处理数据的过程分给多个消费者实例，使你可以扩展处理过程（理解：一个处理，给多个消费者使用）。 不好的是，队列不是多订阅者模式的—一旦一个进程读取了数据，数据就会被丢弃。 而发布-订阅系统允许你广播数据到多个进程，但是无法进行扩展处理，因为每条消息都会发送给所有的订阅者。

消费组在Kafka有两层概念。在队列中，消费组允许你将处理过程分发给一系列进程(消费组中的成员)，**起到了拓展处理功能**。 在发布订阅中，Kafka允许你将消息广播给多个消费组。

Kafka的优势在于每个topic都有以下特性—**可以扩展处理并且允许多订阅者模式**（通过消息组实现，见上方解释）—不需要只选择其中一个.

Kafka相比于传统消息队列还具有更严格的顺序保证

传统队列在服务器上保存有序的记录，如果多个消费者消费队列中的数据， 服务器将按照存储顺序输出记录。 虽然服务器按顺序输出记录，但是记录被异步传递给消费者， 因此记录可能会无序的到达不同的消费者。这意味着在并行消耗的情况下， 记录的顺序是丢失的。因此消息系统通常使用“唯一消费者”的概念，即只让一个进程从队列中消费， 但这就意味着不能够并行地处理数据。

Kafka 设计的更好。topic中的partition是一个并行的概念。 Kafka能够为一个消费者池提供顺序保证和负载平衡，是通过将topic中的partition分配给消费者组中的消费者来实现的， 以便每个分区由消费组中的一个消费者消耗。通过这样，我们能够确保消费者是该分区的唯一读者，并按顺序消费数据。 众多分区保证了多个消费者实例间的负载均衡。但请注意，消费者组中的消费者实例个数不能超过分区的数量。

### 2.1.8 Kafka作为存储系统

许多消息队列可以发布消息，除了消费消息之外还可以充当中间数据的存储系统。那么Kafka作为一个优秀的存储系统有什么不同呢?

数据写入Kafka后被写到磁盘，并且进行备份以便容错。直到完全备份，Kafka才让生产者认为完成写入，即使写入失败Kafka也会确保继续写入

Kafka使用磁盘结构，具有很好的扩展性—50kb和50TB的数据在server上表现一致。

可以存储大量数据，并且可通过客户端控制它读取数据的位置，您可认为Kafka是一种高性能、低延迟、具备日志存储、备份和传播功能的分布式文件系统。

### 2.1.9 Kafka做流处理

Kafka 流处理不仅仅用来读写和存储流式数据，它最终的目的是为了能够进行实时的流处理。

在Kafka中，**流处理器不断地从输入的topic获取流数据，处理数据后，再不断生产流数据到输出的topic中去**。

例如，零售应用程序可能会接收销售和出货的输入流，经过价格调整计算后，再输出一串流式数据。

简单的数据处理可以直接用生产者和消费者的API。对于复杂的数据变换，Kafka提供了Streams API。 Stream API 允许应用做一些复杂的处理，比如将流数据聚合或者join。

这一功能有助于解决以下这种应用程序所面临的问题：处理无序数据，当消费端代码变更后重新处理输入，执行有状态计算等。

Streams API建立在Kafka的核心之上：它使用Producer和Consumer API作为输入，使用Kafka进行有状态的存储， 并在流处理器实例之间使用相同的消费组机制来实现容错。

### 2.1.10 Kafka做批处理

Kafka结合了像HDFS这样的分布式文件系统可以存储用于批处理的静态文件、传统的企业消息系统允许处理订阅后到达的数据

## 2.2 使用案例

### 2.2.1 消息

Kafka 很好地替代了传统的message broker（消息代理）。 Message brokers 可用于各种场合（如将数据生成器与数据处理解耦，缓冲未处理的消息等）。 与大多数消息系统相比，Kafka拥有更好的吞吐量、内置分区、具有复制和容错的功能，这使它成为一个非常理想的大型消息处理应用。

### 2.2.2 跟踪网站活动

Kafka 的初始用例是将用户活动跟踪管道重建为一组实时发布-订阅源。 这意味着网站活动（浏览网页、搜索或其他的用户操作）将被发布到中心topic，其中每个活动类型有一个topic。 这些订阅源提供一系列用例，包括实时处理、实时监视、对加载到Hadoop或离线数据仓库系统的数据进行离线处理和报告等。

每个用户浏览网页时都生成了许多活动信息，因此活动跟踪的数据量通常非常大。

### 2.2.3 度量

Kafka 通常用于监控数据。这涉及到从分布式应用程序中汇总数据，然后生成可操作的集中数据源。

### 2.2.4 日志聚合

许多人使用Kafka来替代日志聚合解决方案。 日志聚合系统通常从服务器收集物理日志文件，并将其置于一个中心系统（可能是文件服务器或HDFS）进行处理。 Kafka 从这些日志文件中提取信息，并将其抽象为一个更加清晰的消息流。 这样可以实现更低的延迟处理且易于支持多个数据源及分布式数据的消耗。 与Scribe或Flume等以日志为中心的系统相比，Kafka具备同样出色的性能、更强的耐用性（因为复制功能）和更低的端到端延迟。

### 2.2.5 流处理

许多Kafka用户通过管道来处理数据，有多个阶段： 从Kafka topic中消费原始输入数据，然后聚合，修饰或通过其他方式转化为新的topic， 以供进一步消费或处理。 例如，一个推荐新闻文章的处理管道可以从RSS订阅源抓取文章内容并将其发布到“文章”topic; 然后对这个内容进行标准化或者重复的内容， 并将处理完的文章内容发布到新的topic; 最终它会尝试将这些内容推荐给用户。 这种处理管道基于各个topic创建实时数据流图。

### 2.2.6 采集日志

[Event sourcing](http://martinfowler.com/eaaDev/EventSourcing.html)是一种应用程序设计风格，按时间来记录状态的更改。 Kafka 可以存储非常多的日志数据，为基于 event sourcing 的应用程序提供强有力的支持。

### 2.2.7 提交日志

Kafka 可以从外部为分布式系统提供日志提交功能。 日志有助于记录节点和行为间的数据，采用重新同步机制可以从失败节点恢复数据。 Kafka的[日志压缩](http://kafka.apachecn.org/documentation.html#compaction) 功能支持这一用法。 这一点与[Apache BookKeeper](http://zookeeper.apache.org/bookkeeper/) 项目类似。

## 2.3 APIS

Producer用于应用（Application）生成消息至topic；

Consumer用于应用订阅一个或者多个topic，并进行流数据处理；

Streams用于应用作为流数据处理器，处理来自topic的数据，处理后，输出到topic。

Connector用于构建和运行可重用生产者或者消费者，连接Kafka topic和应用，如连接了DB的connector会记录变化。

AdminClient用于管理和检查topics、brokers和其他的Kafka对象。

### 2.3.1 Producer API

```xml
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-clients</artifactId>
    <version>1.0.0</version>
</dependency>
```

使用实例：[地址](http://kafka.apachecn.org/10/javadoc/index.html?org/apache/kafka/clients/producer/KafkaProducer.html)

```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("acks", "all");
props.put("retries", 0);
props.put("batch.size", 16384);
props.put("linger.ms", 1);
props.put("buffer.memory", 33554432);
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

Producer<String, String> producer = new KafkaProducer<>(props);
for (int i = 0; i < 100; i++)
    producer.send(new ProducerRecord<String, String>("my-topic", Integer.toString(i), Integer.toString(i)));

producer.close();
```

### 2.3.2 Consumer API

```xml
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-clients</artifactId>
    <version>1.0.0</version>
</dependency>
```

使用实例：[地址](http://kafka.apachecn.org/10/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html)

```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("group.id", "test");
props.put("enable.auto.commit", "true");
props.put("auto.commit.interval.ms", "1000");
props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
consumer.subscribe(Arrays.asList("foo", "bar"));
while (true) {
    ConsumerRecords<String, String> records = consumer.poll(100);
    for (ConsumerRecord<String, String> record : records)
        System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
}
```



### 2.3.3 Streams API



### 2.3.4 Connect API



### 2.3.5 AdminClient API



# 3.Kafka使用

