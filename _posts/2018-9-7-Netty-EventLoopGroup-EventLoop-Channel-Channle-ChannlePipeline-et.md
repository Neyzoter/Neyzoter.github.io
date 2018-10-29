---
layout: post
title: 对Netty组件的理解（Channel、Pipeline、EventLoop等）
categories: Java
description: 我对于Netty的组件——Channel、Pipeline、EventLoop等的理解
keywords: Java, Netty, Java框架
---

# 1、介绍
## 1.1 Channel
Channel是Java NIO的一个基本构造：

>它代表了一个到实体（如一个硬件设备、一个文件、一个网络套接字或者一个能够执行一个或者多个不同的IO操作的程序组建）的开放连接，如读操作和写操作。

可以把Channel看作是传入（入站）或者传出（出站）数据的载体。

**我的感悟**

每个TCP连接socket都会对因一个Channel，创建过程如下：

<img src="/images/posts/2018-9-7-Netty-EventLoopGroup-EventLoop-Channel-Channle-ChannlePipeline-et/ChannelEventIO.jpg" width="700" alt="Channel的创建过程" />

* 第一步，TCP连接时，会自动生成Channel。

会自动调用ServerBootstrap设置的ChannelInitializer类中的initChannel方法。这个方法可以重写，主要可以写Channel对因的ChannelPipelinePipeline（**每个Channel都会有一个ChannelPipeline**）中添加哪写处理器（ChannelHandler，主要用于入站或者出站的数据）、编解码器等。

* 第二步，Channel注册到EventLoopGroup

一般会单独分配一个EventLoop给一个Channle。但是并不是一个EventLoop对因一个Channel，也有可能一个EventLoop中有多个Channel。

另外要说明的是，**EventLoopGroup中包含多个EventLoop，每个EventLoop对因一个线程。在EventLoop（一个线程）中采用循环事件方式执行，也就是轮循。**

* 第三步，Channel激活，并在整个生命周期中由对应的EventLoop处理。

## 1.2 ChannelPipeline
ChannelPipeline是一个拦截流经Channel的入站和出站事件的 **ChannelHandler实例链** （说白了，就是用来装方法的，这些方法用来处理Channel传过来数据）。

每个新创建的Channel都会被分配一个新的ChannelPipeline（注：一对一）。这项关联时永久性的，Channel既不能附加另外一个ChannelPipeline，也不能脱离当前的Pipeline。

pipeline在创建的时候，还包含一个ChannelInitializer相关的handler，创建完成后自动删除这个handler。

pipeline见下图。

<img src="/images/posts/2018-9-7-Netty-EventLoopGroup-EventLoop-Channel-Channle-ChannlePipeline-et/ChannelPipeline.jpg" width="700" alt="Pipeline和处理器 " />

注：数据处理后出Pipeline，就会通过Channel传出去；进Channel后，也会经过Pipeline处理。

**如何转发UDP客户端的发过来消息到TCP客户端**

首先要说明的是，服务器的UDP引导（Bootstrap，适用于无连接传输协议）和TCP引导（ServerBootstrap，适用于基于连接的传输协议）不是同一个。可以通过将TCP连接的Channel保存在一个Map中。然后，在UDP的Channel接收到消息后，会进入处理器handler。最后遍历Map中的基于TCP的Channel（每个Channel对因一个连接），使用Channel(或者Pipeline)的writeAndFlush()来发送。也就是说，*如果我们把TCP在别的Pipeline(线程、对象等)处理器里可以直接调用别的Pipeline(Channel).writeAndFlush发数据，但是数据需要转成ByteBuf格式*

**如果在一个pipeline中使用多个处理器**

在调用initChannel的时候，需要对应添加handler。每次进入一个handler的read方法，都会带有一个context对象。调用context的fireChannelRead()就会发送给下一个handler。

channel\-pipeline\-context的工作结构如下所示。

<img src="/images/posts/2018-9-7-Netty-EventLoopGroup-EventLoop-Channel-Channle-ChannlePipeline-et/ChannelhandlercontextWork.jpg" width="700" alt="Channel、Pipeline和ChannelContext的工作结构 " />

## 1.3 引导
引导包括ServerBootstrap和Bootstrap。ServerBootstrap主要面向有连接的协议，Bootstrap主要面向无连接的协议。

而且ServerBootstrap还需要两个EventLoopGroup，一个用于监听是否有客户端连接，一个用于管理已经连接的客户端。如下图。

<img src="/images/posts/2018-9-7-Netty-EventLoopGroup-EventLoop-Channel-Channle-ChannlePipeline-et/ServerWith2EventLoopGroups.jpg" width="700" alt="2个EventLoopGroup的服务器引导" />

## 1.4 事件循环
EventLoop也就是事件循环，EventLoopGroup是一个包含了多个EventLoop（线程）的事件循环组。

每个EventLoop可以管理多个Channel，但是Channel是以轮循的方式管理的。如果不是在一个EventLoop中的Channel，则用不同的线程管理。

为什么要这么做呢？

因为如果连接量过多，线程切换带来的消耗会很大，在一个EventLoop中轮循会减小上下文切换的消耗。

