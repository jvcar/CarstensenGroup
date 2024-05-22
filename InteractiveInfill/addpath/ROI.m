function [ind,num_ind,el_D]=ROI()
parameters
% Draw the ROI
fprintf('Highlight region of interest - double click on region when finished editing \n');
roi = drawfreehand('Color','red');
% Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);
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
% Find x and y locations of elements in ROI
check=inROI(roi,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)); %flip grid
el_array=reshape(1:nele,nely,nelx);
el_D=el_array(:);

% Find Element Numbers of elements in ROI
for i =1:length(xloc)
    ind(i)=el_array(yloc(i),xloc(i)); % indices of the ROI elements
end
num_ind=length(ind); % total number of ROI elements
ind=ind';
el_D(ind)=[];
end

function clickCallback(~,evt)
if strcmp(evt.SelectionType,'double')
    uiresume;
end
end