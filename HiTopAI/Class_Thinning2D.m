classdef Class_Thinning2D
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        %         Property1T
    end

    methods
        function obj = Class_Thinning2D()

        end

        %%
        function NewM=SimplifyPoints(obj,M0,xyn)
            Y0 = size(M0,1);
            X0 = size(M0,2);
            Xn = xyn(1);
            Yn = xyn(2);
            Xsize = X0 / Xn;
            Ysize = Y0 / Yn;
            NewM = zeros(Yn,Xn);

            for i = 1:Yn
                for j = 1: Xn
                    Xmax = j*Xsize + 0.5*Xsize;
                    Xmin = j*Xsize - 0.5*Xsize;
                    Ymax = i*Ysize + 0.5*Ysize;
                    Ymin = i*Ysize - 0.5*Ysize;
                    tp=0;
                    count=0;
                    for ii = 1:Y0
                        for jj = 1:X0
                            if ii>=Ymin && ii<=Ymax && jj>=Xmin && jj<=Xmax
                                count=count+1;
                                tp = tp + M0(ii,jj);
                            end
                        end
                    end
                    if tp/count >=0.75
                        NewM(i,j)=1;
                    end

                end
            end


        end

        %% thinning
        function jd = Judge(obj, tm, option)
            jd=0;

            if (sum(sum(tm)))== 1 && tm(2,2)==1
                jd=1;
            end

            jd1=0;
            if (sum(sum(tm))-tm(2,2))>=2 && (sum(sum(tm))-tm(2,2))<=6
                jd1=1;
            end

            jd2=0;
            tp=0;
            if tm(1,2)==0 && tm(1,3)==1
                tp=tp+1;
            end
            if tm(1,3)==0 && tm(2,3)==1
                tp=tp+1;
            end
            if tm(2,3)==0 && tm(3,3)==1
                tp=tp+1;
            end
            if tm(3,3)==0 && tm(3,2)==1
                tp=tp+1;
            end
            if tm(3,2)==0 && tm(3,1)==1
                tp=tp+1;
            end
            if tm(3,1)==0 && tm(2,1)==1
                tp=tp+1;
            end
            if tm(2,1)==0 && tm(1,1)==1
                tp=tp+1;
            end
            if tm(1,1)==0 && tm(1,2)==1
                tp=tp+1;
            end

            if tp==1
                jd2=1;
            end

            jd3=0;
            jd4=0;
            if option == 1
                if (tm(1,2)*tm(2,3)*tm(3,2))==0
                    jd3=1;
                end
                if (tm(2,3)*tm(3,2)*tm(2,1))==0
                    jd4=1;
                end
            else
                if (tm(1,2)* tm(2,3) * tm(2,1))==0
                    jd3=1;
                end
                if (tm(1,2)* tm(3,2)* tm(2,1))==0
                    jd4=1;
                end
            end

            if jd1*jd2*jd3*jd4==1
                jd=1;
            end
        end

        function [NewM, jd] = Thin(obj, MM, option)
            xnum = size(MM,2);
            ynum = size(MM,1);
            jd=0;
            NewM = MM;

            for i = 1:ynum
                for j =1:xnum
                    tm = zeros(3,3);
                    if i-1<1 && j-1<1
                        tm(2:3,2:3) = MM(i:i+1,j:j+1);
                    elseif (i+1)>ynum && (j+1)>xnum
                        tm(1:2,1:2) = MM(i-1:i,j-1:j);
                    elseif i-1<1 && (j+1)>xnum
                        tm(2:3,1:2) = MM(i:i+1,j-1:j);
                    elseif (i+1)>ynum && j-1<1
                        tm(1:2,2:3) = MM(i-1:i,j:j+1);
                    elseif i-1<1
                        tm(2:3,:) = MM(i:i+1,j-1:j+1);
                    elseif (i+1)>ynum
                        tm(1:2,:) = MM(i-1:i,j-1:j+1);
                    elseif j-1<1
                        tm(:,2:3) = MM(i-1:i+1,j:j+1);
                    elseif (j+1)>xnum
                        tm(:,1:2) = MM(i-1:i+1,j-1:j);
                    else
                        tm =  MM(i-1:i+1,j-1:j+1);
                    end

                    jd1 = obj.Judge(tm, option);
                    if jd1 == 1
                        NewM(i,j) = 0;
                        xx=i;
                        yy=j;
                        jd=1;
                    end
                end
            end


        end

        function [NewM, jd] = Thin_improve(obj, MM, option, MM2)
            xnum = size(MM,2);
            ynum = size(MM,1);
            jd=0;
            NewM = MM;
            judgeM = MM2;
            for i = 1:ynum
                for j =1:xnum
                    tm = zeros(3,3);
                    if i-1<1 && j-1<1
                        tm(2:3,2:3) = MM(i:i+1,j:j+1);
                    elseif (i+1)>ynum && (j+1)>xnum
                        tm(1:2,1:2) = MM(i-1:i,j-1:j);
                    elseif i-1<1 && (j+1)>xnum
                        tm(2:3,1:2) = MM(i:i+1,j-1:j);
                    elseif (i+1)>ynum && j-1<1
                        tm(1:2,2:3) = MM(i-1:i,j:j+1);
                    elseif i-1<1
                        tm(2:3,:) = MM(i:i+1,j-1:j+1);
                    elseif (i+1)>ynum
                        tm(1:2,:) = MM(i-1:i,j-1:j+1);
                    elseif j-1<1
                        tm(:,2:3) = MM(i-1:i+1,j:j+1);
                    elseif (j+1)>xnum
                        tm(:,1:2) = MM(i-1:i+1,j-1:j);
                    else
                        tm =  MM(i-1:i+1,j-1:j+1);
                    end

                    jd1 = obj.Judge(tm, option);
                    tp2 = judgeM(i,j);
                    if jd1 == 1 && (tp2~=1)
                        NewM(i,j) = 0;
                        xx=i;
                        yy=j;
                        jd=1;
                    end
                end
            end


        end


        %% Matching
        function [types] = TypeSettings(obj)
            types = zeros(3,3,17);
            types(:,:,1) = [0,1,0;
                0,1,0;
                1,0,1];
            types(:,:,2) = [1,0,0;
                0,1,1;
                1,0,0];
            types(:,:,3) = [1,0,1;
                0,1,0;
                0,1,0];
            types(:,:,4) = [0,0,1;
                1,1,0;
                0,0,1];

            types(:,:,5) = [0,1,0;
                0,1,1;
                0,1,0];
            types(:,:,6) = [0,0,0;
                1,1,1;
                0,1,0];
            types(:,:,7) = [0,1,0;
                1,1,0;
                0,1,0];
            types(:,:,8) = [0,1,0;
                1,1,1;
                0,0,0];

            types(:,:,9) = [1,0,0;
                0,1,1;
                0,1,0];
            types(:,:,10) = [0,0,1;
                1,1,0;
                0,1,0];
            types(:,:,11) = [0,1,0;
                1,1,0;
                0,0,1];
            types(:,:,12) = [0,1,0;
                0,1,1;
                1,0,0];

            types(:,:,13) = [1,0,1;
                0,1,0;
                1,0,0];
            types(:,:,14) = [1,0,0;
                0,1,0;
                1,0,1];
            types(:,:,15) = [0,0,1;
                0,1,0;
                1,0,1];
            types(:,:,16) = [1,0,1;
                0,1,0;
                0,0,1];
            types(:,:,17) = [1,0,1;
                0,1,0;
                1,0,1];


        end

        function [Nodes] = DetermineNodes_modified(obj, NM, filter)
            MM0 = NM;
            xnum = size(MM0,2);
            ynum = size(MM0,1);
            Nodes = zeros(1,2);
            MM = MM0;
            count =0;
            hh = filter;
            NodeConnection = [];

            % 1st part
            types = obj.TypeSettings();
            for i = 1:ynum
                for j =1:xnum
                    tm = zeros(3,3);
                    if i-1<1 && j-1<1
                        tm(2:3,2:3) = MM(i:i+1,j:j+1);
                    elseif (i+1)>ynum && (j+1)>xnum
                        tm(1:2,1:2) = MM(i-1:i,j-1:j);
                    elseif i-1<1 && (j+1)>xnum
                        tm(2:3,1:2) = MM(i:i+1,j-1:j);
                    elseif (i+1)>ynum && j-1<1
                        tm(1:2,2:3) = MM(i-1:i,j:j+1);
                    elseif i-1<1
                        tm(2:3,:) = MM(i:i+1,j-1:j+1);
                    elseif (i+1)>ynum
                        tm(1:2,:) = MM(i-1:i,j-1:j+1);
                    elseif j-1<1
                        tm(:,2:3) = MM(i-1:i+1,j:j+1);
                    elseif (j+1)>xnum
                        tm(:,1:2) = MM(i-1:i+1,j-1:j);
                    else
                        tm =  MM(i-1:i+1,j-1:j+1);
                    end

                    flag = 0;
                    for k = 1:17
                        if tm.*types(:,:,k) == types(:,:,k)
                            flag=1;
                        end
                    end

                    if sum(sum(tm))==2 && tm(2,2)==1
                        flag=1;
                    end

                    if flag==1
                        count = count+1;
                        Nodes(count,:) = [j,i];
                    end

                end
            end

            % 2nd part
            tnum = 2*hh+1;
            tpType = zeros(tnum,tnum);
            tpType(1:1+hh,1+hh)=1;
            tpType(1:1+hh,hh)=1;
            tpType(1:1+hh,hh+2)=1;
            for i =1:hh
                tpType(1+hh+i,1:1+hh-i)=1;
            end
            tpType(:,:,2) = rot90(tpType(:,:,1));
            tpType(:,:,3) = rot90(tpType(:,:,2));
            tpType(:,:,4) = rot90(tpType(:,:,3));
            for i = 1:ynum
                for j =1:xnum
                    tm = zeros(tnum,tnum);
                    if i-hh<1 && j-hh<1
                        k1=1+hh-i;
                        k2 = 1+hh-j;
                        tm(1+k1:tnum,1+k2:tnum) = MM(i-hh+k1:i+hh,j-hh+k2:j+hh);
                    elseif (i+hh)>ynum && (j+hh)>xnum
                        k1 = i+hh-ynum;
                        k2 = j+hh-xnum;
                        tm(1:tnum-k1,1:tnum-k2) = MM(i-hh:i+hh-k1,j-hh:j+hh-k2);
                    elseif i-hh<1 && (j+hh)>xnum
                        k1=1+hh-i;
                        k2 = j+hh-xnum;
                        tm(1+k1:tnum,1:tnum-k2) = MM(i-hh+k1:i+hh,j-hh:j+hh-k2);
                    elseif (i+hh)>ynum && j-hh<1
                        k1 = i+hh-ynum;
                        k2 = 1+hh-j;
                        tm(1:tnum-k1,1+k2:tnum) = MM(i-hh:i+hh-k1,j-hh+k2:j+hh);
                    elseif i-hh<1
                        k1=1+hh-i;
                        tm(1+k1:tnum,:) = MM(i-hh+k1:i+hh,j-hh:j+hh);
                    elseif (i+hh)>ynum
                        k1 = i+hh-ynum;
                        tm(1:tnum-k1,:) = MM(i-hh:i+hh-k1,j-hh:j+hh);
                    elseif j-hh<1
                        k2 = 1+hh-j;
                        tm(:,1+k2:tnum) = MM(i-hh:i+hh,j-hh+k2:j+hh);
                    elseif (j+hh)>xnum
                        k2 = j+hh-xnum;
                        tm(:,1:tnum-k2) = MM(i-hh:i+hh,j-hh:j+hh-k2);
                    else
                        tm =  MM(i-hh:i+hh,j-hh:j+hh);
                    end

                    flag = 0;
                    for k = 1:4
                        if (tm.*tpType(:,:,k) == tm)
                            if (tm(hh+1,hh+1) ~= 0)
                                flag=1;
                            end
                        end
                    end
                    if flag==1
                        count = count+1;
                        Nodes(count,:) = [j,i];
                    end

                end
            end

        end

        function [Nodes] = DetermineNodes(obj, NM, SpecialNodes)
            MM0 = NM;
            xnum = size(MM0,2);
            ynum = size(MM0,1);
            Nodes = zeros(1,2);
            MM = MM0;
            count =0;
            SN = SpecialNodes;

            types = obj.TypeSettings();

            for i = 1:ynum
                for j =1:xnum
                    tm = zeros(3,3);
                    if i-1<1 && j-1<1
                        tm(2:3,2:3) = MM(i:i+1,j:j+1);
                    elseif (i+1)>ynum && (j+1)>xnum
                        tm(1:2,1:2) = MM(i-1:i,j-1:j);
                    elseif i-1<1 && (j+1)>xnum
                        tm(2:3,1:2) = MM(i:i+1,j-1:j);
                    elseif (i+1)>ynum && j-1<1
                        tm(1:2,2:3) = MM(i-1:i,j:j+1);
                    elseif i-1<1
                        tm(2:3,:) = MM(i:i+1,j-1:j+1);
                    elseif (i+1)>ynum
                        tm(1:2,:) = MM(i-1:i,j-1:j+1);
                    elseif j-1<1
                        tm(:,2:3) = MM(i-1:i+1,j:j+1);
                    elseif (j+1)>xnum
                        tm(:,1:2) = MM(i-1:i+1,j-1:j);
                    else
                        tm =  MM(i-1:i+1,j-1:j+1);
                    end

                    flag = 0;
                    for k = 1:17
                        if tm.*types(:,:,k) == types(:,:,k)
                            flag=1;
                        end
                    end

                    if sum(sum(tm))==2 && tm(2,2)==1
                        flag=1;
                    end

                    if flag==1
                        count = count+1;
                        Nodes(count,:) = [j,i];
                    end

                end
            end

            if isempty(SN)
            else
                for i=1:size(SN,1)
                    aa=SN(i,:);
                    cc = ismember(Nodes,aa,'rows');
                    if sum(cc)>0
                    else
                        Nodes(end+1,:)=SN(i,:);
                    end
                end
            end
        end



        % ---- based on toporelation
        function [NewNodes, New_topoRelation] = SimplifyNodes_sameTopo(obj, Nodes, topoRelation,filter)
            Nodes0=Nodes;
            NodeSimple = zeros(1,2);
            hh = filter;
            New_topoRelation = zeros(1,size(topoRelation,2));
            num = size(Nodes0,1);
            cc=0;
            while num>1
                cc = cc +1;
                Nodeset = 1;
                N1 = Nodes0(1,:);
                tpTopo = topoRelation(1,:);
                count=1;
                for i = 1:num-1
                    tp = (Nodes0(i+1,:) - Nodes0(1,:));
                    LL = sqrt(tp*tp');
                    if LL <= hh
                        count = count+1;
                        Nodeset(count) = i+1;
                    end
                end
                if size(Nodeset,2)==1
                    NodeSimple(cc,:) = N1;
                    New_topoRelation(cc,:) = tpTopo;
                else
                    NodeSimple(cc,:) = sum(Nodes0(Nodeset,:))/size(Nodeset,2);
                    tpp = [];
                    for ii = 1:count
                        tpp = [tpp, topoRelation(Nodeset(ii),:)];
                    end
                    tpp = unique(tpp);
                    New_topoRelation(cc,1:size(tpp,2)) = tpp;
                end
                Nodes0(Nodeset,:) = [];
                topoRelation(Nodeset,:) = [];
                num = size(Nodes0,1);
            end
            NodeSimple(cc+1,:) = Nodes0(1,:);
            New_topoRelation(cc+1,:) = topoRelation(1,:);
            NewNodes= NodeSimple;
        end


        % ---- based on nodes location and topo relation
        function [Nodes1, TR_1, ww2] = ImproveNodes(obj, Nodes, TopoRelation, filter, spectialNodes)
            %
            Nodes0=Nodes;
            Nodes1 = Nodes0;
            NS1 = zeros(1,2);
            NS2 = zeros(1,2);
            hh = filter;
            TR_0 = TopoRelation;
            TR_1 = TR_0;
            TR_2 = zeros(1,size(TopoRelation,2));
            SN = spectialNodes;


            holes0 = zeros(max(max(TopoRelation)),100);
            for i = 1:size(holes0,1)
                cc=0;
                for j = 1:size(TopoRelation,1)
                    if max(ismember(TopoRelation(j,:),i))==1
                        cc=cc+1;
                        holes0(i,cc) = j;
                    end
                end
                cc=0;
                for j = 1:size(TopoRelation,1)
                    if all(TopoRelation(j,:)==0)
                        cc=cc+1;
                        holes0(1,cc) = j;
                    end
                end
            end

            pp = zeros(1000,1000);
            flag=1; %control total iter, until no change
            while flag==1
                flag=0;

                num = size(Nodes1,1);
                Nodes0 = Nodes1;
                topoRelation = TR_1;
                TR_2 = zeros(1,size(TopoRelation,2));
                NS2 = zeros(1,2);

                cc = 0;
                flag2=1; % control inner iter, consider changing a node each time
                while num>1
                    cc = cc +1;
                    Nodeset = 1;
                    N1 = Nodes0(1,:);

                    tpTopo = topoRelation(1,:);
                    count=1;

                    flagSN0 = 1; % exclude special nodes
                    XX = Nodes0(1,1);
                    yy = Nodes0(1,2);



                    for ISN = 1:size(SN,1)
                        XX1 = SN(ISN,1);
                        yy1 = SN(ISN,2);
                        if XX==XX1 && yy ==yy1
                            flagSN0=0;
                        end
                    end

                    if flagSN0 ==1
                        for i = 1:num-1
                            tpTopo2 = topoRelation(i+1,:);
                            tp = (Nodes0(i+1,:) - Nodes0(1,:));
                            LL = sqrt(tp*tp');



                            flagSN = 1; % exclude special nodes
                            XX = Nodes0(i+1,1);
                            yy = Nodes0(i+1,2);
                            for ISN = 1:size(SN,1)
                                XX1 = SN(ISN,1);
                                yy1 = SN(ISN,2);
                                if XX==XX1 && yy ==yy1
                                    flagSN=0;
                                end
                            end

                            if LL <= hh && flag2==1 && pp(cc,i)==0 && all(tpTopo==0)~=1 && all(tpTopo2==0)~=1 && flagSN==1
                                %                             if LL <= hh && flag2==1 && pp(cc,i)==0 && all((tpTopo+tpTopo2)==0)~=1 && flagSN==1
                                count = count+1;
                                Nodeset(count) = i+1;
                                flag=1;
                                flag2=0;
                                pp(cc,i)=1;
                            end
                        end
                    end

                    if size(Nodeset,2)==1
                        NS2(cc,:) = N1;
                        TR_2(cc,:) = tpTopo;
                    else

                        NS2(cc,:) = sum(Nodes0(Nodeset,:))/size(Nodeset,2);
                        tpp = [];
                        for ii = 1:count
                            tpp = [tpp, topoRelation(Nodeset(ii),:)];
                        end
                        tpp = unique(tpp);
                        TR_2(cc,1:size(tpp,2)) = tpp;
                    end
                    Nodes0(Nodeset,:) = [];
                    topoRelation(Nodeset,:) = [];
                    num = size(Nodes0,1);
                end

                if num~=0
                    NS2(cc+1,:) = Nodes0(1,:);
                    TR_2(cc+1,:) = topoRelation(1,:);
                end

                % check holes
                holes(:,:) = holes0*0;
                for i = 1:size(holes,1)
                    cc=0;
                    for j = 1:size(TR_2,1)
                        if max(ismember(TR_2(j,:),i))==1
                            cc=cc+1;
                            holes(i,cc) = j;
                        end
                    end
                    cc=0;
                    for j = 1:size(TR_2,1)
                        if all(TR_2(j,:)==0)
                            cc=cc+1;
                            holes(1,cc) = j;
                        end
                    end
                end

                tp=0;
                for i = 2:size(holes,1)
                    if size(find(holes(i,:)>0),2) < 2.5
                        if size(find(holes(i,:)>0),2) ~= size(find(holes0(i,:)>0),2)
                            tp=1;
                        end
                    end
                end

                % ----
                if tp==0 % if satisfy demand, update nodes
                    Nodes1 = NS2;
                    TR_1 = TR_2;
                    pp = zeros(1000,1000);
                    %                     flag=0;
                end
            end

        end

        % --- basic simplifying nodes, based on nodes locations
        function [NewNodes] = SimplifyNodes(obj, Nodes,filter, spectialNodes)
            Nodes0=Nodes;
            NodeSimple = zeros(1,2);
            hh = filter;
            num = size(Nodes0,1);
            cc=0;
            SN = spectialNodes;
            while num>1
                cc = cc +1;
                Nodeset = 1;
                N1 = Nodes0(1,:);
                count=1;

                flagSN0 = 1;
                XX = Nodes0(1,1);
                yy = Nodes0(1,2);

                for ISN = 1:size(SN,1)
                    XX1 = SN(ISN,1);
                    yy1 = SN(ISN,2);
                    if XX==XX1 && yy ==yy1
                        flagSN0=0;
                    end
                end

                if flagSN0==1
                    for i = 1:num-1
                        flagSN = 1;
                        XX = Nodes0(i+1,1);
                        yy = Nodes0(i+1,2);
                        for ISN = 1:size(SN,1)
                            XX1 = SN(ISN,1);
                            yy1 = SN(ISN,2);
                            if XX==XX1 && yy ==yy1
                                flagSN=0;
                            end
                        end
                        tp = (Nodes0(i+1,:) - Nodes0(1,:));
                        LL = sqrt(tp*tp');
                        if LL <= hh && flagSN==1
                            count = count+1;
                            Nodeset(count) = i+1;
                        end
                    end
                end

                if size(Nodeset,2)==1
                    NodeSimple(cc,:) = N1;
                else
                    NodeSimple(cc,:) = sum(Nodes0(Nodeset,:))/size(Nodeset,2);
                end
                Nodes0(Nodeset,:) = [];
                num = size(Nodes0,1);
            end
            if num~=0
                NodeSimple(cc+1,:) = Nodes0(1,:);
            end
            NewNodes= NodeSimple;
        end


        function [Elements, NM2, NodeTopo] = MatchingElement_TopoRelation(obj, Nodes, NM, factor, spectialNodes)
            Elements = zeros(1,2);
            SN = spectialNodes;
            [NM2, NodeTopo] = obj.Holes_Total(Nodes, NM, factor, SN);
            EnumY = size(NM,1);
            EnumX = size(NM,2);
            eCount=0;
            for i = 2:max(max(NM2))
                nodeNUM=0;
                index=[];
                for j1 = 1:size(NodeTopo,1)
                    v1 = NodeTopo(j1,:);
                    if ismember(i,v1)
                        nodeNUM=nodeNUM+1;
                        index(nodeNUM) = j1;
                    end
                end
                % Based on the ratio of all possible inner triangles to determine convex or not convex
                trangIndexTP = combnk([1:1:nodeNUM],3);
                trangIndex = [];
                for jj = 1:size(trangIndexTP,1)
                    flag1=1;
                    flag2=1;
                    N1 = index(trangIndexTP(jj,1));
                    N2 = index(trangIndexTP(jj,2));
                    N3 = index(trangIndexTP(jj,3));
                    nx_averge = ceil((Nodes(N1,1)+Nodes(N2,1)+Nodes(N3,1))/3);
                    ny_averge = ceil((Nodes(N1,2)+Nodes(N2,2)+Nodes(N3,2))/3);

                    if NM2(ny_averge,nx_averge) ==i
                        flag1=1;
                    else
                        flag1=0;
                    end

                    for jjj=1:nodeNUM
                        if jjj~=trangIndexTP(jj,1) && jjj~=trangIndexTP(jj,2) && jjj~=trangIndexTP(jj,3)
                            N4 =  index(jjj);

                            %                                v1 = [Nodes(N4,1)-Nodes(N1,1)  Nodes(N4,2)-Nodes(N1,2) ];
                            %                                v2 = [Nodes(N4,1)-Nodes(N2,1)  Nodes(N4,2)-Nodes(N2,2) ];
                            %                                v3 = [Nodes(N4,1)-Nodes(N3,1)  Nodes(N4,2)-Nodes(N3,2) ];
                            %                                tp=acos(((v1+v2)*v3')/(norm(v1+v2)*norm(v3)));
                            %                                if abs(abs(rad2deg(tp))-180)<(180*0.2)
                            %                                    flag2=0;
                            %                                end
                            xtp = [Nodes(N1,1),Nodes(N2,1),Nodes(N3,1)];
                            ytp = [Nodes(N1,2),Nodes(N2,2),Nodes(N3,2)];
                            A0 = polyarea(xtp,ytp);
                            xtp = [Nodes(N1,1),Nodes(N2,1),Nodes(N4,1)];
                            ytp = [Nodes(N1,2),Nodes(N2,2),Nodes(N4,2)];
                            A1 = polyarea(xtp,ytp);
                            xtp = [Nodes(N4,1),Nodes(N2,1),Nodes(N3,1)];
                            ytp = [Nodes(N4,2),Nodes(N2,2),Nodes(N3,2)];
                            A2 = polyarea(xtp,ytp);
                            xtp = [Nodes(N1,1),Nodes(N4,1),Nodes(N3,1)];
                            ytp = [Nodes(N1,2),Nodes(N4,2),Nodes(N3,2)];
                            A3 = polyarea(xtp,ytp);
                            if abs((A1+A2+A3)) < (A0*1.1)
                                flag2=0;
                            end
                        end
                    end

                    if flag1==1 && flag2==1
                        trangIndex(end+1,:) = trangIndexTP(jj,:);
                    end


                end
                if (size(trangIndex,1)/size(trangIndexTP,1)) < 0.5
                    convexornot=0;
                else
                    convexornot=1;
                end

                convexornot=1;
                if convexornot==0
                    % formulating valid triangles
                    %-------------------------------
                    % --- 1.determine all possible inner triangles
                    trangIndexTP = combnk([1:1:nodeNUM],3);
                    trangIndex = [];
                    for jj = 1:size(trangIndexTP,1)
                        flag1=1;
                        flag2=1;
                        N1 = index(trangIndexTP(jj,1));
                        N2 = index(trangIndexTP(jj,2));
                        N3 = index(trangIndexTP(jj,3));
                        nx_averge = ceil((Nodes(N1,1)+Nodes(N2,1)+Nodes(N3,1))/3);
                        ny_averge = ceil((Nodes(N1,2)+Nodes(N2,2)+Nodes(N3,2))/3);

                        if NM2(ny_averge,nx_averge) ==i
                            flag1=1;
                        else
                            flag1=0;
                        end

                        for jjj=1:nodeNUM
                            if jjj~=trangIndexTP(jj,1) && jjj~=trangIndexTP(jj,2) && jjj~=trangIndexTP(jj,3)
                                N4 =  index(jjj);

                                %                                v1 = [Nodes(N4,1)-Nodes(N1,1)  Nodes(N4,2)-Nodes(N1,2) ];
                                %                                v2 = [Nodes(N4,1)-Nodes(N2,1)  Nodes(N4,2)-Nodes(N2,2) ];
                                %                                v3 = [Nodes(N4,1)-Nodes(N3,1)  Nodes(N4,2)-Nodes(N3,2) ];
                                %                                tp=acos(((v1+v2)*v3')/(norm(v1+v2)*norm(v3)));
                                %                                if abs(abs(rad2deg(tp))-180)<(180*0.2)
                                %                                    flag2=0;
                                %                                end
                                xtp = [Nodes(N1,1),Nodes(N2,1),Nodes(N3,1)];
                                ytp = [Nodes(N1,2),Nodes(N2,2),Nodes(N3,2)];
                                A0 = polyarea(xtp,ytp);
                                xtp = [Nodes(N1,1),Nodes(N2,1),Nodes(N4,1)];
                                ytp = [Nodes(N1,2),Nodes(N2,2),Nodes(N4,2)];
                                A1 = polyarea(xtp,ytp);
                                xtp = [Nodes(N4,1),Nodes(N2,1),Nodes(N3,1)];
                                ytp = [Nodes(N4,2),Nodes(N2,2),Nodes(N3,2)];
                                A2 = polyarea(xtp,ytp);
                                xtp = [Nodes(N1,1),Nodes(N4,1),Nodes(N3,1)];
                                ytp = [Nodes(N1,2),Nodes(N4,2),Nodes(N3,2)];
                                A3 = polyarea(xtp,ytp);
                                if abs((A1+A2+A3)) < (A0*1.1)
                                    flag2=0;
                                end
                            end
                        end

                        if flag1==1 && flag2==1
                            trangIndex(end+1,:) = trangIndexTP(jj,:);
                        end


                    end
                    % --- 2. Deleting extra inner trianlges
                    if size(trangIndex,1)> (nodeNUM-2)
                        trangIndexTP2=trangIndex;
                        deletIndex =[];
                        for kk=1: (size(trangIndex,1)-(nodeNUM-2))
                            flag=1;


                            for jj = 1:(size(trangIndexTP2,1)-1)
                                N1 = index(trangIndexTP2(jj,1));
                                N2 = index(trangIndexTP2(jj,2));
                                N3 = index(trangIndexTP2(jj,3));

                                for jj2= (jj+1):size(trangIndexTP2,1)
                                    NN1 = index(trangIndexTP2(jj2,1));
                                    NN2 = index(trangIndexTP2(jj2,2));
                                    NN3 = index(trangIndexTP2(jj2,3));

                                    count=0;
                                    if N1==NN1 || N1==NN2 || N1==NN3
                                        count=count+1;
                                    end
                                    if N2==NN1 || N2==NN2 || N2==NN3
                                        count=count+1;
                                    end
                                    if N3==NN1 || N3==NN2 || N3==NN3
                                        count=count+1;
                                    end

                                    if count>=2 && flag==1
                                        LL=[Nodes(N1,1), Nodes(N1,2), Nodes(N2,1), Nodes(N2,2);
                                            Nodes(N1,1), Nodes(N1,2), Nodes(N3,1), Nodes(N3,2);
                                            Nodes(N2,1), Nodes(N2,2), Nodes(N3,1), Nodes(N3,2);
                                            Nodes(NN1,1), Nodes(NN1,2), Nodes(NN2,1), Nodes(NN2,2);
                                            Nodes(NN1,1), Nodes(NN1,2), Nodes(NN3,1), Nodes(NN3,2);
                                            Nodes(NN2,1), Nodes(NN2,2), Nodes(NN3,1), Nodes(NN3,2)];
                                        for jj3=1:3
                                            xa=LL(jj3,1);
                                            xb=LL(jj3,3);
                                            ya=LL(jj3,2);
                                            yb=LL(jj3,4);
                                            L1=norm([xb-xa,yb-ya]);
                                            for jj4=4:6
                                                xc=LL(jj4,1);
                                                xd=LL(jj4,3);
                                                yc=LL(jj4,2);
                                                yd=LL(jj4,4);
                                                L2=norm([xd-xc,yd-yc]);
                                                [rr]=obj.IntersectionPoints(xa,xb,xc,xd,ya,yb,yc,yd);
                                                if norm([rr(1)-xa,rr(2)-ya])<0.9*L1 && norm([rr(1)-xb,rr(2)-yb])<0.9*L1 && ...
                                                        norm([rr(1)-xc,rr(2)-yc])<0.9*L2 && norm([rr(1)-xd,rr(2)-yd])<0.9*L2
                                                    if flag==1

                                                        if sum(ismember(deletIndex,jj2))>=1
                                                        else
                                                            deletIndex(end+1)=jj2;
                                                            flag=0;
                                                        end

                                                    end
                                                end
                                            end

                                        end


                                    end
                                end

                            end
                            %                         trangIndexTP2(deletIndex,:) = [];
                        end
                        deletIndex = unique(deletIndex);
                        trangIndex(deletIndex,:) =[];
                    end

                    %-------------------------------

                    % based on valid triangles to decide elements
                    triangleNUM = size(trangIndex,1);
                    for jj = 1:triangleNUM

                        % ----- first edge ----
                        N1 = index(trangIndex(jj,1));
                        N2 = index(trangIndex(jj,2));
                        flag=1;
                        for jjj2 = 1:size(Elements,1)
                            if sum(ismember([N1, N2],Elements(jjj2,:)))==2
                                flag=0;
                            end
                        end
                        for jjj2 = 1:triangleNUM
                            if jjj2~=jj
                                NN1 = index(trangIndex(jjj2,1));
                                NN2 = index(trangIndex(jjj2,2));
                                NN3 = index(trangIndex(jjj2,3));
                                count=0;
                                if N1==NN1 || N1==NN2 || N1==NN3
                                    count=count+1;
                                end
                                if N2==NN1 || N2==NN2 || N2==NN3
                                    count=count+1;
                                end

                                if count==2
                                    flag=0;
                                end
                            end
                        end
                        if flag==1
                            eCount = eCount +1;
                            Elements(eCount,:) = [N1, N2];
                        end

                        % ---- second edge ----
                        N1 = index(trangIndex(jj,2));
                        N2 = index(trangIndex(jj,3));
                        flag=1;
                        for jjj2 = 1:size(Elements,1)
                            if sum(ismember([N1, N2],Elements(jjj2,:)))==2
                                flag=0;
                            end
                        end
                        for jjj2 = 1:triangleNUM
                            if jjj2~=jj
                                NN1 = index(trangIndex(jjj2,1));
                                NN2 = index(trangIndex(jjj2,2));
                                NN3 = index(trangIndex(jjj2,3));
                                count=0;
                                if N1==NN1 || N1==NN2 || N1==NN3
                                    count=count+1;
                                end
                                if N2==NN1 || N2==NN2 || N2==NN3
                                    count=count+1;
                                end

                                if count==2
                                    flag=0;
                                end
                            end
                        end
                        if flag==1
                            eCount = eCount +1;
                            Elements(eCount,:) = [N1, N2];
                        end

                        % ---- third edge ----
                        N1 = index(trangIndex(jj,1));
                        N2 = index(trangIndex(jj,3));

                        flag=1;
                        for jjj2 = 1:size(Elements,1)
                            if sum(ismember([N1, N2],Elements(jjj2,:)))==2
                                flag=0;
                            end
                        end
                        for jjj2 = 1:triangleNUM
                            if jjj2~=jj
                                NN1 = index(trangIndex(jjj2,1));
                                NN2 = index(trangIndex(jjj2,2));
                                NN3 = index(trangIndex(jjj2,3));
                                count=0;
                                if N1==NN1 || N1==NN2 || N1==NN3
                                    count=count+1;
                                end
                                if N2==NN1 || N2==NN2 || N2==NN3
                                    count=count+1;
                                end

                                if count==2
                                    flag=0;
                                end
                            end
                        end
                        if flag==1
                            eCount = eCount +1;
                            Elements(eCount,:) = [N1, N2];
                        end

                    end

                else

                    tpX=0;
                    tpY=0;
                    tpNum=0;
                    for j1=1:EnumY
                        for j2=1:EnumX
                            if NM2(j1,j2)==i
                                tpX = tpX + j2;
                                tpY = tpY + j1;
                                tpNum = tpNum + 1;
                            end
                        end
                    end
                    tpX = tpX / tpNum;
                    tpY = tpY / tpNum;

                    tpNum=0;
                    index=[];
                    for j1 = 1:size(NodeTopo,1)
                        v1 = NodeTopo(j1,:);
                        if ismember(i,v1)
                            tpNum=tpNum+1;
                            index(tpNum) = j1;
                        end
                    end

                    vv = zeros(tpNum,3);
                    for j1 = 1:tpNum
                        vv(j1,1) = Nodes(index(j1),1)-tpX;
                        vv(j1,2) = Nodes(index(j1),2)-tpY;
                        b = [0,1];
                        a = [vv(j1,1),vv(j1,2)];
                        if (a(1)*b(2)-a(2)*b(1))>0
                            vv(j1,3) = acos(sum(a.*b)/norm(a)/norm(b));
                        else
                            vv(j1,3) = 2*pi - acos(sum(a.*b)/norm(a)/norm(b));
                        end
                    end
                    % ------------------------

                    vvtp = vv(:,3);
                    for j1 = 1:tpNum
                        [aa,tpii1] = min(vvtp);
                        vvtp(find(vvtp==aa))=1e3*j1;
                        [~,tpii2] = min(vvtp);
                        flag=1;
                        for j2 = 1:size(Elements,1)
                            if sum(ismember([index(tpii1), index(tpii2)],Elements(j2,:)))==2
                                flag=0;
                            end
                        end

                        if flag==1
                            eCount = eCount +1;
                            Elements(eCount,:) = [index(tpii1), index(tpii2)];
                        end
                    end
                end
            end

        end

        function [rr]=IntersectionPoints(obj,xa,xb,xc,xd,ya,yb,yc,yd)
            v1= [xb-xa,yb-ya];
            v2=[xd-xc, yd-yc];

            m1 = [(xb-xa)/norm(v1), -1*(xd-xc)/norm(v2);
                (yb-ya)/norm(v1), -1*(yd-yc)/norm(v2)];
            d = [xc-xa; yc-ya];
            result = inv(m1)*d;
            rr = [xa+(xb-xa)*result(1)/norm(v1), ya+(yb-ya)*result(1)/norm(v2)];
        end



        function [Elements, NM2, NodeTopo] = MatchingElement_TopoRelation_improve(obj, Nodes, NM,factor)
            Elements = zeros(1,2);
            [NM2, NodeTopo] = obj.Holes_Total(Nodes, NM, factor);
            EnumY = size(NM,1);
            EnumX = size(NM,2);
            eCount=0;
            for i = 2:max(max(NM2))

                tpNum=0;
                index=[];
                for j1 = 1:size(NodeTopo,1)
                    v1 = NodeTopo(j1,:);
                    if ismember(i,v1)
                        tpNum=tpNum+1;
                        index(tpNum) = j1;
                    end
                end

                if i==5
                    xy=0;
                end
                cc_total = perms([1:1:tpNum]);   % need total chooses
                %%% have a parameter to determine
                for ii=1:size(cc_total,1)
                    cc = cc_total(ii,:)';
                    [flag, Elements0] = MatchingElement_TopoRelation_iters_component(...
                        obj, Nodes, index, tpNum, cc);   %for checking
                    if flag==0
                        xy=ii;
                        Elements1 = Elements0;
                    end
                end


                %
                for j1 = 1:tpNum
                    flag=1;
                    tpii1 = Elements1(j1,1);
                    tpii2 = Elements1(j1,2);
                    for j2 = 1:size(Elements,1)
                        if sum(ismember([tpii1, tpii2],Elements(j2,:)))==2
                            flag=0;
                        end
                    end

                    if flag==1
                        eCount = eCount +1;
                        Elements(eCount,:) = [tpii1, tpii2];
                    end
                end

            end

        end

        function [Elements] = MatchingElement_TopoRelation_withoutHole(obj, Nodes, NM, NM2, NodeTopo)
            Elements = zeros(1,2);
            % factor = 2;
            % [NM2, NodeTopo]=Holes_Total(obj, Nodes, NM, factor);
            EnumY = size(NM,1);
            EnumX = size(NM,2);
            eCount=0;
            for i = 2:max(max(NM2))
                tpX=0;
                tpY=0;
                tpNum=0;
                for j1=1:EnumY
                    for j2=1:EnumX
                        if NM2(j1,j2)==i
                            tpX = tpX + j2;
                            tpY = tpY + j1;
                            tpNum = tpNum + 1;
                        end
                    end
                end
                tpX = tpX / tpNum;
                tpY = tpY / tpNum;


                tpNum=0;
                index=[];
                for j1 = 1:size(NodeTopo,1)
                    v1 = NodeTopo(j1,:);
                    if ismember(i,v1)
                        tpNum=tpNum+1;
                        index(tpNum) = j1;
                    end
                end

                vv = zeros(tpNum,3);
                for j1 = 1:tpNum
                    vv(j1,1) = Nodes(index(j1),1)-tpX;
                    vv(j1,2) = Nodes(index(j1),2)-tpY;
                    b = [0,1];
                    a = [vv(j1,1),vv(j1,2)];
                    if (a(1)*b(2)-a(2)*b(1))>0
                        vv(j1,3) = acos(sum(a.*b)/norm(a)/norm(b));
                    else
                        vv(j1,3) = 2*pi - acos(sum(a.*b)/norm(a)/norm(b));
                    end
                end

                vvtp = vv(:,3);
                sortIndex = [];
                for j1=1:tpNum % sorting the nodes
                    [aa,tpii1] = min(vvtp);
                    sortIndex(j1) = tpii1;
                    vvtp(tpii1)=0*vvtp(tpii1)+ 1e9 + j1;
                end

                for j1 = 1:tpNum
                    flag=1;
                    if j1~=tpNum
                        for j2 = 1:size(Elements,1)
                            tpii1 = sortIndex(j1);
                            tpii2 = sortIndex(j1+1);
                            if sum(ismember([index(tpii1), index(tpii2)],Elements(j2,:)))==2
                                flag=0;
                            end
                        end
                    else
                        for j2 = 1:size(Elements,1)
                            tpii1 = sortIndex(j1);
                            tpii2 = sortIndex(1);
                            if sum(ismember([index(tpii1), index(tpii2)],Elements(j2,:)))==2
                                flag=0;
                            end
                        end
                    end
                    if flag==1
                        eCount = eCount +1;
                        Elements(eCount,:) = [index(tpii1), index(tpii2)];
                    end
                end

            end
        end

        function [Elements] = MatchingElement_TopoRelation_iters(obj, Nodes, NM, NM2, NodeTopo)
            Elements = zeros(1,2);
            EnumY = size(NM,1);
            EnumX = size(NM,2);
            eCount=0;
            for i = 2:max(max(NM2))
                if i==5
                    xy=0;
                end

                tpNum=0;
                index=[];
                for j1 = 1:size(NodeTopo,1)
                    v1 = NodeTopo(j1,:);
                    if ismember(i,v1)
                        tpNum=tpNum+1;
                        index(tpNum) = j1;
                    end
                end

                cc_total = perms([1:1:tpNum]);   % need total chooses
                %%% have a parameter to determine
                for ii=1:size(cc_total,1)
                    cc = cc_total(ii,:)';
                    [flag, Elements0] = MatchingElement_TopoRelation_iters_component(...
                        obj, Nodes, index, tpNum, cc);   %for checking
                    if flag==0
                        Elements1 = Elements0;
                    end
                end
                %
                for j1 = 1:tpNum
                    flag=1;
                    tpii1 = Elements1(j1,1);
                    tpii2 = Elements1(j1,2);
                    for j2 = 1:size(Elements,1)
                        if sum(ismember([tpii1, tpii2],Elements(j2,:)))==2
                            flag=0;
                        end
                    end

                    if flag==1
                        eCount = eCount +1;
                        Elements(eCount,:) = [tpii1, tpii2];
                    end
                end

            end

        end

        function [flag, Elements] = MatchingElement_TopoRelation_iters_component(obj, Nodes, index, tpNum, cc)
            Elements = zeros(tpNum,2);
            for i =1:tpNum-1
                Elements(i,:) = [index(cc(i)),index(cc(i+1))];
            end
            Elements(tpNum,:) = [index(cc(tpNum)),index(cc(1))];

            %checkings
            flag=1;
            if size(unique(cc),1)~=tpNum
                flag=1;
            else
                vectors = zeros(tpNum,2);
                for i=1:tpNum
                    vectors(i,1) = Nodes(Elements(i,2),1)-Nodes(Elements(i,1),1);
                    vectors(i,2) = Nodes(Elements(i,2),2)-Nodes(Elements(i,1),2);
                end



                totalx = sum(vectors(:,1));
                totaly = sum(vectors(:,2));
                if abs(totalx+totaly) < 1e-3

                    flag2=0;

                    for i =1:tpNum
                        for j =1:tpNum
                            a0 = Nodes(Elements(i,1),2)-Nodes(Elements(i,2),2);
                            b0 = Nodes(Elements(i,2),1)-Nodes(Elements(i,1),1);
                            c0 = Nodes(Elements(i,1),1)*Nodes(Elements(i,2),2) - Nodes(Elements(i,2),1)*Nodes(Elements(i,1),2);
                            if j~=i
                                a1 = Nodes(Elements(j,1),2)-Nodes(Elements(j,2),2);
                                b1 = Nodes(Elements(j,2),1)-Nodes(Elements(j,1),1);
                                c1 = Nodes(Elements(j,1),1)*Nodes(Elements(j,2),2) - Nodes(Elements(j,2),1)*Nodes(Elements(j,1),2);
                                D = a0*b1-a1*b0;
                                xx = [Nodes(Elements(i,1),1),Nodes(Elements(i,2),1), Nodes(Elements(j,1),1),Nodes(Elements(j,2),1)];
                                yy = [Nodes(Elements(i,1),2),Nodes(Elements(i,2),2), Nodes(Elements(j,1),2),Nodes(Elements(j,2),2)];

                                if D~=0
                                    x =  (b0*c1 - b1*c0)/D;
                                    y = (a1*c0 - a0*c1)/D;
                                    indexTp = [Elements(i,1),Elements(i,2),Elements(j,1),Elements(j,2)];
                                    if size(unique(indexTp),2)~=3
                                        L1 = sqrt( a0^2+b0^2 );
                                        L2 = sqrt( a1^2+b1^2 );
                                        L1_1 = sqrt( (x - Nodes(Elements(i,1),1))^2 + (y - Nodes(Elements(i,1),2))^2 );
                                        L1_2 = sqrt( (x - Nodes(Elements(i,2),1))^2 + (y - Nodes(Elements(i,2),2))^2 );
                                        L2_1 = sqrt( (x - Nodes(Elements(j,1),1))^2 + (y - Nodes(Elements(j,1),2))^2 );
                                        L2_2 = sqrt( (x - Nodes(Elements(j,2),1))^2 + (y - Nodes(Elements(j,2),2))^2 );

                                        if (L1_1+L1_2 - L1)> 1e-2 && (L2_1+L2_2 - L2)>1e-2  %%%
                                            %                                             flag2=0;
                                        elseif abs((L1_1+L1_2 - L1))<1e-3 &&(L2_1+L2_2 - L2)>0.3*2*L2
                                        elseif (L1_1+L1_2 - L1)> 0.3*2*L1 && abs(L2_1+L2_2 - L2)<1e-3
                                        else
                                            flag2=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if flag2==0
                        flag=0;
                    end
                end
            end

        end

        function  [NM2, NodeTopo]=Holes_Total(obj, Nodes, NM, factor, SN)
            tp=1;
            temp_Mesh = NM;
            NodeTopo = zeros(size(Nodes,1),1000);
            EnumY = size(NM,1);
            EnumX = size(NM,2);
            ttt = factor;
            for i = 1 : EnumY
                for j =1:EnumX
                    flag=0;
                    if temp_Mesh(i,j) == 0
                        tp=tp+1;
                        [temp_Mesh,NodeTopo, flag] = obj.Holes(temp_Mesh,tp,i,j, Nodes, flag, NodeTopo, ttt, SN);
                    end

                    if flag==1
                        temp_Mesh(find(temp_Mesh==tp))=-1;
                        NodeTopo(find(NodeTopo==tp))=0;
                        tp=tp-1;
                    elseif size((find(temp_Mesh==tp)),1) < 2 % if holes meshes are small than this number, is not a hole
                        temp_Mesh(find(temp_Mesh==tp))=-1;
                        NodeTopo(find(NodeTopo==tp))=0;
                        tp=tp-1;
                    end

                end
            end

            NM2 = temp_Mesh;
            %                     figure;
            %                     image(temp_Mesh);
        end

        function  [TPM,NodeTopo, flag] = Holes(obj,TPM,tp,ii,jj, Nodes, flag, NodeTopo, ttt, SN)
            EnumY = size(TPM,1);
            EnumX = size(TPM,2);
            hh=ttt;
            TPM(ii,jj)=tp;
            for i1 = 1:size(Nodes,1)
                flagSN0 = 1;
                XX = Nodes(i1,1);
                yy = Nodes(i1,2);
                for ISN = 1:size(SN,1)
                    XX1 = SN(ISN,1);
                    yy1 = SN(ISN,2);
                    if XX==XX1 && yy ==yy1
                        flagSN0=1; %%%%%% DEFAULT IS 0 - SWITCH TO 1 SO THAT OUTSIDE SEGMENT CAN STILL BE DISTINCT
                    end
                end

                vv = (Nodes(i1,:) - [jj,ii]);
                LL = sqrt(vv*vv');

                if flagSN0==0
                    index = 1;
                    NodeTopo(i1,index) = 1;
                    if LL<=1
                        NodeTopo(i1,index+1) = tp;
                    end
                else
                    if LL<=hh
                        if all(NodeTopo(i1,:)==0)
                            index = 1;
                            NodeTopo(i1,index) = tp;
                        else
                            index = size(find(NodeTopo(i1,:) ~= 0),2);
                            NodeTopo(i1,index+1) = tp;
                        end
                    end
                end

            end

            % if ii == EnumY || ii ==1 || jj==EnumX || jj==1
            %     flag=1;
            % end

            if jj+1<=EnumX && TPM(ii,jj+1)==0
                [TPM,NodeTopo, flag] = Holes(obj,TPM,tp,ii,jj+1, Nodes, flag, NodeTopo,ttt,SN);
            end
            if jj-1>=1 && TPM(ii,jj-1)==0
                [TPM,NodeTopo, flag] = Holes(obj,TPM,tp,ii,jj-1, Nodes, flag, NodeTopo,ttt,SN);
            end
            if ii+1<=EnumY && TPM(ii+1,jj)==0
                [TPM,NodeTopo, flag] = Holes(obj,TPM,tp,ii+1,jj, Nodes, flag, NodeTopo,ttt,SN);
            end
            if ii-1>=1 && TPM(ii-1,jj)==0
                [TPM,NodeTopo, flag] = Holes(obj,TPM,tp,ii-1,jj, Nodes, flag, NodeTopo,ttt,SN);
            end


        end


        function [Elements] = MatchingElement_Fitting(obj, Nodes, NM, FilterWidth, Elements, NodeTopo)
            Nodes0 = Nodes;
            division=50; %default value = 50
            hh = FilterWidth;

            MnumY = size(NM,1);
            MnumX = size(NM,2);
            Nnum = size(Nodes0,1);
            count=0;

            tpNum=0;
            index=[];
            for j1 = 1:size(NodeTopo,1)
                v1 = sum(NodeTopo(j1,:));
                if v1==1 % 1 is the mark number, for special nodes corresponding to 'NodeTopo' information;
                    tpNum=tpNum+1;
                    index(tpNum) = j1;
                end
            end

            EEnum = size(Elements,1);
            for kkk = 1:tpNum
                fflag=1;
                NM0 = NM;
                NM1 =NM;
                N1 = Nodes0(index(1,kkk),:);

                tLL = [];
                sortSet = [];

                indexSet = [];
                tpCC=0;
                for i=1:Nnum
                    if i ~= index(1,kkk)
                        tpCC = tpCC+1;
                        indexSet(tpCC) = i;
                    end
                end

                for i = 1:size(indexSet,2)
                    N2 = Nodes0(indexSet(i),:);
                    tLL(i) = sqrt((N2-N1)*(N2-N1)');
                end
                for i = 1:size(indexSet,2)
                    tp = find(min(tLL) == tLL);
                    sortSet(i) = tp(1);
                    tLL(sortSet(i)) = max(tLL)*10;
                end


                for i = 1:size(indexSet,2)
                    N2 = Nodes0(indexSet(sortSet(i)),:);

                    if N2(1)==N1(1)
                        xx = ones(1,division+1) * N2(1);
                        yy = [N1(2):(N2(2)-N1(2))/division:N2(2)];
                    elseif N2(2)==N1(2)
                        xx = [N1(1):(N2(1)-N1(1))/division:N2(1)];
                        yy = ones(1,division+1) * N2(2);
                    else
                        xx = [N1(1):(N2(1)-N1(1))/division:N2(1)];
                        yy = [N1(2):(N2(2)-N1(2))/division:N2(2)];
                    end

                    xxN = round(xx);
                    yyN = round(yy);

                    flag = 0;
                    for j = 1: division+1
                        tp = 0;
                        for jj1 = xxN(j)-hh : xxN(j)+hh
                            for jj2 = yyN(j)-hh : yyN(j)+hh
                                if jj1>=1 && jj1<=MnumX && jj2>=1 && jj2<=MnumY
                                    tp = tp + NM0(jj2, jj1);
                                    %                                     if j ~=1 && j~=division+1
                                    NM1(jj2, jj1)=0;
                                    %                                     end
                                end
                            end
                        end
                        if tp>=1
                            flag = flag +1;
                        end
                    end

                    if fflag ==1
                        if flag/(division+1) > 0.5
                            EEnum = EEnum + 1;
                            index1 = find(ismember(Nodes,N1,'rows')==1);
                            index2 = find(ismember(Nodes,N2,'rows')==1);
                            Elements(EEnum,:) = [index1, index2];
                            NM0 = NM1;
                            fflag=0;
                        end
                    end
                end

                %      aaa=1
            end
        end


    end
end

