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

function topng(g::AbstractGrid{Gamma}; 
    cellsize = 10, 
    out = "out.png", 
    modes = [:background, :walls])
    nrows, ncols = size(g)
    imgw = cellsize * ncols
    imgh = cellsize * nrows
    Drawing(imgw + 1, imgh + 1, out)
    background("white")
    for mode in modes
        for cell in g
            x1 = (colindex(cell) - 1) * cellsize
            y1 = (rowindex(cell) - 1) * cellsize
        end
    end
end

function contentsof(g::AbstractGrid{Gamma}, cell)
    return " "
end

function totxt(g::AbstractGrid{Gamma})
    nrows, ncols = size(g)
    print("+")
    for c in 1:ncols
        print("---+")
    end
    println("")
    rendercontents(x) = contentsof(g, x)
    for row in eachrow(g)
        top = "|"
        bottom = "+"
        for cell in row
            body = " $(rendercontents(cell)) "
            corner = "+"
            ebound = islinked(cell, east(g, cell)) ? " " : "|"
            sbound = islinked(cell, south(g, cell)) ? "   " : "---"
            top = join([top, body, ebound])
            bottom = join([bottom, sbound, corner])
        end
        println(top)
        println(bottom)
    end
end    