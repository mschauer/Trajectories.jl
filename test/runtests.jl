using Trajectories
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
t = 0:10
x = rand(11)
X = trajectory(zip(t, x))

@test Pair(X) == (t, x)
@test get(X, 5) == x[6]

#@test [y for y in X] == [t, x]

for i in 5:10
    @test Trajectories._find(5:10, i) == i - 4
end
@test_throws ErrorException Trajectories._find(5:10, 4)
@test_throws ErrorException Trajectories._find(5:10, 11)
