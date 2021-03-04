function binarytree!(grid::AbstractGrid)
    for cell in grid
        neighbors = Cell[]
        n = north(grid, cell)
        e = east(grid, cell)
        isnothing(n) || push!(neighbors, n)
        isnothing(e) || push!(neighbors, e)
        if !isempty(neighbors)
            target = rand(neighbors)
            link!(cell, target)
        end
    end
    return grid
end

function sidewinder!(grid::AbstractGrid)
    for row in eachrow(grid)
        run = Cell[]
        for cell in row
            push!(run, cell)
            atebound = isnothing(east(grid, cell))
            atnbound = isnothing(north(grid, cell))
            closerun = atebound || (!atnbound && iszero(rand((0, 1))))
            if closerun
                target = rand(run)
                n = north(grid, target)
                !isnothing(n) && link!(target, n)
                empty!(run)
            else
                link!(cell, east(grid, cell))
            end
        end
    end
    return grid
end