function [x,y] = xycoord(r, az)
% XYCOORD  Polar to rectangular coordinate conversion, geographic convention
%
% function [u,v] = xycoord(speed, sdir)
% function [x,y] = xycoord(r, az)
%
% Converts from speed, azimuth polar coordinates (0-360 degrees)
% to rectangular coordinates. (Note: use of dir for direction conflicts
% with DOS/MATLAB dir command!)
%
%  See pcoord to do the u,v to speed and direction conversion

% Chris Sherwood, USGS
% March 17, 1999

rd = 57.29577950;
x = r .* sin(az/rd);
y = r .* cos(az/rd);
return

