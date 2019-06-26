module Ariadne

import Base: size, getindex, setindex!
import Base: length, iterate, get
import Base: show, isless, minimum, maximum

using Random
using Luxor

abstract type AbstractCell end
abstract type Tesselation end
abstract type Gamma <: Tesselation end
abstract type Delta <: Tesselation end
abstract type Sigma <: Tesselation end
abstract type Theta <: Tesselation end
abstract type Upsilon <: Tesselation end
abstract type Zeta <: Tesselation end
abstract type AbstractGrid{T<:Tesselation} <: AbstractMatrix{AbstractCell} end
abstract type AbstractDistances{T<:AbstractCell} <: AbstractDict{T,Int} end

export 
    Grid,
    aldousbroder!,
    binarytree!,
    dijkstra,
    totxt,
    topng

include("./grids.jl")
include("./algorithms.jl")
include("./distances.jl")

end # module
