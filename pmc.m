%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                   Oscar Felício Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear;
clc;

%% Dados

Data = csvread('livro59.csv');      %Dados dos exemplos
X = Data(:,1:4);                    %entradas
X = horzcat(ones(size(X,1),1),X);   %adiciona bias às entradas
D = Data(:,5:7);                    %alvos


%% parâmetros

Net = [15 3];                   %neurônios por camada
layers =  size(Net,2);          %número de Camadas
NumEx = size(X,1);              %Número de Exemplos
NumIn = size(X,2);              %Número de Entradas 
[W,I,Y] = initNet(Net,NumIn);   %Inicia os parãmetros da rede
PrvW = W;                       %pesos da iteração anterior
LrnRte = 0.1;                   %Taxa de aprendizagem
MomRte = 0;                     %Taxa de Momentum
Momentum = 0.9;                  %Momentum
count = 0;                      %Contador de épocas
MaxCount = 10000;               %Número máximo de épocas
minErr = 10e-6;                 %erro mínimo;
EM = inf;                       %erro 
PrvError = 1;                   %erro anterior
CurError = 0;                   %erro atual
Delta = cell(1,layers);         %Delta de Cada neorônio
%% Treinamento

while ((abs(EM - PrvError) > minErr ) && (count < MaxCount)) %Enquanto a variação do erro for maior que o limite
    PrvError = CalcError(Net,X,D,W);
    PrvW = W;    
    for k = 1:NumEx %para cada exemplo
        %FORWARD 
        [I,Y] = Forward(Net,X(k,:),W);
        
        %BACKWARD
        
        %cálculo do Delta da camada de saída
        
        Delta{layers} = (D(k,:)' - Y{layers}) .* (derivative(I{layers}'));
        
        %atualização dos pesos das camadas de saída
        
        for j=1:Net(layers)
            Momentum = MomRte *(W{layers}(:,j) - PrvW{layers}(:,j));
            W{layers}(:,j) = W{layers}(:,j) + Momentum + LrnRte*Delta{layers}(j).*Y{layers-1};
        end
        
        %Cálculo do Delta das outras camadas 
        for n = (layers-1):-1:1
            for j = 1:Net(n)
                Delta{n}(j,1) = -(W{n+1}(j,:) * Delta{n+1}).* (derivative(I{n}(j)'));
            end
            for j=1:Net(n)
                Momentum = MomRte *(W{n}(:,j) - PrvW{n}(:,j));
                if n>1 %se não for a camada de entrada
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

%% Validação 
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
%% Funções

% INICIA OS PARÂMETROS DA REDE

function [W,I,Y] = initNet(Net,NumIn) 
    W = cell(1,size(Net,2));            % pesos sinápticos
    I = cell(1,size(Net,2));            % inputs dos neorônios
    Y = cell(1,size(Net,2));            % outputs dos neorônios
    W(1) = {rand(NumIn,Net(1))};
    I(1) = {zeros(Net(1),1)};
    Y(1) = {zeros(Net(1),1)};
    for i=2:size(Net,2)
        W(i) = {rand(Net(i-1)+1,Net(i))};
        I(i) = {zeros(Net(i),1)};
        Y(i) = {zeros(Net(i),1)};
    end
end

% FUNÇÃO DE ATIVAÇÃO

function y = active(inp)
    y = zeros(length(inp),1);
    
    %função logística
    for i=1:length(inp)
        y(i) = logsig(inp(i));
    end
 
end

% DERIVADA DA FUNÇÃO DE ATIVAÇÃO

function dy = derivative(y)
    dy = zeros(length(y),1);
    %função logística
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
        for j = 1:Net(i)                 %para cada neorônio j na camada i
            I{i}(j) = Y{i-1}' * W{i}(:,j); 
        end
        Y{i} = active(I{i});
    end

end

function em = CalcError(Net,X,D,W)
    HistError = zeros(size(X,1),1);     %histórico de erros
    for k=1:size(X,1)
        [I,Y] = Forward(Net,X(k,:),W);
        HistError(k)= (sum((D(k,:)' - Y{size(Net,2)}).^2))/2;
    end
    em = (sum(HistError))/size(X,1);   
end