addpath(genpath('./Functions'))

%Load in the 3D scaffold
[OBJ1,section] = LoadCS7('3D');

%Plot the 3D model.
%If there are 2 inputs it will plot the surfaces of a specified
%set of tissues. Can specify figure number with third parameter if you have
%plots already open
tissues = 'all';
PlotEmbryoCS7(OBJ1,tissues);
%PlotEmbryoCS5(OBJ1,tissues,1); %Specify figure no.

%Load shot locations
[D,Locations,XYZ,CellType,Shots] = LoadShots('CS7');
%Process the shots onto scaffold
[Output] = loadCS7Scaffold(D,Locations,Shots);

[Output] = MarmosetGP_CS7_v3(D,Output,'SOX2');
[Output] = MarmosetGPInfer_CS7_v3(Output,OBJ1);

%Default view for all tissues
[OBJ1b,a1,b1] = transformCS7(OBJ1,'all');
h = PlotEmbryoCS7GP_v3(Output,OBJ1b,{'all'},2);
view(a1,b1)
camlight('left')

%print(['Plots/Demo_SOX2_CS7.pdf'],'-dpdf','-r1000');
%dpng and quality parameters

%Default view for AP axis
[OBJ2b,a2,b2] = transformCS7(OBJ1,'notall')
h = PlotEmbryoCS7GP_v3(Output,OBJ2b,{'EmDisc','Stalk'},1);
view([a2,b2])
camlight('left')

%Try some sections ...
%Only C2 atm
[OBJ1,section] = LoadCS7('C2');
PlotEmbryoCS7(OBJ1,tissues,1);
[Output] = MarmosetGPInfer_CS7_v3(Output,OBJ1);
virtualIF_CS7(Output,OBJ1,{'all'},1);

%We can also do line plots
load('../Data/SpatialData/CS7_EmDisc.mat')
[Output] = MarmosetGPInfer_CS7_v3(Output,Line,'Line');
h = plotAP(Output, 1, [1,1,1], 'EmDisc');
title('SOX2')

%Virtual micropattern
load('../Data/SpatialData/CS7_EmDisc.mat')
virtualMicropatternCS7(D,Output,Line,{'SOX2','NANOG','MIXL1','T'},1);