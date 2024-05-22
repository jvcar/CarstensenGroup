function [el_display]=DrawInfill(patchX,patchY)
parameters
% Plot the patch for the user to draw infill on
figure(3); 
pcolor(meshgrid(1:patchX+1,1:patchY+1)); zoom out; grid on; axis equal; axis padded; clim([0 1]); 

% Draw the infill
fprintf('Draw infill - double click on region when finished editing \n');
roi = drawpolygon('Color','black');
% Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);
% Generate arrays of x and y for in infill checks
count=1;
for i=1:patchY
  for k=1:patchX
      xcoord(count)=k;
      count = count+1;
  end 
end 
count = 1;
for i=1:patchY
  for k=1:patchX
      ycoord(count)=i;
      count = count+1;
  end 
end 
% Find x and y locations of elements in infill pattern
check=inROI(roi,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)-(patchY)-1); %flip grid
    
el_array=reshape(1:patchX*patchY,patchY,patchX);
% Find Element Numbers of elements in infill pattern
for i =1:length(xloc)
    ind_patch(i)=el_array(yloc(i),xloc(i)); % indices of the passive elements
end

% Create matrix containing one infill pattern
el_display=zeros(patchY,patchX);
el_display(ind_patch)=1;
end

function clickCallback(~,evt)
if strcmp(evt.SelectionType,'double')
    uiresume;
end
end