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

## 2.2 数据库具体问题

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

**进一步改进（返回doc中需要的信息，节省流量）**

MongoDB的映射（Projection）可以实现只返回我们需要的内容。以查询ADC/CAN数据为例，

```java
projections = new BasicDBObject();
//只返回裸数据，不需要_id
projections.append(DataProcessor.MONGODB_KEY_RAW_DATA, 1).append("_id", 0);
FindIterable<Document> docIter = mongodb.collection.find(filterDocs).projection(projections) ;
docIter.forEach(new Block<Document>() {
    @Override
    public void apply(final Document document) {//每个doc所做的操作
        try {
                                                                           ctx.write(Unpooled.copiedBuffer(TCP_ServerHandler4PC.MONGODB_FIND_DOCS+":",CharsetUtil.UTF_8));//加入抬头
            Binary rawDataBin = (Binary)document.get(DataProcessor.MONGODB_KEY_RAW_DATA); 
            byte[] rawDataByte = rawDataBin.getData();            TCP_ServerHandler4PC.writeFlushFuture(ctx,Unpooled.wrappedBuffer(rawDataByte));//发给上位机原始数据
        }catch(Exception e) {
            logger.error("",e);
        }						    	
    }}, new SingleResultCallback<Void>() {//所有操作完成后的工作 	
    @Override
    public void onResult(final Void result, final Throwable t) {
        TCP_ServerHandler4PC.writeFlushFuture(ctx,TCP_ServerHandler4PC.MONGODB_FIND_DOCS+
                                              TCP_ServerHandler4PC.SEG_CMD_DONE_SIGNAL+TCP_ServerHandler4PC.DONE_SIGNAL_OVER);        logger.debug(TCP_ServerHandler4PC.MONGODB_FIND_DOCS+TCP_ServerHandler4PC.SEG_CMD_DONE_SIGNAL+TCP_ServerHandler4PC.DONE_SIGNAL_OVER);
    }			    	
});
```



### 2.2.2 历史数据自动清空（该方案抛弃，不希望程序擅自删除数据）

**方案1**

使用MongoDB自带的TTL索引，指定文档的过期时间，索引必须为时间或者包含时间的字符串。

**方案2**

使用Linux的计划任务服务程序——`crontab`。

**方案3**

使用`quartz`库实现后台程序自动每天执行清空指令。

**方案4**

使用spring自带的定时任务实现周期性清空数据库，实现`linux`中类似`crontab`的功能（语法方面和`crontab`、`quartz`类似）。

**注意1：操作两个`collecions`时候，启动事务。但是MongoDB的事务只支持集群模式和分片模式。这边可以增加冗余措施，即判断返回的ClientSession是否是null（null说明不支持事务），则不启动事务（start和commit均不进行）**

**注意2：异步操作时，如果多个异步操作需要对同一个对象进行调用/操作，则需要已同步方式实现。比如异步操作1，需要使用a；异步操作2，会改变a；如果两者同时进行，则无法确定在操作1进行时，操作2是否已经改变了a。所以需要在操作1的onResult后再调用操作2**

**最终方案**

1.使用spring自带的定时任务实现周期性清空数据库（方案4）；

2.插入文档时，同时插入创建时间，周期性判断该时间来删除

### 2.2.3 数据库分集合存储

**目的**

提高数据查询速率，而不想删除历史数据。

**数据量计算**

注意：单个节点

`ADC：480bytes/pck,20pcks/s,1000SPS`

`CAN：480bytes/pck,6.25pcks/s(CAN : 1pck/10ms)`

`size：2270bytes/pcks`

一分钟：`1575pcks`

一小时：`94500pcks,204.6MB`

单个节点全速运行一个小时，需要`204.6MB`存储空间(`94500包,ADC每个通道数据数 = 94500*50 = 472500`)存储ADC/CAN数据。

**数据库结构**

1.配置文件存储集合

2.数据存储集合

该类集合以月为单位进行分离。

eg.

`2019-01`、`2019-02`、`2019-03`、`2019-04`

**操作对象**

建立三个`MongoClient`：

1.配置文件插入/查询对象`MongoClient1`

2.通用数据查询对象`MongoClient2`

该数据查询对象可以随时改变指向的集合。

3.当前月份数据集合数据插入对象`MongoClient3`

**工作流程**

1.测试开始

配置文件内包含本次实验所指向的集合名称`yyyy_MM`（可能会出现跨越月末凌晨的问题，从而使得数据到达下一个月的数据集合）

2.数据插入

从节点发送过来的数据插入到数据集合（`MongoClient3`集合指向更新时候发生在定时任务中，每个月凌晨0点）

`bean.xml`内定义了col后是可以改变的，在一个线程内修改`col`后，相应引用实例的对象都会相应改变。

**注意1**：每次初始化`DataProccessor`的时候，需要重新根据当前日期初始化连接的结合

**注意2**：`MongoClient3`集合指向更新时候发生在定时任务中，每个月凌晨0点。而且同时需要为该集合建立*索引*。

3.数据查询

3.1 查询配置文件数据库`config`，得到所有名称

3.2 指定测试名称，查询具体数据

服务器端首先根据测试名称拿到`config`集合中该测试指向的集合，从该集合中获取所有数据（下面一个月的也可以查询一下）

**另外**

对于[2.2.2](2.2.2 历史数据自动清空（该方案抛弃，不希望程序擅自删除数据）)，进行改进，分别进行两步操作：

1.每个月根据`insertIsodate`删除`config`内配置文件和数据集合内数据

`Mongodatabase`具有查询集合的方法，一个`foreach`即可根据filter（这里针对`insertIsodate`）删除

2.每天根据`config`集合中的`isodate`找到数据集合，删除数据集合，再删除配置文件

`config`文件中包含了数据对应的集合，如果数据跨越两个集合，则由第1个措施来删除。

## 2.3 数据库比较和选择

### 2.3.1 物联网数据特点

**特点**

1.**异构**——数据库需要进行异构数据解析或者直接存储（交给下面的上位机/边缘处理）

2.**时间序列**——数据库对时间序列有较好的支持

3.**海量**——数据库需要面对大量的数据

4.**关联**——数据库需要对不同维度的数据进行关联分析

描述同一个实体的数据在时间上具有关联性;描述不同实体的数据在空间上会有关联性;描述实体的不同维度之间也具有关联性。

5.**读多写少**——数据库**不需要**支持事务

物联网数据一般写入后，不需要再更改，只需要读取。

**数据类型**

1）RFID：射频识别

2）地址/唯一标识符

3）过程，系统和对象的描述性数据

4）普遍的环境数据和位置数据

5）传感器数据：多维时间序列数据

6）历史数据

7）物理模型：模型是现实的模板

8）用于控制的执行器和命令数据的状态

**数据库选型注意点**

1）尺寸，比例和索引

2）处理大量数据时的有效性

3）用户友好的模式

4）便携性

5）查询语言

6）流程建模和交易

7）异质性和一体化

8）时间序列聚合

9）存档

10）安全性和成本

### 2.3.2 数据库选择

|                | MySQL | MongoDB |
| -------------- | ----- | ------- |
| 丰富的数据模型 | 否    | 是      |
| 动态Schema     | 否    | 是      |
| 数据类型       | 是    | 是      |
| 数据本地化     | 否    | 是      |
| 字段更新       | 是    | 是      |
| 易于编程       | 否    | 是      |
| 复杂事务       | 是    | 否      |
| 审计           | 是    | 是      |
| 自动分片       | 否    | 是      |

 MongoDB最常见的用例包括单视图，物联网，移动，实时分析，个性化，目录和内容管理。

## 2.4 周期运行一个线程

**起始方案**

使用`sleep`，线程包括`{打印5s的数据包个数 -> sleep 5s}`

**改进方案1**

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

**改进方案2**

Spring自带有定时任务，实现`linux`中类似`crontab`的功能（语法方面和`crontab`、`quartz`类似）。

## 2.5 加密

**问题**

如何实现测试人员的安全登录？

**解决方案**

测试人员名称使用明文传输；

密码使用MD5加密后，结合服务器发送过来的随机码，再次进行MD5加密。

## 2.6 Netty数据发送方式

**问题**：

需要发送好多个`byte[]`，但是writeAndFlush不支持发送`byte[]`

**方案1**：

零拷贝方式`Unpooled.wrappedBuffer`

```java
public static ByteBuf wrappedBuffer(byte[] arrays)
```

**方案2**：

深度拷贝方式`Unpooled.copiedBuffer()`

```java
public static ByteBuf copiedBuffer(byte[] arrays)
```

方案1的零拷贝不需要从一个区域搬运到另外一个区域，速度根更快。

## 2.6 数据库异步和Netty发送问题

异步查询两个数据库（见上方数据库分集合存储），在全部查询完后，通过`flush`发送

**问题**

部分数据发送两遍，如

```
|---------------------------------------------|   接收到的数据1
       |--------------------------------------|   接收到的数据2
```

**分析**

异步操作，速度很快在第二个集合（第二个集合一般都是空的）结束查询后，第一个数据集合的`flush`过程还没有进行完，第二个马上触发，导致后面的数据发送两遍。

**解决方法**

方案1.放弃查询两个数据库

方案2.两个集合读出来的数据先分别放到两个Buffer中，然后通过零拷贝发送。

# 3、硬件难点

## 3.1 时钟同步

局域网内的始终同步，实现多节点的时钟同步，使得数据时间戳对其。

方案：使用UDP广播时钟信息，认为在数据传输过程中的延时相同。如果本次没有接收到也没有关系，因为认为延时相同，上一次接收的时间是有延时的，这一次别人接收到的也是有延时的，两者延时相同。只要主时钟的时间变化不大就行（一般来说漂移很小）。

最终实现了平均`70+us`，最大`600+us`的偏差。