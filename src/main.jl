using Pkg
Pkg.activate(".")
using Revise
includet("initial_setup.jl")
includet("structures.jl")
includet("visualize.jl")

my_game = create_initial_state()

moves = (y_move(-1), y_move(1))

game_record = []
for m in 1:6
    sleep(1)
    move = moves[m%2+1]
    @show move
    global my_game
    my_game = update_board(move, my_game)
    draw_window(my_game.snake.body,my_game.apple)
    push!(game_record, my_game)
end

