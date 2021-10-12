# Maze-solver
## 64x64 synchronous verilog maze solver using the right hand rule

The purpose of this project is to familiarize with the Verilog syntax used for sequential circuit design

Initially every position in the maze can be 0 or 1. The way through the maze is marked with 0's, the walls with 1's and the path with 2's. The path follows the [right hand rule](https://en.wikipedia.org/wiki/Maze_solving_algorithm/).

### Signals used for the sequential circuit:
* clk - clock signal
* starting_row, starting_col - starting position of the maze
* row, col - position of the cell that needs to be read
* maze_in - contains the information at [row, col]
* maze_oe - output enable, activates maze_in signal
* maze_we - write enable, marks [row, col] as a path cell (with 2)
* done - maze exit was found

### Notes:
* From the starting position the maze can only be traversed in one direction.
* Maze caching is not allowed.
* The maze has only one exit.
* The maze is simply-connected.

### Example:
>test.data
```
starting_row=1
starting_col=1
1 1 1 1 1 1 1 1
1 0 1 1 0 0 0 1
1 0 1 1 0 1 0 1
1 0 1 1 0 1 0 1
1 0 0 0 0 1 0 1
1 1 0 1 1 1 0 1
1 1 0 1 0 0 0 1
1 1 1 1 0 1 1 1
```
>test.out
```
1 1 1 1 1 1 1 1
1 2 1 1 2 2 2 1
1 2 1 1 2 1 2 1
1 2 1 1 2 1 2 1
1 2 2 2 2 1 2 1
1 1 2 1 1 1 2 1
1 1 2 1 2 2 2 1
1 1 1 1 2 1 1 1
```
