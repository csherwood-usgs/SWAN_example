function out = orthog_trans(x,y,theta,xo,yo)

%   [xn,yn] = orthog_trans(x,y,theta)
%
% orthogonal transformation
%
%  [x,y] = ( [xn,yn] - X ) * A
%
% input:  x,y = point in original coordinate system (in COLUMNS)
%         theta = angle (in degrees)  of rotation of new coord system 
%                 from the old system (between 0 & 180, degrees from true N).
%	  xo,yo = origin of new coordinate system (or the TRANSLATION)
%

if exist('xo','var')==0,xo=0;, end
if exist('yo','var')==0,yo=0;, end

x = x(:); y = y(:);

theta = theta*pi/180;

A = [cos(theta),sin(theta);-sin(theta),cos(theta)];

X = nan*ones(length(x),2);

X(:,1)= (x - xo);
X(:,2)= (y - yo);

% ROTATION
%%%%
out = X*A;
