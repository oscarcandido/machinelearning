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

Data = csvread('dados_norm.csv');      %Dados dos exemplos
X = Data(:,1:3);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias �s entradas
D = Data(:,4:7);                    %alvos
for i=1:size(X,1)
    if D(i,1) == 1
        plot3(X(i,2),X(i,3),X(i,4),'r+');
    end
    if D(i,2) == 1
        plot3(X(i,2),X(i,3),X(i,4),'g+');
    end
    if D(i,3) == 1
        plot3(X(i,2),X(i,3),X(i,4),'b+');
    end
    if D(i,4) == 1
        plot3(X(i,2),X(i,3),X(i,4),'y+');
    end
    hold on;
    
end
%% Dados valida��o

Datav = csvread('dados_norm.csv');     
Xv = Datav(:,1:3);                    
Xv = horzcat(ones(size(Xv,1),1),Xv); 
Dv = Datav(:,4:7); 

%% Par�metros da Rede

Net = [16 4];
LrnRte = 0.1;
MinErr = 10e-6;
MaxIt  = 10000;

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
