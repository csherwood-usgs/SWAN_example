function G = swan_buildGrid(xp,yp,alp,dx,dy,mxc,myc)

%BUILDGRID  Build a rectangular grid.
%
%   G = buildGrid(XP,YP,ALP,DX,DY,MX,MY) builds a rectangular grid based on
%   the INPUTS:
%     XP: x grid origin
%     YP: y grid origin
%     ALP: degrees rotation of x-axis
%     DX: x-direction grid spacing
%     DY: y-direction grid spacing
%     MX: number of meshes in x-direction
%     MY: number of meshes in y-direction
%
%   OUTPUT:
%     G = X: x-grid
%         Y: y-grid
%         xc: x-coords of corners
%         yc: y-coords of corners
%
% G = buildGrid(xp,yp,alp,dx,dy,mx,my);
%
% DMT 6/06

%%
xlen = (mxc-1)*dx; 
ylen = (myc-1)*dy;

% x = xp:dx*cosd(alp):xp+xlen;
% y = yp:dy*sind(alp):yp+ylen;
% 
% [X,Y] = meshgrid(x,y);
% 
% %xc = [X(1,1) X(1,end) X(end,end) X(end,1) X(1,1)];
% %yc = [Y(1,1) Y(1,end) Y(end,end) Y(end,1) Y(1,1)];
% 
% G = struct('X',X,'Y',Y,'x',x,'y',y,'xc',xc,'yc',yc);

%%
x = xp:dx:xp+xlen;
y = yp:dy:yp+ylen;
[X,Y] = meshgrid(x,y);
x = x - x(1);
y = y - y(1);

if alp~=0
   out = orthog_trans(X,Y,alp,xp,yp);
   X = reshape(out(:,1)+xp,size(X));
   Y = reshape(out(:,2)+yp,size(Y));
end

xc = [X(1,1) X(1,end) X(end,end) X(end,1) X(1,1)];
yc = [Y(1,1) Y(1,end) Y(end,end) Y(end,1) Y(1,1)];

G = struct('X',X,'Y',Y,'x',x,'y',y,'xc',xc,'yc',yc,'alp',alp);

