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

# 3.测试结果

测试结果举例，

* **结果树**

    ```
    Thread Name（线程组名称）: 线程组 1-24
    Sample Start（ 启动开始时间）: 2019-02-15 15:00:14 CST
    Load time（加载时长）: 290
    Connect Time（连接时长）: 86
    Latency（等待时长）: 174
    Size in bytes（发送的数据总大小）: 2212
    Sent bytes:821
    Headers size in bytes（发送数据的其余部分大小）: 1162
    Body size in bytes: 1050
    Sample Count（发送统计）: 1
    Error Count（错误统计）: 0
    Data type ("text"|"bin"|""): text
    Response code（返回状态码）: 200
    Response message（返回信息）: OK
    ```

* **聚合报告**

    ```
    Sample:本次测试场景共运行多少线程
    Average:平均响应时间
    Median:统计意义上的响应时间中值
    90% line:所有线程中90%的线程响应时间都小于xx的值
    Min:响应最小时间
    Max:响应最大时间
    Error:出错率
    ```

  