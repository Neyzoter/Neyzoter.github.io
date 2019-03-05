---
layout: post
title: HTTP和HTTPS的基本技术介绍
categories: IoT
description: HTTP和HTTPS的基本介绍
keywords: HTTP, HTTPS, Network
---

## 1、HTTP
HTTP目前（截止到2019年3月5日）主要有三个版本，即HTTP/1.0、HTTP/1.1、HTTP/2，HTTP-over-QUIC有望成为HTTP/3。

### 1.1 HTTP一般流程 
**1、建立连接**

根据用户输入的URL地址，通过DNS、负载均衡等技术找到一台服务器，客户端与服务器的80端口建立一个TCP链接。

**2、进行请求**

客户端向服务器发送消息，请求URL中指定的页面，要求执行指定的操作。

请求包括**GET**、**POST**、**HEAD**等。

**3、响应**

服务器向客户端发送响应。响应以状态码开头。常见的状态码有：200、302、404、500等。

HTTP状态码由三个十进制数字组成，第一个十进制数字定义了状态码的类型，后两个数字没有分类的作用。HTTP状态码共分为5种类型：

|**分类**|**分类描述**|
|-|-|
|1\*\*|信息，服务器收到请求，需要请求者继续执行操作|
|-|-|
|2\*\*|成功，操作被成功接收并处理|
|-|-|
|3\*\*|重定向，需要进一步的操作以完成请求|
|-|-|
|4\*\*|客户端错误，请求包含语法错误或无法完成请求|
|-|-|
|5\*\*|服务器错误，服务器在处理请求的过程中发生了错误|

**4、关闭连接**

服务器不回记忆前面一次连接或者其结果，这种不记忆过去请求的协议被称为无状态(stateless)协议。

### 1.2 HTTP版本
* **HTTP/1.0**

HTTP/1.0规定浏览器与服务器只保持短暂的连接，浏览器的每次请求都需要与服务器建立一个TCP连接，服务器完成请求处理后立即断开TCP连接

* **HTTP/1.1**

1.相比较于HTTP/1.0来说，最主要的改进就是引入了持久连接。所谓的持久连接即TCP连接默认不关闭，可以被多个请求复用。

2.HTTP/1.1版还引入了**管道机制**（pipelining），即在同一个TCP连接里面，客户端可以同时发送多个请求。

<img src="/images/posts/2019-3-5-HTTP-Version/HTTP1.1-Pipelining.webp" width="600" alt="HTTP的管道机制" />

* **HTTP/2**

 1.为了提高HTTP1.1的效率，HTTP2采用了**多路复用**。即在一个连接里，客户端和浏览器都可以同时发送多个请求或回应，而且不用按照顺序一一对应。能这样做有一个前提，就是HTTP/2进行了**二进制分帧**，即 HTTP/2 会将所有传输的信息分割为更小的消息和帧（frame）,并对它们采用二进制格式的编码。

<img src="/images/posts/2019-3-5-HTTP-Version/HTTP1.1 HTTP2.webp" width="600" alt="HTTP1.1和2的对比" />

2.**Header压缩**：压缩老板和员工之间的对话。

3.**服务端推送**：员工事先把一些老板可能询问的事情提现发送到老板的手机（缓存）上。这样老板想要知道的时候就可以直接读取短信（缓存）了。

* **HTTP-over-QUIC**

QUIC （Quick UDP Internet Connections）是 Google 推出的一个项目，旨在降低基于 TCP 通讯的 Web 延迟。QUIC 非常类似 TCP+TLS+SPDY ，但是基于 UDP 实现的。

<img src="/images/posts/2019-3-5-HTTP-Version/OverTCPandTLScmpQUIC.png" width="600" alt="HTTPS基于TCP和TLS与基于QUIC的比较" />

* **HTTP版本比较**

<img src="/images/posts/2019-3-5-HTTP-Version/pics.webp" width="700" alt="几个HTTP版本的比较" />

## 2、HTTPS
HTTPS是Hypertext Transfer Protocol Secure的缩写，翻译为超文本传输安全协议。HTTPS经由HTTP进行通信，但利用SSL/TLS来加密数据包。

HTTP的URL是由“http://”起始与默认使用端口80，而HTTPS的URL则是由“https://”起始与默认使用端口443。


