---
layout: post
title: QT程序打包成exe文件
categories: Softwares
description: QT程序打包成exe文件
keywords: QT, C++
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、准备
写好的QT程序、安装好的QT软件（主要使用windeployqt）、Engima Virtual Box软件。

[http://enigmaprotector.com/en/downloads.html](http://enigmaprotector.com/en/downloads.html "Engima Virtual Box")

# 2、步骤

## 2.1 release一个QT程序

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/release.png" width="400" alt="release" />

会生成一个编译后的文件夹。

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/releaseFile.png" width="600" alt="release编译文件" />

## 2.2 拷贝exe文件
找到release编译文件夹中的exe文件，我的地址是C:\\Users\\Thinkpad\\Desktop\\Socket\-Test\-QT\\build-Socket-Test-Desktop\_Qt\_5\_3\_MSVC2013\_OpenGL_32bit\-Release\\release。

运行该exe文件，发现出错，因为没有QT相关的库文件。

建立一个单独的文件夹，将该exe文件复制到该文件夹下。

## 2.3 命令行运行windeployqt

找到QT的运行文件

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/findQT.png" width="400" alt="找到QT的文件夹" />

通过cd进入2.2节建立的新的文件夹。

命令行输入：windeployqt 程序名，得到运行结果。

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/windeployqtResult.png" width="400" alt="windeployqtResult结果" />

再次双击这个exe文件，则可以运行了。

## 2.4 打包

下面要将这些零碎的文件打包在一个 exe中。

(1)打开Engima Virtual Box软件，填写要打包的文件信息。

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/pack1.png" width="600" alt="软件使用1" />

(2)点右下角的Files Options，选择将文件压缩。

<img src="/images/posts/2018-7-12-QT-Package-Into-exe/compress.png" width="400" alt="软件使用2——压缩" />

(3)Process

打包完成后，生成一个单独的exe文件，可以不需要外部的库文件。






