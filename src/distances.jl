struct Distances <: AbstractDistances
    root::Cell
    cells::Dict{Cell,Int}
end

function Distances(root)
    cells = Dict{Cell,Int}()
    cells[root] = 0
    frontier = [root]
    while !isempty(frontier)
        newfrontier = empty([], typeof(root))
        for cell in frontier
            for link in links(cell)
                if link in keys(cells)
                    continue
                end
                cells[link] = cells[cell] + 1
                push!(newfrontier, link)
            end
        end
        frontier = newfrontier
    end
    return Distances(root, cells)
end

cells(d::AbstractDistances) = d.cells

length(d::AbstractDistances) = length(cells(d))

iterate(d::AbstractDistances) = iterate(cells(d))
iterate(d::AbstractDistances, s) = iterate(cells(d))

get(d::AbstractDistances, key, default) = get(cells(d), key, default)

minimum(d::AbstractDistances) = first(findmin(cells(d)))
maximum(d::AbstractDistances) = first(findmax(cells(d)))