%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                   Oscar Felício Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [W,Er,Time]= mlp(net,x,d,lr,miner,maxit)
    %% Dados
    tic
    X = x;                    %entradas
    D = d;                    %alvos


    %% parâmetros

    Net = net;                      %neurônios por camada
    layers =  size(Net,2);          %número de Camadas
    NumEx = size(X,1);              %Número de Exemplos
    NumIn = size(X,2);              %Número de Entradas 
    [W,I,Y] = initNet(Net,NumIn);   %Inicia os parãmetros da rede
    PrvW = W;                       %pesos da iteração anterior
    LrnRte = lr;                    %Taxa de aprendizagem
    count = 0;                      %Contador de épocas
    MaxCount = maxit;               %Número máximo de épocas
    minErr = miner;                 %erro mínimo;
    EM = inf;                       %erro 
    PrvError = 1;                   %erro anterior
    CurError = 0;                   %erro atual
    Delta = cell(1,layers);         %Delta de Cada neorônio
    %% Treinamento

    while ((abs(EM - PrvError) > minErr ) && (count < MaxCount)) %Enquanto a variação do erro for maior que o limite
        PrvError = CalcError(Net,X,D,W);
        for k = 1:NumEx %para cada exemplo
            %FORWARD 
            [I,Y] = Forward(Net,X(k,:),W);

            %BACKWARD

            %cálculo do Delta da camada de saída

            Delta{layers} = (D(k,:)' - Y{layers}) .* (derivative(I{layers}'));

            %atualização dos pesos das camadas de saída

            for j=1:Net(layers)
                W{layers}(:,j) = W{layers}(:,j) + LrnRte*Delta{layers}(j).*Y{layers-1};
            end

            %Cálculo do Delta das outras camadas 
            for n = (layers-1):-1:1
                for j = 1:Net(n)
                    Delta{n}(j,1) = -(W{n+1}(j,:) * Delta{n+1}).* (derivative(I{n}(j)'));
                end
                for j=1:Net(n)
                    if n>1 %se não for a camada de entrada
                        W{n}(:,j) = W{n}(:,j) + LrnRte*Delta{n}(j).*Y{n-1};
                    else %se for a camada de entrada
                        W{n}(:,j) = W{n}(:,j) + LrnRte*Delta{n}(j).*X(k,:)';
                    end
                end
            end
        end
        CurError  = CalcError(Net,X,D,W);
        EM = CurError;
        count = count+1;
        Er(count) = CurError;
    end
    Time = toc;
end
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
    for i=2:Layers                         %para cada camada i
        Y{i-1} = vertcat(1,Y{i-1});        %acrescenta o Bias
        for j = 1:Net(i)                   %para cada neorônio j na camada i
            I{i}(j) = Y{i-1}' * W{i}(:,j); %calcula o input do neorônio j 
        end
        Y{i} = active(I{i});             
    end

end

% CÁLCULA O ERRO QUADRÁTICO MÉDIO

function em = CalcError(Net,X,D,W)
    HistError = zeros(size(X,1),1);     %histórico de erros
    for k=1:size(X,1)
        [I,Y] = Forward(Net,X(k,:),W);
        HistError(k)= (sum((D(k,:)' - Y{size(Net,2)}).^2))/2;
    end
    em = (sum(HistError))/size(X,1);   
end