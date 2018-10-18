---
layout: post
title: https加密
categories: Security
description: https加密的知识
keywords: https,对称加密,非对称加密
---

# 1、http
明文传输数据

# 2、https
加密数据再传输
## 2.1 对称加密方式
1、服务器生成密钥，通过**明文**发送给客户端。

2、服务器通过密钥加密数据，传输给客户端。

3、客户端通过服务器给的密钥解密数据。

问题：密钥通过明文发送，会被窃取

## 2.2 非对称加密方式
1、分为公钥和私钥。

**用公钥加密的数据，只有对应的私钥才能解密；用私钥加密的数据，只有对应的公钥才能解密。**

2、服务器可以通过客户端给的公钥加密。

3、客户端可以用自己的私钥解密。

**注**：ssh使用RSA算法生成密钥和公钥的时候，包括id\_rsa和id\_rsa.pub,即密钥和公钥

问题：加密需要大量的时间

不安全性：容易被中间人截获（中继攻击）

<img src="/images/posts/2018-10-18-Https-Encryption/relay.webp" width="700" alt="中继攻击" />

## 2.3 对称和非对称加密结合
对称加密用来传输数据，非对称加密用来传输对称加密的密钥。
**作用**：加快数据加密速度。

1、服务器明文方式发送公钥

2、客户端使用明文发送自己的对称加密密钥

3、服务器和客户端使用对称加密传输数据

## 2.4 数字签名
为了保证公钥是服务器的，通过一个认证中心（CA）来认证。CA提供给服务器**私钥**。

1、服务器对服务器信息和服务器要发送的公钥进行hash算法生成信息摘要，并用CA给的**私钥**加密

<img src="/images/posts/2018-10-18-Https-Encryption/hash.webp" width="700" alt="hash算法生成信息摘要" />

<img src="/images/posts/2018-10-18-Https-Encryption/info_encryption.webp" width="700" alt="私钥加密" />

2、加密后，所得到的叫数字签名

3、合并服务器信息、公钥和数字签名

<img src="/images/posts/2018-10-18-Https-Encryption/cat.webp" width="700" alt="合并" />

4、服务器将合并后的信息发送给客户端

5、客户端使用CA所给的**公钥**解密所得到的信息摘要，用hash算法计算服务器信息和公钥得到一个自己计算出来的信息摘要

6、对比这两个信息摘要是否相同

<img src="/images/posts/2018-10-18-Https-Encryption/cmp.webp" width="700" alt="对比连个信息摘要" />

思考：数字签名的私钥会不会被调包？




















