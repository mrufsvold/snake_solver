using DataFrames
using DataFramesMeta
using DataFramesMeta: @subset!, @transform!, @eachrow
using Random

##### Game Objects ######

struct Node
    """Represent a node on the board"""
    row::Int
    col::Int
end
    
struct snake
    """Represent the snake's location"""
    body::AbstractVector{Node}
    head::Node
end
snake(start_location::Node) = snake([start_location], start_location)
snake(body::AbstractVector{Node}) = snake(body, last(body))

struct GameOver
    status::Bool
    message::AbstractString
end

struct game_state
    board::DataFrame
    snake::snake
    apple::Node
    ate_apple::Bool
    game_over::GameOver  
end
    
###### Movement Options ########

struct x_move
    val::Int
    x_move(val::Int) = abs(val) <=1 ? new(val) : error("You can only move 1 spot at a time!")
end

struct y_move
    val::Int
    y_move(val) = abs(val) <=1 ? new(val) : error("You can only move 1 spot at a time!")
end

function move_head(move::x_move, head::Node)
    Node(head.row, head.col + move.val) 
end

function move_head(move::y_move, head::Node)
    Node(head.row - move.val, head.col)
end

#### Base Functions ####

function move_snake(move, current_snake::snake, ate_apple::Bool)
    new_head = move_head(move, current_snake.head)
    new_body = [deepcopy(current_snake.body); new_head]

    # Remove first element if we didn't eat an apple
    new_body = ate_apple ? new_body : new_body[2:end]
    snake(new_body, new_head)
end

function move_apple(current_board::DataFrame)
    game_over_status::GameOver = GameOver(false, "")
    # Delete Apple
    current_board[!,:Apple] .= 0

    # How many nodes don't have a snake?
    empty_node_count = nrow(
        current_board[(current_board[!,:Snake].== 0), :]
    )
    # Create a vector with one random 1 value
    new_apple_placement = zeros(empty_node_count)

    try
        new_apple_placement[rand(collect(1:empty_node_count))] = 1
    catch e 
        if isa(e, ArgumentError)
            return (current_board,GameOver(true, "You win!"))
        else
            error(e)
        end
    end

    # Add that vector to empty nodes
    current_board[(current_board[!,:Snake].== 0), :Apple] = new_apple_placement

    (current_board,game_over_status)
end

function update_board(move,current_game_state)
    
    new_snake::snake = move_snake(move, current_game_state.snake, current_game_state.ate_apple)
    new_board::DataFrame = deepcopy(current_game_state.board)
    apple::Node = deepcopy(current_game_state.apple)
    game_over_status::GameOver = GameOver(false,"")

    # Delete Snake tail on board
    if ! current_game_state.ate_apple
        snake_tail = current_game_state.snake.body[1]
        new_board[((new_board[!,:Row] .== snake_tail.row) .&
            (new_board[!,:Col] .== snake_tail.col)),:Snake] = [0] 
    end
        
    ### Check for fails ###
    # Try to find new location on board, error if out of bounds
    new_node_row = new_board[
        (new_board[!,:Row] .== new_snake.head.row) .& 
        (new_board[!,:Col] .== new_snake.head.col),:]
    if nrow(new_node_row) == 0
        return game_state(new_board, new_snake, apple, ate_apple,GameOver(true,"Out of Bounds!"))
    # If snake body already at this node, error
    elseif  new_node_row[1,:Snake] == 1
        return game_state(new_board, new_snake, apple, false,GameOver(true,"The snake ate itself!"))
    end

    # Add new_head to board
    new_board[
        ((new_board[!,:Row] .== new_snake.head.row) .& 
        (new_board[!,:Col] .== new_snake.head.col)),:Snake] = [1]
    
    # Check if snake got an apple
    ate_apple = new_node_row[1, :Apple] == 1
    
    if ate_apple
        (new_board,game_over_status) = move_apple(new_board)
        print(game_over_status)
        if ! game_over_status.status
            apple_loc = new_board[new_board[!,:Apple] .==1,[:Row, :Col]]
            apple = Node(apple_loc[1,:Row], apple_loc[1, :Col])
        end
    end

    game_state(new_board, new_snake, apple, ate_apple,game_over_status)
end

##### Admin Structs #####

mutable struct Response
    game_over::GameOver
    grid_size::Int
    adjacency_df::DataFrame
    move::Union{x_move,y_move}
    user_data::Dict
end
