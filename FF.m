xd =[0 0 1 1 0 1;
     0 1 0 1 1 0;
     0 1 1 1 0 1];
d=[1 0 0 0 0 0;
   0 1 0 0 1 0;
   0 0 1 0 0 1;
   0 0 0 1 0 0];
[~,nK] = size(xd);
x1 = xd(1,:);
x2 = xd(2,:);
x3 = xd(3,:);
x1 = normalize(x1,nK);
x2 = normalize(x2,nK);
x3 = normalize(x3,nK);
xd = [x1; x2; x3];
[xd,D] = permutation(xd,D);
nP = 3;
nS = 4;
nO = 3;
alpha = 1;
sigmoide = @(v)(1./(1+exp(-alpha*v)));
eta = 0.08;
wO = rand(nP+1,nO);
wS = rand(nO+1,nS);
for i = 1:1000
    for k = 1:nK
        xO = [1; xd(:,k)];
        vO = wO'*xO;
        yO = tanh(vO);
        xS = [1; yO];
        vS = wS'*xS;
        yS = sigmoide(vS);
        e = d(:,k)-yS;
        deltaS = e.(alpha*yS.(1-yS));
        deltaO = ((ones(nO,1)-yO)*(ones(nO,1)+yO))*(wS(2:end,:)*deltaS);
        wS = wS+eta*(deltaS*xS')';
        wO = wO+eta*(deltaO*xO')';
    end
end
%% Generalización
delete(instrfind({'port'},{'COM3'}));
canal_serie = serial('COM3','BaudRate',9600,'Terminator','CR/LF');
fopen(canal_serie);
data = fscanf(canal_serie,'%d %d %d',[3,1]);
samples1 = 1;
samples2 = 20;
R = zeros(1,1);
G = zeros(1,1);
B = zeros(1,1);
counter = 0;
while counter ~= samples1
    disp('Generalización');
    counter = counter+1;
    for i = 1:samples2
       data = fscanf(canal_serie,'%d %d %d',[3,1]);
        R(i) = abs(data(1,1));
        G(i) = abs(data(2,1));
        B(i) = abs(data(3,1)); 
    end
    R = normalize(R,samples2);
    G = normalize(G,samples2);
    B = normalize(B,samples2);
    RGB = [max(R); max(G); max(B)]
    xO = [1; RGB];
    vO = wO'*xO;
    yO = tanh(vO);
    xS = [1; yO];
    vS = wS'*xS;
    yS = sigmoide(vS);
    [~,ind] = max(yS);
    %% Clasificación por colores
    if ind == 1
        disp('COLOR ROJO');
    elseif ind == 2
         disp('COLOR AMARILLO');
    elseif ind == 3
         disp('COLOR BLANCO');
    elseif ind == 4
         disp('COLOR VERDE');
    elseif ind == 5
         disp('COLOR AZUL');
    elseif ind == 6
         disp('COLOR CYAN');
    elseif ind == 7
         disp('COLOR MORADO');
    elseif ind == 8
        disp('COLOR NEGRO');
    end
end
fclose(canal_serie);
delete(canal_serie);
clear canal_serie;

%% Funciones
function [x] = normalize(x,n)
for k = 1:n
    x(k) = (x(k)-mean(x))/(max(x)-min(x));
end
end
function [x,D] = permutation(x,D)
[~,n] = size(x);
xrp = zeros(3,n);
Drp = zeros(8,n);
rp = randperm(n);
for k = 1:n
    xrp(:,k) = x(:,rp(k));
    Drp(:,k) = D(:,rp(k));
end
x = xrp;
D = Drp;
end