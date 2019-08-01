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