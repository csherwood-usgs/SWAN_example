function swan_writeBot(B,name)

%WRITESWANBOT  Writes a bathymetry (bottom) file for SWAN.
%
%   writeSwanBot(B,name) writes a bathymetry file for SWAN input from
%   from the gridded data in the bathymetry structure B with name NAME.bot.
%
%   Input:
%     B = X: X grid
%         Y: Y grid
%         Z: depth grid
%     NAME = 'txt';
%   Output:
%     file named NAME.bot with 2 header lines for SWAN input file.
%
%   !!!ASSUMPTIONS!!!:
%   1 - EXCEPTION value should be -9999.
%
% writeSwanBot(B,NAME)
%
% DMT 4/05
%%
form = repmat('%f ',[1 size(B.X,2)-1]);
form = [form,'%f\n'];

exc = 0;
B.Z(isnan(B.Z)) = -9999;
if ~isempty(find(B.Z==-9999,1))
   exc = 1;
end

alp = atan((B.Y(1,2)-B.Y(1,1))/(B.X(1,2)-B.X(1,1)))*180/pi;
dx = abs((B.X(1,2)-B.X(1,1))/cos(alp*pi/180));
if alp~=0
   dy = abs((B.X(2,1)-B.X(1,1))/sin(alp*pi/180));
else
   dy = (B.Y(2,1)-B.Y(1,1));
end

fid = fopen([name,'.bot'],'w');

if isfield(B,'regular') || ~isfield(B,'curvilinear')
   fprintf(fid,'INPgrid BOTtom REGular %.6f %.6f %.6f %.0f %.0f %.6f %.6f',...
      [B.X(1) B.Y(1) alp size(B.X,2)-1 size(B.Y,1)-1 dx dy]);
else
   fprintf(fid,'INPgrid BOTtom CURVilinear %.1f %.1f %.0f %.0f',...
      [0 0 size(B.X,2)-1 size(B.Y,1)-1]);
end

if exc
   fprintf(fid,' EXCeption %.0f',-9999);
end

fprintf(fid,'\n%s\n',['READinp BOTtom 1 ''',name,'.bot'' 3 2 FREE']);
fprintf(fid,form,B.Z');
fclose(fid);
disp([' wrote ',name,'.bot'])