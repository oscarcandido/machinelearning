%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                   Oscar Fel�cio Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [W,Er,Time]= mlp(net,x,d,lr,miner,maxit)
    %% Dados
    tic
    X = x;                    %entradas
    D = d;                    %alvos


    %% par�metros

    Net = net;                      %neur�nios por camada
    layers =  size(Net,2);          %n�mero de Camadas
    NumEx = size(X,1);              %N�mero de Exemplos
    NumIn = size(X,2);              %N�mero de Entradas 
    [W,I,Y] = initNet(Net,NumIn);   %Inicia os par�metros da rede
    PrvW = W;                       %pesos da itera��o anterior
    LrnRte = lr;                    %Taxa de aprendizagem
    count = 0;                      %Contador de �pocas
    MaxCount = maxit;               %N�mero m�ximo de �pocas
    minErr = miner;                 %erro m�nimo;
    EM = inf;                       %erro 
    PrvError = 1;                   %erro anterior
    CurError = 0;                   %erro atual
    Delta = cell(1,layers);         %Delta de Cada neor�nio
    %% Treinamento

    while ((abs(EM - PrvError) > minErr ) && (count < MaxCount)) %Enquanto a varia��o do erro for maior que o limite
        PrvError = CalcError(Net,X,D,W);
        for k = 1:NumEx %para cada exemplo
            %FORWARD 
            [I,Y] = Forward(Net,X(k,:),W);

            %BACKWARD

            %c�lculo do Delta da camada de sa�da

            Delta{layers} = (D(k,:)' - Y{layers}) .* (derivative(I{layers}'));

            %atualiza��o dos pesos das camadas de sa�da

            for j=1:Net(layers)
                W{layers}(:,j) = W{layers}(:,j) + LrnRte*Delta{layers}(j).*Y{layers-1};
            end

            %C�lculo do Delta das outras camadas 
            for n = (layers-1):-1:1
                for j = 1:Net(n)
                    Delta{n}(j,1) = -(W{n+1}(j,:) * Delta{n+1}).* (derivative(I{n}(j)'));
                end
                for j=1:Net(n)
                    if n>1 %se n�o for a camada de entrada
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
    for i=2:Layers                         %para cada camada i
        Y{i-1} = vertcat(1,Y{i-1});        %acrescenta o Bias
        for j = 1:Net(i)                   %para cada neor�nio j na camada i
            I{i}(j) = Y{i-1}' * W{i}(:,j); %calcula o input do neor�nio j 
        end
        Y{i} = active(I{i});             
    end

end

% C�LCULA O ERRO QUADR�TICO M�DIO

function em = CalcError(Net,X,D,W)
    HistError = zeros(size(X,1),1);     %hist�rico de erros
    for k=1:size(X,1)
        [I,Y] = Forward(Net,X(k,:),W);
        HistError(k)= (sum((D(k,:)' - Y{size(Net,2)}).^2))/2;
    end
    em = (sum(HistError))/size(X,1);   
end