---
title: 'Isomorphic'
date: 2024-02-13T18:10:24+08:00
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
# 6-1 Isomorphic
Two trees, `T1` and `T2`, are isomorphic if `T1` can be transformed into `T2` by swapping left and right children of (some of the) nodes in `T1`. For instance, the two trees in Figure 1 are isomorphic because they are the same if the children of A, B, and G, but not the other nodes, are swapped. Give a polynomial time algorithm to decide if two trees are isomorphic.

![image](https://github.com/novel2430/ZJU-2023-FDS/blob/main/ZJUFDS_2023_HW4/6-1-Isomorphic/001.jpg?raw=true)

## Format of functions:
```c
int Isomorphic( Tree T1, Tree T2 );
```
where `Tree` is defined as the following:
```c
typedef struct TreeNode *Tree;
struct TreeNode {
    ElementType Element;
    Tree  Left;
    Tree  Right;
};
```
The function is supposed to return 1 if `T1` and `T2` are indeed isomorphic, or 0 if not.
## Sample program of judge:
```c
#include <stdio.h>
#include <stdlib.h>

typedef char ElementType;

typedef struct TreeNode *Tree;
struct TreeNode {
    ElementType Element;
    Tree  Left;
    Tree  Right;
};

Tree BuildTree(); /* details omitted */

int Isomorphic( Tree T1, Tree T2 );

int main()
{
    Tree T1, T2;
    T1 = BuildTree();
    T2 = BuildTree();
    printf(“%d\n”, Isomorphic(T1, T2));
    return 0;
}

/* Your function will be put here */

```
## Sample Output 1 (for the trees shown in Figure 1):
```
1
```
## Sample Output 2 (for the trees shown in Figure 2):
```
0
```
![image](https://github.com/novel2430/ZJU-2023-FDS/blob/main/ZJUFDS_2023_HW4/6-1-Isomorphic/002.jpg?raw=true)
## Note
main part : check each node's children situation
## Code
```c
#include <stdio.h>
#include <stdlib.h>

typedef char ElementType;

typedef struct TreeNode *Tree;
struct TreeNode {
    ElementType Element;
    Tree  Left;
    Tree  Right;
};

Tree BuildTree(); /* details omitted */

int Isomorphic( Tree T1, Tree T2 );

int checkValue(Tree n1, Tree n2){
  if(n1!=NULL && n2!=NULL && n1->Element==n2->Element) return 1;
  if(n1==NULL && n2==NULL) return 1;
  return 0;
}
int checkChild(Tree n1, Tree n2){
  Tree n1_left = n1->Left;
  Tree n1_right = n1->Right;
  Tree n2_left = n2->Left;
  Tree n2_right = n2->Right;
  if(checkValue(n1_left, n2_left) && checkValue(n1_right, n2_right)) return 1; // same
  if(checkValue(n1_left, n2_right) && checkValue(n1_right, n2_left)) return 2; // same with swap
  return 0; // not same
}
int Isomorphic_help( Tree T1, Tree T2 ){
  if(T1==NULL && T2==NULL) return 1;
  int situation = checkChild(T1, T2);
  if(situation==1){
    int r1 = Isomorphic_help(T1->Left, T2->Left);
    int r2 = Isomorphic_help(T1->Right, T2->Right);
    return r1*r2;
  }
  else if(situation==2){
    int r1 = Isomorphic_help(T1->Left, T2->Right);
    int r2 = Isomorphic_help(T1->Right, T2->Left);
    return r1*r2;
  }
  else{
    return 0;
  }
}
int Isomorphic( Tree T1, Tree T2 ){
  int res = checkValue(T1, T2);
  if(res==0) return 0;
  return Isomorphic_help(T1, T2);
}

int main()
{
    Tree T1, T2;
    /* T1 = BuildTree(); */
    /* T2 = BuildTree(); */
    printf("%d\n", Isomorphic(T1, T2));
    return 0;
}

/* Your function will be put here */
```
