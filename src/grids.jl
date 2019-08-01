mutable struct Cell <: AbstractCell
    rowindex::Int
    colindex::Int  
    links::Set{Cell}
end

mutable struct Grid <: AbstractGrid{Gamma}
    cells::Matrix{Cell}
end

mutable struct PolarGrid <: AbstractGrid{Theta}
    rows::Vector{Vector{Cell}}
    wrap::Bool
end

mutable struct HexGrid <: AbstractGrid{Sigma}
    cells::Matrix{Cell}
end

mutable struct TriangleGrid <: AbstractGrid{Delta}
    cells::Matrix{Cell}
end

mutable struct Maze{T<:Tesselation} <: AbstractMaze{T}
    grid::AbstractGrid{T}
    distances::Union{AbstractDistances,Nothing}
    path::Union{AbstractDistances,Nothing}
end

Cell(rowindex, colindex) = Cell(rowindex, colindex, Set{Cell}())

_cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

Grid(nrows, ncols) = _cellmatrix(nrows, ncols) |> Grid

function PolarGrid(ncircles; wrap = true)
    rows = [Cell[] for r in 1:ncircles]
    rowheight = 1 / ncircles
    rows[1] = [Cell(1, 1)]
    for row in 2:ncircles
        radius = (row - 1) / ncircles
        circ = 2π * radius
        prevcount = length(rows[row - 1])
        cellwidth = circ / prevcount
        ratio = round(cellwidth / rowheight) |> Int
        ncells = prevcount * ratio
        rows[row] = [Cell(row, col) for col in 1:ncells]
    end
    return PolarGrid(rows, wrap)
end

HexGrid(nrows, ncols) = _cellmatrix(nrows, ncols) |> HexGrid

TriangleGrid(nrows, ncols) = _cellmatrix(nrows, ncols) |> TriangleGrid

function Maze(g::AbstractGrid{T}) where {T<:Tesselation}
    return Maze{T}(g, nothing, nothing)
end

rowindex(c::AbstractCell) = c.rowindex
colindex(c::AbstractCell) = c.colindex

cells(g::AbstractGrid) = g.cells
cells(m::AbstractMaze) = cells(grid(m))

links(::Nothing) = Set{Cell}()
links(c::AbstractCell) = c.links

iswrapped(g::PolarGrid) = g.wrap
iswrapped(g::AbstractGrid) = false

grid(m::AbstractMaze) = m.grid
distances(m::AbstractMaze) = m.distances
path(m::AbstractMaze) = m.path

function setdistances(m::AbstractMaze, v::AbstractDistances)
    m.distances = v
    return m
end

function setpath(m::AbstractMaze, v::AbstractDistances)
    m.path = v
    return m
end

islinked(::Nothing, _) = false
islinked(_, ::Nothing) = false
islinked(a, b) = b in links(a)

function link!(a, b; reverse = true)
    push!(a.links, b)
    reverse && link!(b, a, reverse = false)
    return a
end

function unlink!(a, b; reverse = true)
    pop!(a.links, b)
    reverse && unlink!(b, a, reverse = false)
    return a
end

isdeadend(c::AbstractCell) = length(links(c)) == 1
isunlinked(c::AbstractCell) = isempty(links(c))

deadends(g::AbstractGrid) = filter(isdeadend, g)
unlinked(g::AbstractGrid) = filter(isunlinked, g)

show(io::IO, c::AbstractCell) = print(io, "($(rowindex(c)), $(colindex(c)))")
    
include("./grids/gamma.jl")
