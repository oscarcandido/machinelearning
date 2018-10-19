%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                 TESTE COM DADOS DE CORES COLETADOS                     %
%                   Oscar Fel�cio Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;


%% Dados treinamento

Data = csvread('DADOS_COMPLETOS.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias �s entradas
D = Data(:,5:10);                    %alvos

%% Dados valida��o

Datav = csvread('DADOS_COMPLETOS.csv');     
Xv = Datav(:,1:4);                    
Xv = horzcat(ones(size(Xv,1),1),Xv); 
Dv = Datav(:,5:10); 

%% Par�metros da Rede

Net = [14 6];
LrnRte = 0.1;
MinErr = 10e-10;
MaxIt  = 50000;

%% treinamento da rede
[W,Er,Time]= mlp(Net,X,D,LrnRte,MinErr,MaxIt);


%% valida��o
Y = cell(1);
for i=1:size(Xv,1)
    Y{i} = classifica(Net,Xv(i,:),W,"logsig");
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

TxAcertos = Acertos /size(Result,1);
%% Apresenta��o dos resultados
figure;
plot(Er);
xlabel('�pocas');
ylabel('Erro');
title('Evolu��o do Erro Quadr�tico M�dio no Treinamento');

t1 = ' N�mero de amostras testadas : ';
t2 = ' N�mero de respostas corretas: ';
t3 = ' Taxa de acerto: ';
disp([t1,num2str(size(Dv,1))]);
disp([t2,num2str(Acertos)]);
disp([t3,num2str(TxAcertos*100),'%']);
