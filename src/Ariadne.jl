module Ariadne

using Luxor

import Base: size, getindex #, setindex!
import Base: length, iterate, get
import Base: show, isless, minimum, maximum

export 
    Cell,
    Grid,
    HexGrid,
    Maze,
    PolarGrid,
    TriangleGrid,
    
    aldousbroder!,
    binarytree!,
    dijkstra,
    dijkstra!,
    distances,
    path,
    pathto,
    pathto!,
    setdistances,
    setpath,
    totxt

abstract type AbstractCell end
abstract type AbstractDistances{T<:AbstractCell} <: AbstractDict{T,Int} end
abstract type AbstractGrid{T} <: AbstractMatrix{AbstractCell} end
abstract type AbstractMaze{T} <: AbstractGrid{T} end

include("./grids.jl")
include("./algorithms.jl")
include("./distances.jl")
include("./rendering.jl")

end
