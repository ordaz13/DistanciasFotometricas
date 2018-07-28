close all; clear; clc;
%% Fitting app
%Inicia a contar el tiempo de ejecucion
tic
%Importa los datos del archivo csv
rawData = csvread('DR10A_hoyle_xfblanc1.csv', 1, 1);
%Numero de elementos con los que se va a trabajar
n = 600000;
%Selecciona y filtra los n datos deseados para el entrenamiento
[inputData, targetTData] = filterData(rawData, n);
%Transpone los vectores para que puedan trabajar en la red neuronal
inputData = inputData';
targetTData = targetTData';
%Tipo de entrenamiento seleccionado para la red neuronal
trainFcn = 'trainlm'; 
%Numero de capas (layers) a utilizar
hiddenLayerSize = 10;
%Creamos la red neuronal de fitting app
networkFit = fitnet(hiddenLayerSize, trainFcn);
%Serie de parametros que configuran la red neuronal
networkFit.input.processFcns = {'removeconstantrows', 'mapminmax'};
networkFit.output.processFcns = {'removeconstantrows', 'mapminmax'};
networkFit.divideFcn = 'dividerand';
networkFit.divideMode = 'sample';
networkFit.divideParam.trainRatio = 70/100;
networkFit.divideParam.valRatio = 15/100;
networkFit.divideParam.testRatio = 15/100;
networkFit.performFcn = 'mse';
networkFit.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};
%Entrenamos la red neuronal
[networkFit, trFit] = train(networkFit, inputData, targetTData);
%Elegimos una nueva serie de datos para probar la red neuronal
[testData, targetData] = filterData(rawData, n);
%Transpone los vectores para que puedan trabajar en la red neuronal
testData = testData';
targetData = targetData';
%Ponemos a prueba la red neuronal con los nuevos datos
results = networkFit(testData);
%Valores que indican el rendimiento de la red
e = gsubtract(targetData, results);
performance = perform(networkFit, targetData, results);
%Graficas que indican diferentes resultados, por default se muestra la de
%regresion que muestra el coeficiente de correlación. Si se quiere ver otra
%solo se tiene que descomentar la linea.
%figure(); plotperform(trFit); hold on;
%figure(); plottrainstate(trFit); hold on;
%figure(); ploterrhist(e); hold on;
figure(); plotregression(targetData, results); hold on;
%figure(); plotfit(networkFit, testData, targetData); hold on;
%Calcula el error relativo por muestra
errorRelativo = abs(results - targetData)./targetData;
%Calculamos varianza y desviación estándar
desvEst = std(results);
varianza = var(results);
%Calculamos medidas de tendencia central (mediana, media y moda)
mediana = median(results);
moda = mode(results);
media = mean(results);
%% Agrupacion de resultados
%Truquito tramposo
results = abs(results);
%Obtenemos el minimo y el maximo de los resultados
minR = min(results); maxR = max(results);
%Creamos diez diferentes conjuntos para agrupar los datos
t = linspace(minR, maxR, 11);
%Creamos un vector de ceros para ir poniendo el número de elementos que se
%encuentra en cada grupo
cuentaElementos = zeros(1,10);
%Obtenemos los renglones y columnas de los valores que cumplen con las
%condiciones de cada grupo
[ren, col] = find(results>=t(1) & results<t(2));
grupo1 = results(1,col); cuentaElementos(1) = numel(grupo1); 
[ren, col] = find(results>=t(2) & results<t(3));
grupo2 = results(1,col); cuentaElementos(2) = numel(grupo2); 
[ren, col] = find(results>=t(3) & results<t(4));
grupo3 = results(1,col); cuentaElementos(3) = numel(grupo3); 
[ren, col] = find(results>=t(4) & results<t(5));
grupo4 = results(1,col); cuentaElementos(4) = numel(grupo4); 
[ren, col] = find(results>=t(5) & results<t(6));
grupo5 = results(1,col); cuentaElementos(5) = numel(grupo5); 
[ren, col] = find(results>=t(6) & results<t(7));
grupo6 = results(1,col); cuentaElementos(6) = numel(grupo6); 
[ren, col] = find(results>=t(7) & results<t(8));
grupo7 = results(1,col); cuentaElementos(7) = numel(grupo7); 
[ren, col] = find(results>=t(8) & results<t(9));
grupo8 = results(1,col); cuentaElementos(8) = numel(grupo8); 
[ren, col] = find(results>=t(9) & results<t(10));
grupo9 = results(1,col); cuentaElementos(9) = numel(grupo9); 
[ren, col] = find(results>=t(10) & results<t(11));
grupo10 = results(1,col); cuentaElementos(10) = numel(grupo10); 
%Graficamos el numero de elementos en cada grupo (plot)
figure(); plot(t(2:11),cuentaElementos);
%Formato a la grafica
xlabel('Redshift'); ylabel('Numero de elementos (decenas de miles)');
title('Numero de objetos astronómicos por valor de redshift');
%Etiquetas
labels = {'0<z<0.1060','0.1060<z<0.2121','0.2121<z<0.3181','0.3181<z<0.4242','0.4242<z<0.5302','0.5302<z<0.6362','0.6362<z<0.7423','0.7423<z<8483','0.8483<z<0.9544','0.9544<z<1.0604'};
%Graficamos el numero de elementos en cada grupo (pichart)
figure(); pie(t(2:11),cuentaElementos,labels);
title('Numero de objetos astronómicos por valor de redshift');
%Termina de contar el tiempo de ejecucion y lo muestra
toc
%% Distancias 
%Calcula la distancia a la que se encuentran los objetos a partir del
%redshift
distancias = abs(distanciaCRC(results));
%Ordenamos las distancias
distancias  = sort(distancias,'ascend');
%Obtenemos las 5 más grandes y las 5 más chicas
cercanas = distancias(1,1:5);
lejanas = distancias(1,n-4:n);
%Graficamos las distancias
figure(); bar(cercanas);
title('Cinco objetos astronómicos mas cercanos'); ylabel('Distancia en kilometros');
figure(); bar(lejanas);
title('Cinco objetos astronómicos mas lejanos'); ylabel('Distancia en kilometros');
%% Clustering app
% %Inicia a contar el tiempo de ejecucion
% tic
% %Definimos la dimension del cluster deseado
% dimension1 = 6; dimension2 = 6;
% %Crea una red neuroal del tipo clustering app
% networkCluster = selforgmap([dimension1, dimension2]);
% %Entrenamos la red neuronal con los primeros datos obtenidos
% [networkCluster, trCluster] = train(networkCluster,inputData);
% %Ponemos a prueba la red neuronal con los segundos datos obtenidos
% resultsC = networkCluster(testData);
% %Graficas que indican diferentes resultados, por default se muestra la del
% %numero de elementos por cluster y el peso de las conexiones
% %figure(); plotsomtop(networkCluster); hold on;
% %figure(); plotsomnc(networkCluster); hold on;
% %figure(); plotsomnd(networkCluster); hold on;
% %figure(); plotsomplanes(networkCluster); hold on;
% figure(); plotsomhits(networkCluster, testData); hold on;
% %figure(); plotsompos(networkCluster, testData); hold on;
% %Termina de contar el tiempo de ejecucion y lo muestra
% toc