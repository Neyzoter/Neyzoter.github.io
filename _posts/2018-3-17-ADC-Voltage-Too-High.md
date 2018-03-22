---
layout: post
title: ADC过压保护电压的思考
categories: HARDWARE
description: ADC过压保护电压的思考
keywords: 
---

# 一、问题
STM32的ADC输入电压过高会烧坏引脚，需要添加过压保护。

# 二、解决方法
## 1、电阻分压
以下来自于[网友chunyang](http://bbs.eeworld.com.cn/thread-460529-1-1.html)
>看ADC的输入阻抗和信号源的驱动能力。信号源驱动能力够且ADC的输入阻抗够高可用合适的电阻直接分压。如果信号源内阻较高、驱动能力很差，则先用运放缓冲后再分压。如果信号源电压远远超过系统供电电压，那么只能先分压。

## 2、钳位电压
比如BAT45S芯片。

<img src="/images/posts/2018-3-17-ADC-Voltage-Too-High/BAT45S.png" width="300" alt="BAT45S内部图" />

但是由于二极管有压降，所以如果提供3.3V可能出现最高3.5V电压。

而且给BAT45S的钳位电压要有较好的带负载能力，不能用电阻分压。