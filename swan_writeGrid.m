function swan_writeGrid(G,name)

%%
form = repmat('%f ',[1 size(G.X,2)-1]);
form = [form,'%f\n'];

excx = 0;
excy = 0;
G.X(isnan(G.X)) = -9999;
if ~isempty(find(G.X==-9999,1))
   excx = 1;
end
G.Y(isnan(G.Y)) = -9999;
if ~isempty(find(G.Y==-9999,1))
   excy = 1;
end

fid = fopen([name,'.cgd'],'w');
fprintf(fid,'CGRID CURV %.0f %.0f',[size(G.X,2)-1 size(G.Y,1)-1]);
if excx || excy
   fprintf(fid,' EXC %.0f %.0f',[-9999 -9999]);
end
fprintf(fid,'\n%s\n',['READ COOR 1 ''',name,'.cgd'' 3 2 1 FREE']);
fprintf(fid,'%s\n','x-coordinates');
fprintf(fid,form,G.X');
fprintf(fid,'%s\n','y-coordinates');
fprintf(fid,form,G.Y');
fclose(fid);
