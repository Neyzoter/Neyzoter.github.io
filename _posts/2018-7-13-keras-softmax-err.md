---
layout: post
title: keras出现了softmax() got an unexpected keyword argument 'axis'
categories: Python
description: Python的keras出现了softmax() got an unexpected keyword argument 'axis'
keywords: Python, keras, softmax, tensorflow
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、问题描述
调用函数

```python
Dense(classes, activation='softmax', name='fc' + str(classes), kernel_initializer = glorot_uniform(seed=0))(X)
```

出现了问题

softmax() got an unexpected keyword argument 'axis'

# 2、分析

原来tensorflow.nn.softmax(logits, dim=-1, name=None)里面的axis没有了，应该是dim。

# 3、修改

找到F:\Program\Anaconda3\Lib\site-packages\keras\backend\tensorflow_backend.py

将里面的

```python
def softmax(x, axis=-1):
    """Softmax of a tensor.

    # Arguments
        x: A tensor or variable.
        axis: The dimension softmax would be performed on.
            The default is -1 which indicates the last dimension.

    # Returns
        A tensor.
    """
    return tf.nn.softmax(x, dim=axis)

```

中的softmax(x, axis=axis)改为softmax(x, dim=axis)。

# 4、说明

该问题的出现是因为tensoflow后期修改了tensorflow.nn.softmax()的参数dim为axis。

除了修改keras的函数，也可以直接更新tensorflow，使得和keras版本匹配。