figure
% colormap(pink)
% % bone 蓝色凋灰色
% % cool 青红浓淡色
% % copper 青铜色调浓淡色
% % flag 红白兰黑交错
% % gray 灰度
% % hot 黑红黄白
% % hsv 饱和色
% % jet 蓝头红尾的饱和色
% % pink 粉红色
% % prism 光谱色
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