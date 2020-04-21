---
layout: wiki
title: Netty
categories: Frame
description: Netty的介绍和使用，来源于《Netty实战-刘品译》
keywords: Netty
---

# 1、Netty结构和功能
## 1.1 Netty组成部分
### 1.1.1 Channel

NIO的基本结构，代表了一个用于连接到实体如硬件设备、文件、网络套接字或程序组建，能够执行一个或多个不同的I/O操作（例如读和写）的开放连接。

* callback(回调)

Netty 内部使用回调处理事件时。一旦这样的回调被触发，事件可以由接口 ChannelHandler 的实现来处理。如下面的代码，一旦一个新的连接建立了,调用 channelActive(),并将打印一条消息。

当建立一个连接时，调用channelActive方法。

```java
public class ConnectHandler extends ChannelInboundHandlerAdapter {
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {   //1
        System.out.println(
                "Client " + ctx.channel().remoteAddress() + " connected");
    }
}
```

### 1.1.2 Future

Future 提供了另外一种通知应用操作已经完成的方式。这个对象作为一个异步操作结果的占位符,它将在将来的某个时候完成并提供结果。

ChannelFuture 提供多个附件方法来允许一个或者多个 ChannelFutureListener 实例。这个回调方法 operationComplete() 会在操作完成时调用。事件监听者能够确认这个操作是否成功或者是错误。如果是后者,我们可以检索到产生的 Throwable。简而言之, ChannelFutureListener 提供的通知机制不需要手动检查操作是否完成的。

每个 Netty 的 outbound I/O 操作都会返回一个 ChannelFuture;这样就不会阻塞。这就是 Netty 所谓的“自底向上的异步和事件驱动”。

```java
Channel channel = ...;
//不会阻塞
ChannelFuture future = channel.connect(
    new InetSocketAddress("192.168.0.1", 25));//异步连接到远程地址

```


```java
Channel channel = ...;
//不会阻塞
ChannelFuture future = channel.connect(            //1
        new InetSocketAddress("192.168.0.1", 25));
future.addListener(new ChannelFutureListener() {  //2
@Override
public void operationComplete(ChannelFuture future) {
    if (future.isSuccess()) {                    //3
        ByteBuf buffer = Unpooled.copiedBuffer(
                "Hello", Charset.defaultCharset()); //4
        ChannelFuture wf = future.channel().writeAndFlush(buffer);                //5
        // ...
    } else {
        Throwable cause = future.cause();        //6
        cause.printStackTrace();
    }
}
});

```

1.异步连接到远程对等节点。调用立即返回并提供 ChannelFuture。

2.操作完成后通知注册一个 ChannelFutureListener 。

3.当 operationComplete() 调用时检查操作的状态。

4.如果成功就创建一个 ByteBuf 来保存数据。

5.异步发送数据到远程。再次返回ChannelFuture。

6.如果有一个错误则抛出 Throwable,描述错误原因。

### 1.1.3 Event和Handler

Netty 使用不同的事件来通知我们更改的状态或操作的状态。使我们能够根据发生的事件触发适当的行为（日志、数据转换、流控制、应用程序逻辑）

每个事件都可以分配给用户实现处理程序类的方法。这说明了事件驱动的范例可直接转换为应用程序构建块。

一个事件可以由一连串的事件处理器来处理，如下图

<img src="/images/wiki/Netty/EventFlow.jpg" width="700" alt="EventFlow" />

### 1.1.4 组成部分的整合说明

* FUTURE, CALLBACK 和 HANDLER

Netty 的异步编程模型是建立在 future 和 callback 的概念上的。所有这些元素的协同为自己的设计提供了强大的力量。

拦截操作和转换入站或出站数据只需要您提供回调或利用 future 操作返回的。这使得链操作简单、高效,促进编写可重用的、通用的代码。一个 Netty 的设计的主要目标是促进“关注点分离”:你的业务逻辑从网络基础设施应用程序中分离。

* SELECTOR, EVENT 和 EVENT LOOP

Netty 通过触发事件从应用程序中抽象出 Selector，从而避免手写调度代码。EventLoop 分配给每个 Channel 来处理所有的事件，包括

1、注册感兴趣的事件

2、调度事件到 ChannelHandler

3、安排进一步行动

该 EventLoop 本身是由只有一个线程驱动，它给一个 Channel 处理所有的 I/O 事件，并且在 EventLoop 的生命周期内不会改变。这个简单而强大的线程模型消除你可能对你的 ChannelHandler 同步的任何关注，这样你就可以专注于提供正确的回调逻辑来执行。该 API 是简单和紧凑。

## 1.2 Netty构架模型

**BOOTSTRAP**

Netty 应用程序通过设置 bootstrap（引导）类的开始，该类提供了一个用于应用程序网络层配置的容器。

**CHANNEL**

底层网络传输 API 必须提供给应用 I/O操作的接口，如读，写，连接，绑定等等。对于我们来说，这是结构几乎总是会成为一个“socket”。 Netty 中的接口 Channel 定义了与 socket 丰富交互的操作集：bind, close, config, connect, isActive, isOpen, isWritable, read, write 等等。 Netty 提供大量的 Channel 实现来专门使用。这些包括 AbstractChannel，AbstractNioByteChannel，AbstractNioChannel，EmbeddedChannel， LocalServerChannel，NioSocketChannel 等等。

**CHANNELHANDLER**

ChannelHandler 支持很多协议，并且提供用于数据处理的容器。我们已经知道 ChannelHandler 由特定事件触发。 ChannelHandler 可专用于几乎所有的动作，包括将一个对象转为字节（或相反），执行过程中抛出的异常处理。

常用的一个接口是 ChannelInboundHandler，这个类型接收到入站事件（包括接收到的数据）可以处理应用程序逻辑。当你需要提供响应时，你也可以从 ChannelInboundHandler 冲刷数据。一句话，业务逻辑经常存活于一个或者多个 ChannelInboundHandler。

**CHANNELPIPELINE**

ChannelPipeline 提供了一个容器给 ChannelHandler 链并提供了一个API 用于管理沿着链入站和出站事件的流动。每个 Channel 都有自己的ChannelPipeline，当 Channel 创建时自动创建的。 ChannelHandler 是如何安装在 ChannelPipeline？ 主要是实现了ChannelHandler 的抽象 ChannelInitializer。ChannelInitializer子类 通过 ServerBootstrap 进行注册。当它的方法 initChannel() 被调用时，这个对象将安装自定义的 ChannelHandler 集到 pipeline。当这个操作完成时，ChannelInitializer 子类则 从 ChannelPipeline 自动删除自身。

**EVENTLOOP**

EventLoop 用于处理 Channel 的 I/O 操作。一个单一的 EventLoop通常会处理多个 Channel 事件。一个 EventLoopGroup 可以含有多于一个的 EventLoop 和 提供了一种迭代用于检索清单中的下一个。

**CHANNELFUTURE**

Netty 所有的 I/O 操作都是异步。因为一个操作可能无法立即返回，我们需要有一种方法在以后确定它的结果。出于这个目的，Netty 提供了接口 ChannelFuture,它的 addListener 方法注册了一个 ChannelFutureListener ，当操作完成时，可以被通知（不管成功与否）。

### 1.2.1 Channel, Event 和 I/O

<img src="/images/wiki/Netty/ChannelEventIO.jpg" width="700" alt="ChannelEventIO" />

一个 EventLoopGroup 具有一个或多个 EventLoop。想象 EventLoop 作为一个 Thread 给 Channel 执行工作。 （事实上，一个 EventLoop 是势必为它的生命周期一个线程。）

当创建一个 Channel，Netty 通过 一个单独的 EventLoop 实例来注册该 Channel（并同样是一个单独的 Thread）的通道的使用寿命。这就是为什么你的应用程序不需要同步 Netty 的 I/O操作;所有 Channel 的 I/O 始终用相同的线程来执行。

### 1.2.2 Bootstrapping
Bootstrapping（引导） 是出现在Netty 配置程序的过程中，Bootstrapping在给服务器绑定指定窗口或者要连接客户端的时候会使用到。分为客户端的Bootstrap和ServerBootstrap

|分类 | Bootstrap  | ServerBootstrap|
|-|-|-|
|网络功能  |  连接到远程主机和端口 | 绑定本地端口|
|-|-|-|
|EventLoopGroup数量  | 1 |  2|

Bootstrap和ServerBootstrap的差异：1、“ServerBootstrap”监听在服务器监听一个端口轮询客户端的“Bootstrap”或DatagramChannel是否连接服务器；2、一个 ServerBootstrap 可以认为有2个 Channel 集合，第一个集合包含一个单例 ServerChannel，代表持有一个绑定了本地端口的 socket；第二集合包含所有创建的 Channel，处理服务器所接收到的客户端进来的连接。

<img src="/images/wiki/Netty/ServerWith2EventLoopGroups.jpg" width="700" alt="ServerWith2EventLoopGroups" />

### 1.2.3 Channel和ChannlePipeline
ChannelInboundHandler 和 ChannelOutboundHandler 继承自父接口 ChannelHandler

<img src="/images/wiki/Netty/ChannelHandlerClassHierarchy.jpg" width="700" alt="ChannelHandlerClassHierarchy" />

为了使数据从一端到达另一端，一个或多个 ChannelHandler 将以某种方式操作数据。这些 ChannelHandler 会在程序的“引导”阶段被添加ChannelPipeline中，并且被添加的顺序将决定处理数据的顺序。进站和出站的处理器都可以被安装在相同的 pipeline 

<img src="/images/wiki/Netty/ChannelPipelineWithInboundOutboundChannelHandlers.jpg" width="700" alt="ChannelPipelineWithInboundOutboundChannelHandlers" />

**在当前的链（chain）中，事件可以通过 ChanneHandlerContext 传递给下一个 handler。Netty 为此提供了抽象基类ChannelInboundHandlerAdapter 和 ChannelOutboundHandlerAdapter，用来处理你想要的事件。**可以简单地通过调用 ChannelHandlerContext 上的相应方法将事件传递给下一个 handler。在实际应用中，您可以按需覆盖相应的方法即可。

在 Netty 发送消息可以采用两种方式：直接写消息给 Channel 或者写入 ChannelHandlerContext 对象。这两者主要的区别是， 前一种方法会导致消息从 ChannelPipeline的尾部开始，而后者导致消息从 ChannelPipeline 下一个处理器开始。

### 1.2.4 ChannelHandler
Netty提供了一些默认的处理程序来实现形式的“adapter（适配器）”类。pipeline 中每个的 ChannelHandler 主要负责转发事件到链中的下一个处理器。这些适配器类（及其子类）会自动帮你实现，所以你只需要实现该特定的方法和事件。

适配器的作用：有几个适配器类，可以减少编写自定义 ChannelHandlers ，因为他们提供对应接口的所有方法的默认实现。（也有类似的适配器，用于创建编码器和解码器，这我们将在稍后讨论。）这些都是创建自定义处理器时，会经常调用的适配器：ChannelHandlerAdapter、ChannelInboundHandlerAdapter、ChannelOutboundHandlerAdapter、ChannelDuplexHandlerAdapter

* 解码

解码：入站消息将从字节转为一个Java对象。


* 编码

编码：消息出战，从java对象转化为字节。

* SimpleChannelHandler

最常见的处理器是接收到解码后的消息并应用一些业务逻辑到这些数据。

SimpleChannelHandler将覆盖基类的一个或多个方法，将获得被作为输入参数传递所有方法的 ChannelHandlerContext 的引用。

I/O 线程一定不能完全阻塞，因此禁止任何直接阻塞操作在你的 ChannelHandler， 有一种方法来实现这一要求。你可以指定一个 EventExecutorGroup。当添加 ChannelHandler 到ChannelPipeline。此 EventExecutorGroup 将用于获得EventExecutor，将执行所有的 ChannelHandler 的方法。这EventExecutor 将从 I/O 线程使用不同的线程，从而释放EventLoop。

## 1.3 Transport(传输)
### 1.3.1 Netty的好处
迁移方便，见下方从阻塞IO（OIO）到非阻塞IO（NIO）的转化。

下面是阻塞IO

```java
public class NettyOioServer {

    public void server(int port) throws Exception {
        final ByteBuf buf = Unpooled.unreleasableBuffer(
                Unpooled.copiedBuffer("Hi!\r\n", Charset.forName("UTF-8")));
        EventLoopGroup group = new OioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();        //1

            b.group(group)                                    //2
             .channel(OioServerSocketChannel.class)
             .localAddress(new InetSocketAddress(port))
             .childHandler(new ChannelInitializer<SocketChannel>() {//3
                 @Override
                 public void initChannel(SocketChannel ch) 
                     throws Exception {
                     ch.pipeline().addLast(new ChannelInboundHandlerAdapter() {            //4
                         @Override
                         public void channelActive(ChannelHandlerContext ctx) throws Exception {
                             ctx.writeAndFlush(buf.duplicate()).addListener(ChannelFutureListener.CLOSE);//5
                         }
                     });
                 }
             });
            ChannelFuture f = b.bind().sync();  //6
            f.channel().closeFuture().sync();
        } finally {
            group.shutdownGracefully().sync();        //7
        }
    }
}

```

1.创建一个 ServerBootstrap

2.使用 OioEventLoopGroup 允许阻塞模式（OIO）

3.指定 ChannelInitializer 将给每个接受的连接调用

4.添加的 ChannelHandler 拦截事件，并允许他们作出反应

5.写信息到客户端，并添加 ChannelFutureListener 当一旦消息写入就关闭连接

6.绑定服务器来接受连接

7.释放所有资源

下面是非阻塞IO

```java
public class NettyOioServer {

    public void server(int port) throws Exception {
        final ByteBuf buf = Unpooled.unreleasableBuffer(
                Unpooled.copiedBuffer("Hi!\r\n", Charset.forName("UTF-8")));
        EventLoopGroup group = new OioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();        //1

            b.group(group)                                    //2
             .channel(OioServerSocketChannel.class)
             .localAddress(new InetSocketAddress(port))
             .childHandler(new ChannelInitializer<SocketChannel>() {//3
                 @Override
                 public void initChannel(SocketChannel ch) 
                     throws Exception {
                     ch.pipeline().addLast(new ChannelInboundHandlerAdapter() {            //4
                         @Override
                         public void channelActive(ChannelHandlerContext ctx) throws Exception {
                             ctx.writeAndFlush(buf.duplicate()).addListener(ChannelFutureListener.CLOSE);//5
                         }
                     });
                 }
             });
            ChannelFuture f = b.bind().sync();  //6
            f.channel().closeFuture().sync();
        } finally {
            group.shutdownGracefully().sync();        //7
        }
    }
}
```

1.创建一个 ServerBootstrap

2.使用 NioEventLoopGroup 允许非阻塞模式（NIO）

3.指定 ChannelInitializer 将给每个接受的连接调用

4.添加的 ChannelInboundHandlerAdapter() 接收事件并进行处理

5.写信息到客户端，并添加 ChannelFutureListener 当一旦消息写入就关闭连接

6.绑定服务器来接受连接

7.释放所有资源

### 1.3.2 基于Netty传输的API
还可以在运行时根据需要添加 ChannelHandler 实例到ChannelPipeline 或从 ChannelPipeline 中删除，这能帮助我们构建高度灵活的 Netty 程序。

**channel的主要方法**

|方法名称  |  描述|
|-|-|
|eventLoop() | 返回分配给Channel的EventLoop|
|-|-|
|pipeline() | 返回分配给Channel的ChannelPipeline|
|-|-|
|isActive() | 返回Channel是否激活，已激活说明与远程连接对等|
|-|-|
|localAddress() | 返回已绑定的本地SocketAddress|
|-|-|
|remoteAddress() | 返回已绑定的远程SocketAddress|
|-|-|
|write()  | 写数据到远程客户端，数据通过ChannelPipeline传输过去|
|-|-|
|flush()  | 刷新先前的数据|
|-|-|
|writeAndFlush(...) | 一个方便的方法用户调用write(...)而后调用y flush()|

通过Channel写数据到远程已连接客户端

```java
Channel channel = ...; // 获取channel的引用
ByteBuf buf = Unpooled.copiedBuffer("your data", CharsetUtil.UTF_8);            //1
ChannelFuture cf = channel.writeAndFlush(buf); //2

cf.addListener(new ChannelFutureListener() {    //3
    @Override
    public void operationComplete(ChannelFuture future) {
        if (future.isSuccess()) {                //4
            System.out.println("Write successful");
        } else {
            System.err.println("Write error");    //5
            future.cause().printStackTrace();
        }
    }
});
```

1.创建 ByteBuf 保存写的数据

2.写数据，并刷新

3.添加 ChannelFutureListener 即可写操作完成后收到通知，

4.写操作没有错误完成

5.写操作完成时出现错误


Channel 是线程安全(thread-safe)的，它可以被多个不同的线程安全的操作，在多线程环境下，所有的方法都是安全的。

```java
final Channel channel = ...; // 获取channel的引用
final ByteBuf buf = Unpooled.copiedBuffer("your data",
        CharsetUtil.UTF_8).retain();    //1
Runnable writer = new Runnable() {        //2
    @Override
    public void run() {
        channel.writeAndFlush(buf.duplicate());
    }
};
Executor executor = Executors.newCachedThreadPool();//3

//写进一个线程
executor.execute(writer);        //4

//写进另外一个线程
executor.execute(writer);        //5
```

### 1.3.3 Netty中的传输方式
|方法名称  |  包  | 描述|
|-|-|-|
|NIO | io.netty.channel.socket.nio | 基于java.nio.channels的工具包，使用选择器作为基础的方法。|
|OIO | io.netty.channel.socket.oio | 基于java.net的工具包，使用阻塞流。|
|Local  | io.netty.channel.local | 用来在虚拟机之间本地通信。|
|Embedded  |  io.netty.channel.embedded |  嵌入传输，它允许在没有真正网络的传输中使用 ChannelHandler，可以非常有用的来测试ChannelHandler的实现。|

OIO-在低连接数、需要低延迟时、阻塞时使用

NIO-在高连接数时使用

Local-在同一个JVM内通信时使用

Embedded-测试ChannelHandler时使用

* NIO

<img src="/images/wiki/Netty/SelectProcessStateChanges.jpg" width="700" alt="ChannelHandlerClassHierarchy" />

1.新信道注册 WITH 选择器

2.选择处理的状态变化的通知

3.以前注册的通道

4.Selector.select（）方法阻塞，直到新的状态变化接收或配置的超时 已过

5.检查是否有状态变化

6.处理所有的状态变化

7.在选择器操作的同一个线程执行其他任务

* OIO

<img src="/images/wiki/Netty/OIOProcessingLogic.jpg" width="700" alt="OIOProcessingLogic" />

1.线程分配给 Socket

2.Socket 连接到远程

3.读操作（可能会阻塞）

4.读完成

5.处理可读的字节

6.执行提交到 socket 的其他任务

7.再次尝试读

* Local

Netty 提供了“本地”传输，为运行在同一个 Java 虚拟机上的服务器和客户之间提供异步通信。此传输支持所有的 Netty 常见的传输实现的 API。

在此传输中，与服务器 Channel 关联的 SocketAddress 不是“绑定”到一个物理网络地址中，而是在服务器是运行时它被存储在注册表中，当 Channel 关闭时它会注销。由于该传输不是“真正的”网络通信，它不能与其他传输实现互操作。因此，客户端是希望连接到使用本地传输的的服务器时，要注意正确的用法。除此限制之外，它的使用是与其他的传输是相同的。

* 内嵌Transport

Netty中 还提供了可以嵌入 ChannelHandler 实例到其他的 ChannelHandler 的传输，使用它们就像辅助类，增加了灵活性的方法，使您可以与你的 ChannelHandler 互动。

该嵌入技术通常用于测试 ChannelHandler 的实现，但它也可用于将功能添加到现有的 ChannelHandler 而无需更改代码。嵌入传输的关键是Channel 的实现，称为“EmbeddedChannel”。

## 1.4 Netty的Buffer API
### 1.4.1 特点
包括Bytebuf和BytebufHolder

Netty 根据 reference-counting(引用计数)来确定何时可以释放 ByteBuf 或 ByteBufHolder 和其他相关资源，从而可以利用池和其他技巧来提高性能和降低内存的消耗。

特点：

1、可以自定义缓冲类型

2、通过一个内置的复合缓冲类型实现零拷贝

>1) Netty的接收和发送ByteBuffer采用DIRECT BUFFERS，使用堆外直接内存进行Socket读写，不需要进行字节缓冲区的二次拷贝。如果使用传统的堆内存（HEAP BUFFERS）进行Socket读写，JVM会将堆内存Buffer拷贝一份到直接内存中，然后才写入Socket中。


>2) Netty提供了组合Buffer对象，可以聚合多个ByteBuffer对象，用户可以像操作一个Buffer那样方便的对组合Buffer进行操作，避免了传统通过内存拷贝的方式将几个小Buffer合并成一个大的Buffer。


>3) Netty的文件传输采用了transferTo方法，它可以直接将文件缓冲区的数据发送到目标Channel，避免了传统通过循环write方式导致的内存拷贝问题。

3、扩展性好，比如 StringBuilder

4、不需要调用 flip() 来切换读/写模式

5、读取和写入索引分开

6、方法链

7、引用计数

8、Pooling(池)

使用内存池分配器创建直接内存缓冲区ByteBuf比普通ByteBuf效率更高。

```
//使用内存池分配器创建直接内存缓冲区
poolBuffer = PooledByteBufAllocator.DEFAULT.directBuffer(1024);
//基于非内存池创建的非堆内存缓冲区测试用例
poolBuffer = Unpooled.directBuffer(1024);
```

### 1.4.2 Bytebuf工作原理
写入数据到 ByteBuf 后，writerIndex（写入索引）增加写入的字节数。读取字节后，readerIndex（读取索引）也增加读取出的字节数。可以读取字节，直到写入索引和读取索引处在相同的位置。此时ByteBuf不可读，所以下一次读操作将会抛出 IndexOutOfBoundsException，就像读取数组时越位一样。

<img src="/images/wiki/Netty/16-byteBytebufwithItsIndicesSet.jpg" width="700" alt="OIOProcessingLogic" />

**调用 ByteBuf 的以 "read" 或 "write" 开头的任何方法都将自动增加相应的索引。另一方面，"set" 、 "get"操作字节将不会移动索引位置，它们只会在指定的相对位置上操作字节。**如readUnsignedByte()，getUnsignedByte()


**ByteBuf 使用模式**

Bytebuf的分配见   [1.4.5 Bytebuf分配](### 1.4.5 Bytebuf分配)

*1、HEAP BUFFER(堆缓冲区)*

最常用的模式是 ByteBuf 将数据存储在 JVM 的堆空间。通过 ByteBuf.array() 来获取 byte[]数据。 

```java
ByteBuf heapBuf = ...;
if (heapBuf.hasArray()) {                //1
    byte[] array = heapBuf.array();        //2
    int offset = heapBuf.arrayOffset() + heapBuf.readerIndex();                //3
    int length = heapBuf.readableBytes();//4
    handleArray(array, offset, length); //5
}
```

1.检查 ByteBuf 是否有支持数组。

2.如果有的话，得到引用数组。

3.计算第一字节的偏移量。

4.获取可读的字节数。

5.使用数组，偏移量和长度作为调用方法的参数

*2、DIRECT BUFFER(直接缓冲区)*

在 JDK1.4 中被引入 NIO 的ByteBuffer 类允许 JVM 通过本地方法调用分配内存，其目的是

* 通过免去中间交换的内存拷贝, 提升IO处理速度; 直接缓冲区的内容可以驻留在垃圾回收扫描的堆区以外。

* DirectBuffer 在 -XX:MaxDirectMemorySize=xxM大小限制下, 使用 Heap 之外的内存, GC对此”无能为力”,也就意味着规避了在高负载下频繁的GC过程对应用线程的中断影响

如果你的数据是存放在堆中分配的缓冲区，那么实际上，在通过 socket 发送数据之前，JVM 需要将先数据复制到直接缓冲区。

如果要将数据传递给遗留代码处理，因为数据不是在堆上，可能不得不作出一个副本。如下：

```java
ByteBuf directBuf = ...    //这是一个存放在物理内存直接缓存区的Bytebuf
if (!directBuf.hasArray()) {            //1
    int length = directBuf.readableBytes();//2
    byte[] array = new byte[length];    //3
    directBuf.getBytes(directBuf.readerIndex(), array);        //4    
    handleArray(array, 0, length);  //5
}

```

1.检查 ByteBuf 是不是由数组支持。如果不是，这是一个直接缓冲区。

2.获取可读的字节数

3.分配一个新的数组来保存字节

4.字节复制到数组

5.将数组，偏移量和长度作为参数调用某些处理方法

这比使用数组要多做一些工作。因此，如果你事前就知道容器里的数据将作为一个数组被访问，你可能更愿意使用堆内存。

**非直接缓冲区与直接缓冲区**

非直接缓冲区：通过 allocate() 方法分配缓冲区，将缓冲区建立在 JVM 的内存中

直接缓冲区：通过 allocateDirect() 方法分配直接缓冲区，将缓冲区建立在物理内存中。可以提高效率

直接缓存区，在JVM内存外开辟内存，在每次调用基础操作系统的一个本机IO之前或者之后，虚拟机都会避免将缓冲区的内容复制到中间缓冲区（或者从中间缓冲区复制内容），缓冲区的内容驻留在物理内存内，会少一次复制过程，如果需要循环使用缓冲区，用直接缓冲区可以很大地提高性能。虽然直接缓冲区使JVM可以进行高效的I/O操作，但它使用的内存是操作系统分配的，绕过了JVM堆栈，建立和销毁比堆栈上的缓冲区要更大的开销。



<img src="/images/wiki/Netty/NonDirectBuffer.png" width="700" alt="非直接缓冲区" />

<img src="/images/wiki/Netty/DirectBuffer.png" width="700" alt="直接缓冲区" />

*3、COMPOSITE BUFFER(复合缓冲区)*

创建多个不同的 ByteBuf，然后提供一个这些 ByteBuf 组合的视图。复合缓冲区就像一个列表，我们可以动态的添加和删除其中的 ByteBuf，JDK 的 ByteBuffer 没有这样的功能。

Netty 提供了 ByteBuf 的子类 CompositeByteBuf 类来处理复合缓冲区，CompositeByteBuf 只是一个视图。

**注**：CompositeByteBuf.hasArray() 总是返回 false，因为它可能既包含堆缓冲区，也包含直接缓冲区

一条消息由 header 和 body 两部分组成，将 header 和 body 组装成一条消息发送出去，**可能 body 相同，只是 header 不同，使用CompositeByteBuf 就不用每次都重新分配一个新的缓冲区**。下图显示CompositeByteBuf 组成 header 和 body：

<img src="/images/wiki/Netty/CompositeByteBuf.jpg" width="700" alt="复合缓冲区" />

实现：

```java
CompositeByteBuf messageBuf = ...;   //这是一个复合缓存区
ByteBuf headerBuf = ...; // 可以支持或直接
ByteBuf bodyBuf = ...; // 可以支持或直接
messageBuf.addComponents(headerBuf, bodyBuf);
// ....
messageBuf.removeComponent(0); // 移除头    //2

for (int i = 0; i < messageBuf.numComponents(); i++) {                        //3
    System.out.println(messageBuf.component(i).toString());
}
```

1.追加 ByteBuf 实例的 CompositeByteBuf

2.删除 索引1的 ByteBuf

3.遍历所有 ByteBuf 实例。

下面时处理数据：

```java
CompositeByteBuf compBuf = ...;
int length = compBuf.readableBytes();    //1
byte[] array = new byte[length];        //2
compBuf.getBytes(compBuf.readerIndex(), array);    //3
handleArray(array, 0, length);    //4
```

1.得到的可读的字节数。

2.分配一个新的数组,数组长度为可读字节长度。

3.读取字节到数组

4.使用数组，把偏移量和长度作为参数

### 1.4.3 Netty字节级别操作
<img src="/images/wiki/Netty/BytebufInternalSegmentation.jpg" width="700" alt="Bytebuf内部满足的关系" />

1.字节，可以被丢弃，因为它们已经被读。通过调用discardReadBytes() 来回收空间。

2.还没有被读的字节是：“readable bytes（可读字节）”

3.空间可加入多个字节的是：“writeable bytes（写字节）”

通过调用discardReadBytes() 来回收空间后。这个段的初始大小存储在readerIndex，为 0，当“read”操作被执行时递增（“get”操作不会移动 readerIndex）。

<img src="/images/wiki/Netty/AfterDiscardingReadBytes.jpg" width="700" alt="抛弃掉已读数据后的Bytebuf" />

* 索引管理

设置和重新定位ByteBuf readerIndex 和 writerIndex 通过调用 markReaderIndex(), markWriterIndex(), resetReaderIndex() 和 resetWriterIndex()。这些是分别用来 **标记流中的当前位置和复位流到该位置**。

通过调用 readerIndex(int) 或 writerIndex(int) 将指标移动到指定的位置。

* 查询操作

bytebuf.indexOf()：找到特定byte值所的索引

bytebuf.forEachByte(ByteBufProcessor.FIND_CR)：找到"\r"

* 衍生缓冲区

由 duplicate(), slice(), slice(int, int),readOnly(), 和 order(ByteOrder) 方法创建的。所有这些都返回一个新的 ByteBuf 实例包括它自己的 reader, writer 和标记索引。

拷贝的方法：

如果需要已有的缓冲区的全新副本，使用 copy() 或者 copy(int, int)。不同于派生缓冲区，这个调用返回的 ByteBuf 有数据的独立副本。

若需要操作某段数据，使用 slice(int, int)

```java
Charset utf8 = Charset.forName("UTF-8");
ByteBuf buf = Unpooled.copiedBuffer("Netty in Action rocks!", utf8); //1

ByteBuf sliced = buf.slice(0, 14);          //2
System.out.println(sliced.toString(utf8));  //3

buf.setByte(0, (byte) 'J');                 //4
assert buf.getByte(0) == sliced.getByte(0);
```

1.创建一个 ByteBuf 保存特定字节串。

2.创建从索引 0 开始，并在 14 结束的 ByteBuf 的新 slice。

3.打印 Netty in Action

4.更新索引 0 的字节。

5.断言成功，因为数据是共享的，并以一个地方所做的修改将在其他地方可见。

* 读/写操作

主要包括get()/set()和read()/write()。

get()/set() 操作从给定的索引开始，保持不变

read()/write() 操作从给定的索引开始，与字节访问的数量来适用，递增当前的写索引或读索引

|get方法名称  |  描述|
|-|-|
|getBoolean(int)| 返回当前索引的 Boolean 值|
|-|-|
|getByte(int)  / getUnsignedByte(int) |  返回当前索引的(无符号)字节
|-|-|
|getMedium(int) / getUnsignedMedium(int)  | 返回当前索引的 (无符号) 24-bit 中间值|
|-|-|
|getInt(int) / getUnsignedInt(int) | 返回当前索引的(无符号) 整型|
|-|-|
|getLong(int) / getUnsignedLong(int) |  返回当前索引的 (无符号) Long 型|
|-|-|
|getShort(int) / getUnsignedShort(int) | 返回当前索引的 (无符号) Short 型|
|-|-|
|getBytes(int, ...)  | 字节|


|set方法名称  |  描述|
|-|-|
|setBoolean(int, boolean)   | 在指定的索引位置设置 Boolean 值|
|-|-|
|setByte(int, int)  | 在指定的索引位置设置 byte 值|
|-|-|
|setMedium(int, int) | 在指定的索引位置设置 24-bit 中间 值|
|-|-|
|setInt(int, int)  |  在指定的索引位置设置 int 值|
|-|-|
|setLong(int, long) | 在指定的索引位置设置 long 值|
|-|-|
|setShort(int, int) |  在指定的索引位置设置 short 值|

```java
Charset utf8 = Charset.forName("UTF-8");
ByteBuf buf = Unpooled.copiedBuffer("Netty in Action rocks!", utf8);    //1创建一个新的 ByteBuf 给指定 String 保存字节
System.out.println((char)buf.getByte(0));                    //2

int readerIndex = buf.readerIndex();                        //3
int writerIndex = buf.writerIndex();

buf.setByte(0, (byte)'B');                            //4

System.out.println((char)buf.getByte(0));                    //5
assert readerIndex == buf.readerIndex();                    //6这些断言成功，因为这些操作永远不会改变索引
assert writerIndex ==  buf.writerIndex();
```

|read方法名称  |  描述|
|-|-|
|readBoolean()　 | 　Reads the Boolean value at the current readerIndex and increases the readerIndex by 1.|
|-|-|
|readByte()　/  readUnsignedByte()　|  Reads the (unsigned) byte value at the current readerIndex and increases　the readerIndex by 1.|
|-|-|
|readMedium()　/ readUnsignedMedium()　|  Reads the (unsigned) 24-bit medium value at the current readerIndex and　increases the readerIndex by 3.|
|-|-|
|readInt()　/ readUnsignedInt() |　Reads the (unsigned) int value at the current readerIndex and increases　the readerIndex by 4.|
|-|-|
|readLong()　/ readUnsignedLong()　| 　Reads the (unsigned) int value at the current readerIndex and increases　the readerIndex by 8.|
|-|-|
|readShort()　/ readUnsignedShort()　  |  Reads the (unsigned) int value at the current readerIndex and increases　the readerIndex by 2.|
|-|-|
|readBytes(int,int, ...) | Reads the value on the current readerIndex for the given length into the　given object. Also increases the readerIndex by the length.|

|write方法名称  |  描述|
|-|-|
|writeBoolean(boolean)  | 　Writes the Boolean value on the current writerIndex and increases the　writerIndex by 1.|
|-|-|
|writeByte(int) | 　Writes the byte value on the current writerIndex and increases the　writerIndex by 1.|
|-|-|
|writeMedium(int) |   　Writes the medium value on the current writerIndex and increases the　writerIndex by 3.|
|-|-|
|writeInt(int)  | 　Writes the int value on the current writerIndex and increases the　writerIndex by 4.|
|-|-|
|writeLong(long) |　Writes the long value on the current writerIndex and increases the　writerIndex by 8.|
|-|-|
|writeShort(int) |　Writes the short value on the current writerIndex and increases thewriterIndex by 2.|
|-|-|
|writeBytes(int，...） |　Transfers the bytes on the current writerIndex from given resources.|

```java
Charset utf8 = Charset.forName("UTF-8");
ByteBuf buf = Unpooled.copiedBuffer("Netty in Action rocks!", utf8);    //1
System.out.println((char)buf.readByte());                    //2

int readerIndex = buf.readerIndex();                        //3
int writerIndex = buf.writerIndex();                        //4

buf.writeByte((byte)'?');                            //5

assert readerIndex == buf.readerIndex();
assert writerIndex != buf.writerIndex();
```


|其他方法名称  |  描述|
|-|-|
|isReadable() |   Returns true if at least one byte can be read.
|-|-|
|isWritable()  |  Returns true if at least one byte can be written.|
|-|-|
|readableBytes() | Returns the number of bytes that can be read.|
|-|-|
|writablesBytes()   | Returns the number of bytes that can be written.|
|-|-|
|capacity() | Returns the number of bytes that the ByteBuf can hold. After this it will try to expand again until maxCapacity() is reached.|
|-|-|
|maxCapacity()  | Returns the maximum number of bytes the ByteBuf can hold.|
|-|-|
|hasArray() | Returns true if the ByteBuf is backed by a byte array.|
|-|-|
|array() | Returns the byte array if the ByteBuf is backed by a byte array, otherwise throws an UnsupportedOperationException|

### 1.4.4 BytebufHolder
需要另外存储除有效的实际数据各种属性值

|名称 | 描述|
|-|-|
|data() | 返回 ByteBuf 保存的数据|
|-|-|
|copy() | 制作一个 ByteBufHolder 的拷贝，但不共享其数据(所以数据也是拷贝).|

如果你想实现一个“消息对象”有效负载存储在 ByteBuf，使用ByteBufHolder 是一个好主意。   

### 1.4.5 Bytebuf分配
* ByteBufAllocator

为了减少分配和释放内存的开销，Netty 通过支持 **池类 ByteBufAllocator** ，可用于分配的任何 ByteBuf 我们已经描述过的类型的实例。

Netty 默认使用 PooledByteBufAllocator，我们可以通过 ChannelConfig 或通过引导设置一个不同的实现来改变。

|名称 | 描述|
|-|-|
|buffer() / buffer(int) / buffer(int, int) |  Return a ByteBuf with heap-based or direct data storage.|
|-|-|
|heapBuffer() / heapBuffer(int) / heapBuffer(int, int)  | Return a ByteBuf with heap-based storage.|
|-|-|
|directBuffer() / directBuffer(int) / directBuffer(int, int) | Return a ByteBuf with direct storage.|
|-|-|
|compositeBuffer() / compositeBuffer(int) / heapCompositeBuffer() / heapCompositeBuffer(int) / directCompositeBuffer() / directCompositeBuffer(int)  | Return a CompositeByteBuf that can be expanded by adding heapbased or direct buffers.|
|-|-|
|ioBuffer() | Return a ByteBuf that will be used for I/O operations on a socket.|

```java
Channel channel = ...;
ByteBufAllocator allocator = channel.alloc(); //1从 channel 获得 ByteBufAllocator
....
ChannelHandlerContext ctx = ...;
ByteBufAllocator allocator2 = ctx.alloc(); //2从 ChannelHandlerContext 获得 ByteBufAllocator
...
```

* Unpooled （非池化）缓存

当未引用 ByteBufAllocator 时，上面的方法无法访问到 ByteBuf。对于这个用例 Netty 提供一个实用工具类称为 Unpooled,，它提供了静态辅助方法来创建非池化的 ByteBuf 实例。

|名称 | 描述|
|-|-|
|buffer() / buffer(int) / buffer(int, int) |  Returns an unpooled ByteBuf with heap-based storage|
|-|-|
|directBuffer() / directBuffer(int) / directBuffer(int, int) | Returns an unpooled ByteBuf with direct storage|
|-|-|
|wrappedBuffer() | Returns a ByteBuf, which wraps the given data.|
|-|-|
|copiedBuffer() | Returns a ByteBuf, which copies the given data|

```
Unpooled.copiedBuffer("Netty rocks!",
        CharsetUtil.UTF_8)
```

* ByteBufUtil

ByteBufUtil 静态辅助方法来操作 ByteBuf，因为这个 API 是通用的，与使用池无关，这些方法已经在外面的分配类实现。

hexDump() 方法，这个方法返回指定 ByteBuf 中可读字节的十六进制字符串，可以用于调试程序时打印 ByteBuf 的内容。

### 1.4.6 Netty引用计数器
在Netty 4中为 ByteBuf 和 ByteBufHolder（两者都实现了 ReferenceCounted 接口）引入了引用计数器。

```java
Channel channel = ...;
ByteBufAllocator allocator = channel.alloc(); //1从 channel 获取 ByteBufAllocator
....
ByteBuf buffer = allocator.directBuffer(); //2从 ByteBufAllocator 分配一个 ByteBuf
assert buffer.refCnt() == 1; //3检查引用计数器是否是 1
...

```



```java
ByteBuf buffer = ...;
boolean released = buffer.release(); //1  release（）将会递减对象引用的数目。当这个引用计数达到0时，对象已被释放，并且该方法返回 true。
...
```

如果尝试访问已经释放的对象，将会抛出 IllegalReferenceCountException 异常。

需要注意的是一个特定的类可以定义自己独特的方式其释放计数的“规则”。 例如，release() 可以将引用计数器直接计为 0 而不管当前引用的对象数目。

## 1.5 ChannelHandler和ChannelPipeline
### 1.5.1  Channel 生命周期

 Channel 的四个状态

|状态 | 描述|
|-|-|
|channelUnregistered | channel已创建但未注册到一个 EventLoop.|
|-|-|
|channelRegistered |  channel 注册到一个 EventLoop.|
|-|-|
|channelActive  | channel 变为活跃状态(连接到了远程主机)，现在可以接收和发送数据了|
|-|-|
|channelInactive | channel 处于非活跃状态，没有连接到远程主机|

<img src="/images/wiki/Netty/ChannelStateModel.jpg" width="700" alt="Channel的四个状态" />
### 1.5.2 ChannelHandler 生命周期

|类型 | 描述|
|-|-|
|handlerAdded  |  当 ChannelHandler 添加到 ChannelPipeline 调用|
|-|-|
|handlerRemoved   | 当 ChannelHandler 从 ChannelPipeline 移除时调用|
|-|-|
|exceptionCaught | 当 ChannelPipeline 执行抛出异常时调用|

### 1.5.3 ChannelHandler 子接口

ChannelInboundHandler - 处理进站数据和所有状态更改事件

ChannelOutboundHandler - 处理出站数据，允许拦截各种操作

*ChannelHandler 适配器*

*Netty 提供了一个简单的 ChannelHandler 框架实现，给所有声明方法签名。这个类 ChannelHandlerAdapter 的方法,主要推送事件 到 pipeline 下个 ChannelHandler 直到 pipeline 的结束。这个类 也作为 ChannelInboundHandlerAdapter 和ChannelOutboundHandlerAdapter 的基础。所有三个适配器类的目的是作为自己的实现的起点;您可以扩展它们,覆盖你需要自定义的方法。*

### 1.5.4 ChannelInboundHandler

|类型 | 描述|
|-|-|
|channelRegistered |  Invoked when a Channel is registered to its EventLoop and is able to handle I/O.|
|-|-|
|channelUnregistered | Invoked when a Channel is deregistered from its EventLoop and cannot handle any I/O.|
|-|-|
|channelActive |  Invoked when a Channel is active; the Channel is connected/bound and ready.|
|-|-|
|channelInactive | Invoked when a Channel leaves active state and is no longer connected to its remote peer.|
|-|-|
|channelReadComplete | Invoked when a read operation on the Channel has completed.|
|-|-|
|channelRead | Invoked if data are read from the Channel.|
|-|-|
|channelWritabilityChanged |  Invoked when the writability state of the Channel changes. The user can ensure writes are not done too fast (with risk of an 
OutOfMemoryError) or can resume writes when the Channel becomes writable again.Channel.isWritable() can be used to detect the actual writability of the channel. The threshold for writability can be set via Channel.config().setWriteHighWaterMark() and Channel.config().setWriteLowWaterMark().|
|-|-|
|userEventTriggered(...) | Invoked when a user calls Channel.fireUserEventTriggered(...) to pass a pojo through the ChannelPipeline. This can be used to pass user specific events through the ChannelPipeline and so allow handling those events.|


ChannelInboundHandler 实现覆盖了 channelRead() 方法处理进来的数据用来响应释放资源。Netty 在 ByteBuf 上使用了资源池，所以当执行释放资源时可以减少内存的消耗。

```java
@ChannelHandler.Sharable
public class DiscardHandler extends ChannelInboundHandlerAdapter {        //1扩展 ChannelInboundHandlerAdapter

    @Override
    public void channelRead(ChannelHandlerContext ctx,
                                     Object msg) {
        ReferenceCountUtil.release(msg); //2ReferenceCountUtil.release() 来丢弃收到的信息
    }

}
```

由于手工管理资源会很繁琐,您可以通过使用 SimpleChannelInboundHandler 简化问题。

```java
@ChannelHandler.Sharable
public class SimpleDiscardHandler extends SimpleChannelInboundHandler<Object> {  //1扩展 SimpleChannelInboundHandler

    @Override
    public void channelRead0(ChannelHandlerContext ctx,
                                     Object msg) {
        // No need to do anything special //2不需做特别的释放资源的动作
    }

}
```


|类型 | 描述|
|-|-|
|bind   | Invoked on request to bind the Channel to a local address|
|-|-|
|connect | Invoked on request to connect the Channel to the remote peer|
|-|-|
|disconnect | Invoked on request to disconnect the Channel from the remote peer|
|-|-|
|close  | Invoked on request to close the Channel|
|-|-|
|deregister | Invoked on request to deregister the Channel from its EventLoop|
|-|-|
|read   | Invoked on request to read more data from the Channel|
|-|-|
|flush  | Invoked on request to flush queued data to the remote peer through the Channel|
|-|-|
|write |  Invoked on request to write data through the Channel to the remote peer|

几乎所有的方法都将 ChannelPromise 作为参数,一旦请求结束要通过 ChannelPipeline 转发的时候，必须通知此参数。

*ChannelPromise vs. ChannelFuture*

*ChannelPromise 是 特殊的 ChannelFuture，允许你的 ChannelPromise 及其 操作 成功或失败。所以任何时候调用例如 Channel.write(...) 一个新的 ChannelPromise将会创建并且通过 ChannelPipeline传递。这次写操作本身将会返回 ChannelFuture， 这样只允许你得到一次操作完成的通知。Netty 本身使用 ChannelPromise 作为返回的 ChannelFuture 的通知，事实上在大多数时候就是 ChannelPromise 自身（ChannelPromise 扩展了 ChannelFuture）*

### 1.5.6 资源管理

当你通过 ChannelInboundHandler.channelRead(...) 或者 ChannelOutboundHandler.write(...) 来处理数据，重要的是在处理资源时要确保资源不要泄漏。

Netty 使用引用计数器来处理池化的 ByteBuf。所以当 ByteBuf 完全处理后，要确保引用计数器被调整。

引用计数的权衡之一是用户时必须小心使用消息。当 JVM 仍在 GC(不知道有这样的消息引用计数)这个消息，以至于可能是之前获得的这个消息不会被放回池中。因此很可能,如果你不小心释放这些消息，很可能会耗尽资源。

为了让用户更加简单的找到遗漏的释放，Netty 包含了一个 ResourceLeakDetector ，将会从已分配的缓冲区 1% 作为样品来检查是否存在在应用程序泄漏。因为 1% 的抽样,开销很小。

检测等级：

|Level Description |  DISABLED|
|-|-|
|Disables |   Leak detection completely. While this even eliminates the 1 % overhead you should only do this after extensive testing.|
|-|-|
|SIMPLE | Tells if a leak was found or not. Again uses the sampling rate of 1%, the default level and a good fit for most cases.|
|-|-|
|ADVANCED  |  Tells if a leak was found and where the message was accessed, using the sampling rate of 1%.|
|-|-|
|PARANOID  |  Same as level ADVANCED with the main difference that every access is sampled. This it has a massive impact on performance. Use this only in the debugging phase.|

修改检测等级的方法：

```java
# java -Dio.netty.leakDetectionLevel=paranoid //我们就能在 ChannelInboundHandler.channelRead(...) 和 ChannelOutboundHandler.write(...) 避免泄漏。
```


处理 channelRead(...) 操作，并在消费消息(不是通过 ChannelHandlerContext.fireChannelRead(...) 来传递它到下个 ChannelInboundHandler) 时，要释放它。如下：


```java
@ChannelHandler.Sharable
public class DiscardInboundHandler extends ChannelInboundHandlerAdapter {  //1

    @Override
    public void channelRead(ChannelHandlerContext ctx,
                                     Object msg) {
        ReferenceCountUtil.release(msg); //2使用 ReferenceCountUtil.release(...) 来释放资源
    }
}

```

当你在处理写操作，并丢弃消息时，你需要释放它。如下。

```java
@ChannelHandler.Sharable 
public class DiscardOutboundHandler extends ChannelOutboundHandlerAdapter { //1
@Override
public void write(ChannelHandlerContext ctx,
                                 Object msg, ChannelPromise promise) {
    ReferenceCountUtil.release(msg);  //2使用 ReferenceCountUtil.release(...) 来释放资源
    promise.setSuccess();    //3通知 ChannelPromise 数据已经被处理

}

```

释放资源并通知 ChannelPromise。如果，ChannelPromise 没有被通知到，这可能会引发 ChannelFutureListener 不会被处理的消息通知的状况。

如果消息是被 消耗/丢弃 并不会被传入下个 ChannelPipeline 的 ChannelOutboundHandler ，调用 ReferenceCountUtil.release(message) 。一旦消息经过实际的传输，在消息被写或者 Channel 关闭时，它将会自动释放。


### 1.5.7 ChannelPipeline
每当一个新的Channel被创建了，都会建立一个新的 ChannelPipeline，并且这个新的 ChannelPipeline 还会绑定到Channel上。这个关联是永久性的；Channel 既不能附上另一个 ChannelPipeline 也不能分离当前这个。这些都由Netty负责完成,，而无需开发人员的特别处理。

**根据它的起源,一个事件将由 ChannelInboundHandler 或 ChannelOutboundHandler 处理。随后它将调用 ChannelHandlerContext 实现转发到下一个相同的超类型的处理程序。**

<img src="/images/wiki/Netty/ChannelPipeline.jpg" width="700" alt="ChannelPipeline典型布局" />

### 1.5.8 修改ChannelPipeline

|名称 | 描述|
|-|-|
|addFirst / addBefore / addAfter / addLast | 添加 ChannelHandler 到 ChannelPipeline.|
|-|-|
|Remove | 从 ChannelPipeline 移除 ChannelHandler.|
|-|-|
|Replace | 在 ChannelPipeline 替换另外一个 ChannelHandler|

```java
ChannelPipeline pipeline = null; // get reference to pipeline;
FirstHandler firstHandler = new FirstHandler(); //1
pipeline.addLast("handler1", firstHandler); //2
pipeline.addFirst("handler2", new SecondHandler()); //3
pipeline.addLast("handler3", new ThirdHandler()); //4

pipeline.remove("handler3"); //5
pipeline.remove(firstHandler); //6 

pipeline.replace("handler2", "handler4", new ForthHandler()); //6
```

1、创建一个 FirstHandler 实例

2、添加该实例作为 "handler1" 到 ChannelPipeline

3、添加 SecondHandler 实例作为 "handler2" 到 ChannelPipeline 的第一个槽，这意味着它将替换之前已经存在的 "handler1"

4、添加 ThirdHandler 实例作为"handler3" 到 ChannelPipeline 的最后一个槽

5、通过名称移除 "handler3"

6、通过引用移除 FirstHandler (因为只有一个，所以可以不用关联名字 "handler1"）.

7、将作为"handler2"的 SecondHandler 实例替换为作为 "handler4"的 FourthHandler

* ChannelPipeline访问ChannelHandler

方法如下：

|名称 | 描述|
|-|-|
|get(...)  |  Return a ChannelHandler by type or name|
|-|-|
|context(...)   | Return the ChannelHandlerContext bound to a ChannelHandler.|
|-|-|
|names() / iterator() | Return the names or of all the ChannelHander in the ChannelPipeline.|

* ChannelPipeline入站操作

ChannelPipeline API 有额外调用入站和出站操作的方法。

|名称 | 描述|
|-|-|
fireChannelRegistered  | Calls channelRegistered(ChannelHandlerContext) on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireChannelUnregistered | Calls channelUnregistered(ChannelHandlerContext) on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireChannelActive |  Calls channelActive(ChannelHandlerContext) on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireChannelInactive | Calls channelInactive(ChannelHandlerContext)on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireExceptionCaught | Calls exceptionCaught(ChannelHandlerContext, Throwable) on the next ChannelHandler in the ChannelPipeline.|
|-|-|
|fireUserEventTriggered  | Calls userEventTriggered(ChannelHandlerContext, Object) on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireChannelRead | Calls channelRead(ChannelHandlerContext, Object msg) on the next ChannelInboundHandler in the ChannelPipeline.|
|-|-|
|fireChannelReadComplete | Calls channelReadComplete(ChannelHandlerContext) on the next ChannelStateHandler in the ChannelPipeline.|

* ChannelPipeline出站操作

|名称 | 描述|
|-|-|
|bind   | Bind the Channel to a local address. This will call bind(ChannelHandlerContext, SocketAddress, ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|connect | Connect the Channel to a remote address. This will call connect(ChannelHandlerContext, SocketAddress,ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|disconnect | Disconnect the Channel. This will call disconnect(ChannelHandlerContext, ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|close |  Close the Channel. This will call close(ChannelHandlerContext,ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|deregister |  Deregister the Channel from the previously assigned EventExecutor (the EventLoop). This will call deregister(ChannelHandlerContext,ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|flush  | Flush all pending writes of the Channel. This will call flush(ChannelHandlerContext) on the next ChannelOutboundHandler in the ChannelPipeline.|
|-|-|
|write |  Write a message to the Channel. This will call write(ChannelHandlerContext, Object msg, ChannelPromise) on the next ChannelOutboundHandler in the ChannelPipeline. Note: this does not write the message to the underlying Socket, but only queues it. To write it to the Socket call flush() or writeAndFlush().|
|-|-|
|writeAndFlush  | Convenience method for calling write() then flush().|
|-|-|
|read   | Requests to read more data from the Channel. This will call read(ChannelHandlerContext) on the next ChannelOutboundHandler in the ChannelPipeline.|

## 1.6 Netty的接口ChannelHandlerContext
在ChannelHandler 添加到 ChannelPipeline 时会创建一个实例，就是接口 ChannelHandlerContext，它代表了 ChannelHandler 和ChannelPipeline 之间的关联。接口ChannelHandlerContext 主要是对通过同一个 ChannelPipeline 关联的 ChannelHandler 之间的交互进行管理

ChannelHandlerContext 中包含了有许多方法，其中一些方法也出现在 Channel 和ChannelPipeline 本身。如果您通过Channel 或ChannelPipeline 的实例来调用这些方法，他们就会在整个 pipeline中传播 。相比之下，一样的方法在 ChannelHandlerContext 的实例上调用， 就只会从当前的 ChannelHandler 开始并传播到相关管道中的下一个有处理事件能力的 ChannelHandler 。

|名称 | 描述|
|-|-|
|bind  |  Request to bind to the given SocketAddress and return a ChannelFuture.|
|-|-|
|channel | Return the Channel which is bound to this instance.|
|-|-|
|close |  Request to close the Channel and return a ChannelFuture.|
|-|-|
|connect | Request to connect to the given SocketAddress and return a ChannelFuture.|
|-|-|
|deregister | Request to deregister from the previously assigned EventExecutor and return a ChannelFuture.|
|-|-|
|disconnect |  Request to disconnect from the remote peer and return a ChannelFuture.|
|-|-|
|executor   | Return the EventExecutor that dispatches events.
|-|-|
|fireChannelActive |  A Channel is active (connected).|
|-|-|
|fireChannelInactive | A Channel is inactive (closed).|
|-|-|
|fireChannelRead | A Channel received a message.|
|-|-|
|fireChannelReadComplete | Triggers a channelWritabilityChanged event to the nextChannelInboundHandler. 
|-|-|
|handler | Returns the ChannelHandler bound to this instance. |
|-|-|
|isRemoved | Returns true if the associated ChannelHandler was removed from the ChannelPipeline. |
|-|-|
|name | Returns the unique name of this instance. |
|-|-|
|pipeline | Returns the associated ChannelPipeline. |
|-|-|
|read | Request to read data from the Channel into the first inbound buffer. Triggers a channelRead event if successful and notifies the handler of channelReadComplete. |
|-|-|
|write | Request to write a message via this instance through the pipeline.|

<img src="/images/wiki/Netty/ChannelPipeline_Channel_ChannelHandler_ChannelHandlerContext.jpg" width="700" alt="ChannelPipeline, Channel, ChannelHandler 和 ChannelHandlerContext 的关系" />

1、Channel 绑定到 ChannelPipeline

2、ChannelPipeline 绑定到 包含 ChannelHandler 的 Channel

3、ChannelHandler

4、当添加 ChannelHandler 到 ChannelPipeline 时，ChannelHandlerContext 被创建

从 ChannelHandlerContext 获取到 Channel 的引用，通过调用 Channel 上的 write() 方法来触发一个 写事件到通过管道的的流中。如下code1。

```java
//code1
ChannelHandlerContext ctx = context;
Channel channel = ctx.channel();  //1得到与 ChannelHandlerContext 关联的 Channel 的引用
channel.write(Unpooled.copiedBuffer("Netty in Action",
        CharsetUtil.UTF_8));  //2通过 Channel 写缓存
```

 从 ChannelHandlerContext 获取到 ChannelPipeline。如下。

```java
//code2
ChannelHandlerContext ctx = context;
ChannelPipeline pipeline = ctx.pipeline(); //1得到与 ChannelHandlerContext 关联的 ChannelPipeline 的引用
pipeline.write(Unpooled.copiedBuffer("Netty in Action", CharsetUtil.UTF_8));  //2通过 ChannelPipeline 写缓冲区
```

**Channel 或者 ChannelPipeline 上调用write() 都会把事件在整个管道传播；在 ChannelHandler 级别上，从一个处理程序转到下一个要通过在 ChannelHandlerContext 调用方法实现**

<img src="/images/wiki/Netty/ChannelhandlercontextWork.jpg" width="700" alt="Context将信息传递到下一个channel" />

1、事件传递给 ChannelPipeline 的第一个 ChannelHandler

2、ChannelHandler 通过关联的 ChannelHandlerContext 传递事件给 ChannelPipeline 中的 下一个

3、ChannelHandler 通过关联的 ChannelHandlerContext 传递事件给 ChannelPipeline 中的 下一个


**实现绕过ChannelPipeline前面的ChannelHandler，直接进入后面的ChannelHandler**

```java
ChannelHandlerContext ctx = context;   //可以通过ChannelPipeline接口的context()获取特定ChannelHandler的context，也可以在handlerAdded()进入的时候保存
ctx.write(Unpooled.copiedBuffer("Netty in Action",CharsetUtil.UTF_8));
```

示意图如下：

<img src="/images/wiki/Netty/ChannelPipelineSkip.jpg" width="700" alt="ChannelPipline跳过前面的ChannelHandler" />

1、ChannelHandlerContext 方法调用

2、事件发送到了下一个 ChannelHandler

3、经过最后一个ChannelHandler后，事件从 ChannelPipeline 移除

```java
public class WriteHandler extends ChannelHandlerAdapter {

    private ChannelHandlerContext ctx;

    @Override
    public void handlerAdded(ChannelHandlerContext ctx) {
        this.ctx = ctx;        //1存储 ChannelHandlerContext 的引用供以后使用
    }

    public void send(String msg) {
        ctx.writeAndFlush(msg);  //2使用之前存储的 ChannelHandlerContext 来发送消息
    }
}

```

**因为 ChannelHandler 可以属于多个 ChannelPipeline ,它可以绑定多个 ChannelHandlerContext 实例。然而,ChannelHandler 用于这种用法必须添加 @Sharable 注解。否则,试图将它添加到多个 ChannelPipeline 将引发一个异常。此外,它必须既是线程安全的又能安全地使用多个同时的通道(比如,连接)。下面的SharableHandler并不持有任何状态（对比下面）。**

```java
@ChannelHandler.Sharable            //1添加 @Sharable 注解
public class SharableHandler extends ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        System.out.println("channel read message " + msg);
        ctx.fireChannelRead(msg);  //2日志方法调用， 并传递到下一个 ChannelHandler
    }
}
```


下面代码的问题是它持有状态:一个实例变量保持了方法调用的计数。将这个类的一个实例添加到 ChannelPipeline 并发访问通道时很可能产生错误。(当然,这个简单的例子中可以通过在 channelRead() 上添加 synchronized 来纠正 )

```java
@ChannelHandler.Sharable  //1
public class NotSharableHandler extends ChannelInboundHandlerAdapter {
    private int count;

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        count++;  //2count 字段递增

        System.out.println("inboundBufferUpdated(...) called the "
        + count + " time");  //3日志方法调用， 并专递到下一个 ChannelHandler
        ctx.fireChannelRead(msg);
    }

}

```

# 2、Netty使用
## 2.1 echo服务器
echo服务器需要：

* 一个服务器handler

这个组件实现了服务器的业务逻辑，决定了连接创建后和接收到信息后该如何处理

* Bootstrapping

这个是配置服务器的启动代码。最少需要设置服务器绑定的端口，用来监听连接请求。

**通过ChannelHandler来实现服务器的逻辑**

1、handler

```java
@Sharable                                        //@Sharable 标识这类的实例之间可以在 channel 里面共享
public class EchoServerHandler extends
        ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx,Object msg) {     //每个信息入站都会调用
        ByteBuf in = (ByteBuf) msg;
        System.out.println("Server received: " + in.toString(CharsetUtil.UTF_8));//日志消息输出到控制台
        ctx.write(in);         //将所接收的消息返回给发送者。注意，这还没有冲刷数据
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {   //通知处理器最后的 channelread() 是当前批处理中的最后一条消息时调用
        ctx.writeAndFlush(Unpooled.EMPTY_BUFFER)        //冲刷所有待审消息到远程节点。关闭通道后，操作完成
        .addListener(ChannelFutureListener.CLOSE);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {    //读操作时捕获到异常时调用
        cause.printStackTrace();                //打印异常堆栈跟踪
        ctx.close();                            //关闭通道
    }
}
```

如果异常没有被捕获，会发生什么？

每个 Channel 都有一个关联的 ChannelPipeline，它代表了 ChannelHandler 实例的链。适配器处理的实现只是将一个处理方法调用转发到链中的下一个处理器。因此，如果一个 Netty 应用程序不覆盖exceptionCaught ，那么这些错误将最终到达 ChannelPipeline，并且结束警告将被记录。出于这个原因，你应该提供至少一个实现exceptionCaught 的 ChannelHandler。

关键两点：

ChannelHandler 是给不同类型的事件调用

应用程序实现或扩展 ChannelHandler 挂接到事件生命周期和 提供自定义应用逻辑。

2、引导服务器

监听和接收进来的连接请求

配置 Channel 来通知一个关于入站消息的 EchoServerHandler 实例

```java
public class EchoServer {

    private final int port;

    public EchoServer(int port) {
        this.port = port;
    }
        public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println(
                    "Usage: " + EchoServer.class.getSimpleName() +
                    " <port>");
            return;
        }
        int port = Integer.parseInt(args[0]);        //1  设置端口值（抛出一个 NumberFormatException 如果该端口参数的格式不正确）
        new EchoServer(port).start();                //2  呼叫服务器的 start() 方法
    }

    public void start() throws Exception {
        NioEventLoopGroup group = new NioEventLoopGroup(); //3 创建 EventLoopGroup接受和处理新连接
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(group)                                //4  建 ServerBootstrap
             .channel(NioServerSocketChannel.class)        //5  指定使用 NIO 的传输 Channel为信道类型,channel方法内部，只是初始化了一个用于生产指定channel类型的工厂实例。
             .localAddress(new InetSocketAddress(port))    //6  置 socket 地址使用所选的端口
             .childHandler(new ChannelInitializer<SocketChannel>() { //7  添加 EchoServerHandler 到 Channel 的 ChannelPipeline
                 @Override
                 public void initChannel(SocketChannel ch) 
                     throws Exception {
                     ch.pipeline().addLast(
                             new EchoServerHandler());
                 }
             });

            ChannelFuture f = b.bind().sync();            //8  绑定的服务器;sync 等待服务器关闭
            System.out.println(EchoServer.class.getName() + " started and listen on " + f.channel().localAddress());
            f.channel().closeFuture().sync();            //9  关闭 channel 和 块，直到它被关闭
        } finally {
            group.shutdownGracefully().sync();            //10  关机的 EventLoopGroup，释放所有资源。
        }
    }

}

```

第7步，在这里我们使用一个特殊的类，ChannelInitializer 。当一个新的连接被接受，一个新的子 Channel 将被创建， ChannelInitializer 会添加我们EchoServerHandler 的实例到 Channel 的 ChannelPipeline。正如我们如前所述，如果有入站信息，这个处理器将被通知。

.sync()的原因：当前线程阻塞。

总结：

echo服务器包括handler处理和引导服务器

引导服务器的步骤(1-5)：

1.创建 ServerBootstrap 实例来引导服务器并随后绑定

2.创建并分配一个 NioEventLoopGroup 实例来处理事件的处理，如接受新的连接和读/写数据。

3.指定本地 InetSocketAddress 给服务器绑定

4.通过 EchoServerHandler 实例给每一个新的 Channel 初始化

5.最后调用 ServerBootstrap.bind() 绑定服务器

## 2.2 echo客户端

```java
@Sharable                                //1
public class EchoClientHandler extends
        SimpleChannelInboundHandler<ByteBuf> {

    @Override
    public void channelActive(ChannelHandlerContext ctx) {
        ctx.writeAndFlush(Unpooled.copiedBuffer("Netty rocks!", //2
        CharsetUtil.UTF_8));
    }

    @Override
    public void channelRead0(ChannelHandlerContext ctx,
        ByteBuf in) {
        System.out.println("Client received: " + in.toString(CharsetUtil.UTF_8));    //3
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx,
        Throwable cause) {                    //4
        cause.printStackTrace();
        ctx.close();
    }
}

```

channelRead0()：这种方法会在接收到数据时被调用。注意，由服务器所发送的消息可以以块的形式被接收。即，当服务器发送 5 个字节是不是保证所有的 5 个字节会立刻收到 - 即使是只有 5 个字节，channelRead0() 方法可被调用两次，第一次用一个ByteBuf（Netty的字节容器）装载3个字节和第二次一个 ByteBuf 装载 2 个字节。唯一要保证的是，该字节将按照它们发送的顺序分别被接收。 

**SimpleChannelInboundHandler vs. ChannelInboundHandler**

何时用这两个要看具体业务的需要。在客户端，当 channelRead0() 完成，我们已经拿到的入站的信息。**当方法返回时，SimpleChannelInboundHandler 会小心的释放对 ByteBuf（保存信息） 的引用**(在channelRead0()中，不需要程序员自行调用释放资源的函数)。而在 EchoServerHandler,我们需要将入站的信息返回给发送者，由于 write() 是异步的，在 channelRead() 返回时，可能还没有完成。所以，我们使用 ChannelInboundHandlerAdapter,无需释放信息。最后在 channelReadComplete() 我们调用 ctxWriteAndFlush() 来释放信息。

```java
public class EchoClient {

    private final String host;
    private final int port;

    public EchoClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void start() throws Exception {
        EventLoopGroup group = new NioEventLoopGroup();
        try {
            Bootstrap b = new Bootstrap();                //1
            b.group(group)                                //2
             .channel(NioSocketChannel.class)            //3
             .remoteAddress(new InetSocketAddress(host, port))    //4
             .handler(new ChannelInitializer<SocketChannel>() {    //5
                 @Override
                 public void initChannel(SocketChannel ch) 
                     throws Exception {
                     ch.pipeline().addLast(
                             new EchoClientHandler());
                 }
             });

            ChannelFuture f = b.connect().sync();        //6

            f.channel().closeFuture().sync();            //7
        } finally {
            group.shutdownGracefully().sync();            //8
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println(
                    "Usage: " + EchoClient.class.getSimpleName() +
                    " <host> <port>");
            return;
        }

        final String host = args[0];
        final int port = Integer.parseInt(args[1]);

        new EchoClient(host, port).start();
    }
}

```

1.创建 Bootstrap

2.指定 EventLoopGroup 来处理客户端事件。由于我们使用 NIO 传输，所以用到了 NioEventLoopGroup 的实现

3.使用的 channel 类型是一个用于 NIO 传输

4.设置服务器的 InetSocketAddress

5.当建立一个连接和一个新的通道时，创建添加到 EchoClientHandler 实例 到 channel pipeline

6.连接到远程，等待连接完成

7.阻塞直到 Channel 关闭

8.调用 shutdownGracefully() 来关闭线程池和释放所有资源

与以前一样，在这里使用了 NIO 传输。请注意，您可以在 客户端和服务器 使用不同的传输 ，例如 NIO 在服务器端和 OIO 客户端。在第四章中，我们将研究一些具体的因素和情况，这将导致 您可以选择一种传输，而不是另一种。

# 3、Netty使用问题
## 3.1 内存泄露
### 3.1.1 消息读取时的内存泄露
* **问题描述**

Netty 的消息读取并不存在消息队列，但是如果消息解码策略不当，则可能会发生内存泄漏，主要有如下几点：

1.畸形码流攻击：如果客户端按照协议规范，将消息长度值故意伪造的非常大，可能会导致接收方内存溢出。

2.代码 BUG：错误的将消息长度字段设置或者编码成一个非常大的值，可能会导致对方内存溢出。

3.高并发场景：单个消息长度比较大，例如几十 M 的小视频，同时并发接入的客户端过多，会导致所有 Channel 持有的消息接收 ByteBuf 内存总和达到上限，发生 OOM。

* **问题解决**

无论采用哪种解码器实现，都对消息的最大长度做限制，当超过限制之后，抛出解码失败异常，用户可以选择忽略当前已经读取的消息，或者直接关闭链接。


```java
//以基于分隔符的解码器为例
//指定一个比较合理的消息最大长度限制
public DelimiterBasedFrameDecoder(
	int maxFrameLength, boolean stripDelimiter, ByteBuf delimiter) {
		this(maxFrameLength, stripDelimiter, true, delimiter);
}
```

需要根据单个 Netty 服务端可以支持的最大客户端并发连接数、消息的最大长度限制以及当前 JVM 配置的最大内存进行计算，并结合业务场景，合理设置 maxFrameLength 的取值。

### 3.1.2 ChannelHandler的并发执行
* **问题提出**
Netty 的 ChannelHandler 支持串行和异步并发执行两种策略，在将 ChannelHandler 加入到 ChannelPipeline 时，如果指定了 EventExecutorGroup，则 ChannelHandler 将由 EventExecutorGroup 中的 EventExecutor 异步执行。这样的好处是可以实现 Netty I/O 线程与业务 ChannelHandler 逻辑执行的分离，防止 ChannelHandler 中耗时业务逻辑的执行阻塞 I/O 线程。

<img src="/images/wiki/Netty/NettyNIO.webp" width="600" alt="Netty异步执行" />

如果业务 ChannelHandler 中执行的业务逻辑耗时较长，消息的读取速度又比较快，很容易发生消息在 EventExecutor 中积压的问题，如果创建 EventExecutor 时没有通过 io.netty.eventexecutor.maxPendingTasks 参数指定积压的最大消息个数，则默认取值为 0x7fffffff，长时间的积压将导致内存溢出，相关代码如下所示（异步执行 ChannelHandler，将消息封装成 Task 加入到 taskQueue 中）：

```java
public void execute(Runnable task) {
	if (task == null) {
		throw new NullPointerException("task");
	}
	boolean inEventLoop = inEventLoop();
	if (inEventLoop) {
		addTask(task);
	} else {
		startThread();
		addTask(task);
	}
	if (isShutdown() && removeTask(task)) {
		reject();
	}
}
```

* **问题解决**

对 EventExecutor 中任务队列的容量做限制，可以通过 io.netty.eventexecutor.maxPendingTasks 参数做全局设置，也可以通过构造方法传参设置。结合 EventExecutorGroup 中 EventExecutor 的个数来计算 taskQueue 的个数，根据 taskQueue \* N \* 任务队列平均大小 \* maxPendingTasks < 系数K（0 < K < 1）\* 总内存的公式来进行计算和评估。

### 3.1.3 高并发引发的消息发送队列积压
* **问题提出**

为了防止高并发场景下，由于对方处理慢导致自身消息积压，除了服务端做流控之外，客户端也需要做并发保护，防止自身发生消息积压。

* **问题解决**

利用 Netty 提供的高低水位机制，可以实现客户端更精准的流控。

```java
ChannelConfig setWriteBufferHighWaterMark(int writeBufferHighWaterMark);
```

当发送队列待发送的字节数组达到高水位上限时，对应的 Channel 就变为不可写状态。由于高水位并不影响业务线程调用 write 方法并把消息加入到待发送队列中，因此，必须要在消息发送时对 Channel 的状态进行判断：当到达高水位时，Channel 的状态被设置为不可写，通过对 Channel 的可写状态进行判断来决定是否发送消息。

具体方法：

```java
public void channelActive(final ChannelHandlerContext ctx) {
	//设置水位
	ctx.channel().config().setWriteBufferHighWaterMark(10 \* 1024 * 1024);
	loadRunner = new Runnable() {
		@Override
		public void run() {
			try {
				TimeUnit.SECONDS.sleep(30);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			ByteBuf msg = null;
			while (true) {
				//检查这个通道是否到达水位，即是否可写
				if (ctx.channel().isWritable()) {
					msg = Unpooled.wrappedBuffer("Netty OOM Example".getBytes());
					ctx.writeAndFlush(msg);
				} else {
					LOG.warning("The write queue is busy : " + ctx.channel().unsafe().outboundBuffer().nioBufferSize());
				}
			}//endof while
		}//endof run
	};//endof runnable
	new Thread(loadRunner, "LoadRunner-Thread").start();
}
```

我的代码：

```java
//通道开启时设置水位
public void channelActive(ChannelHandlerContext ctx) throws Exception {
	//设置消息队列流量水位，不能太多，否则会造成积压
	ctx.channel().config().setWriteBufferHighWaterMark(10 * 1024 * 1024);//10MB
	System.out.println("PC "+ctx.channel().remoteAddress()+" connected!");
	//通道数太多了
	if(RunPcServer.getChMap().size()>ChannelAttributes.MAX_CHANNEL_NUM) {
		TCP_ServerHandler4PC.ctxCloseFuture(ctx);
		return;
	}
	//加入该通道
	RunPcServer.getChMap().put(ctx.channel().remoteAddress().toString(), new ChannelAttributes(ctx));
	String salt = RunPcServer.getChMap().get(ctx.channel().remoteAddress().toString()).getSalt();
	TCP_ServerHandler4PC.writeFlushFuture(ctx,"RandStr"+TCP_ServerHandler4PC.SEG_CMD_DONE_SIGNAL+salt);	System.out.println("RandStr"+TCP_ServerHandler4PC.SEG_CMD_DONE_SIGNAL+salt);//打印salt
    ctx.fireChannelActive();
}//end of channelActive

//封装writeAndFlush，实现判断channel是否可写
public static void writeFlushFuture(ChannelHandlerContext ctx,ByteBuf msg) {
	//如果这个channel没有到达水位的话，还可以写入
	//水位在active时设置
	if(ctx.channel().isWritable()) {
	ChannelFuture future = ctx.writeAndFlush(msg);
    	//发送完毕会返回一个信息
    	future.addListener(new ChannelFutureListener(){
			@Override
			public void operationComplete(ChannelFuture f) {
				if(!f.isSuccess()) {
					f.cause().printStackTrace();
				}
			}
		});
	}
}
```

### 3.1.4  其他原因导致消息发送队列积压
* **问题提出**

1.网络瓶颈，发送速率超过网络链接处理能力时，会导致发送队列积压。

2.对端读取速度小于己方发送速度，导致自身 TCP 发送缓冲区满，频繁发生 write 0 字节时，待发送消息会在 Netty 发送队列排队。

### 3.1.4 内存泄漏的查询

Netty的内存泄漏日志级别包括DISABLE, SIMPLE(默认),ADVANCED, PARANOID，可以在VM参数设置

```
-Dio.netty.leakDetectionLevel=ADVANCED
```

进而更加详细的追踪泄漏信息。

## 3.2 ByteBuf 的释放策略
有一种说法认为 Netty 框架分配的 ByteBuf 框架会自动释放，业务不需要释放；业务创建的 ByteBuf 则需要自己释放，Netty 框架不会释放。

事实上，这种观点是错误的，即便 ```ByteBuf ```是 Netty 创建的，如果使用不当仍然会发生内存泄漏。在实际项目中如何更好的管理 ```ByteBuf```，下面我们分四种场景进行说明——内存池（```PooledDirectByteBuf``` 和``` PooledHeapByteBuf```）、请求（外界发消息到本机）；非内存池（```Unpooled...```）、请求；内存池、响应（本机发送消息）；非内存池、响应

### 3.2.1 基于*内存池*的*请求* ByteBuf
* **问题提出**
主要包括 ```PooledDirectByteBuf``` 和``` PooledHeapByteBuf```，它由 Netty 的 ```NioEventLoop ```线程在处理 Channel 的读操作时分配，需要在业务 ```ChannelInboundHandler ```处理完请求消息之后释放（通常是解码之后）。

* **问题解决**

*策略1*

```ChannelInboundHandler ```继承自 ```SimpleChannelInboundHandler```，实现它的抽象方法 ```channelRead0(ChannelHandlerContext ctx, I msg)```，ByteBuf 的释放业务不用关心，由 ```SimpleChannelInboundHandler ```负责释放，相关代码如下所示（```SimpleChannelInboundHandler```）

```java
@Override
public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
	boolean release = true;
	try {
		if (acceptInboundMessage(msg)) {
		I imsg = (I) msg;
		channelRead0(ctx, imsg);
		} else {
			release = false;
			ctx.fireChannelRead(msg);
		}
	} finally {
		if (autoRelease && release) {
			ReferenceCountUtil.release(msg);
		}
	}
}
```

如果当前业务 ```ChannelInboundHandler ```需要执行，则调用完``` channelRead0``` 之后执行 ```ReferenceCountUtil.release(msg) ```释放当前请求消息。如果没有匹配上需要继续执行后续的 ```ChannelInboundHandler```，则不释放当前请求消息，调用 ```ctx.fireChannelRead(msg) ```驱动 ```ChannelPipeline ```继续执行。

```java
//继承自 SimpleChannelInboundHandler，即便业务不释放请求 ByteBuf 对象，依然不会发生内存泄漏，相关示例代码如下所示：
public class RouterServerHandlerV2 extends SimpleChannelInboundHandler<ByteBuf> {
// 代码省略...
	@Override
	public void channelRead0(ChannelHandlerContext ctx, ByteBuf msg) {
		byte [] body = new byte[msg.readableBytes()];
		executorService.execute(()->
		{
		// 解析请求消息，做路由转发，代码省略...
		// 转发成功，返回响应给客户端
		ByteBuf respMsg = allocator.heapBuffer(body.length);
		respMsg.writeBytes(body);// 作为示例，简化处理，将请求返回
		ctx.writeAndFlush(respMsg);
	});
}
```

*策略2*

在业务 ```ChannelInboundHandler ```中调用``` ctx.fireChannelRead(msg) ```方法，让请求消息继续向后执行，直到调用到 ```DefaultChannelPipeline ```的内部类``` TailContext```，由它来负责释放请求消息，代码如下所示（```TailContext```）

```java
protected void onUnhandledInboundMessage(Object msg) {
	try {
		logger.debug(
			"Discarded inbound message {} that reached at the tail of the pipeline. " +
			"Please check your pipeline configuration.", msg);
		} finally {
			ReferenceCountUtil.release(msg);
	}
}
```

### 3.2.2 基于*非内存池*的*请求* ByteBuf
如果业务使用非内存池模式覆盖 Netty 默认的内存池模式创建请求 ```ByteBuf```，也需要按照内存池的方式去释放内存。例如在Netty初始化一个通过如下代码修改内存申请策略为```Unpooled```：

```java
// 代码省略... 
.childHandler(new ChannelInitializer<SocketChannel>() {
    @Override
    public void initChannel(SocketChannel ch) throws Exception {
        ChannelPipeline p = ch.pipeline(); 								         	               ch.config().setAllocator(UnpooledByteBufAllocator.DEFAULT);
        p.addLast(new RouterServerHandler());
    }
    }); 
}
```

### 3.2.3 基于*内存池*的*响应* ByteBuf
只要调用了``` writeAndFlush``` 或者 ```flush```方法，在消息发送完成之后都会由 Netty 框架进行内存释放，业务不需要主动释放内存。

(1)如果是堆内存（```PooledHeapByteBuf```），则将 ```HeapByteBuffer``` 转换成 ```DirectByteBuffer```，并释放 ```PooledHeapByteBuf``` 到内存池

(2)如果是 ```DirectByteBuffer```，则不需要转换，当消息发送完成之后，由 ```ChannelOutboundBuffer``` 的``` remove() ```负责释放。

### 3.2.4 基于*非内存池*的*响应* ByteBuf
无论是基于内存池还是非内存池分配的 ```ByteBuf```，如果是堆内存，则将堆内存转换成堆外内存，然后释放 ```HeapByteBuffer```，待消息发送完成之后，再释放转换后的 ```DirectByteBuf```；如果是 ```DirectByteBuffer```，则无需转换，待消息发送完成之后释放。因此对于需要发送的响应 ```ByteBuf```，由业务创建，但是不需要业务来释放。

## 3.3 Netty 服务端高并发保护

### 3.3.1 高并发场景下的 OOM (Out-Of-Memory)问题

在 RPC 调用时，如果客户端并发连接数过多，服务端又没有针对并发连接数的流控机制，一旦服务端处理慢，就很容易发生批量超时和断连重连问题。

以 Netty HTTPS 服务端为例，典型的业务组网示例如下所示：

<img src="/images/wiki/Netty/NettyHTTPSRPC.webp" width="700" alt="Netty 的HTTPS业务组" />

* **OOM过程**

客户端采用 HTTP 连接池的方式与服务端进行 RPC 调用，单个客户端连接池上限为 200，客户端部署了 30 个实例，而服务端只部署了 3 个实例。在业务高峰期，每个服务端需要处理 6000 个 HTTP 连接，当服务端时延增大之后，会导致客户端批量超时，超时之后客户端会关闭连接重新发起 connect 操作，在某个瞬间，几千个 HTTPS 连接同时发起 SSL 握手操作，由于服务端此时也处于高负荷运行状态，就会导致部分连接 SSL 握手失败或者超时，超时之后客户端会继续重连，进一步加重服务端的处理压力，最终导致服务端来不及释放客户端 close 的连接，引起 ```NioSocketChannel ```大量积压，最终 OOM。

* **解决方法**：限制一台服务器的连接数，Netty 的pipeline机制对SSL握手、链接关闭作切面拦截（```channelActive(ChannelHandlerContext ctx)```即为连接时调用的函数）。

<img src="/images/wiki/Netty/NettyConCtrl.webp" width="560" alt="Netty 的pipeline机制对SSL握手、链接关闭作切面拦截" />

**服务器流控算法**：

1.获取流控阈值。

2.从全局上下文中获取当前的并发连接数，与流控阈值对比，如果小于流控阈值，则对当前的计数器做原子自增，允许客户端连接接入。

3.如果等于或者大于流控阈值，则抛出流控异常给客户端。

4.SSL 连接关闭时，获取上下文中的并发连接数，做原子自减。

**注意点**：

1.流控的``` ChannelHandler ```声明为 ```@ChannelHandler.Sharable```，这样全局创建一个流控实例，就可以在所有的 SSL 连接中共享。

2.通过 ```userEventTriggered ```方法拦截 ```SslHandshakeCompletionEvent ```和 ```SslCloseCompletionEvent ```事件，在 SSL 握手成功和 SSL 连接关闭时更新流控计数器。

3.流控并不是单针对 ESTABLISHED 状态的 HTTP 连接，而是针对所有状态的连接，因为客户端关闭连接，并不意味着服务端也同时关闭了连接，只有 ```SslCloseCompletionEvent ```事件触发时，服务端才真正的关闭了 ```NioSocketChannel```，GC 才会回收连接关联的内存。

4.流控 ```ChannelHandler ```会被多个 ```NioEventLoop ```线程调用，因此对于相关的计数器更新等操作，要保证并发安全性，避免使用全局锁，可以通过原子类等提升性能。



# X.参考文献

[1.Netty防止内存泄漏措施](https://mp.weixin.qq.com/s?__biz=MjM5MDE0Mjc4MA==&mid=2651013961&idx=2&sn=91b202f2df224e2b3ddc652b5b0c69cb&chksm=bdbebb1a8ac9320c3249217d01d927f7fe003560f110b97079767da114a9eadd367e963f55d9&mpshare=1&scene=1&srcid=&key=0cc0a803134ec623278dd87e0df5faffcd6813a41434e7eba02eaed37a08d419484bcf0c4f780450ff26bd2cb2c350388e149b82a17dc9521cc8185e6471be4c996a81aedd14793648062407cfc773be&ascene=1&uin=Mjk2MTQyNjcwNA%3D%3D&devicetype=Windows+10&version=62060728&lang=zh_CN&pass_ticket=tfRDLvAV4pVmH9C40TehCveAy85%2F%2BHx5b2StWrTjEhg8NvwsIGyCvzZT3JMW6Sz3 'Netty防止内存泄露的措施')



