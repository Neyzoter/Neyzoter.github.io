---
layout: post
title: STM32外部晶振引脚的连接
categories: MCU
description: 如果不需要外部晶振时，STM32外部晶振引脚的连接方法
keywords: STM32, MCU, OSC
---

# HSE
### 连接方法
>以下官方电路

 <img src="/images/posts/2018-3-15-STM32-OSC-Pins-Connect/HSE_OSC.png" width="600" alt="STM32L1的HSE晶振连接方法" />

>以下官方参考手册PDF

 <img src="/images/posts/2018-3-15-STM32-OSC-Pins-Connect/HSE_LSE_ST.png" width="600" alt="STM32L1的HSE晶振连接方法" />
### 不连接的注意点
1、问题

未知？？？

2、方法
以下来自于网上：

>1）对于100脚或144脚的产品，OSC_IN应接地，OSC_OUT应悬空。
>2）对于少于100脚的产品，有2种接法：
>2.1）OSC_IN和OSC_OUT分别通过10K电阻接地。此方法可提高EMC性能。
>2.2）分别重映射OSC_IN和OSC_OUT至PD0和PD1，再配置PD0和PD1为推挽输出并输出'0'。此方法可以减小功耗并(相对上面2.1)节省2个外部电阻。

# LSE
### 连接方法
<img src="/images/posts/2018-3-15-STM32-OSC-Pins-Connect/LSE_OSC.png" width="600" alt="STM32L1的LSE晶振连接方法" />
### 不连接的注意点和方法
1、注意点

不连接容易出现系统卡死。

2、方法

？？？？未知

# 官方推荐晶振

<img src="/images/posts/2018-3-15-STM32-OSC-Pins-Connect/OSC_Recomanded.png" width="500" alt="STM32L1的LSE和HSE晶振推荐" />