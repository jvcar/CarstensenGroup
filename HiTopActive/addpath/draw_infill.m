function [xPhys,elloc, neleD,el_D,ellocFree,xPhysbig,ind]=draw_infill(nelx,nely,figNum,xPhys)

nele=nelx*nely;
%% DRAW FIRST ROI WHERE DRAWING WILL BE PLACED
fprintf('Highlight ROI 1 - double click on ROI when finished editing \n');
roi = drawfreehand('Color','red');
% Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);

% Generate arrays of x and y for in ROI checks
count=1;
for i=1:nely
  for k=1:nelx
      xcoord(count)=k;
      count = count+1;
  end 
end 

count = 1;

for i=1:nely
  for k=1:nelx
      ycoord(count)=i;
      count = count+1;
  end 
end 
check=inROI(roi,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)); %flip grid

el_array=reshape(1:nele,nely,nelx);
el_D=el_array(:);

% Find Element Numbers
    for i =1:length(xloc)
        elloc(i)=el_array(yloc(i),xloc(i)); % indices of the passive elements
    end
neleD=nele-length(elloc); % get the number of design elements
el_D(elloc)=[]; % indices of the design variable elements

%% Show Design Space
xPhys_map=0.5*xPhys;
xPhys_map(elloc)=1;
figure(figNum); colormap(jet); imagesc(xPhys_map); caxis([0 1]); axis equal; axis off; drawnow;

%% DRAW SECOND ROI - ACTUAL DRAWING THAT WILL BE REPLICATED 
roiFree = drawfreehand('Color','White');
% Wait until user finishes editing ROI
l = addlistener(roiFree,'ROIClicked',@clickCallback);
uiwait;
delete(l);

% Find x y position of elements IN the freehand roi 
checkFree=inROI(roiFree,xcoord,ycoord);    
locFree=find(checkFree==1);
xlocFree=xcoord(locFree);
ylocFree=abs(ycoord(locFree)); %flip grid

% find element numbers of elements in the freehand roi
for i =1:length(xlocFree)
    ellocFree(i)=el_array(ylocFree(i),xlocFree(i)); % indices of 1s in freehand roi
end


%% Find the indices of the drawing elements 
xPhysbig=zeros(nely,nelx);
xPhysbig(ellocFree)=1;
ind=unique([elloc(:);ellocFree(:)]);

function clickCallback(~,evt)
    if strcmp(evt.SelectionType,'double')
        uiresume;
    end
end
end