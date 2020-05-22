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

## 2.1 MQTT协议

MQTT是一个轻量的发布订阅模式消息传输协议，专门针对低带宽和不稳定网络环境的物联网应用设计。

MQTT官网: [http://mqtt.org](http://mqtt.org/)

MQTT V3.1.1协议规范: http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html

### 2.1.1 特点

1. 开放消息协议，简单易实现
2. 发布订阅模式，一对多消息发布
3. 基于TCP/IP网络连接
4. 1字节固定报头，2字节心跳报文，报文结构紧凑
5. 消息QoS支持，可靠传输保证

### 2.1.2 应用场景

MQTT协议广泛应用于物联网、移动互联网、智能硬件、车联网、电力能源等领域。

1. 物联网M2M通信，物联网大数据采集
2. Android消息推送，WEB消息推送
3. 移动即时消息，例如Facebook Messenger
4. 智能硬件、智能家具、智能电器
5. 车联网通信，电动车站桩采集
6. 智慧城市、远程医疗、远程教育
7. 电力、石油与能源等行业市场

### 2.1.3 基于主题的消息路由

MQTT协议基于主题(Topic)进行消息路由，主题(Topic)类似URL路径，例如:

```
chat/room/1

sensor/10/temperature

sensor/+/temperature

$SYS/broker/metrics/packets/received

$SYS/broker/metrics/#
```

主题(Topic)通过’/’分割层级，支持’+’, ‘#’通配符:

```
'+': 表示通配一个层级，例如a/+，匹配a/x, a/y

'#': 表示通配多个层级，例如a/#，匹配a/x, a/b/c/d
```

订阅者与发布者之间通过主题路由消息进行通信，例如采用mosquitto命令行发布订阅消息:

```
mosquitto_sub -t a/b/+ -q 1

mosquitto_pub -t a/b/c -m hello -q 1
```

注解

订阅者可以订阅含通配符主题，但发布者不允许向含通配符主题发布消息。

### 2.1.4 MQTT V3.1.1协议报文

**报文结构**

| 固定报头(Fixed header)    |
| ------------------------- |
| 可变报头(Variable header) |
| 报文有效载荷(Payload)     |

**固定报头**

| Bit    | 7                | 6     | 5    | 4    | 3    | 2    | 1    | 0    |
| ------ | ---------------- | ----- | ---- | ---- | ---- | ---- | ---- | ---- |
| byte1  | MQTT Packet type | Flags |      |      |      |      |      |      |
| byte2… | Remaining Length |       |      |      |      |      |      |      |

**报文类型**

| 类型名称    | 类型值 | 报文说明     |
| ----------- | ------ | ------------ |
| CONNECT     | 1      | 发起连接     |
| CONNACK     | 2      | 连接回执     |
| PUBLISH     | 3      | 发布消息     |
| PUBACK      | 4      | 发布回执     |
| PUBREC      | 5      | QoS2消息回执 |
| PUBREL      | 6      | QoS2消息释放 |
| PUBCOMP     | 7      | QoS2消息完成 |
| SUBSCRIBE   | 8      | 订阅主题     |
| SUBACK      | 9      | 订阅回执     |
| UNSUBSCRIBE | 10     | 取消订阅     |
| UNSUBACK    | 11     | 取消订阅回执 |
| PINGREQ     | 12     | PING请求     |
| PINGRESP    | 13     | PING响应     |
| DISCONNECT  | 14     | 断开连接     |

**PUBLISH发布消息**

PUBLISH报文承载客户端与服务器间双向的发布消息。 PUBACK报文用于接收端确认QoS1报文，PUBREC/PUBREL/PUBCOMP报文用于QoS2消息流程。

**PINGREQ/PINGRESP心跳**

客户端在无报文发送时，按保活周期(KeepAlive)定时向服务端发送PINGREQ心跳报文，服务端响应PINGRESP报文。PINGREQ/PINGRESP报文均2个字节。

**MQTT消息QoS**

MQTT发布消息QoS保证不是端到端的，是客户端与服务器之间的。订阅者收到MQTT消息的QoS级别，最终取决于发布消息的QoS和主题订阅的QoS。

| 发布消息的QoS | 主题订阅的QoS | 接收消息的QoS |
| ------------- | ------------- | ------------- |
| 0             | 0             | 0             |
| 0             | 1             | 0             |
| 0             | 2             | 0             |
| 1             | 0             | 0             |
| 1             | 1             | 1             |
| 1             | 2             | 1             |
| 2             | 0             | 0             |
| 2             | 1             | 1             |
| 2             | 2             | 2             |

**Qos0消息发布订阅**

<img src="./images/wiki/EMQ/qos0_seq.png" width="500" alt="Qos0消息发布订阅">

**Qos1消息发布订阅**

<img src="./images/wiki/EMQ/qos1_seq.png" width="500" alt="Qos1消息发布订阅">

**Qos2消息发布订阅**

<img src="./images/wiki/EMQ/qos2_seq.png" width="500" alt="Qos2消息发布订阅">

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

## 3.5 配置说明

### 3.5.1 配置文件

| 配置文件             | 说明                        |
| :------------------- | :-------------------------- |
| `etc/emqx.conf`      | EMQ X 配置文件              |
| `etc/acl.conf`       | EMQ X 默认 ACL 规则配置文件 |
| `etc/plugins/*.conf` | EMQ X 扩展插件配置文件      |

* **监听器**

| 监听器                    | 说明                                                    |
| :------------------------ | :------------------------------------------------------ |
| TCP Listener              | A listener for MQTT which uses TCP                      |
| SSL Listener              | A secure listener for MQTT which uses TLS               |
| Websocket Listener        | A listener for MQTT over WebSockets                     |
| Secure Websocket Listener | A secure listener for MQTT over secure WebSockets (TLS) |

| 端口  | 说明                                        |
| :---- | :------------------------------------------ |
| 1883  | MQTT/TCP 协议端口                           |
| 11883 | MQTT/TCP 协议内部端口，仅用于本机客户端连接 |
| 8883  | MQTT/SSL 协议端口                           |
| 8083  | MQTT/WS 协议端口                            |
| 8084  | MQTT/WSS 协议端口                           |

Listener 配置项的命名规则为 `listener...xxx`， `<Protocol>`即 Listener 使用的协议，目前支持 `tcp`, `ssl`, `ws`, `wss`。

一个 Zone 定义了一组配置项 (比如最大连接数等)，Listener 可以通过配置项 `listener...zone` 指定使用某个 Zone，以使用该 Zone 下的所有配置。多个 Listener 可以共享同一个 Zone。Zone 的命名规则为 `zone..xxx`，`Zone Name` 可以随意命名，但同样建议是全小写的英文单词，`xxx` 是具体的配置项，你可以在 [配置项](https://docs.emqx.io/broker/latest/cn/configuration/configuration.html) 中查看 Zone 支持的所有配置项。

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

