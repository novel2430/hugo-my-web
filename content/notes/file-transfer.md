---
title: 'File Transfer'
date: 2024-02-13T18:44:00+08:00
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
# 7-1 File Transfer
We have a network of computers and a list of bi-directional connections. Each of these connections allows a file transfer from one computer to another. Is it possible to send a file from any computer on the network to any other?
## Input Specification:
Each input file contains one test case. For each test case, the first line contains N (2≤N≤10<sup>4</sup>), the total number of computers in a network. Each computer in the network is then represented by a positive integer between 1 and N. Then in the following lines, the input is given in the format:
```
I c1 c2
```
where `I` stands for inputting a connection between `c1` and `c2`; or
```
C c1 c2
```
where `C` stands for checking if it is possible to transfer files between `c1` and `c2`; or
```
S
```
where `S` stands for stopping this case.
## Output Specification:
For each `C` case, print in one line the word "yes" or "no" if it is possible or impossible to transfer files between `c1` and `c2`, respectively. At the end of each case, print in one line "The network is connected." if there is a path between any pair of computers; or "There are `k` components." where `k` is the number of connected components in this network.
## Sample Input 1:
```
5
C 3 2
I 3 2
C 1 5
I 4 5
I 2 4
C 3 5
S
```
## Sample Output 1:
```
no
no
yes
There are 2 components.
```
## Sample Input 2:
```
5
C 3 2
I 3 2
C 1 5
I 4 5
I 2 4
C 3 5
I 1 3
C 1 5
S
```
## Sample Output 2:
```
no
no
yes
yes
The network is connected.
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

#define true 1
#define false 0

typedef struct Node{
  struct Node* parent;
}Node ;

// Node op
Node* node_init(){
  Node* res = (Node*)malloc(sizeof(Node));
  res->parent = res;
  return res;
}
Node* node_check_father(Node* node){
  if(node->parent == node) return node;
  node->parent = node_check_father(node->parent);
  return node->parent;
}
Node* node_check_father_non_recursice(Node* node){
  // find root
  Node* root = node;
  while(root->parent!=root) root = root->parent;
  // set root
  Node* cur = node;
  while(cur!=root){
    Node* tmp = cur->parent;
    cur->parent = root;
    cur = tmp;
  }
  return root;
}
void node_build_connect(Node* n1, Node* n2){
  if(n1==NULL || n2==NULL) return;
  node_check_father(n1)->parent = node_check_father(n2);
}
int node_is_connect(Node* n1, Node* n2){
  Node* n1_father = node_check_father(n1);
  Node* n2_father = node_check_father(n2);
  if(n1_father==n2_father) return true;
  return false;
}

int count_components(Node** nodes, int size){
  int count = 0;
  for(int i=0; i<size; i++){
    if(nodes[i]->parent==nodes[i]) count++;
  }
  return count;
}

int main(int argc, char *argv[]){
  int size;
  scanf("%d", &size);
  Node* nodes[size];
  for(int i=0; i<size; i++) nodes[i] = node_init();
  while(1){
    getchar();
    char op;
    scanf("%c", &op);
    if(op=='S') break;
    int n1, n2;
    scanf("%d %d", &n1, &n2);
    if(op=='C'){
      if(node_is_connect(nodes[n1-1], nodes[n2-1])){
        printf("yes\n");
      }
      else printf("no\n");
    }
    else if(op=='I'){
      node_build_connect(nodes[n1-1], nodes[n2-1]);
    }
  }
  int count = count_components(nodes, size);
  if(count==1) printf("The network is connected.\n");
  else printf("There are %d components.\n", count);
}
```
