function [xPhys,elloc, neleD,el_D,ellocFree]=draw_infill(nelx,nely,fignum,xPhys)
nele=nelx*nely;

fprintf('Highlight ROI 1 - double click on ROI when finished editing \n');
roi = drawfreehand('Color','red');
%Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);

% Get position
x1=roi.Position(1);
y1=roi.Position(2);
x2=x1+roi.Position(3);
y2=y1+roi.Position(4);
%Generate arrays of x and y for in ROI checks
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

% Show Design Space
el_display=zeros(nelx,nely);
el_display(elloc)=1;
xPhys_map=0.5*xPhys;
xPhys_map(elloc)=1;
figure(fignum); colormap(jet); imagesc(xPhys_map); caxis([0 1]); axis equal; axis off; drawnow;

% Freehand 
roiFree = drawfreehand('Color','White');
%Wait until user finishes editing ROI
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


% set first, rectangular ROI to 0s
xPhys(elloc)=0;
xPhys(ellocFree)=1;

function clickCallback(~,evt)
    if strcmp(evt.SelectionType,'double')
        uiresume;
    end
end
end