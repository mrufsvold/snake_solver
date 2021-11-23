using Pkg
Pkg.activate(".")
using Revise
includet("initial_setup.jl")
includet("structures.jl")

my_game = create_initial_state()

game_record = []
for _ in 1:4
    move = x_move(1)
    global my_game
    my_game = update_board(move, my_game)
    push!(game_record, my_game)
end

