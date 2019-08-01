function aldousbroder!(G::AbstractGrid)
    cell = rand(G)
    unvisited = count(!isnothing, G) - 1
    while unvisited > 0
        neighbor = rand(neighbors(G, cell))
        if isempty(links(neighbor))
            link!(cell, neighbor)
            unvisited -= 1
        end
        cell = neighbor
    end
    return G
end
