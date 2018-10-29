---
layout: post
title: FreeRTOS学习笔记(9)列表和列表项
categories: RTOS
description: FreeRTOS学习笔记(9)列表和列表项
keywords: FreeRTOS, 列表, 列表项
---

> 原创
> 
> 转载请注明出处，侵权必究。

# 1、列表和列表项介绍
列表是FreeRTOS的一个数据结构，概念上和链表类似，用于跟踪FreeRTOS的任务。

任务优先级为0的***就绪列表**、列表项和TCB的关系如下：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/list2tcb.png" width="600" alt="列表、列表项和TCB的关系" />

**不同任务优先级的就绪列表**关系如下。其中优先级0的有1个任务，优先级1的无任务，优先级2的有3个任务。

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/ReadyListStructure.png" width="600" alt="不同的任务优先级的就绪列表关系" />

>*我的理解重要*：
>
>列表分不同的等级，如等级0（pxReadyTaskLists[0]）、等级1（pxReadyTaskLists[1]）……其中pxIndex可以指向它包含的某一个列表项，后面的是可以通过指针遍历到的。
>
>列表项的pvOwner可以指向不同的任务控制块，任务控制块是唯一表示一个任务的结构体。
>
>列表项的pvContainer指向包含它的列表。
>
>由pxCurrentTCB指向当前运行的任务控制块。
>
>总结：列表->某一个列表项（通过链表遍历到其他的列表项）->任务控制块<-当前任务

## 1.1 列表
```cpp
typedef struct xLIST
{
	listFIRST_LIST_INTEGRITY_CHECK_VALUE				/*< 如果 configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES设置为1，则给该变量赋值一个值，用于检查列表完整性. */
	volatile UBaseType_t uxNumberOfItems;		/*<用来记录列表中	列表项的数量  */
	ListItem_t * configLIST_VOLATILE pxIndex;			/*< 用来记录当前列表项索引号，用于遍历列表. */
	MiniListItem_t xListEnd;							/*<  列表最后一个列表项，用于表示列表结束，类型迷你列表项*/
	listSECOND_LIST_INTEGRITY_CHECK_VALUE				/*<如果 configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES设置为1，则给该变量赋值一个值，用于检查列表完整性. */
} List_t;
```

其中两个宏，现在不使用。结构如下：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/list.png" width="300" alt="列表结构" />

## 1.2 列表项

列表项即存放在列表中的项目，分为列表项和迷你列表项。

```cpp
struct xLIST_ITEM
{
	listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE			
	configLIST_VOLATILE TickType_t xItemValue;			/*< 列表项值. */
	struct xLIST_ITEM * configLIST_VOLATILE pxNext;		/*< 指向下一个列表项. */
	struct xLIST_ITEM * configLIST_VOLATILE pxPrevious;	/*< 指向前一个列表项. */
	void * pvOwner;		/*< 指向一个拥有列表项的对象（一般是任务控制块TCB）. */
	void * configLIST_VOLATILE pvContainer;				/*< 指向放置列表项的列表. */
	listSECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE			
};
typedef struct xLIST_ITEM ListItem_t;
```

没有列出列表项完整性的检查的成员变量。

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/listitem.png" width="300" alt="列表项结构" />

## 1.3 迷你列表项

```cpp
struct xMINI_LIST_ITEM
{
	listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE			
	configLIST_VOLATILE TickType_t xItemValue;/*< 记录列表项值 */
	struct xLIST_ITEM * configLIST_VOLATILE pxNext;/*<指向下一个列表项*/
	struct xLIST_ITEM * configLIST_VOLATILE pxPrevious; /*< 指向上一个列表项*/
};
typedef struct xMINI_LIST_ITEM MiniListItem_t;
```

迷你列表项的成员变量在列表项均有，而少了pvOwner和pvContainer，因为有的时候的列表项不需要这么全。

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/minilistitem.png" width="300" alt="迷你列表项结构" />

# 2、列表和列表项初始化

## 2.1 列表初始化
```cpp
void vListInitialise( List_t * const pxList )
{

	pxList->pxIndex = ( ListItem_t * ) &( pxList->xListEnd );			/*<xListEnd表示列表的末尾，pxIndex	表示列表项的索引号，此时列表只有一个列表项，即xListEnd，pxList指向xListEnd. */

	pxList->xListEnd.xItemValue = portMAX_DELAY;/*< 给xListEnd.xItemValue初始化*/

	pxList->xListEnd.pxNext = ( ListItem_t * ) &( pxList->xListEnd );	/*下一个列表，指向自身. */
	pxList->xListEnd.pxPrevious = ( ListItem_t * ) &( pxList->xListEnd );/*< 初始化xListEnd的pxEnd的pxprevious变量，指向xListEnd自身. */

	pxList->uxNumberOfItems = ( UBaseType_t ) 0U;//列表项数目是0，没有算xListEnd

	/* 完整性检查字段，只有宏configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES为1的时候才有效
		不同的的MCU写入不同的值，如STM32时32位系统，写入5a5a5a5aUL. */
	listSET_LIST_INTEGRITY_CHECK_1_VALUE( pxList );
	listSET_LIST_INTEGRITY_CHECK_2_VALUE( pxList );
}

```

列表初始化后的结构图：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/listinit.png" width="300" alt="列表初始化" />

## 2.2 列表项初始化

```cpp
void vListInitialiseItem( ListItem_t * const pxItem )
{
	/* 初始化pvContainer为NULL. */
	pxItem->pvContainer = NULL;

	/* 完整性检查. */
	listSET_FIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem );
	listSET_SECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem );
}
```

# 3、列表项插入

```cpp
void vListInsert( List_t * const pxList, ListItem_t * const pxNewListItem )
{
	ListItem_t *pxIterator;
	const TickType_t xValueOfInsertion = pxNewListItem->xItemValue;/*获取要插入的列表项值，即列表项成员变量xItemValue的值，因为要根据这个值来确定列表项要插入的位置*/

	/* 检查列表和列表项完整性，如果用于完整性的数字改变了，则configASSERT. */
	listTEST_LIST_INTEGRITY( pxList );
	listTEST_LIST_ITEM_INTEGRITY( pxNewListItem );	

	if( xValueOfInsertion == portMAX_DELAY )//如果插入到末尾（插入的列表项数值为portMAX_DELAY最大值）
	{
		pxIterator = pxList->xListEnd.pxPrevious;		//最后一个列表项xListEnd的数值设置的是portMAX_DELAY，而如果插入进来的也是最大值，那么把插进来的列表项放在最后一个列表项
	}
	else  //如果不插入到末尾
	{

		for( pxIterator = ( ListItem_t * ) &( pxList->xListEnd ); pxIterator->pxNext->xItemValue <= xValueOfInsertion; pxIterator = pxIterator->pxNext ) /*这个for循环用于寻找到列表项插入点. */
		{
			/* There is nothing to do here, just iterating to the wanted
			insertion position. */
		}
	}

	//把列表项插入进去
	pxNewListItem->pxNext = pxIterator->pxNext;//新建的下一个指向遍历到的下一个
	pxNewListItem->pxNext->pxPrevious = pxNewListItem;//新建的下一个的前一个变成了新建的
	pxNewListItem->pxPrevious = pxIterator;//新建的前一个是遍历到的
	pxIterator->pxNext = pxNewListItem;//遍历到的下一个是新建的

	/* 列表项的成员变量pvContainer记录该列表项属于哪个列表. */
	pxNewListItem->pvContainer = ( void * ) pxList;

	( pxList->uxNumberOfItems )++; //列表项的数目+1
}

```

插入第一个列表值为40的列表项（ListEnd的previous和nex均会指向第一个列表项）：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/insertItem1.png" width="500" alt="插入第一个列表项" />

插入第二个列表值为50的列表项：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/insertItem2.png" width="500" alt="插入第二个列表项" />

插入第三个列表值为60的列表项：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/insertItem3.png" width="800" alt="插入第三个列表项" />

# 4、列表项末尾插入

不使用列表项的数值来决定列表的先后顺序。

```cpp
void vListInsertEnd( List_t * const pxList, ListItem_t * const pxNewListItem )
{
	ListItem_t * const pxIndex = pxList->pxIndex;

	/* 检查列表和列表项的完整性，如果数值发生了改变，那么就会执行assert. */
	listTEST_LIST_INTEGRITY( pxList );
	listTEST_LIST_ITEM_INTEGRITY( pxNewListItem );

	/* pxIndex是用来遍历列表的，指向的列表项即要遍历开始的地方，即表头。由于是一个环形列表所以新的列表项就应该插入到pxIndex所指向的列表项的前面. */
	pxNewListItem->pxNext = pxIndex;
	pxNewListItem->pxPrevious = pxIndex->pxPrevious;

	/* Only used during decision coverage testing. */
	mtCOVERAGE_TEST_DELAY();

	pxIndex->pxPrevious->pxNext = pxNewListItem;
	pxIndex->pxPrevious = pxNewListItem;

	/* Remember which list the item is in. */
	pxNewListItem->pvContainer = ( void * ) pxList;

	( pxList->uxNumberOfItems )++;
}
```

列表项插入的图示：

插入前两个，分别编号40和60，但是这里不需要按照先后循序来连接：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/insertEndItem1and2.png" width="600" alt="插入前两个列表项" />

插入第三个：

<img src="/images/posts/2018-4-20-FreeRTOS-Note9-List-and-ListBoxItem/insertEndItem3.png" width="600" alt="插入前两个列表项" />

# 5、列表项的删除

```cpp
UBaseType_t uxListRemove( ListItem_t * const pxItemToRemove )
{
/* The list item knows which list it is in.  Obtain the list from the list
item. */
List_t * const pxList = ( List_t * ) pxItemToRemove->pvContainer;

	pxItemToRemove->pxNext->pxPrevious = pxItemToRemove->pxPrevious;
	pxItemToRemove->pxPrevious->pxNext = pxItemToRemove->pxNext;

	/* Only used during decision coverage testing. */
	mtCOVERAGE_TEST_DELAY();

	/* Make sure the index is left pointing to a valid item. */
	if( pxList->pxIndex == pxItemToRemove )	//如果pxIndex指向正好要删除的列表项那么需要给pxIndex重新找一个列表项，这里给了要删除的前一个
	{
		pxList->pxIndex = pxItemToRemove->pxPrevious;
	}
	else
	{
		mtCOVERAGE_TEST_MARKER();
	}

	pxItemToRemove->pvContainer = NULL;//被删除列表项的成员变量pvContainer清零
	( pxList->uxNumberOfItems )--;

	return pxList->uxNumberOfItems;
}

```

# 6、列表的遍历
```cpp
//pxTCB用于保存pxIndex所指向的列表项的pvOwner变量值，即列表属于谁。通常是一个任务的任务控制块。
//pxList表示要遍历的列表
#define listGET_OWNER_OF_NEXT_ENTRY( pxTCB, pxList )							
{																				
	List_t * const pxConstList = ( pxList );									
	/* Increment the index to the next item and return the item, ensuring */	
	/* we don't return the marker used at the end of the list.  */	
	//列表的pxIndex变量指向下一个列表项	
	( pxConstList )->pxIndex = ( pxConstList )->pxIndex->pxNext;

	//如果到达了最后一个列表项
	if( ( void * ) ( pxConstList )->pxIndex == ( void * ) &( ( pxConstList )->xListEnd ) )	
	{																			
		//如果到达了最后一个列表项，列表pxIndex重新指向下一个列表项。跳过	xListEnd。
		( pxConstList )->pxIndex = ( pxConstList )->pxIndex->pxNext;			
	}		
		//	下一个要运行任务的pvOwner给pxTCB											
	( pxTCB ) = ( pxConstList )->pxIndex->pvOwner;	
}
```




