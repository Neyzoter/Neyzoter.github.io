---
layout: post
title: FreeRTOS学习笔记(4)FreeRTOS的中断配置和临界端
categories: RTOS
description: FreeRTOS学习笔记(4)FreeRTOS的中断配置和临界端
keywords: FreeRTOS, NVIC 
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1.Cortex-M中断

## 1.1 中断介绍
Cortex-M3和M4都有最多240个IRQ中断，1个不可屏蔽中断（NMI），1个SysTick中断和多个系统异常。

Cortex-M处理器有3个固定优先级和256个可编程的优先级，最多128个抢占优先级，实际由芯片厂商决定优先级数量（如STM32采用4位来控制，共16级）。


>注：8位宽优先级配置寄存器为什么最多128个抢占优先级？因为分为了抢占优先级和亚优先级。
>
>而抢占优先级支持中断嵌套，即高优先级可以打断低优先级；亚优先级不支持中断嵌套，即如果抢占优先级相同，亚优先级高的中断无法打断正在运行的亚优先级低的中断。不过如果抢占优先级相同，亚优先级不同，而且中断同时到来，优先运行亚优先级高的中断。
>
>Hard Fault、NMI、RESET优先级为负数，高于普通中断优先级，且不可以配置。

FreeRTOS没有处理亚优先级，所以配置STM32的优先级为组4，全部为抢占优先级。

## 1.2 优先级配置
每个外部中断优先级寄存器，分别都是8位，所以最大宽度是8位，而最小为3位。

4个相邻的优先级寄存器组成32位寄存器。FreeRTOS在设置PendSV和SysTick中断优先级的时候都是直接操作0xE000_ED20这个32位寄存器。该寄存器地址从低到高分别为调试监视器的优先级（0xE000_ED20）、-（0xE000_ED21）、PendSV的优先级（0xE000_ED22）、SysTick的优先级（0xE000_ED23）。

## 1.3 重要的寄存器
<img src="/images/posts/2018-4-3-FreeRTOS-Note4-NVIC/ThreeNVICMask.png" width="600" alt="3个重要的屏蔽寄存器" />

* PRIMASK

用于禁止NMI和HardFault之外的所有异常和中断。

可以用CPS（修改处理器状态）指令来修改寄存器的数值。

```
//使能中断（清除PRIMASK）
CPSIE I;

//禁止中断（设置PRIMASK）
CPSID I;
```

也可以通过MRS和MSR：

```
MOVS R0,#1;

MSR PRIMASK ,R0;//1写入PRIMASK

```

* FAULTMASk

除了NMI之外的所有异常和中断都屏蔽掉。

```
//使能中断（清除FAULTMASk）
CPSIE F;

//禁止中断（设置FAULTMASk）
CPSID F;
```

也可以用MSR和MRS，参考PRIMASK。

* BASEPRI

用于设置是否屏蔽中断的优先级阈值。所有优先级数值（优先级数值越大，优先级越低）大于等于该值的中断均被关闭。如，希望屏蔽优先级低于0x60（即优先级数值大于等于0x60）的中断，可以将该寄存器设置为0x60。**但是**，如果写0，则会停止屏蔽中断而**不是**屏蔽大于等于0的所有中断。

>注：FreeRTOS的开关中断通过操作BASEPRI寄存器实现的。关闭优先级小于该值的中断，打开大于该值的中断。

# 2.FreeRTOS中断配置宏介绍
在FreeRTOSconfig.h中设置。

* （1）configPRIO_BITS

用来设置MCU使用几位优先级，STM32采用的是4bits，所以是4。

* （2）configLIBRARY_LOWEST_INTERRUPT_PRIORITY

用来设置最低优先级。STM32采用4bits且用抢占优先级：亚优先级 = 4：0，故优先级从0到15。所以对于STM32该值设置为15。

* （3）configKERNEL_INTERRUPT_PRIORITY

配置内核中断优先级。代码如下

```
#define configKERNEL_INTERRUPT_PRIORITY 		( configLIBRARY_LOWEST_INTERRUPT_PRIORITY << (8 - configPRIO_BITS) )
```

代码表示：内核中断优先级配置为宏configLIBRARY_LOWEST_INTERRUPT_PRIORITY（最低优先级）左移（8 - MCU采用优先级位数），即移到高四位。为什么这么设置呢？因为STM32采用**高四位**作为优先级设置位。

configKERNEL_INTERRUPT_PRIORITY用来设置PendSV和滴答时钟的中断优先级，定义如下。

```
#define portNVIC_PENDSV_PRI		( ( ( uint32_t ) configKERNEL_INTERRUPT_PRIORITY ) << 16UL )
#define portNVIC_SYSTICK_PRI	( ( ( uint32_t ) configKERNEL_INTERRUPT_PRIORITY ) << 24UL )
```

这里左移16位和24位的意思可以参考《1.2 优先级配置》:SysTickd的8位寄存器地址：0xE000_ED23；PendSV的8位寄存器地址0xE000_ED22（每个地址指向一个8位的寄存器）。

在函数xPortStartScheduler中定义了这两者的优先级：

```
//portNVIC_SYSPRI2_REG寄存器包含了0xE000_ED20之后32位的寄存器
//其中从低到高分别是调试监视器（0xE000_ED20）、--（0xE000_ED21）、PendSV（0xE000_ED22）和SysTick（0xE000_ED23）
portNVIC_SYSPRI2_REG |= portNVIC_PENDSV_PRI;
portNVIC_SYSPRI2_REG |= portNVIC_SYSTICK_PRI;
```

由此可见，给PendSV和SysTick的优先级配置了最低优先级15。

* （4）configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY

用来设置FreeRTOS系统可管理的最大优先级。低于该值的优先级归FreeRTOS管理；高于该值的优先级不归FreeRTOS管理。

将该值给BASEPRI寄存器赋值。FreeRTOS的开关中断通过操作BASEPRI寄存器实现的。关闭优先级小于该值的中断，打开大于该值的中断。

```
#define configMAX_SYSCALL_INTERRUPT_PRIORITY 	( configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY << (8 - configPRIO_BITS) )
```

* （5）configMAX_SYSCALL_INTERRUPT_PRIORITY

该宏由configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY左移4位得到，道理同configKERNEL_INTERRUPT_PRIORITY。

```
#define configMAX_SYSCALL_INTERRUPT_PRIORITY 	( configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY << (8 - configPRIO_BITS) )
```

该宏设置完毕后，低于该优先级的中断可以安全的调用FreeRTOS的API函数，高于此优先级的中断FreeRTOS无法禁止，所以也不能调用API。

>注：FreeRTOS内核源码中有多处开关全局中断的地方，这些开关全局中断会加大中断延迟时间。比如在源码的某个地方关闭了全局中断，但是此时有外部中断触发，这个中断的服务程序就需要等到再次开启全局中断后才可以得到执行。开关中断之间的时间越长，中断延迟时间就越大，这样极其影响系统的实时性。如果这是一个紧急的中断事件，得不到及时执行的话，后果是可想而知的。
>
>针对这种情况，FreeRTOS就专门做了一种新的开关中断实现机制。关闭中断时仅关闭受FreeRTOS管理的中断，不受FreeRTOS管理的中断不关闭，**这些不受管理的中断都是高优先级的中断，用户可以在这些中断里面加入需要实时响应的程序。**


<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/BASEPRI_USED.png" width="600" alt="BASEPRI设置为5后的效果" />

# 3.临界段代码
即临界区，必须完整运行，而不能被打断的代码，比如有的外设初始化需要严格的时序，初始化过程不能被打断。FreeRTOS进入临界区代码时，关闭中断，处理完临界区代码以后再打开中断。

包含四个函数：taskENTER_CRITICAL()、taskEXIT_CRITICAL()、taskENTER_CRITICAL_FROM_ISR()、taskEXIT_CRITICAL_FROM_ISR( x )。前两个是**任务级**的临界段代码保护，后两个是**中断级**的临界段代码保护。中断级的临界区代码保护用在中断函数中，并且该中断的优先级必须比configMAX_SYSCALL_INTERRUPT_PRIORITY数值大（即优先级小，也就是在调用之前会把该中断给关掉）。


## 3.1 任务级临界区代码保护
```
#define taskENTER_CRITICAL()		portENTER_CRITICAL()
#define taskEXIT_CRITICAL()			portEXIT_CRITICAL()
```

```
#define portENTER_CRITICAL()					vPortEnterCritical()
#define portEXIT_CRITICAL()						vPortExitCritical()
```

portENTER_CRITICAL和portEXIT_CRITICAL具体代码：

```
void vPortEnterCritical( void )
{
	portDISABLE_INTERRUPTS();//关闭中断<首先给BASEPRI赋值（configMAX_SYSCALL_INTERRUPT_PRIORITY），然后关闭优先级数值比该值高的中断>
	uxCriticalNesting++;//用于记录临界区嵌套次数，全局变量

	/* This is not the interrupt safe version of the enter critical function so
	assert() if it is being called from an interrupt context.  Only API
	functions that end in "FromISR" can be used in an interrupt.  Only assert if
	the critical nesting count is 1 to protect against recursive calls if the
	assert function also uses a critical section. */
	if( uxCriticalNesting == 1 )
	{
		configASSERT( ( portNVIC_INT_CTRL_REG & portVECTACTIVE_MASK ) == 0 );
	}
}
```

```
void vPortExitCritical( void )
{
	configASSERT( uxCriticalNesting );
	uxCriticalNesting--;//退出一个临界区代码嵌套就减一
	if( uxCriticalNesting == 0 )//所有临界区代码均退出滞后，打开中断
	{
		portENABLE_INTERRUPTS();//给BASEPRI赋值0<即所有的中断都不关闭>，打开中断
	}
}
```



任务级临界区代码保护步骤包括：

>1）进入临界区
>
>2）（精简的）临界区代码
>
>3）退出临界区

注：临界区代码需要精简，否则由于执行临界区代码过程中导致优先级低于configMAX_SYSCALL_INTERRUPT_PRIORITY的中断（已经被关闭）可不到及时响应。
## 3.2 中断级临界区代码保护

```
#define taskENTER_CRITICAL_FROM_ISR() portSET_INTERRUPT_MASK_FROM_ISR()
#define taskEXIT_CRITICAL_FROM_ISR( x ) portCLEAR_INTERRUPT_MASK_FROM_ISR( x )
```

```
#define portSET_INTERRUPT_MASK_FROM_ISR()		ulPortRaiseBASEPRI()
#define portCLEAR_INTERRUPT_MASK_FROM_ISR(x)	vPortSetBASEPRI(x)
```

ulPortRaiseBASEPRI和vPortSetBASEPRI具体代码：

```
static portFORCE_INLINE uint32_t ulPortRaiseBASEPRI( void )
{
uint32_t ulReturn, ulNewBASEPRI = configMAX_SYSCALL_INTERRUPT_PRIORITY;

	__asm
	{
		/* Set BASEPRI to the max syscall priority to effect a critical
		section. */
		mrs ulReturn, basepri		;读出BASEPRI的值，保存在ulReturn中
		msr basepri, ulNewBASEPRI	;将configMAX_SYSCALL_INTERRUPT_PRIORITY（可管理的最大优先级）的值写入BASEPRI
		dsb
		isb
	}

	return ulReturn;		;返回BASEPRI中原来保存的值，退出临界区代码需要使用（重新给BASEPRI赋值）
}
```

```
static portFORCE_INLINE void vPortSetBASEPRI( uint32_t ulBASEPRI )
{
	__asm
	{
		/* Barrier instructions are not used as this function is only used to
		lower the BASEPRI value. */
		msr basepri, ulBASEPRI
	}
}
```

中断级临界区代码（在中断服务函数中）保护步骤包括：

>1）进入临界区
>
>2）（精简的）临界区代码
>
>3）退出临界区

<img src="/images/posts/2018-4-1-FreeRTOS-Note3-Config/IRQHandler_Protect.png" width="600" alt="中断服务函数中的临界区代码" />

**为什么中断级和任务级不同？**

>区别：
>
>中断级进入前保存当前的BASEPRI值，并给其赋值configMAX_SYSCALL_INTERRUPT_PRIORITY，实现关闭比configMAX_SYSCALL_INTERRUPT_PRIORITY优先级低的中断。退出的时候需要给BASEPRI赋值进入临界区代码前的值。也就是中断级无法嵌套。
>
>任务级进入前关闭中断，而不保存当前BASEPRI的初始值，每次嵌套都要保存嵌套了几次。当全部嵌套退出后，给BASEPRI赋值0，打开中断。







