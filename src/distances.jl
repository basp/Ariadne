struct Distances{T} <: AbstractDistances{T}
    root::T
    cells::Dict{T,Int}
end

function Distances(root::AbstractCell)
    cells = Dict{typeof(root),Int}()
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

root(d::Distances) = d.root
cells(d::Distances) = d.cells

length(d::Distances) = length(cells(d))

iterate(d::Distances) = iterate(cells(d))
iterate(d::Distances, s) = iterate(cells(d), s)

get(d::Distances, key, default) = get(cells(d), key, default)

minimum(d::Distances) = first(findmin(cells(d)))
maximum(d::Distances) = first(findmax(cells(d)))

function pathto(d, goal)
    current = goal
    path = Distances(root(d), Dict{typeof(root(d)),Int}())
    cells(path)[current] = d[current]
    while current != root(d)
        for link in links(current)
            if d[link] < d[current]
                cells(path)[link] = d[link]
                current = link
                break
            end
        end
    end
    return path
end