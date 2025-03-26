function mat = table_to_matrix(t)
%Converts the parquet formatted data into a [125 125 13] matrix.
    mat = zeros([125 125 13]);
    xjet = t.X_jet;
    for ch=1:13
        cell = xjet{:}(ch);
        subcell = cell{:};
        img = zeros(125);
        for i=1:125
            img(:,i) = cell2mat(subcell(i));
        end
        mat(:,:,ch) = img;
    end
end

