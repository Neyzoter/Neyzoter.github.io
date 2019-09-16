---
layout: wiki
title: InfluxDb
categories: db
description: InfluxDb学习笔记
keywords: database, InfluxDB
---



# 1.InfluxDB介绍

## 1.1 介绍

[InfluxDB](http://neyzoter.cn/2019/09/14/Survey-On-Time-Series-DB/#4influxdb)

## 1.2 安装

[地址](https://portal.influxdata.com/downloads/)

### 1.2.1 安装

* **deb**

  ```bash
  $ wget https://dl.influxdata.com/influxdb/releases/influxdb_1.7.8_amd64.deb
  $ sudo dpkg -i influxdb_1.7.8_amd64.deb
  ```

* **linux-bin**

  ```bash
  $ tar zxvf influx*.tar.gz
  ```

### 1.2.2 设置

进入`http://localhost:9999/`设置用户、密码、组织、bucket等信息。

# 2.InfluxDB语言——Flux

## 2.1 实例

<img src="/images/wiki/InfluxDB/Flux_Language.gif" width="700" alt="Flux语言实例" />



# 3.InfluxDB操作

## 3.1 写操作

* **influx指令**

    ```bash
    # -b:bucket -o:organization -t:token -p:precision(s,ms,us,ns)
    $ influx write -b influxdb_bucket -o zju -t yzwAKztIXZLJNSvTPeUuFW7P9z4oWd_NLnGZNcIuoJMY7PCZEm1Lu1s-IIjloYFiSBVhRss7aMaDbh58WdlhGA== -p ns 'myMeasurement,host=myHost testField="testData" 1556896326'
    ```
    
* **http API**

    ```bash
$ curl "http://localhost:9999/api/v2/write?org=YOUR_ORG&bucket=YOUR_BUCKET&precision=s" \
      --header "Authorization: Token YOURAUTHTOKEN" \
      --data-raw "mem,host=host1 used_percent=23.43234543 1556896326"
    ```

* **line protocol**

    `'myMeasurement,host=myHost testField="testData" 1556896326'`是`line protocol`——

    ```
    // Syntax
    <measurement>[,<tag_key>=<tag_value>[,<tag_key>=<tag_value>]] <field_key>=<field_value>[,<field_key>=<field_value>] [<timestamp>]

    // Example
    myMeasurement,tag1=value1,tag2=value2 fieldKey="fieldValue" 1556813561098000000
    ```

    具体来说，包括以下部分：

    ```
    measurementName,tagKey=tagValue fieldKey="fieldValue" 1465839830100400200
    --------------- --------------- --------------------- -------------------
           |               |                  |                    |
      Measurement       Tag set           Field set            Timestamp
    ```
    
    `Measurement`（Required）：测量名称。InfluxDB每点接受一次测量。测量名称区分大小写，并受命名限制（不能一`_`开头，`_`开头的命名由系统使用）。数据类型为String。
    
    `Tag Set`（Optional）：该点的所有标记键值对。键值关系用=操作数表示。多个标记键值对以逗号分隔。标记键和标记值区分大小写。标记键受命名限制。该点的所有标记键值对。键值关系用=操作数表示。多个标记键值对以逗号分隔。标记键和标记值区分大小写。标记键受命名限制。值只能为`String`。
    
    `Field Set`（Required）：这里是数据存储的地方，该点的所有字段键值对。积分必须至少有一个字段。字段键和字符串值区分大小写。字段键受命名限制。值可以是`Float`、`Integer`、`String`、`Boolean`。
    
    `Timestampe`（Option）：数据点的Unix纳秒时间戳。InfluxDB每点接受一个时间戳。如果未提供时间戳，InfluxDB将使用其主机的系统时间（UTC）。数据类型是`Unix timestamp`。

## 3.2 查看数据

浏览器进入`localhost:9999`选择`Data Explore`，再选择过滤选项，如选择`_measurement`的`boltdb_reads_total`，再点击`Script Editor`按钮，再点击`Query Builder`来查看数据。