---
layout: post
title: Python YOLOv2模型的重建为keras模型
categories: Python, AIA
description: Python YOLOv2模型的重建为keras模型
keywords: Python, YOLO
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、介绍
由于计算机性能的限制，我们在采用YOLO算法时，可以采用直接load已经训练好的YOLO模型的方法。

# 2、步骤
## 2.1 下载模型
YOLO官网：[https://pjreddie.com/darknet/yolo/](https://pjreddie.com/darknet/yolo/ "YOLO官网")

选择YOLOv2 608×608

<img src="/images/posts/2018-7-15-YOLO-Model-Load/YOLO_download.png" width="600" alt="选择YOLOv2 608×608" />

点击CFG文件，进入到github界面时，发现该文件还是416×416的图片，下载下来后改成608即可。如果本来就想实现416×416输入的话，可以不改，也不会出错。

<img src="/images/posts/2018-7-15-YOLO-Model-Load/wd_hg_err.png" width="600" alt="cfg文件的错误" />

## 2.2 下载yad2k
[https://github.com/allanzelener/YAD2K](https://github.com/allanzelener/YAD2K "yadk2k")

然后将cfg和weights文件放到以上文件中。

## 2.3 cmd命令框进入到该文件夹

## 2.4 转化为keras模型

$ python [yad2k.py] [cfg文件] [weights文件] [目标文件] 

eg

```
python ./yad2k.py yolov2.cfg yolov2.weights model_data/yolo.h5
```

## 2.5 测试

用./images中的图片测试一下keras模型

```
python ./test_yolo.py model_data/yolo.h5 # output in images/out/
```

## 2.6 keras调用
```
yolo_model = keras.models.load_model("model_data/yolo.h5") 
```

这个模型已经可以直接使用了。

# 3、问题
可能出现tensorflow和keras不兼容的问题。如tensorflow版本为1.2.1，keras为2.1.6，则有的地方不兼容，如tensorflow没有leaky_relu。

解决办法：升级tensorflow。

采用cmd更新tensorflow。

```
conda install --channel https://conda.anaconda.org/anaconda tensorflow
```

# 4、参考

allanzelener/YAD2K[https://github.com/allanzelener/YAD2K](https://github.com/allanzelener/YAD2K "yadk2k")