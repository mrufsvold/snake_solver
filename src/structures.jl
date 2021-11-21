using DataFrames: DataFrame, select
using DataFramesMeta
using DataFramesMeta: @subset!, @transform!
import YAML
include("utils.jl")

config = YAML.load_file("config.yml")
grid_size = get(config, "grid_size", 3)
