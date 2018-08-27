---
layout: wiki
title: FPGA使用注意点
categories: FPGA
description: FPGA使用注意点
keywords: FPGA
---

> 原创
> 
> 转载请注明出处，侵权必究。

### 工程未使用的IO设置为三态
* 操作

Assignment->Device->Device and Pin Options->Unused Pins->Reserve all unused pins->设置为As input tri-started

* 原因

没有设置成三态有可能出现核心板主芯片及存储芯片冲突损坏，或者造成其他意想不到的损坏。（来自于睿智FPGA）


