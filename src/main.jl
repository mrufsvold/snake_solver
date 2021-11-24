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


func_intro = """
function run_the_game(current_game_status, response)

    include("Solutions/slow_and_steady/main.jl")
    handler = Solution.handler
    game_record = []
    function while_wrapper(current_game_status, response)
        while ! response.game_over.status

"""
sleeptime = 1 / get_mps()
sleep_func = "       sleep($sleeptime)"

func_conclusion = """

            response = handler(current_game_status, response)
            current_game_status = update_board(response.move, current_game_status)
            draw_window(current_game_status.snake.body,current_game_status.apple)
            # push!(game_record, current_game_status)
        end
        print(response.game_over.status)
    end
    while_wrapper(current_game_status, response)
end
"""

func_str = func_intro * sleep_func * func_conclusion

@show func_str
func_parsed = Meta.parse(func_str)
@show func_parsed
run_the_game = Meta.eval(func_parsed)
@show run_the_game
run_the_game(current_game_status, response)
# function run_the_game()
#     game_record = []
#     while ! response.game_over.status
#         global current_game_status
#         global response
#         sleep(0.01)
#         response = handler(current_game_status, response)
#         current_game_status = update_board(response.move, current_game_status)
#         draw_window(current_game_status.snake.body,current_game_status.apple)
#         # push!(game_record, current_game_status)
#     end
#     print(response.game_over.status)
# end
# run_the_game()
