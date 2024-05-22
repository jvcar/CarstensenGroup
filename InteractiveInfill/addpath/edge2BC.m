function [fixeddofs]=edge2BC(choose_edge,dir_bc_edge,nely,nnode,lg_ndof)
% Find fixeddofs
if choose_edge == 1 % Left edge
        if dir_bc_edge==1
            fixeddofs=[1:2:2*(nely+1)];
        elseif dir_bc_edge ==2 
            fixeddofs=[2:2:2*(nely+1)];
        elseif dir_bc_edge==3
            fixeddofs=[1:2*(nely+1)];
        end
    elseif choose_edge == 2 % Top edge
        nodloc=[1:(nely+1):nnode];
        k=1;
        for i =1:length(nodloc)
            if dir_bc_edge == 1
                fixeddofs(k)=lg_ndof(1,nodloc(i)); 
                k=k+1;
            elseif dir_bc_edge == 2
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            elseif  dir_bc_edge ==3
                fixeddofs(k)=lg_ndof(1,nodloc(i));
                k=k+1;
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            end
        end
    elseif choose_edge == 3 % Right edge
        nodloc=[(nnode-(nely)):nnode];
        k=1;
        for i =1:length(nodloc)
            if dir_bc_edge == 1
                fixeddofs(k)=lg_ndof(1,nodloc(i)); 
                k=k+1;
            elseif dir_bc_edge == 2
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            elseif  dir_bc_edge ==3
                fixeddofs(k)=lg_ndof(1,nodloc(i));
                k=k+1;
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            end
        end
    elseif choose_edge == 4 % Top edge
        nodloc=[(nely+1):(nely+1):nnode];
        k=1;
        for i =1:length(nodloc)
            if dir_bc_edge == 1
                fixeddofs(k)=lg_ndof(1,nodloc(i)); 
                k=k+1;
            elseif dir_bc_edge == 2
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            elseif  dir_bc_edge ==3
                fixeddofs(k)=lg_ndof(1,nodloc(i));
                k=k+1;
                fixeddofs(k)=lg_ndof(2,nodloc(i));
                k=k+1;
            end
        end
end
end