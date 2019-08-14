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
                    # We already explored the cell on the other
                    # side of this link so let's just continue.
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

root(D::Distances) = D.root
cells(D::Distances) = D.cells

length(D::Distances) = length(cells(D))

iterate(D::Distances) = iterate(cells(D))
iterate(D::Distances, s) = iterate(cells(D), s)

get(D::Distances, key, default) = get(cells(D), key, default)

minimum(D::Distances) = first(findmin(cells(D)))
maximum(D::Distances) = first(findmax(cells(D)))

"""
    dijkstra(root)

Calculates a `Distances` value from the given root 
cell to each other reachable cell. This is equivalent
to invoking `Distances` directly.
"""
dijkstra(root) = root |> Distances

"""
    pathto(D, goal)

Calculates a shortest path to a particular `goal` cell 
using a precalculated `Distances` value.
"""
function pathto(D, goal)
    current = goal
    path = Distances(root(D), Dict{typeof(root(D)),Int}())
    cells(path)[current] = D[current]
    while current != root(D)
        for link in links(current)
            if D[link] < D[current]
                cells(path)[link] = D[link]
                current = link
                break
            end
        end
    end
    return path
end

"""
    dijkstra!(M, root)

Calculates a `Distances` value from the given `root` cell
and updates maze `M` accordingly.
"""
function dijkstra!(M, root)
    D = dijkstra(root)
    setdistances(M, D)
    return M
end

"""
    pathto!(M, D, goal)

Calculates a `Distances` value representing the shortest
path to given `goal` cell and updates maze `M` accordingly.
"""
function pathto!(M, D, goal)
    P = pathto(D, goal)
    setpath(M, P)
    return
end
