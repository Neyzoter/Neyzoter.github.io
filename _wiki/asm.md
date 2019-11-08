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

* IP

  存放下一个CPU指令存放的内存地址

* ESP/EBP

  是SP/BP的拓展，32位

* CS

  **在一个段寄存器Segment Register里面，会保存16位的段选择子Segment Selector，用于结合GDTR来索引段描述符表中的段描述符，下面各个段寄存器同**

  代码段寄存器(Code Segment Register)，其值为代码段的段值

* DS

  数据段寄存器(Data Segment Register)，其值为数据段的段值

* ES

  附加段寄存器(Extra Segment Register)，其值为附加数据段的段值

* SS

  堆栈段寄存器(Stack Segment Register)，其值为堆栈段的段值。

# 2.ARM

