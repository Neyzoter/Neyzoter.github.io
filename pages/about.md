---
layout: page
title: About
description: 宋超超的github
keywords: 关于
comments: true
menu: 关于
permalink: /about/
---

我是宋超超。

座右铭：坚持就是胜利。

## contact(联系)

{% for website in site.data.social %}
* {{ website.sitename }}：[@{{ website.name }}]({{ website.url }})
{% endfor %}

## Skill Keywords(技能)

{% for category in site.data.skills %}
### {{ category.name }}
<div class="btn-inline">
{% for keyword in category.keywords %}
<button class="btn btn-outline" type="button">{{ keyword }}</button>
{% endfor %}
</div>
{% endfor %}
