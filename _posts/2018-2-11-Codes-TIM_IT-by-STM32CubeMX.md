---
layout: post
title: STM32CubeMX自动生成的定时器中断代码分析
categories: MCU
description: STM32CubeMX自动生成的定时器中断代码分析
keywords: STM32L1, 定时器, 中断
---

> 原创
> 
> 转载请注明出处，侵权必究。

### 1 中断函数void TIM2_IRQHandler(void)
中断向量会指向该函数，故中断到来时，自动调用

其在STM32l1xx\_it.c中，其包含HAL\_TIM_IRQHandler(&htim2)调用一个通用的定时器中断函数，指定定时器为htim2结构体中的定时器，此处是htim2：TIM2（这个结构体TIM\_HandleTypeDef也是自己定义的，通常TIMx对应htimxvoid 
### 2 通用的定时器中断函数void HAL_TIM_IRQHandler(TIM_HandleTypeDef *htim)
在stm32l1xx_hal_tim.c中，根据不同的中断类型进入不同的if函数

比如常用的更新中断——HAL\_TIM\_PeriodElapsedCallback(htim)。这个函数用于周期性的定时器更新中断。

### 3 更新中断函数HAL_TIM_PeriodElapsedCallback(htim)
这个函数没有定义时，指向__weak void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)，weak函数里没有东西。

\_\_weak表示如果其他地方没有对其定义，那么执行这里的函数，也就是什么都不运行UNUSED(htim)。

如果在其他地方定义了同一个名字的函数，而不是用__weak定义的，那么就执行那里的函数。故可以在其他函数中写特定的程序

由于HAL\_TIM\_PeriodElapsedCallback也是通用的（所有TIM的中断调用HAL_TIM_IRQHandler，进而调用其中的HAL\_TIM\_PeriodElapsedCallback，所以如果有多个定时器需要进行中断处理，那么在HAL\_TIM\_PeriodElapsedCallback用if语句判断

```c
if (htim->Instance == htim2.Instance)
```