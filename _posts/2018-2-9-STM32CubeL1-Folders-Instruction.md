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
<img src="/images/posts/2018-2-9-STM32CubeL1-Folders-Instruction/folders.png" width="300" alt="所有STM32CubeL1文件夹" />

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

微控制器专用头文件/启动代码/专用系统文件等
。
### 1.3 STM32L1xx_HAL_Driver
所有HAL库的头文件和源文件，即所有底层硬件抽象层API声明和定义。

作用：屏蔽复杂的硬件寄存器操作，统一了外设接口函数

包括c文件（Src）和h文件（Inc）。遵循stm32l1xx_hal_ppp.c/h的命名方式（ppp表示某外设）。
## 2 Middlewares

<img src="/images/posts/2018-2-9-STM32CubeL1-Folders-Instruction/Middlewares.png" width="800" alt="Middlewares文件夹" />

## 3 Projects
可以直接编译的实例工程。
## 4 Utilities
一些其他的组件

# 搭建HAL工程
## 1 Keil新建工程
工程文件放在自己工程文件夹Template的USER里。

Template包含：CORE，OBJ，HALLIB，USER

## 2 选择芯片

如果keil5弹出来 Manage Run-Time Environment，cancel即可。

## 3 USER文件夹中的Listing和Objects删除
这两个文件夹用来存放编译中间件的文件，我们用不到

我们会在OBJ中存放编译中间件的文件

## 4 Inc,Src  ->  HALLIB
STM32Cube_FW_L1_V1.8.0\\Drivers\\STM32L1xx_HAL_Driver中的h和c文件夹（Inc和Src）复制到HALLIB

## 5 启动文件,关键头文件   ->   CORE
STM32Cube_FW_L1_V1.8.0\\Drivers\\CMSIS\\Device\\ST\\STM32L1xx\\Source\\Templates\\arm中的**.s 启动文件**复制到CORE

STM32Cube_FW_L1_V1.8.0\\Drivers\\CMSIS\\Include中的**（Cortex-M内核及其设备文件）**cmsis_armcc.h，core_cm3.h ，core_cmFunc.h ，core_cmInstr.h  ，core_cmSimd.h（根据不同的内核选择core_cm3、cm4等）

## 6 其他文件   ->    USER
STM32Cube_FW_L1_V1.8.0\Drivers\CMSIS\Device\ST\STM32L1xx\Include中的**（微控制器专用头文件/启动代码/专用系统文件等）**stm32l1xx.h，system_stm32l1xx.h 和 stm32L152xe.h复制到USER

STM32Cube_FW_L1_V1.8.0\Projects\STM32L152RE-Nucleo\Templates\Inc中的stm32l1xx_it.h，stm32l1xx_hal_conf.h 和main.h复制到USER

STM32Cube_FW_L1_V1.8.0\Projects\STM32L152RE-Nucleo\Templates\Src中的system_stm32l1xx.c，stm32l1xx_it.c, stm32l1xx_hal_msp.c 和 main.c复制到USER

## 7 系统SYSTEM文件夹
可以从原子F429的工程文件夹中拿到SYSTEM文件夹放到Template中

## 8 加入工程
选中keil工程的Target 1 \-》Manage Project Items  \-》 Target 改为Template  \-》Group删掉默认的，加上四个CORE、SYSTEM、HALLIB和USER

HALLIB  \-》  添加HALLIB中Src所有的c文件。当然也可以只添加我们需要的c文件。

USER \-》 添加USER其中的c文件。

SYSTEM \-》 添加SYSTEM中各个文件夹的c文件。

CORE  \-》  添加s启动文件和h文件

## 9 设置头文件存放路径
魔术棒  \-》  C/C++  \-》  把h文件的所有最后一级文件夹目录加进去

并把Define  填上  STM32L152xE,USE_STM32L1XX_NUCLEO,USE_HAL_DRIVER   ，文件会用到它。

## 10 把编译文件放到OBJ中
魔术棒  \-》 Target  \-》 Select  Folder  for Objects..  \-》 选择OBJ文件夹。

同时勾上  Create HEX File（生成HEX文件）和Browse Information（方便查看工程中的变量定义）。

## 11 STM32L1-Nucleo的板载c文件
把Nucleo的板载c文件放到你的文件夹，同时像上面一样加入到工程中

最后编译即可。