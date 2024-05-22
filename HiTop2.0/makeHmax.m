function [Hmax,HsVMax,indices,rstraight]=makeHmax(nelx,nely,HsV,rmin,rminV,roi,contno,rnew,lambda)
rmax=rnew+rminV;r=zeros(nely,nelx);
%Retrieve relevant parameters in drawn ROI
center = roi.Center;
axes = roi.SemiAxes;
angle = roi.RotationAngle;
%Generate arrays of x and y for in ROI checks
xcoord = zeros(1,(nelx*nely));
ycoord = zeros(1,(nelx*nely));
count = 1;

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

%Generate rmin function from input lambda
xfunc = 1:1:nelx;
rfunc = zeros(1,nelx);
for i=1:nelx
  %Note: Only works right now for rnew > rmin
    rfunc(i) = 0.5*(rnew+rmin) + 0.5*(rnew-rmin)*tanh((i-nelx/2)/lambda);
end 

for i=1:length(rfunc)
if abs(rfunc(i)-rmin) < 0.01
    start = i;
elseif abs(rfunc(i)-rnew) > 0.01
    fin = i;
end 
end 

rroi = r; %Array of r for plotting ROI

d = fin - start;

contgap = ceil(d/contno);

%r of a contour = rfunc(start+contgap*contourID)

tf = inROI(roi,xcoord,ycoord);
for i=1:length(tf)
  if tf(i) == 1
      r(ycoord(i),xcoord(i)) = rfunc(start);
      rroi(ycoord(i),xcoord(i)) = rfunc(start);
  end 
end 

for z=1:contno
  
  %New concentric contour - Generating inwards
  roinew = drawellipse('Center',center,'SemiAxes',axes-3*z,'RotationAngle',angle,'Color','white');   
  tfnew = inROI(roinew,xcoord,ycoord);

  for i=1:length(tfnew)
      if tfnew(i)==1 
          r(ycoord(i),xcoord(i)) = rfunc(start + contgap*z);
      end 
  end 

end
%% Count the elements on the ellipse
rstraight=r(:);
kk=0;
indices=[];
for i =1:nelx*nely
    if rstraight(i,1) > 0
        kk=kk+1;
        indices(end+1,1)=i;
    end
end
%% Create H and Hs with new map
iHmax=ones((nelx*nely)*(2*(ceil(rmax)-1)+1)^2,1);
jHmax=ones(size(iHmax));
sHmax=zeros(size(iHmax));
k=0;
p=1;
for i1 =1:nelx
    for j1= 1:nely
        e1=(i1-1)*nely+j1;
        for i2 = max(i1-(ceil(rmax)-1),1):min(i1+(ceil(rmax)-1),nelx)
            for j2 = max(j1-(ceil(rmax)-1),1):min(j1+(ceil(rmax)-1),nely)
                e2 = (i2-1)*nely+j2;
                k = k+1;
                iHmax(k) = e1;
                jHmax(k) = e2;
                sHmax(k) = max(0,rmax-sqrt((i1-i2)^2+(j1-j2)^2));
            end
        end
    end
end
Hmax=sparse(iHmax,jHmax,sHmax);
Hmax=Hmax(indices,indices);

%% Find HsVMax
HsVMax=HsV(indices);
end