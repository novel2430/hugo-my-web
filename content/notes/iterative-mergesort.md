---
title: 'Iterative Mergesort'
date: 2024-02-14T01:26:20+08:00
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
# 6-1 Iterative Mergesort
How would you implement mergesort without using recursion?

The idea of iterative mergesort is to start from N sorted sublists of length 1, and each time to merge a pair of adjacent sublists until one sorted list is obtained. You are supposed to implement the key function of merging.
## Format of functions:
```c
void merge_pass( ElementType list[], ElementType sorted[], int N, int length );
```
The function `merge_pass` performs one pass of the merge sort that merges adjacent pairs of sublists from `list` into `sorted`. `N` is the number of elements in the `list` and length is the `length` of the sublists.
## Sample program of judge:
```c
#include <stdio.h>

#define ElementType int
#define MAXN 100

void merge_pass( ElementType list[], ElementType sorted[], int N, int length );

void output( ElementType list[], int N )
{
    int i;
    for (i=0; i<N; i++) printf("%d ", list[i]);
    printf("\n");
}

void  merge_sort( ElementType list[],  int N )
{
    ElementType extra[MAXN];  /* the extra space required */
    int  length = 1;  /* current length of sublist being merged */
    while( length < N ) { 
        merge_pass( list, extra, N, length ); /* merge list into extra */
        output( extra, N );
        length *= 2;
        merge_pass( extra, list, N, length ); /* merge extra back to list */
        output( list, N );
        length *= 2;
    }
} 


int main()
{
    int N, i;
    ElementType A[MAXN];

    scanf("%d", &N);
    for (i=0; i<N; i++) scanf("%d", &A[i]);
    merge_sort(A, N);
    output(A, N);

    return 0;
}

/* Your function will be put here */

```
## Sample Input:
```
10
8 7 9 2 3 5 1 6 4 0
```
## Sample Output:
```
7 8 2 9 3 5 1 6 0 4 
2 7 8 9 1 3 5 6 0 4 
1 2 3 5 6 7 8 9 0 4 
0 1 2 3 4 5 6 7 8 9 
0 1 2 3 4 5 6 7 8 9
```
## Code
```c
#include <stdio.h>

#define ElementType int
#define MAXN 100

void merge_pass( ElementType list[], ElementType sorted[], int N, int length );

void output( ElementType list[], int N )
{
    int i;
    for (i=0; i<N; i++) printf("%d ", list[i]);
    printf("\n");
}

void  merge_sort( ElementType list[],  int N )
{
    ElementType extra[MAXN];  /* the extra space required */
    int  length = 1;  /* current length of sublist being merged */
    while( length < N ) { 
        merge_pass( list, extra, N, length ); /* merge list into extra */
        output( extra, N );
        length *= 2;
        merge_pass( extra, list, N, length ); /* merge extra back to list */
        output( list, N );
        length *= 2;
    }
} 


int main()
{
    int N, i;
    ElementType A[MAXN];

    scanf("%d", &N);
    for (i=0; i<N; i++) scanf("%d", &A[i]);
    merge_sort(A, N);
    output(A, N);

    return 0;
}

/* Your function will be put here */
int min(int x, int y) {
  return x < y ? x : y;
}
void merge_pass( ElementType list[], ElementType sorted[], int N, int length ){
  for(int start=0; start<N; start+=length*2){
    int cur_idx = start;
    int start1 = start;
    int end1 = min(start+length, N); 
    int start2 = end1;
    int end2 = min(start+length*2, N);
    while(start1<end1 && start2<end2){
      if(list[start1]>list[start2]){
        sorted[cur_idx++] = list[start2++];
      } 
      else{
        sorted[cur_idx++] = list[start1++];
      }
    }
    while(start1<end1){
      sorted[cur_idx++] = list[start1++];
    }
    while(start2<end2){
      sorted[cur_idx++] = list[start2++];
    }
  }
}
```
