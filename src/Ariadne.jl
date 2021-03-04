module Ariadne

using Luxor: Drawing, Point, background, finish, setcolor, setline, rect, line, preview

export CartesianGrid
export Distances
export Maze
export colindex, rowindex
export dijkstra, dijkstra!
export pathto, pathto!
export links
export islinked
export link!, unlink!
export distances, path
export setdistances!, setpath!
export north, south, west, east
export entrance, getexit
export neighbors
export aldousbroder!
export binarytree!
export sidewinder!
export render

mutable struct Cell
    rowindex::Int
    colindex::Int
    links::Set{Cell}
end

Cell(rowindex, colindex) = Cell(rowindex, colindex, Set{Cell}())

Base.show(io::IO, c::Cell) = print(io, "Cell($(c.rowindex), $(c.colindex))")

rowindex(c) = c.rowindex
colindex(c) = c.colindex

links(::Nothing) = Set{Cell}()
links(x::Cell) = x.links

function link!(a, b, reverse=true)
    push!(a.links, b)
    if reverse link!(b, a, false) end
end

function unlink!(a, b, reverse=true)
    pop!(a.links, b, nothing)
    if reverse unlink!(b, a, false) end
end

islinked(::Nothing, b) = false
islinked(a, ::Nothing) = false
islinked(a, b) = b in a.links

mutable struct CartesianGrid <: AbstractMatrix{Cell}
    cells::Matrix
end

_cellmatrix(nrows, ncols) = [Cell(r, c) for r in 1:nrows, c in 1:ncols]

CartesianGrid(nrows, ncols) = _cellmatrix(nrows, ncols) |> CartesianGrid

Base.size(g::CartesianGrid) = size(g.cells)

function Base.getindex(g::CartesianGrid, row, col)
    nrows, ncols = size(g)
    rowoob = row < 1 || row > nrows
    coloob = col < 1 || col > ncols
    (rowoob || coloob) && return nothing
    return getindex(g.cells, row, col)
end

north(g, c) = g[c.rowindex - 1, c.colindex]
south(g, c) = g[c.rowindex + 1, c.colindex]
west(g, c) = g[c.rowindex, c.colindex - 1]
east(g, c) = g[c.rowindex, c.colindex + 1]

function neighbors(g, c)
    n = north(g, c)
    s = south(g, c)
    w = west(g, c)
    e = east(g, c)
    return filter(!isnothing, [n, s, w, e])
end

mutable struct Distances <: AbstractDict{Cell,Int}
    root::Cell
    cells::Dict{Cell,Int}
end

Base.length(d::Distances) = length(d.cells)

Base.iterate(d::Distances) = iterate(d.cells)
Base.iterate(d::Distances, s) = iterate(d.cells, s)

Base.get(d::Distances, key, default) = get(d.cells, key, default)

Base.minimum(d::Distances) = findmin(d.cells)
Base.maximum(d::Distances) = findmax(d.cells)

root(d::Distances) = d.root
cells(d::Distances) = d.cells

function dijkstra(root)
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

pathto(::Nothing, goal) = nothing

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

mutable struct Maze <: AbstractMatrix{Cell}
    grid::AbstractMatrix{Cell}
    distances::Union{Nothing,Distances}
    entrance::Union{Nothing,Cell}
    exit::Union{Nothing,Cell}
    path::Union{Nothing,Distances}
end

Maze(grid) = Maze(
    grid, 
    nothing, 
    first(grid),
    nothing, 
    nothing)

Base.size(m::Maze) = size(grid(m))
Base.getindex(m::Maze, row, col) = getindex(grid(m), row, col)

grid(m) = m.grid
distances(m) = m.distances
entrance(m) = m.entrance
getexit(m) = m.exit
path(m) = m.path

function setentrance!(m, e)
    m.entrance = e
    return m
end

function setexit!(m, e)
    m.exit = e
    return m
end

function setdistances!(m, d)
    m.distances = d
    return m
end

function setpath!(m, p)
    m.path = p
    return m
end

dijkstra!(m, root) = setdistances!(m, dijkstra(root))
pathto!(m, goal) = setpath!(m, pathto(distances(m), goal))

function longestpath!(m)
    root = first(m)
    d = dijkstra(root)
    ignored, start = findmax(d)
    d = dijkstra(start)
    ignored, exit = findmax(d)
    setdistances!(m, d)
    setpath!(m, pathto(d, exit))
    setentrance!(m, start)
    setexit!(m, exit)
end

function binarytree!(m::AbstractMatrix{Cell})
    for cell in m
        neighbors = Set{Cell}()
        n = north(m, cell)
        e = east(m, cell)
        isnothing(n) || push!(neighbors, n)
        isnothing(e) || push!(neighbors, e)
        if !isempty(neighbors)
            target = rand(neighbors)
            link!(cell, target)
        end
    end
    return m
end

function sidewinder!(m::AbstractMatrix{Cell})
    for row in eachrow(m)
        run = Set{Cell}()
        for cell in row
            push!(run, cell)
            atebound = isnothing(east(m, cell))
            atnbound = isnothing(north(m, cell))
            closerun = atebound || (!atnbound && iszero(rand((0, 1))))
            if closerun
                target = rand(run)
                n = north(m, target)
                !isnothing(n) && link!(target, n)
                empty!(run)
            else
                link!(cell, east(m, cell))
            end
        end
    end
    return m
end

function aldousbroder!(m::AbstractMatrix{Cell})
    cell = rand(m)
    nrows, ncols = size(m)
    unvisited = nrows * ncols - 1
    while unvisited > 0
        neighbor = rand(neighbors(m, cell))
        if isempty(links(neighbor))
            link!(cell, neighbor)
            unvisited -= 1
        end
        cell = neighbor
    end
    return m
end

function _bgcolor(m::Maze, cell::Cell;
    renderpath = false,
    renderdistances = false,
    renderentrance = false,
    renderexit = false)
    if renderentrance && cell == entrance(m)
        return 1.0, 0.0, 0.0
    end
    if renderexit && cell == getexit(m)
        return 0.0, 1.0, 0.0
    end
    d = distances(m)
    if isnothing(d)
        return 1.0, 1.0, 1.0
    end
    p = path(m)
    if renderpath && !isnothing(p) && haskey(p.cells, cell)
        return 0.1, 0.8, 1.0
    end
    if renderdistances && haskey(d.cells, cell) 
        distance = d[cell]
        maxdistance = first(maximum(d))
        intensity = (maxdistance  - distance) / maxdistance
        dark = intensity
        bright = 0.5 + (intensity * 0.5)
        return dark, bright, bright
    end
    return 1.0, 1.0, 1.0
end

function render(m;
    out = "out.png",
    cellsize = 16,
    modes = [:background, :walls],
    renderpath = false, 
    renderdistances = false)
    nrows, ncols = size(m)
    imgw = cellsize * ncols
    imgh = cellsize * nrows
    Drawing(imgw + 2, imgh + 2, out)
    background("white")
    for mode in modes
        for cell in m
            x1 = (colindex(cell) - 1) * cellsize + 0.5
            y1 = (rowindex(cell) - 1) * cellsize + 0.5
            x2 = colindex(cell) * cellsize + 0.5
            y2 = rowindex(cell) * cellsize + 0.5
            if mode == :background
                color = color = _bgcolor(m, cell, 
                    renderpath = renderpath,
                    renderdistances = renderdistances)
                setcolor(color)
                setline(1.0)
                rect(x1, y1, cellsize, cellsize, :fill)
                rect(x1, y1, cellsize, cellsize, :stroke)
            else
                setcolor("black")
                setline(1.0)
                isnothing(north(m, cell)) && line(Point(x1, y1), Point(x2, y1), :stroke)
                isnothing(west(m, cell)) && line(Point(x1, y1), Point(x1, y2), :stroke)
                islinked(cell, east(m, cell)) || line(Point(x2, y1), Point(x2, y2), :stroke)
                islinked(cell, south(m, cell)) || line(Point(x1, y2), Point(x2, y2), :stroke)
            end
        end
    end
    finish()
    preview()
    return m
end

const dim = 64
test() = 
    CartesianGrid(dim, dim) |> 
        Maze |> 
        binarytree! |>
        m -> dijkstra!(m, m[dim, dim ÷ 2]) |>
        m -> pathto!(m, m[dim, dim]) |>
        m -> render(m, cellsize = 16)

end # module