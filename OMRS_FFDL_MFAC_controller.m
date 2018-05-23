function [control_effect] = OMRS_FFDL_MFAC_controller(qd,dqd,ddqd,q,dq)
tic
t3=clock;
global T;
global P;
global MFAC
% epsilon = 10^-5;
% MFAC.lambda = 0.01;
% rho1 = 0.5;
% rho2 = 0.5;
% rho3 = 0.5;

% rho = zeros(MFAC.Ly + MFAC.Lu,1);
% MFAC.Ly
% for i = 1 : (MFAC.Ly + MFAC.Lu)
%     rho(i) = 0.5;
% end
% rho = 0.5*ones(MFAC.Ly + MFAC.Lu,1);
rho = 0.5*ones(MFAC.Ly + MFAC.Lu,1);
eta = 0.5;
mu = 1;
% b1 = 1;
% b2 = 11;
% alpha = 2;
% b1 = 1;
% b2 = 8;
% alpha = 1.5;

b1 = 0.2;
b2 = 0.5;
% b1 = b1*600;
% b2 = b2*600;
alpha = 10;%15;%10;%15;%10;

Rav=[cos(q(3)), -sin(q(3)), 0;
    sin(q(3)), cos(q(3)), 0;
    0, 0, 1];
Ravd=[cos(qd(3)), -sin(qd(3)), 0;
    sin(qd(3)), cos(qd(3)), 0;
    0, 0, 1];

% beta = 1;%0.5;%1.5;%2;%1;
% alpha = 10;%12;%10;%8;
% kp1=1;%6;;%3;%4;%5;
% 
% edq=dq-dqd;
% eq=q-qd;
% 
% k(1) = 0 + kp1/(1 + beta * exp(alpha * (-edq(1)) * eq(1)));
% k(2) = 0 + kp1/(1 + beta * exp(alpha * (-edq(2)) * eq(2)));
% k(3) = 0 + kp1/(1 + beta * exp(alpha * (-edq(3)) * eq(3)));
% 
% kd(1) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(1)) * eq(1)));
% kd(2) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(2)) * eq(2)));
% kd(3) = 0 + 0.01/(1 + beta * exp(alpha * (-edq(3)) * eq(3)));
% 
% w0 = 1;%5;%4;%3;%1;%2;%1%2%4;
% wc = 2;%4;
% 
% MFAC.Kp = [wc*wc+k(1)*wc*wc 0 0;0 wc*wc+k(2)*wc*wc 0;0 0 wc*wc+k(3)*wc*wc];
% MFAC.Kd = [(1+kd(1))*2*w0*wc 0 0;0 (1+kd(2))*2*w0*wc 0;0 0 (1+kd(3))*2*w0*wc];

MFAC.wheel_theta(1) = mod(q(3) + pi/6,2*pi);
MFAC.wheel_theta(2) = mod(q(3) + pi*5/6,2*pi);
MFAC.wheel_theta(3) = mod(q(3) + pi*3/2,2*pi);
% for i = 1 : 3
%     if((0<=MFAC.wheel_theta(i)) && (MFAC.wheel_theta(i)<pi/2))
%         MFAC.Phy_pL_const(1,i) = -1;
%         MFAC.Phy_pL_const(2,i) = 1;
%     elseif((pi/2<=MFAC.wheel_theta(i)) && (MFAC.wheel_theta(i)<pi))
%         MFAC.Phy_pL_const(1,i) = -1;
%         MFAC.Phy_pL_const(2,i) = -1;
%     elseif((pi<=MFAC.wheel_theta(i)) && (MFAC.wheel_theta(i)<pi*3/2))
%         MFAC.Phy_pL_const(1,i) = 1;
%         MFAC.Phy_pL_const(2,i) = -1;
%     elseif((pi*3/2<=MFAC.wheel_theta(i)) && (MFAC.wheel_theta(i)<pi*2))
%         MFAC.Phy_pL_const(1,i) = 1;
%         MFAC.Phy_pL_const(2,i) = 1;
%     else
%     end
% end
% MFAC.Phy_pL_init = [0.5*MFAC.Phy_pL_const(1,1) 0.2*MFAC.Phy_pL_const(1,2) 0.2*MFAC.Phy_pL_const(1,3);
%                     0.2*MFAC.Phy_pL_const(2,1) 0.5*MFAC.Phy_pL_const(2,2) 0.2*MFAC.Phy_pL_const(2,3);
%                     0.2*MFAC.Phy_pL_const(3,1) 0.2*MFAC.Phy_pL_const(3,2) 0.5*MFAC.Phy_pL_const(3,3)];
for i = 1 : 3
    MFAC.Phy_pL_const(1,i) = -sin(MFAC.wheel_theta(i));
    MFAC.Phy_pL_const(2,i) = cos(MFAC.wheel_theta(i));
    MFAC.Phy_pL_const(3,i) = 1;
end
MFAC.Phy_pL_init = [0.5*MFAC.Phy_pL_const(1,1) 0.2*MFAC.Phy_pL_const(1,2) 0.2*MFAC.Phy_pL_const(1,3);
                    0.2*MFAC.Phy_pL_const(2,1) 0.5*MFAC.Phy_pL_const(2,2) 0.2*MFAC.Phy_pL_const(2,3);
                    0.2*MFAC.Phy_pL_const(3,1) 0.2*MFAC.Phy_pL_const(3,2) 0.5*MFAC.Phy_pL_const(3,3)];
%% controller
% delta_input = [MFAC.U(:,MFAC.iterative_count-1);MFAC.U(:,MFAC.iterative_count-2);MFAC.U(:,MFAC.iterative_count-3)] - [MFAC.U(:,MFAC.iterative_count-2);MFAC.U(:,MFAC.iterative_count-3);MFAC.U(:,MFAC.iterative_count-4)];
if(MFAC.Ly == 0)
    delta_input = MFAC.U(:,MFAC.iterative_count-1) - MFAC.U(:,MFAC.iterative_count-2);
    for i = 2 : MFAC.Lu
        delta_input = [delta_input;MFAC.U(:,MFAC.iterative_count-i) - MFAC.U(:,MFAC.iterative_count-i-1)];
    end
else
    delta_input = MFAC.Q(:,MFAC.iterative_count-1) - MFAC.Q(:,MFAC.iterative_count-2);
    for i = 2 : MFAC.Ly
        delta_input = [delta_input;MFAC.Q(:,MFAC.iterative_count-i) - MFAC.Q(:,MFAC.iterative_count-i-1)];
    end
    for i = 1 : MFAC.Lu
        delta_input = [delta_input;MFAC.U(:,MFAC.iterative_count-i) - MFAC.U(:,MFAC.iterative_count-i-1)];
    end
end

% % q = Rav\q;
% % qd = Ravd\qd;
% MFAC.Q = [MFAC.Q q];
% delta_output = qd - q;

% % dq = MFAC.J\Rav\dq;
% % dqd = MFAC.J\Ravd\dqd;
% dq = Rav\dq;
% dqd = Ravd\dqd;
% MFAC.Q = [MFAC.Q dq];
% delta_output = dqd - dq;

% dq = Rav\dq;
% dqd = Ravd\dqd;
MFAC.Q = [MFAC.Q (MFAC.Kd*dq + MFAC.Kp*q)];
delta_output = MFAC.Kd*(dqd - dq) + MFAC.Kp*(qd - q);

MFAC.Phy_pL = MFAC.Phy_pL_Pre + eta * (MFAC.Q(:,MFAC.iterative_count) - MFAC.Q(:,MFAC.iterative_count - 1) - MFAC.Phy_pL_Pre * delta_input) * delta_input' / (mu + delta_input' * delta_input);
MFAC.Phy_pL_Pre = MFAC.Phy_pL;
% for i = 1 : (MFAC.Ly + MFAC.Lu)
%     eval(['MFAC.Phy_pL',num2str(i),' = MFAC.Phy_pL(1:3,3*',num2str(i-1),'+1:3*(',num2str(i-1),'+1));']);
% end

if 1
    for i = 1 : 3
        for j = 1 : 3
            if(i == j)
                if((abs(MFAC.Phy_pL(i,3*MFAC.Ly+j))<b2) || (abs(MFAC.Phy_pL(i,3*MFAC.Ly+j))>(alpha*b2)) || (sign(MFAC.Phy_pL(i,3*MFAC.Ly+j)) ~= MFAC.Phy_pL_init(i,j)))
                    MFAC.Phy_pL(i,3*MFAC.Ly+j) = MFAC.Phy_pL_init(i,j);
                end
%                 if((abs(MFAC.Phy_pL(i,j))<b2) || (abs(MFAC.Phy_pL(i,j))>(alpha*b2)) || (sign(MFAC.Phy_pL(i,j)) ~= MFAC.Phy_pL_init(i,j)))
%                     MFAC.Phy_pL(i,j) = MFAC.Phy_pL_init(i,j);
%                 end
            else
                if((abs(MFAC.Phy_pL(i,3*MFAC.Ly+j))>b1) || (sign(MFAC.Phy_pL(i,3*MFAC.Ly+j)) ~= MFAC.Phy_pL_init(i,j)))
                    MFAC.Phy_pL(i,3*MFAC.Ly+j) = MFAC.Phy_pL_init(i,j);
                end
%                 if((abs(MFAC.Phy_pL(i,j))>b1) || (sign(MFAC.Phy_pL(i,j)) ~= MFAC.Phy_pL_init(i,j)))
%                     MFAC.Phy_pL(i,j) = MFAC.Phy_pL_init(i,j);
%                 end
            end
        end
    end
end

%% 采用F范数计算矩阵范数
% MFAC.control_input = MFAC.U(:,MFAC.iterative_count - 1) + MFAC.Phy_pL1' * (rho1 * (delta_output) - rho2 * MFAC.Phy_pL2 * (MFAC.U(:,MFAC.iterative_count-1) - MFAC.U(:,MFAC.iterative_count-2)) - rho3 * MFAC.Phy_pL3 * (MFAC.U(:,MFAC.iterative_count-2) - MFAC.U(:,MFAC.iterative_count-3))) / (MFAC.lambda + norm(MFAC.Phy_pL1,'fro')^2);
%% 采用2范数计算矩阵范数
% MFAC.control_input = MFAC.U(:,MFAC.iterative_count - 1) + MFAC.Phy_pL1' * (rho1 * (delta_output) - rho2 * MFAC.Phy_pL2 * (MFAC.U(:,MFAC.iterative_count-1) - MFAC.U(:,MFAC.iterative_count-2)) - rho3 * MFAC.Phy_pL3 * (MFAC.U(:,MFAC.iterative_count-2) - MFAC.U(:,MFAC.iterative_count-3))) / (MFAC.lambda + norm(MFAC.Phy_pL1,2)^2);
%% 实验表明，矩阵范数，采用2范数，效果优于采用F范数
Block_sum = 0.0;
for i = 1 : MFAC.Ly
    Block_sum = Block_sum + rho(i) * MFAC.Phy_pL(1:3,3*i-2:3*i) * (MFAC.Q(:,MFAC.iterative_count-i+1) - MFAC.Q(:,MFAC.iterative_count-i));
end
for i = (MFAC.Ly + 2) : (MFAC.Lu + MFAC.Ly)
    Block_sum = Block_sum + rho(i) * MFAC.Phy_pL(1:3,3*i-2:3*i) * (MFAC.U(:,MFAC.iterative_count-i+MFAC.Ly+1) - MFAC.U(:,MFAC.iterative_count-i+MFAC.Ly));
end
MFAC.control_input = MFAC.U(:,MFAC.iterative_count - 1) + MFAC.Phy_pL(1:3,3*MFAC.Ly+1:3*MFAC.Ly+3)' * (rho(MFAC.Ly + 1) * (delta_output) - Block_sum) / (MFAC.lambda + norm(MFAC.Phy_pL(1:3,3*MFAC.Ly+1:3*MFAC.Ly+3),2)^2);

MFAC.PHY_PL = [MFAC.PHY_PL;MFAC.Phy_pL];
MFAC.U = [MFAC.U MFAC.control_input];
MFAC.iterative_count = MFAC.iterative_count + 1;
MFAC.PHY_FL = [MFAC.PHY_FL;[MFAC.Phy_pL(1,:) MFAC.Phy_pL(2,:) MFAC.Phy_pL(3,:)]];

% a=q
% b=MFAC.Phy_pL
% c=MFAC.control_input
%% amplitude limiting
if 0
   if MFAC.control_input(1) > 24
      MFAC.control_input(1) = 24;
   elseif MFAC.control_input(1) < -24
          MFAC.control_input(1) = -24;
   end

   if MFAC.control_input(2) > 24
      MFAC.control_input(2) = 24;
   elseif MFAC.control_input(2) < -24
          MFAC.control_input(2) = -24;
   end

   if MFAC.control_input(3) > 24
      MFAC.control_input(3) = 24;
   elseif MFAC.control_input(3) < -24
          MFAC.control_input(3) = -24;
   end
end
P.muavc = MFAC.control_input;
control_effect = P.muavc;
t4=clock;
T.mfacTime=etime(t4,t3);
P.mfacTime=toc;
end
