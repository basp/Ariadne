mutable struct TriangleGrid <: AbstractGrid{:Δ}
    cells::Matrix{Cell}
end

TriangleGrid(nrows, ncols) = __cellmatrix(nrows, ncols) |> TriangleGrid
