% B端:收到指令后反馈1024点的正弦波叠加噪声

clear;clc;close all;

% 构造反馈数据
N = 1024;
t = [1:N]/N*4*pi;
signal = sin(t) + 0.05*rand(1,N);
figure;
plot(t,signal);
grid on;
title('signal on the end of B.')

% 构造客户端tcpip对象
tcpipClient = tcpip('192.168.123.30',5001,...
    'NetworkRole','Client');%设置对象属性,A端的IP为192.168.123.30
set(tcpipClient,'OutputBufferSize',8*N); %设置缓存长度
set(tcpipClient,'InputBufferSize',1024); %设置缓存长度
set(tcpipClient,'Timeout',60); %设置连接时间为1分钟

%打开连接对象
fopen(tcpipClient);

% 等待接收命令
while(1)
    nBytes = get(tcpipClient,'BytesAvailable');
    if nBytes>0
        break;
    end
end

% 接收命令
receivedInstruction = fread(tcpipClient,nBytes,'int8');
disp(strcat('received instruction is: ',char(receivedInstruction')));

% 反馈数据
fwrite(tcpipClient,signal,'double');

% 关闭和删除连接对象
fclose(tcpipClient);
delete(tcpipClient);
