close all; clear all

addpath addpath/
addpath addpath/MMA_Nov22
set(0,'DefaultFigureWindowStyle','docked')
tic
%% Run Inputs
parameters;

%% Prompt GUI and Passive Regions
[U,freedofs,F]=GUI(nelx,nely);
passive_usr=input('Do you want to prescribe solid(1), void(0), or neither (2) \n');
if passive_usr==2
    neleD=nele; elloc=[]; el_D=[1:nele];
else
    [neleD,elloc,el_D]=passive();
end

%% Run First 50 iterations
maxloop=50; figNum=2;
x=.5*ones(nely,nelx);
[xPhys,HsV,HS,HsS,HV,U]=MinLS(x,maxloop,figNum,U,freedofs,F,neleD,elloc,el_D,passive_usr); % modified for passive

%% Show first Stress Plot 
figNum=4;
StressPlot(xPhys,U,figNum);

%% -----------------ROI 1-------------- %%
fprintf('Arrived at loop 50. ');
% Enter number of changes to design
changes=input('Make 1 or 2 changes? ');
if changes ==1
    maxloop=2000;
elseif changes==2
    maxloop=50;
end
% Decide changes
change1=input('First Change: Passive (3), Max(2), Min S(1), or Min V(0):');
fprintf('Highlight ROI 1 - double click on ROI when finished editing \n');
roi = drawellipse('Color','green');
%Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);
if change1 ==3
    passive_usr=input('Prescribe solid (1) or void (0): '); % must be same as design problem
else
    contno = input('Enter number of contour lines \n');
    rnew = input('Input rmin of ROI \n');
    lambda = input('Input lambda between domain and ROI \n');
end

%% CHANGE 1 
figNum=5;    
if change1==3 % Prescribe Passive Region 
    [elloc2]=passive2(roi);
    elloc=[elloc,elloc2]; % all the indices of the design variable elements
    elloc=unique(elloc);
    neleD=nele-length(elloc); % updated neleD
    el_D=reshape(1:nele,nely,nelx);
    el_D(elloc)=[]; % indices of design variable elements are not included
    [xPhys]=MinLS(xPhys,maxloop,figNum,U,freedofs,F,neleD,elloc,el_D,passive_usr);
elseif change1==2 % Change Max Length Scale
    [Hmax,HsVMax,indices]=makeHmax(nelx,nely,HsV,rminS,rminV,roi,contno,rnew,lambda);
    [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
elseif change1==1 % Change Min Length Scale Solid
    r=rminS*ones(nely,nelx);
    [HS,HsS,r]=makeH_Hs(roi,contno,rnew,lambda,nely,nelx,rminS,r);
    [xPhys]=MinLenScaleS_MOD(xPhys,maxloop,rminV,HS,HsS,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
elseif change1==0 % Change Min Length Scale Void
    r=rminV*ones(nely,nelx);
    [HV,HsV,r]=makeH_Hs(roi,contno,rnew,lambda,nely,nelx,rminV,r);
    [xPhys]=MinLenScaleV_MOD(xPhys,maxloop,rminS,HV,HsV,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
end

%% Show Second Stress Plot 
figNum=7;
StressPlot(xPhys,U,figNum);

%% -----------------ROI 2-------------- %%
fprintf('Arrived at loop 50. ');
change2=input('Change Max(2), Min S(1), or Min V(0) OR No Change(3):');
if change2==3 
   fprintf('Complete! \n');
else
    fprintf('Highlight ROI 1 - double click on ROI when finished editing \n');
    roi2 = drawellipse('Color','green');
    %Wait until user finishes editing ROI
    l = addlistener(roi2,'ROIClicked',@clickCallback);
    uiwait;
    delete(l);
    contno2 = input('Enter number of contour lines \n');
    rnew2 = input('Input rmin of ROI \n');
    lambda2 = input('Input lambda between domain and ROI \n');
    maxloop=2000;

%% CHANGE 2
    if change2==2 % Change 2 - Max
        figNum=8;
        if change1==2 % Change 1 - Max
        [Hmax,HsVMax,indices]=makeHmaxTwice(nelx,nely,HsV,rminS,rminV,roi2,contno2,rnew2,lambda2,indices);
        [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif or(change1==1,change1==3) % Change 1 - Min Solid
        [Hmax,HsVMax,indices]=makeHmax(nelx,nely,HsV,rminS,rminV,roi2,contno2,rnew2,lambda2);
        [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif change1==0 % Change 1 - Min Void
        [Hmax,HsVMax,indices]=makeHmax(nelx,nely,HsV,rminS,rminV,roi2,contno2,rnew2,lambda2);
        [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        end
    elseif change2==1 % Change 2 - Min Solid
        figNum=8;
        if change1==2 % Change 1 - Max
        r=rminS*ones(nely,nelx);
        [HS,HsS,r]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminS,r);
        [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif or(change1==1,change1==3) % Change 1 - Min Solid
        if change1==3
            r=rminS*ones(nely,nelx);
        end
        [HS,HsS,r]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminS,r);
        [xPhys]=MinLenScaleS_MOD(xPhys,maxloop,rminV,HS,HsS,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif change1==0 % Change 1 - Min Void
        rS=rminS*ones(nely,nelx);
        [HS,HsS,rS]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminS,rS);
        [xPhys]=MinLenScaleSV(xPhys,maxloop,HS,HsS,HV,HsV,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        end    
    elseif change2==0 % Change 2 - Min Void
        figNum=8;
        if change1==2 % Change 1 - Max
        r=rminV*ones(nely,nelx);
        [HV,HsV,r]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminV,r);    
        [xPhys]=MaxLenScale(xPhys,Hmax,HsV,HS,HsS,HV,HsVMax,maxloop,indices,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif or(change1==1,change1==3) % Change 1 - Min Solid
        rV=rminV*ones(nely,nelx);
        [HV,HsV,rV]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminV,rV);   
        [xPhys]=MinLenScaleSV(xPhys,maxloop,HS,HsS,HV,HsV,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        elseif change1==0 % Change 1 - Min Solid
        [HV,HsV,r]=makeH_Hs(roi2,contno2,rnew2,lambda2,nely,nelx,rminV,r);
        [xPhys]=MinLenScaleV_MOD(xPhys,maxloop,rminS,HV,HsV,figNum,F,U,freedofs,neleD,elloc,el_D,passive_usr);
        end
    end
end

toc
function clickCallback(~,evt)
if strcmp(evt.SelectionType,'double')
    uiresume;
end
end