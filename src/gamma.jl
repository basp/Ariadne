mutable struct Grid <: AbstractGrid
    cells::Matrix{Cell}
end

Grid(nrows, ncols) = cellmatrix(nrows, ncols) |> Grid

cells(g::Grid) = g.cells

Base.size(g::Grid) = size(cells(g))

function Base.getindex(g::Grid, r, c)
    nrows, ncols = size(g)
    roob = r < 1 || r > nrows
    coob = c < 1 || c > ncols
    (roob || coob) && return nothing
    return getindex(cells(g), r, c)
end

north(g::AbstractGrid, c) = g[rowidx(c) - 1, colidx(c)]
south(g::AbstractGrid, c) = g[rowidx(c) + 1, colidx(c)]
east(g::AbstractGrid, c) = g[rowidx(c), colidx(c) + 1]
west(g::AbstractGrid, c) = g[rowidx(c), colidx(c) - 1]

function neighbors(g::Grid, c)
    n = north(g, c)
    s = south(g, c)
    w = west(g, c)
    e = east(g, c)
    return filter(!isnothing, [n, e, s, w])
end

function totxt(g::Grid)
    nrows, ncols = size(g)
    print("+")
    for c in 1:ncols
        print("---+")
    end
    println("")
    rendercontents(x) = repeat(" ", 2)
    for row in eachrow(g)
        top = "|"
        bottom = "+"
        for cell in row
            body = "$(rendercontents(cell)) "
            corner = "+"
            ebound = ifelse(islinked(cell, east(g, cell)), " ", "|")
            sbound = ifelse(islinked(cell, south(g, cell)), "   ", "---")
            top = join([top, body, ebound])
            bottom = join([bottom, sbound, corner])
        end
        println(top)
        println(bottom)
    end
    return g
end

function backgroundcolorfor(g::AbstractGrid, cell::Cell;
    renderpath = false,
    renderdistances = false)
    d = distances(g)
    if isnothing(d)
        return 1.0, 1.0, 1.0
    end
    p = path(g)
    if !isnothing(p)
        if renderpath && haskey(cells(p), cell)
            return 0.1, 0.8, 1.0
        end
    end
    if renderdistances
        if !haskey(cells(d), cell) 
            return 0.0, 0.0, 0.0 
        end
        distance = d[cell]
        maxdistance = first(maximum(d))
        intensity = (maxdistance  - distance) / maxdistance
        dark = intensity
        bright = 0.5 + (intensity * 0.5)
        return dark, bright, bright
    end
    return 1.0, 1.0, 1.0
end

function topng(g::AbstractGrid; renderdistances = false)
    cellsize = 30
    filename = "out.png"
    modes = [:background, :walls]
    nrows, ncols = size(g)
    imgw = cellsize * ncols
    imgh = cellsize * nrows
    Drawing(imgw + (2 * cellsize), imgh + (2 * cellsize), filename)
    background("white")
    for mode in modes
        for cell in g
            x1 = colidx(cell) * cellsize
            y1 = rowidx(cell) * cellsize
            x2 = (colidx(cell) + 1) * cellsize
            y2 = (rowidx(cell) + 1) * cellsize
            if mode == :background
                color = backgroundcolorfor(g, cell, renderdistances = renderdistances)
                sethue(color)
                setline(1.0)
                rect(x1, y1, cellsize, cellsize, :fill)
                rect(x1, y1, cellsize, cellsize, :stroke)
            else
                sethue("black")
                setline(1.0)
                isnothing(north(g, cell)) && line(Point(x1, y1), Point(x2, y1), :stroke)
                isnothing(west(g, cell)) && line(Point(x1, y1), Point(x1, y2), :stroke)
                islinked(cell, east(g, cell)) || line(Point(x2, y1), Point(x2, y2), :stroke)
                islinked(cell, south(g, cell)) || line(Point(x1, y2), Point(x2, y2), :stroke)
            end
        end
    end
    finish()
    preview()
    return g
end