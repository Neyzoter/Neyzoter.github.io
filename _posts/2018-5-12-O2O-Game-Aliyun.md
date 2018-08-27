---
layout: post
title: 生活大实惠：O2O优惠券使用预测
categories: AIA
description: 生活大实惠：O2O优惠券使用预测
keywords: Python, Alibaba, Prediction
---

> 原创
> 
> 转载请注明出处，侵权必究

# 1、赛题和数据
## 1.1 赛题
随着移动设备的完善和普及，移动互联网+各行各业进入了高速发展阶段，这其中以O2O（Online to Offline）消费最为吸引眼球。据不完全统计，O2O行业估值上亿的创业公司至少有10家，也不乏百亿巨头的身影。O2O行业天然关联数亿消费者，各类APP每天记录了超过百亿条用户行为和位置记录，因而成为大数据科研和商业化运营的最佳结合点之一。 以优惠券盘活老用户或吸引新客户进店消费是O2O的一种重要营销方式。然而随机投放的优惠券对多数用户造成无意义的干扰。对商家而言，滥发的优惠券可能降低品牌声誉，同时难以估算营销成本。 个性化投放是提高优惠券核销率的重要技术，它可以让具有一定偏好的消费者得到真正的实惠，同时赋予商家更强的营销能力。**本次大赛为参赛选手提供了O2O场景相关的丰富数据，希望参赛选手通过分析建模，精准预测用户是否会在规定时间内使用相应优惠券。**

## 1.2 数据
1、用户线下消费和优惠券领取行为

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1754884 entries, 0 to 1754883
Data columns (total 7 columns):
User_id          int64    用户的ID
Merchant_id      int64    商家的ID
Coupon_id        object   优惠券的ID，null表示没有优惠券
Discount_rate    object   折扣如满140减20：140:20
Distance         object   顾客经常活动地点和商家的距离  x\in[0,10]；null表示无此信息，0表示低于500米，10表示大于5公里
Date_received    object   优惠券获得的时间，null表示没有优惠券
Date             object   消费的时间，null表示没有使用优惠券
dtypes: int64(2), object(5)
memory usage: 93.7+ MB
```

2、用户线上点击/消费和优惠券领取行为

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 11429826 entries, 0 to 11429825
Data columns (total 7 columns):
User_id          int64
Merchant_id      int64
Action           int64  0：点击；1：购买；2：领取优惠券
Coupon_id        object  优惠券ID。null：无优惠券消费，此时Discount_rate和Date_received无意义
Discount_rate    object  折扣
Date_received    object  优惠券获取时间
Date             object  
dtypes: int64(3), object(4)
memory usage: 610.4+ MB
```

3、用户O2O线下优惠券使用**预测样本**

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 113640 entries, 0 to 113639
Data columns (total 6 columns):
User_id          113640 non-null int64  
Merchant_id      113640 non-null int64
Coupon_id        113640 non-null int64
Discount_rate    113640 non-null object
Distance         113640 non-null object
Date_received    113640 non-null int64   注意这里是int64
dtypes: int64(4), object(2)
memory usage: 5.2+ MB
```

# 2、分析
## 2.1 预测样本
预测样本的信息包括用户ID(只有1个没有在训练集中出现，包括online和offline)、商铺ID、优惠券的ID、优惠券的折扣率（包括打折、满减和null）、用户活动地点离最近商铺的距离、领取优惠券的时间（20160701最早取优惠券日期、20160731最晚取优惠券日期）。

需要根据这些信息，来预测用户在15天内使用优惠券的概率。

除了这些信息，还可以从训练集中提取特征。比如用户1，他在训练集中一共购买了20次，是最高的，则任务该特征是1；如果一共10次，最高20次，他是0.5。

## 2.2 训练样本
**Table1. 用户线下消费和优惠券领取行为**

分为两种情况来得到特征：

1、用户ID对应的特征（线下训练集和线上训练集）

如用户自身前几个月一共使用了多少次优惠券。训练集里的特征可以被测试集（真实预测的时候）使用。

2、普遍的特征（线下训练集）

如距离和商铺的关系。这个是测试集里可以提取的，当然是不能用训练集的。


### 2.2.1用户ID对应的特征
1、购买次数

记录该用户一共购买了多少次。

备注：需要后期归一化。比如10次，最高的人是20次，则认为他是0.5。

2、**15天内**领取并使用优惠券次数/领取优惠券次数

该比例越高，说明改用户使用优惠券的概率越高。

备注：归一化或者可以不归一化，我们还是归一化一下吧。

3、最后一次用优惠券时间-最早一次用优惠券时间(计算能力有限，时间很长，目前暂时不用)

备注：需要后期归一化。如别人最高的是30天，他的是15天，则归一化为0.5。

### 2.2.2普遍的特征
1、商铺距离和是15天内购买的关系

所有的购买情况 = 有商铺距离+无商铺距离

测试集中存在距离确实的情况，所以不得不考虑这种情况。

>* 数据缺失的解决方法
>
>1）、用平均值、中值、分位数、众数、随机值等替代。效果一般，因为等于人为增加了噪声。
>
>2）、用其他变量做预测，算出数据可能的值
>
>3）、映射到高维空间。如男女和缺失，可以映射到是否男、是否女、是否确实

本次采用第一和三方法结合，距离如果是null，则输入一个中位数median()并且定义一个是否是null的特征。

所以这里有两个特征Distance和Null

2、满多少和是15天内购买的关系

3、减多少和是15天内购买的关系

4、折扣率和是15天内购买的关系

将满多少减多少也转化为折扣率，折扣率 = 1 - 减/满

### 2.2.3标签
是否15天内使用优惠券。











