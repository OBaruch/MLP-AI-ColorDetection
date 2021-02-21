%% MLP
%% Entrenamiento 
close all; clear all; clc
sigmoide = @(v) 1./(1+exp(-v)); %Para poder hacer calculos matriciales con ella
xd =[0 0 1 1;
     0 1 0 1];
d=[1 0 0 0;
   0 1 0 0;
   0 0 1 0;
   0 0 0 1];
nK=4; %datos de entrenaimiento 
nP=2; %numero de entradas
nS=4; %numero de salidas
nO=10; %capa oculta
eta=.1; %aprendisaje
wO=rand(nP+1,nO); %Inicialisamos pesos aleatorios de capa oculta
wS=rand(nO+1,nS); %Inicialisamos pesos aleatorios de capa de salida
eVector=[];
for i=1:1000 %iteraciones del MLP
    eA=0;
    for k=1:nK  %para recopilacion de datos de entreniamiento
        %% Porpagacion hacia delante
        xO=[1; xd(:,k)]; % agregamos al dato k el bias
        vO=wO'*xO;      % se calcula la salida de las neuronas de la clapa oculta 
        yO= tanh(vO);   % se calucla la funcion de activacion de las salida de la capa oculta
        xS=[1; yO];     % ahora las salida son la entrada de la capa de salida
        vS=wS'*xS;      % se calucla la salida de las neuronas  de la capa de salida
        yS=sigmoide(vS); % se calulca la funcion de activacion de la capa de salida
        e=d(:,k)-yS;    %Se calucla el error al deseado 
        eA=eA+e;
        %% Propagacion hacia atras
        deltaS=e.*(yS.*(1-yS));
        deltaO=((ones(nO,1)-yO).*(ones(nO,1)+yO)).*(wS(2:end,:)*deltaS);
        %% Reecalculo de los pesos
        wS=wS+eta*(deltaS*xS')';
        wO=wO+eta*(deltaO*xO')';
        
    end
    eVector=[eVector eA];
end
% Plotear evoluvion el error por iteracion
for sal=1:nS
figure
plot(eVector(sal,:));
str = sprintf('Erro en la salida: %d', sal);
title(str);
end

%% GENERALIZACION 
hold on 
grid on
axis([-1 1 -1 1])

for i=-1:.01:1
    for j=-1:.01:1
        xg=[i;j]; %entrada
        x0=[1;xg]; %entrada con bias
        v0=wO'*x0; %applicacion 
        y0=tanh(v0);
        xS=[1; y0]; % salida
        vS=wS'*xS;
        yS=sigmoide(vS)';
        [~,ic]=max(yS);
        if ic==1
            plot(xg(1),xg(2),'r.');
        elseif ic==2
            plot(xg(1),xg(2),'b.');
        elseif ic==3
            plot(xg(1),xg(2),'g.');
        elseif ic==4
            plot(xg(1),xg(2),'k.');
        end        
    end
end