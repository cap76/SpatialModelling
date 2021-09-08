function [Output] = MarmosetGPInfer_CS6Corr(Output,cell,OBJ);

%Scale the input data
Xtrain = Output.cleanX / Output.scalefactor;


Ytrain = Output.P(:,cell);

HYP2 = Output.HYP1;
HYP3 = Output.HYP2;

im1 = Output.im1;
im2 = Output.im2;

%First is all MODEL 8
%par = {@meanConst,@covSEiso,'likGauss',Xtrain(:,1:3), Ytrain};
hyp2 = HYP2{cell,9};
hyp3 = HYP3{cell,9};
[m9 s9] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(:,1:3), Ytrain, OBJ.vertices/Output.scalefactor);
%[m8_1 s8_1] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(:,1:3), Ytrain', OBJ.vertices/400);
    
%First is amnion
indT = find( strcmp(Output.cleanAnotaton,"Am_CS6")==1 | strcmp(Output.cleanAnotaton,"Am_CS6_PGC")==1);
hyp2 = HYP2{cell,1};
hyp3 = HYP3{cell,1};
[m1 s1] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);

%Second is EmDisk
indT = find(strcmp(Output.cleanAnotaton,"EmDisc_CS6")==1 | strcmp(Output.cleanAnotaton,"EmDisc_CS6_PGC")==1 | strcmp(Output.cleanAnotaton,"EmDisc_Gast_CS6")==1 |  strcmp(Output.cleanAnotaton,"EmDisc_gast_CS6")==1 );
hyp2 = HYP2{cell,2};
hyp3 = HYP3{cell,2};
[m2 s2] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);

%Second is EmDisk
indT = find( strcmp(Output.cleanAnotaton,"PGC_CS6")==1);
if isempty(indT)==1
    %Embryo has no PGC
    m3 = [];
else
hyp2 = HYP2{cell,3};
hyp3 = HYP3{cell,3};
[m3 s3] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);


end

indT = find(strcmp(Output.cleanAnotaton,"VE_CS6")==1);

if isempty(indT)==1
    m4 = [];
%Third is VE
else
hyp2 = HYP2{cell,4};
hyp3 = HYP3{cell,4};
[m4 s4] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);
end

%Next we have SYS
indT = find(strcmp(Output.cleanAnotaton,"SYS_CS6")==1);
if isempty(indT)==1
    m5 = [];
%Third is VE
else
hyp2 = HYP2{cell,5};
hyp3 = HYP3{cell,5};
[m5 s5] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);
end

%ExMes
indT = find(strcmp(Output.cleanAnotaton,"ExMes_CS6")==1);
if isempty(indT)==1
    m6 = [];
else
hyp2 = HYP2{cell,6};
hyp3 = HYP3{cell,6};
[m6 s6] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);
end

indT = find(strcmp(Output.cleanAnotaton,"Tb_CS6")==1);
if isempty(indT)==1
    m7 = [];
else
hyp2 = HYP2{cell,7};
hyp3 = HYP3{cell,7};
[m7 s7] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);
end


%Second is EmDisk
indT = find(strcmp(Output.cleanAnotaton,"Stalk_CS6")==1 | strcmp(Output.cleanAnotaton,"EmDisc_Stalk_CS6")==1 | strcmp(Output.cleanAnotaton,"EmDisc_stalk_CS6")==1 );
hyp2 = HYP2{cell,8};
hyp3 = HYP3{cell,8};
[m8 s8] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT), OBJ.vertices/Output.scalefactor);


Output.m1 = m1;
Output.m2 = m2;
Output.m3 = m2;
Output.m4 = m4;
Output.m5 = m5;
Output.m6 = m6;
Output.m7 = m7;
Output.m8 = m8;
Output.m9 = m9;
