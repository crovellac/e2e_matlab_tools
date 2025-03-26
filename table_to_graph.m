function tab = table_to_graph(t)
   
    %Convert the data into a [125 125 13] matrix
    mat = table_to_matrix(t);
    tab = table;
    
    %HCAL resample to avoid repeating nodes
    hcal_frame = zeros(125);
    hcal_mat = mat(:,:,5); 
    for x=1:122
       for y=1:122
            if mod(x-3,5) == 0
                if mod(y-3,5) == 0
                    hcal_frame(x,y) = sum(hcal_mat((x-2):(x+2),(y-2):(y+2)),"all");
                end
            end
        end
    end
    mat(:,:,5) = hcal_frame;
   
    %Initialize the feature arrays
    nonzero_rows = single([]);
    nonzero_cols = single([]);
    track_pt = single([]);
    dZ = single([]);
    d0 = single([]);
    ecal = single([]);
    hcal = single([]);
    bpix1 = single([]);
    bpix2 = single([]);
    bpix3 = single([]);
    bpix4 = single([]);
    tib1 = single([]);
    tib2 = single([]);
    tob1 = single([]);
    tob2 = single([]);

    %Construct the feature arrays.
    %If any i,j pixel has a nonzero value in any channel,
    %then that pixel becomes a node, and we fill in our
    %feature arrays with the pixel value from each channel.
    for i=1:125
        for j=1:125
            has_nonzero = false;
            for k=1:13
                if mat(i,j,k) > 0.001
                    has_nonzero = true;
                end
            end
            if has_nonzero
                nonzero_rows = [nonzero_rows; i];
                nonzero_cols = [nonzero_cols; j];
                track_pt = [track_pt; mat(i,j,1)];
                dZ = [dZ; mat(i,j,2)];
                d0 = [d0; mat(i,j,3)];
                ecal = [ecal; mat(i,j,4)];
                hcal = [hcal; mat(i,j,5)];
                bpix1 = [bpix1; mat(i,j,6)];
                bpix2 = [bpix2; mat(i,j,7)];
                bpix3 = [bpix3; mat(i,j,8)];
                bpix4 = [bpix4; mat(i,j,9)];
                tib1 = [tib1; mat(i,j,10)];
                tib2 = [tib2; mat(i,j,11)];
                tob1 = [tob1; mat(i,j,12)];
                tob2 = [tob2; mat(i,j,13)];
            end
        end
    end
    row = nonzero_rows;
    col = nonzero_cols;
    
    %From the i,j values, construct the adjacency matrix by
    %using Euclidean distance to the k-nearest neigboring pixels.
    k = 15;
    knns = knnsearch([row,col],[row,col],'K',k+1,'Distance','Euclidean');
    A = zeros(length(knns));
    for n=1:length(knns)
        for m=2:k+1
            A(knns(n,1),knns(n,m)) = 1;
        end
    end
    A = A + eye(size(A)); %Add the identity matrix so that every node connects to itself
    g = digraph(A);


    %Insert the feature arrays into the table
    tab.coords0 = {(nonzero_rows - 63)/62}; %Normalized
    tab.coords1 = {(nonzero_cols - 63)/62}; %Normalized
    tab.edge_index_from = {int64(g.Edges.EndNodes(:,2)-1)};
    tab.edge_index_to = {int64(g.Edges.EndNodes(:,1)-1)};
    tab.pT = {track_pt};
    tab.dz = {dZ};
    tab.d0 = {d0};
    tab.ECAL = {ecal};
    tab.HCAL = {hcal};
    tab.BPIX1 = {bpix1};
    tab.BPIX2 = {bpix2};
    tab.BPIX3 = {bpix3};
    tab.BPIX3 = {bpix4};
    tab.TIB1 = {tib1};
    tab.TIB2 = {tib2};
    tab.TOB1 = {tob1};
    tab.TOB2 = {tob2};

    %Also put other quantities from the parquet into the table

    class_raw = t(:,'y'); %Class (contains a->ee)
    tab.y = class_raw{:,:}; 

    am_raw = t(:,'am'); %Generated mass for a
    tab.am = am_raw{:,:};

    apt_raw = t(:,'apt'); %Generated pT for a
    tab.apt = apt_raw{:,:};

    ieta_raw = t(:,'ieta'); %Jet ieta
    tab.ieta = ieta_raw{:,:};

    iphi_raw = t(:,'iphi'); %Jet ihpi
    tab.iphi = iphi_raw{:,:};
end
