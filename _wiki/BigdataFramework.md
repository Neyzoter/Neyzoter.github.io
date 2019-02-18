---
layout: wiki
title: 大数据框架
categories: Bigdata
description: 大数据框架笔记
keywords: Big Data; Hadoop; Spark
---

# 1、介绍
本笔记包含大数据框架——hadoop、spark等。

# 2、Hadoop
## 2.1 介绍
**目的**

提高处理速度。

**方法**

把数据分到多块硬盘，然后同时读取。代码向数据迁移，避免大规模数据时，造成大量数据迁移的情况，尽量让一段数据的计算发生在同一台机器上。

**关键技术**

1.数据分布在多台机器

可靠性：每个数据块都复制到多个节点

性能：多个节点同时处理数据

2.计算随数据走

网络IO速度 << 本地磁盘IO速度，大数据系统会尽量地将任务分配到离数据最近的机器上运行（程序运行时，将程序及其依赖包都复制到数据所在的机器运行）

代码向数据迁移，避免大规模数据时，造成大量数据迁移的情况，尽量让一段数据的计算发生在同一台机器上

3.串行IO取代随机IO

传输时间 << 寻道时间，一般数据写入后不再修改

**适合场景**

大规模数据

流式数据（写一次，读多次）

商用硬件（一般硬件）

**不适合场景**

低延时的数据访问

大量的小文件

频繁修改文件（基本就是写1次）

**hadoop框架**

<img src="/images/wiki/BigdataFramework/architecture.png" width="700" alt="hadoop框架" />

* HDFS: 分布式文件存储
* YARN: 分布式资源管理
* MapReduce: 分布式计算
* Others: 利用YARN的资源管理功能实现其他的数据处理方式

## 2.2 HDFS
Hadoop Distributed File System，分布式文件系统

<img src="/images/wiki/BigdataFramework/hdfs-architecture.png" width="700" alt="hdfs框架" />

### 2.2.1 Block数据（黄色）

基本存储单位，一般大小为64M配置大的块主要是因为：（1）减少搜寻时间，一般硬盘传输速率比寻道时间要快，大的块可以减少寻道时间；2）减少管理块的数据开销，每个块都需要在NameNode上有对应的记录；3）对数据块进行读写，减少建立网络的连接成本）

一个大文件会被拆分成一个个的块，然后存储于不同的机器。如果一个文件少于Block大小，那么实际占用的空间为其文件的大小

基本的读写位，类似于磁盘的页，每次都是读写一个块

每个块都会被复制到多台机器，默认复制3份

### 2.2.2 NameNode

1、存储文件的metadata，运行时所有数据都保存到内存，整个HDFS可存储的文件数受限于NameNode的内存大小

2、一个Block在NameNode中对应一条记录（一般一个block占用150字节），如果是大量的小文件，会消耗大量内存。同时map task的数量是由splits来决定的，所以用MapReduce处理大量的小文件时，就会产生过多的map task，线程管理开销将会增加作业时间。处理大量小文件的速度远远小于处理同等大小的大文件的速度。因此Hadoop建议存储大文件

3、数据会定时保存到本地磁盘，但不保存block的位置信息，而是由DataNode注册时上报和运行时维护（NameNode中与DataNode相关的信息并不保存到NameNode的文件系统中，而是NameNode每次重启后，动态重建）

4、NameNode失效则整个HDFS都失效了，所以要保证NameNode的可用性

### 2.2.3 Secondary NameNode

定时与NameNode进行同步（定期合并文件系统镜像和编辑日&#x#x5FD7;，然后把合并后的传给NameNode，替换其镜像，并清空编辑日志，类似于CheckPoint机制），但NameNode失效后仍需要手工将其设置成主机

### 2.2.4 DataNode

1、保存具体的block数据

2、负责数据的读写操作和复制操作

3、DataNode启动时会向NameNode报告当前存储的数据块信息，后续也会定时报告修改信息

4、DataNode之间会进行通信，复制数据块，保证数据的冗余性

## 2.3 YARN
<img src="/images/wiki/BigdataFramework/yarn.jpg" width="700" alt="yarn框架" />

<img src="/images/wiki/BigdataFramework/yarn-block.jpg" width="700" alt="yarn的方框图" />
### 2.3.1 组件
* ResourceManager

全局资源管理和任务调度——提供了计算资源的分配和管理

* NodeManager

单个节点的资源管理和监控——提供了计算资源的分配和管理

* ApplicationMaster

单个作业的资源管理和任务监控——完成应用程序的运行

* Container

资源申请的单位和任务运行的容器

### 2.3.2 yarn处理流程

<img src="/images/wiki/BigdataFramework/yarn-processing.jpg" width="700" alt="yarn处理流程" />

**1. Job submission**

从ResourceManager中获取一个Application ID检查作业输出配置，计算输入分片拷贝作业资源（job jar、配置文件、分片信息）到HDFS，以便后面任务的执行

**2. Job initialization**

ResourceManager将作业递交给Scheduler（有很多调度算法，一般是根据优先级）Scheduler为作业分配一个Container，ResourceManager就加载一个application master process并交给NodeManager管理ApplicationMaster主要是创建一系列的监控进程来跟踪作业的进度，同时获取输入分片，为每一个分片创建一个Map task和相应的reduce task Application Master还决定如何运行作业，如果作业很小（可配置），则直接在同一个JVM下运行

**3. Task assignment**

ApplicationMaster向Resource Manager申请资源（一个个的Container，指定任务分配的资源要求）一般是根据data locality来分配资源

**4. Task execution**

ApplicationMaster根据ResourceManager的分配情况，在对应的NodeManager中启动Container 从HDFS读取任务所需资源（job jar，配置文件等），然后执行该任务

**5. Progress and status update**

定时将任务的进度和状态报告给ApplicationMaster Client定时向ApplicationMaster获取整个任务的进度和状态

**6. Job completion**

Client定时检查整个作业是否完成 作业完成后，会清空临时文件、目录等

## 2.4 MapReduce
一种分布式的计算方式指定一个Map（映射）函数，用来把一组键值对映射成一组新的键值对，指定并发的Reduce（归约）函数，用来保证所有映射的键值对中的每一个共享相同的键组。

<img src="/images/wiki/BigdataFramework/mapreduce-pattern.png" width="700" alt="MapReduce模式" />
trend_coef  trend_intercept  abs_trend_coef  abs_trend_intercept