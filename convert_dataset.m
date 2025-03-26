pds_raw = parquetDatastore("HToEleEle_m100To5115_pT20To150_ctau0To3_eta0To1p4_RHAnalyzer_validation_0.parquet");
reset(pds_raw);
new_graph_pds = transform(pds_raw,@table_to_graph);
preview(new_graph_pds)

writeall(new_graph_pds,"./graphdata/",OutputFormat="parquet")

%Steps:                               
% 1. Convert raw data to images             
% 2. Convert images to graphs               
% 3. Train GraphSAGE network                
% 4. Run GraphSAGE network                