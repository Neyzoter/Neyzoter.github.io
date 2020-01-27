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

# 2.ucore内核进程管理

内核进程不需要进行优先级切换，变量常驻内存当中，也就不需要进行虚拟内存管理，相对来说更加简单。

ucore的内核进程首先会创建一个空闲进程，而后会创建一个内核进程。（[ucore的Lab4](https://github.com/Neyzoter/ucore_os_lab/tree/master/labcodes_answer/lab4_result)，内核创建第0个进程即空闲进程，第1个内核进程）下面对该实验进行解析和理解。



# 3.ucore用户进程管理