mutable struct TriangleGrid <: AbstractGrid{:Δ}
    cells::Matrix{Cell}
end

TriangleGrid(nrows, ncols) = cellmatrix(nrows, ncols) |> TriangleGrid
