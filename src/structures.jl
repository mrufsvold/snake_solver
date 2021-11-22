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
    

    # Update the board
    function update_board(move)
        new_head = move_head(move)

        ### Check for fails ###
        # Try to find new location on board, error if out of bounds
        try 
            new_node = @subset(board, (:Row .== new_head[1]) .& (:Col .== new_head[2]))
        catch e
            error("Out of Bounds!")
        end

        # create new tail for snake movement
        new_tail = deepcopy(snake.tail)

        # If snake body already at this node, error
        if  new_node[1,:Snake] == 1 
            error("The snake ate itself!")
        # Check if snake got an apple
        elseif new_node[1, :Apple] == 1
            #Do snake gets longer, place new Apple
            push!(new_tail, snake.head)

        # Move the snake
        else
            #Do move snake
            popfirst!(new_tail)
            push!(new_tail, snake.head)
        







        