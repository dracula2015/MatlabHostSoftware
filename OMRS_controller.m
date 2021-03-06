function [uavc] = OMRS_controller(qd,dqd,ddqd,q,dq)
tic
t3=clock;
global T
global P;
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
P.f=-Mavc^(-1)*Cavc*dq;

%% ESO
%% eight order
% P.e=P.z1-q;
% P.z1=P.z1+P.dt*(P.z2-P.bt1*P.e)
% P.z2=P.z2+P.dt*(P.z3+P.u-P.bt2*P.e)
% P.z3=P.z3+P.dt*(P.z4-P.bt3*P.e)
% P.z4=P.z4+P.dt*(P.Z5-P.bt4*P.e)
% P.z5=P.z5+P.dt*(P.z6-P.bt5*P.e)
% P.z6=P.z6+P.dt*(P.z7-P.bt6*P.e)
% P.z7=P.z7+P.dt*(P.z8-P.bt7*P.e)
% P.z8=P.z8+P.dt*(-P.bt8*P.e)
%% five order
% P.e=P.z1-q;
% P.z5=P.z5+P.dt*(-P.bt5*P.e);
% P.z4=P.z4+P.dt*(P.z5-P.bt4*P.e);
% P.z3=P.z3+P.dt*(P.z4-P.bt3*P.e);
% P.z2=P.z2+P.dt*(P.z3+P.u-P.bt2*P.e);
% P.z1=P.z1+P.dt*(P.z2-P.bt1*P.e);
%% four order
P.e=P.z1-q;
P.z1=P.z1+P.dt*(P.z2-P.bt1*P.e);
P.z2=P.z2+P.dt*(P.z3+P.u-P.bt2*P.e);
P.z3=P.z3+P.dt*(P.z4-P.bt3*P.e);
P.z4=P.z4+P.dt*(-P.bt4*P.e);
%% three order
% P.e=P.z1-q;
% P.z3=P.z3+P.dt*(-P.bt3*P.e);
% P.z2=P.z2+P.dt*(P.z3+P.u-P.bt2*P.e);
% P.z1=P.z1+P.dt*(P.z2-P.bt1*P.e);

%% error of q
edq=dq-dqd;
eq=q-qd;

%% gain
P.Kp = [P.wc*P.wc 0 0;0 P.wc*P.wc 0;0 0 P.wc*P.wc];
P.Kd = [2*P.w0*P.wc 0 0;0 2*P.w0*P.wc 0;0 0 2*P.w0*P.wc];

%% controller
P.u=ddqd-(P.Kp*eq)-P.Kd*(edq)-P.z3;
% P.u=ddqd-(P.Kp*eq)-P.Kd*(edq)-P.f;
% P.u=ddqd-(P.Kp*eq)-P.Kd*(edq)+Mavc^(-1)*Cavc*dq;
uavc=((Bavc)^-1)*Mavc*P.u;

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
P.uavc = uavc;
t4=clock;
T.racTime=etime(t4,t3);
P.racTime=toc;
end
