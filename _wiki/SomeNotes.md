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

## 5.2 前端技术

* **什么是V8引擎？**

  V8引擎是JS解析器之一，实现随用随解析。V8引擎为了提高解析性能，**对热点代码做编译，非热点代码直接解析**。先将JavaScript源代码转成抽象语法树，然后再将抽象语法树生成字节码。如果发现某个函数被多次调用或者是多次调用的循环体(热点代码)，那就会将这部分的代码编译优化。

* **Node.js的来源？**

  V8引擎引入到了服务器端，在V8基础上加入了网络通信、IO、HTTP等服务器函数，形成了Node.js。Node.js是运行在服务器端的JS解析器。

## 5.3 代码规范

