---
layout: post
title: STM32L1的待机模式实践
categories: MCU
description: STM32L1的待机模式实践
keywords: STM32L1, 低功耗, 待机
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1 待机模式实现回顾
## 1.1 电源控制寄存器PWR_CR介绍
<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/CWUFandPDDS.png" width="600" alt="PWR_CR寄存器的CWUF和PDDS位" />

* CWUF：将唤醒标志清零，clear wakeup flag，总是读到0。

0：没有作用

1：在两个系统时钟周期后，清除WUF唤醒标志位

* PDDS：深度睡眠掉电，power-down deepsleep

0：CPU深度睡眠时进入停止模式

1：CPU深度睡眠时进入待机模式

该寄存器我们只关心 bit1 和 bit2 这两个位，这里我们通过设置PWR_CR的PDDS位，使CPU进入深度睡眠时进入待机模式，同时我们通过CWUF位，清除之前的唤醒位。

## 1.2 电源控制/状态寄存器PWR_CSR介绍
<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/PWR_CSR.png" width="600" alt="PWR_CSR寄存器" />

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/WUF.png" width="600" alt="PWR_CSR寄存器的WUF" />

WUF位是唤醒标志位，由硬件置1，系统复位或者CWUF位（PWR_CR寄存器中）置1来清除。

0：没有唤醒时间发生

1：从WAUP引脚、RTC闹钟、RTC入侵、RTC时间戳或者RTC唤醒，得到一个唤醒事件。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/EWUP123.png" width="600" alt="PWR_CSR寄存器的EWUP1 2 3" />

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/STM32L15xREpinout.png" width="600" alt="STM32L15xRE的引脚图" />

这里，我们通过设置 PWR_CSR 的 EWUP 位，来使能 WKUP 引脚用于待机模式唤醒。我们还可以从 WUF 来检查是否发生了唤醒事件，不过本章我们并没有用到。

对于使能了RTC闹钟中断或RTC周期性唤醒等中断的时候，进入待机模式前，必须按如下操作处理：

1， 禁止 RTC 中断（ALRAIE、ALRBIE、WUTIE、TAMPIE 和 TSIE 等）。

2， 清零对应中断标志位。

3， 清除 PWR 唤醒(WUF)标志（通过设置 PWR_CR 的 CWUF 位实现）。

4， 重新使能 RTC 对应中断。

5， 进入低功耗模式。

# 2 待机模式实践
## 2.1 wakeup中断唤醒
STM32L152RET6的wakeup引脚：PA0（WKUP1）、PC13（KUP2）

开始前将引脚配置为外部中断，并且优先级较低。

具体配置步骤：

1)使能pwr时钟

```
__HAL_RCC_PWR_CLK_ENABLE();
```

2)设置WKUP为唤醒源,并清除唤醒标志位

```
HAL_PWR_EnableWakeUpPin(PWR_WAKEUP_PIN2);//这里是PC13，看是按键连接什么
SET_BIT(PWR->CR, PWR_CR_CWUF);//唤醒标志位清除
```

3)设置SLEEPDEEP位、PDDS位，执行WFI指令，进入待机模式

```
HAL_PWR_EnterSTANDBYMode();
```

WFI：通过NVIC应答的任何外设中断均可唤醒期间

WFE：MCU在事件发生时立即退出低功耗模式

4)编写WKUP中断服务函数

如果不写中断服务函数的话，系统会在按下后自动启动。

也可以设置超过3s后进入待机模式。

example.

```
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	int i=0;
	if(GPIO_Pin == GPIO_PIN_13)
	{
		HAL_Delay(10);//消抖
		while(!HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_13))//这里需要根据按键的电路情况设定，这里是在长按连接地的情况下
		{
			//如果不超过3s，则可以认为用于唤醒待机或者没有作用
			i++;
			HAL_Delay(30);//30ms
			if(i>=100)//超过3ms了，进入待机模式
			{
				HAL_UART_Transmit_IT(&huart2,"\r\nget into Standby mode\r\n",25);
				while(!HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_13));//等待抬起按键
				HAL_PWR_EnableWakeUpPin(PWR_WAKEUP_PIN2);
				SET_BIT(PWR->CR, PWR_CR_CWUF);//唤醒标志位清零	
				HAL_PWR_EnterSTANDBYMode();
			}
		}
	}
}
```

## 2.2 RTC闹钟唤醒
<img src="/images/posts/2018-2-11-Clocks-of-STM32L1/RTC_Block_Diagram.png" width="700" alt="RTC框图" />

RTC时钟如果用LSE做晶振，则需要通过两个分频器（7位异步分频器和15位同步分频器）

经过两个分频器后的频率计算方法如下，

<img src="/images/posts/2018-2-11-Clocks-of-STM32L1/Fck_spre.png" width="700" alt="RTC的CK_SPRE频率" />

hrtc.Init.AsynchPrediv和hrtc.Init.SynchPrediv分别是两个分频器，这两个分频器后的频率用于日历更新。所以一般为127和255，算的1s更新一次。

我们要用到的wakeup中断可以由这两个分频器后的频率CK_SPRE，也可以用RTCCLK经过一个2位异步分频器得到。4位分频器由寄存器WUCKSEL确定。

具体步骤和WAKEUP类似，只需要在正常运行时关闭RTC：

```
__HAL_RCC_RTC_DISABLE();
```

在要进入待机模式时，打开RTC：

```
__HAL_RCC_RTC_ENABLE();
```

然后参考WAKEUP的步骤。

## 2.3 说明

目前无法实现同时支持待机模式RTC进入/唤醒和按键（WKUP）进入/唤醒，即RTC进入要RTC唤醒，wakeup进入则wakeup唤醒。