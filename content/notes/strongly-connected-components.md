---
title: 'Strongly Connected Components'
date: 2024-02-14T01:22:00+08:00
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
# 6-1 Strongly Connected Components
Write a program to find the strongly connected components in a digraph.
## Format of functions:
```c
void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) );
```
where `Graph` is defined as the following:
```c
typedef struct VNode *PtrToVNode;
struct VNode {
    Vertex Vert;
    PtrToVNode Next;
};
typedef struct GNode *Graph;
struct GNode {
    int NumOfVertices;
    int NumOfEdges;
    PtrToVNode *Array;
};
```
Here `void (*visit)(Vertex V)` is a function parameter that is passed into `StronglyConnectedComponents` to handle (print with a certain format) each vertex that is visited. The function `StronglyConnectedComponents` is supposed to print a return after each component is found.
## Sample program of judge:
```c
#include <stdio.h>
#include <stdlib.h>

#define MaxVertices 10  /* maximum number of vertices */
typedef int Vertex;     /* vertices are numbered from 0 to MaxVertices-1 */
typedef struct VNode *PtrToVNode;
struct VNode {
    Vertex Vert;
    PtrToVNode Next;
};
typedef struct GNode *Graph;
struct GNode {
    int NumOfVertices;
    int NumOfEdges;
    PtrToVNode *Array;
};

Graph ReadG(); /* details omitted */

void PrintV( Vertex V )
{
   printf("%d ", V);
}

void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) );

int main()
{
    Graph G = ReadG();
    StronglyConnectedComponents( G, PrintV );
    return 0;
}
/* Your function will be put here */
```
## Sample Input (for the graph shown in the figure):
![image](https://github.com/novel2430/ZJU-2023-FDS/blob/main/ZJUFDS_2023_HW11/6-1-Strongly-Connected-Components/001.jpg?raw=true)
```
4 5
0 1
1 2
2 0
3 1
3 2

```
## Sample Output:
```
3 
1 2 0 

```
Note: The output order does not matter. That is, a solution like
```
0 1 2 
3
```
is also considered correct.
## Code Tarjan
```c
#include <stdio.h>
#include <stdlib.h>

#define MaxVertices 10  /* maximum number of vertices */
typedef int Vertex;     /* vertices are numbered from 0 to MaxVertices-1 */
typedef struct VNode *PtrToVNode;
struct VNode {
    Vertex Vert;
    PtrToVNode Next;
};
typedef struct GNode *Graph;
struct GNode {
    int NumOfVertices;
    int NumOfEdges;
    PtrToVNode *Array;
};

Graph ReadG(); /* details omitted */

void PrintV( Vertex V )
{
   printf("%d ", V);
}

void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) );

int main()
{
    Graph G = ReadG();
    StronglyConnectedComponents( G, PrintV );
    return 0;
}

PtrToVNode ptr_node_init(Vertex v){
  PtrToVNode res = (PtrToVNode)malloc(sizeof(struct VNode));
  res->Vert = v;
  res->Next = NULL;
  return res;
}
Graph ReadG(){
  Graph res = (Graph)malloc(sizeof(struct GNode));
  int vertice_num, edge_num;
  scanf("%d %d", &vertice_num, &edge_num);
  res->NumOfVertices = vertice_num;
  res->NumOfEdges = edge_num;
  res->Array = (PtrToVNode*)malloc(sizeof(PtrToVNode)*res->NumOfVertices);
  for(int i=0; i<vertice_num; i++) res->Array[i] = NULL;
  for(int i=0; i<edge_num; i++){
    int v1, v2;
    scanf("%d %d", &v1, &v2);
    PtrToVNode node = ptr_node_init(v2);
    if(res->Array[v1]==NULL) res->Array[v1] = node;
    else{
      node->Next = res->Array[v1];
      res->Array[v1] = node;
    }
  }
  return res;
}

/* Your function will be put here */
typedef enum Boolean {FALSE, TRUE} Boolean ;
typedef int StackVal; ;
typedef struct Stack{
  int max_size; 
  int cur_top;
  StackVal* array;
} Stack;
Stack* stack_init(int max){
  Stack* res = (Stack*)malloc(sizeof(Stack));
  res->max_size = max;
  res->cur_top = -1;
  res->array = (StackVal*)malloc(sizeof(StackVal)*res->max_size);
  return res;
}
Boolean stack_is_empty(Stack* stack){
  if(stack->cur_top==-1) return TRUE;
  return FALSE;
}
void stack_insert(Stack* stack, StackVal val){
  stack->cur_top++;
  stack->array[stack->cur_top] = val;
}
StackVal stack_pop(Stack* stack){
  int res = stack->array[stack->cur_top]; 
  stack->cur_top--;
  return res;
}
StackVal stack_peak(Stack* stack){
  int res = stack->array[stack->cur_top]; 
  return res;
}
void stack_empty(Stack* stack){
  while(!stack_is_empty(stack)){
    stack_pop(stack);
  }
}

int min(int a, int b){
  if(a < b) return a;
  return b;
}
void tarjan(Graph G, Stack* stack, int* dfn, int* low, Boolean* in_stack, int cur_idx, int* visit_count, void (*visit)(Vertex V)){
  dfn[cur_idx] = *visit_count;
  low[cur_idx] = *visit_count;
  (*visit_count)++;
  stack_insert(stack, cur_idx);
  in_stack[cur_idx] = TRUE;
  for(PtrToVNode cur=G->Array[cur_idx]; cur!=NULL; cur=cur->Next){
    if(dfn[cur->Vert]<0){
      tarjan(G, stack, dfn, low, in_stack, cur->Vert, visit_count, visit);
      low[cur_idx] = min(low[cur_idx], low[cur->Vert]);
    }
    else if(in_stack[cur->Vert]){
      low[cur_idx] = min(low[cur_idx], dfn[cur->Vert]);
    }
  }
  if(low[cur_idx]==dfn[cur_idx]){
    while(!stack_is_empty(stack)){
      int stack_top = stack_pop(stack);
      in_stack[stack_top] = FALSE;
      visit(stack_top);
      if(cur_idx==stack_top) break;
    }
    printf("\n");
  }
}
void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) ){
  Stack* stack = stack_init(G->NumOfVertices);
  int dfn[G->NumOfVertices];
  int low[G->NumOfVertices];
  Boolean in_stack[G->NumOfVertices];
  for(int i=0; i<G->NumOfVertices; i++){
    dfn[i] = -1;
    low[i] = -1;
    in_stack[i] = FALSE;
  }
  for(int i=0; i<G->NumOfVertices; i++){
    int visit_count = 0;
    if(dfn[i]==-1)
      tarjan(G, stack, dfn, low, in_stack, i, &visit_count, visit);
    stack_empty(stack);
  }
}
```
## Code Kosaraju
```c
#include <stdio.h>
#include <stdlib.h>

#define MaxVertices 10  /* maximum number of vertices */
typedef int Vertex;     /* vertices are numbered from 0 to MaxVertices-1 */
typedef struct VNode *PtrToVNode;
struct VNode {
    Vertex Vert;
    PtrToVNode Next;
};
typedef struct GNode *Graph;
struct GNode {
    int NumOfVertices;
    int NumOfEdges;
    PtrToVNode *Array;
};

Graph ReadG(); /* details omitted */

void PrintV( Vertex V )
{
   printf("%d ", V);
}

void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) );

int main()
{
    Graph G = ReadG();
    StronglyConnectedComponents( G, PrintV );
    return 0;
}

PtrToVNode ptr_node_init(Vertex v){
  PtrToVNode res = (PtrToVNode)malloc(sizeof(struct VNode));
  res->Vert = v;
  res->Next = NULL;
  return res;
}
Graph ReadG(){
  Graph res = (Graph)malloc(sizeof(struct GNode));
  int vertice_num, edge_num;
  scanf("%d %d", &vertice_num, &edge_num);
  res->NumOfVertices = vertice_num;
  res->NumOfEdges = edge_num;
  res->Array = (PtrToVNode*)malloc(sizeof(PtrToVNode)*res->NumOfVertices);
  for(int i=0; i<vertice_num; i++) res->Array[i] = NULL;
  for(int i=0; i<edge_num; i++){
    int v1, v2;
    scanf("%d %d", &v1, &v2);
    PtrToVNode node = ptr_node_init(v2);
    if(res->Array[v1]==NULL) res->Array[v1] = node;
    else{
      node->Next = res->Array[v1];
      res->Array[v1] = node;
    }
  }
  return res;
}

/* Your function will be put here */
typedef enum Boolean {FALSE, TRUE} Boolean ;
typedef int StackVal; ;
typedef struct Stack{
  int max_size; 
  int cur_top;
  StackVal* array;
} Stack;
Stack* stack_init(int max){
  Stack* res = (Stack*)malloc(sizeof(Stack));
  res->max_size = max;
  res->cur_top = -1;
  res->array = (StackVal*)malloc(sizeof(StackVal)*res->max_size);
  return res;
}
Boolean stack_is_empty(Stack* stack){
  if(stack->cur_top==-1) return TRUE;
  return FALSE;
}
void stack_insert(Stack* stack, StackVal val){
  stack->cur_top++;
  stack->array[stack->cur_top] = val;
}
StackVal stack_pop(Stack* stack){
  int res = stack->array[stack->cur_top]; 
  stack->cur_top--;
  return res;
}
StackVal stack_peak(Stack* stack){
  int res = stack->array[stack->cur_top]; 
  return res;
}
void stack_empty(Stack* stack){
  while(!stack_is_empty(stack)){
    stack_pop(stack);
  }
}

int min(int a, int b){
  if(a < b) return a;
  return b;
}
Graph build_graph_inverse(Graph graph){
  Graph res = (Graph)malloc(sizeof(struct GNode));
  res->NumOfEdges = graph->NumOfEdges;
  res->NumOfVertices = graph->NumOfVertices;
  res->Array = (PtrToVNode*)malloc(sizeof(PtrToVNode)*res->NumOfVertices);
  for(int i=0; i<res->NumOfVertices; i++) res->Array[i] = NULL;
  for(int i=0; i<res->NumOfVertices; i++){
    for(PtrToVNode cur = graph->Array[i]; cur!=NULL; cur=cur->Next){
      int v1 = cur->Vert;
      int v2 = i;
      PtrToVNode node = (PtrToVNode)malloc(sizeof(struct VNode));
      node->Vert = v2;
      node->Next = NULL;
      if(res->Array[v1]==NULL) res->Array[v1] = node;
      else{
        node->Next = res->Array[v1];
        res->Array[v1] = node;
      }
    }
  }
  return res;
}
void kosaraju_first_dfs(Graph graph, Stack* stack, Boolean* visit, Boolean* in_stack, int cur_idx){
  if(visit[cur_idx]) return;
  visit[cur_idx] = TRUE;
  for(PtrToVNode cur=graph->Array[cur_idx]; cur!=NULL; cur=cur->Next){
    kosaraju_first_dfs(graph, stack, visit, in_stack, cur->Vert);
  }
  stack_insert(stack, cur_idx);
  in_stack[cur_idx] = TRUE;
}
void kosaraju_second_dfs(Graph graph, Boolean* visit, Boolean* in_stack, int cur_idx, void (*print_visit)(Vertex V)){
  if(visit[cur_idx] || !in_stack[cur_idx]) return;
  visit[cur_idx] = TRUE;
  print_visit(cur_idx);
  for(PtrToVNode cur=graph->Array[cur_idx]; cur!=NULL; cur=cur->Next){
    kosaraju_second_dfs(graph, visit, in_stack, cur->Vert, print_visit);
  }
}
void kosaraju(Graph graph, Boolean* is_visit, int start, void (*visit)(Vertex V)){
  Graph inverse_graph = build_graph_inverse(graph);
  Stack* stack = stack_init(graph->NumOfVertices);
  Boolean is_visit_2[graph->NumOfVertices];
  Boolean in_stack[graph->NumOfVertices];
  for(int i=0; i<graph->NumOfVertices; i++) is_visit_2[i] = FALSE;
  for(int i=0; i<graph->NumOfVertices; i++) in_stack[i] = FALSE;
  kosaraju_first_dfs(graph, stack, is_visit, in_stack, start);
  while(!stack_is_empty(stack)){
    int stack_top = stack_pop(stack);
    if(is_visit_2[stack_top]) continue;
    kosaraju_second_dfs(inverse_graph, is_visit_2, in_stack, stack_top, visit);
    printf("\n");
  }
}
void StronglyConnectedComponents( Graph G, void (*visit)(Vertex V) ){
  Boolean is_visit[G->NumOfVertices];
  for(int i=0; i<G->NumOfVertices; i++) is_visit[i] = FALSE;
  for(int i=0; i<G->NumOfVertices; i++){
    if(is_visit[i]) continue;
    kosaraju(G, is_visit, i, visit);
  }

}
```
