mutable struct Cell <: AbstractCell
    rowidx::Int
    colidx::Int
    links::Set{Cell}
end

mutable struct Maze{T} <: AbstractMaze{T}
    grid::AbstractGrid{T}
    distances::Union{AbstractDistances,Nothing}
    path::Union{AbstractDistances,Nothing}
end

cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

Cell(rowidx, colidx) = Cell(rowidx, colidx, Set{Cell}())

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

include("./grids/delta.jl")
include("./grids/gamma.jl")
include("./grids/sigma.jl")
include("./grids/theta.jl")
