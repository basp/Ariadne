function backgroundcolorfor(g::AbstractGrid, cell::AbstractCell;
    renderpath = false,
    renderdistances = true)
    δ = distances(g)
    if isnothing(δ)
        return 1.0, 1.0, 1.0
    end
    p = path(g)
    if !isnothing(p)
        if renderpath && haskey(cells(p), cell)
            return 0.1, 0.8, 1.0
        end
    end
    if renderdistances
        if !haskey(cells(δ), cell) return 0.0, 0.0, 0.0 end
        distance = δ[cell]
        intensity = (maximum(δ) - distance) / maximum(δ)
        dark = intensity
        bright = 0.5 + (intensity * 0.5)
        return dark, bright, bright
    end
    return 1.0, 1.0, 1.0
end

function topng(g::AbstractGrid{:Γ}; 
    cellsize = 30, 
    out = "out.png", 
    modes = [:background, :walls])
    nrows, ncols = size(g)
    imgw = cellsize * ncols
    imgh = cellsize * nrows
    Drawing(imgw + 1, imgh + 1, out)
    background("white")
    for mode in modes
        for cell in g
            x1 = (colidx(cell) - 1) * cellsize
            y1 = (rowidx(cell) - 1) * cellsize
            x2 = colidx(cell) * cellsize
            y2 = rowidx(cell) * cellsize
            if mode == :background
                color = backgroundcolorfor(g, cell)
                sethue(color)
                setline(1.0)
                rect(x1, y1, cellsize, cellsize, :fill)
                rect(x1, y1, cellsize, cellsize, :stroke)
            else
                sethue("black")
                setline(1.5)
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

contentsof(g::AbstractGrid{:Γ}) = repeat(" ", 2)

function contentsof(g::AbstractMaze{:Γ}, cell)
    isnothing(distances(g)) && return repeat(" ", 2)
    haskey(distances(g), cell) || return repeat(" ", 2)
    return lpad(string(distances(g)[cell], base=16), 2)
end

function totxt(g::AbstractGrid{:Γ})
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
            body = "$(rendercontents(cell)) "
            corner = "+"
            ebound = islinked(cell, east(g, cell)) ? " " : "|"
            sbound = islinked(cell, south(g, cell)) ? "   " : "---"
            top = join([top, body, ebound])
            bottom = join([bottom, sbound, corner])
        end
        println(top)
        println(bottom)
    end
    return g
end   
