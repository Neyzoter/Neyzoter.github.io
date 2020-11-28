---
layout: post
title: ZooKeeper报错Last transaction was partial
categories: Backend
description: ZooKeeper报错
keywords: ZooKeeper
---

> Zookeeper无法正常启动，报错Last transaction was partial
>

# 1.错误日志

```
[2020-11-28 10:28:59,552] INFO Using org.apache.zookeeper.server.NIOServerCnxnFactory as server connection factory (org.apache.zookeeper.server.ServerCnxnFactory)
[2020-11-28 10:28:59,556] INFO binding to port 0.0.0.0/0.0.0.0:2181 (org.apache.zookeeper.server.NIOServerCnxnFactory)
[2020-11-28 10:28:59,588] ERROR Last transaction was partial. (org.apache.zookeeper.server.persistence.Util)
[2020-11-28 10:28:59,589] ERROR Unexpected exception, exiting abnormally (org.apache.zookeeper.server.ZooKeeperServerMain)
java.io.EOFException
	at java.io.DataInputStream.readInt(DataInputStream.java:392)
	at org.apache.jute.BinaryInputArchive.readInt(BinaryInputArchive.java:63)
	at org.apache.zookeeper.server.persistence.FileHeader.deserialize(FileHeader.java:66)
	at org.apache.zookeeper.server.persistence.FileTxnLog$FileTxnIterator.inStreamCreated(FileTxnLog.java:588)
	at org.apache.zookeeper.server.persistence.FileTxnLog$FileTxnIterator.createInputArchive(FileTxnLog.java:607)
	at org.apache.zookeeper.server.persistence.FileTxnLog$FileTxnIterator.goToNextLog(FileTxnLog.java:573)
	at org.apache.zookeeper.server.persistence.FileTxnLog$FileTxnIterator.next(FileTxnLog.java:653)
	at org.apache.zookeeper.server.persistence.FileTxnSnapLog.fastForwardFromEdits(FileTxnSnapLog.java:219)
	at org.apache.zookeeper.server.persistence.FileTxnSnapLog.restore(FileTxnSnapLog.java:176)
	at org.apache.zookeeper.server.ZKDatabase.loadDataBase(ZKDatabase.java:217)
	at org.apache.zookeeper.server.ZooKeeperServer.loadData(ZooKeeperServer.java:284)
	at org.apache.zookeeper.server.ZooKeeperServer.startdata(ZooKeeperServer.java:407)
	at org.apache.zookeeper.server.NIOServerCnxnFactory.startup(NIOServerCnxnFactory.java:118)
	at org.apache.zookeeper.server.ZooKeeperServerMain.runFromConfig(ZooKeeperServerMain.java:122)
	at org.apache.zookeeper.server.ZooKeeperServerMain.initializeAndRun(ZooKeeperServerMain.java:89)
	at org.apache.zookeeper.server.ZooKeeperServerMain.main(ZooKeeperServerMain.java:55)
	at org.apache.zookeeper.server.quorum.QuorumPeerMain.initializeAndRun(QuorumPeerMain.java:119)
	at org.apache.zookeeper.server.quorum.QuorumPeerMain.main(QuorumPeerMain.java:81)
```

# 2.解决过程

（1）删除ZooKeeper安装目录下的logs

无效果

（2）删除ZooKeeper的数据文件夹下大小为0的文件

数据文件夹位置可以通过zookeeper的配置文件得到。

```properties
# the directory where the snapshot is stored.
dataDir=/tmp/zookeeper
```

删除该`[dataDir]/version-2/`下大小为0的快照文件，即可正常启动。

# 3.原因探究

（1）磁盘满了

首先使用`du -h --max-depth=1`来逐层分析磁盘满的根本原因，比如我最终定位到docker文件夹，是因为Docker容器过多，需要将停止的容器清除，即可释放磁盘

（2）ZooKeeper快照无法写入（待考证）

由于磁盘满，所以ZooKeeper无法将快照写入到磁盘，导致了大小为0的快照文件

下次启动时，如果从快照中读取数据，就会出现`Last transaction was partial`

