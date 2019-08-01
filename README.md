# Ariadne.jl
A toolkit for playing around with mazes. And Julia. Mostly Julia though.

#### Style
Since there's not really a definitive style guide for Julia, most of the code tries to confirm to [Flux guidelines](http://www.juliaopt.org/JuMP.jl/v0.19.0/style/) since they make sense and are the most complete we have right now.

# Example
```
julia> f = (nrows, ncols) -> Grid(nrows, ncols) |>
       aldousbroder! |>
       Maze |>
       m -> dijkstra!(m, m[1,1]) |>
       totxt
#26 (generic function with 1 method)

julia> f(3,3)
+---+---+---+
| 0   1 | 4 |
+---+   +   +
| 3   2   3 |
+---+   +   +
| 4   3 | 4 |
+---+---+---+
3×3 Maze{:Γ}:
 (1, 1)  (1, 2)  (1, 3)
 (2, 1)  (2, 2)  (2, 3)
 (3, 1)  (3, 2)  (3, 3)
 ```