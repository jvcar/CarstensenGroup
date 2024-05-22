function [neleD,elloc,el_D]=passive()
parameters

fprintf('Highlight passive region - double click on region when finished editing \n');
roi = drawrectangle('Color','yellow');

% Wait until user finishes editing ROI
l = addlistener(roi,'ROIClicked',@clickCallback);
uiwait;
delete(l);

% Get position
x1=roi.Position(1);
y1=roi.Position(2);
x2=x1+roi.Position(3);
y2=y1+roi.Position(4);

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

% Find x and y locations of elements in passive region
check=inROI(roi,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)-(nely)-1); %flip grid
el_array=reshape(1:nele,nely,nelx);
el_D=el_array(:);

% Find Element Numbers
for i =1:length(xloc)
    elloc(i)=el_array(yloc(i),xloc(i)); % indices of the passive elements
end

neleD=nele-length(elloc); % get the number of design elements
el_D(elloc)=[]; % indices of the design variable elements
end

function clickCallback(~,evt)
if strcmp(evt.SelectionType,'double')
    uiresume;
end

end
