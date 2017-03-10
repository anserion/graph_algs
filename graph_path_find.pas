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

//учебный шаблон поиска пути между двумя вершинами графа
//граф задан списками смежности (исходящие ребра).
//работа алгоритма основана на обходе графа в глубину (DFS)

program graph_path_find;
const
   max_p=100;
   max_q=100;

var i,j,k,current_p:integer;
   graph_lst_out: array [1..max_p,1..max_q] of integer; //списки смежности (исходящих ребер)
   stack: array[1..max_p]of integer; //рабочая структура данных - стек
   n: integer; //глубина стека
   xx: array[1..max_p]of integer; //массив предков (обратные пути) до вершин
   p:integer; //реальное число вершин в графе
   start_p,target_p:integer; //начальная и конечная вершины пути
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
      while (graph_lst_out[i,j]<>0)and(j<=p) do
      begin
         write(graph_lst_out[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;

   write('start vertex: '); readln(start_p);
   write('target vertex: '); readln(target_p);
   
   //помечаем все вершины непосещенными
   for i:=1 to p do xx[i]:=0;
   //помещаем в стек стартовую вершину
   stack[1]:=start_p; n:=1;
   current_p:=stack[1]; xx[current_p]:=start_p;
   //спускаемся по спискам смежности до самой последней
   // из достижимых непосещенных вершин, запоминая путь в стеке
   while (n>0)and(current_p<>target_p) do
   begin
      //печатаем содержимое стека
      write('stack:'); for i:=1 to n do write(' ',stack[i]); writeln;
      //пропускаем все уже посещенные вершины
      j:=1;
      while (xx[graph_lst_out[current_p,j]]<>0)and(j<=p) do
      begin
         writeln('skip vertex ',graph_lst_out[current_p,j]);
         j:=j+1;
      end;
      //если есть непосещенное направление, то идем туда
      if j<=p then
      if graph_lst_out[current_p,j]<>0 then
      begin
         xx[graph_lst_out[current_p,j]]:=current_p;
         n:=n+1; stack[n]:=graph_lst_out[current_p,j];
         current_p:=graph_lst_out[current_p,j];
         writeln('go to vertex ',current_p);
      end else //иначе возвращаемся назад
      begin current_p:=stack[n]; n:=n-1; writeln('return to vertex ',current_p); end;
   end;
   //если останов произошел на целевой вершине, то выводим путь от нее до стартовой
   if current_p=target_p then
   begin
      write('path found: ',target_p);
      j:=target_p;
      while(j<>start_p) do
      begin
         write('<-',xx[j]);
         j:=xx[j];
      end;
      writeln;
   end else writeln('path not found');
end.
