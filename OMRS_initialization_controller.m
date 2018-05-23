function [uavc] = OMRS_initialization_controller(qd,dqd,ddqd,q,dq)
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
f=-Mavc^(-1)*Cavc*dq;

%% error of q
edq=dq-dqd;
eq=q-qd;

%% gain
w0 = 0.1;%1%2%4;
wc = 0.5;%15%5%15%20%4%10%15;
Kp = [wc*wc 0 0;0 wc*wc 0;0 0 wc*wc];
Kd = [2*w0*wc 0 0;0 2*w0*wc 0;0 0 2*w0*wc];

%% controller
u=ddqd-(Kp*eq)-Kd*(edq)-f;
uavc=((Bavc)^-1)*Mavc*u;

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
end
