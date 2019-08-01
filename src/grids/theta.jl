mutable struct PolarGrid <: AbstractGrid{:Θ}
    rows::Vector{Vector{Cell}}
    wrap::Bool
end

function PolarGrid(ncircles; wrap = true)
    rows = [Cell[] for r in 1:ncircles]
    rowheight = 1 / ncircles
    rows[1] = [Cell(1, 1)]
    for row in 2:ncircles
        radius = (row - 1) / ncircles # -1 for 1-based indices
        circ = 2π * radius
        prevcount = length(rows[row - 1]) # and again
        cellwidth = circ / prevcount
        ratio = round(Int, cellwidth / rowheight)
        ncells = prevcount * ratio
        rows[row] = [Cell(row, col) for col in 1:ncells]
    end
    return PolarGrid(rows, wrap)
end

iswrapped(G::AbstractGrid{:Θ}) = G.wrap

rows(G::AbstractGrid{:Θ}) = G.rows
rows(M::AbstractMaze{:Θ}) = rows(grid(M))

size(G::AbstractGrid{:Θ}) = length(rows(G)), length(last(rows(G)))

function getindex(G::AbstractGrid{:Θ}, r, c)
    roob = r < 1 || r > length(rows(G))
    coob = !iswrapped(G) && (c < 1 || c > length(rows(G)[r]))
    (roob || coob) && return nothing
    return rows(G)[r][mod1(c, length(rows(G)[r]))]
end
