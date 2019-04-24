---
layout: post
title: STM32栈溢出问题分析
categories: MCU
description: STM32栈溢出问题分析
keywords: STM32, 栈, 启动项
---

## 1、问题描述
通过wifi模组发送数据时，发现经常出现wifi数据全0，或者许多0的情况。甚至有的时候出现MCU运行崩溃。

## 2、问题发现

### 2.1 STM32的一些存储结构
**Code**

程序

**RO-data**

RO_data表示只读数据域，程序中用到的只读数据、全局变量，例如C语言中const关键字定义的全局变量。

**ZI-data**

ZI-data（ZeroInitial data）即初始化为0值的可读写数据域。

**RW-data**

RW-data（ReadWrite data）即初始化为**非0值**的可读写数据域。和ZI-data的区别是此类数据初始化非0，ZI-data初始化为0。**ZI-data和RW-data均存储在RAM，供程序读取和修改**

## STM32的启动
初始化汇编文件包含栈的初始化，栈用于存储局部变量。

而我们在发送wifi数据时需要将大量数据打包，形成一个局部变量，造成栈溢出。

```asm
Stack_Size EQU 0x00000800
```

**解决方案**：

将栈改大，

```asm
Stack_Size EQU 0x00002000
```

