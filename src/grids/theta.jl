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
