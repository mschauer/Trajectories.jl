# location, measurements

# elipsis in print_range


import Base: eachindex, iterate, Pair,
    pairs, getindex, length, getproperty, map,
    get, keys

include("unroll1.jl")

export AbstractPairedArray, Trajectory, trajectory


abstract type  AbstractPairedArray
end

const APA = AbstractPairedArray

#=
struct PairedArray{T,S} <: AbstractPairedArray
    x::S
    x::T
end
=#

struct Trajectory{S,T} <: AbstractPairedArray
    t::S
    x::T
end

keys(X::Trajectory) = X.t
values(X::Trajectory) = X.x

struct Linear
end
struct Left
end

function _find(r::AbstractRange, x)
    n = round(Integer, (x - first(r)) / step(r)) + 1
    if n >= 1 && n <= length(r) && r[n] == x
        return n
    else
        error("index error")
    end
end


function find(X::Trajectory, key, default)
    X.x[find(X.t, key)]
end

function get(X::Trajectory{<:AbstractVector}, key)
    i = searchsorted(keys(X), key)
    isempty(i) && error("key not found and no interpolation rule")
    first(i) != last(i) && error("key not unique")
    return values(X)[first(i)]
end

trajectory(t, x) = Trajectory(t, x)
function trajectory(itr)
    local t, x
    @unroll1 for (tᵢ, xᵢ) in itr
        if $first
            t = [tᵢ]
            x = [xᵢ]
        else
            push!(t, tᵢ)
            push!(x, xᵢ)
        end
    end
    Trajectory(t, x)
end


#=
iterate(X::Trajectory) = X.t, (X.x, nothing)
iterate(X::Trajectory, state) = state
length(X) = 2
=#

Pair(X::Trajectory) = (X.t, X.x)

pairs(X::Trajectory) = (t => x for (t, x) in zip(X.t, X.x))

#eachindex(X::Trajectory) = eachindex(X.x)
#getindex(X::Trajectory{<:AbstractVector}, i) = getindex(X.x, i)

indextype(::Trajectory) = eltype(X.t)

valtype(::Trajectory) = eltype(X.x)

function getproperty(X::Trajectory, s::Symbol)
    if s == :tt
        warn("fieldname `tt` changed to `t` ")
        s = :t
    elseif s == :yy
        warn("fieldname `yy` changed to `x` ")
        s = :x
    end
    (s == :t || s == :x) && return getfield(X, s)
    error("getproperty: type Trajectory has no field $s")
end
#=
struct Splice
    X
    Y
end

function iterate(Splice)
    X, Y = Splice.X, Splice.Y
    ϕ = iterate(pairs(X))
    ψ = iterate(pairs(X))
end


    while true
        s1, s2 = iterate(X.t)
        iterate(Y.t)

        Trajectory(X.t, map(X.y + Y.y))
    end
end
=#

function map(f, X::Trajectory, Y::Trajectory)
    if X.t === Y.t || X.t == Y.t
        Trajectory(X.t, map(f, X.x, Y.x))
    else
        error("map undefined for Trajectory on different times")
    end
end
struct RelVector{T}
    y::T
end



import Base: size, length, getindex
const VView{T} = SubArray{T,1,Matrix{T},Tuple{Base.Slice{Base.OneTo{Int64}},Int64},true}

struct ViewVector{T} <: AbstractVector{VView{T}}
    x::Matrix{T}
end
size(X::ViewVector) = (length(X),)
length(X::ViewVector) = size(X.x, 2)
#getindex(X::ViewVector{T}, i) where {T} = view(X.x, :, i)::VView{T}
function getindex(X::ViewVector{T}, i) where {T}
    @boundscheck checkbounds(X.x, i)
    @inbounds VView{T}(X.x, (Base.Slice(Base.OneTo(3)), i), i, 1)
end
