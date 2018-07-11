---
layout: post
title: STM32的BOOT模式
categories: MCU
description: STM32的BOOT模式介绍
keywords: STM32, 启动模式, BOOT
---

> 原创
> 
> 转载请注明出处，侵权必究。


# 一、启动模式

<img src="/images/posts/2018-2-27-BOOT-Mode-of-STM32/mode.png" width="700" alt="启动模式表" />

### 1.1 Main Flash memory
是STM32内置的Flash，一般我们使用JTAG或者SWD模式下载程序时，就是下载到这个里面，重启后也直接从这启动程序。

### 2.2 System memory
从系统存储器启动，这种模式启动的程序功能是由厂家设置的。一般来说，这种启动方式用的比较少。系统存储器是芯片内部一块特定的区域，STM32在出厂时，由ST在这个区域内部预置了一段BootLoader， 也就是我们常说的ISP程序， 这是一块ROM，出厂后无法修改。一般来说，我们选用这种启动模式时，是为了从串口下载程序，因为在厂家提供的BootLoader中，提供了串口下载程序的固件，可以通过这个BootLoader将程序下载到系统的Flash中。但是这个下载方式需要以下步骤：

Step1:将BOOT0设置为1，BOOT1设置为0，然后按下复位键，这样才能从系统存储器启动BootLoader

Step2:最后在BootLoader的帮助下，通过串口下载程序到Flash中

Step3:程序下载完成后，又有需要将BOOT0设置为GND，手动复位，这样，STM32才可以从Flash中启动可以看到， 利用串口下载程序还是比较的麻烦， 需要跳帽跳来跳去的，非常的不注重用户体验。

### 3.3 Embedded Memory
内置SRAM，既然是SRAM，自然也就没有程序存储的能力了，这个模式一般用于程序调试。假如我只修改了代码中一个小小的地方，然后就需要重新擦除整个Flash，比较的费时，可以考虑从这个模式启动代码（也就是STM32的内存中），用于快速的程序调试，等程序调试完成后，在将程序下载到SRAM中。

# 二、开发BOOT模式选择。

1、通常使用程序代码存储在主闪存存储器，配置方式：BOOT0=0，BOOT1=X;

2、Flash锁死解决办法：

开发调试过程中，由于某种原因导致内部Flash锁死，无法连接SWD以及Jtag调试，无法读到设备，可以通过修改BOOT模式重新刷写代码。

修改为BOOT0=1，BOOT1=0即可从系统存储器启动，ST出厂时自带Bootloader程序，SWD以及JTAG调试接口都是专用的。重新烧写程序后，可将BOOT模式重新更换到BOOT0=0，BOOT1=X即可正常使用。

# 三、电路

<img src="/images/posts/2018-2-27-BOOT-Mode-of-STM32/boot_circuit.png" width="700" alt="启动模式选择电路" />

以上为可选择的模式，由于一般采用BOOT=0的模式，所以可以直接BOOT0接地，BOOT1悬空。