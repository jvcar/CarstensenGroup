function [F]=roi2Force(nelx,nely,roiF,ndof,lg_ndof,nodenrs,dir)

%Generate arrays of x and y for in Force vector
count=1;
for i=1:nely+1
  for k=1:nelx+1
      xcoord(count)=k;
      count = count+1;
  end 
end 

count = 1;

for i=1:nely+1
  for k=1:nelx+1
      ycoord(count)=i;
      count = count+1;
  end 
end 

% Find x and y locations of elements in Force vector 
check=inROI(roiF,xcoord,ycoord);    
loc=find(check==1);
xloc=xcoord(loc);
yloc=abs(ycoord(loc)-(nely+2)); %flip grid

% Find Node Numbers of elements in Force vector
for i =1:length(xloc)
    nodloc(i)=nodenrs(yloc(i),xloc(i));
end

% Find N_dof of elements in Force vector
k=1;
for i =1:length(nodloc)
    if dir == 1
        ndof_loc(k)=lg_ndof(1,nodloc(i)); 
        k=k+1;
    elseif dir == 2
        ndof_loc(k)=lg_ndof(2,nodloc(i));
        k=k+1;
    elseif dir ==3
        ndof_loc(k)=lg_ndof(1,nodloc(i));
        k=k+1;
        ndof_loc(k)=lg_ndof(2,nodloc(i));
    end
end

% Create Force vector
F=sparse(ndof,1);
F(ndof_loc,1)=-1;
end