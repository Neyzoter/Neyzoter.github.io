---
layout: post
title: Verilog HDL的阻塞和非阻塞式赋值语句
categories: FPGA
description: Verilog HDL的阻塞和非阻塞式赋值语句
keywords: FPGA, Verilog, 阻塞赋值, 非阻塞赋值
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、阻塞和非阻塞式赋值的介绍
## 1.1 阻塞式赋值
阻塞式赋值用符号“=”表示。赋值语句可表示为   LHS = RHS，其中LHS表示赋值等号左边的变量，RHS表示赋值等号右边的表达式。

赋值时，先计算等号右手边的RHS然后赋值语句赋值。这段时间，不允许任何别的Verilog语句的干扰，直到赋值语句的完成。

注意点：一般可综合的阻塞赋值操作在RHS不能设定有延时，会导致在延时期间组织赋值语句的执行，延时后才能执行赋值，这种赋值语句是不可综合的。

## 1.2 非阻塞语句
非阻塞式赋值用符号“<=”表示。赋值语句可表示为  LHS<=RHS。

（1）复制开始时刻，计算等号右手边的RHS（2）复制操作结束时刻，更新LHS。

注意点：非阻塞式复制操作只能用于对寄存器类型变量进行赋值，因此只能在initial和always等过程块中使用，而非阻塞式不允许用于连续赋值（assign）。

# 2、例子
## 2.1 阻塞式赋值例子

```Verilog
module fbosc1(y1,y2,clk,rst);
	output y1,y2;
	input clk,rst;
	reg y1,y2;
	
	always@(posedge clk or posedge rst)
		if(rst) y1 = 0;
		else y1 = y2;
	
	always@(posedge clk or posedge rst)
		if(rst) y2 = 1;
		else y2 = y1;
endmodule 
```

（1）复位，y1=0，y2=1。并且rst归0。

（2）当下一个clk上升沿到来，有可能到达两个always块的时间不同。

如果clk先到第一个always（几个ps），则y1=y2就是y1=1；clk再到第二个always时，被阻塞，直到第一个always中的阻塞赋值语句y1=y2执行完毕。那么第二个always语句中的y2=y1就是得到y2=1。从而，y1和y2都是1。

如果clk先到第二个always，则y2=y1就是y1=0；clk再到第一个always时，被阻塞，直到第一个always中的阻塞赋值语句y2=y1执行完毕。那么第二个always语句中的y1=y2就是得到y2=0。从而，y1和y2都是0。

综上所述，该模块不稳定，会产生竞争和冒险的情况。

<img src="/images/posts/2018-5-28-Verilog-Blocking-Nonblocking-Assignment/blocking-simu.png" width = "700"  alt="阻塞式赋值仿真效果"  />

## 2.2 非阻塞式赋值例子

```Verilog
module fbosc1(y1,y2,clk,rst);
	output y1,y2;
	input clk,rst;
	reg y1,y2;
	
	always@(posedge clk or posedge rst)
		if(rst) y1 = 0;
		else y1 = y2;
	
	always@(posedge clk or posedge rst)
		if(rst) y2 = 1;
		else y2 = y1;
endmodule 
```

（1）复位，y1=0，y2=1。并且rst归0。

（2）无论clk先到哪个always块，两个always块中的非阻塞赋值都在赋值开始时刻计算RHS表达式，而在结束时刻才更新LHS。

<img src="/images/posts/2018-5-28-Verilog-Blocking-Nonblocking-Assignment/nonblocking-simu.png" width = "700"  alt="非阻塞式赋值仿真效果"  />