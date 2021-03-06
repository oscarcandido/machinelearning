%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                         VALIDA��O CRUZADA                              %
%                   Oscar Fel�cio Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;


%% Dados amostras

Data = csvread('dados.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias �s entradas
D = Data(:,5:10);  
%% par�metros valida��o
nAmostras = size(X,1);              %Total de amostras
txTestes  = 0.6;                    %Taxa de amostras no grupo de teste
nClasses  = 6;                      %N�mero de classes amostradas
%% sele��o aleat�rias de amostras para os grupos
inTestes  = zeros(1,nAmostras);     %vetor cujos indices represenatam as amostras  1 amostra selecionada 0 n�o selecionada;
inValid   = ones(1,nAmostras);      %vetor cujos indices represenatam as amostras 1 amostra selecionada 0 n�o selecionada;
nTestes = nAmostras * txTestes;     %N�mero de amostras que dever�o ser selecionadas para o grupo de testes
nValid = nAmostras - nTestes;       %N�mero de amostras que dever�o ser selecionadas para o grupo de valida��o
cont = 0;
while cont < nTestes                %Seleciona aleatoriamente as amostras dos grupo de Testes
    I = randi([1 nAmostras]);
    if (inTestes(I) == 0)
        inTestes(I) = 1;
        cont = cont +1;
    end
end
inValid = inValid - inTestes;       %As amostras do grupo de valida��o s�o as que n�o fazem parte do grupo de testes
cont = 1;
i = 1;
while cont <= nAmostras
    if inTestes(cont) == 1
        Xt(i,:) = X(i,:);            %Grupo de Testes
        Dt(i,:) = D(i,:);
        i = i + 1;
    end
    cont = cont + 1;
end
cont = 1;
i = 1;
while cont <= nAmostras
    if inValid(cont) == 1
        Xv(i,:) = X(i,:);            %Grupo de Valida��o
        Dv(i,:) = D(i,:);
        i = i + 1;
    end
    cont = cont + 1;
end
%% configura��es de redes a serem testadas
Net(1,:) = [14 6];
Net(2,:) = [9 6];
Net(3,:) = [28 6];
LrnRte = 1;
MinErr = 10e-8;
MaxIt  = 50000;
%% valida��o cruzada
for I=1:size(Net,1)
    %% treinamento da rede
    [W,Er,Time]= mlp(Net(I,:),Xt,Dt,LrnRte,MinErr,MaxIt); 
    %% valida��o
    Y = cell(1);
    for i=1:size(Xv,1)
        Y{i} = classifica(Net(I,:),Xv(i,:),W,"logsig");
    end

%% Ajuste das respostas da valida��o
    Yadj = Y;
    for i=1:size(Y,2)
        for j = 1 :size(Y{1},1)
            if Y{i}(j) >=  0.5
               Yadj{i}(j) =  1;
            else
               Yadj{i}(j) =  0;
            end
        end
    end

%% Compara��o da sa�da ajustada da rede com o esperado

    Result = zeros(size(Dv,1),1);
    for i=1:size(Dv,1)
        if isequal(Dv(i,:),Yadj{i}')
            Result(i) = 1;
        else
            Result(i) = 0;
        end
    end

    Acertos = sum(Result);

    TxAcertos(I) = Acertos /size(Result,1);    
end