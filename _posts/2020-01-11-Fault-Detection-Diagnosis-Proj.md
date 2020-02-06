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

1. 服务器动态加载模型，创建一个模型管理Hash表
2. 每个模型都有一个存活时间（从最新接收到数据开始计时）
3. 创建一个类（包含一个线程），定时管理每个模型
4. Kafka在接受到设备的数据请求后，根据车辆ID均匀分配到不同的partition，而在Kafka中每个partition都会固定分给一个消费者处理，所以不会出现不同的消费者频繁加载模型的情况

## 2.2 消息中间件调研

1. Kafka吞吐量更大，RocketMQ居中，RabbitMQ最差。

   [Kafka、RabbitMQ、RocketMQ消息中间件的对比 —— 消息发送性能](http://jm.taobao.org/2016/04/01/kafka-vs-rabbitmq-vs-rocketmq-message-send-performance/?utm_source=tuicool&utm_medium=referral)

2. Kafka社区活跃度高，针对Spark、Flink等有案例