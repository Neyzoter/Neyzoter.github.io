---
layout: wiki
title: React
categories: Front
description: React学习笔记
keywords: 前端, React
---

# 1、简介

React（React.js或者ReactJS）是一个为数据提供渲染为HTML视图的开源JavaScript库。

**特点**

1. 声明式设计：React采⽤声明范式，可以轻松描述应⽤。
2. ⾼效：React通过对DOM的模拟，最⼤限度地减少与DOM的交互。
3. 灵活：React可以与已知的库或框架很好地配合。
4. JSX ：JSX 是 JavaScript 语法的扩展，即为JavaScript和XML的混合体。React 开发不⼀定使⽤
    JSX ，但建议使⽤它。
5. 组件：通过 React 构建组件，使得代码更加容易得到复⽤，能够很好的应⽤在⼤项⽬的开发中。
6. 单向响应的数据流：React 实现了单向响应的数据流，从⽽减少了重复代码，这也是它为什么⽐传统
    数据绑定更简单。

**核心功能**

*1.虚拟DOM*

虚拟DOM是⼀种对于HTML DOM节点的抽象描述，是⼀个JavaScript实现的数据结构⽽⾮真正渲染在浏览器的DOM，它不需要浏览器的DOM API⽀持，在Node.js中也可以使⽤。它和DOM的⼀⼤区别就是它采⽤了更⾼效的渲染⽅式，组件的DOM结构映射到Virtual DOM上，当需要重新渲染组件时，React在Virtual DOM上实现了⼀个Diff算法，通过这个算法寻找需要变更的节点，再把⾥⾯的修改更新到实际需要修改的DOM节点上，这样就避免了整个渲染DOM带来的巨⼤成本，从⽽也提升了⽹⻚的运⾏性能。

*2.JSX(JS+XML)*

react定义的⼀种类似于XML的JS扩展语法: XML+JS。 js中直接可以套标签, 但标签要套js需要放在{}中，JSX ⽤来创建react虚拟DOM对象，在{}括号中的元素会⾃动当做JavaScript执⾏，⽽外部的XML（HTML内容）可以给Virtual DOM执⾏。JSX语⾔的程序是不能被浏览器识别并直接运⾏的，需要转化成为浏览器可以识别的HTML + JavaScript + CSS内容，React提供Babel.js来进⾏处理，⽽开发者⽆需考虑和感知。

*3.Component*

组件是React的核⼼思想。React是⾯向组件编程的(组件化编码开发)，⼀切都是基于组件的。可以**通过定义⼀个组件，然后在其他的组件中，可以像HTML标签⼀样引⽤它**。说得通俗点，组件其实就是⾃定义的类HTML标签，可以通过的⽅式进⾏组合，将庞⼤的前端项⽬功能分散成若⼲个⼩的组件进⾏组装，增强各组件的可移植性和复⽤开发效率。每个组件都有⾃⼰的状态、UI和⽅法，并在组件内部进⾏管理和维护，当组件的状态被外界变更，则⾃动重新渲染整个组件⽽⽆需开发者关⼼。

```react
import React, { Component } from 'react';
import { render } from 'react-dom';
class HelloMessage extends Component {
    render() {
		return <div>Hello {this.props.name}</div>;
	}
}
// 加载组件到 DOM 元素 mountNode
render(<HelloMessage name="John" />, mountNode);
```

react为Component提供了API和⽣命周期的接⼝，其中API可以直接调⽤

| 组件API      | 功能             |
| ------------ | ---------------- |
| setState     | 设置状态         |
| replaceState | 替换状态         |
| replaceProps | 替换属性         |
| forceUpdate  | 强制更新         |
| findDOMNode  | 获取DOM节点      |
| isMounted    | 判断组件挂载状态 |

*4.组件生命周期*

不同于组件API，⽣命周期函数需要开发者在组件内部实现

| 组件生命周期函数          | 功能                                                         |
| ------------------------- | ------------------------------------------------------------ |
| componentWillMount        | 在渲染前调⽤，常⽤在预先请求数据或执⾏复杂渲染               |
| componentDidMount         | 在第⼀次渲染后调⽤，之后组件已经⽣成了对应的DOM结构，可以通过this.getDOMNode()来进⾏访问。 |
| componentWillReceiveProps | 在组件接收新的 prop (更新后)时被调⽤。                       |
| shouldComponentUpdate     | 返回⼀个布尔值，在组件接收到新的props或者state时被调⽤，返回true则组件执⾏渲染，false为不渲染。在初始化时或者使⽤forceUpdate时不被调⽤。 |
| componentWillUpdate       | 在组件接收到新的props或者state但还没有render时被调⽤。在初始化时不会被调⽤。 |
| componentDidUpdate        | 在组件完成更新后⽴即调⽤。在初始化时不会被调⽤。             |
| componentWillUnmount      | 在组件从 DOM 中移除之前⽴刻被调⽤。                          |

```react
import React, { Component } from 'react';
import { render } from 'react-dom';
class Hello extends React.Component {
    //构造函数初始化初始组件state
    constructor(props) {
        super(props);
        this.state = {opacity: 1.0};
    }
    //第一次渲染后调用
    componentDidMount() {
        this.timer = setInterval(function () {
            var opacity = this.state.opacity;
            opacity -= .05;
            if (opacity < 0.1) {
            opacity = 1.0;
            }
            this.setState({
                opacity: opacity
            });
        }.bind(this), 100);
    }
    //render渲染Hello world
    render () {
        return (
        <div style={{opacity: this.state.opacity}}>
        Hello {this.props.name}
        </div>
        );
    }
}
ReactDOM.render(
    <Hello name="world"/>,
    document.body
);
```



# 2、React知识点



# 3、UmiJS框架

乌米，可插拔企业级react应用框架。Umi以路由为基础，支持类next.js的约定式路由（根据文件自动生成路由），比如支持路由级的按需加载，可以帮助开发者快速搭建应用而无需关心复杂的路由配置，umi是蚂蚁金服的底层前端框架。

[官方文档](https://umijs.org/zh/)

## 3.1 安装

**1.[安装Node.js](https://nodejs.org/zh-cn/)**

**2.安装yarn**

`npm i yarn tyarn -g`

**3.安装umi**

`yarn global add umi`

# 4、Ant Design框架

Ant Design of React，是专⻔⽤来开发和服务于企业级后台产品的UI框架，简单来说就是提供了⼤量的UI组件，例如输⼊框、动效、按钮、表格等等。每个UI组件都有稳定的API可进⾏调⽤，开发者只要在各组件API基础上进⾏开发，即可快速搭建⾃⼰的前端⻚⾯。

[官方网站](https://ant.design/index-cn)，官网给出了详细的API列表和参考实例。

## 4.1 安装

1、在Umi中内置了Antd的插件，在umi中完成配置即可使⽤

2、不是umi框架内：`npm install -g antd`或者`yarn add antd`

# 5、dva框架

React框架将各个模块组件化，存在不⾜在于React只⽀持单向的数据流，即⽗组件可以将数据通过⼦组件的props属性传⼊，但是⽗组件确很难获取到⼦组件的状态，并且开发中管理数据流是⼀件⾮常麻烦的事情，于是就出现了Redux这样的数据流框架，核⼼思想是创建⼀个数据状态管理库（store），所有组件的状态state都以⼀个对象树的形式储存在⼀个单⼀的store中，store中的数据通过组件的props传⼊，当props关联的数据发⽣改变时将会触发组件的重新渲染。

dva是对Redux的进⼀步封装，对许多配置进⾏了简化，简单来讲，接下来的例程组件间通信、组件数据请求刷新全部都是基于dva完成的。[官方网站](https://dvajs.com/)

```react
app.model({
    namespace: 'count',
    state: {
        record: 0,
        current: 0,
    },
    reducers: {
        add(state) {
            const newCurrent = state.current + 1;
                return { ...state,
                record: newCurrent > state.record ? newCurrent : state.record,
                        current: newCurrent,
                };
            },		
            minus(state) {
            return { ...state, current: state.current - 1};
            },
        },
        effects: {
            *add(action, { call, put }) {
            yield call(delay, 1000);
            yield put({ type: 'minus' });
            },
        },
        subscriptions: {
        keyboardWatcher({ dispatch }) {
        key('⌘+up, ctrl+up', () => { dispatch({type:'add'}) });
        },	
    },
});
```

# X.初始化和运行第一个前端项目

可以将脚⼿架理解成为⼀个模版，脚⼿架⼯具可以快速帮助你从零搭建起⼀个简单的应⽤，同时帮助配置好各类软件包依赖，使得开发者可以快速投⼊业务逻辑的开发当中。

## x.1 安装

1.安装yarn包管理工具

`npm i yarn tyarn -g`

2.全局安装umi

`yarn global add umi`

2.安装antd

`yarn add antd`或者`npm install -g antd`

## x.2 使用脚手架初始化

1.新建目录，进入后执行：

`yarn create umi`

2.选择引用类型

`app->不使用TypeScript(n)->选中antd和dva功能块`

## x.3 Umi路由添加

```
.
├── mock/ // mock 文件所在目录，基于 express
├── node_modules/ // 依赖包安装文件夹
└── src/ // 源码目录，可选
    ├── layouts // 全局布局
    ├── models // dva models文件存放目录，存放global的models
    ├── pages/ // 页面目录，里面的文件即路由
        ├── .umi/ // dev 临时目录，需添加到 .gitignore
        ├── index.js // HTML 模板
        ├── index.css // 404 页面
    ├── global.css // 约定的全局样式文件，自动引入，也可以用
global.less
    ├── app.js // 可以在这里加入 polyfill
├── .umirc.js // umi 配置，同 config/config.js，二选一
├── .env // 环境变量
└── package.json
```

那如何添加我们⾃定义的⻚⾯，并且能够通过浏览器的路由访问到呢？umi提供约定式路由，可以⾃动帮助独⽴的⻚⾯⽂件⽣成路由，例如pages⽂件夹下index.js⽂件通过"/"默认路径即可访问，在pages下新建test.js⽂件，输⼊以下内容

```react
//pages/test.js
export default function() {
	return (
		<div>
		<h1>欢迎接入浙大-瑞立物联网云平台</h1>
		</div>
	);
}
```

`localhost:8000/test` 访问到test.js⻚⾯中的“欢迎接入浙大-瑞立物联网云平台”

## x.4 纯函数和React组件

test.js文件中的`export default function(){...}`成为函数式组件，相当于函数体内只实现了ReactComponent的render()方法，没有state和生命周期函数，故⼜称为⽆状态组件，这类组件完全实现UI的渲染，显示内容由函数组件的props参数决定。

将Test组件改写成为标准的React组件为以下内容：

```react
import React from 'react';
export default class Welcome extends React.Component {
	render() {
		return (
			<div>
			<h1>欢迎接入浙大-瑞立物联网云平台</h1>
			</div>
		);
	}
}
```

## x.5 使用现有组件

[Layout组件网站](<https://ant.design/components/layout-cn/>)

