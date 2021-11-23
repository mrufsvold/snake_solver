using DataFrames
using DataFramesMeta
using DataFramesMeta: @subset!, @transform!, @eachrow
using Random



###### Movement Options
struct x_move
    val::Int
end

struct y_move
    val::Int
end

function move_head(move::x_move, head::AbstractVector{Int})
    [head[1], head[2]+ move.val]    
end

function move_head(move::y_move, head::AbstractVector{Int})
    [head[1] + move.val, head[2]]
end


##### Game Objects ######

struct snake
    body::AbstractVector{AbstractVector{Int}}
    head::AbstractVector
    head::NamedTuple
end

snake(start_location::AbstractVector{Int}) = snake([start_location], start_location)
snake(body::AbstractVector{AbstractVector{Int}}) = snake(body, last(body))

struct game
    board::DataFrame
    snake::snake    
end

#### Base Functions ####

function update_board(move,game)
    new_head = move_head(move, game.snake.head)

    ### Check for fails ###
    # Try to find new location on board, error if out of bounds
    try 
        new_node = @subset(game.board, (:Row .== new_head[1]) .& (:Col .== new_head[2]))
    catch e
        error("Out of Bounds!")
    end
    new_node = @subset(game.board, (:Row .== new_head[1]) .& (:Col .== new_head[2]))
    println(new_node)
    println(typeof(new_node))
    println(new_node[1, :Apple])
    # create new body and board to record snake movement
    new_body::AbstractVector{AbstractVector{Int}} = deepcopy(game.snake.body)
    new_board::DataFrame = deepcopy(game.board)

    # If snake body already at this node, error
    if  new_node[1,:Snake] == 1 
        error("The snake ate itself!")

    # Check if snake got an apple
    elseif new_node[1, :Apple] == 1
        push!(new_body, new_head)
        @transform!(new_board, :Snake = [[x.Row,x.Col] in new_body for x in copy.(eachrow([:Row, :Col]))])
        
        # Construct a new apple column with the apple in a random empty node
        empty_node_count = nrow(@subset(new_board, :Snake .== 0))
        apple_placement = rand(collect(1:empty_node_count))
        apple_col = []
        n = 1
        for is_snake in new_board[:,:Snake]
            if is_snake == 0 && n == apple_placement
                push!(apple_col, 1)
                apple_col = [apple_col; zeros(Int, length(new_board)-length(apple_col))]
                break
            end
            n += 1
            push!(apple_col, 0)
        end
        new_board[:,:Apple] = apple_col

    # Move the snake
    else
        #Do move snake
        popfirst!(new_body)
        push!(new_body, new_head)
        @transform!(new_board, :Snake = [[x.Row,x.Col] in new_body for x in copy.(eachrow([:Row, :Col]))])
    end
    new_snake::snake = snake(new_body)
    return game(new_board,new_snake)
end




        