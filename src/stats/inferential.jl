#<---- correlation Coefficient --->
"""
    # Description
      A correlation coefficient is a statistical value that can be used to
      determine statistical correlation.\n
      --------------------\n
    # Input
      correlationcoeff(x, y)\n
      --------------------\n
      ## Positional Arguments
      x:: An array of values representing the general population.\n
      y:: An array of values representing the sample population.\n
      --------------------\n
     # Output
     r:: The correlation coefficient.
       """
function correlationcoeff(x,y)
    n = length(x)
    yl = length(y)
    if n != yl
        throw(ArgumentError("The array shape does not match!"))
    end
    xy = x .* y
    sx = sum(x)
    sy = sum(y)
    sxy = sum(xy)
    x2 = x .^ 2
    y2 = y .^ 2
    sx2 = sum(x2)
    sy2 = sum(y2)
    ((n*sxy) - (sx * sy)) / (sqrt((((n*sx2)-(sx^2)) * ((n*sy2)-(sy^2)))))
end
"""
    # Two Tailed Test
    ### Description
      The TwoTailed function takes a distribution, a sample, and a confidence
          level, and will return a P value reflecting the probability of
          statistical significance.\n
      --------------------\n
    ### Input
      TwoTailed(Distribution, sample; c)\n
      --------------------\n
      #### Positional Arguments
      Lathe Distribution - Distribution:: A Lathe Distribution.\n
      Array{Any} - sample:: An array of values representing the sample that should be
       tested.\n
       #### Key-word Arguments\n
       Float64 - c:: Level of confidence for a given test in decimal form of a
       percentage.\n
      --------------------\n
     ### Output
     T:: Bool type representing as to whether or not P <= a && P >= -a.
       """
function TwoTailed(dist::Distribution, sample; c = .95)
    a = 1 - c
    t = dist.apply(sample)
    v = dist.N - 1
    P = Real(dist.cdf(t, v))
    println(P)
    if P <= a && P >= - a
            return(true)
        else
            return(false)
    end
end
"""
    One Tailed Test -- NOT IMPLEMENTED (0.1.4)
    # Description
      The OneTailed test function takes a distribution, a sample, and a
          confidence
          level, and will return a P value reflecting the probability of
          statistical significance.\n
      --------------------\n
    # Input
      OneTailed(Distribution, sample; c)\n
      --------------------\n
      #### Positional Arguments
      Lathe Distribution - Distribution:: A Lathe Distribution.\n
      Array{Any} - sample:: An array of values representing the sample that should be
       tested.\n
       #### Key-word Arguments\n
       Float64 - c:: Level of confidence for a given test in decimal form of a
       percentage.\n
      --------------------\n
     # Output
     P:: P value representing the probability of A <= P >= - A
       """
function OneTailed(dist, sample; c = .95)
  a = 1 - c
  t = dist.apply(sample)
  v = dist.N - 1
  P = Real(dist.cdf(t, v))
  println(P)
  if P <= a
        return(true)
    else
        return(false)
end
end
"""
    Probability\n
    # Description
    The P() function takes a distribution, sample, and confidence level and
    will return the corresponding probability value.
      --------------------\n
    # Input
      OneTailed(Distribution, sample; c)\n
      --------------------\n
      #### Positional Arguments
      Lathe Distribution - Distribution:: A Lathe Distribution.\n
      Array{Any} - sample:: An array of values representing the sample that should be
       tested.\n
       #### Key-word Arguments\n
       Float64 - c:: Level of confidence for a given test in decimal form of a
       percentage.\n
      --------------------\n
     # Output
     P:: P value representing probability.
       """
P(dist, sample; c = .95) = dist.cdf(dist.apply(sample), dist.N - 1)
