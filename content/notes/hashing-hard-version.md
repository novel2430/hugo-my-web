---
title: 'Hashing Hard Version'
date: 2024-02-14T01:30:02+08:00
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
# 7-1 Hashing - Hard Version
Given a hash table of size N, we can define a hash function `H(x)=x%N`. Suppose that the linear probing is used to solve collisions, we can easily obtain the status of the hash table with a given sequence of input numbers.  
However, now you are asked to solve the reversed problem: reconstruct the input sequence from the given status of the hash table. Whenever there are multiple choices, the smallest number is always taken.
## Input Specification:
Each input file contains one test case. For each test case, the first line contains a positive integer N (≤1000), which is the size of the hash table. The next line contains N integers, separated by a space. A negative integer represents an empty cell in the hash table. It is guaranteed that all the non-negative integers are distinct in the table.
## Output Specification:
For each test case, print a line that contains the input sequence, with the numbers separated by a space. Notice that there must be no extra space at the end of each line.
## Sample Input:
```
11
33 1 13 12 34 38 27 22 32 -1 21
```
## Sample Output:
```
1 13 12 21 33 34 38 27 22 32
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

#define MAXN 1000
typedef enum Boolean {FALSE, TRUE} Boolean ;

typedef struct Node{
  int value;
  int before_count;
  int after_count;
  struct Node* after[MAXN];
}Node ;

typedef struct Heap{
  int size;
  Node* nodes[MAXN];
}Heap ;

Node* node_init(int value){
  Node* res = (Node*)malloc(sizeof(Node));
  res->value = value;
  res->after_count = 0;
  res->before_count = 0;
  return res;
}
void node_delete(Node* node){
  if(node==NULL) return;
  free(node);
  node = NULL;
}
void node_add_after(Node* cur, Node* after){
  if(cur==NULL || after==NULL) return;
  cur->after[cur->after_count] = after;
  cur->after_count++;
  after->before_count++;
}

Heap* heap_init(){
  Heap* res = (Heap*)malloc(sizeof(Heap));
  res->size = 0;
  return res;
}
void heap_delete(Heap* heap){
  if(heap==NULL) return;
  for(int i=0; i<heap->size; i++)
    node_delete(heap->nodes[i]);
  free(heap);
  heap = NULL;
}
Boolean heap_is_empty(Heap* heap){
  if(heap->size==0) return TRUE;
  return FALSE;
}
int min_idx(Heap* heap, int idx1, int idx2){
  if(heap->nodes[idx1]->value < heap->nodes[idx2]->value) return idx1;
  return idx2;
}
void swap(Heap* heap, int idx1, int idx2){
  Node* tmp = heap->nodes[idx1];
  heap->nodes[idx1] = heap->nodes[idx2];
  heap->nodes[idx2] = tmp;
}
void heap_insert(Heap* heap, Node* node){
  if(heap==NULL || node==NULL) return;
  heap->nodes[heap->size] = node;
  for(int i=heap->size; i>0; i=(i-1)/2){
    Node* cur = heap->nodes[i];
    Node* father = heap->nodes[(i-1)/2];
    if(cur->value >= father->value) break;
    swap(heap, i, (i-1)/2);
  }
  heap->size++;
}
Node* heap_pop(Heap* heap){
  if(heap==NULL || heap->size==0) return NULL;
  heap->size--;
  Node* res = heap->nodes[0];
  swap(heap, 0, heap->size);
  int next = 0;
  for(int i=0; i*2+1<heap->size; i=next){
    if(i*2+2 < heap->size) next = min_idx(heap, i*2+1, i*2+2);
    else next = i*2+1;
    if(heap->nodes[i]->value <= heap->nodes[next]->value) break;
    swap(heap, i, next);
  }
  return res;
}

void build_node_reletions(Node* nodes[MAXN], int size){
  for(int i=0; i<size; i++){
    Node* cur = nodes[i];
    if(cur==NULL) continue;
    int dist = i - cur->value%size;
    if(dist < 0) dist = size + dist;
    for(int ii=cur->value%size; ii<(cur->value%size)+dist; ii++){
      int idx = ii%size;
      node_add_after(nodes[idx], cur);
    }
  }
}
void build_input_seq(Node* nodes[MAXN], int size){
  Heap* heap = heap_init();
  for(int i=0; i<size; i++){
    if(nodes[i]==NULL) continue;
    if(nodes[i]->before_count==0) heap_insert(heap, nodes[i]);
  }
  int count = 0;
  while(!heap_is_empty(heap)){
    Node* cur = heap_pop(heap);
    for(int i=0; i<cur->after_count; i++){
      cur->after[i]->before_count--;
      if(cur->after[i]->before_count==0) heap_insert(heap, cur->after[i]);
    }
    if(count > 0) printf(" ");
    printf("%d", cur->value);
    count++;
  }
  heap_delete(heap);
}

int main(int argc, char *argv[]){
  int size;
  Node* nodes[MAXN];
  scanf("%d", &size);
  for(int i=0; i<size; i++){
    int tmp;
    scanf("%d", &tmp);
    if(tmp<0) nodes[i] = NULL;
    else nodes[i] = node_init(tmp);
  }
  build_node_reletions(nodes, size);
  build_input_seq(nodes, size);
  return 0;
}
```
