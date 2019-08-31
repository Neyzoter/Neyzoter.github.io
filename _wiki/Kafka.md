---
layout: wiki
title: Kafka
categories: bigdata
description: Kafka学习笔记
keywords: Big data, Kafka, MQ
---

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
broker.id=1
log.dirs=/data/kafka/logs-1
```

**4.功能验证**

* 启动zookeeper

```bash
$ bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
```

* 启动kafka

```bash
$ bin/kafka-server-start.sh  config/server.properties
```

* 创建 topic

```bash
# 创建
$ bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
# 查看
$ bin/kafka-topics.sh --list --zookeeper localhost:2181
```

