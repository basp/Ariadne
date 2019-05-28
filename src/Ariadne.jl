module Ariadne

#import Base: size, getindex, setindex!
#import Base: iterate, length, eltype, IteratorSize, IteratorEltype
#import Base: show, isless, minimum, maximum

import Base: size, getindex, setindex!
import Base: show

abstract type AbstractCell end
abstract type Tesselation end
abstract type Gamma <: Tesselation end
abstract type AbstractGrid{T<:Tesselation} <: AbstractMatrix{AbstractCell} end

include("./grids.jl")

end # module
