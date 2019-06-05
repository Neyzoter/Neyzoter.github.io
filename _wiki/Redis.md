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

# 运行mongodb
echo "Starting run mongo"
nohup mongod &
sleep 5s
echo "mongod run ok"
# 运行redis
echo "Starting run redis"
nohup /home/songchaochao/opt/redis-5.0.5/src/redis-server & 
sleep 5s
echo "redis-server run ok"

# 运行redis命令行
if [ ! -n "$1" ];then
    echo "[INFO] You can input a \$1 = 1 to start redis client"
elif [ $1 -eq 1 ];then 
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

## 2.7 使用Redis

使用前保证Redis打开。

### 2.7.1 原生Redis 接口使用

```java
import redis.clients.jedis.Jedis;
public class RedisJava {
    public static void main(String[] args) {
        //连接本地的 Redis 服务
        Jedis jedis = new Jedis("localhost");
        System.out.println("连接成功");
        //查看服务是否运行
        System.out.println("服务器正在运行: "+jedis.ping());

        /*字符串实例*/
        //设置 redis 字符串数据
        jedis.set("w3ckey", "www.w3cschool.cn");
        // 获取存储的数据并输出
        System.out.println("redis 存储的字符串为: "+ jedis.get("w3ckey"));

        /*列表实例*/
        //存储数据到列表中
        jedis.lpush("tutorial-list", "Redis");
        jedis.lpush("tutorial-list", "Mongodb");
        jedis.lpush("tutorial-list", "Mysql");
        // 获取存储的数据并输出
        List<String> list = jedis.lrange("tutorial-list", 0 ,2);
        for(int i=0; i<list.size(); i++) {
            System.out.println("列表项为: "+list.get(i));
        }
        /*Java KEY 实例*/
        // 获取数据并输出
        Set<String> keys= jedis.keys("*");
        Iterator<String> it=keys.iterator();
        while(it.hasNext) {
            String key=it.next();
            System.out.println("key");
        }
    }
```

输出

```
  连接成功
  服务正在运行：PONG
  redis 存储的字符串为：www.w3cschool.cn
  列表项为: Redis
  列表项为: Mongodb
  列表项为: Mysql
  w3ckey
  tutorial-list 
```

### 2.7.2 springframework的Redis接口

测试类

```java
package com.neyzoter.aiot.dal.redis;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.junit4.SpringRunner;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

@RunWith(SpringRunner.class)
@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})
@SpringBootTest
public class RedisTest {
    private final static Logger logger = LoggerFactory.getLogger(RedisApplicationTest.class);
    //构建一个StringRedisTemplate的bean对象
    @Resource
    private StringRedisTemplate stringRedisTemplate;
    //构建一个RedisTemplate的bean对象
    //本身是一个RedisTemplate<k,v>类型，这里可以不指明k和v的类型，自动识别
	@Resource
    private RedisTemplate<String, User> redisTemplate;

    @Test
    public void test() throws Exception {
        stringRedisTemplate.opsForValue().set("aaa", "111");
        Assert.assertEquals("111", stringRedisTemplate.opsForValue().get("aaa"));
        if(stringRedisTemplate.opsForValue().get("aaa").equals("111")){
            logger.info("stringRedisTemplate equal!");
        }else{
            logger.info("stringRedisTemplate not equal!");
        }

    }
    
    @Test
    public void testObj() throws Exception {
        User user=new User("aa@126.com", "aa", "aa123456", "aa","123");
        ValueOperations<String, User> operations=redisTemplate.opsForValue();
        operations.set("com.neox", user);
        //设置Redis内部数据存活时间
        operations.set("com.neo.f", user,1, TimeUnit.SECONDS);
        //sleep1s后，"com.neo.f"对应的数值会被擦除
        Thread.sleep(1000);
        //redisTemplate.delete("com.neo.f");
        boolean exists=redisTemplate.hasKey("com.neo.f");
        if(exists){
        	logger.info("exists is true");
        }else{
        	logger.info("exists is false");
        }
    }
}

```

# 3、Redis命令

## 3.1 基础

```bash
# 启动
src/redis-cli
# PING-PONG
127.0.0.1:6379> PING
PONG
```

## 3.2 Redis键

```bash
127.0.0.1:6379> SET w3ckey redis
OK
127.0.0.1:6379> DEL w3ckey
(integer) 1
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [DEL key](https://www.w3cschool.cn/redis/keys-del.html) 该命令用于在 key 存在时删除 key。 |
| 2    | [DUMP key](https://www.w3cschool.cn/redis/keys-dump.html)  序列化给定 key ，并返回被序列化的值。 |
| 3    | [EXISTS key](https://www.w3cschool.cn/redis/keys-exists.html)  检查给定 key 是否存在。 |
| 4    | [EXPIRE key](https://www.w3cschool.cn/redis/keys-expire.html) seconds 为给定 key 设置过期时间。 |
| 5    | [EXPIREAT key timestamp](https://www.w3cschool.cn/redis/keys-expireat.html)  EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)。 |
| 6    | [PEXPIRE key milliseconds](https://www.w3cschool.cn/redis/keys-pexpire.html)  设置 key 的过期时间亿以毫秒计。 |
| 7    | [PEXPIREAT key milliseconds-timestamp](https://www.w3cschool.cn/redis/keys-pexpireat.html)  设置 key 过期时间的时间戳(unix timestamp) 以毫秒计 |
| 8    | [KEYS pattern](https://www.w3cschool.cn/redis/keys-keys.html)  查找所有符合给定模式( pattern)的 key 。 |
| 9    | [MOVE key db](https://www.w3cschool.cn/redis/keys-move.html)  将当前数据库的 key 移动到给定的数据库 db 当中。 |
| 10   | [PERSIST key](https://www.w3cschool.cn/redis/keys-persist.html)  移除 key 的过期时间，key 将持久保持。 |
| 11   | [PTTL key](https://www.w3cschool.cn/redis/keys-pttl.html)  以毫秒为单位返回 key 的剩余的过期时间。 |
| 12   | [TTL key](https://www.w3cschool.cn/redis/keys-ttl.html)  以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。 |
| 13   | [RANDOMKEY](https://www.w3cschool.cn/redis/keys-randomkey.html)  从当前数据库中随机返回一个 key 。 |
| 14   | [RENAME key newkey](https://www.w3cschool.cn/redis/keys-rename.html)  修改 key 的名称 |
| 15   | [RENAMENX key newkey](https://www.w3cschool.cn/redis/keys-renamenx.html)  仅当 newkey 不存在时，将 key 改名为 newkey 。 |
| 16   | [TYPE key](https://www.w3cschool.cn/redis/keys-type.html)  返回 key 所储存的值的类型。 |

## 3.3 Redis字符串

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [SET key value](https://www.w3cschool.cn/redis/strings-set.html)  设置指定 key 的值 |
| 2    | [GET key](https://www.w3cschool.cn/redis/strings-get.html)  获取指定 key 的值。 |
| 3    | [GETRANGE key start end](https://www.w3cschool.cn/redis/strings-getrange.html)  返回 key 中字符串值的子字符 |
| 4    | [GETSET key value](https://www.w3cschool.cn/redis/strings-getset.html) 将给定 key 的值设为 value ，并返回 key 的旧值(old value)。 |
| 5    | [GETBIT key offset](https://www.w3cschool.cn/redis/strings-getbit.html) 对 key 所储存的字符串值，获取指定偏移量上的位(bit)。 |
| 6    | [MGET key1 [key2..]](https://www.w3cschool.cn/redis/strings-mget.html) 获取所有(一个或多个)给定 key 的值。 |
| 7    | [SETBIT key offset value](https://www.w3cschool.cn/redis/strings-setbit.html) 对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)。 |
| 8    | [SETEX key seconds value](https://www.w3cschool.cn/redis/strings-setex.html) 将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位)。 |
| 9    | [SETNX key value](https://www.w3cschool.cn/redis/strings-setnx.html) 只有在 key 不存在时设置 key 的值。 |
| 10   | [SETRANGE key offset value](https://www.w3cschool.cn/redis/strings-setrange.html) 用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。 |
| 11   | [STRLEN key](https://www.w3cschool.cn/redis/strings-strlen.html) 返回 key 所储存的字符串值的长度。 |
| 12   | [MSET key value [key value ...] ](https://www.w3cschool.cn/redis/strings-mset.html) 同时设置一个或多个 key-value 对。 |
| 13   | [MSETNX key value [key value ...]](https://www.w3cschool.cn/redis/strings-msetnx.html)  同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。 |
| 14   | [PSETEX key milliseconds value](https://www.w3cschool.cn/redis/strings-psetex.html) 这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位。 |
| 15   | [INCR key](https://www.w3cschool.cn/redis/strings-incr.html) 将 key 中储存的数字值增一。 |
| 16   | [INCRBY key increment](https://www.w3cschool.cn/redis/strings-incrby.html) 将 key 所储存的值加上给定的增量值（increment） 。 |
| 17   | [INCRBYFLOAT key increment](https://www.w3cschool.cn/redis/strings-incrbyfloat.html) 将 key 所储存的值加上给定的浮点增量值（increment） 。 |
| 18   | [DECR key](https://www.w3cschool.cn/redis/strings-decr.html) 将 key 中储存的数字值减一。 |
| 19   | [DECRBY key decrement](https://www.w3cschool.cn/redis/strings-decrby.html) key 所储存的值减去给定的减量值（decrement） 。 |
| 20   | [APPEND key value](https://www.w3cschool.cn/redis/strings-append.html) 如果 key 已经存在并且是一个字符串， APPEND 命令将 value 追加到 key 原来的值的末尾。 |

## 3.4 Redis哈希

Redis 中每个 hash 可以存储 232 - 1 键值对（40多亿）。	

```bash
redis 127.0.0.1:6379> HMSET w3ckey name "redis tutorial" description "redis basic commands for caching" likes 20 visitors 23000
OK
redis 127.0.0.1:6379> HGETALL w3ckey

1) "name"
2) "redis tutorial"
3) "description"
4) "redis basic commands for caching"
5) "likes"
6) "20"
7) "visitors"
8) "23000"
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [HDEL key field2 [field2]](https://www.w3cschool.cn/redis/hashes-hdel.html)  删除一个或多个哈希表字段 |
| 2    | [HEXISTS key field](https://www.w3cschool.cn/redis/hashes-hexists.html)  查看哈希表 key 中，指定的字段是否存在。 |
| 3    | [HGET key field](https://www.w3cschool.cn/redis/hashes-hget.html)  获取存储在哈希表中指定字段的值 |
| 4    | [HGETALL key](https://www.w3cschool.cn/redis/hashes-hgetall.html)  获取在哈希表中指定 key 的所有字段和值 |
| 5    | [HINCRBY key field increment](https://www.w3cschool.cn/redis/hashes-hincrby.html)  为哈希表 key 中的指定字段的整数值加上增量 increment 。 |
| 6    | [HINCRBYFLOAT key field increment](https://www.w3cschool.cn/redis/hashes-hincrbyfloat.html)  为哈希表 key 中的指定字段的浮点数值加上增量 increment 。 |
| 7    | [HKEYS key](https://www.w3cschool.cn/redis/hashes-hkeys.html)  获取所有哈希表中的字段 |
| 8    | [HLEN key](https://www.w3cschool.cn/redis/hashes-hlen.html)  获取哈希表中字段的数量 |
| 9    | [HMGET key field1 [field2]](https://www.w3cschool.cn/redis/hashes-hmget.html)  获取所有给定字段的值 |
| 10   | [HMSET key field1 value1 [field2 value2]](https://www.w3cschool.cn/redis/hashes-hmset.html)  同时将多个 field-value (域-值)对设置到哈希表 key 中。 |
| 11   | [HSET key field value](https://www.w3cschool.cn/redis/hashes-hset.html)  将哈希表 key 中的字段 field 的值设为 value 。 |
| 12   | [HSETNX key field value](https://www.w3cschool.cn/redis/hashes-hsetnx.html)  只有在字段 field 不存在时，设置哈希表字段的值。 |
| 13   | [HVALS key](https://www.w3cschool.cn/redis/hashes-hvals.html)  获取哈希表中所有值 |
| 14   | HSCAN key cursor \[MATCH pattern\]\[COUNT count\]  迭代哈希表中的键值对。 |

## 3.5 列表(List)

Redis列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素导列表的头部（左边）或者尾部（右边）

一个列表最多可以包含 232 - 1 个元素 (4294967295, 每个列表超过40亿个元素)。

```bash

redis 127.0.0.1:6379> LPUSH w3ckey redis
(integer) 1
redis 127.0.0.1:6379> LPUSH w3ckey mongodb
(integer) 2
redis 127.0.0.1:6379> LPUSH w3ckey mysql
(integer) 3
# 按照插入顺序输出（和插入顺序相反）
redis 127.0.0.1:6379> LRANGE w3ckey 0 10

1) "mysql"
2) "mongodb"
3) "redis"
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [BLPOP key1 [key2 ] timeout](https://www.w3cschool.cn/redis/lists-blpop.html)  移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 2    | [BRPOP key1 [key2 ] timeout](https://www.w3cschool.cn/redis/lists-brpop.html)  移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 3    | [BRPOPLPUSH source destination timeout](https://www.w3cschool.cn/redis/lists-brpoplpush.html)  从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。 |
| 4    | [LINDEX key index](https://www.w3cschool.cn/redis/lists-lindex.html)  通过索引获取列表中的元素 |
| 5    | [LINSERT key BEFORE\|AFTER pivot value](https://www.w3cschool.cn/redis/lists-linsert.html)  在列表的元素前或者后插入元素 |
| 6    | [LLEN key](https://www.w3cschool.cn/redis/lists-llen.html)  获取列表长度 |
| 7    | [LPOP key](https://www.w3cschool.cn/redis/lists-lpop.html)  移出并获取列表的第一个元素 |
| 8    | [LPUSH key value1 [value2]](https://www.w3cschool.cn/redis/lists-lpush.html)  将一个或多个值插入到列表**头部** |
| 9    | [LPUSHX key value](https://www.w3cschool.cn/redis/lists-lpushx.html)  将一个或多个值插入到已存在的列表头部 |
| 10   | [LRANGE key start stop](https://www.w3cschool.cn/redis/lists-lrange.html)  获取列表指定范围内的元素 |
| 11   | [LREM key count value](https://www.w3cschool.cn/redis/lists-lrem.html)  移除列表元素 |
| 12   | [LSET key index value](https://www.w3cschool.cn/redis/lists-lset.html)  通过索引设置列表元素的值 |
| 13   | [LTRIM key start stop](https://www.w3cschool.cn/redis/lists-ltrim.html)  对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。 |
| 14   | [RPOP key](https://www.w3cschool.cn/redis/lists-rpop.html)  移除并获取列表最后一个元素 |
| 15   | [RPOPLPUSH source destination](https://www.w3cschool.cn/redis/lists-rpoplpush.html)  移除列表的最后一个元素，并将该元素添加到另一个列表并返回 |
| 16   | [RPUSH key value1 [value2]](https://www.w3cschool.cn/redis/lists-rpush.html)  在列表中添加一个或多个值 |
| 17   | [RPUSHX key value](https://www.w3cschool.cn/redis/lists-rpushx.html)  为已存在的列表添加值 |

## 3.6 集合(Set)

Redis的Set是string类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据。

Redis 中 集合是**通过哈希表实现**的，所以添加，删除，查找的复杂度都是O(1)。

集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。

```bash
redis 127.0.0.1:6379> SADD w3ckey redis
(integer) 1
redis 127.0.0.1:6379> SADD w3ckey mongodb
(integer) 1
redis 127.0.0.1:6379> SADD w3ckey mysql
(integer) 1
redis 127.0.0.1:6379> SADD w3ckey mysql
(integer) 0
# 返回所有成员
redis 127.0.0.1:6379> SMEMBERS w3ckey

1) "mysql"
2) "mongodb"
3) "redis"
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [SADD key member1 [member2]](https://www.w3cschool.cn/redis/sets-sadd.html)  向集合添加一个或多个成员 |
| 2    | [SCARD key](https://www.w3cschool.cn/redis/sets-scard.html)  获取集合的成员数 |
| 3    | [SDIFF key1 [key2]](https://www.w3cschool.cn/redis/sets-sdiff.html)  返回给定所有集合的差集 |
| 4    | [SDIFFSTORE destination key1 [key2]](https://www.w3cschool.cn/redis/sets-sdiffstore.html)  返回给定所有集合的差集并存储在 destination 中 |
| 5    | [SINTER key1 [key2]](https://www.w3cschool.cn/redis/sets-sinter.html)  返回给定所有集合的交集 |
| 6    | [SINTERSTORE destination key1 [key2]](https://www.w3cschool.cn/redis/sets-sinterstore.html)  返回给定所有集合的交集并存储在 destination 中 |
| 7    | [SISMEMBER key member](https://www.w3cschool.cn/redis/sets-sismember.html)  判断 member 元素是否是集合 key 的成员 |
| 8    | [SMEMBERS key](https://www.w3cschool.cn/redis/sets-smembers.html)  返回集合中的所有成员 |
| 9    | [SMOVE source destination member](https://www.w3cschool.cn/redis/sets-smove.html)  将 member 元素从 source 集合移动到 destination 集合 |
| 10   | [SPOP key](https://www.w3cschool.cn/redis/sets-spop.html)  移除并返回集合中的一个随机元素 |
| 11   | [SRANDMEMBER key [count]](https://www.w3cschool.cn/redis/sets-srandmember.html)  返回集合中一个或多个随机数 |
| 12   | [SREM key member1 [member2]](https://www.w3cschool.cn/redis/sets-srem.html)  移除集合中一个或多个成员 |
| 13   | [SUNION key1 [key2]](https://www.w3cschool.cn/redis/sets-sunion.html)  返回所有给定集合的并集 |
| 14   | [SUNIONSTORE destination key1 [key2]](https://www.w3cschool.cn/redis/sets-sunionstore.html)  所有给定集合的并集存储在 destination 集合中 |
| 15   | [SSCAN key cursor [MATCH pattern\] [COUNT count]](https://www.w3cschool.cn/redis/sets-sscan.html)  迭代集合中的元素 |

## 3.7 有序集合(ZSet)

Redis 有序集合和集合一样也是string类型元素的集合,且不允许重复的成员。

不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。

有序集合的成员是唯一的,但分数(score)却可以重复。

```bash
redis 127.0.0.1:6379> ZADD w3ckey 1 redis
(integer) 1
redis 127.0.0.1:6379> ZADD w3ckey 2 mongodb
(integer) 1
redis 127.0.0.1:6379> ZADD w3ckey 3 mysql
(integer) 1
redis 127.0.0.1:6379> ZADD w3ckey 3 mysql
(integer) 0
redis 127.0.0.1:6379> ZADD w3ckey 4 mysql
(integer) 0
redis 127.0.0.1:6379> ZRANGE w3ckey 0 10 WITHSCORES

1) "redis"
2) "1"
3) "mongodb"
4) "2"
5) "mysql"
6) "4"
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [ZADD key score1 member1 [score2 member2]](https://www.w3cschool.cn/redis/sorted-sets-zadd.html)  向有序集合添加一个或多个成员，或者更新已存在成员的分数 |
| 2    | [ZCARD key](https://www.w3cschool.cn/redis/sorted-sets-zcard.html)  获取有序集合的成员数 |
| 3    | [ZCOUNT key min max](https://www.w3cschool.cn/redis/sorted-sets-zcount.html)  计算在有序集合中指定区间分数的成员数 |
| 4    | [ZINCRBY key increment member](https://www.w3cschool.cn/redis/sorted-sets-zincrby.html)  有序集合中对指定成员的分数加上增量 increment |
| 5    | [ZINTERSTORE destination numkeys key [key ...]](https://www.w3cschool.cn/redis/sorted-sets-zinterstore.html)  计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 key 中 |
| 6    | [ZLEXCOUNT key min max](https://www.w3cschool.cn/redis/sorted-sets-zlexcount.html)  在有序集合中计算指定字典区间内成员数量 |
| 7    | [ZRANGE key start stop [WITHSCORES]](https://www.w3cschool.cn/redis/sorted-sets-zrange.html)  通过索引区间返回有序集合成指定区间内的成员 |
| 8    | [ZRANGEBYLEX key min max [LIMIT offset count]](https://www.w3cschool.cn/redis/sorted-sets-zrangebylex.html)  通过字典区间返回有序集合的成员 |
| 9    | [ZRANGEBYSCORE key min max [WITHSCORES\] [LIMIT]](https://www.w3cschool.cn/redis/sorted-sets-zrangebyscore.html)  通过分数返回有序集合指定区间内的成员 |
| 10   | [ZRANK key member](https://www.w3cschool.cn/redis/sorted-sets-zrank.html)  返回有序集合中指定成员的索引 |
| 11   | [ZREM key member [member ...]](https://www.w3cschool.cn/redis/sorted-sets-zrem.html)  移除有序集合中的一个或多个成员 |
| 12   | [ZREMRANGEBYLEX key min max](https://www.w3cschool.cn/redis/sorted-sets-zremrangebylex.html)  移除有序集合中给定的字典区间的所有成员 |
| 13   | [ZREMRANGEBYRANK key start stop](https://www.w3cschool.cn/redis/sorted-sets-zremrangebyrank.html)  移除有序集合中给定的排名区间的所有成员 |
| 14   | [ZREMRANGEBYSCORE key min max](https://www.w3cschool.cn/redis/sorted-sets-zremrangebyscore.html)  移除有序集合中给定的分数区间的所有成员 |
| 15   | [ZREVRANGE key start stop [WITHSCORES]](https://www.w3cschool.cn/redis/sorted-sets-zrevrange.html)  返回有序集中指定区间内的成员，通过索引，分数从高到底 |
| 16   | [ZREVRANGEBYSCORE key max min [WITHSCORES]](https://www.w3cschool.cn/redis/sorted-sets-zrevrangebyscore.html)  返回有序集中指定分数区间内的成员，分数从高到低排序 |
| 17   | [ZREVRANK key member](https://www.w3cschool.cn/redis/sorted-sets-zrevrank.html)  返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序 |
| 18   | [ZSCORE key member](https://www.w3cschool.cn/redis/sorted-sets-zscore.html)  返回有序集中，成员的分数值 |
| 19   | [ZUNIONSTORE destination numkeys key [key ...]](https://www.w3cschool.cn/redis/sorted-sets-zunionstore.html)  计算给定的一个或多个有序集的并集，并存储在新的 key 中 |
| 20   | [ZSCAN key cursor [MATCH pattern\] [COUNT count]](https://www.w3cschool.cn/redis/sorted-sets-zscan.html)  迭代有序集合中的元素（包括元素成员和元素分值） |

## 3.8 HyperLogLog

自Redis 2.8.9版本开始。

**Redis HyperLogLog 是用来做基数统计的算法**，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

**基数**

比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素)为5。 

**基数统计**

基数估计就是在误差可接受的范围内，快速计算基数。

**实例**

```bash
redis 127.0.0.1:6379> PFADD w3ckey "redis"

1) (integer) 1

redis 127.0.0.1:6379> PFADD w3ckey "mongodb"

1) (integer) 1

redis 127.0.0.1:6379> PFADD w3ckey "mysql"

1) (integer) 1

redis 127.0.0.1:6379> PFCOUNT w3ckey

(integer) 3
```

**指令**

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [PFADD key element [element ...]](https://www.w3cschool.cn/redis/hyperloglog-pfadd.html)  添加指定元素到 HyperLogLog 中。 |
| 2    | [PFCOUNT key [key ...]](https://www.w3cschool.cn/redis/hyperloglog-pfcount.html)  返回给定 HyperLogLog 的基数估算值。 |
| 3    | [PFMERGE destkey sourcekey [sourcekey ...]](https://www.w3cschool.cn/redis/hyperloglog-pfmerge.html)  将多个 HyperLogLog 合并为一个 HyperLogLog |

## 3.9 Redis发布订阅

Redis 发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。 

<img src="image/wiki/Redis/sub.png" width = 700 alt="订阅">

<img src="image/wiki/Redis/pub.png" width = 700 alt="订阅">