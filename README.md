# Snake Solver
![Snake Game Graphic](/snake_dvlfwCony2.jpeg)
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
