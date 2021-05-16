# Formulae.jl

_created by Austin Poor_

Create dynamic formulae using `Variables`, `Constants`, and `Operators`.

Here's a quick example:

```julia
julia> using Formulae

julia> x = Variable("x", 10)
{x=10}

julia> y = Variable("y", 3)
{y=3}

julia> f = x * (y + 2)
{{x=10} {*} {{y=3} {+} {2}}}

julia> getval(x), getval(y), getval(f)
(10, 3, 50)

julia> x.value = 5
5

julia> getval(x), getval(y), getval(f)
(5, 3, 25)
```

