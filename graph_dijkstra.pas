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

//учебный шаблон поиска кратчайших путей и расстояний графа (алгоритм Дейкстры)
//граф задан матрицей расстояний

program graph_dijkstra;
const max_p=100;

var
   C:array[1..max_p,1..max_p] of real; //входная матрица
   T:array[1..max_p] of real; //кратчайшие расстояния
   H:array[1..max_p] of integer; //кратчайшие пути
   X:array[1..max_p] of integer; //метки вершин
   G_out: array [1..max_p,1..max_p] of integer; //списки смежности (исходящих ребер)
   p:integer; //реальное число вершин графа
   s:integer; //стартовая вершина
   vv:integer; //вершина релаксации
   u:integer; //вершина смежная с вершиной релаксации
   i,j,k:integer; //счетчики циклов
   tt:real; //для поиска вершины релаксации
begin
   //ввод исходных данных (матрица расстояний)
   writeln('Dijkstra algorithm for matrix graph');
   //определяем количество вершин графа
   write('number of vertexes: '); readln(p);

   //инициализация матрицы расстояний
   for i:=1 to p do
      for j:=1 to p do
         C[i,j]:=0;

   //автоматическая генерация входной матрицы
   //полносвязный граф с случайными неотрицательными связями
   for i:=1 to p do
      for j:=1 to p do
         C[i,j]:=random*100;
   //некоторые связи устраняем (делаем "бесконечно" большими)
   for i:=1 to 2*p do
   begin
      j:=random(p)+1;
      k:=random(p)+1;
      C[j,k]:=-1; //-1 признак "бесконечно" большого расстояния
   end;
   //по главной диагонали матрицы выставляем нули
   for i:=1 to p do C[i,i]:=0;

{   
   //ввод матрицы расстояний вручную
   for i:=1 to p do
   begin
      for j:=1 to p do
      begin
         write('Distance from vertex ',i,' to vertex ',j,': ');
         readln(C[i,j]);
      end;
      writeln('===========================================');
   end;
}  

   //печать матрицы расстояний
   writeln('Distance matrix: ',p,'x',p,' vertexes');
   write('     '); for i:=1 to p do write(i:5); writeln;
   for i:=1 to p do
   begin
      write(i:5,': ');
      for j:=1 to p do 
         if C[i,j]<>-1 then write(C[i,j]:5:1) else write('  -- ');
      writeln;
   end;

   //инициализация списков смежности (исходящие ребра)
   for i:=1 to p do
      for j:=1 to p do
         G_out[i,j]:=0;
   
   //перевод "матрицы смежности" в списки смежности (исходящие ребра)
   for i:=1 to p do
   begin
      k:=0;
      for j:=1 to p do
         if C[i,j]<>-1 then
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

   //ввод номера стартовой вершины
   write('Start vertex: '); readln(s);

   //инициализация алгоритма Дейкстры
   for i:=1 to p do
   begin
      T[i]:=-1;
      X[i]:=0;
      H[i]:=i;
   end;
   H[s]:=s;
   T[s]:=0;
   X[s]:=1;

   writeln('Dijkstra table');
   vv:=s; //vv - вершина релаксации
   repeat
      //печать строки с номерами вершин
      write('      '); for i:=1 to p do write(i:5); writeln;
      //печать строки с метками отрелаксировавших вершин
      write('relax: ');
      for j:=1 to p do if X[j]=1 then write('   * ') else write('     ');
      writeln;
      //печать строки таблицы текущих минимальных расстояний от s
      write(' old : ');
      for j:=1 to p do if T[j]<>-1 then write(T[j]:5:0) else write('  -- ');
      writeln;

      //корректируем минимальные расстояния до всех вершин от s
      //(vv - вершина релаксации)
      j:=1;
      while (G_out[vv,j]<>0)and(j<=p) do
      begin
         u:=G_out[vv,j];
         if (X[u]=0)and(T[vv]<>-1)and(C[vv,u]<>-1) then
         if (T[u]=-1)or(T[u]>T[vv]+C[vv,u]) then
         begin
            T[u]:=T[vv]+C[vv,u];
            H[u]:=vv;
         end;
         j:=j+1;
      end;

      //печать строки таблицы с коррекцией минимальных расстояний от s
      write(' new : ');
      for j:=1 to p do if T[j]<>-1 then write(T[j]:5:0) else write('  -- ');
      writeln;
      //печать строки таблицы с коррекцией кратчайших путей от s
      write('paths: ');
      for j:=1 to p do if T[j]<>-1 then write(H[j]:5) else write('  -- ');
      writeln;
            
      //находим новую вершину с гарантированно найденным минимальным
      //расстоянием и путем до нее (вершина релаксации)
      vv:=1; tt:=-1;
      while (vv<=p)and(X[vv]<>0) do vv:=vv+1;
      if vv<=p then tt:=T[vv];
      for u:=vv+1 to p do
         if (X[u]=0)and(T[u]<tt)and(T[u]<>-1) then
         begin
            vv:=u; tt:=T[u];
         end;
      
      if vv<=p then
      begin
         X[vv]:=1;
         writeln('relax vertex: ',vv);
      end;
   until vv>p;
   
   //печать кратчайших расстояний и путей
   writeln;
   writeln('Shortest distances and paths from vertex ',s,':');
   for i:=1 to p do
   begin
      writeln('to vertex ',i,':');
      if T[i]=-1 then writeln('no path to ',i) else
      begin
         writeln('D=',T[i]:5:1);
         write('path: ');
         k:=i; write(k);
         while k<>s do
         begin
            k:=H[k];
            write('<--',k);
         end;
         writeln;
      end;
   end;
end.
