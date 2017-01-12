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

//учебный шаблон создания матрицы транзитивного замыкания графа
//граф задан матрицей смежности

program graph_warshall;
const
   max_p=100;
   max_q=100;

var i,j,k,p:integer;
   graph_adj: array [1..max_p,1..max_p] of integer; //матрица смежности
   T: array [1..max_p,1..max_p] of integer; //матрица транзитивного замыкания
   S: array [1..max_p,1..max_p] of integer; //вспомогательная матрица
begin
   //ввод исходных данных (матрица смежности)
   writeln('Warshall algorithm for an  adjacence matrix graph');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);
   
   //инициализация матрицы смежности
   for i:=1 to p do
      for j:=1 to p do
         graph_adj[i,j]:=0;

   //автоматическая генерация матрицы смежности (1 в 30% ячеек)
   for i:=1 to p do
      for j:=1 to p do
         if random(100)<30 then graph_adj[i,j]:=1 else graph_adj[i,j]:=0;
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

   //инициализация
   for i:=1 to p do
      for j:=1 to p do
         S[i,j]:=graph_adj[i,j];
   
   //вычислительное ядро алгоритма Уоршалла
   for i:=1 to p do
   begin
      //наращиваем T[]
      for j:=1 to p do
         for k:=1 to p do
         begin
            //T[j,k]:=S[j,k] or S[j,i] and S[i,k];
            T[j,k]:=0;
            if S[j,k]=1 then T[j,k]:=1;
            if (S[j,i]=1) and (S[i,k]=1) then T[j,k]:=1;
         end;
      //копируем T[] в S[]
      for j:=1 to p do
         for k:=1 to p do
            S[j,k]:=T[j,k];
   end;
   
   //печать матрицы транзитивного замыкания графа
   writeln('Warshall matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:3); writeln;
   for i:=1 to p do
   begin
      write(i:3,': ');
      for j:=1 to p do write(T[i,j]:3);
      writeln;
   end;
      
end.
