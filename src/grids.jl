mutable struct Cell <: AbstractCell
    rowidx::Int
    colidx::Int
    links::Set{Cell}
end

mutable struct Grid <: AbstractGrid{:Γ}
    cells::Matrix{Cell}
end

mutable struct TriangleGrid <: AbstractGrid{:Δ}
    cells::Matrix{Cell}
end

mutable struct HexGrid <: AbstractGrid{:Σ}
    cells::Matrix{Cell}
end

mutable struct PolarGrid <: AbstractGrid{:Θ}
    rows::Vector{Vector{Cell}}
    wrap::Bool
end

mutable struct Maze{T} <: AbstractMaze{T}
    grid::AbstractGrid{T}
    distances::Union{AbstractDistances,Nothing}
    path::Union{AbstractDistances,Nothing}
end

__cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

Cell(rowidx, colidx) = Cell(rowidx, colidx, Set{Cell}())

Grid(nrows, ncols) =  __cellmatrix(nrows, ncols) |> Grid                        

TriangleGrid(nrows, ncols) = __cellmatrix(nrows, ncols) |> TriangleGrid

HexGrid(nrows, ncols) = __cellmatrix(nrows, ncols) |> HexGrid

function PolarGrid(ncircles; wrap = true)
    rows = [Cell[] for r in 1:ncircles]
    rowheight = 1 / ncircles
    rows[1] = [Cell(1, 1)]
    for row in 2:ncircles
        radius = (row - 1) / ncircles
        circ = 2π * radius
        prevcount = length(rows[row - 1])
        cellwidth = circ / prevcount
        ratio = round(Int, cellwidth / rowheight)
        ncells = prevcount * ratio
        rows[row] = [Cell(row, col) for col in 1:ncells]
    end
    return PolarGrid(rows, wrap)
end

Maze(G) = Maze(G, nothing, nothing)

rowidx(c) = c.rowidx
colidx(c) = c.colidx
links(c) = c.links

show(io::IO, c::AbstractCell) = print(io, "($(rowidx(c)), $(colidx(c)))")

cells(G::AbstractGrid) = G.cells
cells(M::AbstractMaze) = cells(grid(M))

grid(M) = M.grid
distances(M) = M.distances
path(M) = M.path

function setdistances(M, D) 
    M.distances = D
    return M
end

function setpath(M, P)
    M.path = P
    return M
end

iswrapped(x) = false
iswrapped(M::AbstractMaze) = iswrapped(grid(M))

islinked(a, b) = b in links(a)

function link!(a, b, reverse = true)
    push!(links(a), b)
    reverse && link!(b, a, false)
    return a
end

function unlink!(a, b, reverse = true)
    pop!(links(a), b)
    reverse && unlink!(b, a, false)
    return a
end

size(g::AbstractGrid) = size(cells(g))

function getindex(g::AbstractGrid, r, c)
    nrows, ncols = size(g)
    roob = r < 1 || r > nrows
    coob = c < 1 || c > ncols
    (roob || coob) && return nothing
    return getindex(cells(g), r, c)
end

north(g, c) = g[rowidx(c) - 1, colidx(c)]
south(g, c) = g[rowidx(c) + 1, colidx(c)]
west(g, c) = g[rowidx(c), colidx(c) - 1]
east(g, c) = g[rowidx(c), colidx(c) + 1]

include("./grids/gamma.jl")
include("./grids/theta.jl")
include("./grids/sigma.jl")