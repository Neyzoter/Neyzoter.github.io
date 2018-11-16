---
layout: post
title: BC95实现简单的CDP服务器下行数据接收
categories: IoT
description: BC95实现简单的CDP服务器下行数据接收
keywords: NB-IoT,物联网,电信,华为
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 一、前期准备
### 1、设备
供电电源、BC95模组、USB转串口、PC（安装JAVA，并有北向demo.jar）。

# 二、平台配置
### 1、具体的profile和插件配置
见

[https://neyzoter.github.io/2018/01/08/Send-Messages-to-TeleChina-with-BC95/](https://neyzoter.github.io/2018/01/08/Send-Messages-to-TeleChina-with-BC95/ "从硬件开发者的角度实现简单的电信NB物联网平台配置")

>注：上述文章的profile和插件配置只能实现上行数据传输，即设备数据上传到CDP服务器。

### 2、服务命令的添加
和《从硬件开发者的角度实现简单的电信NB物联网平台配置》不同的是，本章节在此基础上添加CDP命令的下行传输。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/serviceCMD.png" width="900" alt="服务命令添加图" />

可以看到在命令处，我添加了一个stressValue字段。只需要是你想要发送的信息格式即可。

### 3、插件设计
《从硬件开发者的角度实现简单的电信NB物联网平台配置》中已经跟说明了怎么实现插件设计（实现服务和设备信息的映射），我们这里只需要将服务命令也映射起来即可。服务命令同服务属性的信息传递方向不同，所以界面上的箭头方向也不同。这个很容易理解。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/stressandsend.png" width="900" alt="插件设计" />

### 4、注册设备
同《从硬件开发者的角度实现简单的电信NB物联网平台配置》。

# 三、北向demo数据发送

### 1、登录北向demo
华为提供了北向demo，可以去华为网站下载。

下面是北向demo的登录界面。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/demoFace.png" width="400" alt="北向demo登录界面" />

前两个空填平台给你发过来的邮件中的“中国电信物联网开放平台北向API-企业应用接入地址”。
<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/telechinaMail.png" width="900" alt="北向API-企业应用接入地址" />

后两个空是你在物联网平台创建你的应用的时候平台提供的。
<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/APIinformation.png" width="400" alt="接口信息" />

### 2、查看消息
我们可以通过这个demo查看设备发送到CDP服务器的数据或者信息。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/dispMsg.png" width="900" alt="查询设备发送过来的消息" />

具体的包括：

①选择module中的数据管理
②填写你的设备ID
③点击查询历史数据
④查看debug框内的数据

见下图。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/queryData.png" width="900" alt="查询设备发送过来的消息" />

和浏览器形式平台上的信息一致。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/dataonCDP.png" width="900" alt="平台上的数据用浏览器显示" />

### 3、发送命令
###### 3.1选择命令管理

在Module中选择命令管理(Data Manager)

###### 3.2填写设备ID

在Post Async Command中填写设备ID。然后点击Get Command。

###### 3.3发送数据

选择你的服务命令，然后在Value和Expire Time内填写数据和过期时间。该数据和你在平台设置的数据格式一致，过期时间以秒为单位。

具体见图。

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/CDPsend.png" width="500" alt="CDP服务器发送数据" />

# 四、设备接收数据

在CDP服务器发送数据后，我们需要在过期时间内接收数据。

而接收数据需要先通过“AT+NMGS=位数,十六进制数据”，任意发送一条信息给CDP。

>因为有IP端口老化问题，华为等非电信平台目前无法保证下发数据能正确送达，只能先缓存，等收到上报后按照这个最新的地址再下发。对于psm设备这种机制没有问题。对于DRX或eDRX模式需要的实时下发机制，目前据说只能在电信平台上实现。电信平台和电信核心网之间做了IP隧道可以避免IP老化问题。(感谢网友-王治-http://developer.huawei.com/ict/forum/space-uid-4032453.html)

而后通过“AT+NQMGR”可以查询到数据缓存多少，接受了多少，发送了多少。

可以通过“AT+NMGR”接收数据。

该数据以“\r\n数据位数,数据\r\n\r\nOK\r\n”的格式返回。

我们可以看到数据已经被接收。

平台上：

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/telechinaCMD.png" width="900" alt="平台上的数据情况" />

北向demo上：

<img src="/images/posts/2018-1-19-Device-Gets-Msg-from-CDP/queryAsyncCMD.png" width="900" alt="demo上的数据情况" />


# 五、总结
CDP服务器发送数据，设备接收数据分为以下几步：

①平台服务命令的配置。

②插件设计

③插件部署

④设备注册

⑤通过demo将数据post

⑥设备通过“AT+NMGS=位数,十六进制数据”发送数据到CDP服务器

⑦设备通过“AT+NMGR”接收数据

>宋超超  
>[http://neyzoter.github.io](http://neyzoter.github.io "我的Github主页")


