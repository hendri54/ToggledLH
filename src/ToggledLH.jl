module ToggledLH

export @toggled, @tog_assert, toggle

assert_toggle() = true

macro toggled(expr)
    :( @toggled(true, $expr) )
end

"""
    @toggled(cond, expr)
    @toggled(expr)

Execute `expr` if `toggle` is ON and `cond` is true.
`cond` may be omitted.

`expr` can be several expressions as in
```
@toggled (1 == 1.0) (println("Start"); global x = 2; println("End"))
@toggled (1 == 1.0) begin
    println("Start");
    global x = 3;
    println("End");
end
```
"""
macro toggled(cond, expr)
    quote
        if assert_toggle()
            if $cond
                $expr
            else
                nothing
            end
        else
            nothing
        end
        # :(assert_toggle() ?  ($cond  &&  $expr)  : nothing)
    end
end


"""
    @tog_assert(cond, text = nothing)

Toggled assert. 
This is verbatim from `ToggleableAsserts.jl`
"""
macro tog_assert(cond, text = nothing)
    if text==nothing
        assert_stmt = esc(:(@assert $cond))
    else
        assert_stmt = esc(:(@assert $cond $text))
    end
    :(assert_toggle() ? $assert_stmt  : nothing)
end


const toggle_lock = ReentrantLock()


function toggle(enable::Bool)
    lock(toggle_lock) do
        @eval ToggledLH assert_toggle() = $enable
        on_or_off = enable ? "on." : "off."
        @info "ToggledLH turned "*on_or_off
    end
end

end # module
