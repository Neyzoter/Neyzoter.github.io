---
layout: wiki
title: 窄带物联网专业词汇
categories: IoT
description: NB-IoT的专业术语
keywords: NB-IoT,专业术语
---

### IMEI
International Mobile Equipment Identity(IMEI)

国际移动设备身份码的缩写

### IMSI
International Mobile Subscriber Identification Number

国际移动用户识别码，区别移动用户的标志，存储在sim卡中，可用于区别移动用户的有效信息。

### DTLS
Datagram Transport Layer Security(DTLS)

数据包传输层安全性协议

握手来回数据三次（客户hello、IoT平台hello验证请求；客户hello、服务器hello完成；客户密钥交换完毕、服务器完毕）
### LWM2M
Lowweight M2M(LWM2M)

轻量级M2M
### M2M
Machine-to-Machine/Man(M2M)

一种以机器终端智能交互为核心的、网络化的应用与服务
### GSM
Global System for Mobile Communication

全球移动通信系统，当前最广泛的移动电话标准，3G

### LTE
Long Term Evolution

长期演进，是4G移动通信网络的无线网标准。当前运营商宣称的4G即为LTE，其实是3.9G。

### SAE
System Architecture Evolution

3GPP标准化组织定义的4G核心网领域的演进架构。

### EPC
Evolved Packet Core

演进的分组核心网，是SAE在4G移动通信网络的核心网具体形式。

#### SGW
服务网关

#### PGW
PDN网关

#### SCEF
业务能力开放单元

### EPS
Evolved Packet System

一套完整的演进分组系统。

EPS = LTE + EPC + UE（用户终端）

### MME
Mobility Management Entity

3GPP协议LTE接入网络的关键控制节点

负责空闲模式的UE(User Equipment)的定位，传呼过程，包括中继，简单的说MME是负责信令处理部分。
### CDMA
Code Division Multiple Access

码分多址，电信3G的网络模式。

### WCDMA
Wideband Code Division Multiple Access

宽带码分多址，联通3G的网络模式。

### TD-SCDMA
Time Division-Synchronous Code Division Multiple Access

时分同步码分多址，移动3G的网络模式。

### UMTS
Universal Mobile Telecommunications System

通用移动通信系统，3G网络协议体系。

### NB-IoT的两种上行物理信道
（1）NPUSCH

窄带物理上行共享通道

（2）NPRACH

窄带物理随机接入通道

### MCL
Maximum Coupling Loss

最大耦合损耗，从基站天线端口到终端天线端口的路径损耗。

上行MCL=上行最大发射功率-基站接收灵敏度

下行MCL=下行最大发射功率-终端接收灵敏度

NB-IoT的上行和下行MCL均为164dB
