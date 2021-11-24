using DataFrames
using DataFramesMeta
using Random
import YAML
using Revise
includet("utils.jl")
includet("structures.jl")

grid_size = get_grid_size()

rows = repeat_items(1:grid_size,grid_size)
cols = repeat(1:grid_size,grid_size)

function create_adjacency_df()
    adjacency_df = DataFrame(N1_Row= repeat(rows,grid_size^2),
                            N1_Col = repeat(cols, grid_size^2),
                            N2_Row= repeat_items(rows,grid_size^2),
                            N2_Col= repeat_items(cols,grid_size^2)
                            )
    
    # Remove identity pairs from node comparisons
    @subset!(adjacency_df, .!((:N1_Row .== :N2_Row) .& (:N1_Col .== :N2_Col)))
    
    function calc_node_adjacency(r1::AbstractArray,c1::AbstractArray,r2::AbstractArray,c2::AbstractArray)
        (abs.(r1 .- r2) .== 1) .& (abs.(c1 .- c2) .== 0) .| (abs.(r1 .- r2) .== 0) .& (abs.(c1 .- c2) .== 1)
    end
    
    @transform!(adjacency_df, :adjacent = calc_node_adjacency(:N1_Row, :N1_Col, :N2_Row, :N2_Col))
end

function create_initial_state()
    initial_board = DataFrame(Row= rows, Col=cols, Snake = 0, Apple = 0)
    initial_apple = rand(collect(1:grid_size^2))
    initial_snake = (initial_apple + rand(collect(1:grid_size^2 - 2))) % grid_size^2 + 1
    # Add apple and snake to board
    initial_board[initial_apple, :Apple] = 1
    initial_board[initial_snake, :Snake] = 1
    # Create Snake
    snake_r::Int = initial_board[initial_board[!,:Snake] .== 1, :Row][1]
    snake_c::Int = initial_board[initial_board[!,:Snake] .== 1, :Col][1]
    i_snake = snake(Node(snake_r, snake_c))
    apple_loc = initial_board[initial_board[!,:Apple].==1,[:Row, :Col]]
    apple = Node(apple_loc[1,:Row], apple_loc[1, :Col])
    game_state(initial_board, i_snake, apple, false, GameOver(false, ""))
end