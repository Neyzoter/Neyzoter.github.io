---
layout: post
title: STM32CubeL1的文件夹结构和工程搭建
categories: MCU
description: STM32CubeL1的文件夹介绍
keywords: STM32, Cube, HAL, 低功耗
---

> 原创
> 
> 转载请注明出处，侵权必究。

# STM32Cube_FW_L1_V1.8.0
## 1 Drivers
### 1.1 BSP
板级支持包，提供直接与硬件打交道的API，例如触摸板、LCD、SRAM以及EEPROM等板载硬件资源（根据不同的评估板）等驱动。
### 1.2 CMSIS
符合 CMSIS 标准的软件抽象层组件相关文件。
#### 1.2.1 DSP_Lib
DSP库。
#### 1.2.2 Include
Cortex-M内核及其设备文件。
#### 1.2.3 Device 
微控制器专用头文件/启动代码/专用系统文件等。
### 1.3 STM32L1xx_HAL_Driver
所有HAL库的头文件和源文件，即所有底层硬件抽象层API声明和定义。

作用：屏蔽复杂的硬件寄存器操作，统一了外设接口函数

包括c文件（Src）和h文件（Inc）。遵循stm32l1xx_hal_ppp.c/h的命名方式（ppp表示某外设）。
## 2 Middlewares
<img src="/images/posts/2018-2-9-STM32CubeL1-Folders-Instruction/Middlewares.png" width="800" alt="Middlewares文件夹" />

<img src="/images/posts/2018-2-9-STM32CubeL1-Folders-Instruction/folders.png" width="300" alt="所有STM32CubeL1文件夹" />