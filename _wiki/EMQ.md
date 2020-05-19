---
layout: wiki
title: EMQ
categories: MQTT
description: EMQ搭建MQTT服务器
keywords: IOT, MQTT, EMQ
---

# 1.EMQ介绍

[EMQ官网文档](https://docs.emqx.io/broker/latest/cn/)

*EMQ X* (Erlang/Enterprise/Elastic MQTT Broker) 是基于 Erlang/OTP 平台开发的开源物联网 MQTT 消息服务器。

Erlang/OTP是出色的软实时 (Soft-Realtime)、低延时 (Low-Latency)、分布式 (Distributed)的语言平台。

MQTT 是轻量的 (Lightweight)、发布订阅模式 (PubSub) 的物联网消息协议。

EMQ X 设计目标是实现高可靠，并支持承载海量物联网终端的MQTT连接，支持在海量物联网设备间低延时消息路由:

1. 稳定承载大规模的 MQTT 客户端连接，单服务器节点支持50万到100万连接。
2. 分布式节点集群，快速低延时的消息路由，单集群支持1000万规模的路由。
3. 消息服务器内扩展，支持定制多种认证方式、高效存储消息到后端数据库。
4. 完整物联网协议支持，MQTT、MQTT-SN、CoAP、LwM2M、WebSocket 或私有协议支持。

![EMQ X 开源版、企业版和专业版的对比](https://docs.emqx.io/broker/latest/cn/introduction/assets/3011583829062_.pic_hd-3829209.jpg)

# 2.EMQ技术



# 3.EMQ使用

## 3.1 安装

[安装流程](https://docs.emqx.io/broker/latest/cn/getting-started/install.html##shell)

## 3.2 启动

```bash
# 启动
## 直接启动
$ emqx start
EMQ X v4.0.0 is started successfully!
## systemctl 启动
$ sudo systemctl start emqx
EMQ X v4.0.0 is started successfully!
## service 启动
$ sudo service emqx start
EMQ X v4.0.0 is started successfully!
# 查看启动状态
$ emqx_ctl status
```

## 3.3 操作

```bash
# 后台启动 EMQ X Broker；
$ emqx start
# 关闭 EMQ X Broker；
$ emqx stop
# 重启 EMQ X Broker；
$ emqx restart
# 使用控制台启动 EMQ X Broker；
% emqx console
# 使用控制台启动 EMQ X Broker，与 emqx console 不同，emqx foreground 不支持输入 Erlang 命令；
emqx foreground
# Ping EMQ X Broker。
emqx ping
```

[其他指令](https://docs.emqx.io/broker/latest/cn/advanced/cli.html)

## 3.4 目录结构

| 描述                        | 使用 ZIP 压缩包安装 | 使用二进制包安装         |
| :-------------------------- | :------------------ | :----------------------- |
| 可执行文件目录              | `./bin`             | `/usr/lib/emqx/bin`      |
| 数据文件                    | `./data`            | `/var/lib/emqx/data`     |
| Erlang 虚拟机文件           | `./erts-*`          | `/usr/lib/emqx/erts-*`   |
| 配置文件目录                | `./etc`             | `/etc/emqx/etc`          |
| 依赖项目录                  | `./lib`             | `/usr/lib/emqx/lib`      |
| 日志文件                    | `./log`             | `/var/log/emqx`          |
| 启动相关的脚本、schema 文件 | `./releases`        | `/usr/lib/emqx/releases` |

### 3.4.1 bin 目录

**emqx、emqx.cmd**

EMQ X 的可执行文件，具体使用可以查看 [基本命令](https://docs.emqx.io/broker/latest/cn/getting-started/command-line.html)。

**emqx_ctl、emqx_ctl.cmd**

EMQ X 管理命令的可执行文件，具体使用可以查看 [管理命令 CLI](https://docs.emqx.io/broker/latest/cn/advanced/cli.html)。

### 3.4.2 etc 目录

EMQ X 通过 `etc` 目录下配置文件进行设置，主要配置文件包括:

| 配置文件         | 说明                              |
| :--------------- | :-------------------------------- |
| `emqx.conf`      | EMQ X 配置文件                    |
| `acl.conf`       | EMQ X 默认 ACL 规则配置文件       |
| `plugins/*.conf` | EMQ X 各类插件配置文件            |
| `certs`          | EMQ X SSL 证书文件                |
| `emqx.lic`       | License 文件仅限 EMQ X Enterprise |

EMQ X 具体的配置内容可以查看 [配置项](https://docs.emqx.io/broker/latest/cn/configuration/configuration.html)。

### 3.4.3 data 目录

EMQ X 将运行数据存储在 `data` 目录下，主要的文件包括:

**`configs/app.\*.config`**

EMQ X 读取 `etc/emqx.conf` 和 `etc/plugins/*.conf` 中的配置后，转换为 Erlang 原生配置文件格式，并在运行时读取其中的配置。

**`loaded_plugins`**

`loaded_plugins` 文件记录了 EMQ X 默认启动的插件列表，可以修改此文件以增删默认启动的插件。`loaded_plugins` 中启动项格式为 `{, }.`，`` 字段为布尔类型，EMQ X 会在启动时根据 `` 的值判断是否需要启动该插件。关于插件的更多内容，请查看 [插件](https://docs.emqx.io/broker/latest/cn/advanced/plugins.html)。

```bash
$ cat loaded_plugins
{emqx_management,true}.
{emqx_recon,true}.
{emqx_retainer,true}.
{emqx_dashboard,true}.
{emqx_rule_engine,true}.
{emqx_bridge_mqtt,false}.
```

**`mnesia`**

Mnesia 数据库是 Erlang 内置的一个分布式 DBMS，可以直接存储 Erlang 的各种数据结构。

EMQ X 使用 Mnesia 数据库存储自身运行数据，例如告警记录、规则引擎已创建的资源和规则、Dashbaord 用户信息等数据，这些数据都将被存储在 `mnesia` 目录下，因此一旦删除该目录，将导致 EMQ X 丢失所有业务数据。

可以通过 `emqx_ctl mnesia` 命令查询 EMQ X 中 Mnesia 数据库的系统信息，具体请查看 [管理命令 CLI](https://docs.emqx.io/broker/latest/cn/advanced/cli.html)。

### 3.4.4 log 目录

**`emqx.log.\*`**

EMQ X 运行时产生的日志文件，具体请查看 [日志与追踪](https://docs.emqx.io/broker/latest/cn/getting-started/log.html)。

**`crash.dump`**

EMQ X 的崩溃转储文件，可以通过 `etc/emqx.conf` 修改配置，具体内容可以查看 [配置项](https://docs.emqx.io/broker/latest/cn/configuration/configuration.html)。

**`erlang.log.\*`**

以 `emqx start` 方式后台启动 EMQ X 时，控制台日志的副本文件。

# 4.其他

## 4.1 paho-mqtt安装

### 4.1.1 Python

paho-mqtt-python存放在[github](https://github.com/eclipse/paho.mqtt.python)。

测试代码：

```python
import paho.mqtt.client as mqtt
import json
import random

# 更换为自己的IP或者域名
Ip = "XXX.XXX.XXX.XXX"

def success_connect(*args):
    print('连接成功')

def on_message(client, other, message: mqtt.MQTTMessage):
    print(message.topic)
    print(message.payload)
    print(json.loads(message.payload))
    data = json.loads(message.payload)
    request_id = data.get('request_id', 'none')
    data = {
            'request_id': request_id,
            'errcode': 2002,
            'errmsg': 'params incorrect',
            'data': {
            'ok': 'success'
            }
        }
    client.publish('/pub/product/1998/1222222222/set', json.dumps(data, ensure_ascii=False))
    print('发送成功')

def on_subscribe(*args):
    print('订阅成功')

client = mqtt.Client(client_id='test_' + str(random.randint(1, 1000000000000)))
client.on_connect = success_connect
client.on_message = on_message
client.on_subscribe = on_subscribe
# client.username_pw_set('admin', 'admin')
client.connect(Ip, 1883, 60)
client.subscribe('/sub/product/1998/1222222222/set')
# while 1:
# time.sleep(1)
# client.publish('/sub/product/1/1222222222/set', "sdsdsd")
client.loop_forever()

```

