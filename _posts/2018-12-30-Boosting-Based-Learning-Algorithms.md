---
layout: post
title: 基于提升方法的学习算法
categories: AIA
description: 基于提升（boosting）方法的学习算法
keywords: AI,提升方法,AdaBoost,GB,GBDT,XGBOOST
---

# 提升方法介绍
提升方法的原理还要追溯到Kearns和Valiant提出的“强可学习”和“弱可学习”概念。在概率近似正确（Probably Approximately Correct，PAC）学习的框架中，一个概念存在一个多项式的学习算法能学习它，并且正确率很高，则称为“强可学习”；如果正确率仅比随机猜测略好，则成为“弱可学习”。Schapire证明了“强可学习”与“弱可学习”是等价的。所以可以通过设计“弱可学习”算法，进而提升为“强可学习”算法。大多数提升方法为改变训练数据的概率分布（权值分布），针对不同的训练数据分布训练弱学习器。

# 
# 参考文献
[1]Kaggle.Housing Prices Competition for Kaggle Learn Users[DB/OL]. https://www.kaggle.com/c/home-data-for-ml-course

[2] Chen T, Guestrin C. XGBoost:A Scalable Tree Boosting System[J]. 2016.

[3]李航.统计学习方法[M].北京:清华大学出版社.2012:137-154

[4] Valiant L G. A theory of the learnable[J]. Communications of Acm, 1984, 27(11):1134-1142.

[5] Schapire R E. The strength of weak learnability[C]// Proc IEEE Symposium on Foundations of Computer Science. 1989.
