module Ariadne

import Base: size, getindex, setindex!
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

export Grid,
       binarytree!,
       totxt,
       topng

include("./grids.jl")
include("./algorithms.jl")

end # module
