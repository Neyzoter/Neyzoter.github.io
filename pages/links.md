---
layout: page
title: Links
description: 我的友情链接
keywords: 友情链接
comments: true
menu: 链接
permalink: /links/
---

> Thannks for my friends and teachers.

{% for link in site.data.links %}
* [{{ link.name }}]({{ link.url }})
{% endfor %}
