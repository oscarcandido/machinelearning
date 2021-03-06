clear
close all;

%% Dados
load iris_dataset.mat;
Data = irisInputs(2:4,1:100);
Alvo = irisTargets(1,1:100);

%% Gr�fico
% figure;
% 
% d1 = Data(1,:);
% d2 = Data(2,:);
% d3 = Data(3,:);
% n = size(d1,2);
% for i=1:n
%     if Alvo(i) == 0
%         plot3(d1(i),d2(i),d3(i),'r*')
%     else
%         plot3(d1(i),d2(i),d3(i),'b+')
%     end
%     hold on;
% end
%% Dados de treinamento
X = Data';%entradas
Y = Alvo';%alvo
nEx  = size(X,1); %n�mero de exemplos
B = ones(nEx,1);
X = horzcat(B,X);
nImp = size(X,2); %n�mero de entradas
%Taxa de aprendizagem
n = 0.1;
%% regress�o linear 
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
Pocket = W;
iPk = 1;
%N� m�ximo de itera��es
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
    if txAcertos(cont) > txAcertos(iPk)
        iPk = cont;
        Pocket = W;
    end
    cont = cont +1;
end
%% Gr�fico

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
plot(txAcertos,'r*');

%% Classifica��o
function c = classifica(I)
    global W;
    c = ativ(I*W);
end
%% fun��o de ativa��o
function n = ativ(v)
    if v <= 0 
        n = 0;
    else
        n = 1;
    end
end