close all;
%% Dados de treinamento
Data = csvread('LOG.csv');%Dados dos exemplos
X = Data(:,1:3);%entradas
Y = Data(:,4);%alvo
nEx  = size(X,1); %número de exemplos
B = ones(nEx,1);
X = horzcat(B,X);
nImp = size(X,2); %número de entradas
%Taxa de aprendizagem
n = 0.1;
%% regressão linear 
Wr = pinv(X) * Y;
Yr = zeros(nEx,1);
for i=1:nEx
    Yr(i) = ativ(X(i,:) * Wr); 
end

%% 
%inicia vetor de pesos
global W 
nW = 0;
W = rand(nImp,1);
%Nº máximo de iterações
MaxIt = 10;
cont = 1;
nAcertos = 0;
%% treinamento 
while (nAcertos/nEx) ~= 1
    nAcertos = 0;
    for i = 1:nEx
        y = classifica(X(i,:));
        if y ~= Y(i)
            erro = Y(i) - y;
            W = W + (n*erro*X(i,:)');
            nW = nW +1;
        else 
            nAcertos = nAcertos + 1;
        end
    end
    txAcertos(cont) = nAcertos/nEx;
    cont = cont +1;
end
%% Gráfico

for i = 1:nEx
        y = classifica(X(i,:));
        if y == 1
           % plot(p(2),p(3),'b+')
           if y ==(Y(i))
               plot3(X(i,2),X(i,3),X(i,4),'b+')
           else
               plot3(X(i,2),X(i,3),X(i,4),'k+')
           end
        else
           % plot(p(2),p(3),'go')
           if y == Y(i)
               plot3(X(i,2),X(i,3),X(i,4),'go')
           else
               plot3(X(i,2),X(i,3),X(i,4),'ko')
           end
        end 
        hold on;
end
%% teste
% A = [0 125 20];
% A = horzcat(1,A);
% classifica(A)
% plot3(A(2),A(3),A(4),'r*')
figure;
plot(txAcertos,'b-*');

%% Classificação
function c = classifica(I)
    global W;
    c = ativ(I*W);
end
%% função de ativação
function n = ativ(v)
    if v <= 0 
        n = -1;
    else
        n = 1;
    end
end
