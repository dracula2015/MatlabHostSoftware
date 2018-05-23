% function simMainFunction(source,eventdata)
%% ===== Initial parameters
global T stopFlag startFlag P MFAC;
stopFlag = false;
style={'k-','b--','g-.','r:','m:'};
method={'Ref','PD','NPD','MFAC'};
Parameters;
% P.Trajectory = 0;%%0 circle; 1 rectangle; 2 lemniscate
MFAC.lambdan=[0.01,0.1,1,5,10,15];
MFAC.lambda = 0.01;

MFAC.Kp = 15;
MFAC.Kd = 6;

MFAC.Ly = 0;
MFAC.Lu = 1;
MFAC.U = zeros(3,(MFAC.Ly + MFAC.Lu) + 1);
MFAC.Q = zeros(3,(MFAC.Ly + MFAC.Lu) + 1);
MFAC.iterative_count = (MFAC.Ly + MFAC.Lu) + 2;%% 5
% MFAC.Phy_pL_init = [-0.5 -0.2 0.2;
%                      0.2 -0.5 0.2;
%                      0.2 0.2 0.5];
% MFAC.Phy_pL_init = [0.5 0.2 -0.2;
%                     -0.2 0.5 -0.2;
%                      0.2 0.2 0.5];
MFAC.Phy_pL_const = [1  1 -1;
                    -1  1 -1;
                     1  1  1];
MFAC.Phy_pL_init = [0.5*MFAC.Phy_pL_const(1,1) 0.2*MFAC.Phy_pL_const(1,2) 0.2*MFAC.Phy_pL_const(1,3);
    0.2*MFAC.Phy_pL_const(2,1) 0.5*MFAC.Phy_pL_const(2,2) 0.2*MFAC.Phy_pL_const(2,3);
    0.2*MFAC.Phy_pL_const(3,1) 0.2*MFAC.Phy_pL_const(3,2) 0.5*MFAC.Phy_pL_const(3,3)];
eval(['MFAC.Phy_pL',num2str(MFAC.Ly+1),'_init = MFAC.Phy_pL_init;']);
MFAC.Phy_fLy_init = [-0.5 -0.2 0.2;
    0.2 -0.5 0.2;
    0.2 0.2 0.5];

if MFAC.Ly == 0
    MFAC.Phy_pL = MFAC.Phy_pL1_init;
else
    MFAC.Phy_pL = zeros(3);
end
for i = 1 : (MFAC.Ly + MFAC.Lu) - 1
    if(i == MFAC.Ly)
        eval(['MFAC.Phy_pL = [MFAC.Phy_pL MFAC.Phy_pL',num2str(MFAC.Ly+1),'_init];']);
    else
        MFAC.Phy_pL = [MFAC.Phy_pL zeros(3)];
    end
end
MFAC.Phy_pL_Pre = MFAC.Phy_pL;

for i = 1 : (MFAC.Ly + MFAC.Lu)
    eval(['MFAC.Phy_pL',num2str(i),' = MFAC.Phy_pL(1:3,3*',num2str(i-1),'+1:3*(',num2str(i-1),'+1))']);
end

MFAC.PHY_PL = MFAC.Phy_pL;
for i = 1 : (MFAC.Ly + MFAC.Lu)
    MFAC.PHY_PL = [MFAC.PHY_PL;MFAC.Phy_pL];
end

MFAC.PHY_FL = zeros((MFAC.Ly + MFAC.Lu) + 1,3*3*(MFAC.Ly + MFAC.Lu));

MFAC.control_input = [0;0;0];

% MFAC.Q = [0,0,0;0,0,0;0,0,0;0,0,0;]';
% MFAC.U = [0,0,0;0,0,0;0,0,0;0,0,0;]';
% MFAC.U = [1,1,1;1,1,1;1,1,1;1,1,1;]';
% MFAC.Phy_pL = [MFAC.Phy_pL1_init zeros(3) zeros(3)];
% MFAC.Phy_pL_Pre = [MFAC.Phy_pL1_init zeros(3) zeros(3)];
% MFAC.PHY_PL = [MFAC.Phy_pL1_init zeros(3) zeros(3);
%                MFAC.Phy_pL1_init zeros(3) zeros(3);
%                MFAC.Phy_pL1_init zeros(3) zeros(3);
%                MFAC.Phy_pL1_init zeros(3) zeros(3);];
% MFAC.Phy_pL1 = zeros(3);
% MFAC.Phy_pL2 = zeros(3);
% MFAC.Phy_pL3 = zeros(3);
% MFAC.extract_coefficient1 = [eye(3);zeros(3);zeros(3)];
% MFAC.extract_coefficient2 = [zeros(3);eye(3);zeros(3)];
% MFAC.extract_coefficient3 = [zeros(3);zeros(3);eye(3)];

style={'k-','b--','g-.','r:','m:'};
P.gp=10;
% P.gp=5;
% P.lambdan=[5,10,100];
P.lambda=15;
P.iaeExp=[];
P.iaeSim=[];

% tuning_parameter;
P.QD=[0;0;0];
P.DQD=[0;0;0];
P.DDQD=[0;0;0];

P.Q=[0;0;0];
P.QN=[0;0;0];
P.QM=[0;0;0];
P.DQ=[0;0;0];
P.DQN=[0;0;0];
P.DQM=[0;0;0];
P.U=[0;0;0];
P.UN=[0;0;0];
P.UM=[0;0;0];

P.T=(0);
P.dt=0.01;
% P.dt=0.001;

% P.stime=40;

P.Z1=[0;0;0];
P.Z2=[0;0;0];
P.Z3=[0;0;0];
P.NZ1=[0;0;0];
P.NZ2=[0;0;0];
P.NZ3=[0;0;0];
P.K=[0;0;0];

P.F=[0;0;0];
P.NF=[0;0;0];
P.NPIDKP=[0;0;0];
P.BASCIKP=[0;0;0];
P.omega=[0;0;0];
P.nomega=[0;0;0];
P.phy=[0;0;0];
P.nphy=[0;0;0];
P.mphy=[0;0;0];
P.phy_pre=[0;0;0];
P.nphy_pre=[0;0;0];
P.mphy_pre=[0;0;0];
P.L=[P.Dout;P.Dout;P.Dout];
P.NL=[P.Dout;P.Dout;P.Dout];

P.time=[];
T.time=[];
% P.mainLoopTime=0;
% P.npidTime=0;
% P.racTime=0;
% P.modelTime=0;

qd_pre=[0;0;0];
dqd_pre=[0;0;0];
%% Initial state for OMRS_PD_controller
dq_pre=[0;0;0];
dq=dq_pre;
q_pre=[0;0;0];          %[0;0;0];->[0.6;0;0];
q=q_pre;
%% Initial state for OMRS_NPID_controller
dqN_pre=[0;0;0];
dqN=dqN_pre;
qN_pre=[0;0;0];
qN=qN_pre;
%% Initial state for OMRS_NPID_controller
dqM_pre=[0;0;0];
dqM=dqM_pre;
qM_pre=[0;0;0];
qM=qM_pre;
if P.Trajectory == 0
    qd_pre=[0.8;0;0];
    q_pre=[0.8;0;0];          %[0;0;0];->[0.6;0;0];
    q=q_pre;
    qN_pre=[0.8;0;0];
    qN=qN_pre;
    qM_pre=[0.8;0;0];
    qM=qM_pre;
    P.QD=[0.8;0;0];
    P.Q=[0.8;0;0];
    P.QN=[0.8;0;0];
    P.QM=[0.8;0;0];
    P.stime=30;
end
%%
set(0, 'defaultfigurecolor', 'w')
% F1=figure('Position',[40 60 1000 900],'name',['MFAC.lambda = ',num2str(MFAC.lambda)]);
% F1=figure('Position',[40 60 1000 900],'name',['NPD.lambda = ',num2str(P.lambda)]);
% F10=figure('Position',[50 70 1000 900],'name',['lambda = ',num2str(P.lambda)]);
% F17=figure('Position',[60 80 1000 900],'name',['MFAC.lambda = ',num2str(MFAC.lambda),'_NPD.lambda = ',num2str(P.lambda)]);
% st=P.stime/4;
st=1.0;
speed=0.1;%0.3;%0.5;%1;%0.1;
netClient = tcpip('192.168.1.100',8899,'NetworkRole','client');
% netServer = tcpip('192.168.1.100',8888,'NetworkRole','server');
fopen(netClient);
%% Main loop
for t=0:P.dt:P.stime
    if stopFlag
        break;
    end
    tic
    t1=clock;
    %% theta
    if (10<t && t<=20)
        theta=0.35*(t-10);
        thetad=0.35;
    else if(20<=t && t<30)
            theta=3.5;
            thetad=0;
            thetadd=0;
        else if(30<=t && t<=40)
                theta=3.5+0.5*sin(pi/5*t);
                thetad=0.1*pi*cos(pi/5*t);
                thetadd=-0.02*pi*sin(pi/5*t);
            else
                theta=0;
                thetad=0;
                thetadd=0;
            end
        end;
    end
    %% rectangle
    if(P.Trajectory == 1)
        if(0<=mod(t*speed,4*st) && mod(t*speed,4*st)<st)
            x=mod(t*speed,4*st);
            y=0;
            xd=speed;
            yd=0;
        elseif(st<=mod(t*speed,4*st) && mod(t*speed,4*st)<2*st)
            x=st;
            y=mod(t*speed,4*st)-st;
            xd=0;
            yd=speed;
        elseif(2*st<=mod(t*speed,4*st) && mod(t*speed,4*st)<3*st)
            x=3*st-mod(t*speed,4*st);
            y=st;
            xd=-speed;
            yd=0;
        elseif(3*st<=mod(t*speed,4*st) && mod(t*speed,4*st)<4*st)
            x=0;
            y=4*st-mod(t*speed,4*st);
            xd=0;
            yd=-speed;
        end;
        xdd=0;
        ydd=0;
        
        qd=[x;y;theta];
        dqd=[xd;yd;thetad];
        ddqd=[xdd;ydd;thetadd];
    end
    %% circle
    if(P.Trajectory == 0)
        x=0.8*cos(pi/15*t);
        y=0.8*sin(pi/15*t);
        %         x=0.8*cos(pi/30*t);
        %         y=0.8*sin(pi/30*t);
        qd=[x;y;theta];
        dqd=(qd-qd_pre)/P.dt;
        qd_pre=qd;
        ddqd=(dqd-dqd_pre)/P.dt;
        dqd_pre=dqd;
    end
    %% lemniscate
    if(P.Trajectory == 2)
        %         x=2*sin(0.05*t*pi);
        %         y=sin(0.1*t*pi);
        x=0.5*sin(0.05*t*pi);
        y=0.5*sin(0.1*t*pi);
        qd=[x;y;theta];
        dqd=(qd-qd_pre)/P.dt;
        qd_pre=qd;
        ddqd=(dqd-dqd_pre)/P.dt;
        dqd_pre=dqd;
    end
    %     theta=0;
    %     thetad=0;
    %     thetadd=0;
    
    if t>20
        P.b0=12.0*10^(-5);
    end
    %%
    %     Rav=[cos(q(3)), -sin(q(3)), 0;
    %         sin(q(3)), cos(q(3)), 0;
    %         0, 0, 1];
    %     NRav=[cos(qN(3)), -sin(qN(3)), 0;
    %         sin(qN(3)), cos(qN(3)), 0;
    %         0, 0, 1];
    %     MRav=[cos(qM(3)), -sin(qM(3)), 0;
    %         sin(qM(3)), cos(qM(3)), 0;
    %         0, 0, 1];
    
    MFAC.J=[-1/2, sqrt(3)/2, P.La;
        -1/2, -sqrt(3)/2, P.La;
        1, 0, P.La];
    a=toc;
    %% OMRS_controller
    %     ddq=OMRS_model(OMRS_FFDL_MFAC_controller(qd,dqd,ddqd,q,dq),q,dq,P.beta0,P.beta1,P.beta2,P.m,P.La,P.Iv);
    ddq=OMRS_model(OMRS_controller(qd,dqd,ddqd,q,dq),q,dq,P.beta0,P.beta1,P.beta2,P.m,P.La,P.Iv);
    tic
    q=q_pre+dq*P.dt;
    dq=dq_pre+ddq*P.dt;
    %     P.phy=P.phy+P.dt/P.r*(P.J\Rav\dq);
    b=toc;
    %% OMRS_NPID_controller
    ddqN=OMRS_model_NPD(OMRS_NPD_controller_wcica(qd,dqd,ddqd,qN,dqN),qN,dqN,P.beta0,P.beta1,P.beta2,P.m,P.La,P.Iv);
    tic
    qN=qN_pre+dqN*P.dt;
    dqN=dqN_pre+ddqN*P.dt;
    %     P.nphy=P.nphy+P.dt/P.r*(P.NJ\NRav\dqN);
    c=toc;
    %% OMRS_MFAC_controller
    ddqM=OMRS_model_MFAC(OMRS_FFDL_MFAC_controller(qd,dqd,ddqd,qM,dqM),qM,dqM,P.beta0,P.beta1,P.beta2,P.m,P.La,P.Iv);
    tic
    qM=qM_pre+dqM*P.dt;
    dqM=dqM_pre+ddqM*P.dt;
    %     P.mphy=P.mphy+P.dt/P.r*(P.J\MRav\dqM);
    %% disturbance
    if(t==25)
        q(2)=q(2)+0.05;
        qN(2)=qN(2)+0.05;
        qM(2)=qM(2)+0.05;
    end;
    if(t==35)
        q(1)=q(1)+0.05;
        qN(1)=qN(1)+0.05;
        qM(1)=qM(1)+0.05;
    end;
    dq_pre=dq;
    q_pre=q;
    dqN_pre=dqN;
    qN_pre=qN;
    dqM_pre=dqM;
    qM_pre=qM;
    %% record data
    P.QD=[P.QD qd];
    P.Q=[P.Q q];
    P.QN=[P.QN qN];
    P.QM=[P.QM qM];
    P.U=[P.U P.uavc];
    P.UN=[P.UN P.nuavc];
    P.UM=[P.UM P.muavc];
    P.T=[P.T t];
    P.Z1=[P.Z1 P.z1];
    P.Z2=[P.Z2 P.z2];
    P.Z3=[P.Z3 P.z3];
    P.NZ1=[P.NZ1 P.nz1];
    P.NZ2=[P.NZ2 P.nz2];
    P.NZ3=[P.NZ3 P.nz3];
    P.K=[P.K P.k];
    P.DDQD=[P.DDQD ddqd];
    P.DQD=[P.DQD dqd];
    P.DQ=[P.DQ dq];
    P.DQN=[P.DQN dqN];
    P.DQM=[P.DQM dqM];
    P.F=[P.F P.f];
    P.NF=[P.NF P.nf];
    d=toc;
    t2=clock;
    T.mainLoopTime=etime(t2,t1);
    P.mainLoopTime=a+b+c+d;
    if isempty(P.time)
        P.time=[P.mainLoopTime;P.racTime;P.npdTime;P.mfacTime;P.modelTime;P.npdModelTime;P.mfacModelTime];
    else
        P.time=[P.time [P.mainLoopTime;P.racTime;P.npdTime;P.mfacTime;P.modelTime;P.npdModelTime;P.mfacModelTime]];
    end
    if isempty(T.time)
        T.time=[T.mainLoopTime;T.racTime;T.npdTime;T.mfacTime;T.modelTime;T.npdModelTime;T.mfacModelTime];
    else
        T.time=[T.time [T.mainLoopTime;T.racTime;T.npdTime;T.mfacTime;T.modelTime;T.npdModelTime;T.mfacModelTime]];
    end
    %     if isempty(P.time)
    %         P.time=[P.mainLoopTime;P.npdTime;P.racTime;];
    %     else
    %         P.time=[P.time [P.mainLoopTime;P.npdTime;P.racTime]];
    %     end
    %     if isempty(T.time)
    %         T.time=[T.mainLoopTime;T.npdTime;T.racTime];
    %     else
    %         T.time=[T.time [T.mainLoopTime;T.npdTime;T.racTime]];
    %     end
    drawnow
    fwrite(netClient,typecast(single(ddq),'uint8'),'uint8')
end
%% Display
if 0
    %% X-Y plane
    figure(F1);
    subplot(221);
    plot(P.QD(1,:),P.QD(2,:),'b.-',P.Q(1,:),P.Q(2,:),'g.-.',P.QN(1,:),P.QN(2,:),'r.--')
    if(P.Trajectory == 0)
        axis([-1 1 -1 1])
    elseif(P.Trajectory == 1)
        axis([-0.1 1.1 -0.1 1.1])
    elseif(P.Trajectory == 2)
        axis([-0.6 0.6 -0.6 0.6])
    end
    xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
    L1=legend('Reference','Response(PD)','Response(NPD)');
    set(L1,'Location','SouthEast','FontSize',10)
    hold on
    %% theta plane
    subplot(222);
    plot(P.T,P.QD(3,:),'b.-',P.T,P.Q(3,:),'g.-.',P.T,P.QN(3,:),'r.--');
    axis([0 P.stime -1 6])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
    L2=legend('Reference','Response(PD)','Response(NPD)');
    set(L2,'Location','SouthEast','FontSize',10)
    hold on
    
    %% X error
    subplot(627);
    plot(P.T,P.Q(1,:)-P.QD(1,:),'g.-.',P.T,P.QN(1,:)-P.QD(1,:),'r.--');
    axis([0 P.stime -0.1 0.1])
    ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
    hold on
    %% Y error
    subplot(6,2,9)
    plot(P.T,P.Q(2,:)-P.QD(2,:),'g.-.',P.T,P.QN(2,:)-P.QD(2,:),'r.--');
    axis([0 P.stime -0.1 0.1])
    ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
    L3=legend('PD','NPD');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% theta error
    subplot(6,2,11);
    plot(P.T,P.Q(3,:)-P.QD(3,:),'g.-.',P.T,P.QN(3,:)-P.QD(3,:),'r.--');
    axis([0 P.stime -0.15 0.15])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15')
    ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
    hold on
    %% u1 output
    subplot(628);
    plot(P.T,P.U(1,:),'g.-.',P.T,P.UN(1,:),'r.--');
    axis([0 P.stime -20 20])
    ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
    hold on
    %% u2 output
    subplot(6,2,10)
    plot(P.T,P.U(2,:),'g.-.',P.T,P.UN(2,:),'r.--');
    axis([0 P.stime -20 20])
    ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
    L4=legend('PD','NPD');
    set(L4,'Location','NorthWest','FontSize',10)
    hold on
    %% u3 output
    subplot(6,2,12);
    plot(P.T,P.U(3,:),'g.-.',P.T,P.UN(3,:),'r.--')
    axis([0 P.stime -20 20])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
    hold on
end

%% Observer
if 0
    figure(F10);
    %% PD X channel estimated perturbation
    subplot(6,2,1);
    plot(P.T,P.F(1,:),'g.-.',P.T,P.Z3(1,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% PD Y channel estimated perturbation
    subplot(6,2,3)
    plot(P.T,P.F(2,:),'g.-.',P.T,P.Z3(2,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% PD theta channel estimated perturbation
    subplot(6,2,5);
    plot(P.T,P.F(3,:),'g.-.',P.T,P.Z3(3,:),'r.--');
    axis([0 P.stime -50 50])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% PD X channel estimated speed
    subplot(6,2,2);
    plot(P.T,P.Z2(1,:),'g.-.',P.T,P.DQ(1,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% PD Y channel estimated speed
    subplot(6,2,4)
    plot(P.T,P.Z2(2,:),'g.-.',P.T,P.DQ(2,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% PD theta channel estimated speed
    subplot(6,2,6);
    plot(P.T,P.Z2(3,:),'g.-.',P.T,P.DQ(3,:),'r.--');
    axis([0 P.stime -1.5 2.0])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    
    %% NPD X channel estimated perturbation
    subplot(6,2,7);
    plot(P.T,P.NF(1,:),'g.-.',P.T,P.NZ3(1,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% NPD Y channel estimated perturbation
    subplot(6,2,9)
    plot(P.T,P.NF(2,:),'g.-.',P.T,P.NZ3(2,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% NPD theta channel estimated perturbation
    subplot(6,2,11);
    plot(P.T,P.NF(3,:),'g.-.',P.T,P.NZ3(3,:),'r.--');
    axis([0 P.stime -50 50])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% NPD X channel estimated speed
    subplot(6,2,8);
    plot(P.T,P.NZ2(1,:),'g.-.',P.T,P.DQN(1,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% NPD Y channel estimated speed
    subplot(6,2,10)
    plot(P.T,P.NZ2(2,:),'g.-.',P.T,P.DQN(2,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% NPD theta channel estimated speed
    subplot(6,2,12);
    plot(P.T,P.NZ2(3,:),'g.-.',P.T,P.DQN(3,:),'r.--');
    axis([0 P.stime -1.5 2.0])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
end

%% paper graphics
if 0
    %% x-y plane
    F2=figure('name','x-y plane','position',[50 70 570 450]);
    plot(P.QD(1,:),P.QD(2,:),'b.-',P.Q(1,:),P.Q(2,:),'g.-.',P.QN(1,:),P.QN(2,:),'r.--')
    if(P.Trajectory == 0)
        axis([-1 1 -1 1])
    elseif(P.Trajectory == 1)
        axis([-0.1 1.1 -0.1 1.1])
    elseif(P.Trajectory == 2)
        axis([-0.6 0.6 -0.6 0.6])
    end
    xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
    L1=legend('Reference','Response(PD)','Response(NPD)');
    set(L1,'Location','northeast','FontSize',10)
    hold on
    
    %% theta plane
    F3=figure('name','\theta plane','position',[60 80 570 450]);
    plot(P.T,P.QD(3,:),'b.-',P.T,P.Q(3,:),'g.-.',P.T,P.QN(3,:),'r.--');
    axis([0 P.stime -1 6])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
    L2=legend('Reference','Response(PD)','Response(NPD)');
    set(L2,'Location','SouthEast','FontSize',10)
    hold on
    
    %% error
    F4=figure('name','error','position',[70 90 570 450]);
    % X error
    subplot(311);
    plot(P.T,P.Q(1,:)-P.QD(1,:),'g.-.',P.T,P.QN(1,:)-P.QD(1,:),'r.--');
    axis([0 P.stime -0.1 0.1])
    ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
    hold on
    % Y error
    subplot(312)
    plot(P.T,P.Q(2,:)-P.QD(2,:),'g.-.',P.T,P.QN(2,:)-P.QD(2,:),'r.--');
    axis([0 P.stime -0.1 0.1])
    ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
    L3=legend('PD','NPD');
    set(L3,'Location','NorthWest','FontSize',10)
    hold on
    % theta error
    subplot(313);
    plot(P.T,P.Q(3,:)-P.QD(3,:),'g.-.',P.T,P.QN(3,:)-P.QD(3,:),'r.--');
    axis([0 P.stime -0.15 0.15])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
    hold on
    
    %% output
    F5=figure('name','output','position',[80 100 570 450]);
    % u1 output
    subplot(311);
    plot(P.T,P.U(1,:),'g.-.',P.T,P.UN(1,:),'r.--');
    axis([0 P.stime -20 20])
    ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
    hold on
    % u2 output
    subplot(312)
    plot(P.T,P.U(2,:),'g.-.',P.T,P.UN(2,:),'r.--');
    axis([0 P.stime -20 20])
    ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
    L4=legend('PD','NPD');
    set(L4,'Location','NorthWest','FontSize',10)
    hold on
    % u3 output
    subplot(313);
    plot(P.T,P.U(3,:),'g.-.',P.T,P.UN(3,:),'r.--')
    axis([0 P.stime -20 20])
    %xlabel('t(s)','fontname','times new roman','fontweight','bold')
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
    hold on
    
    %% Real system perturbation and its corresponding estimation
    F11=figure('name','real perturbation and its estimation','position',[90 110 570 450]);
    %% PD X channel estimated perturbation
    subplot(3,1,1);
    plot(P.T,P.F(1,:),'g.-.',P.T,P.Z3(1,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% PD Y channel estimated perturbation
    subplot(3,1,2)
    plot(P.T,P.F(2,:),'g.-.',P.T,P.Z3(2,:),'r.--');
    axis([0 P.stime -10 10])
    ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% PD theta channel estimated perturbation
    subplot(3,1,3);
    plot(P.T,P.F(3,:),'g.-.',P.T,P.Z3(3,:),'r.--');
    axis([0 P.stime -50 50])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    
    %% Real robot speed and its corresponding estimation
    F12=figure('name','real speed and its estimation','position',[100 120 570 450]);
    %% PD X channel estimated speed
    subplot(3,1,1);
    plot(P.T,P.Z2(1,:),'g.-.',P.T,P.DQ(1,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
    %% PD Y channel estimated speed
    subplot(3,1,2)
    plot(P.T,P.Z2(2,:),'g.-.',P.T,P.DQ(2,:),'r.--');
    axis([0 P.stime -0.5 0.5])
    ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
    L3=legend('Real','Estimated');
    set(L3,'Location','NorthWest','FontSize',10);
    hold on
    %% PD theta channel estimated speed
    subplot(3,1,3);
    plot(P.T,P.Z2(3,:),'g.-.',P.T,P.DQ(3,:),'r.--');
    axis([0 P.stime -1.5 2.0])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
    hold on
end

currentDir=pwd;
filePath=fullfile(currentDir,'SimExpImages');
%% Traditional Format Conversion
if 0
    xy_frame=getframe(F2);
    xy_image=frame2im(xy_frame);
    if strcmp('win64',computer('arch'))
        imwrite(xy_image,[filePath,'\xy_plane_single.bmp'],'bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(xy_image,[filePath,'/xy_plane_single.bmp'],'bmp')
    end
    theta_frame=getframe(F3);
    theta_image=frame2im(theta_frame);
    if strcmp('win64',computer('arch'))
        imwrite(theta_image,[filePath,'\theta_plane_single.bmp'],'bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(theta_image,[filePath,'/theta_plane_single.bmp'],'bmp')
    end
    error_frame=getframe(F4);
    error_image=frame2im(error_frame);
    if strcmp('win64',computer('arch'))
        imwrite(error_image,[filePath,'\error_single.bmp'],'bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(error_image,[filePath,'/error_single.bmp'],'bmp')
    end
    output_frame=getframe(F5);
    output_image=frame2im(output_frame);
    if strcmp('win64',computer('arch'))
        imwrite(output_image,[filePath,'\output_single.bmp'],'bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(output_image,[filePath,'/output_single.bmp'],'bmp')
    end
    if strcmp('glnxa64',computer('arch'))
        unix('cd SimExpImages;convert xy_plane_single.bmp xy_plane_single.eps; convert theta_plane_single.bmp theta_plane_single.eps; convert error_single.bmp error_single.eps; convert output_single.bmp output_single.eps')
    elseif strcmp('win64',computer('arch'))
        cd SimExpImages
        system('bitmap2eps xy_plane_single.bmp xy_plane_single.eps')
        system('bitmap2eps theta_plane_single.bmp theta_plane_single.eps')
        system('bitmap2eps error_single.bmp error_single.eps')
        system('bitmap2eps output_single.bmp output_single.eps')
        cd ..
    end
end

%% New Format Conversion
if 0
    if strcmp('win64',computer('arch'))
        figure(F2)
        saveas(gcf,[filePath,'\xy_plane_single.eps'],'epsc')
        figure(F3)
        saveas(gcf,[filePath,'\theta_plane_single.eps'],'epsc')
        figure(F4)
        saveas(gcf,[filePath,'\error_single.eps'],'epsc')
        figure(F5)
        saveas(gcf,[filePath,'\output_single.eps'],'epsc')
        figure(F11)
        saveas(gcf,[filePath,'\perturbation_estimation.eps'],'epsc')
        figure(F12)
        saveas(gcf,[filePath,'\speed_estimation.eps'],'epsc')
    elseif strcmp('glnxa64',computer('arch'))
        figure(F2)
        saveas(gcf,[filePath,'/xy_plane_single.eps'],'epsc')
        figure(F3)
        saveas(gcf,[filePath,'/theta_plane_single.eps'],'epsc')
        figure(F4)
        saveas(gcf,[filePath,'/error_single.eps'],'epsc')
        figure(F5)
        saveas(gcf,[filePath,'/output_single.eps'],'epsc')
        figure(F11)
        saveas(gcf,[filePath,'/perturbation_estimation'],'epsc')
        figure(F12)
        saveas(gcf,[filePath,'/speed_estimation.eps'],'epsc')
    end
end
if(P.Trajectory == 0)
    combine_picture_name='circle.eps';
elseif(P.Trajectory == 1)
    combine_picture_name='rectangle.eps';
elseif(P.Trajectory == 2)
    combine_picture_name='lemniscate.eps';
end
% figure(F1)
% saveas(gcf,fullfile(currentDir,'SimExpImages',combine_picture_name),'epsc')

% save(['PD+NPD_LAMBDA=',num2str(P.lambda)],'P')
% num=['PD+NPD_lambda=',num2str(P.lambda)];
num='PD_NPD_MFAC_Simulation';
save(num,'P')
% MFAC_SimPrintFunction()
% NPD_SimPrintFunction()
MFAC_NPD_SimPrintFunction()
% clear P functions;
startFlag = false;
% end