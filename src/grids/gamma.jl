mutable struct Grid <: AbstractGrid{:Γ}
    cells::Matrix{Cell}
end

Grid(nrows, ncols) =  __cellmatrix(nrows, ncols) |> Grid                        

function neighbors(g::AbstractGrid{:Γ}, c)
    n = north(g, c)
    s = south(g, c)
    w = west(g, c)
    e = east(g, c)
    return filter(!isnothing, [n, e, s, w])
end 