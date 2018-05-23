function MFAC_NPD_ExpPrintFunction()
%% ===== Initial parameters
% global P MFAC;
Trajectory = 0;
if(Trajectory == 0)
    end_file_name='circle.mat';
elseif(Trajectory == 1)
    end_file_name='rectangle.mat';
elseif(Trajectory == 2)
    end_file_name='lemniscate.mat';
end
currentDir=pwd;
partial_file_name='MFAC_';
filePath=fullfile(currentDir,'experimentData',['OMRS_Experiment_',partial_file_name,end_file_name]);
load(filePath);

% style={'k-','b--','g-.','r:','m:'};
style={'k-','g-.','b--','r:','m:'};
% style={'k-','g-.','r:','b--','m:'};

lineWidth=2;
IAExp=[];

F6=figure('name','x-y plane npd mfac exp','position',[90 110 570 450]);
F7=figure('name','theta plane npd mfac exp','position',[100 120 570 450]);
F8=figure('name','error npd mfac exp','position',[110 130 570 450]);
F9=figure('name','output npd mfac exp','position',[120 140 570 450]);

methodNum = 3;%3:PD,NPD,MFAC;
              %2:PD,NPD;
%% Reference
    %% paper graphics
    %% Reference, PD response, NPD response and MFAC response
    %% x-y plane
    figure(F6)
    plot(P.QD(1,2:end),P.QD(2,2:end),style{1},'LineWidth',lineWidth)
    if(Trajectory == 0)
        axis([-1 1 -1 1])
    elseif(Trajectory == 1)
        axis([-0.1 1.1 -0.1 1.1])
    elseif(Trajectory == 2)
        axis([-0.6 0.6 -0.6 0.6])
    end
    xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
%     L5=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
%     set(L5,'Location','SouthEast','FontSize',10)
    hold on
    %% theta plane
    figure(F7)
    plot(P.T,P.QD(3,:),style{1},'LineWidth',lineWidth);
    axis([0 P.instantTime -1 6])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
%     L6=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
%     set(L6,'Location','SouthEast','FontSize',10)
    hold on
%% PD, NPD AND MFAC RESPONSE
for i=1:methodNum
    if(i == 1)
        partial_file_name='PD_';
    elseif(i == 2)
        partial_file_name='NPD_';
    elseif(i == 3)
        partial_file_name='MFAC_';
    end
    currentDir=pwd;
    filePath=fullfile(currentDir,'experimentData',['OMRS_Experiment_',partial_file_name,end_file_name]);
    load(filePath);
    if isempty(IAExp)
        IAExp=iaeExp(P.QN-P.QD,P.T);
    else
        IAExp=[IAExp iaeExp(P.QN-P.QD,P.T)];
    end
    
    %% paper graphics
    %% PD response, NPD response and MFAC response
    %% x-y plane
    figure(F6)
    plot(P.QN(1,2:end),P.QN(2,2:end),style{i+1},'LineWidth',lineWidth)
    if(Trajectory == 0)
        axis([-1 1 -1 1])
    elseif(Trajectory == 1)
        axis([-0.1 1.1 -0.1 1.1])
    elseif(Trajectory == 2)
        axis([-0.6 0.6 -0.6 0.6])
    end
%     xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
%     ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
%     L5=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
%     set(L5,'Location','SouthEast','FontSize',10)
    hold on
    %% theta plane
    figure(F7)
    plot(P.T,P.QN(3,:),style{i+1},'LineWidth',lineWidth);
%     axis([0 P.instantTime -1 6])
%     xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
%     ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
%     L6=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
%     set(L6,'Location','SouthEast','FontSize',10)
    hold on
    %% error
    figure(F8)
    % X error
    subplot(311);
    plot(P.T,P.QN(1,:)-P.QD(1,:),style{i+1},'LineWidth',lineWidth);
    axis([0 P.instantTime -0.1 0.1])
    ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
    hold on
    % Y error
    subplot(312)
    plot(P.T,P.QN(2,:)-P.QD(2,:),style{i+1},'LineWidth',lineWidth);
    axis([0 P.instantTime -0.1 0.1])
    ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
%     L7=legend('PD','NPD','MFAC');
%     set(L7,'Location','NorthWest','FontSize',10);
    hold on
    % theta error
    subplot(313);
    plot(P.T,P.QN(3,:)-P.QD(3,:),style{i+1},'LineWidth',lineWidth);
    axis([0 P.instantTime -0.15 0.15])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15')
    ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
    hold on
    %% output
    figure(F9)
    % u1 output
    subplot(311);
    plot(P.T,P.NU(1,:),style{i+1},'LineWidth',lineWidth);
    axis([0 P.instantTime -20 20])
    ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
    hold on
    % u2 output
    subplot(312)
    plot(P.T,P.NU(2,:),style{i+1},'LineWidth',lineWidth);
    axis([0 P.instantTime -20 20])
    ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
%     L8=legend('PD','NPD','MFAC');
%     set(L8,'Location','NorthWest','FontSize',10)
    hold on
    % u3 output
    subplot(313);
    plot(P.T,P.NU(3,:),style{i+1},'LineWidth',lineWidth)
    axis([0 P.instantTime -20 20])
    xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
    ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
    hold on
end

figure(F6)
L5=legend('Reference','Response(PD)','Response(NPD)','Response(CFDL-MFAPDC)');
%set(L5,'Location','SouthEast')
%set(L5,'box','off','Location','SouthEast');
set(L5,'box','on','position',[0.45 0.35 0.2877 0.1911]);
figure(F7)
L6=legend('Reference','Response(PD)','Response(NPD)','Response(CFDL-MFAPDC)');
%set(L6,'Location','SouthEast')
%set(L6,'box','off','Location','SouthEast');
set(L6,'box','on','position',[0.2 0.6 0.2877 0.1911]);
figure(F8)
L7=legend('PD','NPD','CFDL-MFAPDC');
%set(L7,'Location','NorthWest','FontSize',6)
%set(L7,'box','off','Location','West');
set(L7,'box','on','position',[0.135 0.3 0.1789 0.1544]);
figure(F9)
L8=legend('PD','NPD','CFDL-MFAPDC');
%set(L8,'Location','NorthWest','FontSize',6)
%set(L8,'box','off','Location','West');
set(L8,'box','on','position',[0.135 0.3 0.1789 0.1544]);

% %% Real system perturbation and its corresponding estimation
% F11=figure('name','real perturbation and its estimation','position',[90 110 570 450]);
% %% PD X channel estimated perturbation
% subplot(3,1,1);
% plot(P.T,P.NF(1,:),style{2},P.T,P.NZ3(1,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -10 10])
% ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
% hold on
% %% PD Y channel estimated perturbation
% subplot(3,1,2)
% plot(P.T,P.NF(2,:),style{2},P.T,P.NZ3(2,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -10 10])
% ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
% L3=legend('Real','Estimated');
% set(L3,'Location','NorthWest','FontSize',10);
% hold on
% %% PD theta channel estimated perturbation
% subplot(3,1,3);
% plot(P.T,P.NF(3,:),style{2},P.T,P.NZ3(3,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -50 50])
% xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
% ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
% hold on
% 
% %% Real robot speed and its corresponding estimation
% F12=figure('name','real speed and its estimation','position',[100 120 570 450]);
% %% PD X channel estimated speed
% subplot(3,1,1);
% plot(P.T,P.DQN(1,:),style{2},P.T,P.NZ2(1,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -0.5 0.5])
% ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
% hold on
% %% PD Y channel estimated speed
% subplot(3,1,2)
% plot(P.T,P.DQN(2,:),style{2},P.T,P.NZ2(2,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -0.5 0.5])
% ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
% L3=legend('Real','Estimated');
% set(L3,'Location','NorthWest','FontSize',10);
% hold on
% %% PD theta channel estimated speed
% subplot(3,1,3);
% plot(P.T,P.DQN(3,:),style{2},P.T,P.NZ2(3,:),style{3},'LineWidth',lineWidth);
% axis([0 P.instantTime -1.5 2.0])
% xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
% ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
% hold on

filePath=fullfile(currentDir,'SimExpImages');
if(Trajectory == 0)
    end_picture_name='exp_circle.eps';
elseif(Trajectory == 1)
    end_picture_name='exp_rectangle.eps';
elseif(Trajectory == 2)
    end_picture_name='exp_lemniscate.eps';
end

if methodNum == 2
    partial_picture_name = 'npd_';
elseif methodNum == 3
    partial_picture_name = 'multi_';
end
%% New Format Conversion
if 1
%     figure(F2)
%     saveas(gcf,fullfile(filePath,['xy_plane_npd_',partial_picture_name,end_picture_name]),'epsc')
%     figure(F3)
%     saveas(gcf,fullfile(filePath,['theta_plane_npd_',partial_picture_name,end_picture_name]),'epsc')
%     figure(F4)
%     saveas(gcf,fullfile(filePath,['error_npd_',partial_picture_name,end_picture_name]),'epsc')
%     figure(F5)
%     saveas(gcf,fullfile(filePath,['output_plane_npd_',partial_picture_name,end_picture_name]),'epsc')
    figure(F6)
    saveas(gcf,fullfile(filePath,['xy_plane_',partial_picture_name,end_picture_name]),'epsc')
    figure(F7)
    saveas(gcf,fullfile(filePath,['theta_plane_',partial_picture_name,end_picture_name]),'epsc')
    figure(F8)
    saveas(gcf,fullfile(filePath,['error_',partial_picture_name,end_picture_name]),'epsc')
    figure(F9)
    saveas(gcf,fullfile(filePath,['output_',partial_picture_name,end_picture_name]),'epsc')
%     figure(F11)
%     saveas(gcf,fullfile(filePath,['perturbation_estimation_',end_picture_name]),'epsc')
%     figure(F12)
%     saveas(gcf,fullfile(filePath,['speed_estimation_',end_picture_name]),'epsc')
end
IAExp
P.iaeExp=IAExp;
% pwd
end