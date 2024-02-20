---
title: 'Insertion or Heap Sort'
date: 2024-02-14T01:28:32+08:00
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
# 7-1 Insertion or Heap Sort
According to Wikipedia:

**Insertion sort** iterates, consuming one input element each repetition, and growing a sorted output list. Each iteration, insertion sort removes one element from the input data, finds the location it belongs within the sorted list, and inserts it there. It repeats until no input elements remain.

**Heap sort** divides its input into a sorted and an unsorted region, and it iteratively shrinks the unsorted region by extracting the largest element and moving that to the sorted region. it involves the use of a heap data structure rather than a linear-time search to find the maximum.

Now given the initial sequence of integers, together with a sequence which is a result of several iterations of some sorting method, can you tell which sorting method we are using?
## Input Specification:
Each input file contains one test case. For each case, the first line gives a positive integer N (≤100). Then in the next line, N integers are given as the initial sequence. The last line contains the partially sorted sequence of the N numbers. It is assumed that the target sequence is always ascending. All the numbers in a line are separated by a space.
## Output Specification:
For each test case, print in the first line either "Insertion Sort" or "Heap Sort" to indicate the method used to obtain the partial result. Then run this method for one more iteration and output in the second line the resulting sequence. It is guaranteed that the answer is unique for each test case. All the numbers in a line must be separated by a space, and there must be no extra space at the end of the line.
## Sample Input 1:
```
10
3 1 2 8 7 5 9 4 6 0
1 2 3 7 8 5 9 4 6 0
```
## Sample Output 1:
```
Insertion Sort
1 2 3 5 7 8 9 4 6 0
```
## Sample Input 2:
```
10
3 1 2 8 7 5 9 4 6 0
6 4 5 1 0 3 2 7 8 9
```
## Sample Output 2:
```
Heap Sort
5 4 3 1 0 2 6 7 8 9
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

#define MAXN 1000

typedef enum SortType{
  INSERTION,
  HEAP
}SortType ;

SortType get_sort_type(int* arr, int* orig, int size){
  if(arr[0]<arr[1]) return INSERTION;
  return HEAP;
}
void swap(int* arr, int idx1, int idx2){
  int tmp = arr[idx1];
  arr[idx1] = arr[idx2];
  arr[idx2] = tmp;
}
int max_idx(int* arr, int idx1, int idx2){
  if(arr[idx1]>arr[idx2]) return idx1;
  return idx2;
}
void do_sort(SortType type, int* arr, int size){
  if(type==INSERTION){
    int idx = 0;
    for(int i=0; i<size-1; i++){
      if(arr[i]>arr[i+1]){
        idx = i+1;
        break;
      }
    }
    for(int i=idx; i>0; i--){
      if(arr[i]<arr[i-1]){
        swap(arr, i, i-1);
      }
    }
  }
  else{
    int max = arr[0];
    int heap_size = 0;
    for(int i=0; i<size; i++){
      if(arr[i]>max){
        heap_size = i;
        break;
      }
    }
    heap_size--;
    swap(arr, 0, heap_size);
    for(int start=0, next=start; start*2+1<heap_size; start=next){
      if(2*(start+1) < heap_size){
        next = max_idx(arr, start*2+1, 2*(start+1));
      }
      else{
        next = start*2 + 1;
      }
      if(arr[start]>arr[next]) break;
      swap(arr, start, next);
    }
  }
  for(int i=0; i<size; i++){
    if(i>0) printf(" ");
    printf("%d", arr[i]);
    if(i==size-1) printf("\n");
  }
}

int main(int argc, char *argv[]){
  int size;
  int arr[MAXN];
  int orig[MAXN];
  scanf("%d", &size);
  for(int i=0; i<size; i++){
    scanf("%d", &orig[i]);
  }
  for(int i=0; i<size; i++){
    scanf("%d", &arr[i]);
  }
  switch(get_sort_type(arr, orig, size)){
    case INSERTION:
      printf("Insertion Sort\n");
      do_sort(INSERTION, arr, size);
      break;
    case HEAP:
      printf("Heap Sort\n");
      do_sort(HEAP, arr, size);
      break;
    default:
      break;
  }
  return 0;
}
```
