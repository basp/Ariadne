module Sandbox

abstract type AbstractCell end

rowindex(n::AbstractCell) = 0
colindex(n::AbstractCell) = 0
links(n::AbstractCell) = Set{AbstractCell}()
link!(a::AbstractCell, b::AbstractCell) = a
unlink!(a::AbstractCell, b::AbstractCell) = a

abstract type AbstractGrid{T} <: AbstractMatrix{T} end

# size
# getindex

end