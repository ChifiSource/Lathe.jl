abstract type AbstractWeights end
using DataFrames
mutable struct Weights <: AbstractWeights
    lookup::Dict
end
mutable struct NoWeights <: AbstractWeights
    lookup::Dict
end
function NormalWeight(df::DataFrame, y::Array{Any})
    features = eachcol(df)
    n_features = size(df)[1]
    categories = Set(y)
    y = OrdinalEncoder(y).predict(y)
    dist = NormalDist(y)
    norm = dist.apply(y)
    for val in y

    end
end
function ManualWeights(pairs::Array)
    return(Weights(Dict(pairs)))
end
