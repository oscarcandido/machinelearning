close all;
clear all;
%% Dados de treinamento
%Data = csvread('Data1.csv');%Dados dos exemplos
x1_w1=[0.1; 6.8; -3.5; 2.0; 4.1; 3.1; -0.8; 0.9; 5.0; 3.9];
x2_w1=[1.1; 7.1; -4.1; 2.7; 2.8; 5.0; -1.3; 1.2; 6.4; 4.0];
w1=[x1_w1 x2_w1];
x1_w3=[-3.0; 0.5; 2.9; -0.1; -4.0; -1.3; -3.4; -4.1; -5.1; 1.9];
x2_w3=[-2.9; 8.7; 2.1; 5.2; 2.2; 3.7; 6.2; 3.4; 1.6; 5.1];
w3=[x1_w3 x2_w3];
figure;
plot(x1_w1,x2_w1,'ro');
hold on;
plot(x1_w3,x2_w3,'b+');
hold off;
%% 
X = [w1; w3];%entradas
Y = [-ones(length(w1),1); ones(length(w3),1)];%alvo
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
W = Wr;%rand(nImp,1);
Pocket = W;
iPk = 1;
%Nº máximo de iterações
MaxIt = 1000;
cont = 1;
Taxa = 0;
%% treinamento 
while (( Taxa < 1  ) && (cont < MaxIt))
    nAcertos = 0;
    for i = 1:nEx
        y = classifica(X(i,:));
        if y ~= Y(i)
            erro = Y(i) - y;
            W = W + (n*erro*X(i,:)');
            nW = nW +1;
        end
    end
    txAcertos(cont) = TaxaAcertos(X,Y,W);
    Taxa = txAcertos(cont);
    if txAcertos(cont) > txAcertos(iPk)
        iPk = cont;
        Pocket = W;
    end
    cont = cont +1;
end
%% Gráfico
figure;
for i = 1:nEx
        y = classificaPocket(X(i,:),Pocket);
        if y == 1
           % plot(p(2),p(3),'b+')
           if y ==(Y(i))
               plot(X(i,2),X(i,3),'b+')
           else
               plot(X(i,2),X(i,3),'k+')
           end
        else
           % plot(p(2),p(3),'go')
           if y == Y(i)
               plot(X(i,2),X(i,3),'go')
           else
               plot(X(i,2),X(i,3),'ko')
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
plot(txAcertos,'b*');
%% taxa de acertos
function t = TaxaAcertos(X,Y,W)
    Acertos = 0;
    for i=1:length(X)
        y = classificaPocket(X(i,:),W);
        if y == Y(i)
            Acertos = Acertos + 1;
        end
    end
    t = Acertos / length(X);
end
%% Classificação
function c = classifica(I)
    global W;
    c = ativ(I*W);
end
function c = classificaPocket(I,Wp)
    c = ativ(I*Wp);
end
%% função de ativação
function n = ativ(v)
    if v <= 0 
        n = -1;
    else
        n = 1;
    end
end
