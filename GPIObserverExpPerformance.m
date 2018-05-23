Trajectory = 0;
if(Trajectory == 0)
    end_file_name='circle.mat';
elseif(Trajectory == 1)
    end_file_name='rectangle.mat';
elseif(Trajectory == 2)
    end_file_name='lemniscate.mat';
end
currentDir=pwd;
partial_file_name='PD_';%'NPD_';%MFAC_;
filePath=fullfile(currentDir,'experimentData',['OMRS_Experiment_',partial_file_name,end_file_name]);
load(filePath);

style={'k-','g-.','b--','r:','m:'};
lineWidth=2;
%% Real system perturbation and its corresponding estimation
F11=figure('name','real perturbation and its estimation','position',[90 110 570 450]);
%% PD X channel estimated perturbation
subplot(3,1,1);
plot(P.T,P.NZ3(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -10 10])
ylabel('$\bf{f_x(m/(s^2))}$','interpreter','latex','fontsize',15)
hold on
%% PD Y channel estimated perturbation
subplot(3,1,2)
plot(P.T,P.NZ3(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -10 10])
ylabel('$\bf{f_y(m/(s^2))}$','interpreter','latex','fontsize',15)
L3=legend('Estimated');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% PD theta channel estimated perturbation
subplot(3,1,3);
plot(P.T,P.NZ3(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -50 50])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{f_\theta(rad/(s^2))}$','interpreter','latex','fontsize',15)
hold on
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

%% Real robot speed and its corresponding estimation
F12=figure('name','real speed and its estimation','position',[100 120 570 450]);
%% PD X channel estimated speed
subplot(3,1,1);
plot(P.T,P.DQN(1,:),style{2},P.T,P.NZ2(1,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -0.5 0.5])
ylabel('$\bf{\dot{x}(m/(s^2))}$','interpreter','latex','fontsize',15)
hold on
%% PD Y channel estimated speed
subplot(3,1,2)
plot(P.T,P.DQN(2,:),style{2},P.T,P.NZ2(2,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -0.5 0.5])
ylabel('$\bf{\dot{y}(m/(s^2))}$','interpreter','latex','fontsize',15)
L3=legend('Real','Estimated');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% PD theta channel estimated speed
subplot(3,1,3);
plot(P.T,P.DQN(3,:),style{2},P.T,P.NZ2(3,:),style{3},'LineWidth',lineWidth);
axis([0 P.instantTime -1.5 2.0])
xlabel('$\bf{t(s)}$','interpreter','latex','fontsize',15)
ylabel('$\bf{\dot{\theta}(rad/(s^2))}$','interpreter','latex','fontsize',15)
hold on

filePath=fullfile(currentDir,'SimExpImages');
if(Trajectory == 0)
    end_picture_name='exp_circle.eps';
elseif(Trajectory == 1)
    end_picture_name='exp_rectangle.eps';
elseif(Trajectory == 2)
    end_picture_name='exp_lemniscate.eps';
end

figure(F11)
saveas(gcf,fullfile(filePath,['perturbation_estimation_',end_picture_name]),'epsc')
figure(F12)
saveas(gcf,fullfile(filePath,['speed_estimation_',end_picture_name]),'epsc')