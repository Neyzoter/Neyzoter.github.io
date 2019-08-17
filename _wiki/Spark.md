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




