---
layout: post
title: FreeRTOS学习笔记(3)FreeRTOS的系统配置
categories: RTOS
description: FreeRTOS学习笔记(3)FreeRTOS的系统配置，即FreeRTOSConfig.h文件
keywords: FreeRTOS, 配置
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1、FreeRTOSConfig\.h文件
FreeRTOS的配置文件。每个工程都有一个FreeRTOSConfig.h的配置文件，甚至可以直接复制粘贴。

# 2、“INCLUDE\_”开始的宏
使能或者失能FreeRTOS响应的API函数。有的需要编译有的不需要编译，节省RAM和ROM。

具体的宏的作用见FreeRTOS的手册。

# 3、“config”开始的宏
完成FreeRTOS的配置和裁剪。有的需要编译有的不需要编译，节省RAM和ROM。

## 3.1 configAPPLICATION\_ALLOCATED\_HEAP
堆内存是否由用户自行设置。

FreeRTOS的堆内存是由编译器分配

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/configAPPLICATION_ALLOCATED_HEAP_Code.png" width="600" alt="configAPPLICATION_ALLOCATED_HEAP作用函数" />

## 3.2 configASSERT
类似C语言库的assert()函数，调试代码的时候可以检查传入的参数是否合理。

方式1（CubeMX生成的函数）：

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/configASSERT_Code1.png" width="600" alt="configASSERT_作用函数" />

方式2（错误的文件和行数打印出来）：

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/configASSERT_Code2.png" width="600" alt="configASSERT_作用函数" />

## 3.3 configCHECK\_FOR\_STACK\_OVERFLOW
### 3.3.1 configCHECK\_FOR\_STACK\_OVERFLOW的作用
设置堆栈溢出检测。

每个任务都有一个任务堆栈，如果用函数

```cpp
BaseType_t xTaskCreate(	TaskFunction_t pxTaskCode,
		const char * const pcName,		/*lint !e971 Unqualified char types are allowed for strings and single characters only. */
		const configSTACK_DEPTH_TYPE usStackDepth,
		void * const pvParameters,
		UBaseType_t uxPriority,
		TaskHandle_t * const pxCreatedTask )
```

创建一个任务，则任务自动从FreeRTOS的堆(ucHeap)中分配，堆栈的大小由函数xTaskCreate的参数usStackDepth来决定。如果用xTaskCreateStatic函数

```cpp
TaskHandle_t xTaskCreateStatic(	TaskFunction_t pxTaskCode,
		const char * const pcName, /*lint !e971 Unqualified char types are allowed for strings and single characters only. */
		const uint32_t ulStackDepth,
		void * const pvParameters,
		UBaseType_t uxPriority,
		StackType_t * const puxStackBuffer,
		 StaticTask_t * const pxTaskBuffer ) PRIVILEGED_FUNCTION;

```

创建任务，任务的堆栈由用户设置，puxStackBuffer一般为一个数组。

如果configCHECK_FOR_STACK_OVERFLOW大于零，那么需要一个回调函数（钩子函数）:

```cpp
void vApplicationStackOverflowHook( TaskHandle\_t *pxTask,signed char *pcTaskName );
```

在内存溢出后调用该函数。xTask是任务名字，pcTaskName是任务名字。要注意的是堆栈溢出有可能毁掉这两个参数。在这种情况下，变量pxCurrentTCB可以用于确定哪个任务造成了堆栈溢出。

### 3.3.1 configCHECK\_FOR\_STACK\_OVERFLOW的赋值
* 赋值1

检测方法1：检测堆栈指针是否指向有效的堆栈空间。如果检测到指向了无效的值，那么回调函数（钩子函数）会被调用。

优缺点：速度快；不能检测到所有的堆栈溢出。

* 赋值2

检测方法2：检测堆栈区域最后几位是否被重写。如果检测到被重写，那么回调函数（钩子函数）会被调用。

优缺点：效率低于方法1，但是仍然速度较快；检测到更多堆栈溢出，不过仍然有可能有没有检测到的溢出。

## 3.4 configCPU\_CLOCK\_HZ
CPU时钟，产生内核周期性的中断。

## 3.5 configSUPPORT\_DYNAMIC\_ALLOCATION
1:创建FreeRTOS的内核对象的时候所需要的RAM会从FreeRTOS的堆中动态获取内存。

0：用户自行分配内存。

如果没有定义，默认为1。

## 3.6 configENABLE\_BACKWARD\_COMPATIBILITY
后向兼容使能，默认为1。

作用的地方如下

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/configENABLE_BACKWARD_CAPATIBILITY.png" width="500" alt="configENABLE_BACKWARD_CAPATIBILITY作用函数" />

为了实现兼容，V8.0.0前需要使用到这些数据类型，保证V8.0.0前的版本升级到最新版本不需要做修改。

## 3.7 configGENERATE\_RUN\_TIME\_STATS
时间统计功能。1：开启；0：关闭。如果开启需要定义

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/RunTimeStats_Needs.png" width="700" alt="configGENERATE_RUN_TIME_STATS需要的宏定义" />

## 3.8 configIDLE\_SHOULD\_YIELD
控制任务处在空闲模式（IDLE）时，控制同等优先级的其他用户任务的行为。

0：空闲任务不为其他同优先级的任务让出CPU使用权。

1：空闲任务会为其他优先级的任务让出CPU使用权，花费在空闲任务上的时间会变少，也有了副作用。如下图。

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/TimeLineShow4Tasks.png" width="700" alt="同时执行4个任务，空闲任务让出使用权" />

A和I同时使用了一个时间片轮，造成了A的时间变短了。

## 3.9 configINCLUDE\_APPLICATION\_DEFINED\_PRIVILEGED\_FUNCTIONS
仅用于FreeRTOS 的 MPU。

* 赋值1

需要提供一个名字是“application\_defined\_privileged\_functions.h”的文件，用于需要特权模式运行的函数实现。

文件里的函数必须用prvRaisePrivilege()函数来存储和portRESET_PRIVILEGE()宏来恢复处理器的特权状态。

## 3.10 configKERNEL\_INTERRUPT\_PRIORITY,configMAX\_SYSCALL\_INTERRUPT\_PRIORITY,configMAX\_API\_CALL\_INTERRUPT\_PRIORITY
中断配置相关。

## 3.11 configMAX\_CO\_ROUTINE\_PRIORITIES
给协程最大的优先级。设置好后，协程的优先级可以从0到configMAX_CO_ROUTINE_PRIORITIES-1，其中0是最低优先级，configMAX_CO_ROUTINE_PRIORITIES-1是最高优先级。

## 3.12 configMAX\_TASK\_NAME_LEN
最大的任务名字长度。

## 3.13 configMINIMAL\_STACK\_SIZE
给空闲任务分配的最小的堆栈大小。该单位为字（STM32是32位，即4个字节），即数值是100，则共有400个字节。

## 3.14 configNUM\_THREAD\_LOCAL\_STORAGE\_POINTERS
本地存储指针数组的大小，默认为0。任务控制块中有本地存储数组指针，用户应用程序可以在这些本地存储中存入一些数据。

## 3.15 configQUEUE\_REGISTRY\_SIZE
可以注册的队列和信号量的最大数量。在使用内核调试器查看信号量和队列的时候需要设置此宏，而且先要将队列和信号量进行注册，只有注册了队列和信号量才会在内核调试器中看到。如果不使用内核调试器，设置为0。

## 3.16 configSUPPORT\_STATIC\_ALLOCATION
定义为1，则需要用户自行定义RAM；为0时，自动用heap.c中的动态内存管理函数来自动的申请RAM。

## 3.17 configTICK\_RATE\_HZ
时钟节拍频率，即滴答定时器的中断频率。

## 3.18 configTIMER\_QUEUE\_LENGTH
配置FreeRTOS的软件定时器，FreeRTOS的软件定时器API函数会通过命令队列向软件定时器任务发送消息，此宏用来设置该软件定时器的命令队列长度。

## 3.19 configTIMER\_TASK\_PRIORITY
设置软件定时器的任务优先级。

## 3.20 configTIMER\_TASK\_STACK\_DEPTH
设置定时器服务任务的任务堆栈大小。

## 3.21 configTOTAL\_HEAP\_SIZE
设置总共的堆大小。

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/ucHeap_Create.png" width="500" alt="设置ucHeap堆的大小" />

## 3.22 configUSE\_16\_BIT\_TICKS
设置系统节拍计数器变量数据类型，系统节拍计数器变量类型为TickType_t。

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/configUSE_16_BIT_TICKS_Code.png" width="500" alt="设置系统节拍计数器变量数据类型" />

## 3.23 configUSE\_APPLICATION\_TASK\_TAG
设置为1，则vTaskSetApplicationTaskTag() 和 xTaskCallApplicationTaskHook() 这两个函数会被编译。

默认为0。

## 3.24 configUSE\_CO\_ROUTINES
设置为1，启动协程，协程可以节省开销，但是功能有限。

## 3.25 configUSE\_COUNTING\_SEMAPHORES
设置为1，启用计数型信号量，相关API函数会被编译。

## 3.26 configUSE\_DAEMON\_TASK\_STARTUP\_HOOK
和configUSE_TIMERS同时定义为1时，需要定义函数

```
void vApplicationDaemonTaskStartupHook( void )
```

## 3.27 configUSE\_IDLE\_HOOK
设置为1，使用空闲任务钩子函数。
```
void vApplicationIdleHook( void )
```

## 3.28 configUSE\_MALLOC\_FAILED\_HOOK
设置为1时，内存分配失败的钩子函数。
```
void vApplicationMallocFailedHook( void )
```

## 3.29 configUSE\_MUTEXES
设置为1，使用互斥信号量。

## 3.30 configUSE\_PORT\_OPTIMISED\_TASK\_SELECTION
FreeRTOS有两种方法来选择下一个要运行的任务。

* 通用方法

configUSE\_PORT\_OPTIMISED\_TASK\_SELECTION设置为0，或者硬件不支持；

所有硬件通用时；

全部用C语言实现，但是效率比特殊方法低；

不限制最大优先级数目的时候。

* 特殊方法（硬件方法）

不是所有硬件都支持；

宏configUSE\_PORT\_OPTIMISED\_TASK\_SELECTION为1时；

硬件拥有特殊指令，比如计算前异零（CLZ）指令；

比通用方法效率高；

会限制优先级数目，一般是32个。

## 3.31 configUSE\_PREEMPTION
设置为1时，采用抢占式调度器；为0时，采用协程。

* 抢占式调度器

每个时钟节拍中断时进行任务切换；

* 协程

切换方法包括：

1）一个任务调用了函数taskYIELD()；

2）一个任务调用了可以使任务进入阻塞态的API函数；

3）应用程序明确定义了在中断中执行上下文切换。


## 3.32 configUSE\_QUEUE\_SETS
设置为1，启动队列集功能。

## 3.33 configUSE\_RECURSIVE\_MUTEXES
设置为1，启用递归互斥信号量。

## 3.34 configUSE\_STATS\_FORMATTING\_FUNCTIONS
设置configUSE\_TRACE\_FACILITY 和 configUSE\_STATS\_FORMATTING\_FUNCTIONS为1，则vTaskList()和vTaskGetRunTimeStats()编译。

任意一个设置为0，都会使得跳过编译这两个函数。

## 3.35 configUSE\_TASK\_NOTIFICATIONS
设置为1，启动任务通知功能，相关API会被编译。开启此功能，每个任务会多消耗8字节。

## 3.36 configUSE\_TICK\_HOOK
设置为1，使能时间片钩子函数，用户需要实现时间片钩子函数。

```
void vApplicationTickHook( void )
```

## 3.37 configUSE\_TICKLESS\_IDLE
设置为1，使能低功耗tickless模式。

## 3.37 configUSE\_TIMERS
设置为1，使用软件定时器。并且configTIMER\_TASK\_PRIORITY、configTIMER\_QUEUE\_LENGTH和configTIMER\_TASK\_STACK\_DEPTH必须定义。

## 3.38 configUSE\_TIME\_SLICING
FreeRTOS使用抢占式调度器，永远都在执行已经就绪了的最高优先级任务。configUSE\_TIME\_SLICING设置为1，优先级相同的任务在时钟节拍中断中进行切换。configUSE\_TIME\_SLICING设置为0，优先级相同的任务不会在时钟节拍中断中进行切换。

默认为1。

## 3.39 configUSE\_TRACE\_FACILITY
设置为1，启动可视化跟踪调试。



	



