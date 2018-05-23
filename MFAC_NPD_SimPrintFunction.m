function MFAC_NPD_SimPrintFunction()
%% ===== Initial parameters
global P MFAC;
% style={'k-','b--','g-.','r:','m:'};
style={'k-','g-.','b--','r:','m:'};
% style={'k-','g-.','r:','b--','m:'};
lineWidth=2;
IAESim=[0;0];
F1=figure('Position',[40 60 1000 900],'name',['MFAC.lambda = ',num2str(MFAC.lambda)]);
F2=figure('name','x-y plane npd','position',[50 70 570 450]);
F3=figure('name','theta plane npd','position',[60 80 570 450]);
F4=figure('name','error npd','position',[70 90 570 450]);
F5=figure('name','output npd','position',[80 100 570 450]);
F6=figure('name','x-y plane npd mfac','position',[90 110 570 450]);
F7=figure('name','theta plane npd mfac','position',[100 120 570 450]);
F8=figure('name','error npd mfac','position',[110 130 570 450]);
F9=figure('name','output npd mfac','position',[120 140 570 450]);
currentDir=pwd;
filePath=fullfile(currentDir,['PD_NPD_MFAC_Simulation','.mat']);
load(filePath);

IAESim=iaeSim(P.Q-P.QD,P.T);
IAESim=[IAESim iaeSim(P.QN-P.QD,P.T)];
IAESim=[IAESim iaeSim(P.QM-P.QD,P.T)];

%% Big Picture
%% X-Y plane
figure(F1);
subplot(221);
plot(P.QD(1,:),P.QD(2,:),style{1},P.Q(1,:),P.Q(2,:),style{2},P.QN(1,:),P.QN(2,:),style{3},P.QM(1,:),P.QM(2,:),style{4},'LineWidth',lineWidth)
if(P.Trajectory == 0)
    axis([-1 1 -1 1])
elseif(P.Trajectory == 1)
    axis([-0.1 1.1 -0.1 1.1])
elseif(P.Trajectory == 2)
    axis([-0.6 0.6 -0.6 0.6])
end
xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
L5=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
set(L5,'Location','SouthEast','FontSize',10)
hold on
%% theta plane
subplot(222);
plot(P.T,P.QD(3,:),style{1},P.T,P.Q(3,:),style{2},P.T,P.QN(3,:),style{3},P.T,P.QM(3,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -1 6])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
L6=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
set(L6,'Location','SouthEast','FontSize',10)
hold on
%% X error
subplot(627);
plot(P.T,P.Q(1,:)-P.QD(1,:),style{2},P.T,P.QN(1,:)-P.QD(1,:),style{3},P.T,P.QM(1,:)-P.QD(1,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
hold on
%% Y error
subplot(6,2,9)
plot(P.T,P.Q(2,:)-P.QD(2,:),style{2},P.T,P.QN(2,:)-P.QD(2,:),style{3},P.T,P.QM(2,:)-P.QD(2,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
L7=legend('PD','NPD','MFAC');
set(L7,'Location','NorthWest','FontSize',10);
hold on
%% theta error
subplot(6,2,11);
plot(P.T,P.Q(3,:)-P.QD(3,:),style{2},P.T,P.QN(3,:)-P.QD(3,:),style{3},P.T,P.QM(3,:)-P.QD(3,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.15 0.15])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15')
ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
hold on
%% u1 output
subplot(628);
plot(P.T,P.U(1,:),style{2},P.T,P.UN(1,:),style{3},P.T,P.UM(1,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
hold on
%% u2 output
subplot(6,2,10)
plot(P.T,P.U(2,:),style{2},P.T,P.UN(2,:),style{3},P.T,P.UM(2,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
L8=legend('PD','NPD','MFAC');
set(L8,'Location','NorthWest','FontSize',10)
hold on
%% u3 output
subplot(6,2,12);
plot(P.T,P.U(3,:),style{2},P.T,P.UN(3,:),style{3},P.T,P.UM(3,:),style{4},'LineWidth',lineWidth)
axis([0 P.stime -20 20])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
hold on

%% Reference, PD response, NPD response
%% x-y plane
figure(F2)
plot(P.QD(1,:),P.QD(2,:),style{1},P.Q(1,:),P.Q(2,:),style{2},P.QN(1,:),P.QN(2,:),style{3},'LineWidth',lineWidth)
if(P.Trajectory == 0)
    axis([-1 1 -1 1])
elseif(P.Trajectory == 1)
    axis([-0.1 1.1 -0.1 1.1])
elseif(P.Trajectory == 2)
    axis([-0.6 0.6 -0.6 0.6])
end
xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
% L1=legend('Reference','Response(PD)','Response(NPD)');
% set(L1,'Location','SouthEast','FontSize',10)
hold on
%% theta plane
figure(F3)
plot(P.T,P.QD(3,:),style{1},P.T,P.Q(3,:),style{2},P.T,P.QN(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -1 6])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
% L2=legend('Reference','Response(PD)','Response(NPD)');
% set(L2,'Location','SouthEast','FontSize',10)
hold on
%% error
figure(F4)
% X error
subplot(311);
plot(P.T,P.Q(1,:)-P.QD(1,:),style{2},P.T,P.QN(1,:)-P.QD(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
hold on
% Y error
subplot(312)
plot(P.T,P.Q(2,:)-P.QD(2,:),style{2},P.T,P.QN(2,:)-P.QD(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
% L3=legend('PD','NPD');
% set(L3,'Location','NorthWest','FontSize',10);
hold on
% theta error
subplot(313);
plot(P.T,P.Q(3,:)-P.QD(3,:),style{2},P.T,P.QN(3,:)-P.QD(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -0.15 0.15])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15')
ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
hold on
%% output
figure(F5)
% u1 output
subplot(311);
plot(P.T,P.U(1,:),style{2},P.T,P.UN(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
hold on
% u2 output
subplot(312)
plot(P.T,P.U(2,:),style{2},P.T,P.UN(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
% L4=legend('PD','NPD');
% set(L4,'Location','NorthWest','FontSize',10)
hold on
% u3 output
subplot(313);
plot(P.T,P.U(3,:),style{2},P.T,P.UN(3,:),style{3},'LineWidth',lineWidth)
axis([0 P.stime -20 20])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
hold on

%% paper graphics
%% Reference, PD response, NPD response and MFAC response
%% x-y plane
figure(F6)
plot(P.QD(1,:),P.QD(2,:),style{1},P.Q(1,:),P.Q(2,:),style{2},P.QN(1,:),P.QN(2,:),style{3},P.QM(1,:),P.QM(2,:),style{4},'LineWidth',lineWidth)
if(P.Trajectory == 0)
    axis([-1 1 -1 1])
elseif(P.Trajectory == 1)
    axis([-0.1 1.1 -0.1 1.1])
elseif(P.Trajectory == 2)
    axis([-0.6 0.6 -0.6 0.6])
end
xlabel('$\bf{x(m)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{y(m)}$','interpreter','latex','fontsize',15)
% L5=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
% set(L5,'Location','SouthEast','FontSize',10)
hold on
%% theta plane
figure(F7)
plot(P.T,P.QD(3,:),style{1},P.T,P.Q(3,:),style{2},P.T,P.QN(3,:),style{3},P.T,P.QM(3,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -1 6])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{\theta(rad)}$','interpreter','latex','fontsize',15)
% L6=legend('Reference','Response(PD)','Response(NPD)','Response(MFAC)');
% set(L6,'Location','SouthEast','FontSize',10)
hold on
%% error
figure(F8)
% X error
subplot(311);
plot(P.T,P.Q(1,:)-P.QD(1,:),style{2},P.T,P.QN(1,:)-P.QD(1,:),style{3},P.T,P.QM(1,:)-P.QD(1,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_x(m)}$','interpreter','latex','fontsize',15)
hold on
% Y error
subplot(312)
plot(P.T,P.Q(2,:)-P.QD(2,:),style{2},P.T,P.QN(2,:)-P.QD(2,:),style{3},P.T,P.QM(2,:)-P.QD(2,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.1 0.1])
ylabel('$\bf{e_y(m)}$','interpreter','latex','fontsize',15)
% L7=legend('PD','NPD','MFAC');
% set(L7,'Location','NorthWest','FontSize',10);
hold on
% theta error
subplot(313);
plot(P.T,P.Q(3,:)-P.QD(3,:),style{2},P.T,P.QN(3,:)-P.QD(3,:),style{3},P.T,P.QM(3,:)-P.QD(3,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -0.15 0.15])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15')
ylabel('$\bf{e_\theta(rad)}$','interpreter','latex','fontsize',15)
hold on
%% output
figure(F9)
% u1 output
subplot(311);
plot(P.T,P.U(1,:),style{2},P.T,P.UN(1,:),style{3},P.T,P.UM(1,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_1(V)}$','interpreter','latex','fontsize',15)
hold on
% u2 output
subplot(312)
plot(P.T,P.U(2,:),style{2},P.T,P.UN(2,:),style{3},P.T,P.UM(2,:),style{4},'LineWidth',lineWidth);
axis([0 P.stime -20 20])
ylabel('$\bf{u_2(V)}$','interpreter','latex','fontsize',15)
% L8=legend('PD','NPD','MFAC');
% set(L8,'Location','NorthWest','FontSize',10)
hold on
% u3 output
subplot(313);
plot(P.T,P.U(3,:),style{2},P.T,P.UN(3,:),style{3},P.T,P.UM(3,:),style{4},'LineWidth',lineWidth)
axis([0 P.stime -20 20])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{u_3(V)}$','interpreter','latex','fontsize',15)
hold on
%%
figure(F2)
L1=legend('Reference','Response(PD)','Response(NPD)','Response(CFDL-MFAPDC)');
%set(L1,'Location','SouthEast')
%set(L1,'box','off','Location','SouthEast');
set(L1,'box','on','position',[0.45 0.35 0.2877 0.1911]);
figure(F3)
L2=legend('Reference','Response(PD)','Response(NPD)','Response(CFDL-MFAPDC)');
%set(L2,'Location','SouthEast')
%set(L2,'box','off','Location','SouthEast');
set(L2,'box','on','position',[0.2 0.6 0.2877 0.1911]);
figure(F4)
L3=legend('PD','NPD','CFDL-MFAPDC');
%set(L3,'Location','NorthWest','FontSize',6)
%set(L3,'box','off','Location','West');
set(L3,'box','on','position',[0.135 0.3 0.1789 0.1544]);
figure(F5)
L4=legend('PD','NPD','CFDL-MFAPDC');
%set(L4,'Location','NorthWest','FontSize',6)
%set(L4,'box','off','Location','West');
set(L4,'box','on','position',[0.135 0.3 0.1789 0.1544]);
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

%% Real system perturbation and its corresponding estimation
F11=figure('name','real perturbation and its estimation','position',[90 110 570 450]);
%% PD X channel estimated perturbation
subplot(3,1,1);
plot(P.T,P.F(1,:),style{2},P.T,P.Z3(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -10 10])
ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
hold on
%% PD Y channel estimated perturbation
subplot(3,1,2)
plot(P.T,P.F(2,:),style{2},P.T,P.Z3(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -10 10])
ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
L3=legend('Real','Estimated');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% PD theta channel estimated perturbation
subplot(3,1,3);
plot(P.T,P.F(3,:),style{2},P.T,P.Z3(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -50 50])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
hold on

%% Real robot speed and its corresponding estimation
F12=figure('name','real speed and its estimation','position',[100 120 570 450]);
%% PD X channel estimated speed
subplot(3,1,1);
plot(P.T,P.DQ(1,:),style{2},P.T,P.Z2(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -0.5 0.5])
ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
hold on
%% PD Y channel estimated speed
subplot(3,1,2)
plot(P.T,P.DQ(2,:),style{2},P.T,P.Z2(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -0.5 0.5])
ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
L3=legend('Real','Estimated');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% PD theta channel estimated speed
subplot(3,1,3);
plot(P.T,P.DQ(3,:),style{2},P.T,P.Z2(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.stime -1.5 2.0])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
hold on

filePath=fullfile(currentDir,'SimExpImages');
if(P.Trajectory == 0)
    end_picture_name='circle.eps';
elseif(P.Trajectory == 1)
    end_picture_name='rectangle.eps';
elseif(P.Trajectory == 2)
    end_picture_name='lemniscate.eps';
end
% if(P.Method == 0)
%     partial_picture_name='PD_';
% elseif(P.Method == 1)
%     partial_picture_name='NPD_';
% elseif(P.Method == 2)
%     partial_picture_name='MFAC_';
% end
partial_picture_name=[];

%% New Format Conversion
if 1
%     figure(F1)
%     saveas(gcf,fullfile(filePath,['big_picture_',partial_picture_name,end_picture_name]),'epsc')
    figure(F2)
    saveas(gcf,fullfile(filePath,['xy_plane_npd_',partial_picture_name,end_picture_name]),'epsc')
    figure(F3)
    saveas(gcf,fullfile(filePath,['theta_plane_npd_',partial_picture_name,end_picture_name]),'epsc')
    figure(F4)
    saveas(gcf,fullfile(filePath,['error_npd_',partial_picture_name,end_picture_name]),'epsc')
    figure(F5)
    saveas(gcf,fullfile(filePath,['output_npd_',partial_picture_name,end_picture_name]),'epsc')
    figure(F6)
    saveas(gcf,fullfile(filePath,['xy_plane_multi_',partial_picture_name,end_picture_name]),'epsc')
    figure(F7)
    saveas(gcf,fullfile(filePath,['theta_plane_multi_',partial_picture_name,end_picture_name]),'epsc')
    figure(F8)
    saveas(gcf,fullfile(filePath,['error_multi_',partial_picture_name,end_picture_name]),'epsc')
    figure(F9)
    saveas(gcf,fullfile(filePath,['output_multi_',partial_picture_name,end_picture_name]),'epsc')
    figure(F11)
    saveas(gcf,fullfile(filePath,['perturbation_estimation_',partial_picture_name,end_picture_name]),'epsc')
    figure(F12)
    saveas(gcf,fullfile(filePath,['speed_estimation_',partial_picture_name,end_picture_name]),'epsc')
end
IAESim
P.iaeSim=IAESim;
% pwd
end