using Pkg
Pkg.activate(".")
using Revise
using DataFrames
includet("initial_setup.jl")
includet("structures.jl")
includet("visualize.jl")
includet("utils.jl")
includet("Solutions/slow_and_steady/main.jl")

adjacency_df = create_adjacency_df()

current_game_status = create_initial_state()

response = Response(
    GameOver(false,""),
    get_grid_size(), #grid_size
    adjacency_df, #adjacency_df
    x_move(0), #move
    Dict() #user_data
)

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

