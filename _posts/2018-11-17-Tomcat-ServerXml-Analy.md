---
layout: post
title: Tomcat的server.xml配置文件分析
categories: Java
description: Tomcat的server.xml配置文件分析
keywords: Tomcat, Web, Java
---

# 1.Tomcat的server.xml介绍
* 作用

server.xml是Tomcat中最重要的配置文件，server.xml的每一个元素都对应了Tomcat中的一个组件；通过对xml文件中元素的配置，可以实现对Tomcat中各个组件的控制。

* 位置

$TOMCAT_HOME/conf目录下

# 2.server.xml整体结构
* 核心组件

```xml
<Server>  <!-- 顶层元素<Server>，整个配置文件的根元素 -->
    <Service>  <!-- 顶层元素<Service>，<Service>元素则代表一个Engine元素以及一组与之相连的Connector元素。 -->
        <Connector />   <!-- 连接器<Connector>代表了外部客户端发送请求到特定Service的接口；同时也是外部客户端从特定Service接收响应的接口。 -->
        <Connector />
        <!-- 容器（包括<Engine>、<Host>、<Context>）：容器的功能是处理Connector接收进来的请求，并产生相应的响应。  -->
        <Engine>  <!-- 一个Engine组件可以处理Service中的所有请求 -->
            <Host>  <!-- 一个Host组件可以处理发向一个特定虚拟主机的所有请求 -->
                <Context /><!-- 一个Context组件可以处理一个特定Web应用的所有请求。现在常常使用自动部署，不推荐配置Context元素，Context小节有详细说明 -->
            </Host>
        </Engine>
    </Service>
</Server>
```

* 一个server.xml实例

```xml
<Server port="8005" shutdown="SHUTDOWN">  <!-- shutdown属性表示关闭Server的指令；port属性表示Server接收shutdown指令的端口号，设为-1可以禁掉该端口 -->
  <!--
  VersionLoggerListener：当Tomcat启动时，该监听器记录Tomcat、Java和操作系统的信息。该监听器必须是配置的第一个监听器。
  AprLifecycleListener：Tomcat启动时，检查APR库，如果存在则加载。APR，即Apache Portable Runtime，是Apache可移植运行库，可以实现高可扩展性、高性能，以及与本地服务器技术更好的集成。
  JasperListener：在Web应用启动之前初始化Jasper，Jasper是JSP引擎，把JVM不认识的JSP文件解析成java文件，然后编译成class文件供JVM使用。
  JreMemoryLeakPreventionListener：与类加载器导致的内存泄露有关。
  GlobalResourcesLifecycleListener：通过该监听器，初始化< GlobalNamingResources>标签中定义的全局JNDI资源；如果没有该监听器，任何全局资源都不能使用。< GlobalNamingResources>将在后文介绍。
  ThreadLocalLeakPreventionListener：当Web应用因thread-local导致的内存泄露而要停止时，该监听器会触发线程池中线程的更新。当线程执行完任务被收回线程池时，活跃线程会一个一个的更新。只有当Web应用(即Context元素)的renewThreadsWhenStoppingContext属性设置为true时，该监听器才有效。-->
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
 
  <Service name="Catalina">
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
    <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>
 
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
      </Host>
    </Engine>
  </Service>
</Server>
```

# 3.组件的作用

**1、Server**

Server元素在最顶层，代表整个Tomcat容器，因此它必须是server.xml中**唯一一个最外层的元素**。**一个Server元素中可以有一个或多个Service元素**。

作用：Server提供一个接口让客户端能够访问到这个Service集合，同时维护它所包含的所有的Service的声明周期，包括如何初始化、如何结束服务、如何找到客户端要访问的Service。

**2、Service**

作用：在Connector和Engine外面包了一层，把它们组装在一起，对外提供服务。**一个Service可以包含多个Connector，但是只能包含一个Engine**；其中Connector的作用是从客户端接收请求，Engine的作用是处理接收进来的请求。

**3、Connector**

作用：接收连接请求，创建Request和Response对象用于和请求端交换数据；然后分配线程让Engine来处理这个请求，并把产生的Request和Response对象传给Engine。

**注**：访问服务器，默认访问80端口，即url不带端口时默认80端口。

两个Connector（HTTP和AJP），如下

```xml
<!-- protocol属性规定了请求的协议，port规定了请求的端口号，redirectPort表示当强制要求https而请求是http时，重定向至端口号为8443的Connector，connectionTimeout表示连接的超时时间。 -->
<Connector port="8080" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />
<!-- 客户端可以通过8009端口号使用AJP协议访问Tomcat。AJP协议负责和其他的HTTP服务器(如Apache)建立连接；在把Tomcat与其他HTTP服务器集成时，就需要用到这个连接器。  -->
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
```

>关于8080端口：Tomcat监听HTTP请求，使用的是8080端口，而不是正式的80端口；实际上，在正式的生产环境中，Tomcat也常常监听8080端口，而不是80端口。这是因为在生产环境中，很少将Tomcat直接对外开放接收请求，而是在Tomcat和客户端之间加一层代理服务器(如nginx)，用于请求的转发、负载均衡、处理静态文件等；通过代理服务器访问Tomcat时，是在局域网中，因此一般仍使用8080端口。

>关于AJP的作用：之所以使用Tomcat和其他服务器集成，是因为Tomcat可以用作Servlet/JSP容器，但是对静态资源的处理速度较慢，不如Apache和IIS等HTTP服务器；因此常常将Tomcat与Apache等集成，前者作Servlet容器，后者处理静态资源，而AJP协议便负责Tomcat和Apache的连接。

**4、Engine**

作用：Engine是Service组件中的请求处理组件;Engine组件在Service组件中有且只有一个。Engine组件从一个或多个Connector中接收请求并处理，并将完成的响应返回给Connector，最终传递给客户端。

```xml
<!--name属性用于日志和错误信息，在整个Server中应该唯一。defaultHost属性指定了默认的host名称，当发往本机的请求指定的host名称不存在时，一律使用defaultHost指定的host进行处理；因此，defaultHost的值，必须与Engine中的一个Host组件的name属性值匹配。-->
<Engine name="Catalina" defaultHost="localhost">
```

**5、Host**

(1)Engine和Host

Host是Engine的子容器。Engine组件中可以内嵌1个或多个Host组件，每个Host组件代表Engine中的一个虚拟主机。Host组件至少有一个，且其中一个的name必须与Engine组件的defaultHost属性相匹配。

(2)Host的作用

Host虚拟主机的作用，是运行多个Web应用（一个Context代表一个Web应用），并负责安装、展开、启动和结束每个Web应用。

Host组件代表的虚拟主机，对应了服务器中一个网络名实体(如”www.test.com”，或IP地址”116.25.25.25”)；为了使用户可以通过网络名连接Tomcat服务器，这个名字应该在DNS服务器上注册。
Host是Engine的子容器。Engine组件中可以内嵌1个或多个Host组件，每个Host组件代表Engine中的一个虚拟主机。Host组件至少有一个，且其中一个的name必须与Engine组件的defaultHost属性相匹配。

客户端通常使用主机名来标识它们希望连接的服务器；该主机名也会包含在HTTP请求头中。Tomcat从HTTP头中提取出主机名，寻找名称匹配的主机。如果没有匹配，请求将发送至默认主机。因此默认主机不需要是在DNS服务器中注册的网络名，因为任何与所有Host名称不匹配的请求，都会路由至默认主机。

(3)Host的配置

```xml
<!--unpackWARs指定了是否将代表Web应用的WAR文件解压；如果为true，通过解压后的文件结构运行该Web应用，如果为false，直接使用WAR文件运行Web应用。-->
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
```

name属性指定虚拟主机的主机名，一个Engine中有且仅有一个Host组件的name属性与Engine组件的defaultHost属性相匹配；一般情况下，主机名需要是在DNS服务器中注册的网络名，但是Engine指定的defaultHost不需要

Host的autoDeploy和appBase属性，与Host内Web应用的自动部署有关；此外，本例中没有出现的xmlBase和deployOnStartup(启动部署)属性，也与Web应用的自动部署有关

(4)Web应用自动部署

如果deployOnStartup和autoDeploy设置为true，则tomcat启动自动部署：当检测到新的Web应用或Web应用的更新时，会触发应用的部署(或重新部署)。二者的主要区别在于，deployOnStartup为true时，Tomcat在启动时检查Web应用，且检测到的所有Web应用视作新应用；autoDeploy为true时，Tomcat在运行时定期检查新的Web应用或Web应用的更新。

通过配置deployOnStartup和autoDeploy可以开启虚拟主机自动部署Web应用；实际上，自动部署依赖于检查是否有新的或更改过的Web应用，而Host元素的appBase和xmlBase设置了检查Web应用更新的目录。

xmlBase属性指定Web应用的XML配置文件所在的目录，默认值为conf/\<engine_name\>/\<host_name\>，例如第一部分的例子中，主机localhost的xmlBase的默认值是\$TOMCAT_HOME/conf/Catalina/localhost

tomcat检查应用更新过程：

A、扫描虚拟主机指定的xmlBase下的XML配置文件

B、扫描虚拟主机指定的appBase下的WAR文件

C、扫描虚拟主机指定的appBase下的应用目录

**6、Context**

(1)作用

Context元素代表在特定虚拟主机上运行的一个Web应用。每个Web应用基于WAR文件，或WAR文件解压后对应的目录（这里称为应用目录）。

可以看到server.xml配置文件中并没有出现Context元素的配置。这是因为，Tomcat开启了自动部署，Web应用没有在server.xml中配置静态部署，而是由Tomcat通过特定的规则自动部署。

(2)配置

**docBase**指定了该Web应用使用的WAR包路径，或应用目录。需要注意的是，在自动部署场景下(配置文件位于xmlBase中)，docBase不在appBase目录中，才需要指定；如果docBase指定的WAR包或应用目录就在docBase中，则不需要指定，因为Tomcat会自动扫描appBase中的WAR包和应用目录，指定了反而会造成问题。

**path**指定了访问该Web应用的上下文路径，当请求到来时，Tomcat根据Web应用的 path属性与URI的匹配程度来选择Web应用处理相应请求。例如，Web应用app1的path属性是”/app1”，Web应用app2的path属性是”/app2”，那么请求/app1/index.html会交由app1来处理；而请求/app2/index.html会交由app2来处理。如果一个Context元素的path属性为””，那么这个Context是虚拟主机的默认Web应用；当请求的uri与所有的path都不匹配时，使用该默认Web应用来处理。

但是，需要注意的是，在自动部署场景下(配置文件位于xmlBase中)，不能指定path属性，path属性由配置文件的文件名、WAR文件的文件名或应用目录的名称自动推导出来。如扫描Web应用时，发现了xmlBase目录下的app1.xml，或appBase目录下的app1.WAR或app1应用目录，则该Web应用的path属性是”app1”。如果名称不是app1而是ROOT，则该Web应用是虚拟主机默认的Web应用，此时path属性推导为””。

**reloadable**属性指示tomcat是否在运行时监控在WEB-INF/classes和WEB-INF/lib目录下class文件的改动。如果值为true，那么当class文件改动时，会触发Web应用的重新加载。在开发环境下，reloadable设置为true便于调试；但是在生产环境中设置为true会给服务器带来性能压力，因此reloadable参数的默认值为false。

# 4.核心组件的关联
**1、整体关系**

**Server**元素在最顶层，代表整个Tomcat容器；一个Server元素中可以有一个或多个Service元素。

**Service**在Connector和Engine外面包了一层，把它们组装在一起，对外提供服务。一个Service可以包含多个Connector，但是只能包含一个Engine；Connector接收请求，Engine处理请求。

**Engine**、**Host**和**Context**都是容器，且 Engine包含Host，Host包含Context。每个Host组件代表Engine中的一个虚拟主机；每个Context组件代表在特定Host上运行的一个Web应用。

**2、如何确定请求由谁来处理？**

（1）根据协议和端口号选定Service和Engine

Service中的Connector组件可以接收特定端口的请求，因此，当Tomcat启动时，Service组件就会监听特定的端口。在第一部分的例子中，Catalina这个Service监听了8080端口（基于HTTP协议）和8009端口（基于AJP协议）。当请求进来时，Tomcat便可以根据协议和端口号选定处理请求的Service；Service一旦选定，Engine也就确定。

**通过在Server中配置多个Service，可以实现通过不同的端口号来访问同一台机器上部署的不同应用。**

（2）根据域名或IP地址选定Host

Service确定后，Tomcat在Service中寻找名称与域名/IP地址匹配的Host处理该请求。如果没有找到，则使用Engine中指定的defaultHost来处理该请求。在第一部分的例子中，由于只有一个Host（name属性为localhost），因此该Service/Engine的所有请求都交给该Host处理。

（3）根据URI选定Context/Web应用

Tomcat根据应用的 path属性与URI的匹配程度来选择Web应用处理相应请求。

（4）举例

>以请求http://localhost:8080/app1/index.html为例，首先通过协议和端口号（http和8080）选定Service；然后通过主机名（localhost）选定Host；然后通过uri（/app1/index.html）选定Web应用。



<img src="/images/posts/2018-11-17-Tomcat-ServerXml-Analy/TomcatDeal.png" width="600" alt="tomcat处理请求过程" />



# 5.其他组件

## 5.1 Realm

**说明**

Realm域提供了一种用户密码与web应用的映射关系。

因为tomcat中可以同时部署多个应用，因此并不是每个管理者都有权限去访问或者使用这些应用，因此出现了用户的概念。但是想想，如果每个应用都去配置具有权限的用户，那是一件很麻烦的事情，因此出现了role这样一个概念。具有某一角色，就可以访问该角色对应的应用，从而达到一种域的效果。

<img src="/images/posts/2018-11-17-Tomcat-ServerXml-Analy/Realm.png" width="600" alt="tomcat处理请求过程" />



**作用域**



1 在\<Engine\>元素内部 —— Realm将会被所有的虚拟主机上的web应用共享，除非它被\<Host\>或者\<Context\>元素内部的Realm元素重写。

2 在\<Host\>元素内部 —— 这个Realm将会被本地的虚拟主机中的所有的web应用共享，除非被\<Context\>元素内部的Realm元素重写。

3 在\<Context\>元素内部 —— 这个Realm元素仅仅被该Context指定的应用使用



**获取用户信息的方式**

1、JDBCRealm 用户授权信息存储于某个关系型数据库中，通过JDBC驱动获取信息验证

2、DataSourceRealm 用户授权信息存储于关于型数据中，通过JNDI配置JDBC数据源的方式获取信息验证

3、JNDIRealm  用户授权信息存储在基于LDAP的目录服务的服务器中，通过JNDI驱动获取并验证

4、UserDatabaseRealm **默认的配置方式**，信息存储于XML文档中 conf/tomcat-users.xml

5、MemoryRealm 用户信息存储于内存的集合中，对象集合的数据来源于xml文档 conf/tomcat-users.xml

6、JAASRealm 通过JAAS框架访问授权信息

**配置过程(目前有问题)**

1、配置realm的访问方式(./conf/server.xml)

```xml
  <GlobalNamingResources>
    <!-- Editable user database that can also be used by
         UserDatabaseRealm to authenticate users
    -->
    <!--默认为UserDatabase的Realm方式-->
    <!--配置UserDatabase的目录文件是conf/tomcat-users.xml-->
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
```

2、配置用户密码以及分配角色(./conf/tomcat-users.xml)

```xml
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-status"/>
    <user username="songchaochao" password="123456" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>
```

```xml
      <!-- Use the LockOutRealm to prevent attempts to guess user passwords
           via a brute-force attack -->
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <!-- This Realm uses the UserDatabase configured in the global JNDI
             resources under the key "UserDatabase".  Any edits
             that are performed against this UserDatabase are immediately
             available for use by the Realm.  -->
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm" resourceName="UserDatabase"/>
      </Realm>
```

3、配置访问角色以及安全限制的内容(../manager/WEB-INF/web.xml)

```xml
<login-config>
	<!--DIGEST：加密；BASIC：不加密-->
	<auth-method>DIGEST</auth-method>
	<realm-name>Tomcat Manager Application</realm-name>
</login-config>

```

4、配置./conf/Catalina/localhost

加入manager.xml

```xml
<Context privileged="true" antiResourceLocking="false"
         docBase="${catalina_home}/webapps/manager"><!--catalina_home是tomcat的目录-->
    <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />
</Context>
```


# 6.参考

[Tomcat的server.xml详解](https://www.cnblogs.com/kismetv/p/7228274.html#title3-6)

[Realm介绍和配置](https://blog.csdn.net/u013915688/article/details/79369810)



