mutable struct HexGrid <: AbstractGrid{:Σ}
    cells::Matrix{Cell}
end

HexGrid(nrows, ncols) = cellmatrix(nrows, ncols) |> HexGrid

function neighbors(G::AbstractGrid{:Σ}, c::T) where {T<:AbstractCell}
    return T[]
end
