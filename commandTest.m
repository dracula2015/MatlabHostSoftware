% s = serial('COM19','BaudRate',115200,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none','ReadAsyncMode','continuous','ByteOrder','littleEndian');
% fopen(s);
a=10;
controlEffect = [a a a];
voltage = typecast(single(controlEffect),'uint8');
for i=1:6
    if voltage(i)==117 || voltage(i)==115 || voltage(i)==103
        voltage(i)=voltage(i)+1;
    end
end
voltage = typecast(single(controlEffect),'uint8');
% fwrite(s,'u');
fwrite(s,[117 voltage],'uint8');
fwrite(s,'g');
% fwrite(s,'s');