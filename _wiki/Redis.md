---
layout: wiki
title: Redis
categories: Java
description: Redis学习笔记
keywords: Java后端, Redis
---

> 原创

# 1、Redis介绍

## 1.1 简介

**Redis特点**

- Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用。
- Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
- Redis支持数据的备份，即master-slave模式的数据备份。

**Redis优势**

- 性能极高 – Redis能读的速度是110000次/s,写的速度是81000次/s 。
- 丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作。
- 原子 – Redis的所有操作都是原子性的，同时Redis还支持对几个操作全并后的原子性执行。
- 丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性。

## 1.2 安装

1、[下载](https://redis.io/download)和解压

2、make

```bash
# 进入Redis目录
$ make
# 检查有无错误
$ make test
```

3、运行

```bash
$ src/redis-server
```

4、执行client

```bash
$ src/redis-cli
redis> set foo bar
OK
redis> get foo
"bar"
```

*写一个脚本*

```bash
#!/bin/sh
# 运行redis
nohup /home/songchaochao/opt/redis-5.0.5/src/redis-server &
sleep 5s
echo "redis-server run ok"

# 运行redis命令行
if [ $1 -eq 1 ]
then
    /home/songchaochao/opt/redis-5.0.5/src/redis-cli
fi
```

5、配置

```bash
# 在运行命令行后
# 获取某一个参数
127.0.0.1:6379> CONFIG GET loglevel
1) "loglevel"
2) "notice"
# 获取所有参数
127.0.0.1:6379> CONFIG GET *
...

# 设置参数
127.0.0.1:6379> CONFIG SET loglevel "notice"
```

| 参数名称  | 默认参数           | 参数说明                                                     |
| --------- | ------------------ | ------------------------------------------------------------ |
| daemonize | no                 | 不开启守护进程                                               |
| pidfile   | /var/run/redis.pid | pid写入该文件                                                |
| port      | 6379               | 监听端口                                                     |
| bind      | 127.0.0.1          | 绑定主机地址                                                 |
| timeout   | 300                | 客户端限制300秒后断开连接，0表示关闭该功能                   |
| loglevel  | verbose            | 日志等级debug、verbose、notice、warning                      |
| logfile   | stdout             | 标准输出，如果redis的daemonize参数配置为yes，则日志发送给/dev/null |
| databases | 0                  | 数据库数量，可通过SELECT <dbid>来设置                        |

[其他配置](https://www.w3cschool.cn/redis/redis-conf.html)

## 1.3 数据类型

string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)

* String

二进制安全，可以包含任何数据（比如图片、序列化对象）、最大存储512MB

```bash
redis 127.0.0.1:6379> SET name "w3cschool.cn"
OK
redis 127.0.0.1:6379> GET name
"w3cschool.cn"
```

* Hash

键值对集合，string类型的field和value的映射表，适合存储对象。

最多存储`2^(32-1)`个键值对

```bash
redis 127.0.0.1:6379> HMSET user:1 username w3cschool.cn password w3cschool.cn points 200
OK
redis 127.0.0.1:6379> HGETALL user:1
1) "username"
2) "w3cschool.cn"
3) "password"
4) "w3cschool.cn"
5) "points"
6) "200"
```

* List（列表）

简单的字符串列表，按照插入顺序排序，可添加至头部或者尾部。

最多存储`2^(32-1)`个元素。

```bash
redis 127.0.0.1:6379> lpush w3cschool.cn redis
(integer) 1
redis 127.0.0.1:6379> lpush w3cschool.cn mongodb
(integer) 2
redis 127.0.0.1:6379> lpush w3cschool.cn rabitmq
(integer) 3
redis 127.0.0.1:6379> lrange w3cschool.cn 0 10
1) "rabitmq"
2) "mongodb"
3) "redis"
```

* Set（集合）

String类型的无序集合，不允许重复，通过哈希表实现，添加、删除、查找的复杂度都是O(1)。

```bash
# sadd key member
redis 127.0.0.1:6379> sadd w3cschool.cn redis
(integer) 1
redis 127.0.0.1:6379> sadd w3cschool.cn mongodb
(integer) 1
# rabitmq插入两次，不可重复，所以实际只有一个
redis 127.0.0.1:6379> sadd w3cschool.cn rabitmq
(integer) 1
redis 127.0.0.1:6379> sadd w3cschool.cn rabitmq
(integer) 0
redis 127.0.0.1:6379> smembers w3cschool.cn

1) "rabitmq"
2) "mongodb"
3) "redis"
```

* zset（sorted set：有序集合）

String类型元素集合，不允许重复。

不同点：zset每个元素都会关联一个double类型的分数，通过该分数来为集合中的成员进行从小到大的排序。

```bash
# zadd key 分数 member
redis 127.0.0.1:6379> zadd w3cschool.cn 0 redis
(integer) 1
redis 127.0.0.1:6379> zadd w3cschool.cn 0 mongodb
(integer) 1
redis 127.0.0.1:6379> zadd w3cschool.cn 0 rabitmq
(integer) 1
redis 127.0.0.1:6379> zadd w3cschool.cn 0 rabitmq
(integer) 0
redis 127.0.0.1:6379> ZRANGEBYSCORE w3cschool.cn 0 1000

1) "redis"
2) "mongodb"
3) "rabitmq"
```

# 2、Redis高级教程

## 2.1 数据备份和恢复

```bash
# 当前数据库备份
# 安装目录创建dump.rdb文件
redis 127.0.0.1:6379> SAVE
OK
# dump.rdb文件移动到redis启动目录(即在何处启动redis)并启动服务即可
redis 127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/usr/local/redis/bin"
# 后台执行备份
127.0.0.1:6379> BGSAVE
Background saving started
```

## 2.2 安全

```bash
# 查看是否需要密码
CONFIG get requirepass127.0.0.1:6379> CONFIG get requirepass
1) "requirepass"
2) ""

# 设置密码
127.0.0.1:6379> CONFIG set requirepass "key"
OK

# 登录
127.0.0.1:6379> AUTH "key"
OK
127.0.0.1:6379> SET mykey "Test value"
OK
127.0.0.1:6379> GET mykey
"Test value"
```

## 2.3 性能测试

```bash
# 安装
$ sudo apt install redis-tools
# 测试  redis-benchmark [option] [option value]
# 主机为 127.0.0.1，端口号为 6379，执行的命令为 set,lpush，请求数为 10000，通过 -q 参数让结果只显示每秒执行的请求数。
redis-benchmark -h 127.0.0.1 -p 6379 -t set,lpush -n 100000 -q
```

|      |           |                                            |           |
| ---- | --------- | ------------------------------------------ | --------- |
| 序号 | 选项      | 描述                                       | 默认值    |
| 1    | **-h**    | 指定服务器主机名                           | 127.0.0.1 |
| 2    | **-p**    | 指定服务器端口                             | 6379      |
| 3    | **-s**    | 指定服务器 socket                          |           |
| 4    | **-c**    | 指定并发连接数                             | 50        |
| 5    | **-n**    | 指定请求数                                 | 10000     |
| 6    | **-d**    | 以字节的形式指定 SET/GET 值的数据大小      | 2         |
| 7    | **-k**    | 1=keep alive 0=reconnect                   | 1         |
| 8    | **-r**    | SET/GET/INCR 使用随机 key, SADD 使用随机值 |           |
| 9    | **-P**    | 通过管道传输 <numreq> 请求                 | 1         |
| 10   | **-q**    | 强制退出 redis。仅显示 query/sec 值        |           |
| 11   | **--csv** | 以 CSV 格式输出                            |           |
| 12   | **-l**    | 生成循环，永久执行测试                     |           |
| 13   | **-t**    | 仅运行以逗号分隔的测试命令列表。           |           |
| 14   | **-I**    | Idle 模式。仅打开 N 个 idle 连接并等待。   |           |

## 2.4 客户端请求

Redis 通过监听一个 TCP 端口或者 Unix socket 的方式来接收来自客户端的连接

- 首先，客户端 socket 会被设置为非阻塞模式，因为 Redis 在网络事件处理上采用的是非阻塞多路复用模型。
- 然后为这个 socket 设置 TCP_NODELAY 属性，禁用 Nagle 算法
- 然后创建一个可读的文件事件用于监听这个客户端 socket 的数据发送

```bash
# 最大用户数目
config get maxclients
1) "maxclients"
2) "10000"
# 启动服务时配置最大客户
redis-server --maxclients 100000
```

**客户端命令**

| S.N. | 命令               | 描述                                       |
| ---- | ------------------ | ------------------------------------------ |
| 1    | **CLIENT LIST**    | 返回连接到 redis 服务的客户端列表          |
| 2    | **CLIENT SETNAME** | 设置当前连接的名称                         |
| 3    | **CLIENT GETNAME** | 获取通过 CLIENT SETNAME 命令设置的服务名称 |
| 4    | **CLIENT PAUSE**   | 挂起客户端连接，指定挂起的时间以毫秒计     |
| 5    | **CLIENT KILL**    | 关闭客户端连接                             |

## 2.5 管道技术

Redis是一种基于客户端-服务端模型以及请求/响应协议的TCP服务。

- 客户端向服务端发送一个查询请求，并监听Socket返回，通常是以阻塞模式，等待服务端响应。
- 服务端处理命令，并将结果返回给客户端。

**管道技术**：在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。从而实现较高性能。

```bash
# 启动redis后，在命令行（系统的，非redis）输入redis访问信息
# PING    ->   设置w3ckey键值对应redis
$(echo -en "PING\r\n SET w3ckey redis\r\nGET w3ckey\r\nINCR visitor\r\nINCR visitor\r\nINCR visitor\r\n"; sleep 10) | nc localhost 6379

+PONG
+OK
redis
:1
:2
:3
```

## 2.6 分区

分区是分割数据到多个Redis实例的处理过程，因此每个实例只保存key的一个子集。

**优势**

- 通过利用多台计算机内存的和值，允许我们构造更大的数据库。
- 通过多核和多台计算机，允许我们扩展计算能力；通过多台计算机和网络适配器，允许我们扩展网络带宽。

**不足**

- 涉及多个key的操作通常是不被支持的。举例来说，当两个set映射到不同的redis实例上时，你就不能对这两个set执行交集操作。
- 涉及多个key的redis事务不能使用。
- 当使用分区时，数据处理较为复杂，比如你需要处理多个rdb/aof文件，并且从多个实例和主机备份持久化文件。
- 增加或删除容量也比较复杂。redis集群大多数支持在运行时增加、删除节点的透明数据平衡的能力，但是类似于客户端分区、代理等其他系统则不支持这项特性。然而，一种叫做presharding的技术对此是有帮助的。

**分区类型**

* 范围分区

映射一定范围的对象到特定的Redis实例。

比如，ID从0到10000的用户会保存到实例R0，ID从10001到 20000的用户会保存到R1，以此类推。

* 哈希分区

1.用一个hash函数将key转换为一个数字，比如使用crc32 hash函数。对key foobar执行crc32(foobar)会输出类似93024922的整数。

2.对这个整数取模，将其转化为0-3之间的数字，就可以将这个整数映射到4个Redis实例中的一个了。93024922 % 4 = 2，就是说key foobar应该被存到R2实例中。注意：取模操作是取除的余数，通常在多种编程语言中用%操作符实现。