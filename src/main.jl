include("initial_setup.jl")
using DataFrames: DataFrame
using DataFramesMeta: @subset



function update_board(move::x_move, board::DataFrame)
    