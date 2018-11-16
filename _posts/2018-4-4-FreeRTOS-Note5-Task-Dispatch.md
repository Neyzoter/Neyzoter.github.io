---
layout: post
title: FreeRTOS学习笔记(5)FreeRTOS的任务介绍
categories: RTOS
description: FreeRTOS学习笔记(5)FreeRTOS的任务介绍
keywords: FreeRTOS, 任务调度
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1.不同的任务调度方式介绍

## 1.1 前后台系统

裸机一般采用一个大while循环，里面的任务循环调用，下一任务需要等待上一任务结束才能运行。在while中的任务称为**后台程序**。

而一般中断中也会放置任务，该任务称为**前台程序**。

前后台系统任务执行过程如下图。

<img src="/images/posts/2018-4-4-FreeRTOS-Note5-Task-Dispatch/Bigwhile.png" width="600" alt="前后台任务" />

## 1.2 多任务系统
把大问题分成多个小问题，逐步解决小问题，而该小问题称为小任务。这些小任务并发处理，即每个任务执行的时间很短，看起来像同一时间运行。

任务调度器：决定任务的先后运行。FreeRTOS采用抢占式的实时多任务系统，任务调度器也是抢占式的。

**基本原理**

高优先级任务可以打断低优先级任务的运行而取得CPU的使用权，保证紧急任务的及时运行。

<img src="/images/posts/2018-4-4-FreeRTOS-Note5-Task-Dispatch/preemptive.png" width="600" alt="抢占式多任务系统" />

# 2.FreeRTOS的任务和协程（Co-Routine）
FreeRTOS中可以单独使用或者混合使用两者。任务和协程调用不同的API函数，不能通过队列（或者信号量）将数据从任务发送到协程或者反过来亦不可。协程为资源较少的MCU准备，开销小。

RTOS调度器：确保当一个任务开始执行的时候上下文环境（寄存器、堆栈内容等）和任务上一次退出的时候相同。**所以每个任务都有一个堆栈，当任务切换的时候将上下文环境保存在堆栈中。该任务再次运行时，可以从堆栈中取出上下文环境，任务恢复运行。**

**抢占式多任务调度过程：**

<img src="/images/posts/2018-4-4-FreeRTOS-Note5-Task-Dispatch/Task-Transform.png" width="600" alt="任务调度过程" />

说明：有Task1、Task2和Task3三个任务，优先级从低到高。

调度过程（任务状态见第3节）：

1）Task1正在运行时（运行态），Task2就绪。调度器作用下，Task2抢占Task1。Task2进入运行态，Task1进入就绪态。

2）Task2运行时（运行态），Task3就绪。调度器作用下，Task3抢占Task2。Task3进入运行态，Task2进入就绪态。同时，Task1也是就绪态。

3）Task3运行时使用阻塞式API函数，比如延时函数vTaskDelay()，Task3阻塞（阻塞态）。调度器作用下，找到就绪态中拥有最高优先级的Task2，任务Task2由就绪态进入运行态。

4）Task2运行过程中，Task3的阻塞式函数结束，Task3从挂起态进入了就绪态。在调度器作用下，Task3抢占Task2，Task3进入运行态，Task2进入就绪态。

# 3.任务的状态
* 运行态
正在使用处理器的程序。如果单核，则只有一个任务处于运行态。

* 就绪态

已经准备就绪（没有被阻塞或者挂起），可以运行的任务。但是就绪态任务还没有运行，因为有一个同优先级或者更高优先级的任务正在运行。会有一个**就绪列表**存放所有的就绪任务。

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/ReadyListStructure.png" width="600" alt="不同的任务优先级的就绪列表关系" />

* 阻塞态

一个任务正在等待某个外部事件。比如某个任务调用了函数vTaskDelay()，进入阻塞态，知道延时结束。任务在等待队列、信号量、事件组、通知或者互斥信号量时也会进入阻塞态。任务进入阻塞态会有一个超时时间，当超过这个超时时间任务会退出阻塞态，即使所等待的事件还没有来临。

* 挂起态

进入挂起态没有超时时间。进入和退出挂起态使用函数vTaskSuspend()和xTaskResume()。

<img src="/images/posts/2018-4-4-FreeRTOS-Note5-Task-Dispatch/TaskTrasform4States.png" width="600" alt="任务调度过程" />

# 4.任务优先级
每个任务都可以分配一个从0到(configMAX_PRIORITIES-1)的优先级。如果所用的硬件平台支持类似计算前导零这样的指令（通过该指令执行下一个要运行的任务，Cortex-M支持该指令），并且宏configUSE_PORT_OPTIMISED_TASK_SELECTION（下一个要运行的任务的两种方法1：硬件方法，前导零CLZ）设置为1，**宏configMAX_PRIORITIES最大不超过32**。

任务优先级数值从小到大，优先级从低到高。任务优先级和中断优先级正好相反。

如果时间片轮转使能，即configUSE_TIME_SLICING定义为1（默认为1），则多个任务可以同时设置为同一优先级。否则每个优先级只能有一个任务。

# 5.任务实现
使用xTaskCreat（自动分配堆栈）e或者xTaskCreateStatic（用户
分配堆栈）创建任务。

* 创建任务函数

```cpp
//自动分配堆栈的创建任务函数
BaseType_t xTaskCreate(	TaskFunction_t pxTaskCode,
		const char * const pcName,		/*lint !e971 Unqualified char types are allowed for strings and single characters only. */
		const configSTACK_DEPTH_TYPE usStackDepth,
		void * const pvParameters,
		UBaseType_t uxPriority,
		TaskHandle_t * const pxCreatedTask )
```

```cpp
//用户分配堆栈的创建任务函数
TaskHandle_t xTaskCreateStatic(	TaskFunction_t pxTaskCode,
		const char * const pcName, /*lint !e971 Unqualified char types are allowed for strings and single characters only. */
		const uint32_t ulStackDepth,
		void * const pvParameters,
		UBaseType_t uxPriority,
		StackType_t * const puxStackBuffer,
		 StaticTask_t * const pxTaskBuffer ) PRIVILEGED_FUNCTION;

```

* 任务函数模板

```cpp
//任务函数模板
//任务函数的返回值一定要是void类型，也就是无返回值而且任务的参数也是void指针类型
void vATaskFunction(void * pvParameters)
{
	while(1)//任务的具体执行过程是一个while循环
	{
		//此处填写任务应用程序
		//-------
		
		//任务切换
		vTaskDelay(1);//让FreeRTOS实现任务切换的API函数即可，比如请求信号量、队列等，甚至直接调用任务调度器
	}
	//一般不允许跳出while循环，如果要退出则要使用vTaskDelete函数
	vTaskDelete(NULL);
}

```

# 6.任务控制块
```cpp
typedef struct tskTaskControlBlock
{
	volatile StackType_t	*pxTopOfStack;	/*<指向任务堆栈栈顶（最近一个任务last item），必须是TCB结构体的第一个成员*/

	#if ( portUSING_MPU_WRAPPERS == 1 )
		xMPU_SETTINGS	xMPUSettings;	/*<MPU相关配置，必须是第二个成员	*/
	#endif

	ListItem_t			xStateListItem;	/*<状态列表项<就绪,阻塞,挂起>*/
	ListItem_t			xEventListItem;		/*< 时间列表项 */
	UBaseType_t			uxPriority;			/*< 任务优先级，0最低 */
	StackType_t			*pxStack;			/*< 指向堆栈起始地址*/
	char				pcTaskName[ configMAX_TASK_NAME_LEN ];/*< 任务名字 ，只用于debug。只能用字符串 */ 

	#if ( ( portSTACK_GROWTH > 0 ) || ( configRECORD_STACK_HIGH_ADDRESS == 1 ) )
		StackType_t		*pxEndOfStack;		/*< 指向堆栈栈底 */
	#endif

	#if ( portCRITICAL_NESTING_IN_TCB == 1 )
		UBaseType_t		uxCriticalNesting;	/*< 临界区嵌套深度 */
	#endif

	#if ( configUSE_TRACE_FACILITY == 1 )  /*<用于trace或者debug*/
		UBaseType_t		uxTCBNumber;		
		UBaseType_t		uxTaskNumber;
	#endif

	#if ( configUSE_MUTEXES == 1 )
		UBaseType_t		uxBasePriority;		/*< 任务基础优先级，优先级反转的时候用到 */
		UBaseType_t		uxMutexesHeld;/*< 任务获取到的互斥信号量个数 */
	#endif

	#if ( configUSE_APPLICATION_TASK_TAG == 1 )
		TaskHookFunction_t pxTaskTag;
	#endif

	#if( configNUM_THREAD_LOCAL_STORAGE_POINTERS > 0 )
		void			*pvThreadLocalStoragePointers[ configNUM_THREAD_LOCAL_STORAGE_POINTERS ];
	#endif

	#if( configGENERATE_RUN_TIME_STATS == 1 )
		uint32_t		ulRunTimeCounter;	/*< 任务运行时间.*/
	#endif

	#if ( configUSE_NEWLIB_REENTRANT == 1 )
		/* Allocate a Newlib reent structure that is specific to this task.
		Note Newlib support has been included by popular demand, but is not
		used by the FreeRTOS maintainers themselves.  FreeRTOS is not
		responsible for resulting newlib operation.  User must be familiar with
		newlib and must provide system-wide implementations of the necessary
		stubs. Be warned that (at the time of writing) the current newlib design
		implements a system-wide malloc() that must be provided with locks. */
		struct	_reent xNewLib_reent;
	#endif

	#if( configUSE_TASK_NOTIFICATIONS == 1 )
		volatile uint32_t ulNotifiedValue;/*<任务通知值*/
		volatile uint8_t ucNotifyState;/*<任务通知状态*/
	#endif

	/* See the comments above the definition of
	tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE. */
	#if( tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE != 0 ) /*lint !e731 Macro has been consolidated for readability reasons. */
		uint8_t	ucStaticallyAllocated; 		/*< 用来标记任务是动态创建的还是静态创建的，如果静态：pdTRUE；动态：pdFALSE*/
	#endif

	#if( INCLUDE_xTaskAbortDelay == 1 )
		uint8_t ucDelayAborted;
	#endif

} tskTCB;

typedef tskTCB TCB_t;

```