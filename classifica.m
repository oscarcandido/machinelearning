%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PERCEPTRON MULTICAMADAS                          %
%                   Oscar Felício Candido Longuinho                      %
%                                2018                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta função retorna a saída de uma rede perceptron multicamadas
% previamente treinada

function c = classifica(Net,X,W,Func)
    
   c = Forward(Net,X,W,Func); 
   c = c{size(Net,2)};
end

% FORWARD DA REDE

function [Y] = Forward(Net,X,W,fn)
    I = cell(1,size(Net,2));
    Y = cell(1,size(Net,2));
    Layers = size(W,2);
    for i=1:Net(1)                  %para cada neoronio da primeira camada
        I{1}(i) = X * W{1}(:,i);
        Y{1} = active(I{1},fn); 
    end
    for i=2:Layers                         %para cada camada i
        Y{i-1} = vertcat(1,Y{i-1});        %acrescenta o Bias
        for j = 1:Net(i)                   %para cada neorônio j na camada i
            I{i}(j) = Y{i-1}' * W{i}(:,j); %calcula o input do neorônio j 
        end
        Y{i} = active(I{i},fn);             
    end

end

% FUNÇÃO DE ATIVAÇÃO
function y = active(inp,fn)
    y = zeros(length(inp),1);
    if upper(fn) == "LOGSIG"
        %função logística
        for i=1:length(inp)
            y(i) = logsig(inp(i));
        end
    else
        if upper(fn) == "TANH"
            %tangente hiperbólica
            for i=1:length(inp)
                y(i) = tanh(inp(i));
            end
        end
    end
end

