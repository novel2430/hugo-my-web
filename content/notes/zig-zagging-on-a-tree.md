---
title: 'Zig Zagging on a Tree'
date: 2024-02-13T18:15:29+08:00
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
# 7-1 ZigZagging on a Tree
Suppose that all the keys in a binary tree are distinct positive integers. A unique binary tree can be determined by a given pair of postorder and inorder traversal sequences. And it is a simple standard routine to print the numbers in level-order. However, if you think the problem is too simple, then you are too naive. This time you are supposed to print the numbers in "zigzagging order" -- that is, starting from the root, print the numbers level-by-level, alternating between left to right and right to left. For example, for the following tree you must output: 1 11 5 8 17 12 20 15.

![image](https://images.ptausercontent.com/337cbfb0-a7b2-4500-9664-318e9ffc870e.jpg)
## Input Specification:
Each input file contains one test case. For each case, the first line gives a positive integer N (≤30), the total number of nodes in the binary tree. The second line gives the inorder sequence and the third line gives the postorder sequence. All the numbers in a line are separated by a space.
## Output Specification:
For each test case, print the zigzagging sequence of the tree in a line. All the numbers in a line must be separated by exactly one space, and there must be no extra space at the end of the line.
## Sample Input:
```
8
12 11 20 17 1 15 8 5
12 20 17 11 15 8 5 1
```
## Sample Output:
```
1 11 5 8 17 12 20 15
```
## Note
2 part

1. Build tree by inorder/preorder or inorder/postorder
2. zig-zag print tree
### build tree
```c
TreeNode* build_tree(int* inorder, int* postorder, int length){
  if(length==0) return NULL;
  int root_val = postorder[length-1];
  TreeNode* res = tree_node_init(root_val);
  int idx = 0;
  // find root idx in inorder seq
  for(int i=0; i<length; i++){
    if(inorder[i] == root_val){
      idx = i;
      break;
    }
  }
  // split old seq to new seq (go left)
  int new_inorder[30];
  int new_postorder[30];
  for(int i=0; i<idx; i++) {
    new_inorder[i] = inorder[i];
    new_postorder[i] = postorder[i];
  }
  res->left = build_tree(new_inorder, new_postorder, idx);
  // split old seq to new seq (go rigth)
  for(int i=0; i+idx+1<length; i++) {
    new_inorder[i] = inorder[i+idx+1];
  }
  for(int i=0; i+idx<length-1; i++){
    new_postorder[i] = postorder[i+idx];
  }
  res->right = build_tree(new_inorder, new_postorder, length-idx-1);
  return res; 
}
```
### zig-zag
use 2 stack
```c
void tree_zig_zag_print(Tree* tree){
  if(tree==NULL || tree->top==NULL) return;
  my_stack* stack = stack_init(); 
  my_stack* stack_2 = stack_init(); 
  stack_push(stack, tree->top);
  int flag = 0;
  // stop when 2 stack all empty
  while(!stack_is_empty(stack) || !stack_is_empty(stack_2)){
    // stack1 pop, and push in stack2
    while(!stack_is_empty(stack)){
      TreeNode* cur = stack_pop(stack);
      if(flag++ > 0) printf(" ");
      printf("%d", cur->value);
      if(cur->right != NULL)
        stack_push(stack_2, cur->right);
      if(cur->left != NULL)
        stack_push(stack_2, cur->left);
    }
    // stack2 pop, and push in stack1
    while(!stack_is_empty(stack_2)){
      TreeNode* cur = stack_pop(stack_2);
      printf(" %d", cur->value);
      if(cur->left != NULL)
        stack_push(stack, cur->left);
      if(cur->right != NULL)
        stack_push(stack, cur->right);
    }
  }
  stack_delete(stack);
  stack_delete(stack_2);
}
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

// Tree
typedef struct TreeNode{
  int value;
  struct TreeNode* left;
  struct TreeNode* right;
} TreeNode ;
typedef struct Tree {
  TreeNode* top;
} Tree ;

// Stack
typedef struct stack_node{
  TreeNode* values;
  struct stack_node* next;
  struct stack_node* before;
}stack_node;
typedef struct my_stack {
  stack_node* head;
  stack_node* top;
}my_stack;

// Stack & Stack Node op
stack_node* node_init(TreeNode* val){
  stack_node* node = (stack_node*)malloc(sizeof(stack_node));
  node->values = val;
  node->next = NULL;
  node->before = NULL;
  return node;
}
void node_delete(stack_node* node){
  if(node==NULL) return;
  free(node);
  node = NULL;
}
my_stack* stack_init(){
  my_stack* res = (my_stack*)malloc(sizeof(my_stack));
  res->head = node_init(NULL);
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
void stack_push(my_stack* stack, TreeNode* val){
  stack_node* node = node_init(val);
  stack->top->next = node;
  node->before = stack->top;
  stack->top = node;
}
TreeNode* stack_pop(my_stack* stack){
  TreeNode* res = stack->top->values;
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

// Tree & Tree Node op
TreeNode* tree_node_init(int num){
  TreeNode* res = (TreeNode*)malloc(sizeof(TreeNode));
  res->value = num;
  res->left = NULL;
  res->right = NULL;
  return res;
}
void tree_node_delete(TreeNode* node){
  if(node == NULL) return;
  free(node);
  node = NULL;
}
Tree* tree_init(){
  Tree* res = (Tree*)malloc(sizeof(Tree));
  res->top = NULL;
  return res;
}
void tree_delete_help(TreeNode* node){
  if(node == NULL) return;
  tree_delete_help(node->left);
  tree_delete_help(node->right);
  free(node);
  node = NULL;
}
void tree_delete(Tree* tree){
  if(tree==NULL) return;
  TreeNode* cur = tree->top;
  tree_delete_help(cur);
}
void tree_zig_zag_print(Tree* tree){
  if(tree==NULL || tree->top==NULL) return;
  my_stack* stack = stack_init(); 
  my_stack* stack_2 = stack_init(); 
  stack_push(stack, tree->top);
  int flag = 0;
  while(!stack_is_empty(stack) || !stack_is_empty(stack_2)){
    while(!stack_is_empty(stack)){
      TreeNode* cur = stack_pop(stack);
      if(flag++ > 0) printf(" ");
      printf("%d", cur->value);
      if(cur->right != NULL)
        stack_push(stack_2, cur->right);
      if(cur->left != NULL)
        stack_push(stack_2, cur->left);
    }
    while(!stack_is_empty(stack_2)){
      TreeNode* cur = stack_pop(stack_2);
      printf(" %d", cur->value);
      if(cur->left != NULL)
        stack_push(stack, cur->left);
      if(cur->right != NULL)
        stack_push(stack, cur->right);
    }
  }
  stack_delete(stack);
  stack_delete(stack_2);
}
TreeNode* build_tree(int* inorder, int* postorder, int length){
  if(length==0) return NULL;
  int root_val = postorder[length-1];
  TreeNode* res = tree_node_init(root_val);
  int idx = 0;
  for(int i=0; i<length; i++){
    if(inorder[i] == root_val){
      idx = i;
      break;
    }
  }
  int new_inorder[30];
  int new_postorder[30];
  for(int i=0; i<idx; i++) {
    new_inorder[i] = inorder[i];
    new_postorder[i] = postorder[i];
  }
  res->left = build_tree(new_inorder, new_postorder, idx);
  for(int i=0; i+idx+1<length; i++) {
    new_inorder[i] = inorder[i+idx+1];
  }
  for(int i=0; i+idx<length-1; i++){
    new_postorder[i] = postorder[i+idx];
  }
  res->right = build_tree(new_inorder, new_postorder, length-idx-1);
  return res; 
}

int main(){
  Tree* tree = tree_init();
  int node_num;
  scanf("%d", &node_num);
  int inorder[31];
  int postorder[31];
  for(int i=0; i<node_num; i++){
    scanf("%d", &inorder[i]);
  }
  for(int i=0; i<node_num; i++){
    scanf("%d", &postorder[i]);
  }
  tree->top = build_tree(inorder, postorder, node_num);
  tree_zig_zag_print(tree);
  tree_delete(tree);
}
```
