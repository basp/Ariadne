# Ariadne.jl
Playing around with mazes.

# Notes
Instead of writing something ugly like
```
if cond 
    dosomething()
end
```
we can also write
```
cond && dosomething()
```
which looks a lot better.

Similarly, we can also write
```
isnothing(err) || throw(err)
```
which will evaluate to `true` in case of no error but will throw the `err` value in case something happened.

Julia also has literal syntax for pairs.
```
pairs = [:foo => 123, :quux => "bar"]
```
These can be used as keyword arguments as well which is useful if you want to compute the kwargs at runtime.
```
map([1, 2, 3]) do x
    if iseven(x)
        return 0
    else
        return 1
    end
end
```