size(g::AbstractGrid) = size(cells(g))

function getindex(g::AbstractGrid, r, c)
    nrows, ncols = size(g)
    if r < 1 || r > nrows return nothing end
    if c < 1 || c > ncols return nothing end
    return cells(g)[r, c]
end

north(g::AbstractGrid, c) = g[rowindex(c) - 1, colindex(c)]
south(g::AbstractGrid, c) = g[rowindex(c) + 1, colindex(c)]
west(g::AbstractGrid, c) = g[rowindex(c), colindex(c) - 1]
east(g::AbstractGrid, c) = g[rowindex(c), colindex(c) + 1]

function neighbors(g::AbstractGrid{Gamma}, c)
    n = north(g, c)
    s = south(g, c)
    w = west(g, c)
    e = east(g, c)
    return filter(x -> !isnothing(x), [n, e, s, w])
end 