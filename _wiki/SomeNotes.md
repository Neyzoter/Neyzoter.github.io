---
layout: wiki
title: SomeNotes
categories: Notes
description: My Notes From book , wechat, and everywhere.
keywords: 知识点
---

# 1.计算机系统

## 1.1 计算机系统漫游

### 1.1.1 编译系统

```
hello.c          hello.i       hello.s       hello.o                 
-------->预处理器-------->编译器--------->汇编器------     .---------. hello
          cpp            ccl             as       '---> |  链接器  |--------->
                                                  .---> |   ld    |
                                                  |     '---------'
                                                printf.o
```



## 1.2 信息的表示和处理

## 1.3 程序的机器级表示

# 2. 计算机操作系统



# 3.计算机网络

## 3.1 概念

- **什么是CGI？**

  CGI脚本的工作：1.读取用户提交表单的信息；2.处理这些信息（也就是实现业务）；3.输出，返回html响应（返回处理完的数据）

* **什么是RESTful？**

  REST = Representational State Transfer（表现层状态转化），资源（可以是网上的信息实体） 表现层（不同的信息可以通过不同形式表现，比如txt、json、xml） 状态转化（代表了客户端和服务器的一个互动过程，客户端通过HTTP实现获取GET、创建POST、修改PUT和删除DELETE资源）。HTTP是REST规则的一个实现实例。

* **什么是SOA？**

  SOA = Service-Oriented Architecture（面向服务的架构）即把系统按照实际业务，拆分成刚刚好大小的、合适的、独立部署的模块，每个模块之间相互独立。实际上SOA只是一种架构设计模式，而SOAP、REST、RPC就是根据这种设计模式构建出来的规范，其中SOAP通俗理解就是http+xml的形式，REST就是http+json的形式，RPC是基于socket的形式。

* **什么是RPC？**

  RPC = Remote Procedure Call Protocol（远程调用协议）通过网络从远程计算机程序上请求服务的协议，基于socket。相比较于REST（基于http，需要满足较多形式）速度更快。

* **什么是JMS？**

  JMS = Java Message Service（Java消息服务），应用程序接口是一个Java平台中关于面向消息中间件（MOM）的API，用于在两个应用程序之间，或分布式系统中发送消息，进行异步通信。JMS它制定了在整个消息服务提供过程中的所有数据结构和交互流程。而**MQ**则是消息队列服务，是面向消息中间件（MOM）的最终实现，是真正的消息服务提供者。MQ的实现可以基于JMS，也可以基于其他规范或标准，其中ActiveMQ就是基于JMS规范实现的消息队列。

* **什么是IPC？**

  IPC = InterProcess Communication（进程间通信），不同进程之间传播或交换信息，通常有管道（包括无名管道和命名管道）、消息队列、信号量、共享存储、Socket、Streams等方式。

* **HTTP中GET和POST的区别？**
  - GET产生一个TCP数据包（http header和data一并发送出去，接受200 OK）；POST产生两个TCP数据包（先发送header，接收100 continue，再发送data，接收200 OK）。
  - GET在浏览器回退时是无害的，而POST会再次提交请求。
  - GET产生的URL地址可以被Bookmark，而POST不可以。
  - GET请求会被浏览器主动cache，而POST不会，除非手动设置。
  - GET请求只能进行url编码，而POST支持多种编码方式。
  - GET请求参数会被完整保留在浏览器历史记录里，而POST中的参数不会被保留。
  - GET请求在URL中传送的参数是有长度限制的，而POST么有。
  - 对参数的数据类型，GET只接受ASCII字符，而POST没有限制。
  - GET比POST更不安全，因为参数直接暴露在URL上，所以不能用来传递敏感信息。
  - GET参数通过URL传递，POST放在Request body中。

# 4.数据库

## 4.1 概念

* **什么是ORM？**

ORM 就是通过实例对象的语法，完成关系型数据库的操作的技术。

# 5.计算机应用

## 5.1 后端技术

### 5.1.1 大数据

* **大数据索引方式**

  **（1）数据立方体（Data Cube）**

  数据立方体只是多维模型的一个形象的说法，多维模型不仅限于三维模型。真正体现其在分析上的优势还需要基于模型的有效的操作和处理，也就是OLAP（On-line Analytical Processing，联机分析处理），包括钻取（Drill-down）、上卷（Roll-up）、切片（Slice）、切块（Dice）以及旋转（Pivot）。

  <img src="/images/wiki/SomeNotes/Data-Cube.png" width="600" alt="数据立方体">

  **（2）[倒排索引（Inverted index）](https://zh.wikipedia.org/wiki/倒排索引)**

  被用来存储在全文搜索下某个单词在一个文档或者一组文档中的存储位置的映射，是文档检索系统中最常用的数据结构。如`"a":      {(2, 2), (3,5)}`表示单词a在第2个文档的第2个单词和第3个文档的第5个单词出现，可以据诸多单词索引的集合，可以得到一句话的所在位置。

### 5.1.2 中间件

#### 5.1.2.1 Kafka

* **Kafka相比于传统MQ的优势？**

  可以扩展处理(一次处理分发给多个进程)并且允许多订阅者模式，不需要只选择其中一个，需要注意的是传统的MQ的队列方式只能被消费一次，故不能分发给多个订阅者；而发布订阅方式只能分发给多个订阅者，无法提前一步进行拓展处理。具体的实现方式是，通过类似出队列发送到消息组，而消息组进行拓展处理，再给组内的成员（进程）。

* **Kafka如何提高效率?**

  （1）解决大量的小型 I/O 操作问题（发生在客户端和服务端之间以及服务端自身的持久化操作中）

  合理将消息分组，使得网络请求将多个消息打包成一组，而不是每次发送一条消息，从而使整组消息分担网络中往返的开销。

  （2）字节拷贝性能限制

  使用 producer ，broker 和 consumer 都共享的标准化的二进制消息格式，这样数据块不用修改就能在他们之间传递，sendfile允许操作系统将数据从pagecache直接发送到网络（零拷贝）。

  （3）网络带宽限制

  Kafka 以高效的批处理格式支持一批消息可以压缩在一起发送到服务器。这批消息将以压缩格式写入，并且在日志中保持压缩，只会在 consumer 消费时解压缩。

* **Kafka为何使用持久化？**

  （1）合理的设计方案可以大大提高持久化速度；

  （2）Kafka建立在JVM之上，对象内存开销大，而且随着堆中数据的增加，Java垃圾回收变得越来越复杂和缓慢

  （3）相比于维护尽可能多的 in-memory cache，并且在空间不足的时候匆忙将数据 flush 到文件系统，**所有数据一开始就被写入到文件系统的持久化日志中，而不用在 cache 空间不足的时候 flush 到磁盘**这一方案速度会更快，而且可以在下次启动时重新获取数据

* **Kafka的负载均衡措施**

  Topic中的patition会将一个broker（一个服务器对应一个broker）作为leader，直接处理外部请求，而设置多个follwer备份此patition，实现容错。多个partition选择不同的broker作为leader，可以实现不同broker处理不同的请求。

* **Kafka的pull-based优势和劣势？**

  consumer获取数据的方式：consumer从broker处pull数据（pull-based，典型的案例包括Kafka）；由broker将数据push到consumer（push-based，典型案例包括Scribe和Apache Flume）。

  pull-based的优势包括（1）消费者消费速度低于producer的生产速度时，push-based系统的consumer会超载；而pull-based系统的consumer自行pull数据，在生产高峰期也可以保证不会超载，在生产低谷，可以将生产的数据慢慢pull和处理；（2）push-based必须立即发送数据，不知道下游consumer是否能够处理；pull-based可以大批量生产和发送给consumer。

  pull-based的劣势包括（1）如果 broker 中没有数据，consumer 可能会在一个紧密的循环中结束轮询，实际上 busy-waiting 直到数据到来。

  

#### 5.1.2.2 MQ

* **为何使用MQ？**

  （1）实现异步处理提高系统性能（削峰、减少响应所需时间）

  <img src="/images/wiki/SomeNotes/MqAsync.jpg" width="600" alt="消息队列如何实现异步处理">

  消息队列具有很好的削峰作用的功能——即通过异步处理，将短时间高并发产生的事务消息存储在消息队列中，从而削平高峰期的并发事务。举例：在电子商务一些秒杀、促销活动中，合理使用消息队列可以有效抵御促销活动刚开始大量订单涌入对系统的冲击。

  （2）降低系统耦合性

  事件驱动架构类似生产者消费者模式，在大型网站中通常用利用消息队列实现事件驱动结构。

  <img src="/images/wiki/SomeNotes/MqConsumerProducor.jpg" width="600" alt="事件驱动结构">

  消息队列使利用发布-订阅模式工作，消息发送者（生产者）发布消息，一个或多个消息接受者（消费者）订阅消息。

## 5.2 前端技术

* **什么是V8引擎？**

  V8引擎是JS解析器之一，实现随用随解析。V8引擎为了提高解析性能，**对热点代码做编译，非热点代码直接解析**。先将JavaScript源代码转成抽象语法树，然后再将抽象语法树生成字节码。如果发现某个函数被多次调用或者是多次调用的循环体(热点代码)，那就会将这部分的代码编译优化。

* **Node.js的来源？**

  V8引擎引入到了服务器端，在V8基础上加入了网络通信、IO、HTTP等服务器函数，形成了Node.js。Node.js是运行在服务器端的JS解析器。

## 5.3 代码规范

# 6.数据结构 

