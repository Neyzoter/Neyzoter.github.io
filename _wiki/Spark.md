---
layout: wiki
title: Spark
categories: Spark
description: Spark框架使用
keywords: Spark, Java, Big Data, Machine Learning
---

# 1、Spark介绍

## 1.1 链接

[Spark 编程指南](https://endymecy.gitbooks.io/spark-programming-guide-zh-cn/content/)

[Spark例程](http://spark.apache.org/examples.html)

## 1.2 介绍

Spark是个通用的集群计算框架，通过将大量数据集计算任务分配到多台计算机上，提供高效内存计算。如果你熟悉Hadoop，那么你知道分布式计算框架要解决两个问题：如何分发数据和如何分发计算。Hadoop使用HDFS来解决分布式数据问题，MapReduce计算范式提供有效的分布式计算。类似的，Spark拥有多种语言的函数式编程API，提供了除map和reduce之外更多的运算符，这些操作是通过一个称作弹性分布式数据集(resilient distributed datasets, RDDs)的分布式数据框架进行的。

**核心组建**

- **Spark Core**：包含Spark的基本功能；尤其是定义RDD的API、操作以及这两者上的动作。其他Spark的库都是构建在RDD和Spark Core之上的。
- **Spark SQL**：提供通过Apache Hive的SQL变体Hive查询语言（HiveQL）与Spark进行交互的API。每个数据库表被当做一个RDD，Spark SQL查询被转换为Spark操作。对熟悉Hive和HiveQL的人，Spark可以拿来就用。
- **Spark Streaming**：允许对实时数据流进行处理和控制。很多实时数据库（如Apache Store）可以处理实时数据。Spark Streaming允许程序能够像普通RDD一样处理实时数据。
- **MLlib**：一个常用机器学习算法库，算法被实现为对RDD的Spark操作。这个库包含可扩展的学习算法，比如分类、回归等需要对大量数据集进行迭代的操作。之前可选的大数据机器学习库Mahout，将会转到Spark，并在未来实现。
- **GraphX**：控制图、并行图操作和计算的一组算法和工具的集合。GraphX扩展了RDD API，包含控制图、创建子图、访问路径上所有顶点的操作。

# 2、Spark使用

## 2.1 基础

* 运行例子

  ```bash
  ./bin/run-example SparkPi 10
  ```

  

## 2.2 SQL

## 2.3 Spark Stream

## 2.4 MLib

## 2.5 GraphX



# 3、Spark技术

## 3.1 Checkpoint机制

Checkpoint 是用来容错的，当错误发生的时候，可以迅速恢复的一种机制。

在SparkContext中需要调用setCheckpointDir方法，设置一个容错的文件系统的目录，比如HDFS。然后对RDD调用checkpoint方法，之后在RDD所处的job运行结束之后，会启动一个单独的job来将checkpoint过的RDD的数据写入之前设置的文件系统中。进行持久化操作。那么此时，即使在后面使用RDD的时候，他的持久化数据不小心丢失了，但是还是可以从它的checkpoint文件中读取出该数据，而无需重新计算。

## 3.2 弹性分布式数据集

RDD 是指能横跨集群所有节点进行并行计算的分区元素集合。RDDs 从 Hadoop 的文件系统中的一个文件中创建而来(或其他 Hadoop 支持的文件系统)，或者从一个已有的 Scala 集合转换得到。用户可以要求 Spark 将 RDD *持久化(persist)*到内存中，来让它在并行计算中高效地重用。最后，RDDs 能在节点失败中自动地恢复过来。

## 3.3 共享变量

共享变量能被运行在并行计算中。默认情况下，当 Spark 运行一个并行函数时，这个并行函数会作为一个任务集在不同的节点上运行，它会把函数里使用的每个变量都复制搬运到每个任务中。有时，一个变量需要被共享到交叉任务中或驱动程序和任务之间。