function [r,az] = pcoord(x,y)
% PCOORD  Converts rectangular to polar coordinate, geographic convention
%
% function [speed, sdir] = pcoord(u,v) or...
% function [r, az]       = pcoord(x,y)
%
% Converts from rectangular to polar coordinates (0 - 360 degrees)
% x and y must be column vectors
%
%  See xycoord to do the conversion from speed and direction to u,v
%
% Chris Sherwood, USGS
% March 30, 1999

% calculate magnitude
r  = sqrt( x.^2 + y.^2 );

% determine quadrant
q1 = (x> 0.  & y >= 0.);
q2 = (x< 0.  & y >= 0.);
q3 = (x< 0.  & y <  0.);
q4 = (x> 0.  & y <  0.);

% find wierd ones
north = find(x == 0. & y > 0.)';
south = find(x == 0. & y < 0.)';
zip   = find(x == 0. & y == 0.)';

% prevent divide by zero - replace x = 0 with x = eps
small = find(x == 0.);
xs = x;
xs(small) = ones(size(small))*eps;

% calculate angle (relative to east)
rad = 180/pi;
ang = rad*atan( y ./ xs );

% correct for quadrant
az  = q1 .* ( 90 - ang) + ...
      q2 .* ( 270 - ang) + ...
      q3 .* ( 270 - ang) + ...
      q4 .* ( 90 - ang );

% correct for wierd ones
if ( length(north) > 0 )
   az(north) = ones(length(north),1)*360.;
end
if ( length(south) > 0 )
   az(south) = ones(length(south),1)*180;
end
if ( length(zip) > 0 )
   az(zip)   = zeros(length(zip),1);
end

if( any(az>=360.) ),
  i360 = find(az>=360.);
  az(i360)=az(i360)-360.;
end






