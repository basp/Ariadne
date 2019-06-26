function binarytree!(g::AbstractGrid{Gamma})
    for cell in g
        neighbors = Cell[]
        n = north(g, cell)
        e = east(g, cell)
        if !isnothing(n)
            push!(neighbors, n)
        end
        if !isnothing(e)
            push!(neighbors, e)
        end
        if length(neighbors) > 0
            neighbor = rand(neighbors)
            link!(cell, neighbor)
        end
    end
    return g
end

function aldousbroder!(g::AbstractGrid)
    cell = rand(g)
    unvisited = count(!isnothing, g) - 1
    while unvisited > 0
        neighbor = rand(neighbors(g, cell))
        if isempty(links(neighbor))
            link!(cell, neighbor)
            unvisited -= 1
        end
        cell = neighbor
    end
    return g
end