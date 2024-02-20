---
title: 'Universal Travel Sites'
date: 2024-02-14T01:12:56+08:00
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
# Universal Travel Sites
After finishing her tour around the Earth, CYLL is now planning a universal travel sites development project. After a careful investigation, she has a list of capacities of all the satellite transportation stations in hand. To estimate a budget, she must know the minimum capacity that a planet station must have to guarantee that every space vessel can dock and download its passengers on arrival.
## Input Specification:
Each input file contains one test case. For each case, the first line contains the names of the source and the destination planets, and a positive integer N (≤500). Then N lines follow, each in the format: `source[i]` `destination[i]` `capacity[i]` where `source[i]` and `destination[i]` are the names of the satellites and the two involved planets, and `capacity[i]` > 0 is the maximum number of passengers that can be transported at one pass from `source[i]` to `destination[i]`. Each name is a string of 3 uppercase characters chosen from {A-Z}, e.g., ZJU.
Note that the satellite transportation stations have no accommodation facilities for the passengers. Therefore none of the passengers can stay. Such a station will not allow arrivals of space vessels that contain more than its own capacity. It is guaranteed that the list contains neither the routes to the source planet nor that from the destination planet.
## Output Specification:
For each test case, just print in one line the minimum capacity that a planet station must have to guarantee that every space vessel can dock and download its passengers on arrival.
## Sample Input:
```
EAR MAR 11
EAR AAA 300
EAR BBB 400
AAA BBB 100
AAA CCC 400
AAA MAR 300
BBB DDD 400
AAA DDD 400
DDD AAA 100
CCC MAR 400
DDD CCC 200
DDD MAR 300
```
## Sample Output:
```
700
```
## Code Dinic
```c
// USING DINIC
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 2000
#define INF 0x3f3f3f3f

typedef enum { FALSE, TRUE } boolean;
typedef struct Graph{
  int edge_num;
  int node_num;
  int flow[MAXN][MAXN];
  char dict[MAXN][4];
}Graph ;

typedef struct QueueNode{
  int val;
  struct QueueNode* next;
}QueueNode ;
typedef struct Queue{
  QueueNode* head;
  QueueNode* tail;
}Queue ;

QueueNode* queue_node_init(int val){
  QueueNode* res = (QueueNode*)malloc(sizeof(QueueNode));
  res->val = val;
  res->next = NULL;
  return res;
}
Queue* queue_init(){
  Queue* res = (Queue*)malloc(sizeof(Queue));
  res->head = queue_node_init(0);
  res->tail = res->head;
  return res;
}
void queue_insert(Queue* queue, int val){
  QueueNode* node = queue_node_init(val);
  queue->tail->next = node; 
  queue->tail = node;
  queue->head->val++;
}
int queue_pop(Queue* queue){
  int res = -1;
  QueueNode* cur = queue->head->next;
  if(cur!=NULL){
    res = cur->val;
    queue->head->next = cur->next;
    if(cur==queue->tail){
      queue->tail = queue->head;
    }
    free(cur);
    cur = NULL;
    queue->head->val--;
  }
  return res;
}
void queue_delete(Queue* queue){
  QueueNode* cur = queue->head;
  while(cur!=NULL){
    QueueNode* tmp = cur;
    cur = cur->next;
    free(tmp);
    tmp = NULL;
  }
  free(queue);
  queue = NULL;
}
boolean queue_is_empty(Queue* queue){
  if(queue->head==queue->tail) return TRUE;
  return FALSE;
}

Graph* graph_init(char* start, char* end, int edge_num){
  Graph* res = (Graph*)malloc(sizeof(Graph));
  res->edge_num = 2;
  res->node_num = edge_num;
  memset(res->flow, 0, sizeof(res->flow));
  strcpy(res->dict[0], start);
  strcpy(res->dict[1], end);
  return res;
}
void graph_insert_edge(Graph* graph, char* planet1, char* planet2, int weight){
  int p1_idx = -1;
  int p2_idx = -1;
  for(int i=0; i<graph->node_num; i++){
    if(strcmp(graph->dict[i], planet1)==0){
      p1_idx = i;
    }
    if(strcmp(graph->dict[i], planet2)==0){
      p2_idx = i;
    }
  }
  if(p1_idx==-1){
    strcpy(graph->dict[graph->node_num], planet1);
    p1_idx = graph->node_num;
    graph->node_num++;
  }
  if(p2_idx==-1){
    strcpy(graph->dict[graph->node_num], planet2);
    p2_idx = graph->node_num;
    graph->node_num++;
  }
  graph->flow[p1_idx][p2_idx] = weight;
}

int min(int a, int b){
  if(a>b) return b;
  return a;
}
int count_node_flow_sum(Graph* graph, int idx){
  int res = 0;
  for(int i=0; i<graph->node_num; i++){
    res += graph->flow[idx][i];
  }
  return res;
}
void build_level_graph_bfs(int* level, Graph* graph){
  Queue* queue = queue_init();
  queue_insert(queue, 0);
  level[0] = 1;
  while(!queue_is_empty(queue)){
    int cur_idx = queue_pop(queue);
    for(int i=0; i<graph->node_num; i++){
      if(level[i]==0 && graph->flow[cur_idx][i]>0){
        queue_insert(queue, i);
        level[i] = level[cur_idx]+1; 
      }
    }
  }
  queue_delete(queue);
}
int find_blocking_flow_dfs(Graph* graph, int* level, int cur_idx, int last_flow){
  if(cur_idx==1){
    // meet end
    return last_flow;
  }
  int res = 0;
  for(int i=0; i<graph->node_num; i++){
    if(level[i]==level[cur_idx]+1 && graph->flow[cur_idx][i]>0){
      int flow = find_blocking_flow_dfs(graph, level, i, min(last_flow-res, graph->flow[cur_idx][i]));
      graph->flow[cur_idx][i] -= flow;
      graph->flow[i][cur_idx] += flow;
      res += flow;
    }
  }
  return res;
}

void dinic(Graph* graph){
  int level[MAXN];
  while(1){
    // build level graph
    memset(level, 0, sizeof(level));
    build_level_graph_bfs(level, graph);
    // find blocking flow in level graph
    // &
    // update residual graph
    if(!find_blocking_flow_dfs(graph, level, 0, INF)){
      // No blocking flow then break
      break;
    }
  }
}

int main(int argc, char *argv[]){
  char start[4];
  char end[4];
  int edge_num;
  scanf("%s %s %d", start, end, &edge_num);
  Graph* graph = graph_init(start, end, edge_num);
  for(int i=0; i<edge_num; i++){
    char planet1[4];
    char planet2[4];
    int capacity;
    scanf("%s %s %d", planet1, planet2, &capacity);
    graph_insert_edge(graph, planet1, planet2, capacity);
  }
  int before = count_node_flow_sum(graph, 0);
  dinic(graph);
  int after = count_node_flow_sum(graph, 0);
  printf("%d\n", before-after);
  return 0;
}
```
## Code Ford Fulkerson
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXN 2000
#define INF 0x3f3f3f3f

typedef enum { FALSE, TRUE } boolean;

typedef struct Graph{
  int edge_num;
  int node_num;
  int flow[MAXN][MAXN];
  char dict[MAXN][4];
}Graph ;

typedef struct QueueNode{
  int val;
  struct QueueNode* next;
}QueueNode ;
typedef struct Queue{
  QueueNode* head;
  QueueNode* tail;
}Queue ;

QueueNode* queue_node_init(int val){
  QueueNode* res = (QueueNode*)malloc(sizeof(QueueNode));
  res->val = val;
  res->next = NULL;
  return res;
}
Queue* queue_init(){
  Queue* res = (Queue*)malloc(sizeof(Queue));
  res->head = queue_node_init(0);
  res->tail = res->head;
  return res;
}
void queue_insert(Queue* queue, int val){
  QueueNode* node = queue_node_init(val);
  queue->tail->next = node; 
  queue->tail = node;
  queue->head->val++;
}
int queue_pop(Queue* queue){
  int res = -1;
  QueueNode* cur = queue->head->next;
  if(cur!=NULL){
    res = cur->val;
    queue->head->next = cur->next;
    if(cur==queue->tail){
      queue->tail = queue->head;
    }
    free(cur);
    cur = NULL;
    queue->head->val--;
  }
  return res;
}
void queue_delete(Queue* queue){
  QueueNode* cur = queue->head;
  while(cur!=NULL){
    QueueNode* tmp = cur;
    cur = cur->next;
    free(tmp);
    tmp = NULL;
  }
  free(queue);
  queue = NULL;
}
void queue_empty(Queue* queue){
  QueueNode* cur = queue->head->next;
  while(cur!=NULL){
    QueueNode* tmp = cur;
    cur = cur->next;
    free(tmp);
    tmp = NULL;
  }
  queue->tail = queue->head;
}
boolean queue_is_empty(Queue* queue){
  if(queue->head==queue->tail) return TRUE;
  return FALSE;
}

Graph* graph_init(char* start, char* end, int edge_num){
  Graph* res = (Graph*)malloc(sizeof(Graph));
  res->edge_num = 2;
  res->node_num = edge_num;
  memset(res->flow, 0, sizeof(res->flow));
  strcpy(res->dict[0], start);
  strcpy(res->dict[1], end);
  return res;
}
void graph_insert_edge(Graph* graph, char* planet1, char* planet2, int weight){
  int p1_idx = -1;
  int p2_idx = -1;
  for(int i=0; i<graph->node_num; i++){
    if(strcmp(graph->dict[i], planet1)==0){
      p1_idx = i;
    }
    if(strcmp(graph->dict[i], planet2)==0){
      p2_idx = i;
    }
  }
  if(p1_idx==-1){
    strcpy(graph->dict[graph->node_num], planet1);
    p1_idx = graph->node_num;
    graph->node_num++;
  }
  if(p2_idx==-1){
    strcpy(graph->dict[graph->node_num], planet2);
    p2_idx = graph->node_num;
    graph->node_num++;
  }
  graph->flow[p1_idx][p2_idx] = weight;
}

int min(int a, int b){
  if(a>b) return b;
  return a;
}
boolean has_one_path_bfs(Graph* graph, Queue* queue, boolean* visit, int* path, int start, int end){
  queue_insert(queue, start);
  while (!queue_is_empty(queue)) {
    int cur_idx = queue_pop(queue);
    visit[cur_idx] = TRUE;
    if(cur_idx==end) return TRUE;
    for(int i=0; i<graph->node_num; i++){
      if(!visit[i] && graph->flow[cur_idx][i]>0){
        queue_insert(queue, i);
        path[i] = cur_idx;
      }
    }
  }
  return FALSE;
}
int update_one_path_residual_dfs(Graph* graph, int* path, int cur_idx, int end, int last_num){
  if(cur_idx==end){
    return last_num;
  }
  int next = path[cur_idx];
  int min_flow = update_one_path_residual_dfs(graph, path, next, end, min(last_num, graph->flow[next][cur_idx]));
  graph->flow[next][cur_idx] -= min_flow;
  graph->flow[cur_idx][next] += min_flow;
  return min_flow;
}
void ford_fulkerson(Graph* graph){
  Queue* queue = queue_init();
  int path[MAXN];
  for(int i=0; i<graph->node_num; i++) path[i] = i;
  boolean visit[MAXN];
  memset(visit, FALSE, sizeof(visit));
  int count = 0;
  while(has_one_path_bfs(graph, queue, visit, path, 0, 1)){
    update_one_path_residual_dfs(graph, path, 1, 0, INF);
    for(int i=0; i<graph->node_num; i++) path[i] = i;
    queue_empty(queue);
    memset(visit, FALSE, sizeof(visit));
  }
  queue_delete(queue);
}
int count_node_flow_sum(Graph* graph, int idx){
  int res = 0;
  for(int i=0; i<graph->node_num; i++){
    res += graph->flow[idx][i];
  }
  return res;
}

int main(int argc, char *argv[]){
  char start[4];
  char end[4];
  int edge_num;
  scanf("%s %s %d", start, end, &edge_num);
  Graph* graph = graph_init(start, end, edge_num);
  for(int i=0; i<edge_num; i++){
    char planet1[4];
    char planet2[4];
    int capacity;
    scanf("%s %s %d", planet1, planet2, &capacity);
    graph_insert_edge(graph, planet1, planet2, capacity);
  }
  int before = count_node_flow_sum(graph, 0);
  ford_fulkerson(graph);
  int after = count_node_flow_sum(graph, 0);
  printf("%d\n", before-after);
  return 0;
}
```
