---
layout: post
title: FreeRTOS学习笔记(1)FreeRTOS简介
categories: RTOS
description: FreeRTOS学习笔记(1)FreeRTOS简介
keywords: FreeRTOS
---

> 原创
> 
> 转载请注明出处，侵权必究。


# 1、FreeRTOS特点
1）文件数量比UCOS（II和III）小很多；
2）内核抢占式、合作式和时间片调度；
3）提供低功耗的Tickless模式；
4）系统的组件在创建时可以选择动态或者静态的RAM，比如任务、消息队列、信号量软件定时器等；
5）FreeRTOS-MPU支持Cortex-M系列中的MPU单元；
6）简单小巧易用，通常内核占用4K-9K字节的空间；
7）具有优先级继承特性的互斥信号量；
8）堆栈溢出检测；
9）任务数量不限；
10）任务优先级不限。

# 2、官方源码文件夹介绍
## FreeRTOS文件夹
* Demo

官方移植的不同设备的FreeRTOS程序。

* License

相关许可信息。

* Source

源码

说明：

>源码中的Source文件夹中包含了移植需要的源码，其中portble文件夹中的文件包含了不同的编译器对应的源码，只需要留下需要的即可。
比如要用keil来编译，那么keil文件夹中说参考RVDS，我们只需要将RVDS中的源码复制到Keil文件夹中，把除了keil和MemMang文件夹之外的删除即可。

## FreeRTOS文件夹
包含许多在FreeRTOS源码基础上添加的功能块。



