% B��:�յ�ָ�����1024������Ҳ���������

clear;clc;close all;

% ���췴������
N = 1024;
t = [1:N]/N*4*pi;
signal = sin(t) + 0.05*rand(1,N);
figure;
plot(t,signal);
grid on;
title('signal on the end of B.')

% ����ͻ���tcpip����
tcpipClient = tcpip('192.168.123.30',5001,...
    'NetworkRole','Client');%���ö�������,A�˵�IPΪ192.168.123.30
set(tcpipClient,'OutputBufferSize',8*N); %���û��泤��
set(tcpipClient,'InputBufferSize',1024); %���û��泤��
set(tcpipClient,'Timeout',60); %��������ʱ��Ϊ1����

%�����Ӷ���
fopen(tcpipClient);

% �ȴ���������
while(1)
    nBytes = get(tcpipClient,'BytesAvailable');
    if nBytes>0
        break;
    end
end

% ��������
receivedInstruction = fread(tcpipClient,nBytes,'int8');
disp(strcat('received instruction is: ',char(receivedInstruction')));

% ��������
fwrite(tcpipClient,signal,'double');

% �رպ�ɾ�����Ӷ���
fclose(tcpipClient);
delete(tcpipClient);
