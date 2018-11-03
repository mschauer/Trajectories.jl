module Trajectories

export AbstractPairedArray, Trajectory, trajectory
export interpolate, Linear, Left, Right
export piecewise

include("definitions.jl")
include("interpolate.jl")
include("piecewise.jl")
end # module
