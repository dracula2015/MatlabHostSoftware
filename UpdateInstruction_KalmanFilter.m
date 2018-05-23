function UpdateInstruction_KalmanFilter( frameOfData )
%UpdateInstruction 此处显示有关此函数的摘要
%   此处显示详细说明
global P;
% toc;
P.loopTime = [P.loopTime toc];
% tic
global RTX RTY RTTheta ESTX ESTY ESTTheta initialListener expListener expDataDir TIME Pause m
global startFlag;
global pauseFlag;
global stopFlag;
global s netClient netServer;
global frameRate;
global initFinished;
global initialAttitude;
global onStartAttitude;
persistent initialFrameTime;
persistent lastFrameTime;
persistent initial;
persistent qd_pre;
persistent dqd_pre;
persistent qN_pre;
persistent dqN_pre;
persistent qd;
persistent dqd;
persistent ddqd;
persistent qN;
persistent dqN;
persistent ddqN;
persistent voltage;
persistent lastNewFrameTime;
persistent stateEst;
persistent controlEffect;
persistent lastInitialFrameTime;
persistent pauseStatus;
P.loopCount = P.loopCount + 1;
%% initialize statics
if isempty(initial)
    lastFrameTime = frameOfData.fLatency;
    lastNewFrameTime = frameOfData.fLatency;
    initialFrameTime = frameOfData.fLatency;
    lastInitialFrameTime = frameOfData.fLatency;
    controlEffect = [0;0;0];
    stateEst = [0;0;0;0;0;0];
    % Desired attitude
    qd=[0;0;0];
    dqd=[0.1;0;0];
    ddqd=[0;0;0];
    qd_pre=[0;0;0];
    dqd_pre=[0;0;0];
    % Robot attitude
    qN=[0;0;0];
    dqN=[0;0;0];
    ddqN=[0;0;0];
    qN_pre=[0;0;0];
    dqN_pre=[0;0;0];
    voltage=[0;0;0;0;0;0];
    pauseStatus = 0;
    
    rigidBodyData = frameOfData.RigidBodies(1);
    q = quaternion( rigidBodyData.qx, rigidBodyData.qy, rigidBodyData.qz, rigidBodyData.qw );
    qRot = quaternion( 0, 0, 0, 1);     % rotate pitch 180 to avoid 180/-180 flip for nicer graphing
    q = mtimes(q, qRot);
    angles = EulerAngles(q,'zyx');
    angleX = -angles(1) * 180.0 / pi;   % must invert due to 180 flip above
    angleY = angles(2) * 180.0 / pi;
    angleZ = -angles(3) * 180.0 / pi;   % must invert due to 180 flip above
    %% R Quaternion Solution
    Cr=cos(pi*angleZ/180);
    Sr=sin(pi*angleZ/180);
    Cp=cos(pi*angleX/180);
    Sp=sin(pi*angleX/180);
    Cy=cos(pi*angleY/180);
    Sy=sin(pi*angleY/180);
    R=[-Cy*Cp Sp*Sr-Sy*Cp*Cr Sy*Cp*Sr+Cr*Sp;Sy -Cy*Cr Cy*Sr;Cy*Sp Cp*Sr+Sy*Cr*Sp Cp*Cr-Sy*Sp*Sr];
    pitch=asin(-R(3,1));
    sinyaw=R(2,1)/cos(pitch);
    cosyaw=R(1,1)/cos(pitch);
    sinroll=R(3,2)/cos(pitch);
    cosroll=R(3,3)/cos(pitch);
    yaw=2*pi-acos(cosyaw);
    if sinyaw>0 && cosyaw>0
        yaw=asin(sinyaw);
    end
    if  sinyaw>0 && cosyaw<0
        yaw=acos(cosyaw);
    end
    
    roll=asin(sinroll);
    if sinroll>0 && cosroll<0
        roll=acos(cosroll);
    end
    if sinroll<0 && cosroll<0
        roll=-acos(cosroll);
    end
    att1=[roll*180/pi pitch*180/pi yaw*180/pi];  % rigidbody1 attitude in degrees
    angleX=att1(2);
    angleZ=att1(1);
    if att1(3)>180
        angleY=540-att1(3);
    else
        angleY=180-att1(3);
    end
    % Robot attitude
    onStartAttitude(1) = -rigidBodyData.x;
    onStartAttitude(2) = rigidBodyData.z;
    onStartAttitude(3) = angleY*pi/180;
%     fwrite(s,'g');
    fwrite(netClient,'g','uint8');
    P.tcpipCount = P.tcpipCount + 1
end
% calculate the frame increment based on mocap frame's timestamp
% in general this should be monotonically increasing according
% To the mocap framerate, however frames are not guaranteed delivery
% so to be accurate we test and report frame drop or duplication
newFrame = true;
droppedFrames = false;
frameTime = frameOfData.fLatency;

P.instantTime = frameTime - initialFrameTime;

calcFrameInc = round( (frameTime - lastFrameTime) * frameRate );
if(calcFrameInc > 1)
    % debug
    % fprintf('\nDropped Frame(s) : %d\n\tLastTime : %.3f\n\tThisTime : %.3f\n', calcFrameInc-1, lastFrameTime, frameTime);
    droppedFrames = true;
elseif(calcFrameInc == 0)
    % debug
    % display('Duplicate Frame')
    newFrame = false;
end

if pauseStatus
    newFrame = false;
    %     initialFrameTime = P.instantTime - lastInitialFrameTime + initialFrameTime;
    initialFrameTime = frameTime - lastInitialFrameTime;
    lastNewFrameTime = frameTime;
    pauseStatus = false;
%     fwrite(s,'g');
    fwrite(netClient,'g','uint8');
    P.tcpipCount = P.tcpipCount + 1
end

% debug
% fprintf('FrameTime: %0.3f\tFrameID: %d\n',frameTime, frameID);
%% main loop
% try
if(newFrame)
    P.newFrameCount = P.newFrameCount +1;
    if(frameOfData.RigidBodies.Length() > 0)
        
        rigidBodyData = frameOfData.RigidBodies(1);
        P.dt = frameTime - lastNewFrameTime;
        % Test : Marker Y Position Data
        % angleY = data.LabeledMarkers(1).y;
        
        % Test : Rigid Body Y Position Data
        % angleY = rigidBodyData.y;
        
        % Test : Rigid Body 'Yaw'
        % Note : Motive display euler's is X (Pitch), Y (Yaw), Z (Roll), Right-Handed (RHS), Relative Axes
        % so we decode eulers heres to match that.
        q = quaternion( rigidBodyData.qx, rigidBodyData.qy, rigidBodyData.qz, rigidBodyData.qw );
        qRot = quaternion( 0, 0, 0, 1);     % rotate pitch 180 to avoid 180/-180 flip for nicer graphing
        q = mtimes(q, qRot);
        angles = EulerAngles(q,'zyx');
        angleX = -angles(1) * 180.0 / pi;   % must invert due to 180 flip above
        angleY = angles(2) * 180.0 / pi;
        angleZ = -angles(3) * 180.0 / pi;   % must invert due to 180 flip above
        %% R Quaternion Solution
        Cr=cos(pi*angleZ/180);
        Sr=sin(pi*angleZ/180);
        Cp=cos(pi*angleX/180);
        Sp=sin(pi*angleX/180);
        Cy=cos(pi*angleY/180);
        Sy=sin(pi*angleY/180);
        R=[-Cy*Cp Sp*Sr-Sy*Cp*Cr Sy*Cp*Sr+Cr*Sp;Sy -Cy*Cr Cy*Sr;Cy*Sp Cp*Sr+Sy*Cr*Sp Cp*Cr-Sy*Sp*Sr];
        pitch=asin(-R(3,1));
        sinyaw=R(2,1)/cos(pitch);
        cosyaw=R(1,1)/cos(pitch);
        sinroll=R(3,2)/cos(pitch);
        cosroll=R(3,3)/cos(pitch);
        yaw=2*pi-acos(cosyaw);
        if sinyaw>0 && cosyaw>0
            yaw=asin(sinyaw);
        end
        if  sinyaw>0 && cosyaw<0
            yaw=acos(cosyaw);
        end
        
        roll=asin(sinroll);
        if sinroll>0 && cosroll<0
            roll=acos(cosroll);
        end
        if sinroll<0 && cosroll<0
            roll=-acos(cosroll);
        end
        att1=[roll*180/pi pitch*180/pi yaw*180/pi];  % rigidbody1 attitude in degrees
        angleX=att1(2);
        angleZ=att1(1);
        if att1(3)>180
            angleY=540-att1(3);
        else
            angleY=180-att1(3);
        end
        
        %%
        % Robot attitude
        qN(1) = -rigidBodyData.x;
        qN(2) = rigidBodyData.z;
        P.thetaTemp = angleY*pi/180;
        if (P.thetaTemp - P.thetaTempPre) > pi
            P.thetaCount = P.thetaCount - 1;
        elseif (P.thetaTemp - P.thetaTempPre) < -pi
            P.thetaCount = P.thetaCount + 1;
        end
        qN(3) = P.thetaTemp + 2*pi*P.thetaCount;
%         qN(3) = angles(2);
%         qN=round(qN*10000)/10000;
        qN=round(qN*1000)/1000;
        dqN = (qN - qN_pre)/P.dt;
%         ddqN = (dqN-dqN_pre)/P.dt;
%         P.mobileSpeed(1) = P.mobileSpeedPre(1) + P.dt*(cos(qN(3))*m.Acceleration(1)-sin(qN(3))*m.Acceleration(2));
%         P.mobileSpeed(2) = P.mobileSpeedPre(2) + P.dt*(sin(qN(3))*m.Acceleration(1)+cos(qN(3))*m.Acceleration(2));
%         P.mobileSpeed = P.mobileSpeedPre;
%         dqN(1) = P.mobileSpeed(1);
%         dqN(2) = P.mobileSpeed(2);
        accelerate=OMRS_model(controlEffect,stateEst(1:3),stateEst(4:6),P.beta0,P.beta1,P.beta2,P.m,P.La,P.Iv);
        stateEst=KalmanFilter(stateEst, qN, [0;0;0;accelerate], P.dt);
%         stateEst=KalmanFilter(stateEst, [qN;dqN], [0;0;0;accelerate], P.dt);
        %% Reference trajectory
        qd = RefTrajectory;
        dqd=(qd-qd_pre)/P.dt;
        ddqd=(dqd-dqd_pre)/P.dt;

        if ~initFinished
            controlEffect = OMRS_controller(qd,dqd,ddqd,qN,dqN);
%             controlEffect = OMRS_initialization_controller(qd,dqd,ddqd,qN,dqN);
        else
            if(P.Method == 0)
                controlEffect = OMRS_controller(qd,dqd,ddqd,qN,dqN);
            elseif(P.Method == 1)
                controlEffect = OMRS_NPD_controller_wcica(qd,dqd,ddqd,qN,dqN);
            elseif(P.Method == 2)
                controlEffect = OMRS_FFDL_MFAC_controller(qd,dqd,ddqd,qN,dqN);
            end
        end
%         controlEffect = OMRS_FFDL_MFAC_controller(qd,dqd,ddqd,qN,dqN);
%         controlEffect = OMRS_NPD_controller(qd,dqd,ddqd,qN,dqN);
%         controlEffect = OMRS_NPD_controller(qd,dqd,ddqd,stateEst(1:3),stateEst(4:6));
        %% Calculate control voltage
        
%         voltage = typecast(single(controlEffect),'uint8');
%         for i=1:12
%             if voltage(i)==117 || voltage(i)==115 || voltage(i)==103
%                 voltage(i)=voltage(i)+1;
%             end
%         end
%         fwrite(netClient,['u';voltage;'g'],'uint8');
        
        controlVoltage = int32(100*controlEffect)
        P.controlEffect = controlEffect
        P.controlVoltage = controlVoltage
        for i = 1:3
            if controlVoltage(i)<0
                controlVoltage(i)=abs(controlVoltage(i))+32768;
            end
            voltage(2*i-1)=mod(controlVoltage(i),256);
            voltage(2*i)=floor(controlVoltage(i)/256);
        end
        for i=1:6
            if voltage(i)==117 || voltage(i)==115 || voltage(i)==103
                voltage(i)=voltage(i)+1;
            end
        end
        P.voltage=voltage
        fwrite(netClient,['u';voltage;'g'],'uint8');
        P.tcpipCount = P.tcpipCount + 8
%         fwrite(netClient,[117;voltage;103],'uint8');
        if(stopFlag)
            fwrite(netClient,'s','uint8');
            P.tcpipCount = P.tcpipCount + 1
        end
        
%         controlVoltage = int32(100*controlEffect);
%         for i = 1:3
%             if controlVoltage(i)<0
%                 controlVoltage(i)=abs(controlVoltage(i))+32768;
%             end
%             voltage(2*i-1)=mod(controlVoltage(i),256);
%             voltage(2*i)=floor(controlVoltage(i)/256);
%         end
%         for i=1:6
%             if voltage(i)==117 || voltage(i)==115 || voltage(i)==103
%                 voltage(i)=voltage(i)+1;
%             end
%         end
%         P.sendCommand = [117;voltage;103];
%         fwrite(s,'u');
%         fwrite(s,voltage,'uint8');
%         fwrite(s,'g');
%         if(stopFlag)
%             fwrite(s,'s');
%         end

        set(RTX,'string',num2str(qN(1),'%7.3f'));
        set(RTY,'string',num2str(qN(2),'%7.3f'))
%         set(RTX,'string',round(angleX*1000)/1000)
%         set(RTY,'string',round(angleZ*1000)/1000)
        set(RTTheta,'string',num2str(qN(3),'%7.3f'))
        set(ESTX,'string',num2str(stateEst(1),'%7.3f'))
        set(ESTY,'string',num2str(stateEst(2),'%7.3f'))
        set(ESTTheta,'string',num2str(stateEst(3),'%7.3f'))
        set(TIME,'string',num2str(P.instantTime,'%7.3f'))

        if initFinished
            P.QD=[P.QD qd];
            P.DQD=[P.DQD dqd];
            P.DDQD=[P.DDQD ddqd];
            P.QN=[P.QN qN];
            P.DQN=[P.DQN dqN];
            P.DDQN=[P.DDQN ddqN];
            if(P.Method == 0)
                P.NZ1=[P.NZ1 P.z1];
                P.NZ2=[P.NZ2 P.z2];
                P.NZ3=[P.NZ3 P.z3];
                P.NU=[P.NU P.uavc];
                P.NF=[P.NF P.f];
            elseif(P.Method == 1)
                P.NZ1=[P.NZ1 P.nz1];
                P.NZ2=[P.NZ2 P.nz2];
                P.NZ3=[P.NZ3 P.nz3];
                P.NU=[P.NU P.nuavc];
                P.NF=[P.NF P.nf];
            elseif(P.Method == 2)
                P.NU=[P.NU P.muavc];
            end
            P.T=[P.T P.instantTime];
            P.K=[P.K P.k];
            P.STATEST=[P.STATEST stateEst];
        end
        qd_pre=qd;
        dqd_pre=dqd;
        qN_pre=qN;
        dqN_pre=dqN;
        P.thetaTempPre = P.thetaTemp;
        lastNewFrameTime = frameTime;
    end
end
% catch err
%     display(err);
% end
if ~initFinished
    if ((initialAttitude - qN)'*(initialAttitude - qN))^0.5<0.05
        stopFlag = true;
%         fwrite(s,'s');
        fwrite(netClient,'s','uint8');
        P.tcpipCount = P.tcpipCount + 1
        if(~isempty(initialListener))
            delete(initialListener)
            clear('initialListener')
        end
        disp('initialization finished')
        initFinished = true;
    end
end
if(P.Trajectory == 0)
    if P.instantTime>30
    stopFlag = true;
    end
else
    if P.instantTime>40
    stopFlag = true;
    end
end

if stopFlag
    if(~isempty(expListener))
        delete(expListener) 
        clear('expListener')
        %% save data
        %datetime('today');
        time=clock;
        %dataTime=[num2str(time(1),'%02d'),num2str(time(2),'%02d'),num2str(time(3),'%02d'),num2str(time(4),'%02d'),num2str(time(5),'%02d'),num2str(int64(time(6)),'%02d')];
        dataTime=[num2str(time(1),'%02d'),num2str(time(2),'%02d'),num2str(time(3),'%02d'),num2str(time(4),'%02d'),num2str(time(5),'%02d')];
        currentDir=pwd;
        mkdir(fullfile(currentDir,'experimentData',['OMRS_Experiment_',dataTime]));
        dataDir=fullfile(currentDir,'experimentData',['OMRS_Experiment_',dataTime]);
        filePath=fullfile(dataDir,['NPD_lambda=',num2str(P.lambda)]);
        expDataDir=filePath;
        save(filePath,'P')
        
        if(P.Trajectory == 0)
            end_file_name='circle.mat';
        elseif(P.Trajectory == 1)
            end_file_name='rectangle.mat';
        elseif(P.Trajectory == 2)
            end_file_name='lemniscate.mat';
        end
        if(P.Method == 0)
            partial_file_name='PD_';
        elseif(P.Method == 1)
            partial_file_name='NPD_';
        elseif(P.Method == 2)
            partial_file_name='MFAC_';
        end
        currentDir=pwd;
        filePath=fullfile(currentDir,'experimentData',['OMRS_Experiment_',partial_file_name,end_file_name]);
        save(filePath,'P')
        
        % expDataAnalysis;
        if 1
            %% paper graphics
            %% x-y plane
            F2=figure('name','x-y plane','position',[50 70 570 450]);
            plot(P.QD(1,:),P.QD(2,:),'b.-',P.QN(1,:),P.QN(2,:),'r.--')
            %rectangle
            axis([-0.2 1.2 -0.1 1.3])
            %lemniscate
            %axis([-2 2 -2 2])
            xlabel('x(m)')
            ylabel('y(m)')
            L1=legend('Reference','Response(NPID)');
            set(L1,'Location','northeast')
            hold on
            
            %% theta plane
            F3=figure('name','\theta plane','position',[60 80 570 450]);
            plot(P.T,P.QD(3,:),'b.-',P.T,P.QN(3,:),'r.--');
            axis([0 P.instantTime -3 10])
            xlabel('t(s)')
            ylabel('\theta(rad)')
            L2=legend('Reference','Response(NPID)');
            set(L2,'Location','SouthEast')
            hold on
            
            %% error
            F4=figure('name','error','position',[70 90 570 450]);
            % X error
            subplot(311);
            plot(P.T,P.QN(1,:)-P.QD(1,:),'r.--');
            axis([0 P.instantTime -0.5 0.5])
            ylabel('e_x(m)')
            hold on
            % Y error
            subplot(312)
            plot(P.T,P.QN(2,:)-P.QD(2,:),'r.--');
            axis([0 P.instantTime -0.5 0.5])
            ylabel('e_y(m)')
            L3=legend('NPID');
            set(L3,'Location','NorthWest','FontSize',6)
            hold on
            % theta error
            subplot(313);
            plot(P.T,P.QN(3,:)-P.QD(3,:),'r.--');
            axis([0 P.instantTime -0.5 0.5])
            xlabel('t(s)')
            ylabel('e_\theta(rad)')
            hold on
            
            %% output
            F5=figure('name','output','position',[80 100 570 450]);
            % u1 output
            subplot(311);
            plot(P.T,P.NU(1,:),'r.--');
            axis([0 P.instantTime -40 40])
            ylabel('u_1(V)')
            hold on
            % u2 output
            subplot(312)
            plot(P.T,P.NU(2,:),'r.--');
            axis([0 P.instantTime -40 40])
            ylabel('u_2(V)')
            L4=legend('NPID');
            set(L4,'Location','NorthWest','FontSize',6)
            hold on
            % u3 output
            subplot(313);
            plot(P.T,P.NU(3,:),'r.--')
            axis([0 P.instantTime -40 40])
            %xlabel('t(s)','fontname','times new roman','fontweight','bold')
            xlabel('t(s)')
            ylabel('u_3(V)')
            hold on
            %% New Format Conversion
%             figure(F2)
%             saveas(gcf,fullfile(dataDir,'xy_plane_single_exp.eps'),'epsc')
%             figure(F3)
%             saveas(gcf,fullfile(dataDir,'theta_plane_single_exp.eps'),'epsc')
%             figure(F4)
%             saveas(gcf,fullfile(dataDir,'error_single_exp.eps'),'epsc')
%             figure(F5)
%             saveas(gcf,fullfile(dataDir,'output_single_exp.eps'),'epsc')
        end
    end
    if(~isempty(initialListener))
        delete(initialListener)
        clear('initialListener')
    end
%     fwrite(s,'s');
    fwrite(netClient,'s','uint8');
    P.tcpipCount = P.tcpipCount + 1
    startFlag = false;
    initFinished = true;
end

%% record data
lastFrameTime = frameTime;
initial = 0;
if(pauseFlag)
%     fwrite(s,'s');
    fwrite(netClient,'s','uint8');
    P.tcpipCount = P.tcpipCount + 1
    lastInitialFrameTime = P.instantTime;
    pauseStatus = 1;
end
waitfor(Pause,'string','Continue');
% while pauseFlag
%     drawnow
% end
P.functionTime = [P.functionTime toc];
end