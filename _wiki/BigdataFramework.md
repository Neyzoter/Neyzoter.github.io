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

<img src="/images/wiki/BigdataFramework/architecture.png" width="500" alt="hadoop框架" />

* HDFS: 分布式文件存储——提供对应用程序数据的高吞吐量访问
* YARN: 分布式资源管理——用于作业调度和集群资源管理的框架
* MapReduce: 分布式计算——基于YARN的用于并行处理大数据集的系统
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
<img src="/images/wiki/BigdataFramework/yarn.jpg" width="500" alt="yarn框架" />

<img src="/images/wiki/BigdataFramework/yarn-block.jpg" width="500" alt="yarn的方框图" />
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

<img src="/images/wiki/BigdataFramework/mapreduce-pattern.png" width="500" alt="MapReduce模式" />

### 2.4.1 MapReduce读取数据
**流程**：通过InputFormat决定读取的数据的类型，然后拆分成一个个InputSplit（作用：代表一个个逻辑分片，并没有真正存储数据，只是提供了一个如何将数据分片的方法，包含分片数据的位置、split的大小等信息），每个InputSplit对应一个Map处理，RecordReader（作用：将InputSplit拆分成一个个<key,value>对给Map处理，也是实际的文件读取分隔对象</key,value>）读取InputSplit的内容给Map

**InputFormat功能**

1.验证作业输入的正确性，如格式等

2.将输入文件切割成逻辑分片(InputSplit)，一个InputSplit将会被分配给一个独立的Map任务

3.提供RecordReader实现，读取InputSplit中的"K-V对"供Mapper使用

**类结构**

<img src="/images/wiki/BigdataFramework/mapreduce-inputformat.png" width="700" alt="MapReduce的输入格式类结构" />

*List getSplits()*：获取由输入文件计算出输入分片(InputSplit)，解决数据或文件分割成片问题

*RecordReader <k,v>createRecordReader()*：</k,v> 创建RecordReader，从InputSplit中读取数据，解决读取分片中数据问题

**数据类型**

1.TextInputFormat: 输入文件中的每一行就是一个记录，Key是这一行的byte offset，而value是这一行的内容

2.KeyValueTextInputFormat: 输入文件中每一行就是一个记录，第一个分隔符字符切分每行。在分隔符字符之前的内容为Key，在之后的为Value。分隔符变量通过key.value.separator.in.input.line变量设置，默认为(\t)字符。

3.NLineInputFormat: 与TextInputFormat一样，但每个数据块必须保证有且只有Ｎ行，mapred.line.input.format.linespermap属性，默认为１

4.SequenceFileInputFormat: 一个用来读取字符流数据的InputFormat，<key,value>为用户自定义的。字符流数据是Hadoop自定义的压缩的二进制数据格式。它用来优化从一个MapReduce任务的输出到另一个MapReduce任务的输入之间的数据传输过程。</key,value>

**问题**

1.*大量小文件如何处理？*

CombineFileInputFormat可以将若干个Split打包成一个，目的是避免过多的Map任务

2.*怎么计算split的？*

* 分割方法

（1）通常一个split就是一个block（FileInputFormat仅仅拆分比block大的文件）

这样做的好处是使得Map可以在存储有当前数据的节点上运行本地的任务，而不需要通过网络进行跨节点的任务调度
 
（2）通过mapred.min.split.size， mapred.max.split.size, block.size来控制拆分的大小

如果mapred.min.split.size大于block size，则会将两个block合成到一个split，这样有部分block数据需要通过网络读取

如果mapred.max.split.size小于block size，则会将一个block拆成多个split，增加了Map任务数（Map对split进行计算且上报结果，关闭当前计算打开新的split均需要耗费资源）

* 具体流程

先获取文件在HDFS上的路径和Block信息，然后根据splitSize对文件进行切分（ splitSize = computeSplitSize(blockSize, minSize, maxSize) ），默认splitSize 就等于blockSize的默认值（64m）

3.*分片间的数据如何处理？*

split是根据文件大小分割的，而一般处理是根据分隔符进行分割的，这样势必存在一条记录横跨两个split。

<img src="/images/wiki/BigdataFramework/mapreduce-split.png" width="700" alt="MapReduce的文件分割" />

**解决办法**是只要不是第一个split，都会远程读取一条记录，作为最后一个数据，并忽略到第一条记录

### 2.4.2 MapReduce Mapper
主要是读取InputSplit的每一个Key,Value对并进行处理

```python
public class Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    /**
     * 预处理，仅在map task启动时运行一次
     */
    protected void setup(Context context) throws  IOException, InterruptedException {
    }

    /**
     * 对于InputSplit中的每一对<key, value>都会运行一次
     */
    @SuppressWarnings("unchecked")
    protected void map(KEYIN key, VALUEIN value, Context context) throws IOException, InterruptedException {
        context.write((KEYOUT) key, (VALUEOUT) value);
    }

    /**
     * 扫尾工作，比如关闭流等
     */
    protected void cleanup(Context context) throws IOException, InterruptedException {
    }

    /**
     * map task的驱动器
     */
    public void run(Context context) throws IOException, InterruptedException {
        setup(context);
        while (context.nextKeyValue()) {
            map(context.getCurrentKey(), context.getCurrentValue(), context);
        }
        cleanup(context);
    }
}

public class MapContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> extends TaskInputOutputContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    private RecordReader<KEYIN, VALUEIN> reader;
    private InputSplit split;

    /**
     * Get the input split for this map.
     */
    public InputSplit getInputSplit() {
        return split;
    }

    @Override
    public KEYIN getCurrentKey() throws IOException, InterruptedException {
        return reader.getCurrentKey();
    }

    @Override
    public VALUEIN getCurrentValue() throws IOException, InterruptedException {
        return reader.getCurrentValue();
    }

    @Override
    public boolean nextKeyValue() throws IOException, InterruptedException {
        return reader.nextKeyValue();
    }
}
```

### 2.4.3 MapReduce Shuffle
**作用**：对Map的结果进行排序并传输到Reduce进行处理。

Map的结果并不直接存放到硬盘,而是利用缓存做一些预排序处理。Map会调用Combiner，压缩，按key进行分区、排序等，尽量减少结果的大小。每个Map完成后都会通知Task，然后Reduce就可以进行处理。

<img src="/images/wiki/BigdataFramework/mapreduce-process.png" width="700" alt="MapReduce的数据处理过程" />

**Map端**

当Map程序开始产生结果的时候，并不是直接写到文件的，而是利用缓存做一些排序方面的预处理操作

每个Map任务都有一个循环内存缓冲区（默认100MB），当缓存的内容达到80%时，后台线程开始将内容写到文件，此时Map任务可以继续输出结果，但如果缓冲区满了，Map任务则需要等待

写文件使用round-robin方式。在写入文件之前，先将数据按照Reduce进行分区。对于每一个分区，都会在内存中根据key进行排序，如果配置了Combiner，则排序后执行Combiner（Combine之后可以减少写入文件和传输的数据）

每次结果达到缓冲区的阀值时，都会创建一个文件，在Map结束时，可能会产生大量的文件。在Map完成前，会将这些文件进行合并和排序。如果文件的数量超过3个，则并后会再次运行Combiner（1、2个文件就没有必要了）

如果配置了压缩，则最终写入的文件会先进行压缩，这样可以减少写入和传输的数据

一旦Map完成，则通知任务管理器，此时Reduce就可以开始复制结果数据

**Reduce端**

Map的结果文件都存放到运行Map任务的机器的本地硬盘中

如果Map的结果很少，则直接放到内存，否则写入文件中

同时后台线程将这些文件进行合并和排序到一个更大的文件中（如果文件是压缩的则需要先解压）

当所有的Map结果都被复制和合并后，就会调用Reduce方法

Reduce结果会写入到HDFS中

**调优**

一般的原则是给shuffle分配尽可能多的内存，但前提是要保证Map、Reduce任务有足够的内存

对于Map，主要就是避免把文件写入磁盘，例如使用Combiner，增大io.sort.mb的值

对于Reduce，主要是把Map的结果尽可能地保存到内存中，同样也是要避免把中间结果写入磁盘。默认情况下，所有的内存都是分配给Reduce方法的，如果Reduce方法不怎么消耗内存，可以mapred.inmem.merge.threshold设成0，mapred.job.reduce.input.buffer.percent设成1.0

在任务监控中可通过Spilled records counter来监控写入磁盘的数，但这个值是包括map和reduce的

对于IO方面，可以Map的结果可以使用压缩，同时增大buffer size（io.file.buffer.size，默认4kb）

<img src="/images/wiki/BigdataFramework/MapReduceSet.png" width="700" alt="MapReduce的处理设置" />

## 2.5 安装和使用
### 2.5.1 前期准备
* 

*单节点安装*

所有服务运行在一个JVM中，适合调试、单元测试

*伪集群*

所有服务运行在一台机器中，每个服务都在独立的JVM中，适合做简单、抽样测试

*多节点集群*

服务运行在不同的机器中，适合生产环境

配置公共帐号

方便主与从进行无密钥通信，主要是使用公钥/私钥机制 所有节点的帐号都一样 在主节点上执行 ssh-keygen -t rsa生成密钥对 复制公钥到每台目标节点中

* 版本说明

>Apache Hadoop 3.x now support only Java 8
Apache Hadoop from 2.7.x to 2.x support Java 7 and 8

[Hadoop Java Versions](https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions "Hadoop Java Versions")

* 必备Linux软件

ssl和rsync

```bash
$ sudo apt-get install ssh
$ sudo apt-get install rsync
```

* Hadoop下载

http://www.apache.org/dyn/closer.cgi/hadoop/common/

比如下载Hadoop3.1.2.tar.gz

* 解压hadoop

```bash
tar -zxvf hadoop文件名称.tar.gz
```

并移动到某一个目录下，如/opt

### 2.5.2 安装
1.添加路径

"/opt/hadoop-3.1.2/"可修改。

```bash
export HADOOP_HOME=/opt/hadoop-3.1.2/
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
```

使该路径生效

```bash
source ~/.bashrc
```

2.配置Hadoop(伪集群安装模式)

*其他安装模式*：[hadoop安装](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Prerequisites "hadoop安装")

*目录*：/etc/hadoop

*文件*：

(1)core-site.xml

```xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

(2)hdfs-site.xml

```xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
```

(3)hadoop-env.sh

export JAVA_HOME=/usr/lib/jvm/java-8-oracle

2.配置ssh

验证不需要ssh不需要密码

```bash
$ ssh localhost
```

如果以上不可以的话，进行

```bash
$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 0600 ~/.ssh/authorized_keys
```

### 2.5.3 测试
1.进入hadoop安装目录

这里以/opt/hadoop-3.1.2为例


```bash
cd /opt/hadoop-3.1.2
```

2.运行测试指令

(1)输出使用文档

```bash
$ bin/hadoop
```

(2)格式化文件系统

```bash
$ bin/hdfs namenode -format
```

(3)启动NameNode和DataNode守护进程

```bash
$ sbin/start-dfs.sh
```





