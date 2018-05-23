function desiredAttitude = RefTrajectory
%RefTrajectory 此处显示有关此函数的摘要
%   此处显示详细说明
global initFinished initialAttitude onStartAttitude P;
P.speed=0.1;
P.rectLength=1;
if initFinished
    %% rectangle
    if(P.Trajectory == 1)
        if(0<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<P.rectLength)
            x=mod(P.instantTime*P.speed,4*P.rectLength);
            y=0;
        elseif(P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<2*P.rectLength)
            x=P.rectLength;
            y=mod(P.instantTime*P.speed,4*P.rectLength)-P.rectLength;
        elseif(2*P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<3*P.rectLength)
            x=3*P.rectLength-mod(P.instantTime*P.speed,4*P.rectLength);
            y=P.rectLength;
        elseif(3*P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<4*P.rectLength)
            x=0;
            y=4*P.rectLength-mod(P.instantTime*P.speed,4*P.rectLength);
        end;
%         if (P.instantTime > 15)
%             theta = 0.35 * (P.instantTime - 15);
%         end
%         theta=0;
    end
    %% circle
    if(P.Trajectory == 0)
        x=0.8*cos(pi/15*P.instantTime);
        y=0.8*sin(pi/15*P.instantTime);
    end
    %% lemniscate
    if(P.Trajectory == 2)
%         x=2*sin(0.05*P.instantTime*pi);
%         y=sin(0.1*P.instantTime*pi);
        x=0.5*sin(0.05*P.instantTime*pi);
        y=0.5*sin(0.1*P.instantTime*pi);
    end
    %% theta
    if(0<=P.instantTime && P.instantTime<=10)
        theta = 0;
    elseif(10<P.instantTime && P.instantTime<=20)
        theta=0.35*(P.instantTime-10);
    elseif(20<=P.instantTime && P.instantTime<30)
            theta=3.5;
    elseif(30<=P.instantTime && P.instantTime<=40)
        theta=3.5+0.5*sin(pi/5*P.instantTime);
    else
        theta=3.5;
    end
    desiredAttitude = [x;y;theta];
else
    if P.instantTime < 10
        desiredAttitude = onStartAttitude' + P.instantTime*(initialAttitude - onStartAttitude')/10;
    else desiredAttitude = initialAttitude;
    end
end
end