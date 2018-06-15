---
layout: post
title: VS2013项目配置x64及opencv3.4的配置
categories: Softwares
description: VS2013项目配置x64及opencv的配置
keywords: VS2013, x64,win，opencv
---

> 原创
> 
> 转载请注明出处，侵权必究。


# 简介
最近在做opencv3.4+vs2013，其中遇到一个问题。编译无法通过。

原因是编译debug采用了win32，应该改成x64。

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/chaMana.png" width="500" alt="属性管理器" />

如果没有配置，则初始化为win32，没有Debug\|x64和Release\|x64。

# x64的配置
“生成”-》“配置管理器”

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/setMana.png" width="500" alt="设置管理器" />

“活动解决方案平台”下拉，选择“新建”（如果没有x64的话），将ARM改为x64，下面的“win32”不改.

如果有x64，直接选择x64。

这个时候，就可以出现简介中的属性管理器中的x64了。

# opencv的配置
既然配置了x64了，那么下面把opencv整个流程也配置一下吧。

一 所需工具

OpenCV 3.4.0

Visual Studio 2013

CMake

资源地址：链接: https://pan.baidu.com/s/1kXlAKQz 密码: jtfa

二 CMake配置OpenCV源码

1、安装opencv3.4.0（实际是解压过程）

2、新建Build文件夹，用于保存CMake生产的配置文件

比如opencv_vs2013_x64

3、CMake直接解压，无需安装。解压后打开bin目录下的cmake-gui

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/CMake.png" width="500" alt="CMake界面" />
 
l  Where is the source code 填写opencv解压缩后sources文件夹路径

l  Where to build the binaries 填写新建的build文件路劲

4、点击左下角Configure选择编译器（Visual Studio 12 2013 Win64）上图红色部分是提示相应的函数库PS：因为配置复杂，网上建议第一次配置取消勾选WITH_CUDA，自己视情况而定

5、再次点击Configure开始配置，下方提示Configure done

6、点击Generate生成解决方案，下方提示Generate done

7、点击Open Project，启动VS2013开发生产的解决方案

三、配置VS2013

找到VS2013中的OPENCV文件。

1 右键ALL_BUILD文件，选择生成（时间视情况而定）

2 右键INSTALL文件，选择生成（时间视情况而定）

四 配置环境变量

在path中添加编译后的    build文件夹\install\x64\vc12\bin

我这里是：F:\Program\OPENCV\opencv_vs2013_x64\install\x64\vc12\bin

五、VS2013工程配置

1、建立一个空的控制台项目，然后再配置成x64。见上面的**配置**。

2、Debug\|x64-》Microsoft.Cpp.x64.user

3、VC++目录-》包含目录

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/include.png" width="500" alt="包含目录设置" />

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/includePage.png" width="500" alt="包含目录设置" />

这里的opencv_vs2013_x64文件夹是opencv3.4解压文件经过cmake build后的编译文件。

5、VC++目录-》库目录

<img src="/images/posts/2018-6-16-VS2013-Create-x64-Projects/lib.png" width="500" alt="库目录" />

6、链接器-》输入-》附加依赖项

加入

```
opencv_calib3d340d.lib
opencv_core340d.lib
opencv_dnn340d.lib
opencv_features2d340d.lib
opencv_flann340d.lib
opencv_highgui340d.lib
opencv_imgcodecs340d.lib
opencv_imgproc340d.lib
opencv_ml340d.lib
opencv_objdetect340d.lib
opencv_photo340d.lib
opencv_shape340d.lib
opencv_stitching340d.lib
opencv_superres340d.lib
opencv_video340d.lib
opencv_videoio340d.lib
opencv_videostab340d.lib
```

这里的d表示debug，所以不选release。再把...\opencv_vs2013_x64\install\x64\vc12\bin目录下的dll文件复制到C:\Windows\System32下

六、测试

```C++
#include<iostream>
#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
using namespace cv;
using namespace std;
int main()
{
        Mat image = imread("picture.jpg");
        imshow("picture", image);
        waitKey(0);
        return 0;
}

```

这里的picture.jpg是图片，需要自行放置图片到CPP工程中。

# 参考文献

https://blog.csdn.net/ture_dream/article/details/52600897

https://blog.csdn.net/nickcry/article/details/79148772