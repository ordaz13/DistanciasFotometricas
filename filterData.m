function [inputData, targetData] = filterData(rawData, n)
%Esta funcion obtiene un aleatorio de 600,000 datos del archivo
%DR10A_hoyle_xfblanc1.csv
%   rawData    - Matriz con los datos sin procesar
%   n          - Numero de muestras a utilizar
%   inputData  - Matriz filtrada y recortada de entradas
%   targetData - Matriz filtrada y recortada de salidas

%Busca renglones cuyos datos son inservibles
[ren, col] = find(rawData == -9999);
%Elminina los renglones
filterData = removerows(rawData,'ind', ren);
%Elige de manera aleatoria renglones
r = randi([1 size(filterData,1)],1, n);
%Devuelve los resultados ya filtrados
finalData = filterData(r,:);
%Generamos los vectores de input y target para usar mas tarde con la red
%neuronal
inputData = finalData(1:n,[6:13,15]);
targetData = finalData(1:n,4);
end

