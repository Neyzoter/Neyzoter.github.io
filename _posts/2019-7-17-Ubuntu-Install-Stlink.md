---
layout: post
title: Ubuntu安装stlink
categories: Softwares
description: Ubuntu安装stlink
keywords: stlink, Ubuntu
---

> Ubuntu16安装和使用stlink

# 1、准备

安装依赖

```
1.libusb-1.0
1.1：sudo apt-get install libusb-dev
1.2：sudo apt-get install libusb-1.0-0-dev
2.cmake
2.1：sudo add-apt-repository ppa:george-edison55/cmake-3.x
2.2：sudo apt-get update
2.3：sudo apt-get install cmake
```

# 2、安装

1.git下载

```bash
$ git clone https://github.com/texane/stlink.git
```

2.make

```bash
$ cd stlink

$ make
```

3.install

```bash
$ cd build/Release && make install DESTDIR=_install
```

4.复制st-flash到/usr/bin

5.下载程序

```bash
$ sudo st-flash write test.bin 0x8000000
```

# 3、安装内容

* a communication library (libstlink.a),
* a GDB server (st-util),
* a flash manipulation tool (st-flash).
* a programmer and chip information tool (st-info)
