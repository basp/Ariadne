function binarytree!(G::AbstractGrid{:Γ})
    for cell in G
        neighbors = Cell[]
        n = north(G, cell)
        e = east(G, cell)
        isnothing(n) || push!(neighbors, n)
        isnothing(e) || push!(neighbors, e)
        if !isempty(neighbors)
            tgt = rand(neighbors)
            link!(cell, tgt)
        end
    end
    return G
end
