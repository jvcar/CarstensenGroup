function [elloc]=passive2(roi)
parameters

%Generate arrays of x and y for in passive region
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

% Find x and y locations of elements in new passive region 
check=inROI(roi,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)); %flip grid
el_array=reshape(1:nele,nely,nelx);

% Find Element Numbers in new passive region
for i =1:length(xloc)
    elloc(i)=el_array(yloc(i),xloc(i)); % indices of the passive elements
end

end

function clickCallback(~,evt)
if strcmp(evt.SelectionType,'double')
    uiresume;
end

end
