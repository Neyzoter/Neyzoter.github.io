---
layout: post
title: STM32L152系列的代码移植
categories: MCU
description: STM32L152系列的移植
keywords: STM32, 移植
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 说明
如果内核相同，则不需要更换内核。在STM32L152系列中，内核等大部分的文件相同。不同的是不同芯片的外设，如RAM大小、Flash大小等。

# 移植
只需要更换启动.s文件和设备的描述.h文件。

# 备注
其他的同一类型的如STM32F1xx、STM32F4xx等相同的系列，只需要更改启动文件和设备描述文件即可。