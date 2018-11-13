---
layout: post
title: SVC和PendSV的作用
categories: MCU
description: SVC和PendSV的作用
keywords: SVC,PendSV
---

> 转帖
> 
> https://blog.csdn.net/guozhongwei1/article/details/49544671

# 1、SVC（系统服务调用）

用于产生系统函数的调用请求。例如操作系统不让用户程序直接访问硬件，而是通过提供一些系统服务函数，用户程序使用SVC 发出对系统服务函数的呼叫请求，以这种方法调用它们来间接访问硬件。因此，当用户程序想要控制特定的硬件时，它就会产生一个SVC异常，然后操作系统提供的SVC异常服务例程得到执行，它再调用相关的操作系统函数，后者完成用户程序请求的服务。 

<img src="/images/posts/2018-5-2-SVC-and-PendSV/SVC.png" width="600" alt="SVC作为操作系统门户的示意图"/>

# 2、PendSV（可悬起的系统调用）

和SVC协同使用。SVC异常必须立即得到响应（如果因优先级不比当前正处理的高，或是其他原因使之无法立即响应，则上访成硬fault）。而PendSV不同，可以像普通中断一样被悬起（不会像SVC那样会上访）。OS可以利用它“缓期执行”一个异常，知道其他重要的任务完成后才执行动作。

方法：手工网NVIC的PendSV悬起寄存器写1。悬起后，如果优先级不够高，则将缓期执行。

PendSV典型应用：上下文切换。

如果一个系统通过Systick异常启动上下文切换，则可能出现正在响应另一个异常，Systick会抢占ISR（Interrupt Service Routines，中断服务程序）。OS不允许中断过程中执行上下文切换。如下图。

<img src="/images/posts/2018-5-2-SVC-and-PendSV/IRQ_happened.png" width="600" alt="IRQ发生时，上下文切换的问题"/>

而PendSV能悬起，很好的解决该问题。

<img src="/images/posts/2018-5-2-SVC-and-PendSV/PendSVControlContext.png" width="600" alt="PendSV控制上下文切换"/>

# 3、例子

1、任务 A 呼叫SVC 来请求任务切换（例如，等待某些工作完成）

2、OS 接收到请求，做好上下文切换的准备，并且pend 一个PendSV 异常。

3、当 CPU 退出SVC 后，它立即进入PendSV，从而执行上下文切换。

4、当 PendSV 执行完毕后，将返回到任务B，同时进入线程模式。

5、发生了一个中断，并且中断服务程序开始执行

6、在 ISR 执行过程中，发生SysTick 异常，并且抢占了该ISR。

7、OS 执行必要的操作，然后pend 起PendSV 异常以作好上下文切换的准备。

8、当 SysTick 退出后，回到先前被抢占的ISR 中，ISR 继续执行

9、ISR 执行完毕并退出后，PendSV 服务例程开始执行，并且在里面执行上下文切换

10、当 PendSV 执行完毕后，回到任务A，同时系统再次进入线程模式。