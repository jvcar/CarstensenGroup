function [fixeddofs]=roi2BC(nelx,nely,roiBC1,lg_ndof,nodenrs,dir_bc1)
    %Generate arrays of x and y for inROI ch ecks
    
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
    check=inROI(roiBC1,xcoord,ycoord);    
    loc=find(check==1);
    xloc=xcoord(loc);
    yloc=abs(ycoord(loc)-(nely+2)); %flip grid
    
    % Find Node Numbers
    for i =1:length(xloc)
        nodloc(i)=nodenrs(yloc(i),xloc(i));
    end
    
    % Find N_dof
    k=1;
    for i =1:length(nodloc)
        if dir_bc1 == 1
            ndof_loc(k)=lg_ndof(1,nodloc(i)); 
            k=k+1;
        elseif dir_bc1 == 2
            ndof_loc(k)=lg_ndof(2,nodloc(i));
            k=k+1;
        elseif dir_bc1 ==3
            ndof_loc(k)=lg_ndof(1,nodloc(i));
            k=k+1;
            ndof_loc(k)=lg_ndof(2,nodloc(i));
            k=k+1;
        end
    end
    fixeddofs=ndof_loc;
end