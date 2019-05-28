size(g::AbstractGrid) = size(cells(g))

function getindex(g::AbstractGrid, r, c)
    nrows, ncols = size(g)
    if r < 1 || r > nrows return nothing end
    if c < 1 || c > ncols return nothing end
    return cells(g)[r, c]
end
