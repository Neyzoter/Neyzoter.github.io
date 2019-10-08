---
layout: wiki
title: Advanced Autosar
categories: AUTOSAR
description: 先进AUTOSAR
keywords: 汽车, AUTOSAR, Adaptive Autosar
---

# 1.AUTOSAR整体组成和架构

## 1.1 AUTOSAR整体架构

AUTOAR由基础部分（FUNDATION）、AUTOSAR经典平台、AUTOSAR自适应平台组成。AUTOSAR经典平台上层提供验收测试（Acceptance Tests）和应用接口（Application Interfaces）。

<img src="/images/wiki/AdvancedAs/Structure.png" width="700" alt="AUTOSAR 平台架构">

* **FUNDATION**

  Fundation标准是为了增强AUTOSAR平台之间的交互。Fundation包括AUTOSAR平台之间的通用要求和技术规范。

* **AUTOSAR Adaptive Platform**

  AUTOSAR自适应平台为自适应应用提供了AUTOSAR运行时环境，包括两种接口——服务（services）和API。自适应平台由功能集群组成，功能集群而分为服务和自适应AUTOSAR基础（Adaptive AUTOSAR Basis，通过API调用）两部分。每个机子（虚拟机）至少有一个自适应AUTOSAR基础的功能集群的实例。

  对比于AUTOSAR经典平台，自适应平台的运行时环境（Runtime Environment）动态链接服务和客户端。

  >In comparison to the AUTOSAR Classic Platform the AUTOSAR Runtime Environment for the Adaptive Platform dynamically links services and clients during runtime.

  *自适应AUTOSAR基础和服务的理解*：自适应AUTOSAR基础是实现不同机子间通信、调度的基础功能；服务是特定机子提供的能力。

  <img src="/images/wiki/AdvancedAs/Display_AdaptiveFoundation_Services.png" width="700" alt="AUTOSAR架构显示基础和服务">

  

* **AUTOSAR Classical Platform**

  AUTOSAR经典平台架构的三个部分——应用、运行时环境和基础软件层（BSW）有所区别。

  * 应用软件层和硬件的独立性最强
  * 通信通过RTE来实现连接软件组件和连接到BSW
  * RTE代表应用程序的完整接口
  * BSW分为服务、ECU抽象和微控制器抽象（MCAL）。
  * 服务又可分为代表系统基础功能架构的功能组、存储和通信服务。

## 1.2 AUTOSAR自适应平台

<img src="/images/wiki/AdvancedAs/AP_Structure1.png" width="700" alt="AUTOSAR 自适应平台架构">

## 1.3 AUTOSAR经典平台

以下是经典平台的架构，

<img src="/images/wiki/AdvancedAs/CP_Structure1.png" width="700" alt="AUTOSAR 经典平台架构">

### 1.3.1 概念

* **VFB**

  VFB= virtual functional bus，虚拟功能总线可将应用从基础硬件解耦。应用的通信接口需要映射到特定的VFB通信端口。