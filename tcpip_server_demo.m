% A��:��������,������B�˷���
% A��IPΪ192.168.123.30, B��IPΪ192.168.123.10

clear;clc;close all;

% �����������tcpip����
tcpipServer = tcpip('0.0.0.0',5001,'NetWorkRole','Server');
set(tcpipServer,'Timeout',10);
N = 1024;
set(tcpipServer,'InputBufferSize',8*N);
set(tcpipServer,'OutputBufferSize',1024);

% �����Ӷ���
fopen(tcpipServer);

% ����ָ��
instruction = 'Please send back a signal.';
fwrite(tcpipServer,instruction,'int8');
disp('Instruction sending succeeds.');
numSent = get(tcpipServer,'valuesSent');
disp(strcat('Bytes of instruction is :',num2str(numSent)));

% �ȴ���������
while(1)
    nBytes = get(tcpipServer,'BytesAvailable');
    if nBytes > 0
        break;
    end
end

% ��������
recvRaw = fread(tcpipServer,nBytes/8,'double');

% ���ƽ�������ͼ��
figure;
plot(recvRaw);grid on;
title('received signal from B');

% �رպ�ɾ�����Ӷ���
fclose(tcpipServer);
delete(tcpipServer);
