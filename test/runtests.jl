using Test, Ariadne

@testset "ariadne" begin
    @testset "cells" begin
        @testset "cells start with no links" begin
            a = Cell(1, 1)
            b = Cell(1, 2)        
            @test !islinked(a, b)
            @test !islinked(b, a)        
        end

        @testset "linking cells" begin
            a = Cell(1, 1)
            b = Cell(1, 2)        
            link!(a, b)
            @test islinked(a, b)
            @test islinked(b, a)
        end

        @testset "unlinking cells" begin
            a = Cell(1, 1)
            b = Cell(1, 2)
            link!(a, b)
            unlink!(a, b)
            @test !islinked(a, b)
            @test !islinked(b, a)
        end
    end
end