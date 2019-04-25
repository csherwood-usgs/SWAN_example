function swan_write_xy(fn, X, Y)
% swan_write_xy(fn, X, Y)
% Write a .csv file in fn of x, y locations from X and Y arrays.
%
% csherwood@usgs.gov
X = X(:);
Y = Y(:);
fid = fopen( fn, 'w');
for i=1:length(X)
    fprintf(fid,'%10.2f, %10.2f\n',X(i),Y(i));
end
i=fclose(fid);
if(i~=0),disp('Problem closing file.'),else,disp([fn,' written.']),end
