#===============================
<-----------Lathe.jl----------->
Programmed by Emmett Boudreau
    <emmett@emmettboudreau.com>
        <http://emmettboudreau.com>
GNU General Open Source License
    (V 3.0.0)
        Free for Modification and
        Redistribution
Thank you for your forks!
<-----------Lathe.jl----------->
================================#
module Lathe
using DataFrames
#================
Stats
    Module
================#
module stats
#<----Mean---->
function mean(array)
    observations = length(array)
    average = sum(array)/observations
    return(average)
end
#<----Nrow counts number of iterations---->
function nrow(data)
        x = 0
        for i in data
            x = x+1
        end
        return(x)
end
#<----Median---->
function median(array)

end
#<----Mode---->
function mode(array)
    m = findmax(array)
    return(m)
end
#<----Variance---->
function variance(array)
    me = mean(array)
    sq = sum(array) - me
    squared_mean = sq ^ 2
    return(squared_mean)
end
#<----Standard Deviation---->
function standardize(array)
    mean = sum(array)/length(array)
    sq = sum(array) - mean
    squared_mean = sq ^ 2
    standardized = sqrt(squared_mean)
    return(standardized)
end
#<----Confidence Intervals---->
function confiints(data, confidence=.95)
#    n = length(data)
#    mean = sum(data)/n
#    std = standardize(data)
#    stderr = standarderror(data)
#    interval = stderr * scs.t.ppf((1 + confidence) / 2.0, n-1)
#    return (mean-interval, mean+interval)
end
#<----Standard Error---->
function standarderror(data)
    std = standardize(data)
    sample = length(data)
    ste = (std/sqrt(sample))
    return(ste)
end
#<----Z score---->
function z(array)

end
function firstquar(array)
    m = median(array)
    q15 = array / m
    q1 = array / m
    return(q)
end
function secondquar(array)
    m = median(array)
    return(m)
end
function thirdquar(array)
    q = median(array)
    q = q * 1.5
end
function sampmed(array)

end

#-------Inferential-----------__________
#<----Inferential Summary---->
function inf_sum(data,grdata)
    #Doing our calculations
    t = student_t(data,grdata)
    f = f_test(data,grdata)
#    low,high = confiints(data)
    var = variance(data)
    grvar = variance(grdata)
    avg = mean(data)
    gravg = mean(grdata)
    sampstd = standardize(data)
    grstd = standardize(grdata)
    #Printing them out
    println("================")
    println("     Lathe.stats Inferential Summary")
    println("     _______________________________")
    println("N: ",length(grdata))
    println("x̅: ",avg)
    println("μ: ",gravg)
    println("s: ",sampstd)
    println("σ: ",grstd)
    println("var(X): ",var)
    println("σ2: ",grvar)
#    println("Low Confidence interval: ",low)
#    println("High Confidence interval: ",high)
    println("α ",t)
    println("Fp: ",f)
    println("================")
end
#<----T Test---->
function student_t(sample,general)
    sampmean = mean(sample)
    genmean = mean(general)
    samples = length(sample)
    std = standardize(general)
    t = (sampmean - genmean) / (std / sqrt(samples))
    return(t)
end
#<---- F-Test---->
function f_test(sample,general)
    totvariance = variance(general)
    sampvar = variance(sample)
    f =  sampvar / totvariance
    return(f)
end
#-------Bayesian--------------___________
#<----Bayes Theorem---->
#P = prob, A = prior, B = Evidence,
function bay_ther(p,a,b)
    psterior = (p*(b|a) * p*(a)) / (p*b)
    return(psterior)
end
function cond_prob(p,a,b)
    psterior = bay_ther(p,a,b)
    cond = p*(a|b)
    return(cond)
end
#-------Model Metrics--------____________
function reg_sum(pred,gen)
    println("================")
    println("     Lathe.stats Regression Summary")
    println("     _______________________________")
end
function mae(actual,pred)
    l = length(actual)
    lp = length(pred)
    if l != lp
        throw(ArgumentError("The array shape does not match!"))
    end
    println(1,"X",l)
    m = mean(actual)
    prm = mean(pred)
    a = m-prm
    return(a)
end
#---------------------------
end
#================
Preprocessing
     Module
================#
module preprocess
using Random
using Lathe
function TrainTest(data, at = 0.7)
    n = Lathe.stats.nrow(data)
    idx = Random.shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, at*n))
    test_idx = view(idx, (floor(Int, at*n)+1):n)
    data[train_idx,:], data[test_idx,:]
    return(test_idx,train_idx)
end
function TrainTestVal(data, at = 0.6,valat = 0.2)
    n = Lathe.stats.nrow(data)
    idx = Random.shuffle(1:n)
    train = view(idx, 1:floor(Int, at*n))
    test_idx = view(idx, (floor(Int, at*n)+1):n)
    data[train,:], data[test_idx,:]
    # ~Repeats to split test data~
    n = Lathe.stats.nrow(test)
    idx = Random.shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, at*n))
    val_idx = view(idx, (floor(Int, at*n)+1):n)
    train[train_idx,:], train[val_idx,:]
    return(test_idx,train_idx,val_idx)
end
function Rescalar(array)
    v = []
    for i in array
        min = min(array)
        max = max(array)
        x = i
        x = (x-min) / (max - min)
        append!(v,x)
    end
    return(v)
end
function ArbritatraryRescale(array)
    v = []
    for i in array
        a = min(array)
        b = max(array)
        x = i
        x = a + (x-a(x))*(b-a) / (b-a)
        append!(v,x)
    end
    return(v)
end
function MeanNormalization(array)
    avg = Lathe.stats.mean(array)
    first = True
    for i in array
        if first == True
            dtype = typeof(m)
            v = []
        end
        first = False
        x = i
        a = min(array)
        b = max(array)
        m = (x-avg) / (b-a)
        append!(v,x)
    end
end
function z_normalize(array)
    q = Lathe.stats.standardize(array)
    avg = Lathe.stats.mean(array)
    v = []
    for i in array
        x = i
        y = (x-avg) / q
        append!(v,y)
    end
end
function Unit_LScale(array)

end
#-----------------------------
end
#================
Predictive
    Learning
        Models
================#
module models
#==
Baseline
    Model
==#
using Lathe
#Show models shows all the models that are stable
#And ready for use in the library
function showmodels()
    println("________________")
    println("Current")
    println("    Usable")
    println("       Models")
    println("================")
    println("TurtleShell")
    println("majBaseline")
    println("meanBaseline")
end
#Takes model, and X to predict, and returns a y prediction
function predict(m,x)
    if typeof(m) == TurtleShell
        y_pred = pred_turtleshell(m,x)
    end
    if typeof(m) == majBaseline
        y_pred = pred_catbaseline(m,x)
    end
    if typeof(m) == LinearRegression
        y_pred = pred_linearregression(m,x)
    end
    if typeof(m) == meanBaseline
        y_pred = pred_meanbaseline(m,x)
    end
    return(y_pred)
end
#==
Turtle
    Shell
==#
# Model Type
mutable struct TurtleShell
    x
    y
end
#----  Callback
function pred_turtleshell(m,xt)
    x = m.x
    y = m.y
end
#==
Majority
    Class
        Baseline
==#
# Model Type
mutable struct majBaseline
    y
end
#----  Callback
function pred_catbaseline(m,xt)
    y = m.y
    e = []
    mode = Lathe.stats.mode(xt)
    for i in xt
        append!(e,i)
    end

end
#==
Mean
    Baseline
==#
mutable struct meanBaseline
    y
end
#----  Callback
function pred_meanbaseline(m,xt)
    e = []
    m = Lathe.stats.mean(m.y)
    for i in xt
        append!(e,m)
    end
    return(e)
end
#==
Linear
    Regression
==#
mutable struct LinearRegression
    x
    y
end
#----  Callback
function pred_linearregression(m,xt)

end
#
#----------------------------------------------
end
module IterTools

import Base.Iterators: drop, take

import Base: iterate, eltype, length, size, peek
import Base: tail
import Base: IteratorSize, IteratorEltype
import Base: SizeUnknown, IsInfinite, HasLength, HasShape
import Base: HasEltype, EltypeUnknown

export
    takestrict,
    repeatedly,
    chain,
    product,
    distinct,
    partition,
    groupby,
    imap,
    subsets,
    iterated,
    nth,
    takenth,
    peekiter,
    peek,
    ncycle,
    ivec,
    flagfirst,
    takewhile,
    properties,
    propertyvalues,
    fieldvalues

function has_length(it)
    it_size = IteratorSize(it)

    return isa(it_size, HasLength) || isa(it_size, HasShape)
end

# return the size for methods depending on the longest iterator
longest(::T, ::T) where {T<:IteratorSize} = T()
function longest(::S, ::T) where {T<:IteratorSize, S<:IteratorSize}
    longest(T(), S())
end
longest(::HasShape, ::HasShape) = HasLength()
longest(::HasLength, ::HasShape) = HasLength()
longest(::SizeUnknown, ::HasShape) = SizeUnknown()
longest(::SizeUnknown, ::HasLength) = SizeUnknown()
longest(::IsInfinite, ::HasShape) = IsInfinite()
longest(::IsInfinite, ::HasLength) = IsInfinite()
longest(::IsInfinite, ::SizeUnknown) = IsInfinite()

# return the size for methods depending on the shortest iterator
shortest(::T, ::T) where {T<:IteratorSize} = T()
function shortest(::S, ::T) where {T<:IteratorSize, S<:IteratorSize}
    shortest(T(), S())
end
shortest(::HasShape, ::HasShape) = HasLength()
shortest(::HasLength, ::HasShape) = HasLength()
shortest(::IsInfinite, ::HasShape) = HasLength()
shortest(::IsInfinite, ::HasLength) = HasLength()
shortest(::SizeUnknown, ::HasShape) = SizeUnknown()
shortest(::SizeUnknown, ::HasLength) = SizeUnknown()
shortest(::SizeUnknown, ::IsInfinite) = SizeUnknown()

"""
    IterTools.@ifsomething expr
If `expr` evaluates to `nothing`, equivalent to `return nothing`, otherwise the macro
evaluates to the value of `expr`. Not exported, useful for implementing iterators.
```jldoctest
julia> IterTools.@ifsomething iterate(1:2)
(1, 1)
julia> let elt, state = IterTools.@ifsomething iterate(1:2, 2); println("not reached"); end
```
"""
macro ifsomething(ex)
    quote
        result = $(esc(ex))
        result === nothing && return nothing
        result
    end
end

# Iterate through the first n elements, throwing an exception if
# fewer than n items ar encountered.

struct TakeStrict{I}
    xs::I
    n::Int
end
IteratorSize(::Type{<:TakeStrict}) = HasLength()
IteratorEltype(::Type{TakeStrict{I}}) where {I} = IteratorEltype(I)
eltype(::Type{TakeStrict{I}}) where {I} = eltype(I)

"""
    takestrict(xs, n::Int)
Like `take()`, an iterator that generates at most the first `n` elements of `xs`, but throws
an exception if fewer than `n` items are encountered in `xs`.
```jldoctest
julia> a = :1:2:11
1:2:11
julia> collect(takestrict(a, 3))
3-element Array{Int64,1}:
 1
 3
 5
```
"""
takestrict(xs, n::Int) = TakeStrict(xs, n)

function iterate(it::TakeStrict, state=(it.n,))
    n, xs_state = first(state), tail(state)
    n <= 0 && return nothing
    xs_iter = iterate(it.xs, xs_state...)

    if xs_iter === nothing
        throw(ArgumentError("In takestrict(xs, n), xs had fewer than n items to take."))
    end

    v, xs_state = xs_iter
    return v, (n - 1, xs_state)
end

length(it::TakeStrict) = it.n


# Repeat a function application n (or infinitely many) times.

struct RepeatCall{F<:Base.Callable}
    f::F
    n::Int
end
IteratorSize(::Type{<:RepeatCall}) = HasLength()
IteratorEltype(::Type{<:RepeatCall}) = EltypeUnknown()
length(it::RepeatCall) = it.n

"""
    repeatedly(f)
    repeatedly(f, n)
Call function `f` `n` times, or infinitely if `n` is omitted.
```julia
julia> t() = (sleep(0.1); Dates.millisecond(now()))
t (generic function with 1 method)
julia> collect(repeatedly(t, 5))
5-element Array{Any,1}:
 993
  97
 200
 303
 408
```
"""
repeatedly(f, n) = RepeatCall(f, n)
iterate(it::RepeatCall, state=it.n) = state <= 0 ? nothing : (it.f(), state - 1)

struct RepeatCallForever{F<:Base.Callable}
    f::F
end
IteratorSize(::Type{<:RepeatCallForever}) = IsInfinite()
IteratorEltype(::Type{<:RepeatCallForever}) = EltypeUnknown()

repeatedly(f) = RepeatCallForever(f)
iterate(it::RepeatCallForever, state=nothing) = (it.f(), nothing)


@deprecate chain(xss...) Iterators.flatten(xss)
@deprecate product(xss...) Iterators.product(xss...)


# Filter out reccuring elements.

struct Distinct{I, J}
    xs::I

    # Map elements to the index at which it was first seen, so given an iterator
    # state (index) we can test if an element has previously been observed.
    seen::Dict{J, Int}
end

IteratorSize(::Type{<:Distinct}) = SizeUnknown()

eltype(::Type{Distinct{I, J}}) where {I, J} = J

"""
    distinct(xs)
Iterate through values skipping over those already encountered.
```jldoctest
julia> for i in distinct([1,1,2,1,2,4,1,2,3,4])
           @show i
       end
i = 1
i = 2
i = 4
i = 3
```
"""
distinct(xs::I) where {I} = Distinct{I, eltype(xs)}(xs, Dict{eltype(xs), Int}())

function iterate(it::Distinct, state=(1,))
    idx, xs_state = first(state), tail(state)
    xs_iter = iterate(it.xs, xs_state...)

    while xs_iter !== nothing
        val, xs_state = xs_iter
        get!(it.seen, val, idx) >= idx && return (val, (idx + 1, xs_state))

        xs_iter = iterate(it.xs, xs_state)
        idx += 1
    end

    return nothing
end


# Group output from at iterator into tuples.
# E.g.,
#   partition(count(1), 2) = (1,2), (3,4), (5,6) ...
#   partition(count(1), 2, 1) = (1,2), (2,3), (3,4) ...
#   partition(count(1), 2, 3) = (1,2), (4,5), (7,8) ...

struct Partition{I, N}
    xs::I
    step::Int
end
IteratorSize(::Type{<:Partition}) = SizeUnknown()

eltype(::Type{Partition{I, N}}) where {I, N} = NTuple{N, eltype(I)}

"""
    partition(xs, n, [step])
Group values into `n`-tuples.
```jldoctest
julia> for i in partition(1:9, 3)
           @show i
       end
i = (1, 2, 3)
i = (4, 5, 6)
i = (7, 8, 9)
```
If the `step` parameter is set, each tuple is separated by `step` values.
```jldoctest
julia> for i in partition(1:9, 3, 2)
           @show i
       end
i = (1, 2, 3)
i = (3, 4, 5)
i = (5, 6, 7)
i = (7, 8, 9)
julia> for i in partition(1:9, 3, 3)
           @show i
       end
i = (1, 2, 3)
i = (4, 5, 6)
i = (7, 8, 9)
julia> for i in partition(1:9, 2, 3)
           @show i
       end
i = (1, 2)
i = (4, 5)
i = (7, 8)
```
"""
@inline partition(xs, n::Int) = partition(xs, n, n)

function partition(xs::I, n::Int, step::Int) where I
    if step < 1
        throw(ArgumentError("Partition step must be at least 1."))
    end

    if n < 1
        throw(ArgumentError("Partition size n must be at least 1"))
    end

    Partition{I, n}(xs, step)
end

function iterate(it::Partition{I, N}, state=nothing) where {I, N}
    if state === nothing
        result = Vector{eltype(I)}(undef, N)

        result[1], xs_state = @ifsomething iterate(it.xs)

        for i in 2:N
            result[i], xs_state = @ifsomething iterate(it.xs, xs_state)
        end
    else
        (xs_state, result) = state
        result[end], xs_state = @ifsomething iterate(it.xs, xs_state)
    end

    p = similar(result)
    overlap = max(0, N - it.step)
    p[1:overlap] .= result[it.step .+ (1:overlap)]

    # when step > n, skip over some elements
    for i in 1:max(0, it.step - N)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break
        _, xs_state = xs_iter
    end

    for i in (overlap + 1):(N - 1)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break

        p[i], xs_state = xs_iter
    end

    return (tuple(result...)::eltype(Partition{I, N}), (xs_state, p))
end


# Group output from an iterator based on a key function.
# Consecutive entries from the iterator with the same
# key value will be returned in a single array.
# Inspired by itertools.groupby in python.
# E.g.,
#   x = ["face", "foo", "bar", "book", "baz", "zzz"]
#   groupby(z -> z[1], x) =
#       ["face", "foo"]
#       ["bar", "book", "baz"]
#       ["zzz"]
struct GroupBy{I, F<:Base.Callable}
    keyfunc::F
    xs::I
end
IteratorSize(::Type{<:GroupBy}) = SizeUnknown()

eltype(::Type{<:GroupBy{I}}) where {I} = Vector{eltype(I)}

"""
    groupby(f, xs)
Group consecutive values that share the same result of applying `f`.
```jldoctest
julia> for i in groupby(x -> x[1], ["face", "foo", "bar", "book", "baz", "zzz"])
           @show i
       end
i = ["face", "foo"]
i = ["bar", "book", "baz"]
i = ["zzz"]
```
"""
function groupby(keyfunc::F, xs::I) where {F<:Base.Callable, I}
    GroupBy{I, F}(keyfunc, xs)
end

function iterate(it::GroupBy{I, F}, state=nothing) where {I, F<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        keep_going = true
    else
        keep_going, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    values = Vector{eltype(I)}()
    push!(values, prev_val)

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if key == prev_key
            push!(values, val)
        else
            prev_key = key
            prev_val = val
            break
        end
    end

    return (values, (keep_going, prev_key, prev_val, xs_state))
end


"""
    imap(f, xs1, [xs2, ...])
Iterate over values of a function applied to successive values from one or more iterators.
Like `Iterators.zip`, the iterator is done when any of the input iterators have been
exhausted.
```jldoctest
julia> for i in imap(+, [1,2,3], [4,5,6])
            @show i
       end
i = 5
i = 7
i = 9
```
"""
imap(mapfunc, it1, its...) = (mapfunc(xs...) for xs in zip(it1, its...))


# Iterate over all subsets of an indexable collection

struct Subsets{C}
    xs::C
end
IteratorSize(::Type{Subsets{C}}) where {C} = longest(HasLength(), IteratorSize(C))

eltype(::Type{Subsets{C}}) where {C} = Vector{eltype(C)}
length(it::Subsets) = 1 << length(it.xs)

"""
    subsets(xs)
    subsets(xs, k)
    subsets(xs, Val{k}())
Iterate over every subset of the indexable collection `xs`. You can restrict the subsets to a
specific size `k`.
Giving the subset size in the form `Val{k}()` allows the compiler to produce code optimized
for the particular size requested. This leads to performance comparable to hand-written
loops if `k` is small and known at compile time, but may or may not improve performance
otherwise.
```jldoctest
julia> for i in subsets([1, 2, 3])
          @show i
       end
i = Int64[]
i = [1]
i = [2]
i = [1, 2]
i = [3]
i = [1, 3]
i = [2, 3]
i = [1, 2, 3]
julia> for i in subsets(1:4, 2)
          @show i
       end
i = [1, 2]
i = [1, 3]
i = [1, 4]
i = [2, 3]
i = [2, 4]
i = [3, 4]
julia> for i in subsets(1:4, Val{2}())
           @show i
       end
i = (1, 2)
i = (1, 3)
i = (1, 4)
i = (2, 3)
i = (2, 4)
i = (3, 4)
```
"""
function subsets(xs)
    Subsets(xs)
end

# state has one extra bit to indicate that we are at the end
function iterate(it::Subsets, state=fill(false, length(it.xs) + 1))
    state[end] && return nothing

    ss = it.xs[state[1:end-1]]

    state = copy(state)
    state[1] = !state[1]
    for i in 2:length(state)
        if !state[i-1]
            state[i] = !state[i]
        else
            break
        end
    end

    return (ss, state)
end


# Iterate over all subsets of an indexable collection with a given size

struct Binomial{Collection}
    xs::Collection
    n::Int64
    k::Int64
end
Binomial(xs::C, n::Integer, k::Integer) where {C} = Binomial{C}(xs, n, k)

IteratorSize(::Type{<:Binomial}) = HasLength()
IteratorEltype(::Type{Binomial{C}}) where {C} = IteratorEltype(C)

eltype(::Type{Binomial{C}}) where {C} = Vector{eltype(C)}
length(it::Binomial) = binomial(it.n,it.k)

subsets(xs, k) = Binomial(xs, length(xs), k)

mutable struct BinomialIterState
    idx::Vector{Int64}
    done::Bool
end

function iterate(it::Binomial, state=BinomialIterState(collect(Int64, 1:it.k), it.k > it.n))
    state.done && return nothing

    idx = state.idx
    set = it.xs[idx]
    i = it.k
    while i > 0
        if idx[i] < it.n - it.k + i
            idx[i] += 1

            for j in 1:it.k-i
                idx[i+j] = idx[i] + j
            end

            break
        else
            i -= 1
        end
    end

    state.done = i == 0

    return set, state
end


# Iterate over all subsets of an indexable collection with a given *statically* known size

struct StaticSizeBinomial{K, Container}
    xs::Container
end

IteratorSize(::Type{StaticSizeBinomial{K, C}}) where {K, C} = HasLength()
IteratorEltype(::Type{StaticSizeBinomial{K, C}}) where {K, C} = IteratorEltype(C)

eltype(::Type{StaticSizeBinomial{K, C}}) where {K, C} = NTuple{K, eltype(C)}
length(it::StaticSizeBinomial{K}) where {K} = binomial(length(it.xs), K)

subsets(xs::C, ::Val{K}) where {K, C} = StaticSizeBinomial{K, C}(xs)

# Special case for K == 0
iterate(it::StaticSizeBinomial{0}, state=false) = state ? nothing : ((), true)

# Generic case K >= 1
pop(t::NTuple) = reverse(tail(reverse(t))), t[end]

function advance(it::StaticSizeBinomial{K}, idx) where {K}
	xs = it.xs
	lidx, i = pop(idx)
    i += 1
	if i > length(xs) - K + length(idx)
		lidx = advance(it, lidx)
		i = lidx[end] + 1
	end
	return (lidx..., i)
end
advance(it::StaticSizeBinomial, idx::NTuple{1}) = (idx[end]+1,)

function iterate(it::StaticSizeBinomial{K}, idx=ntuple(identity, Val{K}())) where K
    idx[end] > length(it.xs) && return nothing
    return (map(i -> it.xs[i], idx), advance(it, idx))
end


# nth : return the nth element in a collection

"""
    nth(xs, n)
Return the `n`th element of `xs`. This is mostly useful for non-indexable collections.
```jldoctest
julia> mersenne = Set([3, 7, 31, 127])
Set([7, 31, 3, 127])
julia> nth(mersenne, 3)
3
```
"""
function nth(xs, n::Integer)
    n > 0 || throw(BoundsError(xs, n))

    # catch, if possible
    has_length(xs) && (n ≤ length(xs) || throw(BoundsError(xs, n)))

    for (i, val) in enumerate(xs)
        i >= n && return val
    end

    # catch iterators with no length but actual finite size less then n
    throw(BoundsError(xs, n))
end

nth(xs::Union{Tuple, Array}, n::Integer) = xs[n]

function nth(xs::AbstractArray, n::Integer)
    idx = eachindex(xs)[n]
    return @inbounds xs[idx]
end


# takenth(xs,n): take every n'th element from xs

struct TakeNth{I}
    xs::I
    interval::UInt
end
IteratorSize(::Type{TakeNth{I}}) where {I} = longest(HasLength(), IteratorSize(I))
IteratorEltype(::Type{TakeNth{I}}) where {I} = IteratorEltype(I)
eltype(::Type{TakeNth{I}}) where {I} = eltype(I)
length(x::TakeNth) = div(length(x.xs), x.interval)

"""
    takenth(xs, n)
Iterate through every `n`th element of `xs`.
```jldoctest
julia> collect(takenth(5:15,3))
3-element Array{Int64,1}:
  7
 10
 13
```
"""
function takenth(xs, interval::Integer)
    if interval <= 0
        throw(ArgumentError(string("expected interval to be 1 or more, ",
                                   "got $interval")))
    end
    TakeNth(xs, convert(UInt, interval))
end


function iterate(it::TakeNth, state...)
    xs_iter = nothing

    for i = 1:it.interval
        xs_iter = @ifsomething iterate(it.xs, state...)
        state = tail(xs_iter)
    end

    return xs_iter
end


struct Iterated{T, F}
    f::F
    seed::T
end
IteratorSize(::Type{<:Iterated}) = IsInfinite()
IteratorEltype(::Type{<:Iterated}) = EltypeUnknown()

"""
    iterated(f, x)
Iterate over successive applications of `f`, as in `x`, `f(x)`, `f(f(x))`, `f(f(f(x)))`, ...
Use `Base.Iterators.take()` to obtain the required number of elements.
```jldoctest
julia> for i in Iterators.take(iterated(x -> 2x, 1), 5)
           @show i
       end
i = 1
i = 2
i = 4
i = 8
i = 16
julia> for i in Iterators.take(iterated(sqrt, 100), 6)
           @show i
       end
i = 100
i = 10.0
i = 3.1622776601683795
i = 1.7782794100389228
i = 1.333521432163324
i = 1.1547819846894583
```
"""
iterated(f, seed) = Iterated(f, seed)

iterate(it::Iterated) = (it.seed, it.seed)
function iterate(it::Iterated{T, F}, state) where {T, F}
    newval = it.f(state)
    return (newval, newval)
end

# peekiter(iter): possibility to peek the head of an iterator

struct PeekIter{I}
    it::I
end

"""
    peekiter(xs)
Lets you peek at the head element of an iterator without updating the state.
```jldoctest
julia> it = peekiter(["face", "foo", "bar", "book", "baz", "zzz"])
IterTools.PeekIter{Array{String,1}}(["face", "foo", "bar", "book", "baz", "zzz"])
julia> @show peek(it);
peek(it) = Some("face")
julia> @show peek(it);
peek(it) = Some("face")
julia> x, s = iterate(it)
("face", ("foo", 3))
julia> @show x;
x = "face"
julia> @show peek(it, s);
peek(it, s) = Some("foo")
```
"""
peekiter(itr) = PeekIter(itr)

eltype(::Type{PeekIter{I}}) where {I} = eltype(I)
IteratorSize(::Type{PeekIter{I}}) where {I} = IteratorSize(I)
IteratorEltype(::Type{PeekIter{I}}) where {I} = IteratorEltype(I)
length(f::PeekIter) = length(f.it)
size(f::PeekIter) = size(f.it)

function iterate(pit::PeekIter, state=iterate(pit.it))
    val, it_state = @ifsomething state
    return (val, iterate(pit.it, it_state))
end

peek(pit::PeekIter, state=iterate(pit)) = Some{eltype(pit)}(first(@ifsomething state))

#NCycle - cycle through an object N times

struct NCycle{I}
    iter::I
    n::Int
end

"""
    ncycle(iter, n)
Cycle through `iter` `n` times.
```jldoctest
julia> for i in ncycle(1:3, 2)
           @show i
       end
i = 1
i = 2
i = 3
i = 1
i = 2
i = 3
```
"""
ncycle(iter, n::Int) = NCycle(iter, n)

eltype(::Type{NCycle{I}}) where {I} = eltype(I)
length(nc::NCycle) = nc.n*length(nc.iter)
IteratorSize(::Type{NCycle{I}}) where {I} = longest(HasLength(), IteratorSize(I))
IteratorEltype(::Type{NCycle{I}}) where {I} = IteratorEltype(I)

function iterate(nc::NCycle, state=(nc.n,))
    nc.n <= 0 && return nothing  # don't do anything if we aren't iterating

    n, inner_state = first(state), tail(state)
    inner_iter = iterate(nc.iter, inner_state...)

    if inner_iter === nothing
        if n <= 1
            return nothing
        else
            inner_iter = @ifsomething iterate(nc.iter)

            n -= 1
        end
    end

    v, inner_state = inner_iter
    return v, (n, inner_state)
end

# IVec - lazy `vec`-like iterator that drops shape

struct IVec{I}
    iter::I
end

"""
    ivec(iter)
Drops all shape from `iter` while iterating.
Like a non-materializing version of [`vec`](https://docs.julialang.org/en/stable/base/arrays/#Base.vec).
```jldoctest
julia> m = collect(reshape(1:6, 2, 3))
2×3 Array{Int64,2}:
 1  3  5
 2  4  6
julia> collect(ivec(m))
6-element Array{Int64,1}:
 1
 2
 3
 4
 5
 6
```
"""
ivec(iter) = IVec(iter)

eltype(::Type{IVec{I}}) where {I} = eltype(I)
length(iv::IVec) = length(iv.iter)
IteratorSize(::Type{IVec{I}}) where {I} = longest(HasLength(), IteratorSize(I))
IteratorEltype(::Type{IVec{I}}) where {I} = IteratorEltype(I)

iterate(iv::IVec, state...) = iterate(iv.iter, state...)

# FlagFirst: prepend a flag that is `true` iff this is the first element

struct FlagFirst{I}
    iter::I
end

"""
    flagfirst(iter)
An iterator that yields `(isfirst, x)` where `isfirst::Bool` is `true` for the first
element, and `false` after that, while the `x`s are elements from `iter`.
```jldoctest
julia> collect(flagfirst(1:3))
3-element Array{Tuple{Bool,Int64},1}:
 (true, 1)
 (false, 2)
 (false, 3)
```
"""
flagfirst(iter) = FlagFirst(iter)

eltype(::Type{FlagFirst{I}}) where I = Tuple{Bool, eltype(I)}
length(ff::FlagFirst) = length(ff.iter)
size(ff::FlagFirst) = size(ff.iter)
IteratorSize(::Type{FlagFirst{I}}) where {I} = IteratorSize(I)
IteratorEltype(::Type{FlagFirst{I}}) where {I} = IteratorEltype(I)

function iterate(ff::FlagFirst, state = (true, ))
    isfirst, rest = first(state), tail(state)
    elt, nextstate = @ifsomething iterate(ff.iter, rest...)
    (isfirst, elt), (isfirst & false, nextstate)
end

# TakeWhile iterates through values from an iterable as long as a given predicate is true.

struct TakeWhile{I}
    cond::Function
    xs::I
end

"""
    takewhile(cond, xs)
An iterator that yields values from the iterator `xs` as long as the
predicate `cond` is true.
```jldoctest
julia> collect(takewhile(x-> x^2 < 10, 1:100))
3-element Array{Int64,1}:
 1
 2
 3
```
"""
takewhile(cond, xs) = TakeWhile(cond, xs)

function Base.iterate(it::TakeWhile, state=nothing)
    (val, state) = @ifsomething (state === nothing ? iterate(it.xs) : iterate(it.xs, state))
    it.cond(val) || return nothing
    val, state
end

Base.IteratorSize(it::TakeWhile) = Base.SizeUnknown()
eltype(::Type{TakeWhile{I}}) where {I} = eltype(I)
IteratorEltype(::Type{TakeWhile{I}}) where {I} = IteratorEltype(I)

# Properties

struct Properties{T}
    x::T
    n::Int
    names
end

"""
    properties(x)
Iterate through the names and value of the properties of `x`.
```jldoctest
julia> collect(properties(1 + 2im))
2-element Array{Any,1}:
 (:re, 1)
 (:im, 2)
```
"""
function properties(x::T) where T
    names = propertynames(x)
    return Properties{T}(x, length(names), names)
end

function iterate(p::Properties, state=1)
    state > length(p) && return nothing

    name = p.names[state]
    return ((name, getproperty(p.x, name)), state + 1)
end

# PropertyValues

struct PropertyValues{T}
    x::T
    n::Int
    names
end

"""
    propertyvalues(x)
Iterate through the values of the properties of `x`.
```jldoctest
julia> collect(propertyvalues(1 + 2im))
2-element Array{Any,1}:
 1
 2
```
"""

function propertyvalues(x::T) where T
    names = propertynames(x)
    return PropertyValues{T}(x, length(names), names)
end

function iterate(p::PropertyValues, state=1)
    state > length(p) && return nothing

    name = p.names[state]
    return (getproperty(p.x, name), state + 1)
end

length(p::Union{Properties, PropertyValues}) = p.n
IteratorSize(::Type{<:Union{Properties, PropertyValues}}) = HasLength()

# FieldValues

struct FieldValues{T}
    x::T
end

"""
    fieldvalues(x)
Iterate through the values of the fields of `x`.
```jldoctest
julia> collect(fieldvalues(1 + 2im))
2-element Array{Any,1}:
 1
 2
```
"""
fieldvalues(x::T) where {T} = FieldValues{T}(x)
length(fs::FieldValues{T}) where {T} = fieldcount(T)
IteratorSize(::Type{<:FieldValues}) = HasLength()

function iterate(fs::FieldValues, state=1)
    state > length(fs) && return nothing

    return (getfield(fs.x, state), state + 1)
end

end # module IterTools
#==
This is the end of the main
module, nothing is to be written
beyond here
==#
end