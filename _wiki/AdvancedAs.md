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

  AUTOSAR自适应平台为自适应应用提供了AUTOSAR运行时环境，包括两种接口——服务（services）和API。自适应平台由功能集群组成，功能集群而分为服务和自适应AUTOSAR基础（Adaptive AUTOSAR Basis）两部分。每个机子（虚拟机）至少有一个自适应AUTOSAR基础的功能集群的实例。

  对比于AUTOSAR经典平台，自适应平台的运行时环境（Runtime Environment）动态链接服务和客户端。

  >In comparison to the AUTOSAR Classic Platform the AUTOSAR Runtime Environment for the Adaptive Platform dynamically links services and clients during runtime.

  *自适应AUTOSAR基础和服务的理解*：自适应AUTOSAR基础是实现不同机子间通信、调度的基础功能；服务是特定机子提供的能力。

* **AUTOSAR Classical Platform**

  

## 1.2 AUTOSAR自适应平台

<img src="/images/wiki/AdvancedAs/AP_Structure1.png" width="700" alt="AUTOSAR 自适应平台架构">