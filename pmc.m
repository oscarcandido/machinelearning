%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                   Oscar Fel�cio Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;

%% Dados

Data = csvread('livro59.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias �s entradas
D = Data(:,5:7);                    %alvos


%% par�metros

Net = [15 3];                   %neur�nios por camada
layers =  size(Net,2);          %n�mero de Camadas
NumEx = size(X,1);              %N�mero de Exemplos
NumIn = size(X,2);              %N�mero de Entradas 
[W,I,Y] = initNet(Net,NumIn);   %Inicia os par�metros da rede
PrvW = W;                       %pesos da itera��o anterior
LrnRte = 0.1;                   %Taxa de aprendizagem
MomRte = 0;                     %Taxa de Momentum
Momentum = 0.9;                  %Momentum
count = 0;                      %Contador de �pocas
MaxCount = 10000;               %N�mero m�ximo de �pocas
minErr = 10e-6;                 %erro m�nimo;
EM = inf;                       %erro 
PrvError = 1;                   %erro anterior
CurError = 0;                   %erro atual
Delta = cell(1,layers);         %Delta de Cada neor�nio
%% Treinamento

while ((abs(EM - PrvError) > minErr ) && (count < MaxCount)) %Enquanto a varia��o do erro for maior que o limite
    PrvError = CalcError(Net,X,D,W);
    PrvW = W;    
    for k = 1:NumEx %para cada exemplo
        %FORWARD 
        [I,Y] = Forward(Net,X(k,:),W);
        
        %BACKWARD
        
        %c�lculo do Delta da camada de sa�da
        
        Delta{layers} = (D(k,:)' - Y{layers}) .* (derivative(I{layers}'));
        
        %atualiza��o dos pesos das camadas de sa�da
        
        for j=1:Net(layers)
            Momentum = MomRte *(W{layers}(:,j) - PrvW{layers}(:,j));
            W{layers}(:,j) = W{layers}(:,j) + Momentum + LrnRte*Delta{layers}(j).*Y{layers-1};
        end
        
        %C�lculo do Delta das outras camadas 
        for n = (layers-1):-1:1
            for j = 1:Net(n)
                Delta{n}(j,1) = -(W{n+1}(j,:) * Delta{n+1}).* (derivative(I{n}(j)'));
            end
            for j=1:Net(n)
                Momentum = MomRte *(W{n}(:,j) - PrvW{n}(:,j));
                if n>1 %se n�o for a camada de entrada
                    W{n}(:,j) = W{n}(:,j) + Momentum + LrnRte*Delta{n}(j).*Y{n-1};
                else %se for a camada de entrada
                    W{n}(:,j) = W{n}(:,j) + Momentum + LrnRte*Delta{n}(j).*X(k,:)';
                end
            end
        end
    end
    CurError  = CalcError(Net,X,D,W);
    EM = CurError;
    count = count+1;
    Er(count) = CurError;
end
plot(Er);

%% Valida��o 
Exit = cell(NumEx,1);
for k=1:NumEx
    [I,Y] = Forward(Net,X(k,:),W);
    Exit{k}= Y{layers};
end
ContAcertos = 0; 
ExitAdj = cell(NumEx,1);
for k=1:NumEx
    for j=1:Net(layers)
        if Exit{k}(j,1) >= 0.5
            ExitAdj{k}(j,1) = 1;
        else
            ExitAdj{k}(j,1) = 0;
        end
    end
    
    if isequal(ExitAdj{k}', D(k,:))
        Acertos(k) = 1;
        ContAcertos = ContAcertos + 1; 
    else
        Acertos(k) = 0;
    end
end
disp(ContAcertos/NumEx)
%% Fun��es

% INICIA OS PAR�METROS DA REDE

function [W,I,Y] = initNet(Net,NumIn) 
    W = cell(1,size(Net,2));            % pesos sin�pticos
    I = cell(1,size(Net,2));            % inputs dos neor�nios
    Y = cell(1,size(Net,2));            % outputs dos neor�nios
    W(1) = {rand(NumIn,Net(1))};
    I(1) = {zeros(Net(1),1)};
    Y(1) = {zeros(Net(1),1)};
    for i=2:size(Net,2)
        W(i) = {rand(Net(i-1)+1,Net(i))};
        I(i) = {zeros(Net(i),1)};
        Y(i) = {zeros(Net(i),1)};
    end
end

% FUN��O DE ATIVA��O

function y = active(inp)
    y = zeros(length(inp),1);
    
    %fun��o log�stica
    for i=1:length(inp)
        y(i) = logsig(inp(i));
    end
 
end

% DERIVADA DA FUN��O DE ATIVA��O

function dy = derivative(y)
    dy = zeros(length(y),1);
    %fun��o log�stica
    for a=1:length(y)
        dy(a) = logsig(y(a)) * (1-logsig(y(a)));
    end
end

% FORWARD DA REDE

function [I,Y] = Forward(Net,X,W)
    I = cell(1,size(Net,2));
    Y = cell(1,size(Net,2));
    Layers = size(W,2);
    for i=1:Net(1)                  %para cada neoronio da primeira camada
        I{1}(i) = X * W{1}(:,i);
        Y{1} = active(I{1}); 
    end
    for i=2:Layers                       %para cada camada i
        Y{i-1} = vertcat(1,Y{i-1});      %acrescenta o Bias
        for j = 1:Net(i)                 %para cada neor�nio j na camada i
            I{i}(j) = Y{i-1}' * W{i}(:,j); 
        end
        Y{i} = active(I{i});
    end

end

function em = CalcError(Net,X,D,W)
    HistError = zeros(size(X,1),1);     %hist�rico de erros
    for k=1:size(X,1)
        [I,Y] = Forward(Net,X(k,:),W);
        HistError(k)= (sum((D(k,:)' - Y{size(Net,2)}).^2))/2;
    end
    em = (sum(HistError))/size(X,1);   
end