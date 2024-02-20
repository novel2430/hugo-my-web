---
title: 'Is Topological Order'
date: 2024-02-13T18:46:14+08:00
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
# 6-1 Is Topological Order
Write a program to test if a give sequence `Seq` is a topological order of a given graph `Graph`.
## Format of functions:
```c
bool IsTopSeq( LGraph Graph, Vertex Seq[] );
```
where `LGraph` is defined as the following:
```c
typedef struct AdjVNode *PtrToAdjVNode; 
struct AdjVNode{
    Vertex AdjV;
    PtrToAdjVNode Next;
};

typedef struct Vnode{
    PtrToAdjVNode FirstEdge;
} AdjList[MaxVertexNum];

typedef struct GNode *PtrToGNode;
struct GNode{  
    int Nv;
    int Ne;
    AdjList G;
};
typedef PtrToGNode LGraph;
```
The function `IsTopSeq` must return `true` if `Seq` does correspond to a topological order; otherwise return `false`.

**Note**: Although the vertices are numbered from 1 to MaxVertexNum, they are **indexed from 0** in the LGraph structure.
## Sample program of judge:
```c
#include <stdio.h>
#include <stdlib.h>

typedef enum {false, true} bool;
#define MaxVertexNum 10  /* maximum number of vertices */
typedef int Vertex;      /* vertices are numbered from 1 to MaxVertexNum */

typedef struct AdjVNode *PtrToAdjVNode; 
struct AdjVNode{
    Vertex AdjV;
    PtrToAdjVNode Next;
};

typedef struct Vnode{
    PtrToAdjVNode FirstEdge;
} AdjList[MaxVertexNum];

typedef struct GNode *PtrToGNode;
struct GNode{  
    int Nv;
    int Ne;
    AdjList G;
};
typedef PtrToGNode LGraph;

LGraph ReadG(); /* details omitted */

bool IsTopSeq( LGraph Graph, Vertex Seq[] );

int main()
{
    int i, j, N;
    Vertex Seq[MaxVertexNum];
    LGraph G = ReadG();
    scanf("%d", &N);
    for (i=0; i<N; i++) {
        for (j=0; j<G->Nv; j++)
            scanf("%d", &Seq[j]);
        if ( IsTopSeq(G, Seq)==true ) printf("yes\n");
        else printf("no\n");
    }

    return 0;
}

/* Your function will be put here */
```
## Sample Input (for the graph shown in the figure):
![image](https://images.ptausercontent.com/5373e878-196d-45dd-a82f-555b1fea6929.JPG)
```
6 8
1 2
1 3
5 2
5 4
2 3
2 6
3 4
6 4
5
1 5 2 3 6 4
5 1 2 6 3 4
5 1 2 3 6 4
5 2 1 6 3 4
1 2 3 4 5 6
```
## Sample Output:
```
yes
yes
yes
no
no
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

typedef enum {false, true} bool;
#define MaxVertexNum 10  /* maximum number of vertices */
typedef int Vertex;      /* vertices are numbered from 1 to MaxVertexNum */

typedef struct AdjVNode *PtrToAdjVNode; 
struct AdjVNode{
    Vertex AdjV;
    PtrToAdjVNode Next;
};

typedef struct Vnode{
    PtrToAdjVNode FirstEdge;
} AdjList[MaxVertexNum];

typedef struct GNode *PtrToGNode;
struct GNode{  
    int Nv;
    int Ne;
    AdjList G;
};
typedef PtrToGNode LGraph;

LGraph ReadG(); /* details omitted */

bool IsTopSeq( LGraph Graph, Vertex Seq[] );

int main()
{
    int i, j, N;
    Vertex Seq[MaxVertexNum];
    LGraph G = ReadG();
    scanf("%d", &N);
    for (i=0; i<N; i++) {
        for (j=0; j<G->Nv; j++)
            scanf("%d", &Seq[j]);
        if ( IsTopSeq(G, Seq)==true ) printf("yes\n");
        else printf("no\n");
    }

    return 0;
}

/* Your function will be put here */

bool IsTopSeq( LGraph Graph, Vertex Seq[] ){
    int in_degree[1000];
    PtrToAdjVNode t_node;
    for(int i=0;i<=Graph->Nv;i++)
        in_degree[i]=0;
    for(int i=0;i<Graph->Nv;i++){
        t_node=Graph->G[i].FirstEdge;
        while (t_node){
            in_degree[t_node->AdjV] = in_degree[t_node->AdjV] + 1;
            t_node=t_node->Next;
        }
    } 
    for(int i=0;i<Graph->Nv;i++){
        if(in_degree[Seq[i]-1]!=0)
            return false;
        else{
            t_node=Graph->G[Seq[i]-1].FirstEdge;
            while(t_node){
                in_degree[t_node->AdjV] = in_degree[t_node->AdjV] - 1;
                t_node=t_node->Next;
            }
        }
    }
    return true;
}
```
