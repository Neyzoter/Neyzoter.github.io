---
layout: post
title: 电信NB物联网平台配置
categories: NB-IoT
description: 以一个硬件开发者的角度实现简单的电信物联网平台配置及BC95数据发送
keywords: NB-IoT,物联网,电信,华为
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 一、前期准备
### 1、设备
3.8V左右电源（给BC95模组供电）、USB转串口（和BC95模组的串口通信）、BC95模组、电信NB-IoT专用SIM、个人电脑（带上必要的驱动，如CH340的驱动等）。

### 2、申请电信物联网平台
关注微信公众号“天翼物联产业联盟”，点“联盟服务”，选择“实验服务申请”。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/telechinaWechat.png" width="300" alt="天翼电信物联网平台" />

### 3、收到电信的邮件
<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/letterTelechina.png" width = "900"  alt="天翼电信邮件" />

第一个红框是图形界面搭建profile和编解码插件的平台，可在上面进行可视化的平台配置。

第二个框是南向-终端设备接入地址，即在后面对BC95进行AT指令控制时，设置的CDP（“AT+NCDP=x.x.x.x,端口）。

### 4、进入到开发者门户
见3中右键图片的第一个框。

并用电信邮件中的账号名和密码登录。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/platformHome.png" width = "600"  alt="天翼电信物联网平台首页" />

# 二、平台配置
### 1、profile开发
###### 1.1开始自定义产品
点击左栏“profile在线开发”，再点击右上角“自定义产品”，最后点“创建全新产品”

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/profile1.png" width = "600"  alt="天翼电信物联网平台首页" />
###### 1.2创建全新产品
我选择了Other，自己定义一个产品名字。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/profile2_1.png" width = "400"  alt="创建全新产品的定义"  />

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/profile2_2.png" width = "400"  alt="创建全新产品的定义"  />

###### 1.3新建服务
<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/server1.png" width = "900"  alt="新增服务"  />

###### 1.4新增属性
打开“新增服务”后，给服务取名字（这个名字最后会显示在平台的设备数据前面，后面会看到），再点击新增属性。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/serverAndcriterion.png" width = "900"  alt="点击新增属性"  />

接下来就要设置这个属性。

包括属性名、属性类型、长度等。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/criterionSet.png" width = "400"  alt="属性设置" />

> 注：我需要显示压力，所以设置成了字符串的格式。再把它设置成8个字节的数据，用来存储压力的正负（1byte）、数据（6byte）、单位（1byter，N）。枚举类可以不写。访问模式设置成RW，可读可写。后面有个是否必选，我们选择“必选”。  
> 记得点“确定”>>“保存”。如果没有出现服务列表中的属性，那么说明你没有设置好，或者没有点保存。（这个有点坑，点了确定还要点保存。）

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/profile.png" width = "900"  alt="点击新增属性"  />
### 2、插件开发
###### 2.1添加插件和新建插件
左栏“插件开发”，再点右上角“添加插件”，再按下“新建插件”。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/chajianCreate1.png" width = "900"  alt="插件开发开始"  />

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/chajianCreate2.png" width = "900"  alt="插件开发开始"  />

如果调出来下面的，把它×掉。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/chadiao.png" width = "900"  alt="叉掉界面" />

再进行新增消息。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/createMessages.png" width = "900"  alt="新增消息" />

设置消息属性，比如要用设备上传压力数据stress，拉下来有个“完成”按钮。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/editMessages1.png" width = "900"  alt="消息属性设置"  />

点击“字段列表”。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/editMessages2.png" width = "900"  alt="字段列表" />

编辑“字段列表”。

我设置压力字段列表，和之前的服务一样，这两者后面要进行映射设置的。

然后之前8bytes的服务属性都用于这个字段列表，所以我把字段列表也设置成了8bytes长度。可以看到偏移值是0-8byte。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/list.png" width = "400"  alt="字段列表编辑"  />

点击完成后，消息变成了这样，

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/message.png" width = "300"  alt="消息的样子" />

###### 2.3profile和插件映射
在当前界面右侧有一个“更多操作”>>“更换profile”。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/changeProfile.png" width = "900"  alt="更换profile" />

然后我们选择我们刚刚做的profile。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/chooseOurProfile.png" width = "900"  alt="消息的样子" />

“确定”后，右侧会有这个profile的属性。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/RightCriterion.png" width = "300"  alt="出现profile的属性" />

拖过去和消息连接（映射）。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/yingshe.png" width = "600"  alt="实现映射" />

###### 2.4部署
<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/build.png" width = "600"  alt="部署" />

部署成功。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/builtOK.png" width = "400"  alt="部署成功" />

再回到主界面，发现我们的插件已经有了。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/findchajian.png" width = "900"  alt="部署成功" />

### 3、注册设备
<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/registerDevice.png" width = "900"  alt="开始注册设备" />

选择我们刚刚做的profile。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/chooseProfileRegister.png" width = "900"  alt="选择profile注册"  />

并给设备取名字，IMEI号（BC95）填写到设备标识码中。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/setNameandIMEI.png" width = "900"  alt="选择profile注册"  />

我们再来看看设备的情况。

这个设备是我之前注册的，已经ONLINE了。刚注册的设备是OFFLINE的。
<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/Devicestatus.png" width = "900"  alt="选择profile注册" />
# 三、设备模拟器
### 1、配置模拟器
我们可以用设备模拟器来模拟连接。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/simulation.png" width = "400"  alt="设备模拟器软件" />


> 注：软件可以在电信的物联网平台下载。打开这个软件需要安装java1.8，具体见网上教程。

打开模拟器后点“否”。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/simulator.png" width = "400"  alt="设备模拟器软件"  />

而后把自己的CDP地址（电信给你的邮件里有，即南向-设备接入地址，不用加端口）还有IMEI号（和设备注册那里一样）填入。点击注册设备。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/simulatorSET.png" width = "400"  alt="设备模拟器软件"  />

### 2、转化数据
我们需要将字符串数据转化为十六进制的字符串发送。

比如，发送'+002331N'转化为"2b3030323332314e"。其中2b为+，30为0，以此类推。

下图是我用C写的String2HexString的小程序。可以实现字符串数据转化为十六进制的字符串。后期将移植到单片机中。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/string2Hex.png" width = "700"  alt="字符串数据转化为十六进制的字符串" />

### 3、发送数据
接下来我们用模拟器发送转化后的十六进制字符串。

将十六进制字符串复制到hex消息，点击发送即可。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/sendMessage.png" width = "400"  alt="模拟器发送数据" />

### 4、查看数据
我们回到平台查看收到的数据。

通过“我的设备”>>“设备详情”>>“历史数据”查看受到的数据。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/receivedMessages.png" width = "900"  alt="平台数据"  />

# 四、BC95+串口发送数据
懂硬件的人都知道可以用电脑的USB和USB转串口的电路（CH340）和模组连接即可通信。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/USBandBC95.png" width = "600"  alt="USB和BC95连接图"  />


这里我连上了开发板，只用于3.8V电源的提供，不起到通信的作用。BC95模组直接和USB转串口连接。

用QCOM软件发送AT指令。一条一条指令执行即可。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/QCOM.png" width = "900"  alt="QCOM界面" />


> 注：如果发现AT+CFUN?或者AT+CGATT返回其数值为0，重新给这两者赋值。

最后，我们也可以在平台收到相同的数据。
# 五、说明
### 1、关于注册
如果你的设备被demo注册过了。而且数据格式等不符合要求。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/demo.png" width = "400"  alt="demo开启界面" />

那么请将其用同样的方法或者在平台删除该设备，再重新注册。

### 2、profile和插件的关系

具体可以见电信平台的新手指导。

<img src="/images/posts/2018-1-8-Send-Messages-to-TeleChina-with-BC95/profileAndchajian.png" width = "800"  alt="demo开启界面" />

### 3、来源

华为有简单的平台搭建过程/第一个视频

[http://developer.huawei.com/ict/cn/site-oceanconnect_doc?id=12&resourceType=3&curPage=1&pageNum=12](http://developer.huawei.com/ict/cn/site-oceanconnect_doc?id=12&resourceType=3&curPage=1&pageNum=12)

本文档在此基础上加入了硬件的配置。


>宋超超  
>[http://neyzoter.github.io](http://neyzoter.github.io "我的Github主页")


