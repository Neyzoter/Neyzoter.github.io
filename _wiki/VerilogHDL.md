---
layout: wiki
title: Verilog HDL
categories: Verilog HDL
description: Verilog HDL语言的注意事项
keywords: FPGA,Verilog HDL
---

# 1、RTL设计需要注意的问题
1．凡是在 always 或 initial 语句中赋值的变量，一定是 reg 类型变量；凡是在 assign 语句中赋值的变量，一定是 wire 类型变量。

2． 定义存储器：reg [3:0] MEMORY [0:7]; 地址为 0~7，每个存储单元都是 4bit。

3．由于硬件是并行工作的，在 Verilog 语言的 module 中，所有描述语句（包括连续赋值语句 assign、行为语句块 ways 和 initial 语句块以及模块实例化）都是并发执行的。

4．使用完备的 if…else 语句，使用条件完备的 case 语句并设置 default 操作，以防止产生锁存器 latch，因为锁存器对毛刺敏感。

5．严禁设计组合逻辑反馈环路，它最容易引起振荡、毛刺、时序违规等问题。

6．不要在两个或两个以上的语句块（always 或 initial）中对同一个信号赋值。

# 2、阻塞与非阻塞赋值语句
## 2.1 简介
<=：非阻塞赋值语句，可以同时运行

=：阻塞赋值语句，每次只能执行一个阻塞赋值语句，有先后顺序

## 2.2 特殊情况

```Verilog
//过程1
always@(posedge clk or negedge rst_n)
	begin
		if(rst_n==1'b0)
			y = 1'b0;
		else
			y = x;
	end

```

```Verilog
//过程2
always@(posedge clk or negedge rst_n)
	begin
		if(rst_n==1'b0)
			x = 1'b0;
		else
			x = y;
	end

```

如果过程2先执行，复位后，xy的值最终变成1；如果过程1先执行，复位后，xy的值最终变成0。

在使用过程中，尽量避免这种用法。在Verilog中没有规定这种特殊情况下的执行情况。

# 3、不可综合的语句
相除、开方、指数

# 4、代码优化
## 4.1 Pipelining技术
流水线时序优化技术，本质是调整一个较大的组合逻辑路径中的寄存器位置，用寄存器合理分割该组合逻辑路径，从而降低路径Clock-To-Output和Setup等时间参数的要求，达到提高设计频率的目的。

操作方法：

对时延较大的组合逻辑，在它旁路上加上若干需要优化的寄存器，然后运用优化工具自动将大组合逻辑差分成几个小的组合逻辑，同时将寄存器放在小组合逻辑中间。

<img src="/images/wiki/VerilogHDL/Auto.png" width="600" alt="工具自动优化" />

## 4.2 模块复用
能用简单模块代替则代替。

比如乘法器很耗费资源。

```Verilog HDL
//需要两个乘法器
assign square=(data_in[7])? (data_bar*data_bar) : (data_in*data_in);
```

可代替为

```Verilog HDL
//需要一个乘法器
assign data_tmp = (data_in[7])? (~data_in + 1) : data_in;
assign square = data_tmp * data_tmp;
```




