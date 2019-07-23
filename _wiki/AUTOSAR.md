---
layout: wiki
title: AUTOSAR
categories: AUTOSAR
description: AUTOSAR架构学习笔记
keywords: 汽车, AUTOSAR
---

# 1、AUTOSAR介绍

AUTOSAR 是针对特定的汽车电子这一领域，提出的一套开放式软件结构。其主体思想是使得软件设计开发更易于管理，软件系统更易于移植、裁剪，以及更好的维护性和质量保证。

## 1.1 AUTOSAR目的

| 挑战                                                         | 解决方法                                 | 好处                                                         |
| ------------------------------------------------------------ | ---------------------------------------- | ------------------------------------------------------------ |
| 不成熟的过程，因为 ad-hoc 模式/缺少对功能需要的追踪能力。缺少兼容的工具（供应商、OEM） | 标准化的规范交换格式                     | 对规范的改进（格式、内容）提供无缝的工具链。                 |
| 浪费在实现和优化组件上的努力，而顾客并不承认这些努力的价值。 | 基础软件核（BSW, Basic Software）        | 软件质量的加强。将工作集中在有价值的功能上。                 |
| 微控制器模型缺乏可用性，很难适应现有软件。（由新功能引起的）微控制器性能的扩展需求所导致的升级需要（如重新设计）。 | 微控制器抽象（MCAL）                     | 微控制器能在不需要改变更高软件层的情况下调换。               |
| 重定位 ECU 之间的功能时需要做大量的工作。
功能重用时也需要做大量的工作。 | 运 行 时 环 境(RTE, RunTime Environment) | 功能封装导致的通信技术的独立性。通过标准化机制，使得通信更加简单。使功能分区和功能重定位变得可能。 |
| 非竞争性功能必须适应OEM的特定环境。因为需要从其它组件供应接口需要很多功夫，所以哪怕是很微小的革新，也需要做很多工作。基础软件和模型生成的代码间缺少清晰的接口。 | 接口标准化                               | 减少/避免 OEM 和供应商之间的接口。通过使用通用接口目录，使独立于软件功能的硬件实现所耗费的工作量。简化模型驱动的开发，允许使用标准化的AUTOSAR代码生成工具。OEM 间的模型的可重用性。不同供应商之间模块的可交换性。 |

## 1.2 AUTOSAR架构

* **精简版**

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND1.png" width="700" alt="AUTOSAR总体图">

BSW可分为：

*I/O*：访问传感器、执行器、ECU板载总线

*Memery*：访问内部/外部存储器（**非易失性存储器**）

*Crypto*：访问加密原语（基本密码概念，如加密、签名、Hash等算法）

*Communication*：访问汽车网络系统、ECU板载通信系统、ECU内部软件（SW）

*Off-board Communication*：访问汽车-X通信、汽车内无线通信系统、ECU板外通信系统

*System*：提供标准化（操作系统、时钟、error memory错误存储）和ECU特定服务（状态管理、看门狗）和库函数

* **细化版**

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND2.png" width="700" alt="AUTOSAR总体图（较清楚细节）">

* **完整版**

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND3.png" width="700 " alt="AUTOSAR总体图（最清楚细节）">

## 1.3 AUTOSAR方法

<img src="/images/wiki/AUTOSAR/AutosarGenerateProcess.png" width="700 " alt="AUTOSAR总体图（最清楚细节）">

1.定义 System Configuration Input，选择软、硬件组件，标识系统总体限制

2.活动 Configure System 主要是将软件组件映射到关于资源和计时要求的 ECU 上

3.Configure System 的输出是 System Configuration Description：系统信息（如总线映射、拓扑等）和关于软件组件定位到哪个 ECU 的映射

4.活动 Extract ECU-Specific Information 从 System Configuration Description 中提取特定 ECU 所需的信息。

5.提取的信息输出到 ECU Extract of System Configuration

6.活动 Configure ECU 为实现添加了所有必需的信息，如任务调度、必需的 BSW（基础软件）模块、BSW 的配置、任务中可运行实体的赋值等。

7.活动 Configure ECU 的结果将输出给 ECU Configuration Description，它负责收集所有关于特定 ECU 的局部信息。通过这些信息可以构建该特定 ECU 的可执行软件。

8.在最后一步中，活动 Generate Executable 根据从 ECU Configuration Description中得到的信息生成可执行软件。这一步通常涉及生成代码（如为 RTE 和 BSW 生成代码）、编译代码（编译生长的代码或编译软件组件的源代码）、将所有编译后的代码连接成为可执行软件。

9.得到可执行 ECU 软件。

## 1.4 缩写词

* CANSM = CAN State Manager

# 2、BSW-MCAL

MicroController Abstraction Layer，BSW最底层，直接和芯片接触，对应AUTOSAR架构的红色部分。

## 2.1 微控制器驱动

Microcontroller Drivers



## 2.2 存储器驱动

Memory Drivers



## 2.3 加密驱动

Crypto Drivers



## 2.4 无线通信驱动

Wireless Communication Drivers



## 2.5 通信驱动

Communication Drivers



## 2.6 IO驱动

I/O Drivers

# 3、BSW-ECU抽象层

ECU Abstraction Layer，这一层与微控制器抽象层进行对接。它也包含了外部设备的驱动，不需要管外设位置、同芯片连接情况（端口、针脚、接口类型）。

**任务**：让更高层的软件层和ECU硬件独立。

## 3.1 板载设备抽象

Onboard Device Abstraction



## 3.2 存储硬件抽象

Memory Hardware Abstraction



## 3.3 加密硬件抽象

Crypto Hardware Abstraction



## 3.4 无线通信硬件抽象

Wireless Communication Hardware Abstraction



## 3.5 通信硬件抽象

Communication Hardware



## 3.6 IO硬件抽象

I/O Hardware Abstraction，目标是使数据通过RTE来传输，而不完全依赖于ECU硬件。

# 4、BSW-服务层

## 4.1 介绍

Services Layer，BSW最高层，**（任务）为应用、RTE和BSW提供基础服务**。

服务层和应用软件有关联，当对IO信号访问ECU抽象层时，提供：

* 操作系统功能
* 车辆网络通信及管理服务
* 存储管理（NVRAM 管理）
* 诊断服务（包括 UDS 通信及错误内存）
* ECU 状态管理

## 4.2 服务层架构

### 4.2.1 系统服务

System Services

<img src="/images/wiki/AUTOSAR/SystemServices.png" width="700 " alt="服务层架构">

# 5、BSW-复杂驱动层

Complex Drivers Layer，涉及到从硬件到RTE，**任务**：

* 在AUTOSAR中没有定义的芯片特殊驱动
* 高实时限制

# 6、RTE

Runtime Environment，是 AUTOSAR 虚拟功能总线（Virtual Function Bus，VFB）的接口（针对某个特定 ECU）的实现，为应用程序（软件组件）之间的通信提供了基本的服务，同时也便于访问包含 OS 的基本软件组件。

为了满足系统设计者所做的一些限制，应用程序组件能够在系统配置期间被映射到任何有效的 ECU 上。**RTE 负责确保这些（应用程序）组件能够通信，提供了在 AUTOSAR 软件组件间通信的基础服务。**

# 7、Core 21.0.0学习

<img src="/images/wiki/AUTOSAR/Build_System_schematic.png" width="700 " alt="make架构">

## 7.1 工程架构

**工程方案1.工程文件和Arctic Core分开**

*简单版本*

```
<anydir>                               - 工程
|--- config
|    |--- [config files]               - Overrides default module configurations
|    '--- <board>
|         '--- [config files]          - Overrides all other module configurations
|
|--- makefile
|--- [build_config.mk]  
'--- obj-<arch>
 
<Arctic Core>
|--- makefile
|--- boards
|    '--- <board>
|         |--- [config files]          - Default module configurations
|         '--- build_config.mk         - Configuration for the board
|
'--- scrips
     |--- config.mk
     |--- rules.mk
     '--- cc_gcc.mk
```

*详细功能版本*

```
<examples>               - 工程
|--- boards              - [ECL]  ecipse读取板子arxml
|--- HelloWorld
     |--- dbc            - [ECL]  描述CAN网络通信信号的文件
     |--- HelloWorld     - 具体工程
     |    |--- .settings - [ECL]  eclipse配置文件
     |    |--- swcs      - [ECL]  SWC描述文件
     |    |--- src       - [SWC]  软件组件  
     |    '--- config    - [RTE]  板子配置和RTE配置、接口、映射
     ...
|--- OsSimple
...
 
<Arctic Core>            - core
|--- .settings           - [ECL]    eclipse配置文件
|--- arxml               - [ECL]    ecipse读取ECU配置
|--- makefile            - [MAKE]   make顶层文件
|--- scrips              - [MAKE]   脚本(编译、链接)
|--- stylesheets         - [MAKE]   代码风格检查
|--- base                - [MAKE]   编译器基本定义
|--- diagnostic          - [SL]     诊断[Dlt Det Dcm..]
|--- system              - [SL]     操作系统[Os BswM EcuM SchM..]
|--- communication       - [ECU_AL] 通信HWA
|--- memory              - [ECU_AL] memory HWA
|--- Peripherals         - [ECU_AL] IO HWA, 会从examples读取参数
|--- safety_security     - [ECU_AL] 安全库和WDG
|--- cdd                 - [CDD]    Complex Device Driver
|--- drivers             - [MCAL]   驱动(CAN Fr等)
|--- arch                - [MCAL]   内有CAN收发器的SPI驱动
|--- mcal                - [MCAL]   mcal
|--- boards              - [MCAL]   具体板子配置结构体(WDG EEP FLS)
|--- clib                - [BASE]   c库函数
|--- common              - [BASE]   基础函数(log shell等)
|--- include             - [BASE]   内核inc文件给上层使用
|--- libs                - [BASE]   存放生成的libs
'--- datastructures      - [BASE]   数据结构(队列和安全队列)给RTE
```



**工程方案2.工程和Arctic Core在一起**

```
<Arctic Core>
|--- makefile
|--- boards
|    '--- <board>
|         |--- [config files]          - Default module configurations
|         '--- build_config.mk         - Configuration for the board
|
|--- <anydir>
|    |--- config
|    |    |--- [config files]          - Overrides default module configurations
|    |    '--- <board>
|    |          '--- [config files]    - Overrides all other module configurations
|    |
|    |--- makefile
|    |--- [build_config.mk]  
|    '--- obj-<arch>
|
'--- scrips
     |--- config.mk
     |--- rules.mk
     '--- cc_gcc.mk
```

## 7.2 工程make

**make命令**

```bash
# BOARDDIR：电路板；BDIR：工程样例目录
make BOARDDIR=mpc5516it BDIR=<anydir>[,<anydir>] all
```

**一些特定的变量**

* `MOD_AVAIL`

  一些可用模块，例如`ADC CAN DIO MCU FLS PORT PWM GPT EA`

* ` CFG`

  配置信息，例如`ARM ARMV7E_M ARM_CM4 HW_FLOAT THUMB`

  在文件中的冲突问题没有想明白。CFG=会不会影响其他文件中的CFG，但是CFG又没有export

* `MOD_USE`

  需要使用的模块，例如`MCU` 、`KERNEL`、**`RTE`**等，RTE的路径在`project_default.mk`中加入

* `COMPILER`

  编译器名称，如`gcc`

* `CROSS_COMPILE`

  编译器地址，如`/usr/lib/gcc-arm-none-eabi-4_9-2015q2/bin/arm-none-eabi-`，后面会加上`gcc`

  在文件`/core/scripts/guess_cc.sh`中运行了`export CROSS_COMPILE=$COMPILER`，在这里可以设置成和镜像默认的编译器。如wzh-ubuntu镜像的默认gcc版本是 5.4.0版本的，而4.9.3版本在`/usr/lib/gcc-arm-none-eabi-4_9-2015q2/bin/arm-none-eabi-gcc```

* `ASFLAGS` - `assembler flags`

  汇编flags

* `ASOUT`-`how to generate output file`

  如何生成输出文件

* `LDFLAGS`-`linker flags`

* `LDOUT`-`how to Generate linker output file`

* `LDMAPFILE` - `How to generate mapfile `

* `AROUT`-`archiver flags`

  归档器的flags

* obj-y : list of object files to build.

* VPATH : list of directories in which to look for source files.

* inc-y : list of directories in which to look for header files.

* libitem-y : list of libraries to include. 

* build-exe-y : the name of build the output file.

* ldcmdfile-y: path to linkscript, used when building "build-exe-y"

**make调用顺序**

[顶层（core/下）的makefile会（进入目录`<anydir>/obj_<arch>`）调用core/scripts/rules.mk](<https://github.com/Neyzoter/autosar_core21.0.0>)

## 7.3 模块相关代码

### 7.3.1 EcuM

`core/system/EcuM/src/EcuM_Generated_Types.h`：定义EcuM需要的(模块接口配置)数据结构。例子：

```c
if defined(USE_SPI)
     const Spi_ConfigType* SpiConfigPtr;
endif
```

### 7.3.2 OS任务

在`GEN_TASK_HEAD`中定义所有任务

```c
#define GEN_TASK_HEAD const OsTaskConstType  Os_TaskConstList[OS_TASK_CNT]
```
### 7.3.3 初始化

*未完待续*

```mermaid
graph LR;
main["main()@/core/system<br>/Os/rtos/src/os_init.c"]  --> EcuM_Init["EcuM_Init()@/core/system<br>/EcuM/src/EcuM.c"]
	EcuM_Init --1--> OS_CORE_IS_ID_MASTER["OS_CORE_IS_ID_MASTER(GetCoreID())<br>@/core/system/Os/rtos/inc/Os.h<br>如果多核,验证是否是主核<br>是主核运行2-10"]
	EcuM_Init --2--> SetCurrentState["SetCurrentState(ECUM_STATE_STARTUP_ONE)<br>@/core/system/EcuM/src/EcuM_Main.c<br>切换为STARTUP_TWO状态"]
	EcuM_Init --3--> EcuM_AL_DriverInitZero["EcuM_AL_DriverInitZero():初始化DET<br>@/core/system/EcuM/src/EcuM_Callout_Stubs.c<br>Ddefault Error Tracker(DET)初始化"]
	EcuM_Init --4--> InitOS["InitOS()<br>@/core/system/Os/rtos/src/os_init.c<br>Os初始化,添加Task"]
	EcuM_Init --5--> Os_IsrInit["Os_IsrInit()<br>@/core/system/Os/rtos/src/os_isr.c<br>中断初始化"]
	EcuM_Init --6--> EcuM_DeterminePbConfiguration["EcuM_World.config=EcuM_DeterminePbConfiguration()<br>@EcuM_Callout_Stubs.c<br>包含所有PostBuild配置文件"]
	EcuM_Init --7--> EcuM_AL_DriverInitOne["EcuM_AL_DriverInitOne(EcuM_World.config)<br>@EcuM_Callout_Stubs.c<br>OsStar之前的驱动初始化<br>MCU (DEM) PORT DIO (GPT) (WDG) (WDGM) <br>(DMA) (ADC) BSWM (STBM) PWM (OCU) (SHELL) USART<br>(..)代表本工程不使用"]
	EcuM_Init --8--> Mcu_GetResetReason["Mcu_GetResetReason()<br>@/core/mcal/Mcu/src/Mcu.c"<br>决定复位方式]
	EcuM_Init --9--> EcuM_SelectShutdownTarget["EcuM_SelectShutdownTarget()<br>@/core/system/EcuM/src/EcuM.c<br>选择低功耗的模式??-EcuM_OFF or SLEEP"]
	EcuM_Init --10--> StartOS["StartOs(EcuM_World.config->EcuMDefaultAppMode)<br>@/core/system/Os/rtos/src/os_init.c"]
```



### 7.3.4 CAN调用过程

**说明1**：`Github`不支持`mermaid`请**将以下`mermaid`代码复制到**[在线`mermaid`查看器](<https://mermaidjs.github.io/mermaid-live-editor>)、`Typora`等软件查看具体流程图。

**说明2**：CAN需要的底层接口包括`Can_Init( const Can_ConfigType *Config )`和`Can_ReturnType Can_Write( Can_HwHandleType Hth, const Can_PduType *PduInfo )`

*注*：Can_Init(ConfigPtr->PostBuildConfig->CanConfigPtr)：CanConfigPtr参数在Can_PBcfg.c

* **CAN数据接收**

  1.CAN接收中断初始化、触发、数据写入到IPdu过程

```mermaid
graph TB;
OsStartupTask["OsStartupTask()<br>@/examples/CanCtrlPwm/CanCtrlPwm/src/BSWMainFunctionTask.c"] --> EcuM_StartupTwo["EcuM_StartupTwo()<br>@/core/system/EcuM/src/EcuM_Fixed.c"]
EcuM_StartupTwo --> EcuM_AL_DriverInitTwo["EcuM_AL_DriverInitTwo(EcuM_World.config)<br>@/core/system/EcuM/src/EcuM_Callout_Stubs.c"]
EcuM_AL_DriverInitTwo --> Can_Init["Can_Init(ConfigPtr->PostBuildConfig->CanConfigPtr)<br>(CanConfigPtr参数在Can_PBcfg.c->CanConfigData)<br>CanConfigPtr而后赋值给Can_Global.config<br>@/core/mcal/Can/src/Can_stm32.c<br>!!!重点:从此处开始往下需要移植到TC26x"]
Can_Init --> INSTALL_HANDLERS["INSTALL_HANDLERS(Can_1, CAN1_SCE_IRQn, <br>USB_LP_CAN1_RX0_IRQn, CAN1_RX1_IRQn, USB_HP_CAN1_TX_IRQn)<br>@Can_stm32.c"]
INSTALL_HANDLERS --> ISR_INSTALL_ISR2["ISR_INSTALL_ISR2(名称, _can_name ## _Rx0Isr, _rx0, 2, 0)<br>@/core/include/isr.h"]
ISR_INSTALL_ISR2 --_can_name ## _Rx0Isr -> Can_1_Rx0Isr作为中断入口--> __ISR_INSTALL_ISR2["__ISR_INSTALL_ISR2(...)添加到中断向量表<br>@/core/include/isr.h"]
__ISR_INSTALL_ISR2 --中断触发--> Can_1_Rx0Isr["Can_1_Rx0Isr()@Can_stm32.c"]
Can_1_Rx0Isr --> Can_RxIsr["Can_RxIsr((int)CAN_CTRL_1,CAN_FIFO0)<br>@Can_stm32.c"]
Can_RxIsr --> CAN_Receive["CAN_Receive(canHw,fifo, &RxMessage):<br>读取fifo中数据到RxMessage<br>@stm32f10x_can.c"]
Can_RxIsr --> CanIf_RxIndication["CanIf_RxIndication(...,(uint8 *)&RxMessage.Data[0])<br>@/core/communication/CanIf/src/CanIf.c"]
CanIf_RxIndication --> CanIfUserRxIndications["CanIfUserRxIndications[3]()<br>@/examples/CanCtrlPwm/CanCtrlPwm/config/stm32_stm3210c/CanIf_Cfg.c"]
CanIfUserRxIndications --> PduR_CanIfRxIndication["PduR_CanIfRxIndication()@/core/communication/PduR/src/PduR_CanIf.c"]
PduR_CanIfRxIndication --> PduR_LoIfRxIndication["PduR_LoIfRxIndication(pduId(0), pduInfoPtr, 0x01)<br>@/core/communication/PduR/src/PduR_Logic.c"]
PduR_LoIfRxIndication --> PduR_ARC_RxIndication[" PduR_ARC_RxIndication(pduId, pduInfoPtr, serviceId)<br>@PduR_Logic.c"]
PduR_ARC_RxIndication --> PduR_ARC_RouteRxIndication["PduR_ARC_RouteRxIndication(destination, PduInfo)<br>@/core/communication/PduR/src/PduR_Routing.c"]
PduR_ARC_RouteRxIndication --> Com_RxIndication["Com_RxIndication(destination->DestPduId, PduInfo)@Com_Com.c<br>destination->DestPduId即为存放数据的下标0"]
Com_RxIndication --> memcpy["memcpy(Arc_IPdu->ComIPduDataPtr, <br>PduInfoPtr->SduDataPtr, IPdu->ComIPduSize)<br>ComIPduDataPtr指向接收到的数据"]
Com_RxIndication --> Com_Misc_RxProcessSignals["Com_Misc_RxProcessSignals():<br>会抛出Event(放在一个列表里)"]
```

2.OsBswTask将IPDU数据拷贝到DEFERRED_IPDU中

```mermaid
graph TB;
OsBswTask["OsBswTask()"] --> Com_MainFunctionRx["Com_MainFunctionRx()"]
Com_MainFunctionRx --> memcpy["memcpy(Arc_IPdu->ComIPduDeferredDataPtr,Arc_IPdu->ComIPduDataPtr,IPdu->ComIPduSize)"]
```

3.OsRteTask从DEFERRED_IPDU获取数据

```mermaid
graph TB;
OsRteTask["OsRteTask"] --Event--> Rte_lightManager_InteriorLightManagerMain["Rte_lightManager_InteriorLightManagerMain()<br>@/Rte/Config/Rte_InteriorLightManager.c"] 
Rte_lightManager_InteriorLightManagerMain --PRE--> Rte_Read_InteriorLightManager_lightManager_RearDoorStatus_message["Rte_Read_InteriorLightManager_lightManager_<br>RearDoorStatus_message(...)<br>@/Rte/Config/Rte_Internal_InteriorLightManager.c"]
Rte_Read_InteriorLightManager_lightManager_RearDoorStatus_message --> Com_ReceiveSignal["Com_ReceiveSignal(...)@<br>/core/communication/Com/src/Com_Com.c"]
Com_ReceiveSignal --> Com_Misc_ReadSignalDataFromPdu["Com_Misc_ReadSignalDataFromPdu()@<br>/core/communication/Com/src/Com_misc.c"]
```

* **CAN数据发送**

  对于CanCtrlPwm工程而言，在OsRteTask任务中将数据放到IPDU中，在从OsBswTask通过CAN周期性发送出去

  1.OsRteTask任务中将数据放到IPDU中

```mermaid
graph TB;
OsRteTask["OsRteTask"] --Event--> Rte_lightManager_InteriorLightManagerMain["Rte_lightManager_InteriorLightManagerMain()<br>@/Rte/Config/Rte_InteriorLightManager.c"] 
Rte_lightManager_InteriorLightManagerMain --PRE--> Rte_Read_InteriorLightManager_lightManager_RearDoorStatus_message["Rte_Read_InteriorLightManager_lightManager_<br>RearDoorStatus_message(...)<br>@/Rte/Config/Rte_Internal_InteriorLightManager.c"]
Rte_Read_InteriorLightManager_lightManager_RearDoorStatus_message --> Com_ReceiveSignal["Com_ReceiveSignal(...)@<br>/core/communication/Com/src/Com_Com.c"]
Com_ReceiveSignal --> Com_Misc_ReadSignalDataFromPdu["Com_Misc_ReadSignalDataFromPdu()@<br>/core/communication/Com/src/Com_misc.c"]

Rte_lightManager_InteriorLightManagerMain --MAIN--> ..

Rte_lightManager_InteriorLightManagerMain --POST--> Rte_Write_InteriorLightManager_lightManager_LightStatusOnCommMedia_message["Rte_Write_InteriorLightManager_lightManager_<br>LightStatusOnCommMedia_message(...)<br>@/Rte/Config/Rte_Internal_InteriorLightManager.c"]
Rte_Write_InteriorLightManager_lightManager_LightStatusOnCommMedia_message --> Com_SendSignal["Com_SendSignal(ComConf_ComSignal_<br>LightStatus, &value)<br>@/core/communication/Com/src/Com_Com.c"]
Com_SendSignal --> Com_Misc_WriteSignalDataToPdu["Com_Misc_WriteSignalDataToPdu(...)<br>@/core/communication/Com/src/Com_misc.c"]
Com_SendSignal --> Com_Misc_TriggerTxOnConditions["Com_Misc_TriggerTxOnConditions(...)<br>@Com_misc.c<br>对于CanCtrlPwm工程不从此步直接发送数据<br>而是从OsBswTask任务Com_MainFunctionTx发送数据<br>下面程序（虚线）未执行"]
	Com_Misc_TriggerTxOnConditions -.-> Com_Misc_TriggerIPDUSend["Com_Misc_TriggerIPDUSend(pduHandleId)<br>@Com_misc.c"]
	Com_Misc_TriggerIPDUSend -.-> PduR_ComTransmit["PduR_ComTransmit(IPdu->ArcIPduOutgoingId,<br> &PduInfoPackage)<br>@/core/communication/PduR/src/PduR_Com.c"]
	PduR_ComTransmit -.-> PduR_UpTransmit["PduR_UpTransmit(pduId, pduInfoPtr, 0x89)<br>@/core/communication/PduR/src/PduR_Logic.c"]
	PduR_UpTransmit -.->PduR_ARC_Transmit["PduR_ARC_Transmit(pduId, pduInfoPtr, serviceId)<br>@PduR_Logic.c"]
	PduR_ARC_Transmit -.-> PduR_ARC_RouteTransmit["PduR_ARC_Transmit(destination, PduInfo)<br>@/core/communication/PduR/src/PduR_Routing.c"]
	PduR_ARC_RouteTransmit -.-> CanIf_Transmit["CanIf_Transmit(destination->DestPduId, pduInfo)<br>@/core/communication/CanIf/src/CanIf.c"]
	CanIf_Transmit -.-> Can_Write["Can_Write(txPduPtr->CanIfTxPduBufferRef-><br>CanIfBufferHthRef->CanIfHthIdSymRef, &canPdu)<br>@/core/mcal/Can/src/Can_stm32.c"]
	Can_Write -.-> CAN_Transmit["CAN_Transmit(canHw,&TxMessage)<br>@stm32f10x_can.c"]
```

2.周期性从IPdu发送CAN数据

```mermaid
graph TB;
OsBswTask --> Com_MainFunctionTx["Com_MainFunctionTx()<br>@/core/communication/Com/src/Com_Sched.c"]
Com_MainFunctionTx --> Com_ProcessMixedOrPeriodicTxMode["Com_ProcessMixedOrPeriodicTxMode()<br>@Com_Sched.c"]
Com_ProcessMixedOrPeriodicTxMode --> Com_TriggerIPDUSend["Com_TriggerIPDUSend(IPduId)<br>@/core/communication/Com/src/Com_Com.c"]
Com_TriggerIPDUSend --> Com_Misc_TriggerIPDUSend["Com_Misc_TriggerIPDUSend(PduId)<br>@/core/communication/Com/src/Com_misc.c"]
Com_Misc_TriggerIPDUSend --> PduR_ComTransmit["PduR_ComTransmit(IPdu->ArcIPduOutgoingId,<br> &PduInfoPackage)<br>@/core/communication/PduR/src/PduR_Com.c"]
PduR_ComTransmit --> PduR_UpTransmit["PduR_UpTransmit(pduId, pduInfoPtr, 0x89)<br>@/core/communication/PduR/src/PduR_Logic.c"]
PduR_UpTransmit -->PduR_ARC_Transmit["PduR_ARC_Transmit(pduId, pduInfoPtr, serviceId)<br>@PduR_Logic.c"]
PduR_ARC_Transmit --> PduR_ARC_RouteTransmit["PduR_ARC_Transmit(destination, PduInfo)<br>@/core/communication/PduR/src/PduR_Routing.c"]
PduR_ARC_RouteTransmit --> CanIf_Transmit["CanIf_Transmit(destination->DestPduId, pduInfo)<br>@/core/communication/CanIf/src/CanIf.c"]
CanIf_Transmit --> Can_Write["Can_Write(txPduPtr->CanIfTxPduBufferRef-><br>CanIfBufferHthRef->CanIfHthIdSymRef, &canPdu)<br>@/core/mcal/Can/src/Can_stm32.c"]
Can_Write --> CAN_Transmit["CAN_Transmit(canHw,&TxMessage)<br>@stm32f10x_can.c"]
```

### 7.3.5 运行OsBswTask

*未完待续*

```mermaid
graph TB;
OsBswTask["OsBswTask()"] --> ComM_MainFunction_ComMChannel["ComM_MainFunction_ComMChannel()<br> 映射到某种通信方式的状态管理"]
	ComM_MainFunction_ComMChannel --> ComM_MainFunction["ComM_MainFunction(ComMConf_ComMChannel_ComMChannel)"]
OsBswTask --> Com_MainFunctionRx/Tx["Com_MainFunctionRx()<br>Com_MainFunctionTx()"]
OsBswTask --> EcuM_MainFunction["EcuM_MainFunction()<br>timeout倒计时，而后不再进行有意义的工作"]
	EcuM_MainFunction -.-> EcuM_AL_DriverRestart["EcuM_AL_DriverRestart(EcuM_World.config)"]
	EcuM_AL_DriverRestart -.-> EcuM_AL_DriverInitOne["EcuM_AL_DriverInitOne(config)<br>第一步初始化，包括端口配置"]
	EcuM_AL_DriverInitOne -.-> EcuM_AL_DriverInitTwo["EcuM_AL_DriverInitTwo(config)<br>第二步初始化，包括CAN"]
OsBswTask --> Can_MainFunction_Mode["Can_MainFunction_Mode()<br>"]
	
```

### 7.3.6 RTE设置PWM

```mermaid
graph TB;
OsRteTask["OsRteTask()"] --> Rte_SwcReader_SwcReaderRunnable["Rte_SwcReader_SwcReaderRunnable()"]
Rte_SwcReader_SwcReaderRunnable --> swcReaderRunnable["swcReaderRunnable()"]
```

## 7.4 顶层配置和应用

### 7.4.1 Os

配置文件主要包括：`Os_Cfg.c`和`Os_Cfg.h`

* `Os_Cfg.c`

  **（1）外部参考——EXTERNAL REFERENCES**

  

  **（2）DEBUG输出——DEBUG OUTPUT**

  **（3）应用——APPLICATIONS**

  **（4）计数器——COUNTERS**

  **（5）ALARMS??**

  **（6）资源——RESOURSES**

  **（7）任务栈空间——STACKS(TASKS)**

  **（8）任务——TASKS**

  **（9）勾子函数——HOOKS**

  **（10）中断——ISRS**

  **（11）调度表——SCHEDULE TABLES**

  **（12）自旋锁——SPINLOCKS**

* `Os_Cfg.h`









