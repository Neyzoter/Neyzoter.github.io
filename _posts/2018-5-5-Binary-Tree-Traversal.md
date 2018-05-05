---
layout: post
title: C语言实现二叉树遍历
categories: BasicAlgorithm
description: C语言的二叉树遍历
keywords: C, 二叉树
---

> 原创
> 
> 转载请注明出处，侵权必究


# 1、前序遍历
## 1.1 递归模式
```C
void PreOrder(BiTree bt)
{	
	 /*先序遍历二叉树bt*/
	if (bt==NULL) 
		return;
	printf("%d",bt->data); /*访问结点的数据域*/
	PreOrder(bt->lchild) ;/*先序递归遍历bt的左子树*/
	PreOrder(bt->rchild);/*先序递归遍历bt的右子树*/
}
```

## 1.2 非递归模式
```C
Status PreOrder(BiTree T,Status (*Visit)(TElemType e))
{
    //使用前先初始化栈
    BiTree p=T;
    while(p || !StackEmpty(S))//如果指向非空或者堆栈还没有空
    {
        if(p)
        {
            Push(S,p);
            if(!Visit(p->data))
                return ERROR;
            p=p->lchild;
        }
        else
        {
            Pop(S,p);
            p=p->rchild;
        }
    }// end of while
    return OK;
}

```
# 2、中序遍历
## 2.1 递归模式

```C
void InOrder(BiTree bt)
{ 
	/*中序遍历二叉树bt*/
	if (bt==NULL) 
		return;
	InOrder( bt->lchild );/*中序递归遍历bt的左子	树*/
	printf("%d",bt->data); /*访问结点的数据域*/
	InOrder( bt->rchild );/*中序递归遍历bt的右子树*/
}
```

## 2.2 非递归模式
```C
Status InOrder(BiTree T,Status (*Visit)(TElemType e))
{
    //使用前先初始化栈
    BiTree p=T;
    while(p || !StackEmpty(S))//如果指向非空或者堆栈还没有空
    {
        if(p)
        {
            Push(S,p);
            p=p->lchild;
        }
        else
        {
            Pop(S,p);
            if(!Visit(p->data))
                return ERROR;
            p=p->rchild;
        }
    }// end of while
    return OK;
}
```
# 3、后续遍历
## 3.1 递归模式
```C
void PostOrder(BiTree bt)
{ 
	/*后序遍历二叉树bt*/
	if (bt==NULL) 
		return;
	PostOrder ( bt->lchild ) ;/*后序递归遍历bt的左子树*/
	PostOrder (bt->rchild );/*后序递归遍历bt的右子树*/
	printf("%d",bt->data); /*访问结点的数据域*/
}
```
## 3.2 非递归模式
由于前序和中序遍历采用非递归方法的时候，只需要pop一次。这个非递归后序遍历有点不同。

