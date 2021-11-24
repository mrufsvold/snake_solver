module Solution

using Revise
includet("../../structures.jl")
using Structures

function handler(current_game_state::game_state, response::Response)

    move::Union{x_move,y_move} = x_move(0)
    head = current_game_state.snake.head
    if head.row == 1 && head.col ==1
        move = y_move(-1)
    elseif head.row == 2 && head.col % 2 == 0 && head.col != response.grid_size
        move = x_move(1)
    elseif head.row == 1
        move = x_move(-1)
    elseif head.col % 2 == 0
        move = y_move(1)
    elseif head.row == response.grid_size && head.col % 2 == 1
        move = x_move(1)
    elseif head.col % 2 == 1
        move = y_move(-1)
    else
        error("You missed a case for $head")
    end

    response.move = move
    return response
end

end