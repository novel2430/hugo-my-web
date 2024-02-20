---
title: 'Uniqueness of MST'
date: 2024-02-14T01:18:35+08:00
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
# Uniqueness of MST
Given any weighted undirected graph, there exists at least one minimum spanning tree (MST) if the graph is connected. Sometimes the MST may not be unique though. Here you are supposed to calculate the minimum total weight of the MST, and also tell if it is unique or not.
## Input Specification:
Each input file contains one test case. Each case starts with a line containing 2 numbers N (≤ 500), and M, which are the total number of vertices, and the number of edges, respectively. Then M lines follow, each describes an edge by 3 integers:
```
V1 V2 Weight
```
where `V1` and `V2` are the two ends of the edge (the vertices are numbered from 1 to N), and `Weight` is the positive weight on that edge. It is guaranteed that the total weight of the graph will not exceed 2<sup>30</sup>.
## Output Specification:
For each test case, first print in a line the total weight of the minimum spanning tree if there exists one, or else print No MST instead. Then if the MST exists, print in the next line `Yes` if the tree is unique, or `No` otherwise. There there is `no MST`, print the number of connected components instead.
## Sample Input 1:
```
5 7
1 2 6
5 1 1
2 3 4
3 4 3
4 1 7
2 4 2
4 5 5
```
## Sample Output 1:
```
11
Yes
```
## Sample Input 2:
```
4 5
1 2 1
2 3 1
3 4 2
4 1 2
3 1 3
```
## Sample Output 2:
```
4
No
```
## Sample Input 3:
```
5 5
1 2 1
2 3 1
3 4 2
4 1 2
3 1 3
```
## Sample Output 3:
```
No MST
2
```
## Code Prim
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 2000
#define MAXE 150000
typedef enum { FALSE, TRUE } boolean;
typedef enum {
  UNIQUE,
  PLURAL,
  NONE
} ResType;

typedef struct Edge{
  int v1;
  int v2;
  int weight;
}Edge ;
typedef struct Graph{
  int node_num;
  int edge_num;
  Edge* weights[MAXN][MAXN];
  Edge* MST_edges[MAXE];
}Graph ;

typedef struct HeapNode{
  Edge* edge;
  int to;
}HeapNode ;

typedef struct Heap{
  int size;
  HeapNode* value[MAXE];
}Heap ;

void swap(int pos1, int pos2, Heap* H){
  HeapNode* tmp = H->value[pos1];
  H->value[pos1] = H->value[pos2];
  H->value[pos2] = tmp;
}
int min_idx(int idx1, int idx2, Heap* H){
  if(H->value[idx1]->edge->weight < H->value[idx2]->edge->weight) return idx1;
  return idx2;
}
Heap* heap_init(){
  Heap* res = (Heap*)malloc(sizeof(Heap));
  res->size = 0;
  return res;
}
void heap_node_delete(HeapNode* node){
  if(node==NULL) return;
  free(node);
  node = NULL;
}
boolean heap_is_empty(Heap* heap){
  if(heap->size==0) return TRUE;
  else return FALSE;
}
void heap_delete(Heap* heap){
  if(heap==NULL) return;
  for(int i=1; i<=heap->size; i++){
    heap_node_delete(heap->value[i]);
  }
  free(heap);
  heap = NULL;
}
HeapNode heap_pop_min(Heap* heap){
  HeapNode* res = heap->value[1];
  heap->value[1] = heap->value[heap->size];
  heap->size--;
  for(int pos=1, child_idx; pos*2<=heap->size; pos=child_idx){
    int val = heap->value[pos]->edge->weight;
    if(pos*2+1 <= heap->size)
      child_idx = min_idx(pos*2, pos*2+1, heap);
    else child_idx = pos*2;
    if(heap->value[child_idx]->edge->weight < val) swap(pos, child_idx, heap);
    else break;
  }
  HeapNode node;
  node.edge = res->edge;
  node.to = res->to;
  heap_node_delete(res);
  return node;
}
void heap_insert(Heap* heap, Edge* edge, int to){
  if(heap==NULL) return;
  HeapNode* new_node = (HeapNode*)malloc(sizeof(HeapNode));
  new_node->edge = edge;
  new_node->to = to;
  heap->value[heap->size+1] = new_node;
  heap->size++;
  for(int pos=heap->size,parent_idx; pos>1; pos=parent_idx){
    int val = heap->value[pos]->edge->weight;
    if(pos%2==0) parent_idx = pos/2;
    else parent_idx = (pos-1)/2;
    if(heap->value[parent_idx]->edge->weight>val) swap(pos, parent_idx, heap);
    else break;
  }
}

Graph* graph_init(int node_num, int edge_num){
  Graph* res = (Graph*)malloc(sizeof(Graph));
  res->node_num = node_num;
  res->edge_num = edge_num;
  for(int i=0; i<node_num; i++){
    for(int j=0; j<node_num; j++)
      res->weights[i][j] = NULL;
  }
  return res;
}
void graph_insert_edge(Graph* graph, int v1, int v2, int weight){
  Edge* edge = (Edge*)malloc(sizeof(Edge));
  edge->v1 = v1;
  edge->v2 = v2;
  edge->weight = weight;
  graph->weights[v1-1][v2-1] = edge;
  graph->weights[v2-1][v1-1] = edge;
}

ResType find_mst(Graph* graph, Heap* heap, boolean* visit, int start_idx, int* mst_val, int* mst_edge_count){
  visit[start_idx] = TRUE;
  for(int i=0; i<graph->node_num; i++){
    if(graph->weights[start_idx][i]!=NULL){
      heap_insert(heap, graph->weights[start_idx][i], i);
    }
  }
  while(!heap_is_empty(heap)){
    HeapNode min = heap_pop_min(heap);
    Edge* edge = min.edge;
    if(visit[min.to]) continue;
    visit[min.to] = TRUE;
    (*mst_val) += min.edge->weight;
    graph->MST_edges[(*mst_edge_count)++] = edge;
    for(int i=0; i<graph->node_num; i++){
      if(!visit[i] && graph->weights[min.to][i]!=NULL){
        heap_insert(heap, graph->weights[min.to][i], i);
      }
    }
  }
  if((*mst_edge_count)!=graph->node_num-1) return NONE;
  return UNIQUE;
}
int find_tree_count(Graph* graph, Heap* heap, boolean* visit){
  int res = 1;
  int mst_val = 0;
  int mst_edge_count = 0;
  for(int i=0; i<graph->node_num; i++){
    if(!visit[i]){
      find_mst(graph, heap, visit, i, &mst_val, &mst_edge_count);
      res++;
    }
  }
  return res;
}
ResType tree_unique(Graph* graph, Heap* heap, int min_mst_val, int mst_edge_count){
  boolean visit[MAXN];
  for(int ii=0; ii<mst_edge_count; ii++){
    Edge* cannot_use_edge = graph->MST_edges[ii];
    memset(visit, FALSE, sizeof(visit));
    visit[0] = TRUE;
    int mst_val = 0;
    for(int i=0; i<graph->node_num; i++){
      if(graph->weights[0][i]!=NULL){
        heap_insert(heap, graph->weights[0][i], i);
      }
    }
    while(!heap_is_empty(heap)){
      HeapNode min = heap_pop_min(heap);
      Edge* edge = min.edge;
      if(visit[min.to] || edge==cannot_use_edge) continue;
      visit[min.to] = TRUE;
      mst_val += edge->weight;
      for(int i=0; i<graph->node_num; i++){
        if(!visit[i] && graph->weights[min.to][i]!=NULL){
          heap_insert(heap, graph->weights[min.to][i], i);
        }
      }
    }
    if(mst_val==min_mst_val) return PLURAL;
  }
  return UNIQUE;
}
ResType prim(Graph* graph, int* mst_val, int* tree_count){
  int mst_edge_count = 0;
  Heap* heap = heap_init();
  boolean visit[MAXN];
  memset(visit, FALSE, sizeof(visit));
  ResType res = find_mst(graph, heap, visit, 0, mst_val, &mst_edge_count);
  if(res==NONE){
    (*tree_count) = find_tree_count(graph, heap, visit);
  }
  else{
    res = tree_unique(graph, heap, *mst_val, mst_edge_count);
  }
  heap_delete(heap);
  return res;
}


int main(int argc, char *argv[]){
  int node_num, edge_num;
  scanf("%d %d", &node_num, &edge_num);
  Graph* graph = graph_init(node_num, edge_num);
  for(int i=0; i<edge_num; i++){
    int v1, v2, weight;
    scanf("%d %d %d", &v1, &v2, &weight);
    graph_insert_edge(graph, v1, v2, weight);
  }
  int mst_val = 0;
  int tree_count = 0;
  ResType res = prim(graph, &mst_val, &tree_count);
  switch (res) {
    case UNIQUE:
      printf("%d\nYes\n", mst_val);
      break;
    case PLURAL:
      printf("%d\nNo\n", mst_val);
      break;
    case NONE:
      printf("No MST\n%d\n", tree_count);
      break;
    default:
      break;
  }
  return 0;
}
```
## Code Kruskal Normal
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 150000
typedef enum { FALSE, TRUE } boolean;
typedef enum {
  UNIQUE,
  PLURAL,
  NONE
} ResType;

typedef struct Node{
  int val;
  struct Node* parent;
}Node ;
typedef struct Edge{
  Node* v1;
  Node* v2;
  int weight;
}Edge ;
typedef struct Graph{
  int node_num;
  int edge_num;
  Edge* edges[MAXN];
  Node* nodes[MAXN];
}Graph ;

Node* node_init(int val){
  Node* res = (Node*)malloc(sizeof(Node));
  res->val = val;
  res->parent = res;
  return res;
}
Node* node_find_parent(Node* node){
  if(node == node->parent) return node;
  node->parent = node_find_parent(node->parent);
  return node->parent;
}
boolean node_is_same_set(Node* node1, Node* node2){
  Node* n1_parent = node_find_parent(node1);
  Node* n2_parent = node_find_parent(node2);
  if(n1_parent==n2_parent) return TRUE;
  return FALSE;
}
void node_union(Node* node1, Node* node2){
  node_find_parent(node1)->parent = node_find_parent(node2);
}

Graph* graph_init(int node_num, int edge_num){
  Graph* res = (Graph*)malloc(sizeof(Graph));
  res->node_num = node_num;
  res->edge_num = edge_num;
  for(int i=0; i<res->node_num; i++){
    res->nodes[i] = node_init(i+1);
  }
  return res;
}
void graph_insert_edge(Graph* graph, int idx, int v1, int v2, int weight){
  graph->edges[idx] = (Edge*)malloc(sizeof(Edge));
  graph->edges[idx]->v1 = graph->nodes[v1-1];
  graph->edges[idx]->v2 = graph->nodes[v2-1];;
  graph->edges[idx]->weight = weight;
}

void merge_sort_conquer(Edge** arr, Edge** tmp, int low, int mid, int high){
  int start_1 = low;
  int end_1 = mid;
  int start_2 = mid+1;
  int end_2 = high;
  int idx = 0;
  while(start_1<=end_1 && start_2<=end_2){
    if(arr[start_1]->weight < arr[start_2]->weight){
      tmp[idx++] = arr[start_1++];
    }
    else{
      tmp[idx++] = arr[start_2++];
    }
  }
  while(start_1 <= end_1){
    tmp[idx++] = arr[start_1++];
  }
  while(start_2 <= end_2){
    tmp[idx++] = arr[start_2++];
  }
  idx = 0;
  while(low <= high){
    arr[low++] = tmp[idx++];
  }
}
void merge_sort_divide(Edge** arr, Edge** tmp, int low, int high){
  if(low<high){
    int mid = (low+high)/2;
    merge_sort_divide(arr, tmp, low, mid);
    merge_sort_divide(arr, tmp, mid+1, high);
    merge_sort_conquer(arr, tmp, low, mid, high);
  }
}
void merge_sort_edge(Graph* graph){
  Edge* tmp[MAXN];
  merge_sort_divide(graph->edges, tmp, 0, graph->edge_num-1);
}

ResType kruskal(Graph* graph, int* mst_val){
  int mst_edge_count = 0;
  // find MST
  Edge* MST_edge[MAXN];
  for(int i=0; i<graph->edge_num&&mst_edge_count<graph->node_num-1; i++){
    Edge* cur_edge = graph->edges[i];
    if(!node_is_same_set(cur_edge->v1, cur_edge->v2)){
      (*mst_val) += cur_edge->weight;
      MST_edge[mst_edge_count++] = cur_edge;
      node_union(cur_edge->v1, cur_edge->v2);
    }
  }
  if(mst_edge_count!=graph->node_num-1) return NONE;
  // find SMST
  for(int i=0; i<mst_edge_count; i++){
    int sum_SMST = 0;
    for(int ii=0; ii<graph->node_num; ii++)
      graph->nodes[ii]->parent = graph->nodes[ii];
    for(int j=0; j<graph->edge_num; j++){
      Edge* cur_edge = graph->edges[j];
      if(cur_edge==MST_edge[i]) continue;
      if(!node_is_same_set(cur_edge->v1, cur_edge->v2)){
        sum_SMST += cur_edge->weight;
        node_union(cur_edge->v1, cur_edge->v2);
      }
    }
    if(sum_SMST==(*mst_val)) return PLURAL;
  }
  return UNIQUE;
}
int graph_count_set(Graph* graph){
  int res = 0;
  for(int i=0; i<graph->node_num; i++){
    if(graph->nodes[i]->parent==graph->nodes[i]) res++;
  }
  return res;
}

int main(int argc, char *argv[]){
  int node_num, edge_num;
  scanf("%d %d", &node_num, &edge_num);
  Graph* graph = graph_init(node_num, edge_num);
  for(int i=0; i<edge_num; i++){
    int v1, v2, weight;
    scanf("%d %d %d", &v1, &v2, &weight);
    graph_insert_edge(graph, i, v1, v2, weight);
  }
  merge_sort_edge(graph);
  int mst_val = 0;
  ResType res = kruskal(graph, &mst_val);
  switch (res) {
    case UNIQUE:
      printf("%d\nYes\n", mst_val);
      break;
    case PLURAL:
      printf("%d\nNo\n", mst_val);
      break;
    case NONE:
      printf("No MST\n%d\n", graph_count_set(graph));
      break;
    default:
      break;
  }
  return 0;
}
```
## Code Kruskal Better
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 150000
typedef enum { FALSE, TRUE } boolean;
typedef enum {
  UNIQUE,
  PLURAL,
  NONE
} ResType;

typedef struct Node{
  int val;
  struct Node* parent;
}Node ;
typedef struct Edge{
  Node* v1;
  Node* v2;
  int weight;
}Edge ;
typedef struct Graph{
  int node_num;
  int edge_num;
  Edge* edges[MAXN];
  Node* nodes[MAXN];
}Graph ;

Node* node_init(int val){
  Node* res = (Node*)malloc(sizeof(Node));
  res->val = val;
  res->parent = res;
  return res;
}
Node* node_find_parent(Node* node){
  if(node == node->parent) return node;
  node->parent = node_find_parent(node->parent);
  return node->parent;
}
boolean node_is_same_set(Node* node1, Node* node2){
  Node* n1_parent = node_find_parent(node1);
  Node* n2_parent = node_find_parent(node2);
  if(n1_parent==n2_parent) return TRUE;
  return FALSE;
}
void node_union(Node* node1, Node* node2){
  node_find_parent(node1)->parent = node_find_parent(node2);
}

Graph* graph_init(int node_num, int edge_num){
  Graph* res = (Graph*)malloc(sizeof(Graph));
  res->node_num = node_num;
  res->edge_num = edge_num;
  for(int i=0; i<res->node_num; i++){
    res->nodes[i] = node_init(i+1);
  }
  return res;
}
void graph_insert_edge(Graph* graph, int idx, int v1, int v2, int weight){
  graph->edges[idx] = (Edge*)malloc(sizeof(Edge));
  graph->edges[idx]->v1 = graph->nodes[v1-1];
  graph->edges[idx]->v2 = graph->nodes[v2-1];;
  graph->edges[idx]->weight = weight;
}

void merge_sort_conquer(Edge** arr, Edge** tmp, int low, int mid, int high){
  int start_1 = low;
  int end_1 = mid;
  int start_2 = mid+1;
  int end_2 = high;
  int idx = 0;
  while(start_1<=end_1 && start_2<=end_2){
    if(arr[start_1]->weight < arr[start_2]->weight){
      tmp[idx++] = arr[start_1++];
    }
    else{
      tmp[idx++] = arr[start_2++];
    }
  }
  while(start_1 <= end_1){
    tmp[idx++] = arr[start_1++];
  }
  while(start_2 <= end_2){
    tmp[idx++] = arr[start_2++];
  }
  idx = 0;
  while(low <= high){
    arr[low++] = tmp[idx++];
  }
}
void merge_sort_divide(Edge** arr, Edge** tmp, int low, int high){
  if(low<high){
    int mid = (low+high)/2;
    merge_sort_divide(arr, tmp, low, mid);
    merge_sort_divide(arr, tmp, mid+1, high);
    merge_sort_conquer(arr, tmp, low, mid, high);
  }
}
void merge_sort_edge(Graph* graph){
  Edge* tmp[MAXN];
  merge_sort_divide(graph->edges, tmp, 0, graph->edge_num-1);
}

ResType kruskal(Graph* graph, int* mst_val){
  int mst_edge_count = 0;
  // find MST
  int flag = 0;
  for(int i=0; i<graph->edge_num&&mst_edge_count<graph->node_num-1; i++){
    Edge* cur_edge = graph->edges[i];
    if(!node_is_same_set(cur_edge->v1, cur_edge->v2)){
      for(int j=i+1; flag==0&&j<graph->edge_num&&graph->edges[j]->weight==cur_edge->weight; j++){
        Edge* edge = graph->edges[j];
        if(node_is_same_set(cur_edge->v1, edge->v1) && node_is_same_set(cur_edge->v2, edge->v2)){
          flag = 1;
          break;
        }
        if(node_is_same_set(cur_edge->v1, edge->v2) && node_is_same_set(cur_edge->v2, edge->v1)){
          flag = 1;
          break;
        }
      }
      (*mst_val) += cur_edge->weight;
      mst_edge_count++;
      node_union(cur_edge->v1, cur_edge->v2);
    }
  }
  if(mst_edge_count!=graph->node_num-1) return NONE;
  if(flag) return PLURAL;
  return UNIQUE;
}
int graph_count_set(Graph* graph){
  int res = 0;
  for(int i=0; i<graph->node_num; i++){
    if(graph->nodes[i]->parent==graph->nodes[i]) res++;
  }
  return res;
}

int main(int argc, char *argv[]){
  int node_num, edge_num;
  scanf("%d %d", &node_num, &edge_num);
  Graph* graph = graph_init(node_num, edge_num);
  for(int i=0; i<edge_num; i++){
    int v1, v2, weight;
    scanf("%d %d %d", &v1, &v2, &weight);
    graph_insert_edge(graph, i, v1, v2, weight);
  }
  merge_sort_edge(graph);
  int mst_val = 0;
  ResType res = kruskal(graph, &mst_val);
  switch (res) {
    case UNIQUE:
      printf("%d\nYes\n", mst_val);
      break;
    case PLURAL:
      printf("%d\nNo\n", mst_val);
      break;
    case NONE:
      printf("No MST\n%d\n", graph_count_set(graph));
      break;
    default:
      break;
  }
  return 0;
}
```
