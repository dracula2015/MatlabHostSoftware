function varargout = UserInterface2_0(varargin)
%UserInterface 此处显示有关此函数的摘要
%   此处显示详细说明
%   varargin{1}：mode
%   varargin{2}：trajectory
%   varargin{3}：method
clc
clear all functions
global execFunctionHandle startFlag stopFlag pauseFlag execFunction initialAttitude comPortMotiveState theClient initFinished s AttitudeX AttitudeY AttitudeTheta;
global RTX RTY RTTheta ESTX ESTY ESTTheta QEIX QEIY QEITheta OpticalX OpticalY OpticalTheta UI initialListener expListener TIME P START PAUSE STOP INITIALIZE RESET controlListener m
global netClient netServer;
initFinished = true;
comPortMotiveState = false;
initialAttitude=[0;0;0];
stopFlag = false;
pauseFlag = false;
startFlag = false;
P.Trajectory = 1;
P.Method = 0;
P.sendCommand = 0;
% UI=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off','color','default','position',[100 458 560 520]);
UI=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off','color','default','position',[11 453 930 520]);
execFunction = 'simulation';
if strcmp(execFunction,'experiment')
    execFunctionHandle = @expMainFunction2_0;
elseif strcmp(execFunction,'simulation')
    execFunctionHandle = @simMainFunction;
end
if strcmp(execFunction,'experiment')
    if ~comPortMotiveState
        comPortMotiveInitialization
    end
end
uicontrol('style','text','fontsize',20,'string','InitialPos','Position',[110 430 120 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Optitrack','Position',[260 430 120 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','QEI','Position',[430 430 100 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','OpticalFlow','Position',[600 430 100 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Estimated','Position',[760 430 130 60],'backgroundcolor','default')

uicontrol('style','text','fontsize',20,'string','X','Position',[20 350 100 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Y','Position',[20 270 100 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Theta','Position',[20 190 100 60],'backgroundcolor','default')
AttitudeX = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[125 360 80 60]);
AttitudeY = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[125 280 80 60]);
AttitudeTheta = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[125 200 80 60]);

RTX = uicontrol('style','text','fontsize',20,'string',0,'Position',[230 350 160 60],'backgroundcolor','default');
RTY = uicontrol('style','text','fontsize',20,'string',0,'Position',[230 270 160 60],'backgroundcolor','default');
RTTheta = uicontrol('style','text','fontsize',20,'string',0,'Position',[230 190 160 60],'backgroundcolor','default');

QEIX = uicontrol('style','text','fontsize',20,'string',0,'Position',[400 350 160 60],'backgroundcolor','default');
QEIY = uicontrol('style','text','fontsize',20,'string',0,'Position',[400 270 160 60],'backgroundcolor','default');
QEITheta = uicontrol('style','text','fontsize',20,'string',0,'Position',[400 190 160 60],'backgroundcolor','default');

OpticalX = uicontrol('style','text','fontsize',20,'string',0,'Position',[570 350 160 60],'backgroundcolor','default');
OpticalY = uicontrol('style','text','fontsize',20,'string',0,'Position',[570 270 160 60],'backgroundcolor','default');
OpticalTheta = uicontrol('style','text','fontsize',20,'string',0,'Position',[570 190 160 60],'backgroundcolor','default');

ESTX = uicontrol('style','text','fontsize',20,'string',0,'Position',[740 350 160 60],'backgroundcolor','default');
ESTY = uicontrol('style','text','fontsize',20,'string',0,'Position',[740 270 160 60],'backgroundcolor','default');
ESTTheta = uicontrol('style','text','fontsize',20,'string',0,'Position',[740 190 160 60],'backgroundcolor','default');

uicontrol('Style','text','fontsize',20,'String','Running time:','Position',[520 95 270 60],'backgroundcolor','default')
TIME = uicontrol('Style','text','fontsize',20,'String','0','Position',[750 95 150 60],'backgroundcolor','default');

uicontrol('Style','popup','fontsize',20,'String',{'Mode','Simulation','Experiment'},'Position',[20 80 160 80],'Callback',@switchFunction)
uicontrol('Style','popup','fontsize',20,'String',{'Trajectory','Circle','Rectangle','Lemniscate'},'Position',[205 80 160 80],'Callback',@trajectoryFunction)
uicontrol('Style','popup','fontsize',20,'String',{'Method','PD','NPD','MFAC'},'Position',[390 80 160 80],'Callback',@methodFunction)

START = uicontrol('Style','pushbutton','fontsize',20,'String','Start','Position',[20 30 150 60],'Callback',@startFunction);
PAUSE = uicontrol('Style','pushbutton','fontsize',20,'String','Pause','Position',[205 30 150 60],'Callback',@pauseFunction);
STOP = uicontrol('Style','pushbutton','fontsize',20,'String','Stop','Position',[390 30 150 60],'Callback',@stopFunction);
% STOP = uicontrol('Style','pushbutton','fontsize',20,'String','Stop','Position',[390 30 150 60]);
INITIALIZE = uicontrol('Style','pushbutton','fontsize',20,'String','Initialize','Position',[575 30 150 60],'Callback',@(source,eventdata)initialize(source,eventdata));
RESET = uicontrol('Style','pushbutton','fontsize',20,'String','Reset','Position',[760 30 150 60],'Callback',@(source,eventdata)resetFunction(source,eventdata));
% if nargin>=1
%     if(strcmp(varargin{1},'experiment') || strcmp(varargin{1},'exp'))
%         if ~comPortMotiveState
%             comPortMotiveInitialization
%         end
%         execFunctionHandle = @expMainFunction2_0;
%     else
%     end
% end
% if nargin>=2
%     if varargin{2}==0
%         P.Trajectory = 0;
%     elseif varargin{2}==1
%         P.Trajectory = 1;
%     elseif varargin{2}==2
%         P.Trajectory = 2;
%     end
% end
% if nargin>=3
%     if varargin{3}==0
%         P.Method = 0;
%     elseif varargin{3}==1
%         P.Method = 1;
%     elseif varargin{3}==2
%         P.Method = 2;
%     end
% end
connector on;
disp('Connector on');
% m = mobiledev;
% m.SampleRate = 100;

%% Acceleration
% m.AccelerationSensorEnabled = 1;
% m.Acceleration;
%% Magnetic Field
% m.MagneticSensorEnabled = 1;
% m.MagneticField;
%% Orientation 
% m.OrientationSensorEnabled = 1;
% m.Orientation;
%% Angular Velocity
% m.AngularVelocitySensorEnabled = 1;
% m.AngularVelocity;
%% Position
% m.PositionSensorEnabled = 1;
% m.Altitude;
% m.Longitude;
% m.Latitude;
% m.HorizontalAccuracy;
% m.Speed;
%% Begin Transmitting
m.Logging = 1;
% m.InitialTimestamp;
% m.accellog;
% m.magfieldlog;
% m.orientlog;
% m.angvellog;
% m.poslog;

uiwait(UI);
% while(1)
%     drawnow
% end
%% cleanup
if(~isempty(expListener))
    delete(expListener);
end
if(~isempty(initialListener))
    delete(initialListener);
end
if comPortMotiveState
    theClient.Uninitialize();
%     fclose(s);
%     delete(s);
%     clear('s');
%     
%     fclose(netClient);
%     delete(netClient);
%     clear('netClient');
% %     delete(netServer);
% %     fclose(netServer);
% %     clear('netServer');
end

if ~isempty(s)
    fclose(s);
    delete(s);
    clear('s');
end

if~isempty(netClient)
    fclose(netClient);
    delete(netClient);
    clear('netClient');
end
% if~isempty(netServer)
%     delete(netServer);
%     fclose(netServer);
%     clear('netServer');
% end
% m.Logging = 0;
% m.AccelerationSensorEnabled = 0;
% m.MagneticSensorEnabled = 0;
% m.OrientationSensorEnabled = 0;
% m.AngularVelocitySensorEnabled = 0;
% m.PositionSensorEnabled = 0;

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
clear functions
clear m
end

function initialize( source, eventdata)
%InitialAttitude 此处显示有关此函数的摘要
%   此处显示详细说明
global initialAttitude initFinished P AttitudeX AttitudeY AttitudeTheta theClient s startFlag pauseFlag stopFlag MFAC initialListener;
if (~startFlag) && (initFinished)
%     clear P functions;
    clear UpdateInstruction_KalmanFilter;
    P.thetaCount = 0;
    P.thetaTemp = 0;
    P.thetaTempPre = 0;
    stopFlag = false;
    pauseFlag = false;
    initFinished = false;
    Parameters;
    P.thetaCount = 0;
    P.thetaTemp = 0;
    P.thetaTempPre = 0;
    initialAttitude(1) = str2double(get(AttitudeX,'string'));
    initialAttitude(2) = str2double(get(AttitudeY,'string'));
    initialAttitude(3) = str2double(get(AttitudeTheta,'string'));
    initialListener = addlistener(theClient,'OnFrameReady2',@(src,event)FrameReadyCallback(src,event));
    display('[NatNet] FrameReady Listener added.');
    %     fwrite(s,'s');
    %     if(~isempty(ls))
    %         delete(ls);
    %     end
    %     disp('initialization finished')
    %     initFinished = true;
end
end

function comPortMotiveInitialization
global comPortMotiveState s netClient netServer;
%% COM Port Initialization
% if strcmp('win64',computer('arch'))
%     s = serial('COM19','BaudRate',115200,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none','ReadAsyncMode','continuous','ByteOrder','littleEndian');
% elseif strcmp('glnxa64',computer('arch'))
%     s = serial('/dev/ttyUSB0','BaudRate',115200,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none','ReadAsyncMode','continuous','ByteOrder','littleEndian');
% end
% s.BytesAvailableFcn = @QEIData;
% fopen(s);
%% TCP/IP Initialization
netClient = tcpip('10.10.100.254',8899,'NetworkRole','client');
% netServer = tcpip('0.0.0.0',8888,'NetworkRole','server');
fopen(netClient);

% echotcpip('off');
% echotcpip('on',8888);
% netServer = tcpip('192.168.1.3',8888);
% fopen('netServer');
%% Motive Initialization
global frameRate theClient;
% global initialFrameTime;
% global instantTime;
lastFrameTime = -1.0;
lastFrameID = -1.0;

% Add NatNet .NET assembly so that Matlab can access its methods, delegates, etc.
% Note : The NatNetML.DLL assembly depends on NatNet.dll, so make sure they
% are both in the same folder and/or path if you move them.
display('[NatNet] Creating Client.')
curDir = pwd;
dllPath = fullfile(curDir,'NatNetSDK','lib','x64','NatNetML.dll');
assemblyInfo = NET.addAssembly(dllPath);

% Create an instance of a NatNet client
theClient = NatNetML.NatNetClientML(0); % Input = iConnectionType: 0 = Multicast, 1 = Unicast
version = theClient.NatNetVersion();

fprintf( '[NatNet] Client Version : %d.%d.%d.%d\n', version(1), version(2), version(3), version(4) );

% Connect to an OptiTrack server (e.g. Motive)
display('[NatNet] Connecting to OptiTrack Server.')

% Connect to another computer's stream.
% LocalIP = char('10.0.1.1'); % Enter your local IP address
% ServerIP = char('10.0.1.200'); % Enter the server's IP address
% flg = theClient.Initialize(LocalIP, ServerIP); % Flg = returnCode: 0 = Success

% Connect to a local stream.
HostIP = char('127.0.0.1');
LocalIP = char('192.168.1.5');
ServerIP = char('192.168.1.4');
% ServerIP = char('62379971.800.si');
% flg = theClient.Initialize(HostIP, HostIP); % Flg = returnCode: 0 = Success
flg = theClient.Initialize(LocalIP, ServerIP); % Flg = returnCode: 0 = Success

if (flg == 0)
    display('[NatNet] Initialization Succeeded')
else
    display('[NatNet] Initialization Failed')
end

% print out a list of the active tracking Models in Motive
GetDataDescriptions(theClient)

% Test - send command/request to Motive
[byteArray, retCode] = theClient.SendMessageAndWait('FrameRate');
if(retCode ==0)
    byteArray = uint8(byteArray);
    frameRate = typecast(byteArray,'single')
end
comPortMotiveState = true;
end

function switchFunction(source,eventdata)
%switchFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global execFunctionHandle execFunction stopFlag comPortMotiveState;
stopFlag = false;
if strcmp(source.String(source.Value),'Simulation')
    execFunctionHandle = @simMainFunction;
    execFunction = 'Simulation';
    disp('Simulation')
elseif strcmp(source.String(source.Value),'Experiment')
    if ~comPortMotiveState
        comPortMotiveInitialization
    end
    execFunctionHandle = @expMainFunction2_0;
    execFunction = 'Experiment';
    disp('Experiment')
else disp('Choose to simulate or experiment')
end
% drawnow
end

function trajectoryFunction(source,eventdata)
%switchFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global stopFlag P;
% stopFlag = false;
if strcmp(source.String(source.Value),'Circle')
    P.Trajectory = 0;
    disp('Trajectory: circle')
elseif strcmp(source.String(source.Value),'Rectangle')
    P.Trajectory = 1;
    disp('Trajectory: rectangle')
elseif strcmp(source.String(source.Value),'Lemniscate')
    P.Trajectory = 2;
    disp('Trajectory: lemniscate')
else disp('Choose trajectory')
end
% drawnow
end

function methodFunction(source,eventdata)
%switchFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global stopFlag P;
% stopFlag = false;
if strcmp(source.String(source.Value),'PD')
    P.Method = 0;
    disp('Method: PD')
elseif strcmp(source.String(source.Value),'NPD')
    P.Method = 1;
    disp('Method: NPD')
elseif strcmp(source.String(source.Value),'MFAC')
    P.Method = 2;
    disp('Method: MFAC')
else disp('Choose control method')
end
% drawnow
end

function startFunction(source,eventdata)
%startFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global startFlag stopFlag pauseFlag execFunctionHandle initFinished commandTimer P;
if ~startFlag && initFinished
    clear P functions;
    startFlag = true;
    execFunctionHandle();
%     commandTimer = timer('TimerFcn',@timerFunc, 'Period', 0.01, 'BusyMode', 'drop', 'ExecutionMode', 'fixedRate', 'TasksToExecute', 4000);	
%     start(commandTimer)
end
end

function stopFunction(source,eventdata)
%stopFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global s execFunction startFlag stopFlag pauseFlag netClient;
pauseFlag = false;
stopFlag = true;
if strcmp(execFunction,'Simulation')
    disp('Stop simulation');
elseif strcmp(execFunction,'Experiment')
%         if ~startFlag
%             fwrite(s,'s');
%         end
%     fwrite(s,'s');
    fwrite(netClient,'s');
    disp('Stop experiment');
end
end

function pauseFunction(source,eventdata)
%pauseFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global s startFlag pauseFlag execFunction PAUSE netClient
pauseFlag = ~pauseFlag;
if strcmp(execFunction,'Experiment')
    if pauseFlag
        set(PAUSE,'string','Continue');
%         fwrite(s,'s');
        fwrite(netClient,'s');
    else
        set(PAUSE,'string','Pause');
    end
    drawnow
end
end

function resetFunction(source,eventdata)
%pauseFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global s netClient
% fwrite(netClient,'u');
% fwrite(s,[117 0 0 0 0 0 0],'uint8');
fwrite(netClient,[117 0 0 0 0 0 0],'uint8');

end

function QEIData(source,eventdata)
global s P
qeispeed = fread(s,s.BytesAvailable,'uint8');
P.QEIspeed = typecast(uint8(qeispeed),'single');
end

function timerFunc(source,eventdata)
global s netClient P
% fwrite(s,P.sendCommand,'uint8');
fwrite(netClient,P.sendCommand,'uint8');
% P.sendCommand = P.sendCommand+1;
P.sendCommand;
end
