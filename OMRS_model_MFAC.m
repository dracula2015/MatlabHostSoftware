function [DDQ] = OMRS_model(u,q,dq,beta0,beta1,beta2,m,La,Iv)
%OMRS_model Summary of this function goes here
%Detailed explanation goes here
tic
t5=clock;
global T
global P;
Rav=[cos(q(3)), -sin(q(3)), 0;
     sin(q(3)), cos(q(3)), 0;
     0, 0, 1];
DRav=[-sin(q(3))*dq(3), -cos(q(3))*dq(3), 0;
      cos(q(3))*dq(3), -sin(q(3))*dq(3), 0;
      0, 0, 0];
M2av=[1.5*beta0 + m, 0, 0; 
      0, 1.5*beta0 + m, 0; 
      0 , 0, 3*beta0*La^2 + Iv];
C2av=[1.5*beta1, -m*dq(3), 0;
      m*dq(3), 1.5*beta1, 0;
      0, 0, 3*beta1*La^2];
Mav=M2av*Rav';
Cav=C2av*Rav'-M2av*Rav'*DRav*Rav';
Bav=beta2*[-0.5, -0.5, 1;
            0.866, -0.866, 0;
            La, La, La;];
DDQ=Mav\(Bav*u-Cav*dq);

% for i=1:3
%     if (0.125*pi<mod(P.phy(i),pi/2) && mod(P.phy(i),pi/2)<=0.375*pi)
%         P.L(i)=P.Din;
%     else if (-0.125*pi<mod(P.phy(i),pi/2) && mod(P.phy(i),pi/2)<=0.125*pi)
%             P.L(i)=P.Dout;
%         else
%         end;
%     end
% end
% P.J=[-1/2, sqrt(3)/2, P.L(1);
%      -1/2, -sqrt(3)/2, P.L(2);
%       1, 0, P.L(3)];

t6=clock;
T.mfacModelTime=etime(t6,t5);
P.mfacModelTime=toc;
end