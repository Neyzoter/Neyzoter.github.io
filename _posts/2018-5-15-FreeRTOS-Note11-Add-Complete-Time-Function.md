---
layout: post
title: FreeRTOS学习笔记(11)源码修改之Tickless低功耗真实等待时间的应用函数
categories: RTOS
description: FreeRTOS学习笔记(11)源码修改之Tickless低功耗真实等待时间的应用函数
keywords: FreeRTOS, Tickless
---

> 原创
> 
> 转载请注明出处，侵权必究

# 简介
在FreeRTOS操作系统进入Tickless模式后，系统的滴答时钟不再计数。FreeRTOS采用的技术是，预测进入低功耗等待的时间，在退出低功耗后把时间加上。这个预测时间是xExpectedIdleTime，如果按照预测时间退出低功耗，那么真实等待时间就是xExpectedIdleTime。

```cpp
/* As the pending tick will be processed as soon as this
function exits, the tick value maintained by the tick is stepped
forward by one less than the time spent waiting. */
ulCompleteTickPeriods = xExpectedIdleTime - 1UL;
```

但是虽然FreeRTOS关闭了较低优先级的中断，比如滴答定时器中断。但是其他的高优先级中断会使得系统提前退出低功耗。这个时间就通过NVIC的时间来计算得到。

```cpp
ulCompletedSysTickDecrements = ( xExpectedIdleTime * ulTimerCountsForOneTick ) - portNVIC_SYSTICK_CURRENT_VALUE_REG;

/* How many complete tick periods passed while the processor
was waiting? */
ulCompleteTickPeriods = ulCompletedSysTickDecrements / ulTimerCountsForOneTick;
```

FreeRTOS源码给了退出中断后，知道预测时间的函数PostSleepProcessing（这个函数是由用户定义的，可用于打开部分进入低功耗关闭的时钟等操作，具体可以看FreeRTOS的说明）。但是FreeRTOS的源码没有给怎么使用ulCompleteTickPeriods的函数。

ulCompleteTickPeriods对于超时判断有着非常好用的作用。比如一个系统防止得不到响应，那么设置一个n秒的临界，并且使用滴答时钟（也可以使用其他时钟，如果使用其他时钟，且没有在进入低功耗时关闭，则会使得系统不断推出低功耗，失去了Tickless的意义。比较新的STM32L4系列加入了低功耗定时器，也是一种作为定时器的方案。）。在被其他的中断打断后，我们不能把xExpectedIdleTime加到当前已经进行的时间，会比实际的多。因为实际可能提前因为被中断打断，而退出了低功耗。所以这里需要把ulCompleteTickPeriods做一个函数。

# 代码
1、FreeRTOS.h

预编译

```cpp
#ifndef configREAL_WAITINGTIME_PROCESSING
	#define configREAL_WAITINGTIME_PROCESSING( x )
#endif
```

2、FreeRTOSConfig.h

声明函数

```cpp
extern void RealWaitingTimeProcessing(uint32_t ulCompleteTickPeriods);
#define configREAL_WAITINGTIME_PROCESSING		RealWaitingTimeProcessing	
```

3、port.c

在退出低功耗后调用该函数——configREAL_WAITINGTIME_PROCESSING(ulCompleteTickPeriods);

```cpp
…………
portNVIC_SYSTICK_CURRENT_VALUE_REG = 0UL;
portNVIC_SYSTICK_CTRL_REG |= portNVIC_SYSTICK_ENABLE_BIT;
vTaskStepTick( ulCompleteTickPeriods );
portNVIC_SYSTICK_LOAD_REG = ulTimerCountsForOneTick - 1UL;

//加上这句
configREAL_WAITINGTIME_PROCESSING(ulCompleteTickPeriods);

/* Exit with interrpts enabled. */
__enable_irq();
……

```

4、你的C文件

eg.

```cpp
void RealWaitingTimeProcessing(uint32_t ulCompleteTickPeriods)
{
	if(usart.WAIT_START)	
		usart.waittime += ulCompleteTickPeriods;	
}
```