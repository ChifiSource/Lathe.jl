include("../preprocess/boostweights.jl")
include("tree_base.jl")
using Random
using CUDA
using DataFrames
struct TREECLASS end
struct Result{T, S}
    sc::Vector{Node{T}}
    d::Vector{S}
end
function fit(::TREECLASS, X, y, rng = Random.GLOBAL_RNG, max_depth = 6, min_node_records = 1,
        n_features_per_node = Int(floor(sqrt(size(X, 2)))), n_trees = 100)
    if n_features_per_node > size(X, 2)
        n_features_per_node = size(X, 2)
    end
    out_classes = unique(y)
    n_classes = length(out_classes)
    in_classes = collect(1:n_classes)
    d = Dict(zip(out_classes, in_classes))
    target = map(z -> d[z], y)

    T = eltype(X)
    sc = Node{T}[]
    nrow = size(X, 1)
    for i in 1:n_trees
        root = Node{T}()
        push!(sc, root)
        ids = sample(1:nrow, nrow)
        X1 = X[ids, :]
        target1 = target[ids]
        dtc = DecisionTreeContainer{T}(root, n_features_per_node, n_classes, max_depth, min_node_records)
        process_node(dtc, root, X1, target1, rng)
    end
    return Result(sc, out_classes)
end

function rf_predict(scr::Result, X)
    d = scr.d

    n = length(d)
    vals = Vector{Int}(undef, n)
    res = Vector{eltype(d)}(undef, size(X, 1))
    for i in axes(X, 1)
        vals .= 0
        for tree in scr.sc
            vals[predict(tree, X, i)] += 1
        end
        res[i] = d[argmax(vals)]
    end
    return res
end
"""
    ## Random Forest Classifier
    ### Description
      The Random Forest Classifier uses a multitude of decision trees to
      solve classification problems.\n
      --------------------\n
    ### Input
      RandomForestClassifier(x, y, rng ;
      max_depth = 6, min_node_records = 1, n_trees = 100)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - X:: Array of x's for which the model will use to
      predict y.\n
      Array{Any} - Y:: Array of y's for which the x's are used to predict.\n
      RandomNumberGenerator - rng:: Determines the seed for the given model.\n
      #### Key-word Arguments
      Int64 - max_depth:: Determines the max depth which the tree should use
      as a stop parameter.\n
      Int64 - min_node_records:: Determines the minimum number of nodes a
      constructed node is allowed to have.\n
      Int64 - n_trees:: Determines how many decision trees should be trained.
      --------------------\n
     ### Output
     model:: A Lathe Model.\n
     ---------------------\n
     ### Functions
     Model.predict(xt) :: Predicts a new y based on the data provided as xt and
      the weights obtained from X.\n
     ---------------------\n
     ### Data
     storedata :: A tree node type that contains the weights and their
     corresponding values.
       """
mutable struct RandomForestClassifier{P} <: Classifier
    predict::P
    storedata::Result
function RandomForestClassifier(X::Array, Y::Array, rng = Random.GLOBAL_RNG; max_depth = 6,
     min_node_records = 1,
    n_features_per_node = Int(floor(sqrt(size(X, 2)))), n_trees = 100, cuda = false)
    if cuda == true
        X = CuArray(X)
        Y = CuArray(Y)
    end
    storedata = fit(TREECLASS(), X, Y, rng, max_depth, min_node_records,
        Int(floor(sqrt(size(X, 2)))), n_trees)
    new{typeof(predict)}(predict, storedata)
end
function RandomForestClassifier(X::DataFrame, Y::Array, rng = Random.GLOBAL_RNG;
    max_depth = 6,
     min_node_records = 1,
     weights = NoWeights(Dict()), cuda = false,
    n_features_per_node = Int(floor(sqrt(size(X, 2)))),
     n_trees = 100)
    classifiers = []
    treec = 0
    n_features = size(X)[1]
    divamount = n_trees / n_features
    if cuda == true
        Y = CuArray(Y)
    end
    for data in eachcol(X)
        if cuda == true
            data = CuArray(data)
        end
        mdl = RandomForestClassifier(data, Y, n_trees = divamount)
        push!(classifiers, mdl)
    end
    predict(xt) = _compare_predCat(classifiers, xt)
    new{typeof(predict)}(predict, result)
end
end
"""
    ## Decision Tree Classifier
    ### Description
      The decision tree classifier is a model ideal for solving most
          classification problems.\n
      --------------------\n
    ### Input
      DecisionTreeClassifier(x, y, rng ;
      max_depth = 6, min_node_records = 1)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - X:: Array of x's for which the model will use to
      predict y.\n
      Array{Any} - Y:: Array of y's for which the x's are used to predict.\n
      RandomNumberGenerator - rng:: Determines the seed for the given model.\n
      #### Key-word Arguments
      Int64 - max_depth:: Determines the max depth which the tree should use
      as a stop parameter.\n
      Int64 - min_node_records:: Determines the minimum number of nodes a
      constructed node is allowed to have.\n
      --------------------\n
     ### Output
     model:: A Lathe Model.\n
     ---------------------\n
     ### Functions
     Model.predict(xt) :: Predicts a new y based on the data provided as xt and
      the weightsz obtained from X.\n
     ---------------------\n
     ### Data
     storedata :: A tree node type that contains the weights and their
     corresponding values.
       """
function DecisionTreeClassifier(X, Y, rng = Random.GLOBAL_RNG; max_depth = 6,
     min_node_records = 1,
    n_features_per_node = Int(floor(sqrt(size(X, 2)))))
    storedata = fit(TREECLASS(), X, Y, rng, max_depth, min_node_records,
        Int(floor(sqrt(size(X, 2)))), 1)
    predict(xt) = rf_predict(storedata, xt)
    (var)->(predict;storedata)
end
