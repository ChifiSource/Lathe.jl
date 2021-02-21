"""Sample"""
module stats
abstract type Distribution end
export Distribution
#==
Base
==#
include("stats/statbase.jl")
export mean, median, mode, variance, confints, ste, std, q1
export q3, getranks, fact, is_prime, Σ
#==
Distributions
==#
include("stats/distributions.jl")
export NormalDist, T_Dist
#==
Inferential
==#
include("stats/inferential.jl")
export correlationcoeff, TwoTailed, OneTailed
#==
Bayesian
==#
include("stats/bayesian.jl")
export bay_ther, cond_prob
#==
Validate
==#
include("stats/validate.jl")
export mae, mse, r2, catacc
#==
Samples
==#
include("stats/samples.jl")
export sample, sample!
#==
Functions
==#
include("stats/functions.jl")
export φ
#---------------------------
end
