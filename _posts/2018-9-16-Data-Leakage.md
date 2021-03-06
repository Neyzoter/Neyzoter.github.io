---
layout: post
title: 数据泄露的介绍和避免
categories: AIA
description: 数据泄露的介绍和避免
keywords: 数据泄露,数据处理
---

> 原创
>
> 转载请注明出处，侵权必究

# 1、概念

## 1.1 预测器泄露

比如预测一个人是否患有肺炎，有一个特征是是否吃抗生素。

吃抗生素\-患肺炎，在数据中有很大的关联（没有患肺炎的都没有吃抗生素，而患肺炎的都吃抗生素）。

这是患肺炎后希望恢复而吃抗生素，造成了这种关系。但是吃抗生素是由患肺炎产生的。

这就是一个数据泄露。

<img src="/images/posts/2018-9-16-Data-Leakage/UsableNotUsable.png" width="500" alt="哪些特征可用那些不可用" />

## 1.2 验证策略泄露

比如在划分数据集和验证集前，对数据进行了处理。

因为验证集用于验证之前没有考虑过得数据是否正确，如果在数据划分前进行了处理，则没有了验证效果。

# 2、避免数据泄露
## 2.1 预测器方面
* 寻找和目标有着高度相关性的列

* 如果发现模型有着高度的正确率，有可能出现了泄漏问题。

## 2.2 验证集方面
使用pipeline进行数据的处理