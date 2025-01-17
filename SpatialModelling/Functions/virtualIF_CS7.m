function h = virtualIF_CS7(Output,OBJ1,tissues,fig);

h = figure(fig)

if strcmp(tissues,'all')==1
    tissues = {'EmDisc','Am','ExMes','Tb','SYS','Stalk'}
end

if sum(strcmp(tissues,'Am'))~=0
f1 = patch('Faces',OBJ1.objects(16).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m1,'FaceColor','interp','LineStyle','none');
end

if sum(strcmp(tissues,'EmDisc'))~=0
f1 = patch('Faces',OBJ1.objects(20).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m2,'FaceColor','interp','LineStyle','none');
end

if sum(strcmp(tissues,'Stalk'))~=0
f1 = patch('Faces',OBJ1.objects(30).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m2,'FaceColor','interp','LineStyle','none');
end

if sum(strcmp(tissues,'SYS'))~=0
f3 = patch('Faces',OBJ1.objects(8).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m5,'FaceColor','interp','LineStyle','none');
end

if sum(strcmp(tissues,'Tb'))~=0
f4 = patch('Faces',OBJ1.objects(4).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m6,'FaceColor','interp','LineStyle','none');
end

if sum(strcmp(tissues,'ExMes'))~=0
f5 = patch('Faces',OBJ1.objects(34).data.vertices,'Vertices',  OBJ1.vertices,'FaceVertexCData',Output.m7,'FaceColor','interp','LineStyle','none');
end

axis equal
axis off
material dull 
colormap(parula);
%view([-56.3540,-8.2808])
camlight('right')