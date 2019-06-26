module Ariadne

import Base: size, getindex, setindex!
import Base: length, iterate, get
import Base: show, isless, minimum, maximum

using Random
using Luxor

abstract type AbstractCell end
abstract type AbstractDistances{T<:AbstractCell} <: AbstractDict{T,Int} end
abstract type Tesselation end
abstract type Gamma <: Tesselation end
abstract type Delta <: Tesselation end
abstract type Sigma <: Tesselation end
abstract type Theta <: Tesselation end
abstract type Upsilon <: Tesselation end
abstract type Zeta <: Tesselation end
abstract type AbstractGrid{T<:Tesselation} <: AbstractMatrix{AbstractCell} end
abstract type AbstractMaze{T<:Tesselation} <: AbstractGrid{T} end

export 
    Distances,
    Grid,
    Maze,
    aldousbroder!,
    binarytree!,
    deadends,
    distances,
    pathto,
    setdistances,
    setpath,
    topng,
    totxt,
    unlinked

include("./grids.jl")
include("./algorithms.jl")
include("./distances.jl")
include("./rendering.jl")

end # module
