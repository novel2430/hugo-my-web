---
title: 'Hamiltonian Cycle'
date: 2024-02-13T18:48:19+08:00
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
# 7-1 Hamiltonian Cycle
The "Hamilton cycle problem" is to find a simple cycle that contains every vertex in a graph. Such a cycle is called a "Hamiltonian cycle".

In this problem, you are supposed to tell if a given cycle is a Hamiltonian cycle.
## Input Specification:
Each input file contains one test case. For each case, the first line contains 2 positive integers N (2<N≤200), the number of vertices, and M, the number of edges in an undirected graph. Then M lines follow, each describes an edge in the format `Vertex1 Vertex2`, where the vertices are numbered from 1 to N. The next line gives a positive integer K which is the number of queries, followed by K lines of queries, each in the format:  
n V<sub>1</sub> V<sub>2</sub> ... V<sub>n</sub>  
where n is the number of vertices in the list, and V<sub>i</sub>'s are the vertices on a path.
## Output Specification:
For each query, print in a line `YES` if the path does form a Hamiltonian cycle, or `NO` if not.
## Sample Input:
```
6 10
6 2
3 4
1 5
2 5
3 1
4 1
1 6
6 3
1 2
4 5
6
7 5 1 4 3 6 2 5
6 5 1 4 3 6 2
9 6 2 1 6 3 4 5 2 6
4 1 2 5 1
7 6 1 3 4 5 2 6
7 6 1 2 5 4 3 1
```
## Sample Output:
```
YES
NO
NO
NO
YES
NO
```
## Code
```c
#include <stdio.h>
#include <stdlib.h>

int graph[300][300];

void graph_init(){
  for(int i=0; i<300; i++){
    for(int j=0; j<300; j++)
      graph[i][j] = 0;
  }
}

int is_seq_ok(int* seq, int size, int total_size){
  if(size-1!=total_size || seq[0]!=seq[size-1] ) return 0;
  int node[total_size+1];
  for(int i=0; i<total_size+1; i++) node[i] = 0;
  node[seq[0]] = 1;
  for(int i=1; i<size; i++){
    if(i<size-1){
      if(node[seq[i]]) return 0;
      node[seq[i]] = 1;
    }
    if(graph[seq[i-1]][seq[i]] == 0) {
      return 0;
    }
  }
  return 1;
}

int main(int argc, char *argv[]){
  graph_init();
  int total_size, edge_size;
  scanf("%d %d", &total_size, &edge_size);
  for(int i=0; i<edge_size; i++){
    int n1, n2;
    scanf("%d %d", &n1, &n2);
    graph[n1][n2] = 1;
    graph[n2][n1] = 1;
  }
  int case_count;
  scanf("%d", &case_count);
  for(int i=0; i<case_count; i++){
    int seq_size;
    scanf("%d", &seq_size);
    int seq[seq_size];
    for(int j=0; j<seq_size; j++){
      int num;
      scanf("%d", &num);
      seq[j] = num;
    }
    if(is_seq_ok(seq, seq_size, total_size)) printf("YES\n");
    else printf("NO\n");
  }
}
```
