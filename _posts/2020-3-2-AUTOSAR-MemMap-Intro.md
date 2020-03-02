---
layout: post
title: AUTOSAR的MemMap介绍
categories: Life
description: AUTOSAR的MemMap介绍
keywords: AUTOSAR, MemMap
---



> 原创

# 1.MemMap介绍

对于许多ECU而言，**内存映射（MemMap）**是非常重要的，具体包括以下优点：

1. 避免RAM的浪费

   在同一个模块下定义了不同类型的变量（比如8bit、16bit、32bit），则为了对齐，会在不同类型变量间留间隙。比如8bit变量和32bit变量存放在一起，在两个变量都要对齐到32bit。

2. 特殊RAM用途

   比如一些变量通过位掩码来获取，如果map到RAM可以通过编译器的位掩码功能来加快执行效率

3. 特殊ROM用途

   一些频繁执行的函数可以映射到RAM中，而不经常执行的函数可以映射到外部ROM。

4. 同一段代码用在bootloader和应用

   如果同一个模块同时需要被bootloader和应用使用，则需要同时映射到不同的段中

5. 支持内存保护

   使用硬件存储器保护需要将模块变量分离到不同的存储器区域。内部变量映射到受保护的内存中，用于数据交换的缓冲区映射到不受保护的内存中。

6. 支持分区

   可以将一个模块的变量映射到不同的分区中