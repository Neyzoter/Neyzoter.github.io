---
layout: post
title: Keil的Debug调试技巧
categories: Softwares
description: Keil的Debug调试技巧
keywords: Keil, Debug
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 一、查看变量
在变量上右键，并添加到watch即可

# 二、SP追踪错误
## 1.1 描述
硬件出现了非法的存储器访问（访问0地址、写只读寄存器、堆栈溢出）和非法的程序行为（除以0等）会出现进入HardFault\_Handler

## 1.2 SP追踪错误
1、将SP的数值复制到memory的Address

2、查看第21到24个字节的数字

这四个字节的数字即为进入handler前运行的代码地址。因为堆栈以此放入R0~R3、R12、PC(Return address)、xPSR(CPSR或SPSR)、LR。

由于小端模式，所以这几个数字要倒着放。比如00 21 00 08地址为0x08002100。也可以直接将memory 设置成long型（原来是char型）。

<img src="/images/posts/2018-3-8-Keil-Find-Faults/SP2addr.png" width="700" alt="用SP查找上一次运行的代码" />

3、根据上一个PC找到代码

在ASM代码右键，点击show disassembbly at address...，将2中得到的地址复制到里面go to

# 三、根据fault reports判断错误
具体的错误类型参考Keil官网：[http://www.keil.com/support/man/docs/uv4/uv4_cp_m347_faults.htm](http://www.keil.com/support/man/docs/uv4/uv4_cp_m347_faults.htm "KeilMDK Fault Reports")


<img src="/images/posts/2018-3-8-Keil-Find-Faults/faultreports.png" width="700" alt="根据fault reports判断错误" />

# 四、根据RCC_CSR判断上次复位的方式

Debug时，peripheral \-\-\-》  寄存器状态，可以一边更新RCC寄存器的数值一边Debug。

具体的复位方式对应什么位可以参考STM32的芯片参考手册。