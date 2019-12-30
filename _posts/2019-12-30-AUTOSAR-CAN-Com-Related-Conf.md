---
layout: post
title: AUTOSAR架构的CAN通信配置
categories: AUTOSAR
description: AUTOSAR架构的CAN通信配置
keywords: 汽车电子, AUTOSAR, CAN
---

# 1.AUTOSAR的CAN通信介绍

AUTOSAR的通信是其最复杂的部分之一，其中CAN在汽车上有大量的应用，故对CAN通信进行介绍、配置和实验。

下图是AUTOSAR的通信框图。整个图贯穿了基础软件层（Basic SoftWare layer, BSW）的MCAL、硬件抽象层和系统服务层。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/CAN_COM_Diff_Layers.png" width="600" alt="总体结构" />

* **MCAL**

  最底层（红色）是MCAL，具体而言是不同通信协议的驱动，比如FlexRay Driver、CAN Driver、LIN Low Level Driver等。对于CAN Driver而言，数据接收中断服务函数在此处定义，最终也通过此处驱动实现数据的发送。

* **硬件抽象层**

  再上一层（绿色）是硬件抽象层，具体而言是不同通信协议的接口，比如FlexRay Interface、CAN Interface、LIN Interface等。MCAL层和硬件抽象层之间的PDU称为L-PDU，其（以CAN为例）全称为CAN(Data Link Layer) Service Data Unit，包括CAN数据帧ID、DLC（数据长度）、数据（L-SDU）。

* **通信服务器层**

  再上一层（蓝色）是通信服务器层，此处包含了诸多服务模块，比如CAN TP、PDURouter、COM、NM等。

  * 数据形式

    硬件抽象层和通信服务层的TP（Transport Protocal）间数据形式称为N-PDU，（以CAN为例）全称Network Protocal Data Unit of the CAN Transport Layer，包括唯一ID、数据长度、数据，**可以处理多帧CAN数据**。另外，还有一个**J1939TP**（此处未画出），可能对于汽车电子行业来说也非常重要。

    硬件抽象层和除了TP外的通信服务之间的数据形式称为I-PDU，全称Interaction Layer Protocal Data Unit。一个I-PDU中可以包含多个信号Signal，比如一个CAN数据帧长度为8个字节，第`[0:15]`位是空气悬架压力信号，第`[16:31]`位是左侧气囊压力信号，第`[32]`位是制动开关信号，具体见下图。需要说明的是，自此以后，上层已经无法知道底层的通信协议。

    <img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/Singal_Example.png" width="700" alt="IPDU可以包含多个信号" />

  * 模块

    PDUR（PDU Router）主要用于分发数据，比如可以决定CANIF（CAN Interface）模块传上来数据下一步传到某个模块（具体配置和解释见下面章节）。

    COM模块主要进行数据的缓存、管理（比如某一个Signal在一个IPDU中的定位），面下可以接收和发送数据，面上可以给SWC提供信号获取接口（具体配置和解释见下面章节）。

    CANSM全称CAN State Manager，主要用于管理CAN通信的不同网络（总线）。*我的理解是，对于**不同总线**上的CAN控制器，可以分配到不同的CAN网络，进而进行管理。*

    NM全称Network Manager，主要用于管理不同的通信协议，比如CAN、LIN、FlexRay等。

# 2.简单系统——CAN控制PWM

我们以一个CAN控制PWM的系统为例来解释CAN通信和上层应用如何合作运行，如下图所示。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/Global_System.png" width="700" alt="CAN控制PWM的系统框图" />

1. CAN Controller挂在CAN 总线上，如果有PWM设置数据发送到总线，ECU就会进入CAN接收中断；
2. 接受中断经过`CAN Driver -> CANIF -> PDUR -> COM`这个流程后，穿过BSW层，将数据存放到COM模块的缓存，即图中的`IPdu_Rx`（图中配置了64字节长度，其实对于单个CAN数据帧而言，图中三个缓存区都只需要8字节即可）；
3. BSW任务会周期性将`IPdu_Rx`的数据拷贝到`Deferred_IPdu`中；
4. 上层SWC应用pwmValueDeal可以通过RTE将`Deferred_IPdu`中的PWM设置数据拷贝到和pwmValueDeal绑定的结构体成员变量`manager.msg.value`中，对应图中的第① 步；
5. 上层SWC应用pwmValueDeal再通过RTE读取`manager.msg.value`中的PWM设置数据，进行处理后，进而存放到`manager.duty.value`，对应图中的第② ③ ④ 步；
6. 为了让执行器pwmSetActuator能够拿到处理后的数据`manager.duty.value`，上层SWC应用pwmValueDeal再通过RTE将`manager.duty.value`存放到RteBuff中，对应图中的第⑤步，**不同SWC间的通信都通过Buff来实现**；另外，pwmValueDeal还将`manager.duty.value`存放到CAN的发送缓存区`IPdu_Tx`，BSW任务会将其发送出去，对应图中的第⑤步；
7. 上层SWC应用pwmSetActuator可以通过RTE从RteBuff中读取pwmValueDeal存放的数据，进而存放到和pwmSetActuator自身绑定的结构体成员变量`actuator.duty.value`中，对应第⑥ 步；
8. 上层SWC应用pwmSetActuator可以通过RTE从`actuator.duty.value`中读取PWM设置数据，并通过回调函数来设置PWM占空比（回调函数的形式在AUTOSAR中成为CS模式，即客户端服务器模式，前面获取数据的过程成为RS模式，即接收者发送者模式）。

*说明：目前SWC都放在RTE任务中周期性运行，BSW任务也作为一个任务周期性运行。后期考虑将SWC分任务运行。*

目前设计的CAN通信信息流都是`CAN Driver -> CANIF -> PDUR -> COM`（接收）、`COM -> PDUR -> CANIF -> CAN Driver`（发送）的流程。

# 3.CAN通信信息流

上一章节说明了一个简单的系统是如何工作的，但是CAN数据具体如何在BSW中流通未进行详细说明。这一部分对于整个代码来说也是较大的一块工作量。下面就进行CAN通信信息流的详细说明。

## 3.1 CAN数据接收

### 3.1.1 CAN Driver到CAN IF



### 3.1.2 CAN IF到PDUR



### 3.1.3 PDUR到COM



### 3.1.4 BSW任务和COM



### 3.1.5 SWC任务和COM



## 3.2 CAN数据发送