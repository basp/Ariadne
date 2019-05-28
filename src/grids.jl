mutable struct Cell <: AbstractCell
    rowindex::Int
    colindex::Int  
    links::Set{Cell}
end

mutable struct Grid <: AbstractGrid{Gamma}
    cells::Matrix{Cell}
end

_cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

Cell(rowindex, colindex) = Cell(rowindex, colindex, Set{Cell}())

Grid(nrows, ncols) = _cellmatrix(nrows, ncols) |> Grid

rowindex(c) = c.rowindex
colindex(c) = c.colindex
links(c) = c.links

cells(g) = g.cells

function link!(a, b; reverse = true)
    push!(a.links, b)
    if reverse link!(b, a, reverse = false) end
    return a
end

function unlink!(a, b; reverse = true)
    pop!(a.links, b)
    if reverse unlink!(b, a, reverse = false) end
    return a
end

islinked(a, b) = b in links(a)

function show(io::IO, c::AbstractCell)
    print(io, "($(rowindex(c)), $(colindex(c)))")
end

include("./grids/gamma.jl")
