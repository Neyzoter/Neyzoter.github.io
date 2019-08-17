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

<img src="image/wiki/Redis/sub.png" width=700 alt="订阅">

<img src="image/wiki/Redis/pub.png" width=700 alt="发布">

**订阅者的运行**

```bash
# 客户端订阅频道redisChat
redis 127.0.0.1:6379> SUBSCRIBE redisChat

Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redisChat"
3) (integer) 1
```

**发布者的运行**

```bash
# 在同一个频道 redisChat 发布两次消息，订阅者就能接收到消息。
redis 127.0.0.1:6379> PUBLISH redisChat "Redis is a great caching technique"

(integer) 1

redis 127.0.0.1:6379> PUBLISH redisChat "Learn redis by w3cschool.cn"

(integer) 1

# 订阅者的客户端会显示如下消息
1) "message"
2) "redisChat"
3) "Redis is a great caching technique"
1) "message"
2) "redisChat"
3) "Learn redis by w3cschool.cn"
```

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [PSUBSCRIBE pattern [pattern ...]](https://www.w3cschool.cn/redis/pub-sub-psubscribe.html)  订阅一个或多个符合给定模式的频道。 |
| 2    | [ PUBSUB subcommand [argument [argument ...]] ](https://www.w3cschool.cn/redis/pub-sub-pubsub.html)  查看订阅与发布系统状态。 |
| 3    | [PUBLISH channel message](https://www.w3cschool.cn/redis/pub-sub-publish.html)  将信息发送到指定的频道。 |
| 4    | [PUNSUBSCRIBE [pattern [pattern ...]]](https://www.w3cschool.cn/redis/pub-sub-punsubscribe.html)  退订所有给定模式的频道。 |
| 5    | [SUBSCRIBE channel [channel ...]](https://www.w3cschool.cn/redis/pub-sub-subscribe.html)  订阅给定的一个或多个频道的信息。 |
| 6    | [UNSUBSCRIBE [channel [channel ...]]](https://www.w3cschool.cn/redis/pub-sub-unsubscribe.html)  指退订给定的频道。 |

## 3.10 Redis事务

**事务过程**

- 开始事务。
- 命令入队。
- 执行事务。

**示例**

```bash
# 开始事务，以下指令入队，但是不执行
redis 127.0.0.1:6379> MULTI
OK

redis 127.0.0.1:6379> SET book-name "Mastering C++ in 21 days"
QUEUED

redis 127.0.0.1:6379> GET book-name
QUEUED

redis 127.0.0.1:6379> SADD tag "C++" "Programming" "Mastering Series"
QUEUED

redis 127.0.0.1:6379> SMEMBERS tag
QUEUED
# 执行命令
redis 127.0.0.1:6379> EXEC
1) OK
2) "Mastering C++ in 21 days"
3) (integer) 3
4) 1) "Mastering Series"
   2) "C++"
   3) "Programming"
```

**事务相关命令**

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [DISCARD](https://www.w3cschool.cn/redis/transactions-discard.html)  取消事务，放弃执行事务块内的所有命令。 |
| 2    | [EXEC](https://www.w3cschool.cn/redis/transactions-exec.html)  执行所有事务块内的命令。 |
| 3    | [MULTI](https://www.w3cschool.cn/redis/transactions-multi.html)  标记一个事务块的开始。 |
| 4    | [UNWATCH](https://www.w3cschool.cn/redis/transactions-unwatch.html)  取消 WATCH 命令对所有 key 的监视。 |
| 5    | [WATCH key [key ...]](https://www.w3cschool.cn/redis/transactions-watch.html)  监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。 |

## 3.11 Redis脚本

Redis 脚本使用 Lua 解释器来执行脚本。 Reids 2.6 版本通过内嵌支持 Lua 环境。执行脚本的常用命令为 **EVAL**。

**语法**

```bash
redis 127.0.0.1:6379> EVAL script numkeys key [key ...] arg [arg ...]
```

**示例**

```bash
redis 127.0.0.1:6379> EVAL "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second

1) "key1"
2) "key2"
3) "first"
4) "second"
```

**Redis脚本命令**

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [EVAL script numkeys key [key ...] arg [arg ...]](https://www.w3cschool.cn/redis/scripting-eval.html)  执行 Lua 脚本。 |
| 2    | [EVALSHA sha1 numkeys key [key ...\] arg [arg ...]](https://www.w3cschool.cn/redis/scripting-evalsha.html)  执行 Lua 脚本。 |
| 3    | [SCRIPT EXISTS script [script ...]](https://www.w3cschool.cn/redis/scripting-script-exists.html)  查看指定的脚本是否已经被保存在缓存当中。 |
| 4    | [SCRIPT FLUSH](https://www.w3cschool.cn/redis/scripting-script-flush.html)  从脚本缓存中移除所有脚本。 |
| 5    | [SCRIPT KILL](https://www.w3cschool.cn/redis/scripting-script-kill.html)  杀死当前正在运行的 Lua 脚本。 |
| 6    | [SCRIPT LOAD script](https://www.w3cschool.cn/redis/scripting-script-load.html)  将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本。 |

## 3.12 Redis连接

```bash
redis 127.0.0.1:6379> AUTH "password"
OK
redis 127.0.0.1:6379> PING
PONG
```

**Redis连接命令**

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [AUTH password](https://www.w3cschool.cn/redis/connection-auth.html)  验证密码是否正确 |
| 2    | [ECHO message](https://www.w3cschool.cn/redis/connection-echo.html)  打印字符串 |
| 3    | [PING](https://www.w3cschool.cn/redis/connection-ping.html)  查看服务是否运行 |
| 4    | [QUIT](https://www.w3cschool.cn/redis/connection-quit.html)  关闭当前连接 |
| 5    | [SELECT index](https://www.w3cschool.cn/redis/connection-select.html)  切换到指定的数据库 |

## 3.13 Redis服务器

**服务器管理命令**

| 序号 | 命令及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [BGREWRITEAOF](https://www.w3cschool.cn/redis/server-bgrewriteaof.html)  异步执行一个 AOF（AppendOnly File） 文件重写操作 |
| 2    | [BGSAVE](https://www.w3cschool.cn/redis/server-bgsave.html)  在后台异步保存当前数据库的数据到磁盘 |
| 3    | [CLIENT KILL [ip:port\] [ID client-id]](https://www.w3cschool.cn/redis/server-client-kill.html)  关闭客户端连接 |
| 4    | [CLIENT LIST](https://www.w3cschool.cn/redis/server-client-list.html)  获取连接到服务器的客户端连接列表 |
| 5    | [CLIENT GETNAME](https://www.w3cschool.cn/redis/server-client-getname.html)  获取连接的名称 |
| 6    | [CLIENT PAUSE timeout](https://www.w3cschool.cn/redis/server-client-pause.html)  在指定时间内终止运行来自客户端的命令 |
| 7    | [CLIENT SETNAME connection-name](https://www.w3cschool.cn/redis/server-client-setname.html)  设置当前连接的名称 |
| 8    | [CLUSTER SLOTS](https://www.w3cschool.cn/redis/server-cluster-slots.html)  获取集群节点的映射数组 |
| 9    | [COMMAND](https://www.w3cschool.cn/redis/server-command.html)  获取 Redis 命令详情数组 |
| 10   | [COMMAND COUNT](https://www.w3cschool.cn/redis/server-command-count.html)  获取 Redis 命令总数 |
| 11   | [COMMAND GETKEYS](https://www.w3cschool.cn/redis/server-command-getkeys.html)  获取给定命令的所有键 |
| 12   | [TIME](https://www.w3cschool.cn/redis/server-time.html)  返回当前服务器时间 |
| 13   | [COMMAND INFO command-name [command-name ...]](https://www.w3cschool.cn/redis/server-command-info.html)  获取指定 Redis 命令描述的数组 |
| 14   | [CONFIG GET parameter](https://www.w3cschool.cn/redis/server-config-get.html)  获取指定配置参数的值 |
| 15   | [CONFIG REWRITE](https://www.w3cschool.cn/redis/server-config-rewrite.html)  对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写 |
| 16   | [CONFIG SET parameter value](https://www.w3cschool.cn/redis/server-config-set.html)  修改 redis 配置参数，无需重启 |
| 17   | [CONFIG RESETSTAT](https://www.w3cschool.cn/redis/server-config-resetstat.html)  重置 INFO 命令中的某些统计数据 |
| 18   | [DBSIZE](https://www.w3cschool.cn/redis/server-dbsize.html)  返回当前数据库的 key 的数量 |
| 19   | [DEBUG OBJECT key](https://www.w3cschool.cn/redis/server-debug-object.html)  获取 key 的调试信息 |
| 20   | [DEBUG SEGFAULT](https://www.w3cschool.cn/redis/server-debug-segfault.html)  让 Redis 服务崩溃 |
| 21   | [FLUSHALL](https://www.w3cschool.cn/redis/server-flushall.html)  删除所有数据库的所有key |
| 22   | [FLUSHDB](https://www.w3cschool.cn/redis/server-flushdb.html)  删除当前数据库的所有key |
| 23   | [INFO [section]](https://www.w3cschool.cn/redis/server-info.html)  获取 Redis 服务器的各种信息和统计数值 |
| 24   | [LASTSAVE](https://www.w3cschool.cn/redis/server-lastsave.html)  返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示 |
| 25   | [MONITOR](https://www.w3cschool.cn/redis/server-monitor.html)  实时打印出 Redis 服务器接收到的命令，调试用 |
| 26   | [ROLE](https://www.w3cschool.cn/redis/server-role.html)  返回主从实例所属的角色 |
| 27   | [SAVE](https://www.w3cschool.cn/redis/server-save.html)  异步保存数据到硬盘 |
| 28   | [SHUTDOWN [NOSAVE\] [SAVE]](https://www.w3cschool.cn/redis/server-shutdown.html)  异步保存数据到硬盘，并关闭服务器 |
| 29   | [SLAVEOF host port](https://www.w3cschool.cn/redis/server-slaveof.html)  将当前服务器转变为指定服务器的从属服务器(slave server) |
| 30   | [SLOWLOG subcommand [argument]](https://www.w3cschool.cn/redis/server-showlog.html)  管理 redis 的慢日志 |
| 31   | [SYNC](https://www.w3cschool.cn/redis/server-sync.html)  用于复制功能(replication)的内部命令 |

# X、Redis面试题

**1、redis是什么？**

　　Redis是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作数据库、缓存和消息中间件。



**2、Redis有什么特点**

　　Redis是一个Key-Value类型的内存数据库，和memcached有点像，整个数据库都是在内存当中进行加载操作，定期通过异步操作把数据库数据flush到硬盘上进行保存。Redis的性能很高，可以处理超过10万次/秒的读写操作，是目前已知性能最快的Key-Value DB。

　　除了性能外，Redis还支持保存多种数据结构，此外单个value的最大限制是1GB，比memcached的1MB高太多了，因此Redis可以用来实现很多有用的功能，比方说用他的List来做FIFO双向链表，实现一个轻量级的高性 能消息队列服务，用他的Set可以做高性能的tag系统等等。另外Redis也可以对存入的Key-Value设置expire时间，因此也可以被当作一 个功能加强版的memcached来用。

　　当然，Redis也有缺陷，那就是是数据库容量受到物理内存的限制，不能用作海量数据的高性能读写，因此Redis比较适合那些局限在较小数据量的高性能操作和运算上。



**3.使用redis有哪些好处？**

　　(1) 速度快，因为数据存在内存中，类似于HashMap，HashMap的优势就是查找和操作的时间复杂度都是O(1)

　　(2) 支持丰富数据类型，支持string，list，set，sorted set，hash

　　(3) 支持事务，操作都是原子性，所谓的原子性就是对数据的更改要么全部执行，要么全部不执行

　　(4) 丰富的特性：可用于缓存，消息，按key设置过期时间，过期后将会自动删除



**4.redis相比memcached有哪些优势？**

　　(1) memcached所有的值均是简单的字符串，redis作为其替代者，支持更为丰富的数据类型

　　(2) redis的速度比memcached快很多 (3) redis可以持久化其数据



**5.Memcache与Redis的区别都有哪些？**

　　1)、存储方式 Memecache把数据全部存在内存之中，断电后会挂掉，数据不能超过内存大小。 Redis有部份存在硬盘上，这样能保证数据的持久性。

　　2)、数据支持类型 Memcache对数据类型支持相对简单。 Redis有复杂的数据类型。

　　3)、使用底层模型不同 它们之间底层实现方式 以及与客户端之间通信的应用协议不一样。 Redis直接自己构建了VM 机制 ，因为一般的系统调用系统函数的话，会浪费一定的时间去移动和请求。

​		4）、Redis是单线程的，多路复用方式提高处理效率（可应用于分布式锁）；	Memcache是多线程的，通过CPU线程切换来提高处理效率。



**6.redis常见性能问题和解决方案：**

　　1).Master写内存快照，save命令调度rdbSave函数，会阻塞主线程的工作，当快照比较大时对性能影响是非常大的，会间断性暂停服务，所以Master最好不要写内存快照。

　　2).Master AOF持久化，如果不重写AOF文件，这个持久化方式对性能的影响是最小的，但是AOF文件会不断增大，AOF文件过大会影响Master重启的恢复速度。Master最好不要做任何持久化工作，包括内存快照和AOF日志文件，特别是不要启用内存快照做持久化,如果数据比较关键，某个Slave开启AOF备份数据，策略为每秒同步一次。

　　3).Master调用BGREWRITEAOF重写AOF文件，AOF在重写的时候会占大量的CPU和内存资源，导致服务load过高，出现短暂服务暂停现象。

　　4). Redis主从复制的性能问题，为了主从复制的速度和连接的稳定性，Slave和Master最好在同一个局域网内



**7. mySQL里有2000w数据，redis中只存20w的数据，如何保证redis中的数据都是热点数据**

　　相关知识：redis 内存数据集大小上升到一定大小的时候，就会施行数据淘汰策略（回收策略）。redis 提供 6种数据淘汰策略：

　　volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰

　　volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰

　　volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰

　　allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰

　　allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰

　　no-enviction（驱逐）：禁止驱逐数据

**8.请用Redis和任意语言实现一段恶意登录保护的代码，限制1小时内每用户Id最多只能登录5次。具体登录函数或功能用空函数即可，不用详细写出。**

　　用列表实现:列表中每个元素代表登陆时间,只要最后的第5次登陆时间和现在时间差不超过1小时就禁止登陆.用Python写的代码如下：

```python
#!/usr/bin/env python3
import redis  
import sys  
import time  
 
r = redis.StrictRedis(host=’127.0.0.1′, port=6379, db=0)  
try:       
    id = sys.argv[1]
except:      
    print(‘input argument error’)    
    sys.exit(0)  
if r.llen(id) >= 5 and time.time() – float(r.lindex(id, 4)) <= 3600:      
    print(“you are forbidden logining”)
else:       
    print(‘you are allowed to login’)    
    r.lpush(id, time.time())    
    # login_func()
```

**9.为什么redis需要把所有数据放到内存中?**

　　Redis为了达到最快的读写速度将数据都读到内存中，并通过异步的方式将数据写入磁盘。所以redis具有快速和数据持久化的特征。如果不将数据放在内存中，磁盘I/O速度为严重影响redis的性能。在内存越来越便宜的今天，redis将会越来越受欢迎。

　　如果设置了最大使用的内存，则数据已有记录数达到内存限值后不能继续插入新值。

**10.Redis是单进程单线程的**

　　redis利用队列技术将并发访问变为串行访问，消除了传统数据库串行控制的开销

**11.redis的并发竞争问题如何解决?**

　　Redis为单进程单线程模式，采用队列模式将并发访问变为串行访问。Redis本身没有锁的概念，Redis对于多个客户端连接并不存在竞争，但是在Jedis客户端对Redis进行并发访问时会发生连接超时、数据转换错误、阻塞、客户端关闭连接等问题，这些问题均是

　　由于客户端连接混乱造成。对此有2种解决方法：

　　1.客户端角度，为保证每个客户端间正常有序与Redis进行通信，对连接进行池化，同时对客户端读写Redis操作采用内部锁synchronized。

　　2.服务器角度，利用setnx实现锁。

　　注：对于第一种，需要应用程序自己处理资源的同步，可以使用的方法比较通俗，可以使用synchronized也可以使用lock；第二种需要用到Redis的setnx命令，但是需要注意一些问题。

**12.redis事物的了解CAS(check-and-set 操作实现乐观锁 )?**

　　和众多其它数据库一样，Redis作为NoSQL数据库也同样提供了事务机制。在Redis中，MULTI/EXEC/DISCARD/WATCH这四个命令是我们实现事务的基石。相信对有关系型数据库开发经验的开发者而言这一概念并不陌生，即便如此，我们还是会简要的列出Redis中事务的实现特征：

　　1). 在事务中的所有命令都将会被串行化的顺序执行，事务执行期间，Redis不会再为其它客户端的请求提供任何服务，从而保证了事物中的所有命令被原子的执行。

　　2). 和关系型数据库中的事务相比，在Redis事务中如果有某一条命令执行失败，其后的命令仍然会被继续执行。

　　3). 我们可以通过MULTI命令开启一个事务，有关系型数据库开发经验的人可以将其理解为"BEGIN TRANSACTION"语句。在该语句之后执行的命令都将被视为事务之内的操作，最后我们可以通过执行EXEC/DISCARD命令来提交/回滚该事务内的所有操作。这两个Redis命令可被视为等同于关系型数据库中的COMMIT/ROLLBACK语句。

　　4). 在事务开启之前，如果客户端与服务器之间出现通讯故障并导致网络断开，其后所有待执行的语句都将不会被服务器执行。然而如果网络中断事件是发生在客户端执行EXEC命令之后，那么该事务中的所有命令都会被服务器执行。

　　5). 当使用Append-Only模式时，Redis会通过调用系统函数write将该事务内的所有写操作在本次调用中全部写入磁盘。然而如果在写入的过程中出现系统崩溃，如电源故障导致的宕机，那么此时也许只有部分数据被写入到磁盘，而另外一部分数据却已经丢失。

　　Redis服务器会在重新启动时执行一系列必要的一致性检测，一旦发现类似问题，就会立即退出并给出相应的错误提示。此时，我们就要充分利用Redis工具包中提供的redis-check-aof工具，该工具可以帮助我们定位到数据不一致的错误，并将已经写入的部分数据进行回滚。修复之后我们就可以再次重新启动Redis服务器了。

**13.WATCH命令和基于CAS的乐观锁：**

　　在Redis的事务中，WATCH命令可用于提供CAS(check-and-set)功能。假设我们通过WATCH命令在事务执行之前监控了多个Keys，倘若在WATCH之后有任何Key的值发生了变化，EXEC命令执行的事务都将被放弃，同时返回Null multi-bulk应答以通知调用者事务执行失败。例如，我们再次假设Redis中并未提供incr命令来完成键值的原子性递增，如果要实现该功能，我们只能自行编写相应的代码。其伪码如下：

```bash
val = GET mykey
val = val + 1
SET mykey $val
```

以上代码只有在单连接的情况下才可以保证执行结果是正确的，因为如果在同一时刻有多个客户端在同时执行该段代码，那么就会出现多线程程序中经常出现的一种错误场景--竞态争用(race condition)。比如，客户端A和B都在同一时刻读取了mykey的原有值，假设该值为10，此后两个客户端又均将该值加一后set回Redis服务器，这样就会导致mykey的结果为11，而不是我们认为的12。为了解决类似的问题，我们需要借助WATCH命令的帮助，见如下代码：

```bash
WATCH mykey
val = GET mykey
val = val + 1
MULTI
SET mykey $val
EXEC
```

和此前代码不同的是，新代码在获取mykey的值之前先通过WATCH命令监控了该键，此后又将set命令包围在事务中，这样就可以有效的保证每个连接在执行EXEC之前，如果当前连接获取的mykey的值被其它连接的客户端修改，那么当前连接的EXEC命令将执行失败。这样调用者在判断返回值后就可以获悉val是否被重新设置成功。

**14.redis持久化的几种方式**

1、快照（snapshots）

　　缺省情况情况下，Redis把数据快照存放在磁盘上的二进制文件中，文件名为dump.rdb。你可以配置Redis的持久化策略，例如数据集中每N秒钟有超过M次更新，就将数据写入磁盘；或者你可以手工调用命令SAVE或BGSAVE。

　　工作原理

　　． Redis forks.

　　． 子进程开始将数据写到临时RDB文件中。

　　． 当子进程完成写RDB文件，用新文件替换老文件。

　　． 这种方式可以使Redis使用copy-on-write技术。

2、AOF

　　快照模式并不十分健壮，当系统停止，或者无意中Redis被kill掉，最后写入Redis的数据就会丢失。这对某些应用也许不是大问题，但对于要求高可靠性的应用来说，

　　Redis就不是一个合适的选择。

　　Append-only文件模式是另一种选择。

　　你可以在配置文件中打开AOF模式

3、虚拟内存方式

　　当你的key很小而value很大时,使用VM的效果会比较好.因为这样节约的内存比较大.

　　当你的key不小时,可以考虑使用一些非常方法将很大的key变成很大的value,比如你可以考虑将key,value组合成一个新的value.

　　vm-max-threads这个参数,可以设置访问swap文件的线程数,设置最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的.可能会造成比较长时间的延迟,但是对数据完整性有很好的保证.

　　自己测试的时候发现用虚拟内存性能也不错。如果数据量很大，可以考虑分布式或者其他数据库

**15.redis的缓存失效策略和主键失效机制**

　　作为缓存系统都要定期清理无效数据，就需要一个主键失效和淘汰策略.

　　在Redis当中，有生存期的key被称为volatile。在创建缓存时，要为给定的key设置生存期，当key过期的时候（生存期为0），它可能会被删除。

　　1、影响生存时间的一些操作

　　生存时间可以通过使用 DEL 命令来删除整个 key 来移除，或者被 SET 和 GETSET 命令覆盖原来的数据，也就是说，修改key对应的value和使用另外相同的key和value来覆盖以后，当前数据的生存时间不同。

　　比如说，对一个 key 执行INCR命令，对一个列表进行LPUSH命令，或者对一个哈希表执行HSET命令，这类操作都不会修改 key 本身的生存时间。另一方面，如果使用RENAME对一个 key 进行改名，那么改名后的 key的生存时间和改名前一样。

　　RENAME命令的另一种可能是，尝试将一个带生存时间的 key 改名成另一个带生存时间的 another_key ，这时旧的 another_key (以及它的生存时间)会被删除，然后旧的 key 会改名为 another_key ，因此，新的 another_key 的生存时间也和原本的 key 一样。使用PERSIST命令可以在不删除 key 的情况下，移除 key 的生存时间，让 key 重新成为一个persistent key 。

　　2、如何更新生存时间

　　可以对一个已经带有生存时间的 key 执行EXPIRE命令，新指定的生存时间会取代旧的生存时间。过期时间的精度已经被控制在1ms之内，主键失效的时间复杂度是O（1），

　　EXPIRE和TTL命令搭配使用，TTL可以查看key的当前生存时间。设置成功返回 1；当 key 不存在或者不能为 key 设置生存时间时，返回 0 。

　　最大缓存配置

　　在 redis 中，允许用户设置最大使用内存大小

　　server.maxmemory

　　默认为0，没有指定最大缓存，如果有新的数据添加，超过最大内存，则会使redis崩溃，所以一定要设置。redis 内存数据集大小上升到一定大小的时候，就会实行数据淘汰策略。

　　redis 提供 6种数据淘汰策略：

* volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰

* volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰

* volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰

* allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰

* allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰

* no-enviction（驱逐）：禁止驱逐数据

　　注意这里的6种机制，volatile和allkeys规定了是对已设置过期时间的数据集淘汰数据还是从全部数据集淘汰数据，后面的lru、ttl以及random是三种不同的淘汰策略，再加上一种no-enviction永不回收的策略。

　   使用策略规则：

　　1、如果数据呈现幂律分布，也就是一部分数据访问频率高，一部分数据访问频率低，则使用allkeys-lru

　　2、如果数据呈现平等分布，也就是所有的数据访问频率都相同，则使用allkeys-random

　　三种数据淘汰策略：

　　ttl和random比较容易理解，实现也会比较简单。主要是Lru最近最少使用淘汰策略，设计上会对key 按失效时间排序，然后取最先失效的key进行淘汰。