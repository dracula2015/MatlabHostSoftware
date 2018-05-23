function expMainFunction2_0(source,eventdata)
%% ===== Initial parameters
global startFlag stopFlag pauseFlag theClient P MFAC expListener;
P.loopTime = 0;
P.functionTime = 0;
P.writeTime = 0;
P.realTime = 0;
P.startTime = tic;
tic;
% clear P MFAC functions;
clear UpdateInstruction_KalmanFilter;
stopFlag = false;
pauseFlag = false;
Parameters;
MFAC.lambda = 1;%1.6;%2;%1;%5;%1;%0.01;%1;%0.001;%0.1 %1 %5 %10 %15;
% MFAC.Kp = 2;%4;%3;%4;%3;%3;%4;%3;%3;%2;%3;%10;%15;%5;%15;
% MFAC.Kd = 4;%3;%6;%;%7;%3;%6;%4;%5;%6;%6;%3;%6;
% MFAC.Kp = 6;%4;
% MFAC.Kd = 6;
%% best parameters when lambda = 1. MFAC.Ly = 0. MFAC.Lu = 1.
MFAC.Kp = 3;%4;%4;%2;%2;%3;%3;
MFAC.Kd = 6;%2;%3;%3;%5;%6;%4;
%%
MFAC.Ly = 0;%3;
MFAC.Lu = 1;%3;
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
    eval(['MFAC.Phy_pL',num2str(i),' = MFAC.Phy_pL(1:3,3*',num2str(i-1),'+1:3*(',num2str(i-1),'+1));']);
end

MFAC.PHY_PL = MFAC.Phy_pL;
for i = 1 : (MFAC.Ly + MFAC.Lu)
    MFAC.PHY_PL = [MFAC.PHY_PL;MFAC.Phy_pL];
end

MFAC.PHY_FL = zeros((MFAC.Ly + MFAC.Lu) + 1,3*3*(MFAC.Ly + MFAC.Lu));

MFAC.control_input = [0;0;0];

style={'k-','b--','g-.','r:','m:'};

P.thetaCount = 0;
P.thetaTemp = 0;
P.thetaTempPre = 0;
P.dt=[];
P.instantTime=[];
P.speed=0.1;
P.rectLength=1;

P.iaeExp=[];
P.iaeSim=[];

P.gp=0;
P.lambdan=[5,10,100];
P.lambda=100;
P.NPIDKP=[0;0;0];
P.BASCIKP=[0;0;0];
P.ctrlVolt=[0;0;0];

P.QD=[0;0;0];
P.DQD=[0;0;0];
P.DDQD=[0;0;0];
P.QN=[0;0;0];
P.DQN=[0;0;0];
P.DDQN=[0;0;0];
P.NZ1=[0;0;0];
P.NZ2=[0;0;0];
P.NZ3=[0;0;0];
% P.U=[0;0;0];
P.NU=[0;0;0];
% P.F=[0;0;0];
P.NF=[0;0;0];
P.T=0;
P.K=[0;0;0];
P.STATEST=[0;0;0;0;0;0];
P.mobileSpeed = [0;0];
P.mobileSpeedPre = [0;0];

P.tcpipCount=0;
P.loopCount=0;
P.newFrameCount = 0;
%% Initialize Figure
set(0, 'defaultfigurecolor', 'w')
%% Add event listener
% usePollingLoop = false;         % approach 1 : poll for mocap data in a tight loop using GetLastFrameOfData
% usePollingTimer = false;        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
% useFrameReadyEvent = true;      % approach 3 : use event callback from NatNet (no polling)
% F0=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off');
try
    %experiment initial time
    %     frameOfData=theClient.GetLastFrameOfData();
    %     initialFrameTime=frameOfData.fLatency;
    % get the mocap data
    % Add NatNet FrameReady event handler
    expListener = addlistener(theClient,'OnFrameReady2',@(src,event)FrameReadyCallback(src,event));
    display('[NatNet] FrameReady Listener added.');
catch err
    display(err);
end

end