% swan_makeGrid.m - Make nested SWAN grids with same orientation
% 
% This goes through the steps of defining the grid boundaries, setting
% the spacing, and making SWAN grids. One peice is missing...interpolating
% bathy onto the grid points.
%
% This assumes everything is in UTM. If you have data in lat/lon, you will
% need to convert things to UTM for making the grid coordinates, but then
% convert to lat/lon for the interpolation step.
%
% There is some legacy code here...I was making a fine grid and a coarse
% grid, thus xp*f* and xp*c*. This deals with the coarse grid.
% Lower left corner of a fine grid in Easting, Norting (NAD83,
% UTM Zone 19N [m]
xpf = 376125;
ypf = 4625380;

% azimuth (geographic convention) of x axis in model grid
alp = 130; % i.e., approx. east-southeast

% Sorry...next three lines are left over. I want this grid to start at a
% point 142000 meters away, along the x-axis, but to the left.
[dxo,dyo]= xycoord(14200,alp+180) % calculate offset to point
% Add offset. Now xpc and ypc are the origins of my grid. You can start
% here for a different grid.
xpc = xpf + dxo; 
ypc = ypf + dyo;
% Length of the axes (size of the model domain
xlenc = 33600.;
ylenc = 10800.;
% Corners of the model grid
bc(1,:) = [xpc,ypc];
[dxb, dyb] = xycoord( xlenc, alp );
bc(2,:) = bc(1,:)+[dxb, dyb];
[dxb, dyb] = xycoord( ylenc, alp-90);
bc(3,:) = bc(2,:)+[dxb, dyb];
[dxb, dyb] = xycoord( xlenc, alp+180);
bc(4,:) = bc(3,:)+[dxb, dyb]

% Write a .csv file with grid corners (for checking in GIS software)
swan_write_xy('coarse_box.dat',bc(:,1), bc(:,2))
%% Make the coarse grid
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

%% Plot the corners and grid points grids
% your might have to zoom in to see these dots
figure(1);clf
plot(Gc.X,Gc.Y,'.b')
hold on
plot(bc(:,1),bc(:,2),'or')
axis equal
axis square
%% Magic happens
% OK, this is the part where you will have to improvise.
% What I did was:
%   * loaded the ascii version of the grid ('coarse_grid.dat') into my GIS
%   * interpolated the depths onto those points and saved as
%     'Coarse_grid_Z.txt'
%   * Now I want to load those values into Matlab, as array zc
a=load('Coarse_grid_Z.txt');
zc = reshape(a(:,4),myc,mxc);

% There are missing data in the grid filled with zeros...these are ponds on land,
% so I want to give them an elevation.
zc(zc==0.00)=7.99; % missing values are zero (lakes, mostly)
%% You might need to smooth the grid, maybe with a 5x5 kernal
% % I have not used this yet
% K = ones(5);
% K = K./sum(K(:));
% zcs = conv2(zc,K,'same');
% mean(zcs(:))
% mean(zc(:))
% Now, of course, you want to use zcs in the next step, instead of zc
%% make a grid without rotation or translation for simplified modeling
% GRC = swan_buildGrid( 0., 0., 0., dxc, dyc, mxc, myc )
C.X = Gc.X;
C.Y = Gc.Y;
C.Z = -zc % in SWAN, depths are positive
% I changed the name to prevent overwriting the files I know worked
swan_writeBot(C, 'Sand200x200_v1_check')
swan_writeGrid(C,'Sand200x200_v1_check')
%% Plot the bathymetry to check
figure(2);clf
pcolorjw(C.X,C.Y,-C.Z)
caxis([-20 6])
axis equal
colorbar



