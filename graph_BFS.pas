//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон обхода графа в ширину (BFS)
//граф задан списками смежности (исходящие ребра).

program graph_BFS;
const
   max_p=100;
   max_q=100;

var i,j,k,p,start_p,current_p:integer;
   graph_lst_out: array [1..max_p,1..max_q] of integer; //списки смежности (исходящих ребер)
   queue: array[1..max_p]of integer; //рабочая структура данных - очередь
   head_q,end_q: integer; //начало и конец очереди
   xx: array[1..max_p]of integer; //массив меток посещенных вершины (0 - не посещалась)
begin
   //ввод исходных данных (список ребер)
   writeln('DFS of adjacency list (outcoming) graph');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);

   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to max_q do
         graph_lst_out[i,j]:=0;

   //автоматическая генерация списков смежности
   for i:=1 to p do
   begin
      k:=random(p);
      for j:=1 to k do
         graph_lst_out[i,j]:=random(p)+1;
   end;
{   
   //ввод списков смежности вручную
   for i:=1 to p do
   begin
      k:=0;
      writeln('vertex ',i);
      repeat
         k:=k+1;
         write(i,': edge to vertex (0 - next start vertex): ');
         readln(graph_lst_out[i,k]);
      until (graph_lst_out[i,k]=0)or(k=max_q);
   end;
   writeln('===========================================');
 }  

   //печать списков смежности (исходящие ребра)
   writeln('Adjacency list (outcoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while graph_lst_out[i,j]<>0 do
      begin
         write(graph_lst_out[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;

   write('start vertex for BFS: '); readln(start_p);
   for i:=1 to p do xx[i]:=0; 
   //помещаем в очередь стартовую вершину
   queue[1]:=start_p; head_q:=1; end_q:=1;
   current_p:=start_p; xx[current_p]:=1;
   repeat 
      //смотрим голову очереди (очередь не портим)
      current_p:=queue[head_q];
      //заносим в очередь все непосещенные смежные с текущей вершины
      j:=1;
      while graph_lst_out[current_p,j]<>0 do
      begin
         if xx[graph_lst_out[current_p,j]]=0 then
         begin
            xx[graph_lst_out[current_p,j]]:=1;
            end_q:=end_q+1; queue[end_q]:=graph_lst_out[current_p,j];
         end;
         j:=j+1;
      end;
      write('queue:'); for i:=head_q to end_q do write(' ',queue[i]); writeln;
      //извлекаем из очереди вершину и печатаем ее
      current_p:=queue[head_q]; xx[current_p]:=1;
      head_q:=head_q+1;
      writeln(' print ',current_p);
   until head_q>end_q;;
end.
