---
layout: post
title: STM32L1的时钟
categories: MCU
description: STM32L1的时钟介绍
keywords: STM32L1, 时钟
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 时钟树

<img src="/images/posts/2018-2-11-Clocks-of-STM32L1/clocktree.png" width="400" alt="时钟树" />

### 系统时钟的四个时钟源
* HSI（High -speed internal）时钟振荡器

高速内部时钟：来自于内部的16MHz晶振，启动时间快于高速外部时钟，但是精确度不如高速外部时钟。30摄氏度下1%误差。

* HSE（High-speed external）时钟振荡器

高速外部时钟：来自于外部时钟或者外部晶振。（具体见STM32L1xx参考手册）

* PLL时钟

来自于HSI或者HSE晶振，用于系统时钟并为USB外围生成48MHz的时钟。

PLL输入必须是2~24MHz


* MSI（Multispeed internal）时钟振荡器

MSI被用于重启、唤醒或者待机低功耗模式下作为系统时钟

MSI来自于内部RC振荡器。可设置为65.536 kHz, 131.072 kHz, 262.144 kHz, 524.288 kHz, 1.048 MHz, 2.097 MHz (默认值) and 4.194 MHz。30摄氏度下1%误差。

### 设备的二级时钟源
* LSI RC

37KHz 低速内部RC（Low-speed internal RC）

用于独立看门口或选做RTC时钟将设备从停止模式或者待命模式自动唤醒

* LSE 晶振

32.768KHz低速外部晶振可被选做实时时钟RTCCLK

### 说明

#### 1 所有外设时钟都来自于系统时钟

除了：（见时钟树图）

1、USB和SDIO的48MHz，来源于PLL VCO时钟

2、ADC时钟总是HSI时钟

3、RTC和LCD时钟来自于LSE、LSI或者1MHz的HSE_RTC（HSE被程序分频）

4、独立看门狗（independent watch dog，IWDG）时钟总是来自于LSI

#### 2 系统时钟频率
应该高于或者等于RTC/LCD的时钟频率

#### 3 SysTick滴答时钟
RCC（Reset and Clock Control）提供AHB时钟（HCLK）经过8分频给Cortex SystemTimer（滴答时钟）外部时钟

SysTick要么用HCLK，要么配置SysTick控制或者状态寄存器。