# Trajectories

A trajectory in the sense of this package is a vector of time points `t` and a corresponding
vector of spatial points `x`, which are though as locations `x[i]` of an object at times
`t[i]`.

A key decision which has to be made for a time series object,
is whether iteration is used to iterate values, pairs or is leveraged for destruction.
In order to allow pairs `(t, x)` to serve as ad hoc trajectory, here the following
decision was made:

Iteration is de-structuring. For `X = Trajectory(t, x)`,

```julia
t, x = X
```

To iterate values `xᵢ` or pairs `(tᵢ, xᵢ)`, use `values` or `pair`
```julia
xᵢ in values(X)
(tᵢ, xᵢ) in pairs(X)
```
