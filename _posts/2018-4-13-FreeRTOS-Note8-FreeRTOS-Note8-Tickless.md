---
layout: post
title: FreeRTOS学习笔记(8)FreeRTOS的低功耗Tickless模式
categories: RTOS
description: FreeRTOS学习笔记(8)FreeRTOS的低功耗Tickless模式
keywords: FreeRTOS, 低功耗, Tickless
---

> 原创
> 
> 转载请注明出处，侵权必究。


# 1.简介
## 1.1 前言
处理器处理大量的空闲任务，所以考虑将处理器处理空闲任务的时候进入低功耗模式。要处理应用层代码的时候，就将处理器从低功耗模式唤醒。

**我的观点**：STM32的待机模式，相当于重启，而且时延较长，一般不太适合用于Tickless。

FreeRTOS在处理器处理空闲任务的时候将处理器设置为低功耗模式来降低功耗。一般会在空闲任务的钩子函数中执行低功耗相关处理，比如设置处理器进入低功耗模式、关闭其他外设时钟、降低系统主频等。

## 1.2 Tickless的原理

进入空闲周期后关闭系统节拍中断（滴答时钟中断），其他中断发生或者其他任务需要处理的时候处理器从低功耗模式中唤醒。

**问题1：关闭系统节拍器会导致系统节拍计数器停止，系统时钟就会停止。**

记录下系统节拍中断关闭的时间，打开的时候补上这段时间。用另外的定时器来记录和弥补这段时间，可以采用低功耗定时器（如STM32L4系列）。如果没有，也可以用滴答时钟来完成。

**问题2：保证下一个要运行的程序被准确的唤醒？**

中断任务可以将处理器从低功耗中唤醒，但是应用任务就不行了。

我们可以知道下一个任务到来的时间，只需要另外再开一个定时器，定时器的定时周期设置为这个时间即可。如果没有低功耗的定时器完成这个唤醒功能，滴答定时器也可以，下面有讲解。FreeRTOS具有得知下一个任务到来的时间的功能。

# 2.Tickless具体体现
## 2.1 宏
**1.configUSE_TICKLESS_IDLE**

1：使用Tickless模式，FreeRTOS提供了现成的portSUPPRESS_TICKS_AND_SLEEP函数。2：使用Tickless，并且用户自行编写进入Tickless低功耗的portSUPPRESS_TICKS_AND_SLEEP函数。该宏默认为0。

**2.portSUPPRESS_TICKS_AND_SLEEP()**

使能Tickless模式后，且出现以下两种情况：

1、空闲任务是唯一任务，其他任务处于阻塞或者挂起态；

2、系统处于低功耗的时间至少大于configEXPECTED_IDLE_TIME_BEFORE_SLEEP个时钟节拍。configEXPECTED_IDLE_TIME_BEFORE_SLEEP可以重新定义，但是必须大于2。

portSUPPRESS_TICKS_AND_SLEEP( xExpectedIdleTime )这里有一个参数xExpectedIdleTime，此参数定义指定多长时间将有任务进入就绪态或者说退出Tickless的低功耗模式（**单位：时钟节拍数**）。如果portSUPPRESS_TICKS_AND_SLEEP()函数没有由用户定义的话，直接使用FreeRTOS给的vPortSuppressTicksAndSleep( xExpectedIdleTime )。该函数只有使能了Tickless才会编译。

portSUPPRESS_TICKS_AND_SLEEP在文件protmacro.h中定义，

```
#ifndef portSUPPRESS_TICKS_AND_SLEEP
	extern void vPortSuppressTicksAndSleep( TickType_t xExpectedIdleTime );
	#define portSUPPRESS_TICKS_AND_SLEEP( xExpectedIdleTime ) vPortSuppressTicksAndSleep( xExpectedIdleTime )
#endif
```

```
__weak void vPortSuppressTicksAndSleep( TickType_t xExpectedIdleTime )
{
uint32_t ulReloadValue, ulCompleteTickPeriods, ulCompletedSysTickDecrements;
TickType_t xModifiableIdleTime;

	/* 确保xExpectedIdleTime不超过滴答时钟的重装载值，如果设置为cortex的频率是2.097kHz，tick时钟1000Hz，则最大不超过8000具体见下面解释*/
	if( xExpectedIdleTime > xMaximumPossibleSuppressedTicks )
	{
		xExpectedIdleTime = xMaximumPossibleSuppressedTicks;
	}

	/* 停止滴答时钟. */
	portNVIC_SYSTICK_CTRL_REG &= ~portNVIC_SYSTICK_ENABLE_BIT;

	/* 根据xExpectedIdleTime计算滴答时钟的重装载值，进入低功耗模式以后，滴答定时器来计时ulTimerCountsForOneTick = ( configSYSTICK_CLOCK_HZ / configTICK_RATE_HZ );
	*/
	ulReloadValue = portNVIC_SYSTICK_CURRENT_VALUE_REG + ( ulTimerCountsForOneTick * ( xExpectedIdleTime - 1UL ) );

	/* 从滴答时钟停止运行到把统计得到的低功耗模式运行的这段时间补偿给FreeRTOS 
	ulStoppedTimerCompensation说明见下方*/
	if( ulReloadValue > ulStoppedTimerCompensation )
	{
		ulReloadValue -= ulStoppedTimerCompensation;
	}

	/* 在执行WFI前设置寄存器PRIMASK，处理器可以由中断唤醒，但是不会处理中断，退出低功耗模式，来使ISR得到执行. __disable_irq在core_cmx.c中定义*/
	__disable_irq();
	__dsb( portSY_FULL_READ_WRITE );
	__isb( portSY_FULL_READ_WRITE );

	/* 来判断是否可以进入低功耗模式.如果返回eAbortSleep，不能进入低功耗，需要重新使能滴答时钟 */
	if( eTaskConfirmSleepModeStatus() == eAbortSleep )
	{
		/* Restart from whatever is left in the count register to complete
		this tick period.从计数寄存器中剩下的时间重新启动，以完成这个标记周期 */
		portNVIC_SYSTICK_LOAD_REG = portNVIC_SYSTICK_CURRENT_VALUE_REG;

		/* Restart SysTick. */
		portNVIC_SYSTICK_CTRL_REG |= portNVIC_SYSTICK_ENABLE_BIT;

		/* Reset the reload register to the value required for normal tick
		periods. */
		portNVIC_SYSTICK_LOAD_REG = ulTimerCountsForOneTick - 1UL;

		/* 重新打开中断. */
		__enable_irq();
	}
	else   //可以进入低功耗模式
	{
		/* 写入到滴答定时器的重装载寄存器中. */
		portNVIC_SYSTICK_LOAD_REG = ulReloadValue;

		/* Clear the SysTick count flag and set the count value back to
		zero. */
		portNVIC_SYSTICK_CURRENT_VALUE_REG = 0UL;

		/* Restart SysTick. 
		重新启动滴答时钟，用于唤醒低功耗模式*/
		portNVIC_SYSTICK_CTRL_REG |= portNVIC_SYSTICK_ENABLE_BIT;

		/* Sleep until something happens.  configPRE_SLEEP_PROCESSING() can
		set its parameter to 0 to indicate that its implementation contains
		its own wait for interrupt or wait for event instruction, and so wfi
		should not be executed again.  However, the original expected idle
		time variable must remain unmodified, so a copy is taken. */
		xModifiableIdleTime = xExpectedIdleTime;

		/*是一个宏，在进入低功耗之前可以有一些事情来做，比如降低系统时钟、关闭外设时钟、关闭板子某些硬件电源等*/
		configPRE_SLEEP_PROCESSING( xModifiableIdleTime );
		if( xModifiableIdleTime > 0 )
		{
			__dsb( portSY_FULL_READ_WRITE );
			__wfi();	//使用wif进入睡眠模式
			__isb( portSY_FULL_READ_WRITE );
		}

		/*是一个宏，执行到这里，说明已经退出了低功耗模式。在退出低功耗滞后有一些事情来做，比如提高系统时钟、打开外设时钟、打开板子某些硬件电源等*/
		configPOST_SLEEP_PROCESSING( xExpectedIdleTime );

		/* Re-enable interrupts to allow the interrupt that brought the MCU
		out of sleep mode to execute immediately.  see comments above
		__disable_interrupt() call above. */
		__enable_irq();
		__dsb( portSY_FULL_READ_WRITE );
		__isb( portSY_FULL_READ_WRITE );

		/* Disable interrupts again because the clock is about to be stopped
		and interrupts that execute while the clock is stopped will increase
		any slippage between the time maintained by the RTOS and calendar
		time. */
		__disable_irq();
		__dsb( portSY_FULL_READ_WRITE );
		__isb( portSY_FULL_READ_WRITE );
		
		/* Disable the SysTick clock without reading the 
		portNVIC_SYSTICK_CTRL_REG register to ensure the
		portNVIC_SYSTICK_COUNT_FLAG_BIT is not cleared if it is set.  Again, 
		the time the SysTick is stopped for is accounted for as best it can 
		be, but using the tickless mode will inevitably result in some tiny 
		drift of the time maintained by the kernel with respect to calendar 
		time*/
		portNVIC_SYSTICK_CTRL_REG = ( portNVIC_SYSTICK_CLK_BIT | portNVIC_SYSTICK_INT_BIT );

		/* Determine if the SysTick clock has already counted to zero and
		been set back to the current reload value (the reload back being
		correct for the entire expected idle time) or if the SysTick is yet
		to count to zero (in which case an interrupt other than the SysTick
		must have brought the system out of sleep mode).判断导致退出低功耗是因为外部中断还是滴答时钟计时时间引起 */
		if( ( portNVIC_SYSTICK_CTRL_REG & portNVIC_SYSTICK_COUNT_FLAG_BIT ) != 0 )
		{
			uint32_t ulCalculatedLoadValue;

			/* The tick interrupt is already pending, and the SysTick count
			reloaded with ulReloadValue.  Reset the
			portNVIC_SYSTICK_LOAD_REG with whatever remains of this tick
			period. */
			ulCalculatedLoadValue = ( ulTimerCountsForOneTick - 1UL ) - ( ulReloadValue - portNVIC_SYSTICK_CURRENT_VALUE_REG );

			/* Don't allow a tiny value, or values that have somehow
			underflowed because the post sleep hook did something
			that took too long. */
			if( ( ulCalculatedLoadValue < ulStoppedTimerCompensation ) || ( ulCalculatedLoadValue > ulTimerCountsForOneTick ) )
			{
				ulCalculatedLoadValue = ( ulTimerCountsForOneTick - 1UL );
			}

			portNVIC_SYSTICK_LOAD_REG = ulCalculatedLoadValue;

			/* As the pending tick will be processed as soon as this
			function exits, the tick value maintained by the tick is stepped
			forward by one less than the time spent waiting. */
			ulCompleteTickPeriods = xExpectedIdleTime - 1UL;
		}
		else	//外部中断唤醒中断，则需要进行时间补偿
		{
			/* Something other than the tick interrupt ended the sleep.
			Work out how long the sleep lasted rounded to complete tick
			periods (not the ulReload value which accounted for part
			ticks). */
			ulCompletedSysTickDecrements = ( xExpectedIdleTime * ulTimerCountsForOneTick ) - portNVIC_SYSTICK_CURRENT_VALUE_REG;

			/* How many complete tick periods passed while the processor
			was waiting? */
			ulCompleteTickPeriods = ulCompletedSysTickDecrements / ulTimerCountsForOneTick;

			/* The reload value is set to whatever fraction of a single tick
			period remains. */
			portNVIC_SYSTICK_LOAD_REG = ( ( ulCompleteTickPeriods + 1UL ) * ulTimerCountsForOneTick ) - ulCompletedSysTickDecrements;
		}

		/* 重新启动滴答定时器，重装载值设置为正常值 */
		portNVIC_SYSTICK_CURRENT_VALUE_REG = 0UL;
		portNVIC_SYSTICK_CTRL_REG |= portNVIC_SYSTICK_ENABLE_BIT;
		vTaskStepTick( ulCompleteTickPeriods );//补偿系统时钟
		portNVIC_SYSTICK_LOAD_REG = ulTimerCountsForOneTick - 1UL;

		/* Exit with interrpts enabled. */
		__enable_irq();
	}
}


```

**xMaximumPossibleSuppressedTicks**

```
ulTimerCountsForOneTick = ( configSYSTICK_CLOCK_HZ / configTICK_RATE_HZ );
xMaximumPossibleSuppressedTicks = portMAX_24_BIT_NUMBER / ulTimerCountsForOneTick;

```

所以如果Cortex系统的时钟是configSYSTICK_CLOCK_HZ = 2.097kHz，滴答时钟的频率configTICK_RATE_HZ = 1000。那么xMaximumPossibleSuppressedTicks = 0xFFFFFF/(2097000/1000) = 8000


**ulStoppedTimerCompensation**

```
#define portMISSED_COUNTS_FACTOR			( 45UL )
ulStoppedTimerCompensation = portMISSED_COUNTS_FACTOR / ( configCPU_CLOCK_HZ / configSYSTICK_CLOCK_HZ );
```
portMISSED_COUNTS_FACTOR可以自行修改，但是由于代码的优化程度不同，没法知道代码执行了多长时间，只能估计。

>注：睡眠模式sleep mode只关闭CPU时钟，其他外设和时钟没有影响。FreeRTOS采用的是滴答时钟唤醒，低功耗（睡眠）模式。

**configPRE_SLEEP_PROCESSING()**

用于进入睡眠模式前的处理，比如处理器降频、修改时钟源（外部时钟更换为内部时钟）、关闭外设时钟、关闭其他功能模块电源。

在FreeRTOSconfig.h中定义：

```
extern void PreSleepProcessing(uint32_t ulExpectedTime);
extern void PostSleepProcessing(uint32_t ulExpectedTime);
	
////进入低功耗模式前要做的处理
#define configPRE_SLEEP_PROCESSING	PreSleepProcessing
///退出低功耗模式后要做的处理
#define configPOST_SLEEP_PROCESSING		PostSleepProcessing
```

再在其他c文件中定义PreSleepProcessing和PostSleepProcessing函数。



