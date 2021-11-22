using DataFrames: DataFrame, select
using DataFramesMeta
using DataFramesMeta: @subset!, @transform!

struct x_move
    val::Int
end

struct y_move
    val::Int
end

# Change Head in x or y direction
function move_head(move::x_move)
    (snake.head[1] + move, snake.head[2])
end

function move_head(move::y_move)
    (snake.head[1], snake.head[2]+ move)
end

struct snake
    head::AbstractVector{Int}
    tail::AbstractVector{AbstractVector{Int}}
end

struct game
    grid_size::Int
    board::DataFrame
    snake::snake
end

function calc_node_adjacncy(r1::AbstractArray,c1::AbstractArray,r2::AbstractArray,c2::AbstractArray)
    (abs.(r1 .- r2) .== 1) .& (abs.(c1 .- c2) .== 0) .| (abs.(r1 .- r2) .== 0) .& (abs.(c1 .- c2) .== 1)
end

@transform!(adjacency_df, :adjacent = calc_node_adjacncy(:N1_Row, :N1_Col, :N2_Row, :N2_Col))

board_matrix = DataFrame(Row= rows, Col=cols, Snake = false, Apple = false)

