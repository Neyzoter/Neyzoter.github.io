---
layout: post
title: FreeRTOS学习笔记(6)FreeRTOS的任务相关API函数
categories: RTOS
description: FreeRTOS学习笔记(6)FreeRTOS的任务相关API函数
keywords: FreeRTOS, API, 任务
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1.函数简介
## 1.1 xTaskCreate()
* 功能

使用动态的方式（系统分配堆栈空间）创建一个任务,需要定义configSUPPORT_DYNAMIC_ALLOCATION为1。

* 原型

```
BaseType_t xTaskCreate(	TaskFunction_t pxTaskCode,	/*<任务函数*/
	const char * const pcName,	/*<任务名字，用于追踪和调试，长度不能超过configMAX_TASK_NAME_LEN*/
	const configSTACK_DEPTH_TYPE usStackDepth,/*<任务堆栈的大小，是usStackDepth的4倍，空闲任务为configMINIMAL_STACK_SIZE>/
	void * const pvParameters,	/*<传递给任务函数的参数*/
	UBaseType_t uxPriority,	/*<任务的优先级，数值越大，优先级越高。和中断NVIC相反。*/
	TaskHandle_t * const pxCreatedTask 	/*<任务句柄，该任务的任务堆栈*/
)
```

* 返回值

pdPASS：任务创建成功

errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY：任务创建失败，因为堆内存不足

## 1.2 xTaskCreateStatic()
* 功能

使用静态的方式（用户分配堆栈空间）创建一个任务，需要定义configSUPPORT_STATIC_ALLOCATION为1。

* 原型

```
TaskHandle_t xTaskCreateStatic(	TaskFunction_t pxTaskCode,	/*<任务函数*/
	const char * const pcName,	/*<任务名字，用于追踪和调试，长度不能超过configMAX_TASK_NAME_LEN*/
	const uint32_t ulStackDepth,/*<任务堆栈的大小，一般由用户给出>/
	void * const pvParameters,	/*<传递给任务函数的参数*/
	UBaseType_t uxPriority,	/*<任务的优先级，数值越大，优先级越高。和中断NVIC相反。*/
	StackType_t * const puxStackBuffer,	/*<任务堆栈，一般为数组，数据类型是StackType_t*/
	StaticTask_t * const pxTaskBuffer 	/*<任务控制块*/
)
```

* 返回值

NULL：任务创建失败。puxStackBuffer或者pxTaskBuffer为NULL的时候会导致该错误发生。

其他值：任务创建成功，返回任务的句柄。

## 1.3 xTaskCreateRestricted()
* 功能

创建任务，要求MCU有MPU（内存保护单元），此函数创建的任务受到MPU保护。其余功能和xTaskCreate()相同。

* 原型

```
BaseType_t xTaskCreateRestrictedStatic( 
const TaskParameters_t * const pxTaskDefinition, /*<指向一个结构体TaskParameters_t，描述了任务的任务函数、堆栈大小、优先级等，该结构体在task.h中定义。*/
 TaskHandle_t *pxCreatedTask /*<任务句柄*/
)
```

* 返回值

pdPASS：任务创建成功。

其他值：任务为创建成功，很有可能是因为FreeRTOS的堆太小了。

## 1.4 vTaskDelete()
删除一个用xTaskCreate()或者xTaskCreateStatic()创建的任务，被删除了的任务不再存在。

如果xTaskCreate()创建的（即动态方法），则堆栈和控制块会在空闲任务中被释放。使用vTaskDelete()删除任务后必须给空闲任务一定的运行时间。

而用户分配的任务内存需要用户释放，比如某任务调用了pvPortMalloc()分配了500字节内存，则此任务删除后，用户必须调用vPortFree()将这500个字节释放，否则会造成内存泄漏。


## 1.5 vTaskSuspend()
* 功能

挂起一个任务

* 原型

```
void vTaskSuspend( TaskHandle_t xTaskToSuspend );
```

* 说明

参数表示要删除的任务的句柄。如果是NULL，则表示删除自身。

用vTaskSuspend()可以恢复。

如果在中断中恢复，则要使用vTaskSuspendFromISR()。
