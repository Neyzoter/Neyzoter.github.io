---
layout: post
title: Core21.0.0如何实现Debug输出
categories: AUTOSAR
description: Core21.0.0如何实现Debug输出
keywords: AUTOSAR, Debug
---

> 原创
>
> 转载请注明出处，侵权必究

# 1、串口配置



# 2、LDEBUG_PRINTF



# 3、OS_DEBUG

1.`MOD_AVAIL`添加`OS_DEBUG`

不然会报错——`OS_DEBUG`不可利用

2.`MOD_USE`添加`OS_DEBUG`

3.`MOD_USE`添加`RAMLOG`

4.`SELECT_OS_CONSOLE`定义为`RAMLOG`

5.`Os_Cfg.c`中的`os_dbg_mask`变量赋值为一定值，不屏蔽消息

