using Distributions: TDist, Uniform, Normal, cf
import Distributions: cdf
"""
      Binomial Distribution is a distribution well known for its use in
           statistical tests and decision making models. In order to calculate
           binomial distribution, you will need the positives and size of your array.\n
      --------------------\n
      positives = 5\n
      n = 10\n
      r = binomial_dist(positives,n)
       """
function binomial_dist(positives, size; mode = :REC)
    # p = n! / x!(n-x!)*π^x*(1-π)^N-x
    n = size
    x = positives
    if mode != :REC
        factn = factorial(big(n))
        factx = factorial(big(x))
    else
        factn = fact(n)
        factx = fact(x)
    end
    return(factn / (factx * (n-x)))
end
# ---- Normal Distribution ----
"""
    ## Normal Distribution
    ### Description
      Calculates the normal distribution of an array.\n
      --------------------\n
    ### Input
      NormalDist(x)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - x:: Array for which the normal distribution should use the
      data from.\n
      --------------------\n
     ### Output
     norm:: A Lathe distribution\n
     ---------------------\n
     ### Functions
     Distribution.apply(xt) :: Applies the distribution to xt\n
     Distribution.cdf(statistic, alpha, dof) :: Applies the distribution's
     corresponding cummulitive distribution function.\n
     ---------------------\n
     ### Data
     σ :: Standard Deviation of the input data.\n
     μ :: Mean of the input data.
       """
struct NormalDist{c, p} <: Distribution
           σ::Float64
           μ::Float64
           N::Int64
           cdf::c
           apply::p
           function NormalDist(array)
              N = length(array)
               σ = std(array)
               μ = mean(array)
               apply(xt) = Array{Real}([i = (i-μ) / σ for i in xt])
               cdf(xt) = bvnuppercdf(σ, μ, xt)
               new{typeof(cdf), typeof(apply)}(σ, μ, N, cdf, apply)
            end
end
# ---- T distribution ----
"""
    ## T Distribution
    ### Description
      Calculates the T distribution of an array.\n
      --------------------\n
    ### Input
      TDist(x)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - x:: Array for which the T distribution should use the
      data from.\n
      --------------------\n
     ### Output
     t:: A Lathe distribution\n
     ---------------------\n
     ### Functions
     Distribution.apply(xt) :: Applies the distribution to xt\n
     Distribution.cdf(statistic, alpha, dof) :: Applies the distribution's
     corresponding cummulitive distribution function.\n
     ---------------------\n
     ### Data
     μ :: Mean of the input data.\n
     N :: The length of the input data.
       """
struct T_Dist{c, p} <: Distribution
μ::Float64
N::Int64
apply::p
cdf::c

function T_Dist(general)
  norm = NormalDist(general)
  general = norm.apply(general)
  μ = mean(general)
  N = length(general)
  apply(xt) = (mean(norm.apply(xt)) - μ) / (std(norm.apply(xt)) / sqrt(N))
  cdf(t, dog) = cf(TDist(dog), Real(t))
  new{typeof(cdf), typeof(apply)}(μ, N, apply, cdf)
  end
end
# ---- Uniform Dist ----
"""
    ## Uniform Distribution
    ### Description
      Calculates the Uniform distribution of an array.\n
      --------------------\n
    ### Input
      UniformDist(x)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - x:: Array for which the T distribution should use the
      data from.\n
      --------------------\n
     ### Output
     t:: A Lathe distribution\n
     ---------------------\n
     ### Functions
     Distribution.apply(xt) :: Applies the distribution to xt\n
     Distribution.cdf(xt) :: Applies the distribution's
     corresponding cummulitive distribution function.\n
     ---------------------
       """
function UniformDist(array)
    dist = Uniform(minimum(array), maximum(array))
    apply(xt) = pdf(dist, xt)
    cdf(x) = cdf(dist, x)
    (var) ->(dist;cdf;apply)
end

function bvnuppercdf(dh::Float64, dk::Float64, r::Float64)
	if abs(r) < 0.3
	   ng = 1
	   lg = 3
	elseif abs(r) < 0.75
	   ng = 2
	   lg = 6
	else
	   ng = 3
	   lg = 10
	end
	h = dh
	k = dk
	hk = h*k
	bvn = 0.0
	if abs(r) < 0.925
	   	if abs(r) > 0
	      	hs = (h * h + k * k) * 0.5
	      	asr = asin(r)
	      	for i = 1:lg
	         	for j = -1:2:1
	            	sn = sin(asr * (j * bvncdf_x_array[i, ng] + 1.0) * 0.5)
	            	bvn += bvncdf_w_array[i, ng] * exp((sn * hk - hs) / (1.0 - sn*sn))
	        	end
	      	end
	      	bvn *= asr / (4.0pi)
	   	end
	   	bvn += cdf(Normal(), -h) * cdf(Normal(), -k)
	else
	   	if r < 0
	      	k = -k
	      	hk = -hk
	   	end
	   	if abs(r) < 1
	      	as = (1.0 - r) * (1.0 + r)
	      	a = sqrt(as)
	      	bs = (h - k)^2
	      	c = (4.0 - hk) * 0.125
	      	d = (12.0 - hk) * 0.0625
	      	asr = -(bs / as + hk) * 0.5
	      	if ( asr > -100 )
	      		bvn = a * exp(asr) * (1.0 - c * (bs - as) * (1.0 - d * bs / 5.0) / 3.0 + c * d * as * as / 5.0)
	      	end
	      	if -hk < 100
	         	b = sqrt(bs)
	         	bvn -= exp(-hk * 0.5) * sqrt(2.0pi) * cdf(Normal(), -b / a) * b * (1.0 - c * bs * (1.0 - d * bs / 5.0) / 3.0)
	      	end
	     	a /= 2.0
		    for i = 1:lg
	         	for j = -1:2:1
	            	xs = (a * (j*bvncdf_x_array[i, ng] + 1.0))^2
	            	rs = sqrt(1.0 - xs)
	            	asr = -(bs / xs + hk) * 0.5
	            	if asr > -100
	               		bvn += a * bvncdf_w_array[i, ng] * exp(asr) * (exp(-hk * (1.0 - rs) / (2.0 * (1.0 + rs))) / rs - (1.0 + c * xs * (1.0 + d * xs)))
	            	end
	         	end
	        end
	      	bvn /= -2.0pi
	   	end
	   	if r > 0
	      	bvn += cdf(Normal(), -max(h, k))
	   	else
	      	bvn = -bvn
	      	if k > h
	      		bvn += cdf(Normal(), k) - cdf(Normal(), h)
	      	end
		end
	end
	return bvn
end
