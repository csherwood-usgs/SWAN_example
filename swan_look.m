% swan_look.m - read stationary wave model run and make plots

% load SWAN output saved in .mat files
load xp
load yp
load depth
load hsig
load fric
load watlev
load wdir
load rtp
load qb
load dissip
%% Note about coordinate rotation
% In test3, I switched to curvilinear coordinates, with xp and yp being
% real UTM coordinates. However, for plotting, it is easier to use rotated
% coordinates translated to an orgin with 0,0. That is B.X and B.Y in the
% swan_build_grid.m. If you plot there, you have to rotate the direction
% vectors by (90-128)...the amount of rotation specified as alp.

% make a vector from wave height and direction (switch directin by 180 so
% arrows point in the direction of wave propagation)
[u,v]=xycoord(Hsig,Dir+180.);

% subsample the vector arrays and associated coordinate locations
ii = 10;
us = u(1:ii:end,1:ii:end);
vs = v(1:ii:end,1:ii:end);
xs = Xp(1:ii:end,1:ii:end);
ys = Yp(1:ii:end,1:ii:end);

% make some quick and ugly plots
% locations of wave buoys
CDIP = [389684.,4632876.]
USGS = [377256.1589, 4625229.2030]

figure(1); clf

subplot(2,2,1)
pcolorjw(Xp,Yp,-Depth)
hold on
plot(CDIP(:,1),CDIP(:,2),'or')
plot(USGS(:,1),USGS(:,2),'or')
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
colorbar
title('Depth (m)')

subplot(2,2,2)
pcolorjw(Xp,Yp,Hsig)
hold on
h=quiver(xs,ys,us,vs,'-k');
set(h,'color',[.3 .3 .3])
plot(CDIP(:,1),CDIP(:,2),'or')
plot(USGS(:,1),USGS(:,2),'or')
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
colorbar
title('Significant Wave Height (m)')

subplot(2,2,3)
pcolorjw(Xp,Yp,Qb)
hold on
plot(CDIP(:,1),CDIP(:,2),'or')
plot(USGS(:,1),USGS(:,2),'or')
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
colorbar
title('Fraction Waves Breaking')

subplot(2,2,4)
pcolorjw(Xp,Yp,Dissip)
hold on
plot(CDIP(:,1),CDIP(:,2),'or')
plot(USGS(:,1),USGS(:,2),'or')
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
colorbar
title('Wave Dissipation')