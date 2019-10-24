---
layout: wiki
title: assembly
categories: asm
description: X86/ARM架构学习笔记
keywords: assembly,X86
---



# 1.X86

## 1.1 指令

* `pushal`

  将本函数的所有寄存器

## 1.1 寄存器

* AX

  累积暂存器，加法乘法指令的缺省寄存器

* BX

  基底暂存器，在内存寻址时存放基地址

* CX

  计数暂存器，是重复(REP)前缀指令和LOOP指令的内定计数器

* DX

  资料暂存器，被用来放整数除法产生的余数

* EAX/EBX/ECX/EDX

  为AX/BX/CX/DX的延伸，32位

  ```
  EAX包括AH（高8位）、AL（中间8位）、AX（低16位）
  |--AH--|--AL--|----AX----|
  |----------EAX-----------|
  ```

* SP

  堆叠指标暂存器，存放栈的偏移地址，指向栈顶

* BP

  基数指针寄存器，通过BP来寻找堆栈里数据或者地址。最经常被用作高级语言函数调用的"框架指针"(frame pointer)，在EBP上方分别是原来的EBP, 返回地址和参数. EBP下方则是临时变量。

* ESP/EBP

  是SP/BP的拓展，32位



# 2.ARM

