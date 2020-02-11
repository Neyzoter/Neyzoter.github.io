---
layout: wiki
title: JMeter
categories: JMeter
description: JMeter学习笔记
keywords: Java, JMeter, 压力测试
---

# 1.JMeter

Apache JMeter是Apache组织开发的基于Java的压力测试工具。用于对软件做压力测试，它最初被设计用于Web应用测试，但后来扩展到其他测试领域。

# 2.JMeter使用

**不要使用GUI运行压力测试，GUI仅用于压力测试的创建和调试；执行压力测试请不要使用GUI。**

```bash
$ jmeter -n -t [jmx file] -l [results file] -e -o [Path to web report folder]
```

我安装的是JMeter 5.2.1，下面进行压力测试举例。

**1. 创建线程组**

打开GUI后，可以看到一个Test Plan项目，在其下面创建新的线程组（`右键 -> add -> Threads(User) -> Thread Group`）。

**2. 设置线程数和循环次数**

点击线程组，设置线程数和循环次数，比如设置线程数（Number Of Threads(User)）500个，循环次数（Loop Count）1次。

**3. 创建HTTP请求**

右键线程组，创建HTTP请求（`右键 -> add -> Sampler -> HTTP Request`）。

**4. 创建HTTP头管理**

右键HTTP Request，创建HTTP头管理（`右键 -> add -> Config Element -> HTTP Header Manager`），当然还有其他的管理器可以使用。然后对Header进行配置。

**5. 添加查看结果树和聚合报告**

右键线程组，添加结果树（`右键 -> add -> Listener -> View Results Tree`）。

右键线程组，添加聚合报告（`右键 -> add -> Listener -> Summary Report`）。

**6. 运行**

点击运行按钮（绿色箭头）。