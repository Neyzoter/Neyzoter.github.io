---
layout: wiki
title: Python/Pandas
categories: Pandas
description: Python/Pandas的重要函数
keywords: Python, Pandas
---


# 1、数值计算
d1.count() #非空元素计算

d1.min() #最小值

d1.max() #最大值

d1.idxmin() #最小值的位置，类似于R中的which.min函数

d1.idxmax() #最大值的位置，类似于R中的which.max函数

d1.quantile(0.1) #10%分位数

d1.sum() #求和

d1.mean() #均值

d1.median() #中位数

d1.mode() #众数

d1.var() #方差

d1.std() #标准差

d1.mad() #平均绝对偏差

d1.skew() #偏度

d1.kurt() #峰度

d1.describe() #一次性输出多个描述性统计指标

# 2、函数
len(df)：输出一共几行

df.fillna(0)：用0填充NaN

# 3、索引
df[['user','merchant']]：索引里面是一个列表，所以是两个[]

# 4、SQL
Orient2User = pd.merge(temp, Orient2User, on='User_id', how='outer')：两个df合起来

Orient2User = off_train.groupby(['User_id'], as_index = False)['sum'].agg({'count':np.sum})：根据User_id计算一共多少人，每个人的频率。需要在原df上加df['sum']=1

# 5、注意点
## 5.1 copy问题
有的时候直接复制

```
df1 = df2
df1['id'] = ...
```

会出现

```
A value is trying to be set on a copy of a slice from a DataFrame.
Try using .loc[row_indexer,col_indexer] = value instead
```

需要改成
```
df1 = df2.copy()
df1['id'] = ...
```

说明：在python里，直接赋值，表示两个变量是相同的引用，只是别名

a=b.copy()，拷贝父对象，不会拷贝对象的内部的子对象。

a=copy.deepcopy(b)， copy 模块的 deepcopy 方法，完全拷贝了父对象及其子对象。也就是说，两者独立。(需要import copy)

1、直接赋值a=b

<img src="/images/wiki/Pandas/equal.png" width="600" alt="直接赋值" />

2、a = b.copy()浅拷贝

<img src="/images/wiki/Pandas/copy.png" width="600" alt="浅拷贝" />

3、a = copy.deepcopy(b)深度拷贝

<img src="/images/wiki/Pandas/deepcopy.png" width="600" alt="深度拷贝" />

