---
layout: post
title: 网络虚拟化技术初探
categories: IoT
description: 网络虚拟化技术初探
keywords: 计算机网络, 网络虚拟化, Virtualized Networking
---

> 网络虚拟化的介绍，以及和传统网络架构的对比

# 1.网络虚拟化简介

网络资源管理的目标是实现网络资源虚拟化管理，更多关注于某一台物理主机上的网络结构。

# 2.传统网络架构 

传统的网络架构中一台物理主机包括一个 或者多个网卡（NIC），通过自身的NIC和外部网路设施交互，比如交换机上。为了将应用隔离，往往通过将应用部署在不同的物理主机上。

<img src="/images/posts/2019-10-08-Virtualized-Networking/Traditional_Network.png" width="500" alt="传统网络" />

**问题**：1）是某些应用大部分情况可能处于空闲状态；2）是当应用增多的时候，只能通过增加物理设备来解决扩展性问题

# 3.虚拟化网络框架

为了解决传统网络架构的问题，借助虚拟化技术将物理网卡虚拟成多张虚拟网卡（vNIC），通过虚拟机来隔离不同的应用。**解决**：1）可以利用虚拟化层 Hypervisor 的调度技术，将资源从空闲的应用上调度到繁忙的应用上，达到资源的合理利用；针对问题 2）可以根据物理设备的资源使用情况进行横向扩容，除非设备资源已经用尽，否则没有必要新增设备。

<img src="/images/posts/2019-10-08-Virtualized-Networking/Virtualized_Networking_Instructure.png" width="500" alt="虚拟化网络架构" />

一整套虚拟网络的模块都可以独立出去，由第三方来完成，如其中比较出名的一个解决方案就是 Open vSwitch（OVS）。

OVS 的优势在于它基于 SDN 的设计原则，方便虚拟机集群的控制与管理，另外就是它分布式的特性，可以「透明」地实现跨主机之间的虚拟机通信，如下是跨主机启用 OVS 通信的图示。

<img src="/images/posts/2019-10-08-Virtualized-Networking/Distributed_Virtual_Switch.png" width="500" alt="分布式虚拟交换机" />



# 参考

[1.网络虚拟化](https://www.cnblogs.com/bakari/p/8037105.html)



