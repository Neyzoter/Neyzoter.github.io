---
layout: post
title: 信息增益的代码实现
categories: AIA
description: 实现信息增益
keywords: 信息增益,决策树
---

> 原创
>
> 转载请注明出处，侵权必究

>确保你能连上google，不然无法显示公式

# 1、概念
## 1.1 熵
表示随机变量不确定性的量度

<img src="http://chart.googleapis.com/chart?cht=tx&chl= H(X)=-\sum_{i=1}^{n}p_{i}log(p_{i})" style="border:none;">

熵越大，随机变量的不确定性就越大。

## 1.2 条件熵
条件熵H(Y|X)表示在已知随机变量X的条件下随机变量Y的不确定性

<img src="http://chart.googleapis.com/chart?cht=tx&chl= H(Y|X) = \sum_{i=1}^{n}p_{i}H(Y|X=x_{i})" style="border:none;">

## 1.3 信息增益
表示得知特征X的信息而使得类Y的信息的不确定性减少的程度

<img src="http://chart.googleapis.com/chart?cht=tx&chl= g(D|A)=H(D)-H(D|A)" style="border:none;">


给定训练数据集D和特征A，经验熵H(D)表示对数据集D进行分类的不确定性。经验条件熵D(D\|A)表示在特征A给定的条件下对数据集D尽心分类的不确定性。两者之差就是信息增益。

具体D(D\|A)计算方法见《统计学习方法》李航P62

## 1.4 信息增益比
信息增益在计算某个特征具有较多取值时，会因为其取值多而变大，偏向于选择取值多的特征。

为了解决该问题，使用信息增益比对其矫正。

信息增益比为

<img src="http://chart.googleapis.com/chart?cht=tx&chl= g_{R}(D,A)=g(D,A)/{H_{A}(D)}" style="border:none;">

其中，

<img src="http://chart.googleapis.com/chart?cht=tx&chl= H_{A}(D)=-\sum_{i=1}^{n}\frac{|D_{i}|}{|D|}log_{2}(\frac{|D_{i}|}{|D|})" style="border:none;">

可见，某个特征取值越多，<img src="http://chart.googleapis.com/chart?cht=tx&chl= H_{A}(D)" style="border:none;"> 越大，起到了矫正的作用。

# 2、代码实现

```python
"""
信息增益算法，信息增益比算法

用于得知特征A的信息而使得类Y的信息的不确定性减少的程度。《统计学习方法》P61

信息增益比矫正了信息增益存在偏向于选择取值较多的特征的问题。

用途：表示决策树的分类好坏

@author: HP528

@date: 2018-9-12
"""

import math


def getInfoGain(A,Y,prt):
    """
    X：某一个特征的不同取值
    Y：类别，1-K个类别
    """
    # 1.计算数据集D的经验熵H(D)
    ## 1.1 获取Y的类别及数目
    dct_y = {}
    for i in Y:
#        print(str(dct_y.keys()))
        if i in dct_y.keys():  # 返回false或者true
            dct_y[i] += 1;
        else:
            dct_y[i] = 1;
    ## 1.2 获取D数目
    D_num = len(Y)
    ## 1.3 计算H(D)
    H_D = 0
    for y,num in dct_y.items():
#        print("y:"+str(y)+"  num:"+str(num))
        H_D += - (num/D_num) * math.log2(num/D_num)
    
    # 2.计算特征X对数据集D的经验条件熵H(D|A)《统计学习方法》P62
    ## 2.1 根据特征A取值将D划分为n个类型（特征A有n个取值）
    dct_A = {}  # P62的Di（根据特征A的取值将D划分为n个子集）.包括数值和数值对应的下标list
    for idx,item in enumerate(A):  # 特征A的不同取值
        if item in dct_A.keys():  # 返回false或者true
            dct_A[item].append(idx)  # 是旧的分类
        else:
            dct_A[item] = [idx]  # 创建一个新的特征数值分类
    ## 2.2 计算得到子集Di中属于类Ck的样本的集合——Dik和H(D|A)
    H_DA = 0
    HA_D = 0  # 训练集D关于特征A的值得熵
    for item in dct_A.keys(): # 获取到A特征的某个值
        H_Di = 0
        
        dct_Dik = {}  # {Y数值:个数}，且在Di中
        for idx in dct_A[item]: # 获取下标
            if Y[idx] in dct_Dik.keys(): # 如果已经有了记录
                dct_Dik[Y[idx]] += 1
            else:
                dct_Dik[Y[idx]] = 1
        
        for Dik_len in dct_Dik.values():
            
            H_Di += (Dik_len/len(dct_A[item])) * math.log2(Dik_len/len(dct_A[item]))
#            print('Dir_len=  '+str(Dik_len)+ '   len(dct_A[item])=  ' + str(len(dct_A[item])) +'  H(Di)=  '+str(H_Di))
        # 计算D(D|A)的和
        H_DA += -len(dct_A[item]) / D_num * H_Di
        HA_D += -len(dct_A[item]) / D_num * math.log2(len(dct_A[item]) / D_num)
    # 3.计算信息增益g(D,A)
    g_DA = H_D - H_DA
    # 4.计算信息增益比gr(D,A)
    gr_DA = g_DA / HA_D
     
    if prt:
        print("数据集D的经验熵              H(D) = "+str(H_D))
        print("特征A对数据集D的经验条件熵  H(D|A) = "+str(H_DA)) 
        print("信息增益                   g(D|A) = "+str(g_DA))
        print("信息增益比                gr(D|A) = "+str(gr_DA))
    
    
    return g_DA,gr_DA

if __name__ == "__main__":
    Y = [6,9,6,6,7,8,8,7,4,9,9,9,9,10]
    
    getInfoGain([1,1,3,4,5,5,4,3,3,3,2,3,4,5],Y,True)


    
```