figure
% colormap(pink)
% % bone ��ɫ���ɫ
% % cool ���Ũ��ɫ
% % copper ��ͭɫ��Ũ��ɫ
% % flag ������ڽ���
% % gray �Ҷ�
% % hot �ں�ư�
% % hsv ����ɫ
% % jet ��ͷ��β�ı���ɫ
% % pink �ۺ�ɫ
% % prism ����ɫ
beta = 1;
alpha = 1;
eq = -20:0.1:20
edq = -20:0.1:20
[xx,yy] = meshgrid(eq,edq);
% zz = 0 + 30./(1 + beta * exp(alpha * sign(yy) .* xx));
zz = 0 + 30./(1 + beta * exp(alpha * (-yy) .* xx));
% surf(xx,yy,zz)
% plot3(xx,yy,zz)
% grid on
% h=mesh(xx,yy,zz)
% c1 = get(h,'FaceColor')
% plot(eq,1./(1+exp(eq)))
f=@(xx,yy)(0 + 30./(1 + beta * exp(alpha * (-yy) .* xx)));
ezmesh(f,45)

colormap([0,0,1])