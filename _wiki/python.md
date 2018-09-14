---
layout: wiki
title: Python
categories: Python
description: Python 常用模块及资源记录。
keywords: Python
---

# 语句备忘
## 列表中是否存在某个值

```python
if val in list:
```

### requests

优雅简单的 HTTP 模块。

### BeautifulSoup

很好用的 HTML/XML 解析器。

### json

JSON 编码解码器。

应用举例：

* 格式化 JSON 文件

```sh
python -m json.tool src.json > dst.json
```

  在 Vim 里格式化 JSON：

```sh
:%!python -m json.tool
```

### CGIHTTPServer

简单实用的 HTTP 服务器。

应用举例：

* 运行一个简易的 HTTP 服务器

```sh
  python -m CGIHTTPServer 80
```

### base64

方便地进行 base64 编解码的模块。

应用举例：

* 解码 base64

```sh
  echo aGVsbG93b3JsZA== | python -m base64 -d
```
则能看到输出

```sh
  helloworld
```

## 循环高级用法
```python
[expression for x in X [if condition] for y in Y [if condition]...for n in N[if condition]]
```

按照从左到右的顺序，分别是外层循环到内层循环。

eg1.

```python
L = [x for x in L if x%2 != 0]
```

解析：在for语句后面加上一个if判断语句，用于过滤掉那些不满足条件的结果项。

eg2.

```python
[x+y for x in 'ab' for y in 'jk']

输出：['aj','ak','bj','bk']
```




