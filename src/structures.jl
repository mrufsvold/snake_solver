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


struct game_state
    board::DataFrame
    snake::snake
    apple::Node
    ate_apple::Bool   
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
    println("y head move func")
    println(move)
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
    empty_node_count = nrow(
        current_board[(current_board[!,:Snake].== 0), :]
    )
    new_apple_placement = zeros(empty_node_count)
    new_apple_placement[rand(collect(1:empty_node_count))] = 1
    current_board[(current_board[!,:Snake].== 0), :Apple] = new_apple_placement
    current_board
end

function update_board(move,current_game_state)
    
    new_snake = move_snake(move, current_game_state.snake, current_game_state.ate_apple)
    new_board = deepcopy(current_game_state.board)
    apple = deepcopy(current_game_state.apple)
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
        error("Out of Bounds!")
    # If snake body already at this node, error
    elseif  new_node_row[1,:Snake] == 1
        # If the board is filled with snake, you win!
        if nrow(current_game_state.board) < length(new_snake.body)
            error("You win!")
        end
        error("The snake ate itself!")
    end
    
    # Check if snake got an apple
    ate_apple = new_node_row[1, :Apple] == 1
    
    if ate_apple
        new_board = move_apple(new_board)
        apple_loc = new_board[new_board[!,:Apple] .==1,[:Row, :Col]]
        apple = Node(apple_loc[1,:Row], apple_loc[1, :Col])
    end

    # Add new_head to board
    new_board[
        ((new_board[!,:Row] .== new_snake.head.row) .& 
        (new_board[!,:Col] .== new_snake.head.col)),:Snake] = [1]
    game_state(new_board, new_snake, apple, ate_apple)
end

##### Admin Structs #####

mutable struct Response
    game_over::GameOver
    grid_size::Int
    adjacency_df::DataFrame
    move::Union{x_move,y_move}
    user_data::Dict
end
        