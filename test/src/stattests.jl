println("Stats Tests")
println("...........")
using Lathe.stats: NormalDist, T_Dist, mean, std
# Distributions
@testset "Distributions" begin
x = randn(200)
dist = NormalDist(x)
mu = mean(x)
zero_std = dist.apply(mu)
@test Real(zero_std[1]) == 0
end
