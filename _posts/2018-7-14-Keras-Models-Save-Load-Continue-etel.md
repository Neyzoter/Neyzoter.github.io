---
layout: post
title: Keras的神经网络模型保存、加载与继续训练
categories: Python
description: Keras的神经网络模型保存、加载与继续训练
keywords: Python, keras
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、Keras神经网络模型方法的介绍
1、model.save(filepath, overwrite=True, include\_optimizer=True)

保存模型到h5文件，包括模型的结构、权重、训练配置（损失函数、优化器等）、优化器的状态（以便从上次训练中断的地方开始）。

overwrite：如果存在源文件，是否覆盖。

2、keras.models.load_model(filepath, custom_objects=None, compile=True)

通过h5文件，重新实例化模型。如果文件中存储了训练配置的话，该函数还会同时完成模型的编译。

```python
from keras.models import load_model

model.save('my_model.h5')  # 保存模型
del model  # 删掉存在的模型

#返回一个编译好的模型
#与删掉的模型相同
model = load_model('my_model.h5')
```

载入后，可以继续训练。

```python
model.fit(X_train,Y_train)
```

也可以直接评估：

```python
model.evaluate(X_test, Y_test)
print ( "Loss = " + str( preds[0] ) )
print ( "Test Accuracy = " + str( preds[1] ) )
```

3、model.to_json()或者model.to_yaml()

只保存模型的结构（到json或者yaml格式），不包含权重或配置信息。返回一个json_string或者yaml_string。

```python
json_string = model.to_json()
yaml_string = model.to_yaml()
```

通过keras.models.model_from_json(json_string)或者keras.models.model_from_yaml(yaml_string)来载入模型（不包含权重和配置信息）。

4、model.save_weights(filepath, overwrite=True)

将模型的权重保存为h5文件。

通过kmodel.load_weights(filepath,by_name=False,skip_mismatch=False, reshape=False)**初始化**一个权重一样的模型。

**注**：by_name:是否采用名字来加载模型权重，如果要迁移学习，将其设为True

加载权重到不同的网络结构（有些层一样），比如迁移学习，可以通过层的名字来加载模型：

```python
# by_name:是否采用名字来加载模型权重
model.load_weights('my_model_weights.h5', by_name=True)
```

```python
"""
假如原模型为：
    model = Sequential()
    model.add(Dense(2, input_dim=3, name="dense_1"))
    model.add(Dense(3, name="dense_2"))
    ...
    model.save_weights(fname)
"""
# 新的模型
model = Sequential()
model.add(Dense(2, input_dim=3, name="dense_1"))  # 这里的name和原模型的name相同，将会加载权重
model.add(Dense(10, name="new_dense"))  # 将不会加载权重

# 从原始模型中加载权重; 只影响了第一层“dense_1”.
model.load_weights(fname, by_name=True)
```

# 2、参考文献

如何保存Keras模型？：[http://keras-cn.readthedocs.io/en/latest/for_beginners/FAQ/#keras_1](http://keras-cn.readthedocs.io/en/latest/for_beginners/FAQ/#keras_1 "如何保存Keras模型？")


