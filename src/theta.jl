mutable struct PolarGrid <: AbstractGrid
    rows::Vector{Vector{Cell}}
    wrap::Bool
end

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

rows(g::PolarGrid) = g.rows

iswrapped(g::PolarGrid) = g.wrap

Base.size(g::PolarGrid) = length(rows(g)), length(last(rows(g)))

function Base.getindex(g::PolarGrid, r, c)
    roob = r < 1 || r > length(rows(g))
    coob = !iswrapped(g) && (c < 1 || c > length(rows(g)[r]))
    (roob || coob) && return nothing
    return rows(g)[r][mod1(c, length(rows(g)[r]))]
end

function Base.iterate(g::PolarGrid)
    isempty(rows(g)) && return nothing
    isempty(first(rows(g))) && return nothing
    return first(first(rows(g))), (2, 1)
end

Base.iterate(g::PolarGrid, s) = iterate(vcat(rows(g)...), s)