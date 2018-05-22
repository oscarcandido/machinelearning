%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                           VALIDAÇÃO DA REDE                            %
%                   Oscar Felício Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;


%% Dados treinamento

Data = csvread('livro59.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias às entradas
D = Data(:,5:7);                    %alvos

%% Dados validação

Datav = csvread('tabela55.csv');     
Xv = Datav(:,1:4);                    
Xv = horzcat(ones(size(Xv,1),1),Xv); 
Dv = Datav(:,5:7); 

%% Parâmetros da Rede

Net = [15 3];
LrnRte = 0.1;
MinErr = 10e-6;
MaxIt  = 1000;

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
