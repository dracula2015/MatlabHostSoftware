function [uavc] = OMRS_NPID_controller_1995(qd,dqd,ddqd,q,dq)
global P;
tic
t3=clock;
global T
beta = 1;%0.5;%1.5;%2;%1;
alpha = 10;%12;%10;%8;
kp1=6;%3;%4;%5;
%%
deta=0.001;
Ravc=[cos(q(3)), -sin(q(3)), 0;
    sin(q(3)), cos(q(3)), 0;
    0, 0, 1];
DRavc=[-sin(q(3))*dq(3), -cos(q(3))*dq(3), 0;
    cos(q(3))*dq(3), -sin(q(3))*dq(3), 0;
    0, 0, 0];
M2avc=[1.5*P.beta0 + P.m, 0, 0;
    0, 1.5*P.beta0 + P.m, 0;
    0 , 0, 3*P.beta0*P.La^2 + P.Iv];
C2avc=[1.5*P.beta1, -P.m*dq(3), 0;
    P.m*dq(3), 1.5*P.beta1, 0;
    0, 0, 3*P.beta1*P.La^2];
Mavc=M2avc*Ravc';
Cavc=C2avc*Ravc'-M2avc*Ravc'*DRavc*Ravc';
Bavc=P.beta2*[-0.5, -0.5, 1;
    0.866, -0.866, 0;
    P.La, P.La, P.La;];
P.nf=-Mavc^(-1)*Cavc*dq;
P.ne=P.nz1-q;

%% ESO
%% four order
% P.ne=P.nz1-q;
% P.nz4=P.nz4+P.dt*(-P.bt4*P.ne);
% P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*P.ne);
% P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*P.ne);
% P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne);

P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne);
P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*P.ne);
P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*P.ne);
P.nz4=P.nz4+P.dt*(-P.bt4*P.ne);

%% three order
% P.nz3=P.nz3+P.dt*(-P.bt3*P.ne);
% P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*P.ne);
% P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne);

%% error of q
edq=dq-dqd;
eq=q-qd;

%% gain
P.k(1) = 0 + kp1/(1 + beta * exp(alpha * (-edq(1)) * eq(1)));
P.k(2) = 0 + kp1/(1 + beta * exp(alpha * (-edq(2)) * eq(2)));
P.k(3) = 0 + kp1/(1 + beta * exp(alpha * (-edq(3)) * eq(3)));

P.kd(1) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(1)) * eq(1)));
P.kd(2) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(2)) * eq(2)));
P.kd(3) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(3)) * eq(3)));

P.KpN = [P.wc*P.wc+P.k(1)*P.wc*P.wc 0 0;0 P.wc*P.wc+P.k(2)*P.wc*P.wc 0;0 0 P.wc*P.wc+P.k(3)*P.wc*P.wc];
P.KdN = [(1+P.kd(1))*2*P.w0*P.wc 0 0;0 (1+P.kd(2))*2*P.w0*P.wc 0;0 0 (1+P.kd(3))*2*P.w0*P.wc];

%% controller
P.nu=ddqd-(P.KpN*eq)-(P.KdN*edq)-(P.nz3);
% P.nu=ddqd-(P.KpN*eq)-(P.KdN*(P.nz2-dqd))-(P.nz3);
% P.nu=ddqd-(P.KpN*eq)-(P.KdN*edq)-P.nf;
% P.nu=ddqd-P.KpN*eq-P.KdN*edq+Mavc^(-1)*Cavc*dq;
% uavc=inv(Bavc)*Mavc*(ddqd-P.Kd*(dq-dqd)-P.Kp*(q-qd))+inv(Bavc)*Cavc*dq
uavc=((Bavc)^-1)*Mavc*P.nu;

%% output limitation
if uavc(1) > 24
    uavc(1) = 24;
elseif uavc(1) < -24
    uavc(1) = -24;
end

if uavc(2) > 24
    uavc(2) = 24;
elseif uavc(2) < -24
    uavc(2) = -24;
end

if uavc(3) > 24
    uavc(3) = 24;
elseif uavc(3) < -24
    uavc(3) = -24;
end
P.nuavc = uavc;
P.NPIDKP=[P.NPIDKP P.k];
P.BASCIKP=[P.BASCIKP [P.KpN(1); P.KpN(5); P.KpN(9)]];
t4=clock;
T.npdTime=etime(t4,t3);
P.npdTime=toc;
end