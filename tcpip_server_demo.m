% A端:发送命令,并接收B端反馈
% A端IP为192.168.123.30, B端IP为192.168.123.10

clear;clc;close all;

% 构造服务器端tcpip对象
tcpipServer = tcpip('0.0.0.0',5001,'NetWorkRole','Server');
set(tcpipServer,'Timeout',10);
N = 1024;
set(tcpipServer,'InputBufferSize',8*N);
set(tcpipServer,'OutputBufferSize',1024);

% 打开连接对象
fopen(tcpipServer);

% 发送指令
instruction = 'Please send back a signal.';
fwrite(tcpipServer,instruction,'int8');
disp('Instruction sending succeeds.');
numSent = get(tcpipServer,'valuesSent');
disp(strcat('Bytes of instruction is :',num2str(numSent)));

% 等待接收数据
while(1)
    nBytes = get(tcpipServer,'BytesAvailable');
    if nBytes > 0
        break;
    end
end

% 接收数据
recvRaw = fread(tcpipServer,nBytes/8,'double');

% 绘制接收数据图像
figure;
plot(recvRaw);grid on;
title('received signal from B');

% 关闭和删除连接对象
fclose(tcpipServer);
delete(tcpipServer);
