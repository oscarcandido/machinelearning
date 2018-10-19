%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                 TESTE COM DADOS DE CORES COLETADOS                     %
%                   Oscar Felício Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;


%% Dados treinamento

Data = csvread('DADOS_COMPLETOS.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias às entradas
D = Data(:,5:10);                    %alvos

%% Dados validação

Datav = csvread('DADOS_COMPLETOS.csv');     
Xv = Datav(:,1:4);                    
Xv = horzcat(ones(size(Xv,1),1),Xv); 
Dv = Datav(:,5:10); 

%% Parâmetros da Rede

Net = [14 6];
LrnRte = 0.1;
MinErr = 10e-10;
MaxIt  = 50000;

%% treinamento da rede
[W,Er,Time]= mlp(Net,X,D,LrnRte,MinErr,MaxIt);


%% validação
Y = cell(1);
for i=1:size(Xv,1)
    Y{i} = classifica(Net,Xv(i,:),W,"logsig");
end

%% Ajuste das respostas da validação
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

%% Comparação da saída ajustada da rede com o esperado

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
%% Apresentação dos resultados
figure;
plot(Er);
xlabel('Épocas');
ylabel('Erro');
title('Evolução do Erro Quadrático Médio no Treinamento');

t1 = ' Número de amostras testadas : ';
t2 = ' Número de respostas corretas: ';
t3 = ' Taxa de acerto: ';
disp([t1,num2str(size(Dv,1))]);
disp([t2,num2str(Acertos)]);
disp([t3,num2str(TxAcertos*100),'%']);
