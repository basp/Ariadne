module Ariadne

using Luxor

export Grid
export Maze
export PolarGrid
export binarytree!
export colidx
export dijkstra
export dijkstra!
export distances
export distances!
export east
export grid
export hasdistances
export haspath
export islinked
export link!
export links
export neighbors
export north
export path
export path!
export pathto
export rowidx
export sidewinder!
export south
export totxt
export topng
export unlink!
export west

mutable struct Cell
    rowidx::Int
    colidx::Int
    links::Set{Cell}
end

abstract type AbstractDistances <: AbstractDict{Cell,Int} end
abstract type AbstractGrid <: AbstractMatrix{Cell} end
abstract type AbstractMaze <: AbstractGrid end

Cell(rowidx, colidx) = Cell(rowidx, colidx, Set{Cell}())

Base.show(io::IO, cell::Cell) = print(io, "($(rowidx(cell)), $(colidx(cell)))")

rowidx(cell) = cell.rowidx
colidx(cell) = cell.colidx
links(cell) = cell.links

islinked(::Nothing, _) = false
islinked(_, ::Nothing) = false
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

cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

struct Distances <: AbstractDistances
    root::Cell
    cells::Dict{Cell,Int}
end

function Distances(root)
    cells = Dict{Cell,Int}()
    cells[root] = 0
    frontier = [root]
    while !isempty(frontier)
        newfrontier = empty([], Cell)
        for cell in frontier
            for link in links(cell)
                if link in keys(cells)
                    continue
                end
                cells[link] = cells[cell] + 1
                push!(newfrontier, link)
            end
        end
        frontier = newfrontier
    end
    return Distances(root, cells)
end

Base.length(d::Distances) = length(cells(d))

Base.iterate(d::Distances) = iterate(cells(d))
Base.iterate(d::Distances, s) = iterate(cells(d), s)

Base.get(d::Distances, key, default) = get(cells(d), key, default)

Base.minimum(d::Distances) = findmin(cells(d))
Base.maximum(d::Distances) = findmax(cells(d))

root(d::Distances) = d.root
cells(d::Distances) = d.cells

dijkstra(root) = root |> Distances

function pathto(d, goal)
    current = goal
    path = Distances(root(d), Dict{Cell,Int}())
    cells(path)[current] = d[current]
    while current != root(d)
        for link in links(current)
            if d[link] < d[current]
                cells(path)[link] = d[link]
                current = link
                break
            end
        end
    end
    return path
end

mutable struct Maze <: AbstractMaze
    grid::AbstractGrid
    distances::Union{AbstractDistances,Nothing}
    path::Union{AbstractDistances,Nothing}
end

Maze(g) = Maze(g, nothing, nothing)

grid(m::Maze) = m.grid
distances(m::Maze) = m.distances
path(m::Maze) = m.path

Base.size(m::Maze) = size(grid(m))
Base.getindex(m::Maze, r, c) = getindex(grid(m), r, c)

function distances!(m::Maze, d)
    m.distances = d
    return m
end

function path!(m::Maze, p)
    m.path = p
    return m
end

function dijkstra!(m::Maze)
    distances!(m, dijkstra(first(m)))
    return m
end

hasdistances(m::Maze) = !isnothing(distances(m))
haspath(m::Maze) = !isnothing(path(m))

include("gamma.jl")
include("theta.jl")
include("algorithms.jl")

end # module
