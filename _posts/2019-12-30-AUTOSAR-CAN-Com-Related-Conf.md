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

我们以一个CAN控制PWM的系统（CanCtrlPwm子工程）为例来解释CAN通信和上层应用如何合作运行，如下图所示。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/Global_System.png" width="700" alt="CAN控制PWM的系统框图" />

1. CAN Controller挂在CAN 总线上，如果有PWM设置数据发送到总线，ECU就会进入CAN接收中断；
2. 接受中断经过`CAN Driver -> CANIF -> PDUR -> COM`这个流程后，穿过BSW层，将数据存放到COM模块的缓存，即图中的`IPdu_Rx`（图中配置了64字节长度，其实对于单个CAN数据帧而言，图中三个缓存区都只需要8字节即可）；
3. BSW任务会周期性将`IPdu_Rx`的数据拷贝到`Deferred_IPdu`中；
4. 上层SWC应用pwmValueDeal可以通过RTE将`Deferred_IPdu`中的PWM设置数据拷贝到和pwmValueDeal绑定的结构体成员变量`manager.msg.value`中，对应图中的第① 步；
5. 上层SWC应用pwmValueDeal再通过RTE读取`manager.msg.value`中的PWM设置数据，进行处理后，进而存放到`manager.duty.value`，对应图中的第② ③ ④ 步；
6. 为了让执行器pwmSetActuator能够拿到处理后的数据`manager.duty.value`，上层SWC应用pwmValueDeal再通过RTE将`manager.duty.value`存放到RteBuff中，对应图中的第⑤步，**不同SWC间的通信都通过Buff来实现**；另外，pwmValueDeal还将`manager.duty.value`存放到CAN的发送缓存区`IPdu_Tx`，BSW任务会将其发送出去，对应图中的第⑤步；
7. 上层SWC应用pwmSetActuator可以通过RTE从RteBuff中读取pwmValueDeal存放的数据，进而存放到和pwmSetActuator自身绑定的结构体成员变量`actuator.duty.value`中，对应第⑥ 步；
8. 上层SWC应用pwmSetActuator可以通过RTE从`actuator.duty.value`中读取PWM设置数据，并通过回调函数来设置PWM占空比（回调函数的形式在AUTOSAR中成为CS模式，即客户端服务器模式，前面获取数据的过程成为RS模式，即接收者发送者模式），对应第⑦ ⑧ ⑨步。

*说明1：目前SWC都放在RTE任务中周期性运行，BSW任务也作为一个任务周期性运行。后期考虑将SWC分任务运行。*

*说明2：这个简单的系统只使用了1路CAN，而且IPDU和信号也非常简单。下一章节设计的multican则包含了多个CAN、多个IPDU、IPDU可能还包含了多个信号Signal。*

*说明3：目前设计的CAN通信信息流都是`CAN Driver -> CANIF -> PDUR -> COM`（接收）、`COM -> PDUR -> CANIF -> CAN Driver`（发送）的流程。*

# 3.CAN通信信息流

上一章节说明了一个简单的系统是如何工作的，但是CAN数据具体如何在BSW中流通未进行详细说明。这一部分对于整个代码来说也是较大的一块工作量。在修改代码（[master主分支](https://nescar.coding.net/p/SORL-Example/d/SORL-Example/git)，[multican分支](https://nescar.coding.net/p/SORL-Example/d/SORL-Example/git/tree/multican)）的过程中，和CAN通信相关的修改内容均进行了备注，并且带有标签`[MULTICAN]`，可以使用VSCode全局搜索查看。需要说明的是本部分对`multican`子工程进行配置说明，而不是简单系统CanCtrlPwm。下面就进行CAN通信信息流的详细说明。

## 3.1 CAN控制器配置和信号定义

目前共配置2个CAN控制器（英飞凌芯片共 3个CAN控制器），每个CAN控制器包含3个HRH（接收的Handler）和3个HTH（发送的Handler），对应配置了不同的ID类型（标准帧或者拓展帧）、ID掩码（进而HRH可以对应接受某一些数据帧）等。具体配置信息如下所示，共12个HOH（6个HRH和6个HTH），其中HRH0配置为可以接收ID为`0x1XX`（XX表示掩码设置为0，不关心）的CAN数据帧，HRH1接受ID为`0x2XX`的CAN数据帧，HRH2接受ID为`0x3XX`的CAN数据帧，HRH3接受ID为`0x4XX`的CAN数据帧，HRH4接受ID为`0x5XX`的CAN数据帧，HRH5接受ID为`0x6XX`的CAN数据帧（掩码在下图中未体现）。该配置文件通过EB软件生成。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/HRHandHTH.jpeg" width="800" alt="CAN接收和发送Handler" />

CAN数据分为接收和发送两部分。

接收过程中，在CAN IF模块过滤时，共设置7个接收的PDU ID规则（ID分别是`0x100`、`0x200`、`0x201`、`0x300`、`0x400`、`0x500`、`0x600`），除了HRH1对应2个之外，其他HRH都只接收一个PDU。CAN IF过滤后，体现在通信服务层中的PDUR和COM模块的IPDU，也是共7个。为了体现出信号的概念，在IPDU1中定义了3个信号，也就是说这一CAN数据帧中包含了3个信号——空气悬挂压力、左侧气囊压力、制动开关。具体见下图。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/Receive_IPDUs.png" width="700" alt="CAN接收信号定义" />

发送过程中，在COM模块中共设置了6个IPDU，和HTH一一对应，ID分别为`0x10`、`0x11`、`0x12`、`0x13`、`0x14`、`0x15`。为了体现出信号的概念，在IPDU7中定义了3个阀的6个PWM信号（每个阀有2个PWM控制），其余的IPDU都只包含1个信号。具体见下图。

<img src="/images/posts/2019-12-30-AUTOSAR-CAN-Com-Related-Conf/Transmit_IPDUs.png" width="700" alt="CAN发送信号定义" />



## 3.2 CAN数据接收

### 3.2.1 CAN Driver到CAN IF



### 3.2.2 CAN IF到PDUR



### 3.2.3 PDUR到COM



### 3.2.4 BSW任务和COM



### 3.2.5 SWC任务和COM



## 3.3 CAN数据发送