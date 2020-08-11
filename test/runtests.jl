using ToggledLH
using Test

@testset "ToggledLH" begin
    toggle(false);
    x = 3;
    @toggled (global x = 4)
    @test x == 3
    @toggled (1 == 1.0) (global x = 5)
    @test x == 3
    @tog_assert (1 == 2.0) "Nothing happens here"

    toggle(true)
    x = 3;
    @toggled (1 == 1.0) (global x = 5)
    @test x == 5
    @toggled (global x = 4)
    @test x == 4
    @toggled (1 == 2.0) (global x = 7)
    @test x == 4

    @toggled (1 == 1.0) begin
        global x = 11
    end
    @test x == 11
    @test_throws AssertionError (@tog_assert 1 == 2.0)
end

# --------------