---
layout: post
title: 模型融合的方法
categories: AIA
description: 模型融合的方法
keywords: AI,Bagging,Boosting
---

# 1、基础方式
## 1.1 投票
对于分类问题，可以选择票数多的那个分类项作为最终的结果。
## 2.2 平均
对多个回归模型的结果进行加权平均。

# 2、具体方式
## 2.1 Bagging
Bagging就是采用有放回的方式进行抽样，用抽样的样本建立子模型,对子模型进行训练，这个过程重复多次，最后进行融合。

**流程**

（1）重复K次

有放回地重复抽样建模

训练子模型

（2）模型融合

分类问题：投票

回归问题：平均

**实例**

随机森林就是基于Bagging算法的一个典型例子，采用的基分类器是决策树。

## 2.2 Boosting

Bagging算法可以并行处理，而Boosting的思想是一种迭代的方法，**每一次训练的时候都更加关心分类错误的样例**，给这些分类错误的样例增加更大的权重，下一次迭代的目标就是能够更容易辨别出上一轮分类错误的样例。最终将这些弱分类器进行加权相加。

<img src="/images/posts/2019-2-19-Model-Fusion/boosting.webp" width="700" alt="boosting过程" />

**实例**

AdaBoost、GBDT

## 2.3 Stacking

