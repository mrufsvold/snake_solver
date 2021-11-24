# Snake Solver
<figure><img src="https://static.thenounproject.com/png/226219-200.png"><figcaption>Snake Game Graphic</figcaption></figure>

## Introduction

Snake Solver is a tool for experimenting with different algorithmic solutions to
the game of Snake.

This project was inspired by the YouTuber AlphaPhoenix and his 2020 video
[How to Win SNake: The UNKILLABLE Snake AI](https://www.youtube.com/watch?v=TOpBcfbAgPg).
In his video, AlphaPhoenix challenges his audience to develop an algorithm that can
beat Snake as fast as possible. 

This challenge poses a number of interesting questions related to Graph Theory, 
but it also offers a number of programming learning opportunities especially
for someone new to a language.

From vizualizations to function creation to data structures to parallelization, 
solving Snake requires a broad range of fundamental and complex skills.

## Setup
To run this project:
1. [Install Julia](https://julialang.org/downloads/)
2. Clone the repository from Github
3. Use `git branch solution/my-solution-name`
4. Update `config.yml` options (see below)
5. Open the Julia REPL at the root directory of this project
6. Run `include("source/main.jl")`

## Contributing
### Core Code Contributions
If you would like to contribute to the core code, please use the following git branch
naming conventions for:
- `features/my-new-feature`
- `bugfix/problem-to-fix`
- `refactor/my-refactoring`

### Solution Contributions
If you would like to submit a solution, please use `solution/my-solution-name` for your git branch.

Your solution must be in its own subdirectory `/src/Solutions/my-solution-dir`. 
In that directory, you need at least one file with at least one function.
This function must accept these arguments:
- `current_game::game_state` (see `src/structures.jl`)
- `adjacency_df::DataFrame` (see `src/initial_setup.jl`)

The function needs to return either an `x_move()` or `y_move()` with a value of `1` or `-1` (see `structures.jl`).

In `config.yml`, update the `solution_function` values to match your solution.
Now, run `src/main.jl` and it will use the config to read in your solution and see
if it works!

## Configuration Options
|   Key             |   Val Type    |   Description       |
|   ------          |   --------    |  -----------        |
|   grid_size       |   Int         | The length of each side of the grid |
|   sub_dir         |   str         | The solution directory to run     |
|   file_name       |   str         | The solution main file to run |
|   function_name   |   str         | The solution main function to run |

## Development Roadmap 
### 1.1 Nicities
- [ ] Display color customization in Config
- [ ] Comparison Reports after running multiple solutions


### 1.0 Multiple Reports
- [ ] Setup report to accept multiple games from an outer Loop
- [ ] Report min, max, and tertiles for game length and snake length
- [ ] Parallelize running multiple games

### 0.5 Loop analysis
- [ ] Report number of moves, length of snake
- [ ] has wait function to set fps
- [ ] Quality of life improvements

### 0.3 Create Naive Solution
- [x] Pass game state into solver
- [x] gracefully handle error
- [x] create function that takes game state
- [x] Simple logic for 1 hamiltonian path
- [x] makes turns to follow path forever

### 0.2 Visualizing Game
- [x] Essential functions for writing to screen
- [x] Generate view from grid matrix
- [x] Add to main loop
- [x] Add optional wait
- [x] Optimize

### 0.1 Basic Functions
- [x] Instantiate game state
- [x] Move Snake and Apple
- [x] Update Board values
- [x] Check for collisions
- [x] Save each state so the game can be replayed and analyzed


