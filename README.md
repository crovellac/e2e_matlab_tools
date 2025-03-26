# e2e_matlab_tools
A collection of MATLAB scripts for use in the End-to-End physics project.
These scripts can take parquet data created by MLAnalyzer.

## Demos
- `plot_images.mlx` reads a parquet file and displays images showing the subdetector channels in an event.
- `plot_graphs.mlx` converts events to graph representation and then displays the graph.
- `convert_dataset.m` converts the entire E2E parquet file into a new parquet file of graph data. It is designed to produce parquet files in a format compatible with Shravan Chaudhari's [Boosted Top Graph Neural Network training](https://github.com/Shra1-25/GSoC2021_BoostedTopJets/blob/main/Training/BoostedTopGNN_training.ipynb).

## Functions
- `table_to_matrix.m` reshapes an event from a parquet file into a 125 by 125 by 13 matrix. This is an easier way of looking at the event images.
- `table_to_graph.m` constructs a graph from the event image, with features and adjacency information. 
