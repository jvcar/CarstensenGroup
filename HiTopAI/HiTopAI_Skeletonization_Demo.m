close all
clear
clc

warning('off','all') %DISABLE ALL WARNINGS - for JavaFrame stuff
addpath '_SnT_ClassFunctions'

data_length = 1;

plot_row = 1;
plot_col = 1;
c = 1;

factor = 2;

xyThin = Class_Thinning2D();

fname_image = sprintf('gt_topo_1.png');

data_topo = imread(fname_image);
data_topo_binary = imbinarize(data_topo);
data_topo_double = imcomplement(double(data_topo_binary));
temp = imresize(data_topo, 2, "nearest");
data_topo_scale_binary = imbinarize(temp);
data_topo_scale_double = imcomplement(double(data_topo_scale_binary));

fname_topo_scale = sprintf('topo_scale_1.tif');
imwrite(data_topo_scale_double,fname_topo_scale);

% close(figure(4),figure(5),figure(6),figure(7))

%Array indicate total connectedness of generated truss graph, 0 = not connected, 1 = connected
conn_truss = zeros(1,data_length);

%% 2. MAIN LOOP: PROCESS EACH TOPOLOGY
data_load = data_topo_scale_double;

%============PLOTTING 1 - BEGIN============%
figure(4)
subplot(plot_row,plot_col,c)
imagesc(data_load); colormap(flipud(gray));
axis equal tight off
title(['Data Scale '])
%============PLOTTING 1 - END==============%

%% 2.1. EDGE FEATURE DETECTION (SPECIAL NODES)
%Partition into 4 edges

%Top edge - work on column
%--FORMAT of top_edge_point is first row = row, second row = column
[~,col] = find(data_load(1,:));

if isempty(col) == 0

    check_consecutive = diff(col) == 1;

    num_features = length(find(check_consecutive == 0)) + 1; %Find total number of features along this edge

    final_point = zeros(1,num_features);
    top_edge_point = ones(2,num_features);

    start_loc = 1;
    end_loc = 1;

    for k = 1:num_features

        %Repeat this process [num_features] times

        if k == 1
            %Get first position along check_consecutive with value = 1
            start_loc = find(check_consecutive == 1,1);
        else
            start_loc = end_loc+1;
        end

        %Found first position that starts with 1, begin getting subarray of 1
        end_loc = start_loc + 1;

        if end_loc > length(check_consecutive)
            end_loc = end_loc - 1;
        end

        while check_consecutive(end_loc) == 1
            % end_loc = end_loc + 1;

            if end_loc == length(check_consecutive)
                break
            else
                end_loc = end_loc + 1;
            end
        end

        if start_loc == end_loc
            final_point(k) = start_loc;
        else
            final_point(k) = round((end_loc+start_loc)*0.5);
        end
        % end

        % top_edge_point(2,k) = col(1)+final_point(k); %format here is [row,column]
        top_edge_point(2,k) = col(final_point(k));

    end

else
    top_edge_point = [];
end

%Bottom edge - work on column
%--FORMAT of bottom_edge_point is first row = row, second row = column

[~,col] = find(data_load(64*factor,:));

if isempty(col) == 0

    check_consecutive = diff(col) == 1;

    num_features = length(find(check_consecutive == 0)) + 1; %Find total number of features along this edge

    final_point = zeros(1,num_features);
    % bottom_edge_point = 64*ones(2,num_features);

    bottom_edge_point = factor*64*ones(2,num_features);

    start_loc = 1;
    end_loc = 1;

    for k = 1:num_features

        %Repeat this process [num_features] times

        if k == 1
            %Get first position along check_consecutive with value = 1
            start_loc = find(check_consecutive == 1,1);
        else
            start_loc = end_loc+1;
        end

        %Found first position that starts with 1, begin getting subarray of 1
        end_loc = start_loc + 1;

        if end_loc > length(check_consecutive)
            end_loc = end_loc - 1;
        end

        while check_consecutive(end_loc) == 1
            % end_loc = end_loc + 1;

            if end_loc == length(check_consecutive)
                break
            else
                end_loc = end_loc + 1;
            end
        end

        if start_loc == end_loc
            final_point(k) = start_loc;
        else
            final_point(k) = round((end_loc+start_loc)*0.5);
        end
        % end

        bottom_edge_point(2,k) = col(final_point(k));

    end

else
    bottom_edge_point = [];
end

%Left edge - work on row
%--FORMAT of left_edge_point is first row = row, second row = column
[row,~] = find(data_load(:,1));

if isempty(row) == 0

    check_consecutive = diff(row) == 1;

    num_features = length(find(check_consecutive == 0)) + 1; %Find total number of features along this edge

    final_point = zeros(1,num_features);
    left_edge_point = ones(2,num_features);

    start_loc = 1;
    end_loc = 1;

    for k = 1:num_features

        %Repeat this process [num_features] times

        if k == 1
            %Get first position along check_consecutive with value = 1
            start_loc = find(check_consecutive == 1,1);
        else
            start_loc = end_loc+1;
        end

        %Found first position that starts with 1, begin getting subarray of 1
        end_loc = start_loc + 1;

        if end_loc > length(check_consecutive)
            end_loc = end_loc - 1;
        end

        while check_consecutive(end_loc) == 1
            % end_loc = end_loc + 1;

            if end_loc == length(check_consecutive)
                break
            else
                end_loc = end_loc + 1;
            end
        end

        if start_loc == end_loc
            final_point(k) = start_loc;
        else
            final_point(k) = round((end_loc+start_loc)*0.5);
        end
        % end

        left_edge_point(1,k) = row(final_point(k));

    end

else

    left_edge_point = [];
end

%Right edge - work on row
%--FORMAT of right_edge_point is first row = row, second row = column
% [row,col] = find(data_load(:,64));

[row,~] = find(data_load(:,64*factor));

if isempty(row) == 0

    check_consecutive = diff(row) == 1;

    num_features = length(find(check_consecutive == 0)) + 1; %Find total number of features along this edge

    final_point = zeros(1,num_features);
    right_edge_point = factor*64*ones(2,num_features);

    start_loc = 1;
    end_loc = 1;

    for k = 1:num_features

        %Repeat this process [num_features] times

        if k == 1
            %Get first position along check_consecutive with value = 1
            start_loc = find(check_consecutive == 1,1);
        else
            start_loc = end_loc+1;
        end

        %Found first position that starts with 1, begin getting subarray of 1
        end_loc = start_loc + 1;

        if end_loc > length(check_consecutive)
            end_loc = end_loc - 1;
        end

        while check_consecutive(end_loc) == 1
            % end_loc = end_loc + 1;

            if end_loc == length(check_consecutive)
                break
            else
                end_loc = end_loc + 1;
            end
        end

        if start_loc == end_loc
            final_point(k) = start_loc;
        else
            final_point(k) = round((end_loc+start_loc)*0.5);
        end
        % end

        right_edge_point(1,k) = row(final_point(k));

    end
else
    right_edge_point = [];
end

%When plotting the points, first arg is x coor, second arg is y coord, with
%origin starting from top left
%For the points: number of columns = number of points, first row = row
%coord, second row data = column coord


%==================PLOTTING 2 - BEGIN======================%
for i=1:size(top_edge_point,2)
    figure(4)
    subplot(plot_row,plot_col,c)
    hold on
    plot(top_edge_point(2,i),top_edge_point(1,i),'r+','MarkerSize',30);
    hold on
end

for i=1:size(bottom_edge_point,2)
    figure(4)
    subplot(plot_row,plot_col,c)
    hold on
    plot(bottom_edge_point(2,i),bottom_edge_point(1,i),'r+','MarkerSize',30);
    hold on
end

for i=1:size(left_edge_point,2)
    figure(4)
    subplot(plot_row,plot_col,c)
    hold on
    plot(left_edge_point(2,i),left_edge_point(1,i),'r+','MarkerSize',30);
    hold on
end

for i=1:size(right_edge_point,2)
    figure(4)
    subplot(plot_row,plot_col,c)
    hold on
    plot(right_edge_point(2,i),right_edge_point(1,i),'r+','MarkerSize',30);
    hold on
end
%==================PLOTTING 2 - END========================%

%% 2.2. IMAGE LOADING, BINARIZATION, AND INITIAL SIMPLIFICATION

% fname_topo_mat = sprintf('topo_%05d.tif',c);

fname_topo_mat = sprintf('topo_scale_1.tif');

% cd 'Topo_Scale'
FFF = imread(fname_topo_mat);
% cd ..

% Generating binary designs,first clear solid/void (0/1) binary designs based on TO density fields are generated
% BWW = im2bw(FFF,0.9); % Use 0.9 as the threshold
BWW = ~imbinarize(FFF);
BWWd = double(BWW);

xx = size(FFF,2);
yy = size(FFF,1);

BWW2=xyThin.SimplifyPoints(BWW,[xx,yy]);
BWW2=flipud(BWW2);

IM0 = 1-BWW2;
% IM0 = BWW2;

IM = IM0;

%===============PLOTTING 3 - BEGIN=================%
figure(6);
subplot(plot_row,plot_col,c);
imshow(flipud(BWW2))
%===============PLOTTING 3 - END===================%

%% 2.3. ITERATIVE THINNING WITH SPECIAL NODES PROTECTION

% Thinning
pd0 = sum(sum(IM0));
dd=1;
count=0;
IM2 = IM *0;

idx = 1;
total_special_nodes = size(top_edge_point,2) + size(bottom_edge_point,2) + size(left_edge_point,2) + size(right_edge_point,2);
specialNodes = zeros(total_special_nodes,2);

edge = factor*64 + 1;
%Assemble IM2 & specialNodes
for i=1:size(top_edge_point,2)
    IM2(edge-top_edge_point(1,i),top_edge_point(2,i)) = 1;
    specialNodes(idx,1) = top_edge_point(2,i); %xdir = col entry
    specialNodes(idx,2) = edge-top_edge_point(1,i); %ydir = row entry
    idx = idx + 1;
end

for i=1:size(bottom_edge_point,2)
    IM2(edge-bottom_edge_point(1,i),bottom_edge_point(2,i)) = 1;
    specialNodes(idx,1) = bottom_edge_point(2,i);
    specialNodes(idx,2) = edge-bottom_edge_point(1,i);
    idx = idx + 1;
end

for i=1:size(left_edge_point,2)
    IM2(edge-left_edge_point(1,i),left_edge_point(2,i)) = 1;
    specialNodes(idx,1) = left_edge_point(2,i);
    specialNodes(idx,2) = edge-left_edge_point(1,i);
    idx = idx + 1;
end

for i=1:size(right_edge_point,2)
    IM2(edge-right_edge_point(1,i),right_edge_point(2,i)) = 1;
    specialNodes(idx,1) = right_edge_point(2,i);
    specialNodes(idx,2) = edge-right_edge_point(1,i);
    idx = idx + 1;
end

while dd==1
    count=count+1;
    [NM, ~] = xyThin.Thin_improve( IM, 2,IM2);
    IM = NM;
    [NM, ~] = xyThin.Thin_improve( IM, 1,IM2);
    IM = NM;
    pd1 = sum(sum(NM));
    if pd1 == pd0
        dd=0;
    else
        pd0=pd1;
    end
end


%=================FILE SAVING 1-BEGIN===================%
% fname_topo_scale = sprintf('skel_scale_%05d.tif',c);
% imwrite(flipud(double(NM)*255),fname_topo_scale);
%
% temp = flipud(double(NM)*255);
% fname_skel_mat = sprintf("skel_scale_%05d.mat",c);
% save(fname_skel_mat,"temp");
%=================FILE SAVING 1-END=====================%

%===============PLOTTING 4 - BEGIN====================%
figure(7);
subplot(plot_row,plot_col,c);
imshow(flipud(1-NM)) %This here is equivalent to skeleton in MATLAB
%===============PLOTTING 4 - END======================%


%% 2.4. NODE AND ELEMENT EXTRACTION (TRUSS GENERATION)
% Node and bar extraction
Nodes = xyThin.DetermineNodes(NM,specialNodes);
[Nodes] = xyThin.SimplifyNodes(Nodes, 1.5*2, specialNodes); %1.5*2

try

    [~ , NM2, TopoRelation] = xyThin.MatchingElement_TopoRelation(Nodes, NM, 3, specialNodes); % (3) holes, large factor, loose control.

    TopoRelation_new = zeros(size(TopoRelation,1),max(TopoRelation(:)));

    %Get unique relations of which Hole ID (>0) a node lies at the border
    for v = 1:size(TopoRelation,1)
        node_relation_temp = TopoRelation(v,:);
        TopoRelation_new(v,1:length(unique(node_relation_temp(node_relation_temp>0)))) = unique(node_relation_temp(node_relation_temp>0));
    end

    %MODIFYING TOPORELATION_NEW SO THAT BOUNDARY NODE CAN ONLY BE
    %ASSOCIATED WITH 2 HOLES AT MOST (DUE TO 3 RADIUS SCAN) - BEGIN

    N = size(NM, 1);
    TopoRelation_new_Modified = TopoRelation_new;

    for node_id = 1:size(Nodes, 1)
        node_coord = Nodes(node_id, :); % [X, Y]

        X = round(node_coord(1)); % Column index
        Y = round(node_coord(2)); % Row index

        % Check if the node is on the domain boundary (1 or N)
        is_boundary_node = (X == 1 || X == N || Y == 1 || Y == N);

        if ~is_boundary_node
            % Skip interior nodes
            continue;
        end

        % Check how many unique hole IDs (excluding 0) this node is currently associated with
        current_hole_ids = unique(TopoRelation_new_Modified(node_id, :));
        current_hole_ids(current_hole_ids == 0) = []; % Remove padding zeros

        % The user request is to modify if it borders > 2 holes (IDs > 0).
        % Since Hole 1 is always the background, we look for > 2 unique IDs total.
        if length(current_hole_ids) <= 2
            % fprintf('Node %d ([%d, %d]) is a boundary node but borders 2 or fewer holes. No correction needed.\n', node_id, X, Y);
            continue; % No correction needed
        end

        % fprintf('Node %d ([%d, %d]) is a boundary node bordering %d holes. Applying correction logic...\n', node_id, X, Y, length(current_hole_ids));

        % --- 3. DETERMINE CHECK PIXELS ---
        check_R = [];
        check_C = [];

        % Priority 1: Left/Right boundary check (Column = 1 or N)
        if X == 1 || X == N
            % Check 1 above (R-1, C) and 1 below (R+1, C)
            % Ensure indices are within bounds [1, N]
            if Y > 1
                check_R = [check_R, Y-1];
                check_C = [check_C, X];
            end
            if Y < N
                check_R = [check_R, Y+1];
                check_C = [check_C, X];
            end
        end

        % Priority 2: Top/Bottom boundary check (Row = 1 or N) - Only if not already checked
        % (This primarily handles corner cases where X=1/N is false, or if the
        % node is strictly on the Top/Bottom boundary, e.g., Node 7: X=45, Y=50)
        if (X ~= 1 && X ~= N) && (Y == 1 || Y == N)
            % Check 1 left (R, C-1) and 1 right (R, C+1)
            if X > 1
                check_R = [check_R, Y];
                check_C = [check_C, X-1];
            end
            if X < N
                check_R = [check_R, Y];
                check_C = [check_C, X+1];
            end
        end

        % --- 4. EXTRACT NEW HOLE IDs ---
        new_hole_ids = [];
        for k = 1:length(check_R)
            r = check_R(k);
            c = check_C(k);

            hole_id = NM2(r, c);

            % Only store non-zero hole IDs and ensure uniqueness
            if hole_id > 0 && ~ismember(hole_id, new_hole_ids)
                new_hole_ids = [new_hole_ids, hole_id];
            end
        end

        % --- 5. UPDATE TopoRelation_new_Modified ---

        % Ensure the background hole (ID 1) is always included unless explicitly missing from the 2-pixel check
        if ~ismember(1, new_hole_ids)
            % Check the current association for Hole 1. If it was present, keep it.
            if ismember(1, current_hole_ids)
                new_hole_ids = [new_hole_ids, 1];
            end
        end

        % Sort and prepare the new row (Hole 1 is typically first)
        new_hole_ids = sort(new_hole_ids, 'descend'); % Put Hole 1 at the end for consistency with existing data

        % Pad with zeros to match the original column size
        num_cols = size(TopoRelation_new_Modified, 2);
        new_row = [new_hole_ids, zeros(1, num_cols - length(new_hole_ids))];
        new_row = new_row(1:num_cols); % Truncate if too long (shouldn't happen here)

        TopoRelation_new_Modified(node_id, :) = new_row;

        % fprintf('  Corrected association: %s\n', num2str(new_row));
    end

    TopoRelation_new = TopoRelation_new_Modified;

    %MODIFYING TOPORELATION_NEW SO THAT BOUNDARY NODE CAN ONLY BE
    %ASSOCIATED WITH 2 HOLES AT MOST (DUE TO 3 RADIUS SCAN) - END

    % N should be the size of the matrix, set it back to 50 for the simulated data
    N = size(NM, 1);

    Elements = []; % Initialize the output connection list
    node_proximity_threshold = 0.75; % Max pixel distance to be considered "at a node"

    % disp('Starting hole-guided truss element generation...');
    % disp('------------------------------------------------');

    % Find the max hole ID (class number)
    max_class_id = max(NM2(:));

    % --- 2. MAIN ITERATION LOOP (Iterate through Hole Classes) ---
    for class_id = 2:max_class_id
        % fprintf('Processing Hole Class ID: %d\n', class_id);

        % --- 2.1. Acquire Nodes associated with this Class Hole ---
        node_indices = find(any(TopoRelation_new == class_id, 2));

        if isempty(node_indices)
            % fprintf('  No nodes associated with Hole %d. Skipping.\n', class_id);
            continue;
        end

        nodes_indices_in_hole = node_indices;
        % fprintf('  Found %d nodes associated with this hole: %s\n', ...
        % length(node_indices), num2str(node_indices'));

        % --- 2.2. Segment the Skeleton for the current Hole ---
        [hole_segment, ~] = get_hole_skeleton_segment(NM, NM2, class_id);

        % --- 2.3. Find Endpoints and Junctions for Traversal ---

        % Endpoints in the skeleton segment
        endpoints_map = bwmorph(hole_segment, 'endpoints');
        [end_R, end_C] = find(endpoints_map);

        % Flag to indicate if this segment is topologically a loop (no endpoints)
        is_topological_loop = false;

        % Combine all critical points (endpoints and junctions) for traversal starting points
        critical_points_RC = unique([end_R, end_C], 'rows');

        if isempty(critical_points_RC) && length(nodes_indices_in_hole) >= 2 % Closed loop with no junctions/endpoints
            is_topological_loop = true;
            % fprintf('  Closed loop detected. Using the first node as the arbitrary starting point.\n');
            start_node_id = nodes_indices_in_hole(1);
            start_node_coord = Nodes(start_node_id, :);
            critical_points_RC = [round(start_node_coord(2)), round(start_node_coord(1))];
        elseif isempty(critical_points_RC)
            % fprintf('  No critical points found on the skeleton segment. Skipping connection.\n');
            continue;
        end

        % --- 2.4. Custom Path Traversal: Connecting Nodes (START NODE SELECTION & TRAVERSAL) ---

        % Fallback starting node ID
        start_node_id = nodes_indices_in_hole(1);

        % Check for boundary nodes to prioritize them
        boundary_nodes = [];
        for k = 1:length(nodes_indices_in_hole)
            current_node_id = nodes_indices_in_hole(k);
            node_coord = Nodes(current_node_id, :); % [X, Y]

            X = round(node_coord(1)); % Column index
            Y = round(node_coord(2)); % Row index

            % Check if the node is on the boundary (X=1 or X=N or Y=1 or Y=N)
            if X == 1 || X == N || Y == 1 || Y == N
                boundary_nodes = [boundary_nodes, current_node_id];
            end
        end

        if ~isempty(boundary_nodes)
            % Priority: Choose the first boundary node found as the starting point
            start_node_id = boundary_nodes(1);
            % fprintf('  Prioritizing boundary node %d as start point.\n', start_node_id);
        else
            % Fallback: Use the first node in the list
            % fprintf('  No boundary node found. Using default starting node %d.\n', start_node_id);
        end

        % Use the selected start_node_id to find the actual starting pixel on the skeleton segment
        start_R = round(Nodes(start_node_id, 2)); % Row (Y)
        start_C = round(Nodes(start_node_id, 1)); % Column (X)

        start_pixel = [];
        min_dist = inf;

        % Find a starting pixel on the hole_segment closest to the starting node
        for r = max(1, start_R-1):min(N, start_R+1)
            for c = max(1, start_C-1):min(N, start_C+1)
                if hole_segment(r, c) == 1
                    % Note: distance calculation needs to be consistent (using X,Y or R,C)
                    % Here, we use C (X) and R (Y) for distance calculation consistency
                    dist = sqrt((c - start_C)^2 + (r - start_R)^2);
                    if dist < min_dist
                        min_dist = dist;
                        start_pixel = [r, c];
                    end
                end
            end
        end

        if isempty(start_pixel)
            % fprintf('  Could not find a valid starting pixel on the segment. Skipping.\n');
            continue;
        end

        % Custom traversal function on the isolated segment
        [path_node_sequence] = traverse_segment_for_nodes(hole_segment, Nodes, nodes_indices_in_hole, start_pixel, node_proximity_threshold);

        % --- NEW MODIFICATION: Ensure loop closure for node sequence (if topological loop) ---
        if is_topological_loop && length(path_node_sequence) > 1
            first_node = path_node_sequence(1);
            last_node = path_node_sequence(end);

            if first_node ~= last_node
                % The traversal hit all nodes but did not explicitly register the starting node
                % as the last element. We force the loop closure here.
                path_node_sequence = [path_node_sequence, first_node];
                % fprintf('  -> Forced loop closure: Added start node %d to the end of the sequence.\n', first_node);
            else
                % fprintf('  -> Loop detected and correctly closed in sequence.\n');
            end
        end
        % -------------------------------------------------------------------------------------

        % --- 2.5. Generate Connections from Sequence ---

        if length(path_node_sequence) > 1
            % Determine if it's a closed loop (start == end) or open segment
            is_loop = (path_node_sequence(1) == path_node_sequence(end));

            % If loop, handle the last element connecting to the first implicitly
            num_connections = length(path_node_sequence);
            if ~is_loop
                num_connections = length(path_node_sequence) - 1;
            end

            for k = 1:num_connections
                N1_id = path_node_sequence(k);

                % Get the next node ID in the sequence, wrapping if it's a loop
                if is_loop
                    % mod(k, len) + 1 handles the wrap-around correctly for 1-based indexing
                    N2_id = path_node_sequence(mod(k, length(path_node_sequence)) + 1);
                else
                    % If open segment, don't wrap
                    if k == length(path_node_sequence)
                        continue; % End of open segment
                    end
                    N2_id = path_node_sequence(k+1);
                end

                % Skip self-connection (shouldn't happen here, but safety)
                if N1_id == N2_id
                    continue;
                end

                new_element = sort([N1_id, N2_id]);

                % Check for uniqueness before adding
                if ~is_element_unique(Elements, new_element)
                    % fprintf('  Connection %d-%d (already exists as %d-%d) skipped.\n', N1_id, N2_id, new_element(1), new_element(2));
                else
                    Elements = [Elements; new_element];
                    % fprintf('  New connection established: %d-%d\n', N1_id, N2_id);
                end
            end
        else
            % fprintf('  Only one or zero nodes found for this hole. No connections generated.\n');
        end
    end

    TrussElements = Elements;
    TrussNodes = Nodes;

    %===============PLOTTING 5 - BEGIN====================%
    % % plot generated truss-like structures
    PlotBasicTruss(TrussNodes, TrussElements, plot_row, plot_col, 1);
    %===============PLOTTING 5 - END======================%

    equal_row = all(TrussElements(:,1) == TrussElements,2);
    equal_row_index = find(equal_row);
    TrussElements(equal_row_index,:) = [];

    %% 2.6. POST-PROCESSING: NODE MERGING AND CONNECTIVITY CHECK
    %------------GO THROUGH TRUSSNODES AND
    %REMOVE POINTS TOO CLOSE TO EACH OTHER (MIN DIST = 5)
    %---KEY IS TO MERGE POINTS AND ALSO ADJUST INDEX OF NODES AND
    %CONNECTIVITY

    G = graph(TrussElements(:,1),TrussElements(:,2));
    bins = conncomp(G);

    temp_truss = TrussElements;
    temp_node = TrussNodes;
    node_dist = pdist2(TrussNodes,TrussNodes);
    node_dist_upper = triu(node_dist);
    min_dist = 15;
    [row,col] = find(node_dist_upper > 0 & node_dist_upper < min_dist); %Adjust min distance here
    operation_count = length(row);

    if all(bins == 1) && isempty(bins)~=1 && max(max(TrussElements)) == size(TrussNodes,1) %NEW && PART TO CONTROL CASES OF EMPTY TRUSS ELEMENTS
        % LAST CONDITION IS TO ACCOUNT FOR FULLY CONNECTED GRAPH BUT 1
        % FINAL NODE ALONE

        for p = 1:operation_count

            G = graph(temp_truss(:,1),temp_truss(:,2));
            node_dist = pdist2(temp_node,temp_node);
            node_dist_upper = triu(node_dist);
            [row,col] = find(node_dist_upper > 0 & node_dist_upper < min_dist); %Adjust min distance here

            if isempty(row)
                break
            end

            node1 = min(row(1),col(1));
            node2 = max(row(1),col(1));

            % node_conn_degree = degree(G);
            %
            % if node_conn_degree(node1) > node_conn_degree(node2)
            %     node_stay = node1;
            %     node_merge = node2;
            % else
            %     node_stay = node2;
            %     node_merge = node1;
            % end

            % --- 3. METRIC CALCULATION: VOID PIXEL CHECK ---

            % G is based on temp_truss, so it has the current connectivity

            % -----------------------------------------------------------------
            % Scenario 1: Node A merges into Node B (B stays, A is removed)
            % New connections are B -> Neighbors(A)
            % -----------------------------------------------------------------
            neighbors_1 = neighbors(G, node1);

            % Calculate Metric 1: Voids crossed by B -> Neighbors(A)
            metric1 = calculate_total_void_crossings(node2, neighbors_1, temp_node, data_load);

            % -----------------------------------------------------------------
            % Scenario 2: Node B merges into Node A (A stays, B is removed)
            % New connections are A -> Neighbors(B)
            % -----------------------------------------------------------------
            neighbors_2 = neighbors(G, node2);

            % Calculate Metric 2: Voids crossed by A -> Neighbors(B)
            metric2 = calculate_total_void_crossings(node1, neighbors_2, temp_node, data_load);

            % --- 4. DECISION LOGIC ---

            node_conn_degree = degree(G);

            if node_conn_degree(node1) > node_conn_degree(node2)
                node_stay = node1;
                node_merge = node2;
                % fprintf('  Tie-breaker: Node %d (Deg: %d) stays; Node %d (Deg: %d) merges.\n', ...
                % node_stay, node_conn_degree(node_stay), node_merge, node_conn_degree(node_merge));
            elseif node_conn_degree(node1) < node_conn_degree(node2)
                node_stay = node2;
                node_merge = node1;
            else
                if metric1 < metric2
                    % Scenario 1 chosen: A merges into B
                    node_stay = node1;
                    node_merge = node2;
                    % fprintf('  Merge Choice: Node %d stays (Metric: %d) vs Node %d merges (Metric: %d). Staying with %d.\n', ...
                    % node2, metric1, node1, metric2, node2);
                elseif metric2 <= metric1
                    % Scenario 2 chosen: B merges into A
                    node_stay = node2;
                    node_merge = node1;
                    % fprintf('  Merge Choice: Node %d merges (Metric: %d) vs Node %d stays (Metric: %d). Staying with %d.\n', ...
                    % node2, metric1, node1, metric2, node1);
                end
            end

            % a. Update Connectivity indices
            for i=1:size(temp_truss,1)
                for j=1:size(temp_truss,2)
                    if temp_truss(i,j) == node_merge
                        temp_truss(i,j) = node_stay;
                    end
                end
            end

            % b. Remove duplicate elements

            temp_truss = unique(temp_truss,'rows');

            % c. Remove elements that connect a node to itself

            equal_row = all(temp_truss(:,1) == temp_truss,2);
            equal_row_index = find(equal_row);
            temp_truss(equal_row_index,:) = [];

            % d. Ensure all elements are sorted (NodeID1 < NodeID2)

            for i=1:size(temp_truss,1)
                if temp_truss(i,1) > temp_truss(i,2)
                    [temp_truss(i,2),temp_truss(i,1)] = deal(temp_truss(i,1), temp_truss(i,2));
                end
            end

            % e. Remove the merged node's coordinates

            temp_node(node_merge,:) = [];

            % f. Re-index all connectivity elements higher than the merged

            for i=1:size(temp_truss,1)
                for j=1:size(temp_truss,2)
                    if temp_truss(i,j) > node_merge
                        temp_truss(i,j) = temp_truss(i,j) - 1;
                    end
                end
            end

        end

    end

    TrussElements = temp_truss;
    TrussNodes = temp_node;

catch
    % IF AN ERROR OCCUR DURING THINNING, SPAWN A PRE-DETERMINED
    % UNCONNECTED GRAPH
    TrussElements = [1 2];
    TrussNodes = [1 1;64 64;128 128];
end

%------------MODIFICATION: FEB/06/2025: END

%===============PLOTTING 6 - BEGIN====================%
% plot generated truss-like structures

% PlotBasicTruss(TrussNodes, TrussElements, plot_row, plot_col, c);

PlotBasicTruss_SkelBackground(TrussNodes, TrussElements, plot_row, plot_col, 1, NM);

PlotBasicTruss_TopoBackground(TrussNodes, TrussElements, plot_row, plot_col, 1, data_load);

%===============PLOTTING 6 - END======================%

% GENERATING graph object in MATLAB
G = graph(TrussElements(:,1),TrussElements(:,2));
bins = conncomp(G);
if all(bins == 1) && isempty(bins)~=1 && max(max(TrussElements)) == size(TrussNodes,1) %NEW && PART TO CONTROL CASES OF EMPTY TRUSS ELEMENTS
    conn_truss(1) = 1;
end

% set(get(groot, 'Children'), 'WindowState', 'maximized');

%Create plot of generated truss of just connected graphs
conn_truss_idx = find(conn_truss == 1);
conn_plot_row = floor(sqrt(length(conn_truss_idx)));
conn_plot_col = ceil(length(conn_truss_idx)/conn_plot_row);

fprintf('Successful skeletonizations out of non-blob topologies: %d / %d \n', length(conn_truss_idx), data_length);

fprintf('COMPLETED STEP 1 - SKELETONIZATION \n')

function PlotBasicTruss(Nodes, Elements, plot_row, plot_col, c)
Nodes4 = Nodes;
figure(5)
subplot(plot_row,plot_col,c);
axis equal on;
factor = 2;
xlim([0 factor*64]); ylim([0 factor*64]);
% set(gca,'Visible','off');
hold on
for tt = 1:size(Elements,1)
    plot( [Nodes4(Elements(tt,1),1),Nodes4(Elements(tt,2),1)],...
        [Nodes4(Elements(tt,1),2),Nodes4(Elements(tt,2),2)],'r-','LineWidth',3)
end
for tt = 1:size(Nodes4,1)
    plot( Nodes4(tt,1),Nodes4(tt,2),'b.', 'markersize', 40)
    text(Nodes4(tt,1),Nodes4(tt,2),num2str(tt),'Color','g','FontSize',14);
end

hold off
end

function PlotBasicTruss_SkelBackground(Nodes, Elements, plot_row, plot_col, c, NM)
Nodes4 = Nodes;
figure(19)
subplot(plot_row,plot_col,c);
axis equal tight on;
factor = 2;
xlim([0 factor*64]); ylim([0 factor*64]);
% set(gca,'Visible','off');
hold on
for tt = 1:size(Elements,1)
    plot( [Nodes4(Elements(tt,1),1),Nodes4(Elements(tt,2),1)],...
        [Nodes4(Elements(tt,1),2),Nodes4(Elements(tt,2),2)],'r-','LineWidth',3)
end
for tt = 1:size(Nodes4,1)
    plot( Nodes4(tt,1),Nodes4(tt,2),'b.', 'markersize', 40)
    text(Nodes4(tt,1),Nodes4(tt,2),num2str(tt),'Color','g','FontSize',14);
end

h = imagesc((1-NM),'AlphaData',0.3); colormap(gray);
uistack(h,'bottom');

hold off
end

function PlotBasicTruss_TopoBackground(Nodes, Elements, plot_row, plot_col, c, data_load)
Nodes4 = Nodes;
figure(18)
subplot(plot_row,plot_col,c);
axis equal tight on;
factor = 2;
xlim([0 factor*64]); ylim([0 factor*64]);
% set(gca,'Visible','off');
hold on
for tt = 1:size(Elements,1)
    plot( [Nodes4(Elements(tt,1),1),Nodes4(Elements(tt,2),1)],...
        [Nodes4(Elements(tt,1),2),Nodes4(Elements(tt,2),2)],'r-','LineWidth',3)
end
for tt = 1:size(Nodes4,1)
    plot( Nodes4(tt,1),Nodes4(tt,2),'b.', 'markersize', 40)
    text(Nodes4(tt,1),Nodes4(tt,2),num2str(tt),'Color','g','FontSize',14);
end

h = imagesc(flipud(data_load),'AlphaData',0.3); colormap(flipud(gray));

uistack(h,'bottom');

hold off
end



function PlotBasicTruss_Single(Nodes, Elements)
Nodes4 = Nodes;
close(figure(10))
figure(10)
% subplot(plot_row,plot_col,c);
axis equal on;
factor = 2;
xlim([0 factor*64]); ylim([0 factor*64]);
% set(gca,'Visible','off');
hold on
for tt = 1:size(Elements,1)
    plot( [Nodes4(Elements(tt,1),1),Nodes4(Elements(tt,2),1)],...
        [Nodes4(Elements(tt,1),2),Nodes4(Elements(tt,2),2)],'r-','LineWidth',3)
end
for tt = 1:size(Nodes4,1)
    plot( Nodes4(tt,1),Nodes4(tt,2),'b.', 'markersize', 40)
    text(Nodes4(tt,1),Nodes4(tt,2),num2str(tt),'Color','g','FontSize',14);
end

hold off
end

function PlotBasicTruss_Single_2(Nodes, Elements)
Nodes4 = Nodes;
% close(figure(10))
% figure(10)
% subplot(plot_row,plot_col,c);
axis equal on;
factor = 2;
xlim([0 factor*64]); ylim([0 factor*64]);
% set(gca,'Visible','off');
hold on
for tt = 1:size(Elements,1)
    plot( [Nodes4(Elements(tt,1),1),Nodes4(Elements(tt,2),1)],...
        [Nodes4(Elements(tt,1),2),Nodes4(Elements(tt,2),2)],'r-','LineWidth',3)
end
for tt = 1:size(Nodes4,1)
    plot( Nodes4(tt,1),Nodes4(tt,2),'b.', 'markersize', 40)
    text(Nodes4(tt,1),Nodes4(tt,2),num2str(tt),'Color','g','FontSize',14);
end

hold off
end

% -------------------------------------------------------------------------
% HELPER FUNCTION 1: SEGMENT THE SKELETON
% Isolates the part of NM that borders the specific hole_id.
% -------------------------------------------------------------------------
function [hole_segment, border_mask] = get_hole_skeleton_segment(NM, NM2, hole_id)
[R, C] = size(NM);
border_mask = false(R, C);

% Find all pixels that belong to the skeleton (NM=1)
[skel_R, skel_C] = find(NM == 1);

for k = 1:length(skel_R)
    r = skel_R(k);
    c = skel_C(k);

    % Check if this skeleton pixel has a neighbor belonging to the hole_id in NM2
    if has_hole_neighbor(NM2, r, c, hole_id)
        border_mask(r, c) = true;
    end
end

% The segment is the intersection of the skeleton (NM) and the border mask
hole_segment = NM & border_mask;
end

% -------------------------------------------------------------------------
% HELPER FUNCTION 2: TRAVERSE ISOLATED SEGMENT AND RECORD NODES (MODIFIED FOR PRIORITY)
% Walks the segment starting from a pixel near the start node and records
% the sequence of nodes encountered, prioritizing cardinal movement.
% -------------------------------------------------------------------------
function node_sequence = traverse_segment_for_nodes(hole_segment, AllNodes, node_indices, start_pixel_RC, thresh)
node_sequence = [];
visited_pixels = false(size(hole_segment));
[R, C] = size(hole_segment);

current_R = start_pixel_RC(1);
current_C = start_pixel_RC(2);

prev_R = -1; % Not used in this simplified walk, but kept for clarity
prev_C = -1;

max_steps = sum(hole_segment(:)); % TOTAL NUMBER OF STEPS POSSIBLE IN SEGMENT
step_count = 0;

% Initial check at the start pixel
[found_id, is_node] = is_near_node([current_C, current_R], AllNodes, node_indices, thresh);
if is_node
    node_sequence = [node_sequence, found_id];
end
visited_pixels(current_R, current_C) = true;

while step_count < max_steps + 1
    step_count = step_count + 1;
    found_next = false;

    % ---------------------------------------------
    % 1. PRIORITY SEARCH: CARDINAL (R, L, U, D)
    % dr/dc pairs for (0,1), (0,-1), (1,0), (-1,0)
    % ---------------------------------------------
    cardinal_dr = [ 0,  0, 1, -1];
    cardinal_dc = [ 1, -1, 0,  0];

    for i = 1:4
        dr = cardinal_dr(i);
        dc = cardinal_dc(i);

        next_R = current_R + dr;
        next_C = current_C + dc;

        % Check validity (bounds, segment, unvisited)
        if next_R >= 1 && next_R <= R && next_C >= 1 && next_C <= C && ...
                hole_segment(next_R, next_C) == 1 && ~visited_pixels(next_R, next_C)

            % Found the next cardinal pixel
            prev_R = current_R;
            prev_C = current_C;
            current_R = next_R;
            current_C = next_C;
            visited_pixels(current_R, current_C) = true;
            found_next = true;

            % Node Detection and Loop Check
            [found_id, is_node] = is_near_node([current_C, current_R], AllNodes, node_indices, thresh);
            if is_node && (isempty(node_sequence) || node_sequence(end) ~= found_id)
                node_sequence = [node_sequence, found_id];
                % fprintf('  -> Segment walk found Node %d at [%d, %d] (Cardinal)\n', found_id, current_C, current_R);

                % If we hit the starting node again, the loop is closed.
                if length(node_sequence) > 1 && found_id == node_sequence(1)
                    return;
                end
            end

            break; % Exit Cardinal search loop
        end
    end

    % ---------------------------------------------
    % 2. SECONDARY SEARCH: DIAGONAL (Only if no cardinal step was found)
    % ---------------------------------------------
    if ~found_next
        % dr/dc pairs for (1,1), (1,-1), (-1,1), (-1,-1)
        diagonal_dr = [ 1,  1, -1, -1];
        diagonal_dc = [ 1, -1,  1, -1];

        for i = 1:4
            dr = diagonal_dr(i);
            dc = diagonal_dc(i);

            next_R = current_R + dr;
            next_C = current_C + dc;

            % Check validity (bounds, segment, unvisited)
            if next_R >= 1 && next_R <= R && next_C >= 1 && next_C <= C && ...
                    hole_segment(next_R, next_C) == 1 && ~visited_pixels(next_R, next_C)

                % Found the next diagonal pixel
                prev_R = current_R;
                prev_C = current_C;
                current_R = next_R;
                current_C = next_C;
                visited_pixels(current_R, current_C) = true;
                found_next = true;

                % Node Detection and Loop Check
                [found_id, is_node] = is_near_node([current_C, current_R], AllNodes, node_indices, thresh);
                if is_node && (isempty(node_sequence) || node_sequence(end) ~= found_id)
                    node_sequence = [node_sequence, found_id];
                    % fprintf('  -> Segment walk found Node %d at [%d, %d] (Diagonal)\n', found_id, current_C, current_R);

                    % If we hit the starting node again, the loop is closed.
                    if length(node_sequence) > 1 && found_id == node_sequence(1)
                        return;
                    end
                end

                break; % Exit Diagonal search loop
            end
        end
    end

    if ~found_next
        % Traversal stopped (segment end)
        break;
    end
end
end
% -------------------------------------------------------------------------
% HELPER FUNCTION 3: NEIGHBOR CHECK
% Checks if the pixel at (r, c) has a neighbor with the given hole_id in NM2.
% -------------------------------------------------------------------------
function is_neighbor = has_hole_neighbor(NM2, r, c, hole_id)
[R, C] = size(NM2);
is_neighbor = false;
for dr = [-1, 0, 1]
    for dc = [-1, 0, 1]
        if dr == 0 && dc == 0
            continue;
        end
        nr = r + dr;
        nc = c + dc;
        if nr >= 1 && nr <= R && nc >= 1 && nc <= C
            if NM2(nr, nc) == hole_id
                is_neighbor = true;
                return;
            end
        end
    end
end
end
% -------------------------------------------------------------------------
% HELPER FUNCTION 4: NODE PROXIMITY
% Checks if a skeleton pixel (p_coord) is near any of the nodes associated
% with the current hole.
% -------------------------------------------------------------------------
function [found_id, is_node] = is_near_node(p_coord, AllNodes, node_indices, thresh)
% p_coord is [X, Y], AllNodes are [X, Y]
is_node = false;
found_id = -1;

for k = 1:length(node_indices)
    node_id = node_indices(k);
    node_coord = AllNodes(node_id, :);

    dist = sqrt(sum((p_coord - node_coord).^2));

    if dist <= thresh
        is_node = true;
        found_id = node_id;
        return;
    end
end
end
% -------------------------------------------------------------------------
% HELPER FUNCTION 5: ELEMENT UNIQUENESS
% Checks if the element [N1, N2] or [N2, N1] already exists in Elements.
% -------------------------------------------------------------------------
function is_unique = is_element_unique(Elements, new_element_sorted)
is_unique = true;
if isempty(Elements)
    return;
end
% Check if the sorted element matches any row in Elements
if any(all(Elements == new_element_sorted, 2))
    is_unique = false;
end
end

% -------------------------------------------------------------------------
% HELPER FUNCTION 1: CALCULATE VOID PIXEL CROSSINGS
% -------------------------------------------------------------------------
function total_void_count = calculate_total_void_crossings(stay_node_idx, merge_node_neighbors, Nodes, data_load)
% Calculates the total number of void pixels (0 in data_load) crossed by
% new connections from stay_node to all neighbors of the merged node.

total_void_count = 0;
N_size = size(data_load, 1);

if isempty(merge_node_neighbors)
    return;
end

% Coordinates of the node that stays
P_stay = Nodes(stay_node_idx, :); % [X, Y]

for k = 1:length(merge_node_neighbors)
    neighbor_idx = merge_node_neighbors(k);

    % Skip if the neighbor is the stay node itself (shouldn't happen with graph, but safety)
    if neighbor_idx == stay_node_idx
        continue;
    end

    % Coordinates of the neighbor
    P_neighbor = Nodes(neighbor_idx, :); % [X, Y]

    % Simplified Line Drawing (Linear Interpolation for pixel check)
    % This is a substitute for a full Bresenham's algorithm, ensuring
    % that all pixels along the line are checked.

    X1 = P_stay(1); Y1 = P_stay(2);
    X2 = P_neighbor(1); Y2 = P_neighbor(2);

    dist = sqrt((X2-X1)^2 + (Y2-Y1)^2);

    % Number of steps (resolution) for pixel check, based on distance
    % A resolution of 1 step per pixel ensures accurate check
    num_steps = max(2, ceil(dist));

    x_coords = linspace(X1, X2, num_steps);
    y_coords = linspace(Y1, Y2, num_steps);

    % Convert floating-point coordinates to integer matrix indices [Row, Col]
    % Remember: MATLAB indexing is (Row, Col), which corresponds to (Y, X)
    R_indices = round(y_coords);
    C_indices = round(x_coords);

    % Ensure indices are within bounds [1, N_size]
    R_indices = max(1, min(N_size, R_indices));
    C_indices = max(1, min(N_size, C_indices));

    % Check pixels along the line
    for i = 1:length(R_indices)
        r = R_indices(i);
        c = C_indices(i);

        % data_load(r, c) == 0 means void
        if data_load(r, c) == 0
            total_void_count = total_void_count + 1;
        end
    end
end
end

