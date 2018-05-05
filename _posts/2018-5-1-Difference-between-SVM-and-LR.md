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

\begin{gather*}
\begin{array}{ c c c }
! & \int ^{a}_{b} f'( x) dx=f( b) -f( a) & \underbrace{\frac{1}{4} W_{\mu \nu } \cdot W^{\mu \nu } -\frac{1}{4} B_{\mu \nu } B^{\mu \nu } -\frac{1}{4} G^{a}_{\mu \nu } G^{\mu \nu }_{a}}_{\mathrm{kinetic\ energies\ and\ self-interactions\ of\ the\ gauge\ bosons}}\\
 & \Vert x+y\Vert \geq \bigl|\Vert x\Vert -\Vert y\Vert \bigr| & \nabla \cdot \mathbf{D} =\rho \ \mathrm{and} \ \nabla \cdot \mathbf{B} =0\ \\
 &  & \nabla \times \mathbf{E} =-\frac{\partial \mathbf{B}}{\partial t} \ \mathrm{and} \ \nabla \times \mathbf{H} =\mathbf{J} +\frac{\partial \mathbf{D}}{\partial t}\\
 & y=\frac{\sum\limits _{i} w_{i} y_{i}}{\sum\limits _{i} w_{i}} \ \ ,i=1,2...k & e=\lim\limits _{n\rightarrow \infty }\left( 1+\frac{1}{n}\right)^{n}\\
 &  & 
\end{array}\\
\dot{x}_{i} =a_{i} x_{i'} -( d+a_{i0} +a_{i1}) x_{i} +rx_{i}( f_{i} -\phi )\\
\\
\\
\frac{1}{m}\sum\limits ^{m}_{i}\left( -y_{i} log\left( g\left( \theta ^{T} x\right)\right) -( 1-y_{i}) log\left( 1-g\left( \theta ^{T} x\right)\right)\right)
\end{gather*}


## 1.1 SVM

## 1.2 LR