---
title: 'Percolate Up and Down'
date: 2024-02-13T18:36:26+08:00
draft: false
categories: 
tags: # 自由新增
    - FDS Homework    
isCJKLanguage: true # 是否是中文(chinese,japanese,korea) 字數判斷用
comments: true
showToc: true # 顯示目錄
TocOpen: true # 預設打開目錄
hidemeta: false # 是否隱藏meta訊息(ex:發布日期、作者...etc)
disableShare: false # 取消社群分享區塊
showbreadcrumbs: true # 於頂部顯示文章路徑
ShowWordCounts: true
ShowReadingTime: true
ShowLastMod: true
---
# 6-1 Percolate Up and Down
Write the routines to do a "percolate up" and a "percolate down" in a binary min-heap.
## Format of functions:
```c
void PercolateUp( int p, PriorityQueue H );
void PercolateDown( int p, PriorityQueue H );
```
where `int p` is the position of the element, and `PriorityQueue` is defined as the following:
```c
typedef struct HeapStruct *PriorityQueue;
struct HeapStruct {
    ElementType  *Elements;
    int Capacity;
    int Size;
};
```
## Sample program of judge:
```c
#include <stdio.h>
#include <stdlib.h>

typedef int ElementType;
#define MinData -1

typedef struct HeapStruct *PriorityQueue;
struct HeapStruct {
    ElementType  *Elements;
    int Capacity;
    int Size;
};

PriorityQueue Initialize( int MaxElements ); /* details omitted */

void PercolateUp( int p, PriorityQueue H );
void PercolateDown( int p, PriorityQueue H );

void Insert( ElementType X, PriorityQueue H ) 
{
    int p = ++H->Size;
    H->Elements[p] = X;
    PercolateUp( p, H );
}

ElementType DeleteMin( PriorityQueue H ) 
{ 
    ElementType MinElement; 
    MinElement = H->Elements[1];
    H->Elements[1] = H->Elements[H->Size--];
    PercolateDown( 1, H );
    return MinElement; 
}

int main()
{
    int n, i, op, X;
    PriorityQueue H;

    scanf("%d", &n);
    H = Initialize(n);
    for ( i=0; i<n; i++ ) {
        scanf("%d", &op);
        switch( op ) {
        case 1:
            scanf("%d", &X);
            Insert(X, H);
            break;
        case 0:
            printf("%d ", DeleteMin(H));
            break;
        }
    }
    printf("\nInside H:");
    for ( i=1; i<=H->Size; i++ )
        printf(" %d", H->Elements[i]);
    return 0;
}

/* Your function will be put here */

```
## Sample Input:
```
9
1 10
1 5
1 2
0
1 9
1 1
1 4
0
0
```
## Sample Output:
```
2 1 4 
Inside H: 5 10 9
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

typedef int ElementType;
#define MinData -1

typedef struct HeapStruct *PriorityQueue;
struct HeapStruct {
    ElementType  *Elements;
    int Capacity;
    int Size;
};

PriorityQueue Initialize( int MaxElements ); /* details omitted */

void PercolateUp( int p, PriorityQueue H );
void PercolateDown( int p, PriorityQueue H );

void Insert( ElementType X, PriorityQueue H ) 
{
    int p = ++H->Size;
    H->Elements[p] = X;
    PercolateUp( p, H );
}

ElementType DeleteMin( PriorityQueue H ) 
{ 
    ElementType MinElement; 
    MinElement = H->Elements[1];
    H->Elements[1] = H->Elements[H->Size--];
    PercolateDown( 1, H );
    return MinElement; 
}

int main()
{
    int n, i, op, X;
    PriorityQueue H;

    scanf("%d", &n);
    H = Initialize(n);
    for ( i=0; i<n; i++ ) {
        scanf("%d", &op);
        switch( op ) {
        case 1:
            scanf("%d", &X);
            Insert(X, H);
            break;
        case 0:
            printf("%d ", DeleteMin(H));
            break;
        }
    }
    printf("\nInside H:");
    for ( i=1; i<=H->Size; i++ )
        printf(" %d", H->Elements[i]);
    return 0;
}

/* Your function will be put here */
void swap(int pos1, int pos2, PriorityQueue H){
  ElementType tmp = H->Elements[pos1];
  H->Elements[pos1] = H->Elements[pos2];
  H->Elements[pos2] = tmp;
}
int min_idx(int idx1, int idx2, PriorityQueue H){
  if(H->Elements[idx1] < H->Elements[idx2]) return idx1;
  return idx2;
}
void PercolateUp( int p, PriorityQueue H ){
  int pos = p;
  while(pos>1){
    int parent_idx = 1;
    int val = H->Elements[pos];
    if(pos%2==0) parent_idx = pos/2;
    else parent_idx = (pos-1)/2;
    if(H->Elements[parent_idx]>val) swap(pos, parent_idx, H);
    else break;
    pos = parent_idx;
  }
}
void PercolateDown( int p, PriorityQueue H ){
  int pos = p;
  while(pos*2 <= H->Size){
    int val = H->Elements[pos];
    int child_idx = H->Size;
    if(pos*2+1 <= H->Size)
      child_idx = min_idx(pos*2, pos*2+1, H);
    else child_idx = pos*2;
    if(H->Elements[child_idx] < val) swap(pos, child_idx, H);
    else break;
    pos = child_idx;
  }
}
```
