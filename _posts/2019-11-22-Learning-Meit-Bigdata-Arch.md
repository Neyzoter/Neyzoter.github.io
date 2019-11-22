---
layout: post
title: 学习美团大数据平台框架
categories: AIA
description: 学习美团大数据平台框架
keywords: 大数据, 框架, Kafka, Flink
---

# 1.美团数据平台

下图是美团数据平台，右侧的是各组件依赖的基础服务，包括地理位置、元数据管理、唯一设备标识等。

<img src="/images/posts/2019-11-22-Learning-Meit-Bigdata-Arch/global_arch.png" width="700" alt="总体结构" />

- **数据源**

  Arachnia：采集服务端日志系统，支持各APP集成的客户端sdk，负责收集app客户端数据

  DataX：数据集成（导入导出）

  Mor：爬虫平台支持可配置的爬取公网数据的任务分发

- **数据存储**

  根据业务不同，选择不同的存储方案。

- **数据计算**

  离线计算：Hive&MR

  实时计算：Storm、Flink和美团自研的bitmap系统Naix（分布式位图计算）

- **数据开发**

  数据工坊、数据总线分发、任务调度

- **数据产品**

  A/B 实验平台、渠道推广跟踪平台、数据可视化平台、用户画像

# 2.数据架构流图

<img src="/images/posts/2019-11-22-Learning-Meit-Bigdata-Arch/dataflow_arch.png" width="700" alt="数据架构流图" />

lamda架构的数据架构流图，Arachnia和AppSDK分别将服务器端和客户端数据上报到代理服务collector，解析数据协议，并把数据写到Kafka，然后实时流会经过一层数据分发，最终业务消费Kafka数据进行实时计算。

离线会由 ETL（数据抽取Extract、数据转换Transform、数据装载Loading） 服务负责从 Kafka dump 数据到 HDFS，然后异构数据源（比如 MySQL、Hbase 等）主要基于 DataX 以及 Sqoop 进行数据的导入导出，最终通过 hive、kylin、spark 等计算把数据写入到各类的存储层，最后通过统一的对外 API 对接业务系统以及我们自己的可视化平台等。

# 参考

[美图大数据平台架构实践](https://segmentfault.com/a/1190000016106115)



