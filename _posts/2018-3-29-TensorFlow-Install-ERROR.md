---
layout: post
title: TensorFlow的安装出现CondaHTTPError
categories: Softwares
description: TensorFlow的安装出现CondaHTTPError
keywords: TensorFlow, Error, Anaconda
---

# 1、问题
anaconda安装tensorflow时可能会出现问题。
```
$ conda install tensorflow
```

出现了：

CondaHTTPError: HTTP None None for url blabla...

# 2、需要删除.condarc里的default

1）查看情况

```
$ conda config --show
```

2）查看.condarc的地址

```
$ conda --help
```

<img src="/images/posts/2018-3-29-TensorFlow-Install-ERROR/condarc_address.png" width="600" alt="condarc文件的地址" />

3）找到该文件，并删掉default那一行

# 3、再次安装TensorFlow
```
$ conda install tensorflow
```



