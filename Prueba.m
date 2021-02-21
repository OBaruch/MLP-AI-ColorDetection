hold on 
grid on
figure
for i = 1:20:255
    for j=1 :20:255
        for k=1:20:255
xg=[i;j;k]; %entrada
            x0=[1;xg]; %entrada con bias
            v0=wO'*x0; %applicacion 
            y0=tanh(v0);
            xS=[1; y0]; % salida
            vS=wS'*xS;
            yS=sigmoide(vS)';
            [~,ic]=max(yS);
          if ic==1
                plot3(xg(1),xg(2),xg(3),'w.');
            elseif ic==2
                plot3(xg(1),xg(2),xg(3),'g.');
            elseif ic==3
                plot3(xg(1),xg(2),xg(3),'b.');
            elseif ic==4
                plot3(xg(1),xg(2),xg(3),'c.');
            elseif ic==5
                plot3(xg(1),xg(2),xg(3),'k.');
            elseif ic==6
                plot3(xg(1),xg(2),xg(3),'r.');
            elseif ic==7
                plot3(xg(1),xg(2),xg(3),'y.');
            elseif ic==8
                plot3(xg(1),xg(2),xg(3),'m.');
            end             
        end
    end
end

