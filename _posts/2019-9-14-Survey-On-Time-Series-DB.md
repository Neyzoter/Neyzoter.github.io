---
layout: post
title: 时间序列数据库
categories: IoT
description: 时间序列数据库调研
keywords: IoT, database, 时间序列数据库
---

> 原创
>

# 1.时间序列数据库介绍

典型的时间序列数据库由两个维度坐标表示，横坐标表示时间，纵坐标由数据源（datasource）和metric组成。

<img src="/images/posts/2019-9-14-Survey-On-Time-Series-DB/tsdb.jpg" width="700" alt="典型时间序列数据" />

数据源由publisher、advertiser、gender和country四个维度（标签，tags）值唯一表示，metric表示收集的数据源指标。**一个时间序列点point由datasource（tags）+metric+timestamp唯一确定。**

以下几个典型的时间序列数据库介绍。

# 2.OpenTSDB（HBase）

OpenTSDB基于HBase，RowKey规则为：metric+timestamp+datasource（tags）。HBase是一个KV数据库，其中键K为metric+timestamp+datasource（tags），而值V为时间序列点point数值。

**如何确定rowkey的顺序?**

*首位*：metric，希望同一指标数据集中放在一起。如果timestamp放在首位，同一时刻的不同数据写入同一个数据分片，无法起到散列的效果（难以通过哈希值搜索？）。