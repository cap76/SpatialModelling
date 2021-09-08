function [Output] = MarmosetGP_CS5_hmc(D,Output,gene2test);

% %HMC options
options     = foptions; % Default options vector.
options(1)  = 0;		% Switch on diagnostics.
options(5)  = 0;		% Use persistence
options(7)  = 4;	    % Number of steps in trajectory.
options(14) = 25000;	    % Number of Monte Carlo samples returned. 
options(15) = 2000;	    % Number of samples omitted at start of chain.
options(18) = 0.02;

%Scale the input data
Xtrain = Output.cleanX / Output.scalefactor;

gind = find(strcmp(D.textdata(2:end,1),gene2test)==1);
Ytrain = D.data(gind,Output.cleanindex);

pg1 = {@priorGauss,0,1};  
pg2 = {@priorGauss,1,1};  
pg3 = {@priorGauss,log(0.5),1};  
pc = {@priorClamped};

%Prior for base model
prior1.mean = {[]};  
prior1.cov  = {pg2;pg1};
prior1.lik  = {pg3};

%Prior for long lenghth-scale model
prior2.mean = {[]};  
prior2.cov  = {pc;pg1};
prior2.lik  = {pg3};

im1 = {@infPrior,@infExact,prior1};
im2 = {@infPrior,@infExact,prior2};

%Hyparameters: Am, EmDisc+Stalk, PGC, VE, SYS, ExMes, Tb    
HYP2 = cell(1,8);
HYP3 = cell(1,8);
L1 = cell(1,8);
L2 = cell(1,8);

%Initalise a high noiose std and long length scale
hyp1.cov  = [ (4) ; std(Ytrain) ];
hyp1.lik  = [std(Ytrain)/2];    
hyp1.mean = mean(Ytrain);       

hyp1B.cov  = [(40) ; var(Ytrain)];
hyp1B.lik  = [var(Ytrain)/2];    
hyp1B.mean = mean(Ytrain); 

%par = {@meanConst,@covSEiso,'likGauss',Xtrain(:,1:3), Ytrain'};
%par1 = {@meanConst,@covSEard,'likGauss',Xtrain(:,1:3), Ytrain',hyp1};
%par2 = {@meanConst,@covSEard,'likGauss',Xtrain(:,1:3), Ytrain',hyp3};
 
%First is all
par = {@meanConst,@covSEiso,'likGauss',Xtrain(:,1:3), Ytrain',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
%hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
%hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
HYP2{1,8} = samples1;
HYP3{1,8} = samples2;
L1{1,8} = energies1;
L2{1,8} = energies2;
%[m0 s0] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[L1_8 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(:,1:3), Ytrain');
%[L2_8 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(:,1:3), Ytrain');
    
%First is amnion
indT = find(Output.cleanAnotaton=="Am_CS5" | Output.cleanAnotaton=="Am_CS5_PGC");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,1} = samples1;
HYP3{1,1} = samples2;
L1{1,1} = energies1;
L2{1,1} = energies2;
%hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
%hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
%HYP2{1,1} = hyp2;
%HYP3{1,1} = hyp3;
%[m0 s0] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[L1_1 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
%[L2_1 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');


%Second is EmDisk
indT = find(Output.cleanAnotaton=="EmDisc_CS5");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,2} = samples1;
HYP3{1,2} = samples2;
L1{1,2} = energies1;
L2{1,2} = energies2;

%hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
%hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
%HYP2{1,2} = hyp2;
%HYP3{1,2} = hyp3;
%[m1 s1] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[m3 s3] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[L1_2 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
%[L2_2 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');

L1_3 = NaN;
L2_3 = NaN;

%Third is VE
indT = find(Output.cleanAnotaton=="VE_CS5");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,4} = samples1;
HYP3{1,4} = samples2;
L1{1,4} = energies1;
L2{1,4} = energies2;

%hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
%hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
%HYP2{1,4} = hyp2;
%HYP3{1,4} = hyp3;
%%[m2 s2] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[L1_4 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
%[L2_4 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');


%Next we have SYS
indT = find(Output.cleanAnotaton=="SYS_CS5");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,5} = samples1;
HYP3{1,5} = samples2;
L1{1,5} = energies1;
L2{1,5} = energies2;

%hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
%hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
%HYP2{1,5} = hyp2;
%HYP3{1,5} = hyp3;
%[m3 s3] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
%[L1_5 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',
%Xtrain(indT,1:3), Ytrain(indT)');%
%[L2_5 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');

%ExMes
indT = find(Output.cleanAnotaton=="ExMes_CS5");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,6} = samples1;
HYP3{1,6} = samples2;
L1{1,6} = energies1;
L2{1,6} = energies2;

% hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
% hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
% HYP2{1,6} = hyp2;
% HYP3{1,6} = hyp3;
% %[m5 s5] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
% [L1_6 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
% [L2_6 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
    
%ExMes
indT = find(Output.cleanAnotaton=="Tb_CS5");
par = {@meanConst,@covSEiso,'likGauss',Xtrain(indT,1:3), Ytrain(indT)',hyp1};
[samples1, energies1] = hmc2('gpfunc', unwrap(hyp1), options, 'gpgrad', im1, par{:});     
[samples2, energies2] = hmc2('gpfunc', unwrap(hyp1B), options, 'gpgrad', im2, par{:});     
HYP2{1,7} = samples1;
HYP3{1,7} = samples2;
L1{1,7} = energies1;
L2{1,7} = energies2;

% hyp2 = feval(@minimize, hyp1, @gp, -1000, im1, par{:});         % optimise
% hyp3 = feval(@minimize, hyp1B, @gp, -1000, im2, par{:});         % optimise
% HYP2{1,7} = hyp2;
% HYP3{1,7} = hyp3;
% %[m5 s5] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)', OBJ1.vertices/400);
% [L1_7 ] = gp(hyp2, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
% [L2_7 ] = gp(hyp3, 'infExact', @meanConst, @covSEiso, 'likGauss',  Xtrain(indT,1:3), Ytrain(indT)');
 
%Output.m_0 = m0;
%Output.m_1 = m1;
%Output.m_2 = m2;
%Output.m_3 = m3;
%Output.m_5 = m5;

%Output.Ytrain = Ytrain;
%Output.Xtrain = Xtrain;
Output.L1 = L1;%[L1_1,L1_2,L1_3,L1_4,L1_5,L1_6,L1_7,L1_8];
Output.L2 = L2;%[L2_1,L2_2,L1_3,L2_4,L2_5,L2_6,L2_7,L1_8];
Output.HYP1 = HYP2;
Output.HYP2 = HYP3;

Output.im1 = im1;
Output.im2 = im2;
Output.im1 = prior1;
Output.im2 = prior2;

Output.Ytrain = Ytrain;

%Output.hyp2 = hyp1;
%Output.hyp2 = hyp2;
%Output.hyp3 = hyp3;

