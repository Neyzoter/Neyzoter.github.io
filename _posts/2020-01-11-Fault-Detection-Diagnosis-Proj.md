---
layout: post
title: 故障诊断平台设计与实现
categories: Proj
description: 项目难点笔记（用于制动器整车测试的无线物联系统）
keywords: 大数据, 故障检测, 故障诊断, 分布式
---

> 原创
>
> 未完待续

# 1.项目介绍

设计一个故障诊断平台，可以实时分析数据采集设备的北向数据，实现故障诊断功能。

# 2.项目难点

## 2.1 降低模型加载的IO瓶颈

### 2.1.1 问题描述

1. 接入车辆多，无法每个服务器都加载所有的类型的车辆模型，也没有必要
2. IO速度慢，模型加载时间长（模型加载时间达到1.5秒左右，计算一次的时间也只有300ms左右）

### 2.1.2 解决方案

1. 服务器动态加载模型，创建一个模型管理Hash表，来存储ModelManager
2. 每个模型都有一个存活时间（每次使用都要清零），到达最大存活时间则清除
3. 使用可调度线程池来进行周期性运行存活时间更新和Check是否超时
4. Spark在每次Hash表更改后，由Spark集群的master将Hash表broadcast到所有机器上
5. Kafka在接受到设备的数据请求后，根据车辆ID均匀分配到不同的partition，而在Kafka中每个partition都会固定分给一个消费者处理，所以不会出现不同的消费者频繁加载模型的情况

## 2.2 消息中间件调研

1. Kafka吞吐量更大，RocketMQ居中，RabbitMQ最差。

   [Kafka、RabbitMQ、RocketMQ消息中间件的对比 —— 消息发送性能](http://jm.taobao.org/2016/04/01/kafka-vs-rabbitmq-vs-rocketmq-message-send-performance/?utm_source=tuicool&utm_medium=referral)

2. Kafka社区活跃度高，针对Spark、Flink等有案例

## 2.3 JVM如何配置

### 2.3.1 GC配置

本项目要求较高的吞吐量和响应速度，这两者是有一定的矛盾的。从两种垃圾收集器种类来看（暂且不考虑串行垃圾收集器），并发（Concurrent）垃圾收集器是指垃圾收集线程和应用同时工作的收集器，适用于对响应速度有较高要求的场景，典型的如CMS（Concurrent Mark Sweep）垃圾收集器；并行垃圾收集器是指垃圾收集线程会暂停应用执行，并通过多线程合作实现并行垃圾回收的收集器，适用于对吞吐量有较高要求的场景，典型的如Parallel Scavenges（JVM默认，用于新生代）、Parallel Old（JVM默认，用于老年代）。

## 2.4 提高数据处理和TF模型计算速度

### 2.4.1 问题描述

1. 数据量大，需要提高计算效率

### 2.4.2 解决方案

1. Spark并行处理

   ```scala
   sc.parallelize(value).reduce(func)
   ```

2. 

## 2.X 性能评估

### 2.X.1 机器学习模型的评估



### 2.X.2 接口性能

使用JMeter进行性能测试

* **测试吞吐量**

  发送数据时，可以选择是否获取最近的诊断结果。

* **测试响应时间**

### 2.X.3 数据生成与测试

使用Golang实现简单的数据读取，并转化为json格式，通过HTTP发送到服务器进行处理。项目地址为[netest](https://github.com/Neyzoter/cooker/tree/master/netest)。

# 3.项目小问题记录

## 3.1 配置问题

* 如何把Springboot应用打包成Spark可识别

  Spark不可识别`spring-boot-maven-plugin`打包的springboot项目结构，需要使用`maven-shade-plugin`

  ```xml
  <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-shade-plugin</artifactId>
      <version>2.3</version>
      <executions>
          <execution>
              <phase>package</phase>
              <goals>
                  <goal>shade</goal>
              </goals>
              <configuration>
                  <keepDependenciesWithProvidedScope>false</keepDependenciesWithProvidedScope>
                  <createDependencyReducedPom>false</createDependencyReducedPom>
                  <filters>
                      <filter>
                          <artifact>*:*</artifact>
                          <excludes>
                              <exclude>META-INF/*.SF</exclude>
                              <exclude>META-INF/*.DSA</exclude>
                              <exclude>META-INF/*.RSA</exclude>
                          </excludes>
                      </filter>
                  </filters>
                  <transformers>
                      <transformer
                                   implementation="org.apache.maven.plugins.shade.resource.AppendingTransformer">
                          <resource>META-INF/spring.handlers</resource>
                      </transformer>
                      <transformer
                                   implementation="org.springframework.boot.maven.PropertiesMergingResourceTransformer">
                          <resource>META-INF/spring.factories</resource>
                      </transformer>
                      <transformer
                                   implementation="org.apache.maven.plugins.shade.resource.AppendingTransformer">
                          <resource>META-INF/spring.schemas</resource>
                      </transformer>
                      <transformer
                                   implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer"/>
                      <transformer
                                   implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                          <mainClass>cn.neyzoter.aiot.fddp.FddpApplication</mainClass>
                      </transformer>
                  </transformers>
              </configuration>
          </execution>
      </executions>
  </plugin>
  ```

* Spark的Scala版本2.11和2.12不兼容

  如果下载的Spark安装包使用的是Scala2.11，而应用的maven包中配置了Spark的Scala是2.12，则会找不到对应的Scala包。

