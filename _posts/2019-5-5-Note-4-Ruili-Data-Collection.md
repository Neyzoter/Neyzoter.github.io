---
layout: post
title: 用于制动器整车测试的无线物联系统
categories: Proj
description: 项目难点笔记（用于制动器整车测试的无线物联系统）
keywords: IoT, 后端, 嵌入式
---

> 原创
>
> 转载请注明出处，侵权必究

# 1、项目介绍

基于wifi通信协议的无线传感节点采集汽车的CAN和ADC数据，发送到局域网内的上位机和远程的私有云服务器。可以在上位机上实时查看数据的波形图，还可以通过拉取私有云服务器的数据库内的数据，进行远程数据查看。进而为远程调试汽车制动器参数提供

# 2、后端难点

## 2.1 TCP拆包和组包的问题

**服务器**

通过Netty自带的解码器，实现特定分隔符的拆包和组包。上位机发送命令和配置文件时，都要在末尾加上分隔符，比如`\t`。

**上位机**

1、关于接收数据库中的ADC和CAN数据

下发数据都存放在一个循环队列中。

根据ADC/CAN数据中的长度位来提取特定的数据（解决特定数据长度提取问题）；根据下发数据包的OVER指令来判断是否发送完毕（解决拆包和组包问题）。

2、关于接收数据库中的配置文件

根据下发数据包的OVER指令判断是否发送完毕（解决拆包和组包问题）。

## 2.2 数据库效率问题

### 2.2.1 测试名称查询速率过慢

**起始方案**

从所有数据中查询不同的实验名称，使用`mongodb`的`distinct`方法

问题：查询时间长

**改进方案**

查询数据库的配置文件集合(`config`)，每个实验都会对应一个配置文件。从该集合中获取信息就会达到较快的查询速率。

**进一步改进（提高ADC/CAN数据查询速度）**

*MongoDB**索引**可以提高文档的查询、更新、删除、排序操作，所以结合业务需求，适当创建索引。*

在ADC/CAN数据库初始化 `init`函数中加入创建单下降索引（配置文件数据库也可以添加改index），

```java
if(this.getIndexName().equals("")) {
				collection.createIndex(Indexes.descending(this.indexName), new SingleResultCallback<String>() {
					@Override
					public void onResult(String result, Throwable t) {
						logger.info(String.format("db.col create index by \"%s\"(indexName_-1)", result));
					}
				});
			}
```

## 2.3 周期运行一个线程

**起始方案**

使用`sleep`，线程包括`{打印5s的数据包个数 -> sleep 5s}`

**改进方案**

使用`ScheduledExecutorService`实现预定执行或者重复执行任务。`Executors`类的`newSingleThreadScheduledExecutor`和`newScheduledThreadPool`方法将返回实现了`ScheduledExecutorService`接口的对象。具体见《Java核心技术卷I》——`14.9.2 预定执行`。

```java
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

ScheduledExecutorService scheduledExecutorService =
                Executors.newSingleThreadScheduledExecutor();
    	scheduledExecutorService.scheduleAtFixedRate((TestTools)context.getBean("testTools"),
                5, 5, TimeUnit.SECONDS);
```

# 3、硬件难点

## 3.1 时钟同步

局域网内的始终同步，实现多节点的时钟同步，使得数据时间戳对其。

方案：使用UDP广播时钟信息，认为在数据传输过程中的延时相同。如果本次没有接收到也没有关系，因为认为延时相同，上一次接收的时间是有延时的，这一次别人接收到的也是有延时的，两者延时相同。只要主时钟的时间变化不大就行（一般来说漂移很小）。

最终实现了平均70+us，最大600+us的偏差。