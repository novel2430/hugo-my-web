---
title: 'Queue Using Two Stacks'
date: 2024-02-14T01:46:47+08:00
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
# 7-1 Queue Using Two Stacks
A queue (FIFO structure) can be implemented by two stacks (LIFO structure) in the following way:

1. Start from two empty stacks s<sub>1</sub> and s<sub>2</sub>

2. When element `e` is enqueued, it is actually pushed onto s<sub>1</sub>

3. When we are supposed to dequeue, s<sub>2</sub> is checked first. If s<sub>2</sub> is empty, everything in s<sub>1</sub> will be transferred to s<sub>2</sub> by popping from s<sub>1</sub> and immediately pushing onto s<sub>2</sub>. Then we just pop from s<sub>2</sub> -- the top element of s<sub>2</sub> must be the first one to enter s<sub>1</sub> thus is the first element that was enqueued.

Assume that each operation of push or pop takes 1 unit of time. You job is to tell the time taken for each dequeue.
## Input Specification:
Each input file contains one test case. For each case, the first line gives a positive integer `N` (≤10<sup>3</sup>), which are the number of operations. Then `N` lines follow, each gives an operation in the format
```
Operation Element
```
where `Operation` being `I` represents enqueue and `O` represents dequeue. For each `I`, `Element` is a positive integer that is no more than 10<sup>6</sup>. No `Element` is given for `O` operations.

It is guaranteed that there is at least one `O` operation.
## Output Specification:
For each dequeue operation, print in a line the dequeued element and the unites of time taken to do this dequeue. The numbers in a line must be separated by 1 space, and there must be no extra space at the beginning or the end of the line.

In case that the queue is empty when dequeue is called, output in a line `ERROR` instead.
## Sample Input:
```
10
I 20
I 32
O
I 11
O
O
O
I 100
I 66
O
```
## Sample Output:
```
20 5
32 1
11 3
ERROR
100 5
```
## Code
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
}my_stack;
typedef struct my_queue {
  my_stack* stack1;
  my_stack* stack2;
  int op_count;
}my_queue;

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

// Queue op
my_queue* queue_init(){
  my_queue* res = (my_queue*)malloc(sizeof(my_queue));
  res->stack1 = stack_init();
  res->stack2 = stack_init();
  res->op_count = 0;
  return res;
}
void queue_delete(my_queue* queue){
  if(queue == NULL) return;
  stack_delete(queue->stack1);
  stack_delete(queue->stack2);
  free(queue);
  queue = NULL;
}
void queue_push(my_queue* queue, int num){
  stack_push(queue->stack1, num);
}
int queue_pop(my_queue* queue){
  queue->op_count = 0;
  if(stack_is_empty(queue->stack1) && stack_is_empty(queue->stack2))
    return -1;
  if(stack_is_empty(queue->stack2)){
    queue->op_count = queue->stack1->head->values*2;
    while(!stack_is_empty(queue->stack1)){
      stack_push(queue->stack2, stack_pop(queue->stack1));
    }
  }
  queue->op_count++;
  return stack_pop(queue->stack2);
}

int main(){
  int op_counts = 0;
  my_queue* queue = queue_init();
  scanf("%d", &op_counts);
  int print_count = 0;
  for(int i=0; i<op_counts; i++){
    /* printf("Time : %d\n",i); */
    getchar();
    char op;
    scanf("%c", &op);
    if(op=='I'){
      int num;
      scanf("%d", &num);
      queue_push(queue, num);
    }
    else if(op=='O'){
      int num = queue_pop(queue);
      if(num==-1){
        if(print_count>0) printf("\nERROR");
        else printf("ERROR");
      }
      else {
        if(print_count>0)
          printf("\n%d %d",num, queue->op_count);
        else
          printf("%d %d",num, queue->op_count);
      }
      print_count++;
    }
  } 

  queue_delete(queue);
  return 0;
}
```
