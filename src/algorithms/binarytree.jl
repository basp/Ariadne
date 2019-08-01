function binarytree!(g::AbstractGrid{:Γ})
    for cell in g
        neighbors = Cell[]
        n = north(g, cell)
        e = east(g, cell)
        isnothing(n) || push!(neighbors, n)
        isnothing(e) || push!(neighbors, e)
        if !isempty(neighbors)
            tgt = rand(neighbors)
            link!(cell, tgt)
        end
    end
    return g
end
