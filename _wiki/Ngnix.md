---
layout: wiki
title: Nginx
categories: Nginx
description: Ngnix笔记
keywords: 后端开发, Ngnix, Tomcat
---

# 1、介绍
Nginx ("engine x") 是一个开源的，支持高性能、高并发的 Web 服务和代理服务软件。它是由俄罗斯人 Igor Sysoev 开发的，最初被应用在俄罗斯的大型网站 [www.rambler.ru](https://www.rambler.ru/) 上。后来作者将源代码以类 BSD 许可的形式开源出来供全球使用。

## 1.1 基本特性

- 可针对静态资源高速高并发访问及缓存。
- 可使用反向代理加速，并且可进行数据缓存。
- 具有简单负载均衡、节点健康检查和容错功能。
- 支持远程 FastCGI 服务的缓存加速。
- 支持 FastCGI、Uwsgi、SCGI、Memcached Servers 的加速和缓存。
- 支持SSL、TLS、SNI。
- 具有模块化的架构：过滤器包括 gzip 压缩、ranges 支持、chunked 响应、XSLT、SSI 及图像缩放等功能。在SSI 过滤中，一个包含多个 SSI 的页面，如果经由 FastCGI 或反向代理，可被并行处理。

## 1.2 Nginx Web 服务特性

- 支持基于名字、端口及IP的多虚拟主机站点。
- 支持 Keep-alive 和 pipelined 连接。
- 可进行简单、方便、灵活的配置和管理。
- 支持修改 Nginx 配置，并且在代码上线时，可平滑重启，不中断业务访问。
- 可自定义访问日志格式，临时缓冲写日志操作，快速日志轮询及通过 rsyslog 处理日志。
- [可利用信号控制 Nginx 进程。](http://nginx.org/en/docs/control.html)
- 支持 3xx-5xx HTTP状态码重定向。
- 支持 rewrite 模块，支持 URI 重写及正则表达式匹配。
- 支持基于客户端 IP 地址和 HTTP 基本认证的访问控制。
- 支持 PUT、DELETE、MKCOL、COPY 及 MOVE 等特殊的 HTTP 请求方法。
- 支持 FLV 流和 MP4 流技术产品应用。
- 支持 HTTP 响应速率限制。
- 支持同一 IP 地址的并发连接或请求数限制。
- 支持邮件服务代理。

## 1.3 面试必答特性

- 支持高并发：能支持几万并发连接（特别是静态小文件业务环境）。
- 资源消耗少：在3万并发连接下，开启10个 Nginx 线程消耗的内存不到200MB。
- 可以做 HTTP 反向代理及加速缓存，即负载均衡功能，内置对 RS 节点服务器健康检查功能，这相当于专业的 Haproxy 软件或 LVS 的功能。
- 具备 Squid 等专业缓存软件等的缓存功能。
- 支持异步网络 I/O 事件模型 epoll（ Linux 2.6 内核 以上）。

# 2、Nginx使用

## 2.1 [Nginx安装](https://nginx.org/en/linux_packages.html#Ubuntu)

于`ubuntu`的安装，版本支持情况（截止到2019-4-30）：

| Version        | Supported Platforms                  |
| -------------- | ------------------------------------ |
| 14.04 “trusty” | x86_64, i386, aarch64/arm64          |
| 16.04 “xenial” | x86_64, i386, ppc64el, aarch64/arm64 |
| 18.04 “bionic” | x86_64, aarch64/arm64                |
| 18.10 “cosmic” | x86_64                               |
| 19.04 “disco”  | x86_64                               |

（1）前期准备

```bash
# 可能需要安装特定的依赖包，安装上即可
$ sudo apt install curl gnupg2 ca-certificates lsb-release
```

（2）安装稳定版本（经过测试，稳定使用）或者主线版本（一些增加的功能未经测试，可能不稳定）

```bash
# 安装稳定版本
$ echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
# 安装主线版本
$ echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```

（3）`import`官方`nginx`密钥，验证安装包

```bash
$ curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
```

（4）验证正确的密钥

```bash
$ sudo apt-key fingerprint ABF5BD827BD9BF62
```

（5）输出包含`573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62`

```bash
pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
      573B FD6B 3D8F BC64 1079  A6AB ABF5 BD82 7BD9 BF62
uid   [ unknown] nginx signing key <signing-key@nginx.com>
```

（6）安装`nginx`

```bash
$ sudo apt update
$ sudo apt install nginx
```

（7）查看`nginx`运行情况

```bash
$ sudo nginx
```

然后，进入`localhost:80`，可以看到`nginx`的欢迎界面。

```bash
# 基于一个conf文件启动nginx
$ sudo nginx -c [CONF_FILE]
```

（8）关闭`nginx`

```bash
$ sudo nginx -s stop
$ sudo nginx -s quit
```

（9）其他指令

```bash
# 重新加载配置
$ sudo nginx -s reload
# 查看nginx版本
$ sudo nginx -V
```



## 2.2 Nginx实现TCP/UDP代理

（1）查看`nginx`默认配置（默认存在的）

目录为`/etc/nginx/conf.d/default.conf`

```
server {
    listen       80; # 侦听80端口
    server_name  localhost; # 定义使用www.xx.com访问

    #charset koi8-r;   # 字符编码
    #access_log  /var/log/nginx/host.access.log  main;  #设定本虚拟主机的访问日志

    location / {   # 默认请求
        root   /usr/share/nginx/html;  # 定义服务器的默认网站根目录位置
        index  index.html index.htm;  # 定义首页索引文件的名称
    }

    #error_page  404              /404.html;   # 定义错误提示页面

    # redirect server error pages to the static page /50x.html  # 重定向服务器错误页面
    #
    error_page   500 502 503 504  /50x.html;  # 定义错误提示页面
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80 # 代理服务器的PHP脚本到Apache侦听127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000 # 通过PHP脚本到127.0.0.1:9000的FastCGI服务器监听
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

（2）`nginx.conf`配置

目录：`/etc/nginx/nginx.conf`不是`/etc/nginx/conf.d/nginx.conf`

```
# 自动设置启动进程，通常设置成和cpu数目相同
worker_processes auto;
# 日志地址：默认在文件  /etc/nginx/
error_log ./nginx.log info;
# 工作模式的连接上限
events {
    # epoll是多路复用IO(I/O Multiplexing)中的一种方式,
    # 仅用于linux2.6以上内核,可以大大提高nginx的性能   
    # use epoll;
    
    # 单个后台worker process进程的最大并发链接数
    worker_connections  100;
}
# 设置stream服务器
stream {
    # 建立一个tcp连接的upstream
    upstream tcp_conn {
        hash $remote_addr consistent;
		# 包含nginx监听的端口和要代理的端口
        server 127.0.0.1:8089 weight=5;
        server 127.0.0.1:8090            max_fails=3 fail_timeout=30s;
    }
	# 建立一个udp连接的upstream
    upstream udp_data {
   	   # 包含nginx监听的端口和要代理的端口
       server 127.0.0.1:5001;
       server 127.0.0.1:5002;
    }
	# nginx服务器的监听端口设置
    server {
        listen 8090;
        proxy_connect_timeout 20s;
        proxy_timeout 30s;
        # 代理到tcp_conn这个应用
        proxy_pass tcp_conn;
    }
	# nginx服务器的监听端口设置
    server {
        # 这里不要指定127.0.0.1，不然会出错
        listen 5002 udp reuseport;
        proxy_timeout 20s;
        # 代理到udp_data这个应用
        proxy_pass udp_data;
    }
}

```

`nginx`启动后，原本的`UDP`端口5001可以接受来自5002代理的消息；原本的`TCP`端口8089可以接收来自8090端口代理的消息。