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
            x1 = (colindex(cell) - 1) * cellsize + 0.5
            y1 = (rowindex(cell) - 1) * cellsize + 0.5
            x2 = colindex(cell) * cellsize + 0.5
            y2 = rowindex(cell) * cellsize + 0.5
            if mode == :background
                color = backgroundcolorfor(g, cell)
                sethue(color)
                setline(0.5)
                rect(x1, y1, cellsize, cellsize, :fill)
                rect(x1, y1, cellsize, cellsize, :stroke)
            else
                sethue("black")
                setline(0.5)
                if isnothing(north(g, cell))
                    line(Point(x1, y1), Point(x2, y1), :stroke)
                end
                if isnothing(west(g, cell))
                    line(Point(x1, y1), Point(x1, y2), :stroke)
                end
                if !islinked(cell, east(g, cell))
                    line(Point(x2, y1), Point(x2, y2), :stroke)
                end
                if !islinked(cell, south(g, cell))
                    line(Point(x1, y2), Point(x2, y2), :stroke)
                end
            end
        end
    end
    finish()
    preview()
    return g
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
    return g
end   
