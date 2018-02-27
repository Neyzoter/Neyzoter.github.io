---
layout: post
title: STM32L1的电源和运行模式
categories: MCU
description: STM32L1的电源和运行模式介绍
keywords: STM32L1, 运行模式, 电源, 时钟
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1、供电
供电电压一览图

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/PowerSupplyOverview.png" width="700" alt="供电电压一览图" />

* 设备输入电压

1.8V（Brown Out Reset,BOR）~3.6V

* V_CORE

1.2V~1.8V，用于数字外围设备，SRAM，Flash Memory

由内部电压转化电路提供

* V_DDA 、V_SSA

1.8V（BOR）~3.6V

V_DDA 是为ADC、DAC复位模块、RC振荡器和PLL。

* V_REF+、V_REF-

输入参考电压。

* V_LCD

2.5V~3.6V，LCD（液晶显示）控制器可以由V_LCD引脚（STM32L1是引脚PIN_1）或者内部升压器产生

如果LCD电源基于内部升压电路，那么PIN_1应该连接一个电容

# 2、内部稳压器
内部稳压器为所有的数字电路提供电源（除了备用电路standby circuitry）

内部稳压器输出电压（V_CORE）可以用程序选择三种不同的范围：1.2~1.8V之间

内部稳压器在复位后总是开启，三种工作模式：main（MR）、low-power（LPR）和power down。不同的设备工作模式（运行模式（run mode）、低功耗运行模式（low-power run mode）、睡眠模式（sleep mode）、停止模式（stop mode）、待机模式（standby mode））对应不同的内部稳压器工作电压。

以下是设备的工作模式：

* 运行模式

采用MR模式的内部稳压器为V_CORE供电

* 低功耗运行模式

采用LPR模式的内部稳压器为V_CORE供电

* 睡眠模式

采用MR模式的内部稳压器为V_CORE供电

* 低功耗睡眠模式

采用LPR模式的内部稳压器为V_CORE供电

* 停止模式

采用LPR模式的内部稳压器为V_CORE供电，保存寄存器和内部SRAM的内容。

* 待机模式

内部稳压器停止，除了备用电路外寄存器和SRAM的内容全部丢失。

以下是三种不同的内部稳压器工作模式（动态电压范围管理）：

* RANGE1

高性能模式，V_CORE电压为1.8V

* RANGE2

中等性能，V_CORE电压为1.5V，闪存仍然工作，但是以中速的存取时间。此时，在闪存上编程或者擦除操作仍然是可行的。

* RANGE3

低性能，V_CORE电压为1.2V，闪存仍然工作，但是以低速的存取时间。此时，在闪存上编程或者擦除操作是不可行的。

下面是不同的RANGE对应不同的 V_DD 和 V_CORE：

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/PerformanceVersusVDDandVCORERange.png" width="700" alt="不同的RANGE对应不同的V_DD和V_CORE" />

# 3、低功耗模式总结
自上而下，功耗越来越低。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/SummaryofLow-PowerModes.png" width="600" alt="低功耗模式总结" />

## 3.1 低功耗运行模式
如果APB1时钟频率小于RTC时钟的7倍，需要软件读取两次RTC寄存器。如果两次读取结果不同，则需要读第三次。

在V_CORE为RANGE2时，低功耗模式才能进入。

* 进入低功耗模式

1、数字 IP 时钟管理

用RCC_APBxENR或者RCC_AHBENR打开或者关闭。

2、系统时钟SYSCLK

SYSCLK不能超过MSI的range1频率（应该是131.072KHz吧）。

3、软件设置低功耗运行模式

LPRUN and LPSDSR的位设置。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/PWR_CR.png" width="800" alt="PWR_CR寄存器" />

* 退出低功耗模式

1、软件设置内部稳压器

设置为Main模式。

2、打开闪存（如果需要）

3、系统时钟提升

## 3.2 睡眠模式
* 进入睡眠模式

通过Cortex-M3系统控制寄存器SLEEPONEXIT，设置WFI（Wait For Interrupt）或者WFE（Wait For Event）指令：

**立即睡眠**：清除中断待命位（interrupt pending bits），SLEEPONEXIT清0，一旦WFI或者WFE指令执行，进入睡眠模式。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/Sleep-Now.png" width="600" alt="进入立即睡眠" />

**退出（中断）后睡眠**：清除中断待命位（interrupt pending bits），SLEEPONEXIT置1，一旦MCU退出最低优先级的中断服务程序（Interrupt Service Routine，ISR），进入睡眠模式。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/Sleep-on-Exit.png" width="600" alt="退出（中断）后睡眠" />

**注**：在睡眠模式下，IO口的状态同运行模式下相同。

* 退出睡眠模式

WFI：NVIC的任何中断，退出睡眠模式。

WFE：事件（Event）出现时，退出睡眠模式。

退出（中断）后睡眠的方式可以通过中断来唤醒。

## 3.3 低功耗睡眠模式
内部稳压器处于低功耗（LPR）模式，给WFI或者WFE指令。

闪存停止使用，内存保持可用。

系统频率不能超过MSI的range1频率，V_CORE是RANGE2。

如果APB1时钟频率小于RTC时钟的7倍，需要软件读取两次RTC寄存器。如果两次读取结果不同，则需要读第三次。

和睡眠模式相同，有**立即睡眠**和**退出（中断）后睡眠**

* 进入低功耗睡眠模式

1、关闭闪存

采用FLASH_ACR寄存器中的SLEEP_PD位

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/FLASH_ACR.png" width="800" alt="FLASH_ACR寄存器" />

2、数字IP时钟使能或者失能

3、降低系统时钟SYSCLK

4、内部稳压器

用软件设置为低功耗模式（LPR）。

5、WFI或者WFE指令

**注**：低功耗睡眠模式下，IO状态和运行模式相同。

* 退出低功耗睡眠模式

WFI：NVIC的任何中断，退出睡眠模式。

WFE：事件（Event）出现时，退出睡眠模式。

## 3.4 停止模式
所有V_CORE域内的时钟停止，PLL、MSI、HSI和HSE RC晶振失能，内部的SRAM和寄存器保留。

为了实现低功耗，内部的闪存进入低功耗模式。当闪存在掉电模式（Power Down Mode）时，从停止模式唤醒需要更多的唤醒时间。

为了实现低功耗，在进入停止模式前，V_REFINT、BOR、PVD和温度传感器可以关闭。退出停止模式后可以打开这些功能。

在停止模式下，下列特性可以被选择：

1、独立看门狗（IWDG）

独立看门狗开启后不能停止，除非复位。

2、RTC

RCC_CSR寄存器的RTCEN位设置。

3、LSI RC

内部RC晶振在RCC_CSR寄存器的LSION位设置。

4、LSE OSC
外部32.768KHz晶振在RCC_CSR寄存器的LSEON位设置。

**注**：ADC、DAC和LCD在停止模式下也会消耗能量，除非失能。失能方法：ADC_CR2寄存器的ADON位和DAC_CR寄存器的ENx位需要置0。

在待机或者停止模式下，Debug连接丢失，Debug无法使用，因为M3内核无时钟作用。

下表是进入和退出停止模式：

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/EnteringStopMode.png" width="600" alt="进入和退出停止模式" />

退出停止模式后，选MSI为系统时钟。

## 3.5 待机模式
最低功耗模式，基于Cortex-M3的deepsleep模式，同时内部稳压器失能（所以V_CORE也没上电）。

PLL、MSI、HSI和HSE晶振失能。

SRAM和寄存器数值丢失，除了RTC寄存器、RTC备份寄存器和待机电路（Standby circuitry ）。

在待机模式下，下列特性可以被选择：

1、独立看门狗（IWDG）

独立看门狗开启后不能停止，除非复位。

2、RTC

RCC_CSR寄存器的RTCEN位设置。

3、LSI RC

内部RC晶振在RCC_CSR寄存器的LSION位设置。

4、LSE OSC
外部32.768KHz晶振在RCC_CSR寄存器的LSEON位设置。

下表是待机模式的进入和退出：

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/EnteringStandbyMode.png" width="600" alt="进入和退出停止模式" />

唤醒方式包括：

WKUP引脚的上升沿、RTC Alarm（包括Alarm A和B）、RTC wakeup、tamper event、时间戳事件（time-stamp event）、外部的复位信号、IWDG的复位信号。

**注**：IO处于高阻状态，除了Reset pad（仍然可用）、RTC_AF1引脚（PC13，如果设置为WKUP2、tamper、time-sleep、RTC闹钟输出——Alarm out或者RTC时钟校准输出——calibration out）、WKUP 引脚1（PA0，如果使能的话）、WKUP引脚3（PE6，如果使能的话，L152没有）

在待机或者停止模式下，Debug连接丢失，Debug无法使用，因为M3内核无时钟作用。

## 3.6 RTC和比较器退出停止或者待命模式
RTC闹钟事件、RTC唤醒事件、篡改事件（tamper event）、时间戳事件或者比较器事件，而不需要外部中断。

可以通过RCC_CSR寄存器的RTCSEL位来选择RTC唤醒停止或者待命模式的时钟。可见可以选择低功耗外部晶振LSE或者低功耗内部RC振荡器作为唤醒时钟源。

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/EnteringStandbyMode.png" width="600" alt="RCC_CSR寄存器的RTCSEL位" />

### 3.6.1 RTC唤醒停止模式
* RTC闹钟事件唤醒

1、设置外部中断线17（EXTI Line 17）为上升沿触发（中断或者事件模式）。

2、在RTC\_CR寄存器中使能RTC闹钟中断。

3、配置RTC以生成RTC闹钟。

* RTC篡改或者时间戳事件唤醒

1、设置外部中断线19（EXTI Line 17）为上升沿触发（中断或者事件模式）。

2、在RTC\_CR寄存器中使能RTC的时间戳中断；在RTC\_TCR寄存器中使能RTC篡改中断。

3、配置RTC以探测到篡改中断和时间戳事件。

* RTC唤醒事件（Wakeup Event）唤醒

1、设置外部中断线20（EXTI Line 20）。

2、在RTC\_CR寄存器中使能RTC唤醒中断。

3、配置RTC以产生RTC唤醒中断。

### 3.6.2 RTC唤醒待命模式
* RTC闹钟事件唤醒

1、在RTC\_CR寄存器中使能RTC闹钟中断。

2、配置RTC以生成RTC闹钟。

* RTC篡改或者时间戳事件唤醒

1、在RTC\_CR寄存器中使能RTC的时间戳中断；在RTC\_TCR寄存器中使能RTC篡改中断。

2、配置RTC以探测到篡改中断和时间戳事件。

* RTC唤醒事件（Wakeup Event）唤醒

1、在RTC\_CR寄存器中使能RTC唤醒中断

2、配置RTC以产生RTC唤醒中断

<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/RTC_CR.png" width="600" alt="RTC_CR寄存器" />

### 3.6.3 比较器唤醒停止模式
1、设置外部中断线21（比较器1）或者外部中断线22（比较器2）为上升沿触发，中断或者事件模式。

2、配置比较器以生成事件。

## 3.7 待机模式实现
### 3.7.1 电源控制寄存器PWR_CR介绍
<img src="/images/posts/2018-2-16-PWR-Mode-of-STM32L1/CWUFandPDDS.png" width="600" alt="PWR_CR寄存器的CWUF和PDDS位" />

* CWUF：将唤醒标志清零，clear wakeup flag，总是读到0。

0：没有作用

1：在两个系统时钟周期后，清除WUF唤醒标志位

* PDDS：深度睡眠掉电，power-down deepsleep

0：CPU深度睡眠时进入停止模式

1：CPU深度睡眠时进入待机模式

该寄存器我们只关心 bit1 和 bit2 这两个位，这里我们通过设置PWR_CR的PDDS位，使CPU进入深度睡眠时进入待机模式，同时我们通过CWUF位，清除之前的唤醒位。

### 3.7.2 电源控制/状态寄存器PWR_CSR介绍
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

未完待续...


# 5、说明

系统时钟：SYSCLK

CPU时钟、AHB时钟：HCLK

APB时钟：PCLK






