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
| 微控制器模型缺乏可用性，很难适应现有软件。（由新功能引起的）微控制器性能的扩展需求所导致的升级需要（如重新设计）。 | 微控制器抽象（ECU Abstraction Layer）    | 微控制器能在不需要改变更高软件层的情况下调换。               |
| 重定位 ECU 之间的功能时需要做大量的工作。
功能重用时也需要做大量的工作。 | 运 行 时 环 境(RTE, RunTime Environment) | 功能封装导致的通信技术的独立性。通过标准化机制，使得通信更加简单。使功能分区和功能重定位变得可能。 |
|                                                              |                                          |                                                              |
|                                                              |                                          |                                                              |

## 1.2 AUTOSAR架构

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND1.png" width="700" alt="AUTOSAR总体图">

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND2.png" width="700" alt="AUTOSAR总体图（较清楚细节）">

<img src="/images/wiki/AUTOSAR/AUTOSAR_COND3.png" width="700 " alt="AUTOSAR总体图（最清楚细节）">

# 2、MCAL

MicroController Abstraction Layer，BSW最底层，直接和芯片解除，对应AUTOSAR架构的红色部分。