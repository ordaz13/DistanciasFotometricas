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
%Calcula la distancia a la que se encuentran los objetos a partir del
%redshift
distancias = abs(distanciaCRC(results));
%Grafica las distancias obtenidas
figure(); plot(distancias); hold on;
%Calcula el error relativo por muestra
errorRelativo = abs(results - targetData)./targetData;
%Calculamos medidas de tendencia central (mediana, media y moda)
mediana = median(results);
moda = mode(results);
media = mean(results);
%Termina de contar el tiempo de ejecucion y lo muestra
toc
%% Clustering app
% %Inicia a contar el tiempo de ejecucion
% tic
% %Definimos la dimension del cluster deseado
% dimension1 = 3; dimension2 = 3;
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

