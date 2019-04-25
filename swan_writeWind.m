function swan_writeWind(WS,varargin)

%WRITESWANWIND  Writes wind file(s) for SWAN input.
%
%   writeSwanWind(WS) writes wind file(s) for SWAN input from the wind
%   structure WS.
%   writeSwanWind(WS,NAME) will add the prefix NAME to the written file
%   name(s).
%
%   Input:
%     WS = t: datenum(s)
%           X: X grid
%           Y: Y grid
%           U: U velocities
%           V: V velocities
%        where size(U)=size(V)=[size(X) length(t)]
%   Output:
%     file(s) named 'yyyymmddHHMM.wnd' with 2 header lines for SWAN input
%     file.
%
%   !!!ASSUMPTIONS!!!:
%   1 - EXCEPTION value should be -9999.
%
% writeSwanWind(WS)
%
% DMT 5/06

%%
more off

if nargin==1
    name = '';
else
    name = [cell2mat(varargin),'_'];
end

% make format string
form = repmat('%6.2f ',[1 size(WS.X,2)-1]);
form = [form,'%f\n'];
% exception values?
exc = 0;
WS.U(isnan(WS.U)) = -9999;
WS.V(isnan(WS.V)) = -9999;
if ~isempty(find(WS.U==-9999,1))
    exc = 1;
end

% grid info
alp = atan((WS.Y(1,2)-WS.Y(1,1))/(WS.X(1,2)-WS.X(1,1)))*180/pi;
dx = abs((WS.X(1,2)-WS.X(1,1))/cos(alp*pi/180));
dy = abs((WS.Y(2,1)-WS.Y(1,1))/cos(alp*pi/180));

% do it!
fidl = fopen('windfiles.txt','w');
for ii=1:length(WS.t)
    fid = fopen([name,datestr(WS.t(ii),'yyyymmddHHMM'),'.wnd'],'w');
    fprintf(fidl,'%s\n',[name,datestr(WS.t(ii),'yyyymmddHHMM'),'.wnd']);
    
    if isfield(WS,'regular') || ~isfield(WS,'curvilinear')
        fprintf(fid,['INPgrid WInd REGular ',...
            '%.0f %.0f %.0f %.0f %.0f %.0f %.0f'],...
            [WS.X(1) WS.Y(1) alp size(WS.X,2)-1 size(WS.Y,1)-1 dx dy]);
    else
        fprintf(fid,['INPgrid WInd CURVilinear ',...
            '%.1f %.1f %.0f %.0f'],...
            [0 0 size(WS.X,2)-1 size(WS.Y,1)-1]);
    end
    
    if exc
        fprintf(fid,' EXCeption %.0f',-9999);
    end
    
    if length(WS.t)==1
        fprintf(fid,'\n%s\n',['READinp WInd 1 ''',...
            datestr(WS.t(ii),'yyyymmddHHMM'),'.wnd'' 3 2 FREE']);
    else
        fprintf(fid,' NONSTATionary %s %s %s',...
            [datestr(WS.t(1),'yyyymmdd.HHMMSS'),' ',...
            num2str((WS.t(2)-WS.t(1))*24),' HR ',...
            datestr(WS.t(end),'yyyymmdd.HHMMSS')]);
        fprintf(fid,'\nREADinp WInd 1 SERIES ''windfiles.txt'' 3 2 FREE\n');
    end
    
    fprintf(fid,form,WS.U(:,:,ii)');
    fprintf(fid,form,WS.V(:,:,ii)');
    fclose(fid);
    disp([' wrote ',name,datestr(WS.t(ii),'yyyymmddHHMM'),'.wnd'])
end
fclose(fidl);
