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