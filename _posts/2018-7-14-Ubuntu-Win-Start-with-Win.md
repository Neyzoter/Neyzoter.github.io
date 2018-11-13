---
layout: post
title: Ubuntu和Win双系统设置Win为默认开启项
categories: Softwares
description: Ubuntu和Win双系统设置Win为默认开启项
keywords: Ubuntu, Windows, 双系统
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、问题描述

已安装win系统，再安装ubuntu。会发现系统默认从Ubuntu启动。怎么默认从win启动呢？

# 2、方案

1、查看启动项（开机的时候就能看到）

<img src="/images/posts/2018-7-14-Ubunt-Win-Start-with-Win/start.jpg" width="700" alt="启动项" />

可以看到我的Ubuntu是第0项，Ubuntu高级选项是第1项，win启动是第2项，System setup是第3项。

2、进入Ubuntu系统，打开命令行（终端），输入 "cd /etc/default/"，回车

3、输入“sudo sudo nano grub”，回车

4、输入管理员密码

5、打开grub文件后，看到“GRUB\_DEFAULT=0”，修改为win的启动项

从**1、查看启动项**可以知道，我的win启动项是2。所以我这里改成“GRUB_DEFAULT=2”

6、Ctrl+X（离开），并输入“Y”确认

7、再次回车确认

8、输入“sudo update\-grub”更新

9、下次启动的时候，就是默认win启动了



