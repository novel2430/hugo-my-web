---
title: 'Complete Binart Search Tree'
date: 2024-02-13T18:41:08+08:00
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
# 7-1 Complete Binary Search Tree
A Binary Search Tree (BST) is recursively defined as a binary tree which has the following properties:
- The left subtree of a node contains only nodes with keys less than the node's key.
- The right subtree of a node contains only nodes with keys greater than or equal to the node's key.
- Both the left and right subtrees must also be binary search trees.
A Complete Binary Tree (CBT) is a tree that is completely filled, with the possible exception of the bottom level, which is filled from left to right.

Now given a sequence of distinct non-negative integer keys, a unique BST can be constructed if it is required that the tree must also be a CBT. You are supposed to output the level order traversal sequence of this BST.
## Input Specification:
Each input file contains one test case. For each case, the first line contains a positive integer N (≤1000). Then N distinct non-negative integer keys are given in the next line. All the numbers in a line are separated by a space and are no greater than 2000.
## Output Specification:
For each test case, print in one line the level order traversal sequence of the corresponding complete binary search tree. All the numbers in a line must be separated by a space, and there must be no extra space at the end of the line.
## Sample Input:
```
10
1 2 3 4 5 6 7 8 9 0
```
## Sample Output:
```
6 3 8 1 5 7 9 0 2 4
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

// Merge Sort
void merge_sort_help(int* arr, int* tmp, int low_idx, int high_idx){
  if(low_idx>=high_idx) return;
  int mid = (low_idx + high_idx)/2;
  merge_sort_help(arr, tmp, low_idx, mid);
  merge_sort_help(arr, tmp, mid+1, high_idx);
  int start1 = low_idx;
  int end1 = mid;
  int start2 = mid+1;
  int end2 = high_idx;
  int cur_idx = start1;
  while(cur_idx<=high_idx){
    if(arr[start1] < arr[start2] && start1<=end1){
      tmp[cur_idx] = arr[start1++];
    }
    else if(arr[start1] >= arr[start2] && start2<=end2){
      tmp[cur_idx] = arr[start2++]; 
    }
    else if (start1>end1) {
      tmp[cur_idx] = arr[start2++]; 
    }
    else if (start2>end2) {
      tmp[cur_idx] = arr[start1++];
    }
    cur_idx++;
  }
  for(int i=low_idx; i<=high_idx; i++){
    arr[i] = tmp[i];
  }
}
void merge_sort(int* arr, int size){
  int* tmp = (int*)malloc(sizeof(int)*size);
  merge_sort_help(arr, tmp, 0, size-1);
}

// Build Tree Layer print
void get_tree_layer_help(int* inorder, int n, int size, int* cur_idx, int* layer){
  if(n>=size) return;
  get_tree_layer_help(inorder, 2*n+1, size, cur_idx, layer);
  layer[n] = inorder[(*cur_idx)++];
  get_tree_layer_help(inorder, 2*(n+1), size, cur_idx, layer);
}
int* get_tree_layer(int* inorder, int size){
  int* tmp = (int*)malloc(sizeof(int)*size);
  int base_idx = 0;
  get_tree_layer_help(inorder, 0, size, &base_idx, tmp);
  return tmp;
}

int main(int argc, char *argv[]){
  int count;
  scanf("%d", &count);
  int nums[count];
  for(int i=0; i<count; i++) scanf("%d", &nums[i]);
  merge_sort(nums, count);
  int* res = get_tree_layer(nums, count);
  for(int i=0; i<count; i++){
    if(i>0) printf(" ");
    printf("%d", res[i]);
  }
  return 0;
}
```
