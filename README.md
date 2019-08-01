# Ariadne.jl
A toolkit for playing around with mazes. And Julia. Mostly Julia though.

# Example
```
julia> f = (nrows, ncols) -> Grid(nrows, ncols) |>
       aldousbroder! |>
       Maze |>
       m -> dijkstra!(m, rand(m)) |>
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