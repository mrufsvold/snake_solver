using DataFrames: DataFrame, select
using DataFramesMeta
using DataFramesMeta: @subset!, @transform!
import YAML
include("utils.jl")

config = YAML.load_file("config.yml")
grid_size = get(config, "grid_size", 3)

rows = repeat_items(1:grid_size,grid_size)
cols = repeat(1:grid_size,grid_size)

adjacency_df = DataFrame(N1_Row= repeat(rows,grid_size^2),
                        N1_Col = repeat(cols, grid_size^2),
                        N2_Row= repeat_items(rows,grid_size^2),
                        N2_Col= repeat_items(cols,grid_size^2)
                        )

# Remove identity pairs from node comparisons
@subset!(adjacency_df, .!((:N1_Row .== :N2_Row) .& (:N1_Col .== :N2_Col)))

function calc_node_adjacncy(r1::AbstractArray,c1::AbstractArray,r2::AbstractArray,c2::AbstractArray)
    (abs.(r1 .- r2) .== 1) .& (abs.(c1 .- c2) .== 0) .| (abs.(r1 .- r2) .== 0) .& (abs.(c1 .- c2) .== 1)
end

@transform!(adjacency_df, :adjacent = calc_node_adjacncy(:N1_Row, :N1_Col, :N2_Row, :N2_Col))

