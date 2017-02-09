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

//учебный шаблон поиска кратчайших путей и расстояний в графе
//по алгоритму Флойда
//граф задан матрицей растояний.

program graph_floid;
const max_p=100;

var
   C:array[1..max_p,1..max_p] of real; //входная матрица
   T:array[1..max_p,1..max_p] of real; //матрица кратчайших расстояний
   H:array[1..max_p,1..max_p]of integer; //матрица кратчайших путей
   i,j,k,p:integer;
   flag:boolean; //аварийный флаг обнаружения цикла отрицательной длины
begin
   //ввод исходных данных (матрица расстояний)
   writeln('Floid algorithm for matrix graph');
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
   write('     '); for i:=1 to p do write(i:6); writeln;
   for i:=1 to p do
   begin
      write(i:6,': ');
      for j:=1 to p do 
         if C[i,j]<>-1 then write(C[i,j]:6:1) else write('   -- ');
      writeln;
   end;

//инициализация массивов для алгоритма Флойда
   for i:=1 to p do
      for j:=1 to p do
      begin
         T[i,j]:=C[i,j];
         if C[i,j]=-1 then H[i,j]:=0 else H[i,j]:=j;
      end;

//ядро алгоритма Флойда
   flag:=true;
   for i:=1 to p do
   begin
      if flag then
      begin
         for j:=1 to p do
            for k:=1 to p do
               if (i<>j)and(T[j,i]<>-1)and(i<>k)and(T[i,k]<>-1) then
               if (T[j,k]=-1)or(T[j,k]>T[j,i]+T[i,k]) then
               begin
                  H[j,k]:=H[j,i];
                  T[j,k]:=T[j,i]+T[i,k];
               end;
         for j:=1 to p do
            if T[j,j]<0 then 
            begin
               writeln('ERROR: we have a negative length loop');
               flag:=false;
            end;
      end;
   end;

   if flag then
   begin
   //печать матрицы кратчайших расстояний
   writeln;
   writeln('Shortest distance matrix:');
   write('     '); for i:=1 to p do write(i:6); writeln;
   for i:=1 to p do
   begin
      write(i:6,': ');
      for j:=1 to p do 
         if T[i,j]<>-1 then write(T[i,j]:6:1) else write('   -- ');
      writeln;
   end;
   
   //печать кратчайших путей
   writeln;
   writeln('Shortest paths:');
   for i:=1 to p do
   begin
      writeln('start vertex: ',i);
      for j:=1 to p do
      begin
         if T[i,j]=-1 then writeln('no path from ',i,' to ',j) else
         begin
            k:=i; write(k);
            while k<>j do
            begin
               k:=H[k,j];
               write('-->',k);
            end;
            writeln;
         end;
      end;
      writeln('-----------------------');
   end;
   //------------------------------------
   end;
   
end.
