% swan_nestBox - Make nested SWAN grids with same orientation
% 
% fine grid box
xpf = 376125;
ypf = 4625380;
alp = 130;
% xlenf = 1600.; % should be even increment of coarse grid dxc
% ylenf = 600.;  % should be even increment of coarse grid dyc
% % box corners
% fb(1,:) = [xpf,ypf];
% [dxb, dyb] = xycoord( xlenf, alp );
% fb(2,:) = fb(1,:)+[dxb, dyb];
% [dxb, dyb] = xycoord( ylenf, alp-90);
% fb(3,:) = fb(2,:)+[dxb, dyb];
% [dxb, dyb] = xycoord( xlenf, alp+180);
% fb(4,:) = fb(3,:)+[dxb, dyb]
% swan_write_xy('fine_box.dat',fb(:,1), fb(:,2))
% %% make the fine grid
% dxf = 8;
% dyf = 4;
% mxf = xlenf/dxf +1;
% myf = ylenf/dyf +1;
% fprintf(1,'Fine grid is %d x %d, total = %d\n',mxf,myf,mxf*myf);
% xlenf = (mxf-1)*dxf; 
% ylenf = (myf-1)*dyf;
% Gf = swan_buildGrid( 0., 0., -(alp-90), dxf, dyf, mxf, myf );
% Gf.X = Gf.X + xpf;
% Gf.Y = Gf.Y + ypf;
% swan_write_xy('fine_grid.dat',Gf.X,Gf.Y)
%%
% coarse box
% direction to origin of coarse grid...same angle for base line, even
% increment of dxc
[dxo,dyo]= xycoord(14200,alp+180)
xpc = xpf + dxo;
ypc = ypf + dyo;
% alp = 130; % Should use same alp for both grids
xlenc = 33600.;
ylenc = 10800.;
% box corners
bc(1,:) = [xpc,ypc];
[dxb, dyb] = xycoord( xlenc, alp );
bc(2,:) = bc(1,:)+[dxb, dyb];
[dxb, dyb] = xycoord( ylenc, alp-90);
bc(3,:) = bc(2,:)+[dxb, dyb];
[dxb, dyb] = xycoord( xlenc, alp+180);
bc(4,:) = bc(3,:)+[dxb, dyb]
swan_write_xy('coarse_box.dat',bc(:,1), bc(:,2))
%% make the coarse grid
dxc = 100;
dyc = 100;
mxc = xlenc/dxc +1;
myc = ylenc/dyc +1;
fprintf(1,'Coarse grid is %d x %d, total = %d\n',mxc,myc,mxc*myc);
xlenc = (mxc-1)*dxc; 
ylenc = (myc-1)*dyc;
Gc = swan_buildGrid( 0., 0., -(alp-90), dxc, dyc, mxc, myc );
Gc.X = Gc.X + xpc;
Gc.Y = Gc.Y + ypc;
swan_write_xy('coarse_grid.dat',Gc.X,Gc.Y)

%% plot both grids
figure(1);clf
plot(Gc.X,Gc.Y,'.r')
hold on
% plot(Gf.X,Gf.Y,'.b')
% hold on
plot(bc(:,1),bc(:,2),'om')
hold on
plot(fb(:,1),fb(:,2),'oc')
axis equal
axis square
%% After extracting the elevation data for the grids, load them back in
% There are missing data in the grid extracted from Brian's data (ponds?)
% so I used the editor to make ,
a=load('Fine_grid_Z.txt');
zf = reshape(a(:,4),myf,mxf);
%% smooth the grid with a 5x5 kernal
% % I have not used this yet
% K = ones(5);
% K = K./sum(K(:));
% zs = conv2(zf,K,'same');
% mean(zs(:))
% mean(zf(:))
% %% make a fine grid without rotation or translation for simplified modeling
% %GRF = swan_buildGrid( 0., 0., 0., dxf, dyf, mxf, myf )
% F.X = Gf.X;
% F.Y = Gf.Y;
% F.Z = -zf % in SWAN, depths are positive
% swan_writeBot(F,'Sand8x4_v1')
% swan_writeGrid(F,'Sand8x4_v1')
%% After extracting the elevation data for the grids, load them back in
% There are missing data in the grid extracted from Brian's data (ponds?)
% so I used the editor to make ,
a=load('Coarse_grid_Z.txt');
zc = reshape(a(:,4),myc,mxc);
zc(zc==0.00)=7.99; % missing values are zero (lakes, mostly)
%% make a grid without rotation or translation for simplified modeling
% GRC = swan_buildGrid( 0., 0., 0., dxc, dyc, mxc, myc )
C.X = Gc.X;
C.Y = Gc.Y;
C.Z = -zc % in SWAN, depths are positive
swan_writeBot(C, 'Sand200x200_v1_check')
swan_writeGrid(C,'Sand200x200_v1_check')
%%
figure(1);clf
pcolorjw(F.X,F.Y,-F.Z)
caxis([-8 6])
axis equal
colorbar
figure(2);clf
pcolorjw(C.X,C.Y,-C.Z)
caxis([-20 6])
axis equal
colorbar



