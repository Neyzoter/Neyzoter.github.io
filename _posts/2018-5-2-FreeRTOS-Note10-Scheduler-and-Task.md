---
layout: post
title: FreeRTOS学习笔记(10)调度器开启和任务相关函数
categories: RTOS
description: FreeRTOS学习笔记(10)调度器开启和任务相关函数
keywords: FreeRTOS, 调度器
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1、任务创建函数

```C
BaseType_t xTaskCreate(	TaskFunction_t pxTaskCode,
						const char * const pcName,		/*lint !e971 Unqualified char types are allowed for strings and single characters only. */
						const configSTACK_DEPTH_TYPE usStackDepth,
						void * const pvParameters,
						UBaseType_t uxPriority,
						TaskHandle_t * const pxCreatedTask )
{
TCB_t *pxNewTCB;
BaseType_t xReturn;

	/* If the stack grows down then allocate the stack then the TCB so the stack
	does not grow into the TCB.  Likewise if the stack grows up then allocate
	the TCB then the stack. */
	//编译函数
	#if( portSTACK_GROWTH > 0 )
	{
		/* Allocate space for the TCB.  Where the memory comes from depends on
		the implementation of the port malloc function and whether or not static
		allocation is being used. */
		pxNewTCB = ( TCB_t * ) pvPortMalloc( sizeof( TCB_t ) );

		if( pxNewTCB != NULL )
		{
			/* Allocate space for the stack used by the task being created.
			The base of the stack memory stored in the TCB so the task can
			be deleted later if required. */
			pxNewTCB->pxStack = ( StackType_t * ) pvPortMalloc( ( ( ( size_t ) usStackDepth ) * sizeof( StackType_t ) ) ); /*lint !e961 MISRA exception as the casts are only redundant for some ports. */

			if( pxNewTCB->pxStack == NULL )
			{
				/* Could not allocate the stack.  Delete the allocated TCB. */
				vPortFree( pxNewTCB );
				pxNewTCB = NULL;
			}
		}
	}
	#else /* portSTACK_GROWTH */
	{
	StackType_t *pxStack;

		/* Allocate space for the stack used by the task being created. */
		//pvPortMalloc给任务堆栈申请内存
		pxStack = ( StackType_t * ) pvPortMalloc( ( ( ( size_t ) usStackDepth ) * sizeof( StackType_t ) ) ); /*lint !e961 MISRA exception as the casts are only redundant for some ports. */

		if( pxStack != NULL )
		{
			/* Allocate space for the TCB. */
			pxNewTCB = ( TCB_t * ) pvPortMalloc( sizeof( TCB_t ) ); /*lint !e961 MISRA exception as the casts are only redundant for some paths. */

			if( pxNewTCB != NULL )
			{
				/* Store the stack location in the TCB. */
				/*任务控制块	内存申请成功后，初始化内存控制块中的任务堆栈字段pxStack*/
				pxNewTCB->pxStack = pxStack;
			}
			else
			{
				/* The stack cannot be used as the TCB was not created.  Free
				it again. */
				/*如果任务控制块内存申请失败，则释放之前申请的任务堆栈内存*/
				vPortFree( pxStack );
			}
		}
		else
		{
			pxNewTCB = NULL;
		}
	}
	#endif /* portSTACK_GROWTH */
	
	if( pxNewTCB != NULL )
	{
		#if( tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE != 0 ) /*lint !e731 Macro has been consolidated for readability reasons. */
		{
			/* Tasks can be created statically or dynamically, so note this
			task was created dynamically in case it is later deleted. */
			/*说明使用静态方法分配的内存*/
			pxNewTCB->ucStaticallyAllocated = tskDYNAMICALLY_ALLOCATED_STACK_AND_TCB;
		}
		#endif /* configSUPPORT_STATIC_ALLOCATION */
		
		/*初始化任务*/
		prvInitialiseNewTask( pxTaskCode, pcName, ( uint32_t ) usStackDepth, pvParameters, uxPriority, pxCreatedTask, pxNewTCB, NULL );
		/*将新创建的任务加入到就绪列表中*/
		prvAddNewTaskToReadyList( pxNewTCB );
		xReturn = pdPASS;
	}
	else
	{
		xReturn = errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY;
	}

	return xReturn;
}
```

# 2、任务调度器开启函数

## 2.1 任务调度开启
```C
void vTaskStartScheduler( void )
{
BaseType_t xReturn;

	/* 创建一个空闲任务，最低优先级. */
	#if( configSUPPORT_STATIC_ALLOCATION == 1 )  //如果是静态分配内存
	{
		StaticTask_t *pxIdleTaskTCBBuffer = NULL;
		StackType_t *pxIdleTaskStackBuffer = NULL;
		uint32_t ulIdleTaskStackSize;

		/* The Idle task is created using user provided RAM - obtain the
		address of the RAM then create the idle task. */
		vApplicationGetIdleTaskMemory( &pxIdleTaskTCBBuffer, &pxIdleTaskStackBuffer, &ulIdleTaskStackSize );
		xIdleTaskHandle = xTaskCreateStatic(	prvIdleTask,
												configIDLE_TASK_NAME,
												ulIdleTaskStackSize,
												( void * ) NULL, /*lint !e961.  The cast is not redundant for all compilers. */
												( tskIDLE_PRIORITY | portPRIVILEGE_BIT ),
												pxIdleTaskStackBuffer,
												pxIdleTaskTCBBuffer ); /*lint !e961 MISRA exception, justified as it is not a redundant explicit cast to all supported compilers. */
		
		if( xIdleTaskHandle != NULL )
		{
			xReturn = pdPASS;
		}
		else
		{
			xReturn = pdFAIL;
		}
	}
	#else	//如果是动态分配内存
	{
		/* The Idle task is being created using dynamically allocated RAM. */
		xReturn = xTaskCreate(	prvIdleTask,
								configIDLE_TASK_NAME,
								configMINIMAL_STACK_SIZE,
								( void * ) NULL,
								( tskIDLE_PRIORITY | portPRIVILEGE_BIT ),
								&xIdleTaskHandle ); /*lint !e961 MISRA exception, justified as it is not a redundant explicit cast to all supported compilers. */
	}
	#endif /* configSUPPORT_STATIC_ALLOCATION */

	/*使用软件定时器使能*/
	#if ( configUSE_TIMERS == 1 )
	{
		if( xReturn == pdPASS )
		{
			xReturn = xTimerCreateTimerTask();//如果使用软件定时器，创建软件定时器服务任务
		}
		else
		{
			mtCOVERAGE_TEST_MARKER();
		}
	}
	#endif /* configUSE_TIMERS */

	if( xReturn == pdPASS )
	{
		/* freertos_tasks_c_additions_init() should only be called if the user
		definable macro FREERTOS_TASKS_C_ADDITIONS_INIT() is defined, as that is
		the only macro called by the function. */
		#ifdef FREERTOS_TASKS_C_ADDITIONS_INIT
		{
			freertos_tasks_c_additions_init();
		}
		#endif

		/* Interrupts are turned off here, to ensure a tick does not occur
		before or during the call to xPortStartScheduler().  The stacks of
		the created tasks contain a status word with interrupts switched on
		so interrupts will automatically get re-enabled when the first task
		starts to run. */
		portDISABLE_INTERRUPTS();//关闭中断，保证滴答时钟在SVC中断服务函数xPortStartScheduler的时候不出现

		#if ( configUSE_NEWLIB_REENTRANT == 1 )		
		{
			/* Switch Newlib's _impure_ptr variable to point to the _reent
			structure specific to the task that will run first. */
			_impure_ptr = &( pxCurrentTCB->xNewLib_reent );		//使能Newlib
		}
		#endif /* configUSE_NEWLIB_REENTRANT */

		xNextTaskUnblockTime = portMAX_DELAY;
		xSchedulerRunning = pdTRUE;		//调度器设置为pdTRUE，表示正在运行
		xTickCount = ( TickType_t ) 0U;

		/* If configGENERATE_RUN_TIME_STATS is defined then the following
		macro must be defined to configure the timer/counter used to generate
		the run time counter time base.   NOTE:  If configGENERATE_RUN_TIME_STATS
		is set to 0 and the following line fails to build then ensure you do not
		have portCONFIGURE_TIMER_FOR_RUN_TIME_STATS() defined in your
		FreeRTOSConfig.h file. */
		/*CONFIGURE_TIMER_FOR_RUN_TIME_STATS为1时，说明使能时间统计工功能，需要用户编写
		portCONFIGURE_TIMER_FOR_RUN_TIME_STATS，来配置一个定时器/计数器*/
		portCONFIGURE_TIMER_FOR_RUN_TIME_STATS();

		/* Setting up the timer tick is hardware specific and thus in the
		portable interface. */
		/*xPortStartScheduler用于初始化和调度器启动那个相关的硬件--滴答定时器、FPU单元、PendSV中断*/
		if( xPortStartScheduler() != pdFALSE )
		{
			/* 如果调度器启动成功，则不会运行到这里，函数不会有返回值 */
		}
		else
		{
			/* 除非运行了 xTaskEndScheduler()，否则不会到这里. */
		}
	}
	else
	{
		/* This line will only be reached if the kernel could not be started,
		because there was not enough FreeRTOS heap to create the idle task
		or the timer task. */
		/*如果内核没有启动改成功，则会运行到这里
			导致的原因是创建空闲任务时，没有足够内存*/
		configASSERT( xReturn != errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY );
	}

	/* Prevent compiler warnings if INCLUDE_xTaskGetIdleTaskHandle is set to 0,
	meaning xIdleTaskHandle is not used anywhere else. */
	/*防止编译器报错，比如INCLUDE_xTaskGetIdleTaskHandle为0，则编译器会提示xIdleTaskHandle没有用在任何地方*/
	( void ) xIdleTaskHandle;
}
```

## 2.2 初始化调度器启动相关的硬件
xPortStartScheduler在任务开启函数vTaskStartScheduler中调用。
```C
BaseType_t xPortStartScheduler( void )
{
	//编译代码
	#if( configASSERT_DEFINED == 1 )
	{
		volatile uint32_t ulOriginalPriority;
		volatile uint8_t * const pucFirstUserPriorityRegister = ( uint8_t * ) ( portNVIC_IP_REGISTERS_OFFSET_16 + portFIRST_USER_INTERRUPT_NUMBER );
		volatile uint8_t ucMaxPriorityValue;

		/* Determine the maximum priority from which ISR safe FreeRTOS API
		functions can be called.  ISR safe functions are those that end in
		"FromISR".  FreeRTOS maintains separate thread and ISR API functions to
		ensure interrupt entry is as fast and simple as possible.

		Save the interrupt priority value that is about to be clobbered. */
		ulOriginalPriority = *pucFirstUserPriorityRegister;

		/* Determine the number of priority bits available.  First write to all
		possible bits. */
		*pucFirstUserPriorityRegister = portMAX_8_BIT_VALUE;

		/* Read the value back to see how many bits stuck. */
		ucMaxPriorityValue = *pucFirstUserPriorityRegister;

		/* The kernel interrupt priority should be set to the lowest
		priority. */
		configASSERT( ucMaxPriorityValue == ( configKERNEL_INTERRUPT_PRIORITY & ucMaxPriorityValue ) );

		/* Use the same mask on the maximum system call priority. */
		ucMaxSysCallPriority = configMAX_SYSCALL_INTERRUPT_PRIORITY & ucMaxPriorityValue;

		/* Calculate the maximum acceptable priority group value for the number
		of bits read back. */
		ulMaxPRIGROUPValue = portMAX_PRIGROUP_BITS;
		while( ( ucMaxPriorityValue & portTOP_BIT_OF_BYTE ) == portTOP_BIT_OF_BYTE )
		{
			ulMaxPRIGROUPValue--;
			ucMaxPriorityValue <<= ( uint8_t ) 0x01;
		}

		#ifdef __NVIC_PRIO_BITS
		{
			/* Check the CMSIS configuration that defines the number of
			priority bits matches the number of priority bits actually queried
			from the hardware. */
			configASSERT( ( portMAX_PRIGROUP_BITS - ulMaxPRIGROUPValue ) == __NVIC_PRIO_BITS );
		}
		#endif

		#ifdef configPRIO_BITS
		{
			/* Check the FreeRTOS configuration that defines the number of
			priority bits matches the number of priority bits actually queried
			from the hardware. */
			configASSERT( ( portMAX_PRIGROUP_BITS - ulMaxPRIGROUPValue ) == configPRIO_BITS );
		}
		#endif

		/* Shift the priority group value back to its position within the AIRCR
		register. */
		ulMaxPRIGROUPValue <<= portPRIGROUP_SHIFT;
		ulMaxPRIGROUPValue &= portPRIORITY_GROUP_MASK;

		/* Restore the clobbered interrupt priority register to its original
		value. */
		*pucFirstUserPriorityRegister = ulOriginalPriority;
	}
	#endif /* conifgASSERT_DEFINED */

	/* Make PendSV and SysTick the lowest priority interrupts. */
	/*设置PendSV的中断优先级，为最低优先级*/
	portNVIC_SYSPRI2_REG |= portNVIC_PENDSV_PRI;
	/*设置滴答定时器的中断优先级，为最低优先级*/
	portNVIC_SYSPRI2_REG |= portNVIC_SYSTICK_PRI;

	/* Start the timer that generates the tick ISR.  Interrupts are disabled
	here already. */
	/*设置滴答定时器的定时周期*/
	vPortSetupTimerInterrupt();

	/* Initialise the critical nesting count ready for the first task. */
	/*初始化临界区嵌套计数器，没进入一个临界区加1*/
	uxCriticalNesting = 0;

	/* Start the first task. */
	/*开始第一个任务，具体见下面代码*/
	prvStartFirstTask();

	/* Should not get here! */
	return 0;
}
```

开启第一个任务：

```C
__asm void prvStartFirstTask( void )
{
	PRESERVE8

	/* Use the NVIC offset register to locate the stack. */
	;VTOR寄存器在系统初始化的时候SystemInit设置，
	;SCB->VTOR = FLASH_BASE | VECT_TAB_OFFSET/*<VTOR=0x08000000+0x00*/
	ldr r0, =0xE000ED08		;//VTOR的寄存器地址
	ldr r0, [r0]			;//读取VTOR中的值0x08000000
	ldr r0, [r0]			;//获取MSP的初始值

	/* Set the msp back to the start of the stack. */
	msr msp, r0		;//复位MSP
	/* Globally enable interrupts. */
	cpsie i		;//使能中断（清除PRIMASK）
	cpsie f		;//使能中断（清除FAULTMASK）
	dsb			;//数据同步避障
	isb			;//指令同步避障
	/* Call SVC to start the first task. */
	svc 0		;//触发SVC异常，第一个任务在SVC中断服务程序中开始
	nop;
	nop;
}
```

SVC中断被重定义了

```C
#define vPortSVCHandler    SVC_Handler
```

SVC中断服务函数

```C
__asm void vPortSVCHandler( void )
{
	PRESERVE8

	ldr	r3, =pxCurrentTCB	/* 重载上下文pxCurrentTCB，其指向当前执行的TCB. */
	ldr r1, [r3]			/* Use pxCurrentTCBConst to get the pxCurrentTCB address. */
	ldr r0, [r1]			/* 任务控制块的第一个字段就是任务堆栈的栈顶指针pxTopOfStack指向的位置
								The first item in pxCurrentTCB is the task top of stack. */
	ldmia r0!, {r4-r11}		/* Pop the registers that are not automatically saved on exception entry and the critical nesting count. */
	msr psp, r0				/* Restore the task stack pointer. */
	isb
	mov r0, #0
	msr	basepri, r0		/*寄存器basepri=0，开启中断*/
	orr r14, #0xd
	bx r14
}
```

## 2.3空闲任务

1、判断系统是否有任务删除。如果有任务删除，在空闲任务中释放被删除的任务堆栈和任务控制块内存。

2、运行用户设置的空闲任务钩子函数。

3、判断是否开启了低功耗Tickless模式，进行相应处理。

