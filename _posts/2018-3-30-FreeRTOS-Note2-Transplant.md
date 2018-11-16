---
layout: post
title: FreeRTOS学习笔记(2)FreeRTOS的移植
categories: RTOS
description: FreeRTOS学习笔记(2)FreeRTOS的移植，实现串口通信和点灯
keywords: FreeRTOS, 移植, Keil, STM32
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1、前期准备
1、进入源码，FreeRTOS  \->  Source。

2、删除portable中不需要的文件。

RVDS和keil的文件相同，所以keil需要的文件只要从RVDS中复制即可。然后只保留keil和MemMang。

<img src="/images/posts/2018-3-30-FreeRTOS-Note2-Transplant/portable.png" width="600" alt="portable文件夹结构" />

说明：使用V10.0.1的源码和V9.0.0的FreeRTOSConfig.h配置文件。

# 2、移植
## 2.1 添加FreeRTOS源码
创建FreeRTOS文件夹，并将前期准备的Source文件里的文件复制到该文件夹内。

<img src="/images/posts/2018-3-30-FreeRTOS-Note2-Transplant/Copy-Source-Into-Project.png" width="600" alt="在工程中添加FreeRTOS文件" />

## 2.2 Keil工程分组添加FreeRTOS文件
分别添加FreeRTOS和FreeRTOS_PROTABLE。

<img src="/images/posts/2018-3-30-FreeRTOS-Note2-Transplant/Add-RreeRTOS-Into-Keil.png" width="250" alt="在keil工程中添加FreeRTOS和PORTABLE" />

注：采用heap\_x.c是几种不同的内存管理方法，这里选择4。

## 2.3 添加头文件路径

## 2.4 添加FreeRTOSConfig.h到文件夹
将官方的FreeRTOSConfig.h（例程中有）添加到任意一个工程文件即可，只要使得Keil工程找得到。这里放到了FreeRTOS\->include文件夹中。

## 2.5 编译发现定义问题
>A1586E: Bad operand types (UnDefOT, Constant) for operator (

是因为将5和4U进行了计算，在main.h中加入

```cpp
//强制把__NVIC_PRIO_BITS定义为4，而不是4U
#if 1
#ifdef __NVIC_PRIO_BITS
#undef __NVIC_PRIO_BITS
#define __NVIC_PRIO_BITS      4
#endif
#endif
```

## 2.6 编译发现PendSV_Handler和SVC_Handler重定义

屏蔽掉stm321xx_it.c中的这两个函数。

注：有可能Systick_Handler也会报错，在FreeRTOSConfig.h中没有屏蔽掉

<img src="/images/posts/2018-3-30-FreeRTOS-Note2-Transplant/Systick_Handler.png" width="700" alt="FreeRTOSConfig.h屏蔽掉了Systick_Handler" />

我把它也屏蔽，然后保留it里的systick_handler。

## 2.7 更改SYSTEM文件

* sys.h文件

```cpp
#define SYSTEM_SUPPORT_OS		1		//定义系统文件夹是否支持OS
```

* usart.c文件

1、添加FreeRTOS的h文件

```cpp
#if SYSTEM_SUPPORT_OS
#include "includes.h"					//os 使用	 
#include "FreeRTOS.h"//FreeRTOS
#endif
```

2、删掉UCOS的OSIntEnter和OSIntExit

USARTx_IRQHandler中，以下的两段代码删除。

```cpp
#if SYSTEM_SUPPORT_OS	 	//使用OS
	OSIntEnter();    
#endif

```

```cpp
#if SYSTEM_SUPPORT_OS	 	//使用OS
	OSIntExit();
#endif
```

## 2.8 更改系统时钟
1、改写SysTick_Handler()

配置FreeRTOS的系统时钟。FreeRTOS的心跳由滴答时钟产生。

stm32l1xx_it.c文件

```cpp

#ifdef SYSTEM_SUPPORT_OS
	#include "FreeRTOS.h"
	#include "task.h"
#endif


extern void xPortSysTickHandler(void);
extern BaseType_t xTaskGetSchedulerState( void );
void SysTick_Handler(void)
{
//    HAL_IncTick();
	if(xTaskGetSchedulerState()!=taskSCHEDULER_NOT_STARTED)
	{
		xPortSysTickHandler();
	}
}
```

2、系统时钟配置

sys.c文件中的SystemClock_Config函数：

```cpp
/**配置SysTick系统滴答时钟中断时间 
 */
HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/configTICK_RATE_HZ);
```

configTICK_RATE_HZ这里原来是数字1000，表示以1000hz的频率中断。configTICK_RATE_HZ在FreeRTOS中也定义为了1000，1ms中断一次。

## 2.9 例程代码测试
main.c

```cpp
#include "main.h"
#include "FreeRTOS.h"
#include "task.h"

  //任务优先级
#define START_TASK_PRIO		1
//任务堆栈大小	
#define START_STK_SIZE 		128  
//任务句柄
TaskHandle_t StartTask_Handler;
//任务函数
void start_task(void *pvParameters);

//任务优先级
#define UART_TASK_PRIO		2
//任务堆栈大小	
#define UART_STK_SIZE 		50  
//任务句柄
TaskHandle_t UartTask_Handler;
//任务函数
void uart_task(void *pvParameters);

//任务优先级
#define LED1_TASK_PRIO		3
//任务堆栈大小	
#define LED1_STK_SIZE 		50  
//任务句柄
TaskHandle_t LED1Task_Handler;
//任务函数
void led1_task(void *pvParameters);

//任务优先级
#define FLOAT_TASK_PRIO		4
//任务堆栈大小	
#define FLOAT_STK_SIZE 		128
//任务句柄
TaskHandle_t FLOATTask_Handler;
//任务函数
void float_task(void *pvParameters);

 
//开始任务任务函数
void start_task(void *pvParameters)
{
    taskENTER_CRITICAL();           //进入临界区
    //创建UART任务
    xTaskCreate((TaskFunction_t )uart_task,     	
                (const char*    )"uart_task",   	
                (uint16_t       )UART_STK_SIZE, 
                (void*          )NULL,				
                (UBaseType_t    )UART_TASK_PRIO,	
                (TaskHandle_t*  )&UartTask_Handler);   
    //创建LED1任务
    xTaskCreate((TaskFunction_t )led1_task,     
                (const char*    )"led1_task",   
                (uint16_t       )LED1_STK_SIZE, 
                (void*          )NULL,
                (UBaseType_t    )LED1_TASK_PRIO,
                (TaskHandle_t*  )&LED1Task_Handler);        
    //浮点测试任务
    xTaskCreate((TaskFunction_t )float_task,     
                (const char*    )"float_task",   
                (uint16_t       )FLOAT_STK_SIZE, 
                (void*          )NULL,
                (UBaseType_t    )FLOAT_TASK_PRIO,
                (TaskHandle_t*  )&FLOATTask_Handler);  
    vTaskDelete(StartTask_Handler); //删除开始任务
    taskEXIT_CRITICAL();            //退出临界区
}

//UART任务函数 
void uart_task(void *pvParameters)
{
    while(1)
    {
        printf("\r\n300ms\r\n");
        vTaskDelay(300);
    }
}   

//LED1任务函数
void led1_task(void *pvParameters)
{
    while(1)
    {
        BSP_LED_On(LED2);
        vTaskDelay(200);
        BSP_LED_Off(LED2);;
        vTaskDelay(800);
    }
}

//浮点测试任务
void float_task(void *pvParameters)
{
	static float float_num=0.00;
	while(1)
	{
		float_num+=0.01f;
		printf("\r\nfloat_num的值为: %.4f\r\n",float_num);
        vTaskDelay(2000);
	}
}

int main(void)
{

  HAL_Init();

  /* Configure the system clock to 32 MHz */
  SystemClock_Config();

	TIM2_Init(9,2096);
	HAL_TIM_Base_Start_IT(&htim2);
  /* Add your application code here
     */
	uart_init(9600);              //初始化USART

	BSP_LED_Init(LED2);//PA5
	
    xTaskCreate((TaskFunction_t )start_task,            //任务函数
                (const char*    )"start_task",          //任务名称
                (uint16_t       )START_STK_SIZE,        //任务堆栈大小
                (void*          )NULL,                  //传递给任务函数的参数
                (UBaseType_t    )START_TASK_PRIO,       //任务优先级
                (TaskHandle_t*  )&StartTask_Handler);   //任务句柄              
    vTaskStartScheduler();          //开启任务调度
	
}

```

# 3、查看是否支持FPU

前提：芯片自带FPU，浮点计算单元，比如STM32F4。而STM32L1系列没有。

```cpp
float_num+=0.01f;
```

以上代码出断点，再进行硬件仿真。查看响应的asm代码。如果发现使用了s0等浮点寄存器，或者VLDR、VADD等浮点指令。说明FreeRTOS支持FPU。

结论：FreeRTOS支持FPU。而STM32L1没有FPU单元，故采用CPU计算浮点。









 

