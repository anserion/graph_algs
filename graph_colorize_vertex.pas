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

//учебный шаблон раскраски графа (алгоритм перебора вершин и связанных с вершинами палитр)
//граф задан матрицей смежности (переводится в списки смежности)

program graph_colorize_vertex;
const max_p=100;

var
   C:array[1..max_p] of integer; //цвета вершин графа
   graph_adj: array [1..max_p,1..max_p] of integer; //матрица смежности графа
   G_out: array [1..max_p,1..max_p] of integer; //списки смежности (исходящих ребер)
   A:array[1..max_p] of integer; //палитра доступных цветов вершины
   p:integer; //реальное число вершин графа
   u:integer; //вершина смежная с анализируемой
   i,j,k:integer; //счетчики циклов
begin
   //ввод исходных данных (список смежности)
   writeln('Colorized of graph (vertex algorithm)');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);

   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //автоматическая генерация матрицы смежности неориентированного графа
   for i:=1 to p-1 do
      for j:=i+1 to p do
      begin
         graph_adj[i,j]:=random(2);
         graph_adj[j,i]:=graph_adj[i,j];
      end;
{   
   //ввод матрицы смежности вручную
   for i:=1 to p do
   begin
      for j:=1 to p do
      begin
         write('vertex ',i,' start of edge (1), no edge (0) to vertex ',j,': ');
         readln(graph_adj[i,j]);
      end;
      writeln('===========================================');
   end;
}  
   //печать матрицы смежности
   writeln('Adjacency matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(graph_adj[i,j]:3);
      writeln;
   end;

   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to p do
         G_out[i,j]:=0;

   //перевод матрицы смежности в списки смежности (исходящие ребра)
   for i:=1 to p do
   begin
      k:=0;
      for j:=1 to p do
         if graph_adj[i,j]<>0 then
         begin
            k:=k+1;
            G_out[i,k]:=j;
         end;
   end;

   //печать списков смежности (исходящие ребра)
   writeln('Adjacency list (outcoming)');
   for i:=1 to p do
   begin
      write(i,': ');
      j:=1;
      while (G_out[i,j]<>0)and(j<=p) do
      begin
         write(G_out[i,j]:3);
         j:=j+1;
      end;
      writeln;
   end;

   //пометка всех вершин "не раскрашены"
   for i:=1 to p do C[i]:=0;
   //шапка таблицы палитр
   writeln;
   write('    palette: '); for k:=1 to p do write(k:3); writeln;
   //перебираем все вершины
   for i:=1 to p do
   begin
      //инициализация палитры вершины
      for k:=1 to p do A[k]:=1;
      //анализируем цвета смежных вершин
      j:=1;
      while (G_out[i,j]<>0)and(j<=p) do
      begin
         u:=G_out[i,j];
         //вычеркиваем из палитры цвета смежных вершин
         if C[u]<>0 then A[C[u]]:=0;
         j:=j+1;
      end;
      //выводим палитру
      write('vertex ',i:3,' : ');
      for k:=1 to p do write(A[k]:3);
      writeln;
      //ищем минимально доступный цвет из оставшихся в палитре
      k:=1;
      while (A[k]=0)and(k<=p) do k:=k+1;
      C[i]:=k;
      if C[i]=p+1 then C[i]:=0;
   end;

   //печать цветов вершин
   writeln;
   writeln('Colors of vertexes:');
   for i:=1 to p do
      writeln('vertex ',i:3,': color ',C[i]);
end.
