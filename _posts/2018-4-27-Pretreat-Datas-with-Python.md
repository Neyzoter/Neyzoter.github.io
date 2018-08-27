---
layout: post
title: Python数据处理技巧
categories: Python
description: Python数据处理技巧
keywords: Python, 数据处理
---

> 原创
> 
> 转载请注明出处，侵权必究

# 数据的扁平化
以图像数据为例。

输入(样本数，横像素，列像素，通道),通过处理可以实现将数据转化为（样本数，样本所有特征数）。再经过转置后，转化为（所有样本特征数，样本数）

```python
X_train_flatten = X_train_orig.reshape(X_train_orig.shape[0], -1).T
```

# array的拼接
方法1，转成列表，再append

效率较低。

方法2，
np.append()

