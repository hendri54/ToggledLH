using ToggledLH
using Test

foo(x) = 2x;


@testset "ToggledLH" begin
    toggle(false);
    x = 3;
    @toggled (global x = 4)
    @test x == 3
    @toggled (1 == 1.0) (global x = 5)
    @test x == 3

    z = 0;
    @toggled z = foo(3)
    @test z == 0

    @tog_assert (1 == 2.0) "Nothing happens here"

    toggle(true)
    x = 3;
    @toggled (1 == 1.0) (global x = 5)
    @test x == 5
    @toggled (global x = 4)
    @test x == 4
    @toggled (1 == 2.0) (global x = 7)
    @test x == 4

    z = 0;
    @toggled z = foo(3)
    @test z == foo(3)

    z = 0;
    @toggled (1 == 1.0) z = foo(3)
    @test z == foo(3)
    z = 0;
    @toggled (2 == 1.0) z = foo(3)
    @test z == 0

    @toggled (1 == 1.0) begin
        global x = 11
    end
    @test x == 11
    @test_throws AssertionError (@tog_assert 1 == 2.0)
end

# --------------