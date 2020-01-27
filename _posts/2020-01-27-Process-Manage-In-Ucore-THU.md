---
layout: post
title: 清华ucore操作系统的进程管理解析
categories: OS
description: 清华ucore操作系统的进程管理解析
keywords: OS, 清华, ucore, 进程
---

> 未完待续

# 1.ucore操作系统

ucore操作系统是清华大学计算机系为了课程需求而维护的一个简单的操作系统。ucore的[Github仓库地址](https://github.com/chyyuu/ucore_os_lab)，另外我维(学)护（习）的ucore [Github仓库地址](https://github.com/Neyzoter/ucore_os_lab)。不同于清华的ucore仓库，我的ucore仓库添加了许多中文注释，甚至修复了小的问题。不过，不得不说的是，清华大学的计算机课程真的很硬核！国内其他高校，甚至一些985高校都还需要进一步在教学上提高。

本文章从ucore操作系统的角度来解析操作系统是如何管理进程的。

# 2.ucore内核线程管理

内核线程不需要进行优先级切换，变量常驻内存当中，虚拟内存管理作用不大，故相对用户进程来说更加简单。而用户进程各自管理虚拟内存，互不干扰。当然，一个用户进程内部还可能包含多个线程，线程之间分享内存空间。而操作系统的内核线程通过线程控制块TCB来进行管理。线程控制块是一个数据结构，包含诸多线程相关信息，如名称、mm、pid等。

ucore的内核进程首先会创建一个空闲进程，而后会创建一个内核进程。（[ucore的Lab4](https://github.com/Neyzoter/ucore_os_lab/tree/master/labcodes_answer/lab4_result)，内核创建第0个进程即空闲进程，第1个内核进程）下面对该实验进行解析和理解。

## 2.1 内核线程总体运行流程

1. 每个内核线程都会对应一个线程控制块
2. 线程控制块通过链表链接起来，便于进行遍历、插入、删除等操作
3. 调度器通过县城控制块来使得不同内核线程在不同的时段占用CPU

## 2.2 内核线程运行细节

* **虚拟内存初始化**

  [具体说明](http://neyzoter.cn/2020/01/11/Memory-Manage-In-Ucore-TU/)

* **内核线程创建**

  主要在函数`proc_init @ proc.c`中运行

  1. 初始化PCB列表头

     此处也可以说是TCB。具体而言，初始化工作即将PCB的头尾相连

  2. 初始化PCB Hash表

     具体而言是将N个PCB列表头存放在数组中，对数组中每个PCB列表头进行初始化

     ```c
         for (i = 0; i < HASH_LIST_SIZE; i ++) {
             list_init(hash_list + i);
         }
     ```

     ```
         list1         list2       list3        list4        list5
     |------------|------------|------------|------------|------------|
       |_______|    |_______|    |_______|    |_______|    |_______|  
     ```

  3. 给空闲线程分配PCB空间并进行初始化

     `alloc_proc @ proc.c`

  4. 设置空闲线程为当前线程current

  5. 创建第1个内核线程

     1. 初始化trap frame

     2. fork

        分配PCB空间

        分配内核堆栈（物理）

        设置PID

        设置Hash 表

        PCB加入到PCB列表中

        设置为可运行

* **线程运行**

  空闲任务内，进行线程的调度`schedule @ sched.c`

# 3.ucore用户进程管理