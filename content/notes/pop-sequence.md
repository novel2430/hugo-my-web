---
title: 'Pop Sequence'
date: 2024-02-13T18:05:37+08:00
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
# 7-1 Pop Sequence
Given a stack which can keep `M` numbers at most. Push `N` numbers in the order of 1, 2, 3, ..., N and pop randomly. You are supposed to tell if a given sequence of numbers is a possible pop sequence of the stack. For example, if `M` is 5 and `N` is 7, we can obtain 1, 2, 3, 4, 5, 6, 7 from the stack, but not 3, 2, 1, 7, 5, 6, 4.
## Input Specification:
Each input file contains one test case. For each case, the first line contains 3 numbers (all no more than 1000): `M` (the maximum capacity of the stack), `N` (the length of push sequence), and `K` (the number of pop sequences to be checked). Then `K` lines follow, each contains a pop sequence of `N` numbers. All the numbers in a line are separated by a space.
## Output Specification:
For each pop sequence, print in one line `YES` if it is indeed a possible pop sequence of the stack, or `NO` if not.
## Sample Input:
```
5 7 5
1 2 3 4 5 6 7
3 2 1 7 5 6 4
7 6 5 4 3 2 1
5 6 4 3 7 2 1
1 7 6 5 4 3 2
```
## Sample Output:
```
YES
NO
NO
YES
NO
```
## Code:
```c
#include <stdio.h>
#include <stdlib.h>

// Basic Struct
typedef struct stack_node{
  int values;
  struct stack_node* next;
  struct stack_node* before;
}stack_node;
typedef struct my_stack {
  stack_node* head;
  stack_node* top;
}my_stack ;

// Node op
stack_node* node_init(int num){
  stack_node* node = (stack_node*)malloc(sizeof(stack_node));
  node->values = num;
  node->next = NULL;
  node->before = NULL;
  return node;
}
void node_delete(stack_node* node){
  if(node==NULL) return;
  free(node);
  node = NULL;
}

// Stack op
my_stack* stack_init(){
  my_stack* res = (my_stack*)malloc(sizeof(my_stack));
  res->head = node_init(0);
  res->top = res->head;
  return res;
}
void stack_delete(my_stack* stack){
  if(stack==NULL) return;
  stack_node* cur = stack->head;
  while(cur != NULL){
    stack_node* next_node = cur->next;
    node_delete(cur);
    cur = next_node;
  }
  free(stack);
  stack = NULL;
}
void stack_push(my_stack* stack, int num){
  stack->head->values++;
  stack_node* node = node_init(num);
  stack->top->next = node;
  node->before = stack->top;
  stack->top = node;
}
int stack_pop(my_stack* stack){
  stack->head->values--;
  int res = stack->top->values;
  stack_node* old_top = stack->top;
  stack_node* new_top = stack->top->before;
  node_delete(old_top);
  stack->top = new_top;
  stack->top->next = NULL;
  return res;
}
int stack_is_empty(my_stack* stack){
  if(stack==NULL || stack->head!=stack->top){
    return 0;
  }
  return 1;
}

int main(){
  int max_length, max_num, seq_count;
  scanf("%d %d %d", &max_length, &max_num, &seq_count);
  // build test
  int test[seq_count][max_num];
  for(int i=0; i<seq_count; i++){
    for(int j=0; j<max_num; j++){
      int cur_num;
      scanf("%d", &cur_num);
      test[i][j] = cur_num;
    }
  }
  // do test
  for(int i=0; i<seq_count; i++){
    my_stack* stack = stack_init();
    int idx = 1;
    for(int j=0; j<max_num; j++){
      int now_num = test[i][j];
      for(;idx<=now_num && stack->head->values<max_length; idx++){
        stack_push(stack, idx);
      }
      if(stack->top!=stack->head && stack->top->values==now_num){
        stack_pop(stack);
      }
      else break;
    }
    if(i>0) printf("\n");
    if(stack_is_empty(stack)) printf("YES");
    else printf("NO");
    stack_delete(stack);
  }
}
```
