---
layout: post
title: AUTOSAR架构的CAN通信配置之CANTP和J1939TP模块
categories: AUTOSAR
description: AUTOSAR架构的CAN通信CANTP和J1939TP模块配置
keywords: 汽车电子, AUTOSAR, CAN, ISO 15765, SAE J1939
---

# 1.前言

## 1.1 CANTP(ISO 15765)介绍

ISO 15765标准由一般信息、网络层信息、统一诊断服务（UDS）、相关排放系统要求等组成。ISO 15765适用于ISO 11898制定的同一个车辆诊断控制区域网络内（CAN），多用于诊断系统。AUTOSAR框架的CANTP模块是ISO 15765的实现，具备多帧传输的功能。

具体而言，ISO 15765将数据帧（包括ID等）分为了三个域——地址信息`N_AI`、协议控制信息`N_PCI`、数据域`N_Data`。其中，`N_CPI`起到了主要的通信控制作用。

<img src="/images/posts/2020-01-15-AUTOSAR-Can-J1939TPandCANTP-Conf/ISO15765_Frame.png" width="700" alt="15765的域定义" />

## 1.2 J1939TP(SAE J1939)介绍

SAE J1939标准相比于ISO15765更加复杂，具备设备间的连接管理、多帧传输等功能，还将CAN数据帧的ID（标准、拓展帧均可）进行了进一步的定义。所谓的“定义”指的是将CAN数据帧ID的11位（标准帧）或者29位（拓展帧）重新定义为优先级（P）、保留位（R）、数据页（DP）、PDU格式（PF）、特定PDU（PS）、源地址（SA）。如下图所示，

<img src="/images/posts/2020-01-15-AUTOSAR-Can-J1939TPandCANTP-Conf/J1939-Frame-Format.png" width="700" alt="J1939协议的数据帧格式" />

需要说明的是，

1. 数据页位选择参数群（PG, Parameter Group）描述的辅助页，在分配页1的参数群编号（PGN, Parameter Group Number）之前，先分配页0的可用PGN。

> PG参数群概念：PG是可以放在一起发送的一些数据，这些数据可以是在一帧数据中传完，也可以通过J1939的多帧传输协议来通过多次传输实现，取决于数据的长度。比如参数群中共有2个信号——车胎压力（8字节）、轮速（16字节），总共3字节数据，而J1939协议对于小于等于8字节的数据可以直接传输（DIRECT传输方式，具体见下方）。比如参数群中共有6个信号——PWM占空比1（16字节）、PWM占空比2（16字节）、PWM占空比3（16字节）、PWM占空比4（16字节）、PWM占空比5（16字节）、PWM占空比6（16字节），总共12字节数据，此时J1939协议可以通过2个数据帧来发送数据（CMDT传输方式，具体见下方），也可以通过广播（BAM传输方式，具体见下方）的形式发送。另外要说明的是，1个PG对应1个PGN。

2. J1939数据帧ID定义中的特定PDU（PS）的意义是由PDU格式（PF）决定的

   如果PF`>=`240，则PS是群拓展GE（Group Extension, 也就是说PGN可以更多），如果PF<240，则PS是目标地址（Destination Addr），GE等于0。也就是说，对于PF<240的情况，指定了目标地址，但是可以传输的PG（也可以说是PGN）变少了。

3. PGN组成和个数

   PGN由保留位（R）、数据页（DP）、PDU格式（PF）和群拓展（GE）组成。如果PF`>=`240，则PS是群拓展GE（Group Extension, 也就是说PGN可以更多），如果PF<240，则PS是目标地址（Destination Addr），GE等于0。

   PGN个数计算：`(240 + (16 * 256) * 2) = 8672`。其中，240是每个数据页（DP, Data Page）中的PF<240时，GE恒等于0，所以数目是240。16是每个数据页（DP, Data Page）中的PF>240时，数值从240到255之间，共16个数。256是指GE（等于PS）的取值个数，具体是从0到255之间。2表示数据页，分为页0和页1。

## 1.3 TP在AUTOSAR框架中的角色

AUTOSAR的传输协议（TP, Transport Protocal）模块是对某个传输协议国际标准的实现，如上述的ISO15765（对应CANTP模块）和SAE J1939（对应J1939TP模块）。我们都知道CAN2.0的一个CAN数据帧最多传输8字节数据，而在汽车电子领域有数据（或者参数群，也就是一组数据）可能需要超过8字节来传输。而TP模块正是可以实现多个CAN数据帧的组包，形成超过8字节的参数群。发送的时候，也会将超过8字节数据拆包发送。下面是CAN TP模块在AUTOSAR框架中的位置。

<img src="/images/posts/2020-01-15-AUTOSAR-Can-J1939TPandCANTP-Conf/TP_Position.png" width="700" alt="TP在AUOTSAR框架中的位置" />

CANTP模块联通PDUR和CANIF模块，实现PDUR到CANIF时的拆包和CANIF到PDUR时的组包功能。最终，CANTP会将数据经过PDUR后依次存放到COM的Buffer中。

# 2.CAN TP(ISO 15765)的通信过程

## 2.1 ISO 15765的通信过程

ISO 15765对数据帧进行了划分，其中协议控制信息`N_PCI`有着通信控制的作用。以下是`N_PCI`的具体定义，

<img src="/images/posts/2020-01-15-AUTOSAR-Can-J1939TPandCANTP-Conf/N_PCI_Details.png" width="700" alt="N_PCI具体定义" />

ISO 15765不像J1939，没有“连接管理”的概念（J1939的连接管理见下方）。其通过重定义CAN数据帧的数据域来实现多帧传输。

**单帧**（SF），第0个字节被用于控制（`[7:4] N_PCItype = 0`，`[3:0] 数据长度SF_DL`），数据只需要1帧来传输

**首帧**（FF），第0和1个字节被用于控制（`Byte0的[7:4] N_PCItype = 1`，其余12位用于数据长度`FF_DL`），数据需要多个帧来传输，FF是多个帧的第1帧

**连续帧**（CF），第0字节被用于控制（`[7:4] N_PCItype = 2`，`[3:0] SN`连续帧编号，0到15，如果到达15,下一个重置为0），首帧FF后面的帧是连续帧

**流控**（FC），第0字节到2字节被用于控制（具体见标准），目的是调整CF `N_PDUs`发送的速率。

## 2.2 CAN TP模块的通信实现

**1. 单帧**

下图是一个CAN IF模块将数据发送到CAN TP模块，CAN TP模块组织管理CAN数据帧（单帧SF）的过程。

<img src="/images/wiki/AUTOSAR/CanIf2CanTp2PduR_Example.png" width="800" alt="单帧过程">

`PduR_<LoTp>StartOfReception @ PduR_CanTp.c`用于向上层COM模块请求Buffer。

`PduR_<LoTp>CopyRxData @ PduR_Logic.c`用于拷贝数据到COM模块的Buffer，并将剩余可用Buffer空间写入到参数（调用者提供）。

**2. 多帧**

下图是一个CAN IF模块将数据发送到CAN TP模块，CAN TP模块组织管理CAN数据帧（多帧，包括首帧FF和连续帧CF）的过程。

<img src="/images/wiki/AUTOSAR/CanIf2CanTp2PduR_FF_CF.png" width="800" alt="多帧过程">

拷贝过程类似单帧，区别是多帧管理的时候，会有`currentPosition`来指明目前Buffer已经用掉了多少，下次连续帧过来时，拷贝到可利用的Buffer空间（从`currentPosition`开始）。

# 3.J1939TP(J1939)的通信过程

