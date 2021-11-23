using Pkg
Pkg.activate("../snake_solver")
using Revise
include("initial_setup.jl")

snake_pos = [1,0,0,0]
apple_pos = [0,1,0,0]
initial_board[:, :Snake] = snake_pos
initial_board[:, :Apple] = apple_pos

initial_board

include("structures.jl")

move = x_move(1)
my_snake = snake([1,1])
my_game = game(initial_board,my_snake)

new_status = update_board(move, my_game)