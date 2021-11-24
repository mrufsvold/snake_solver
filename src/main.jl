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
while ! response.game_over.status
    global current_game_status
    global response
    sleep(0.01)
    response = handler(current_game_status, response)
    current_game_status = update_board(response.move, current_game_status)
    draw_window(current_game_status.snake.body,current_game_status.apple)
    # push!(game_record, current_game_status)
end

print(response.game_over.status)

