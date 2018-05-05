---
layout: post
title: 支持向量机(SVM)和逻辑回归(LR)的区别
categories: AIA
description: 支持向量机和逻辑回归的区别
keywords: 支持向量机, 逻辑回归
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、简介
两者的损失函数分别为：

<img src="/images/posts/2018-5-1-Difference-between-SVM-and-LR/SVM_LR_Loss.png" width="600" alt="SVM和LR的损失函数" />

公式中，SVM带松弛变量，LR带正则化部分。LR的函数g，表示sigmoid函数。

\begin{equation*}
\frac{1}{m}\sum\limits ^{m}_{i}\left( -y_{i} log\left( g\left( \theta ^{T} x\right)\right) -( 1-y_{i}) log\left( 1-g\left( \theta ^{T} x\right)\right)\right)
\end{equation*}

## 1.1 SVM

## 1.2 LR