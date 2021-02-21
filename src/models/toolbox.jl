#==
Power Log
==#
"""
      A powerlog can be used to perform a one-tailed test, as well as get the proper sample size for a testing population.\n
      --------------------\n
      ==PARAMETERS==\n
     p1 <- A Float64 percentage representing the probability of scenario one.\n
     p2 <- A Float64 percentage representing the probability of scenario two. These two probability values should follow these guidelines: p1 = p1 + x = p2\n
     alpha = 0.05 <- Sets an alpha value\n
     --------------------\n
     Returns power, sample_size
       """
function PowerLog(p1::Float64,p2::Float64; alpha::Float64 = 0.05, rsq::Real = 0)
    pd = p2 - p1
    l1 = p1/(1-p1)
    l2 = p2/(1-p2)
    θ = l2 / l1
    or = θ
    λ = log(θ)
    λ2 = λ^2
    za = quantile(normal(),1-alpha)
    println("One-tailed test: alpha = ",alpha,", p1 = ",p1,", p2 = ",p2,", rsq = ",rsq,", odds ratio = ",or)
    δ = (1 + (1 + λ2)*exp(5 * λ2/4))/(1 + exp(-1*λ2/4))
    pwr = zeros(Float64,8)
    nn = zeros(Int64,8)
    i = 1
    for power = 0.6:.05:.95
        zb = quantile(normal(),power)

        N = ((za + zb*exp(-1 * λ2/4))^2 * (1 + 2*p1*δ))/(p1*λ2)
        N /= (1 - rsq)
        pwr[i] = power
        nn[i] = ceil(Int64,N)
        i += 1
    end
    return(pwr, nn)
end
#==
Mean
    Baseline
==#
 # Model Type
 @doc """
       A mean baseline is great for getting a basic accuracy score in order
           to make a valid direction for your model.\n
         --------------------\n
         ==PARAMETERS==\n
        [y] <- Fill with your trainY values. Should be an array of shape (0,1) or (1,0)\n
        pipl = Pipeline([StandardScalar(),LinearRegression(trainX,trainy)])\n
        --------------------\n
        ==Functions==\n
        predict(xt) <- Returns a prediction from the model based on the xtrain value passed (xt)
                     """
function MeanBaseline(y)
    m = mean(m.y)
    predict(xt) =
    xt = [v = m for v in xt]
    (test)->(m;predict)
end
#==
Majority
    Class
        Baseline
==#
@doc """
      Majority class baseline is used to find the most often interpreted
      classification in an array.\n
      --------------------\n
      ==PARAMETERS==\n
     [y] <- Fill with your trainY values. Should be an array of shape (0,1) or (1,0)\n
     --------------------\n
     ==Functions==\n
     predict(xt) <- Returns a prediction from the model based on the xtrain value passed (xt)\n
     counts() <- Returns a dictionary with the counts of all inserted keys.\n
     highest() <- Will return a Dictionary key with the count as well as the value for the most interpreted classification.
       """
function ClassBaseline(y)
    u=unique(y)
    d=Dict([(i,count(x->x==i,y)) for i in u])
    d = sort(collect(d), by=x->x[2])
    maxkey = d[length(d)]
    predict(xt) = [p = maxkey[1] for p in xt]
    counts() = d
    highest() = maxkey
    (var)->(y;maxkey;d;predict;counts;highest)
end
@doc """
      Pipelines can contain a predictable Lathe model with preprocessing that
      occurs automatically. This is done by putting X array processing methods
      into the iterable steps, and then putting your Lathe model in.\n
      --------------------\n
      ==PARAMETERS==\n
      [steps] <- An iterable list of methods to call for X modification. These mutations should
      have ALREADY BEEN MADE TO THE TRAIN X.\n
      pipl = Pipeline([StandardScalar(),LinearRegression(trainX,trainy)])\n
      --------------------\n
      ==Functions==\n
      predict(xt) <- Returns a prediction from the model based on the xtrain value passed (xt)
      """
function Pipeline(steps)
    predict(xt) = [xt = step[xt] for step in steps]
    (var)->(steps;predict)
end

function _compare_predCat(models, xbar::DataFrame)
    count = 0
    preddict = Dict()
    for model in models
        preddict[count] = model.predict(xbar)
        count += 1
    end
    count = 1
    n_features = length(preddict)
    encoder = OrdinalEncoder(preddict[1])
    y_hat = encoder.predict(preddict[1])
    for (key, value) in preddict
       encoded = encoder.predict(value)
        y_hat[count] = mean([y_hat[count], encoded[count]])
        count += 1
    end
    y_hat = Array{Int64}(y_hat)
    inv_lookup = Dict(value => key for (key, value) in encoder.lookup)
    for x in y_hat
        println(inv_lookup[x])
    end
end
