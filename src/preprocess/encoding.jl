# <---- One Hot Encoder ---->
"""
    ## OneHotEncoder
    ### Description
      One Hot Encodes a dataframe column into a dataframe.\n
      --------------------\n
    ### Input
      OneHotEncoder()\n
      --------------------\n
     ### Output
     encoder :: A Lathe Preprocesser object.
     ---------------------\n
     ### Functions
     Preprocesser.predict(df, symb) :: Applies the encoder to the dataframe key
      corresponding with symb on DF, then returns a dataframe with encoded
      results.
       """
mutable struct OneHotEncoder{P} <: Encoder
    predict::P
    function OneHotEncoder()
        predict(df::DataFrame, symb::Symbol) = _onehot(df, symb)
        P =  typeof(predict)
        return new{P}(predict)
    end
end

function _onehot(df,symb)
    copy = df
    for c in unique(copy[!,symb])
        copy[!,Symbol(c)] = copy[!,symb] .== c
    end
    return(copy)
end
"""
    ## Ordinal Encoder
    ### Description
     Ordinally Encodes an array.\n
      --------------------\n
    ### Input
      OrdinalEncoder(x)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - x:: Array for which the original scaler should be based
      off of.\n
      --------------------\n
     ### Output
     encoder :: A Lathe Preprocesser object.
     ---------------------\n
     ### Functions
     Preprocesser.predict(xt) :: Returns an ordinally encoded xt.\n
       """
mutable struct OrdinalEncoder{P} <: Encoder
    predict::P
    lookup::Dict
    function OrdinalEncoder(array::Array)
        lookup = Dict(v => i for (i,v) in array |> unique |> enumerate)
        predict(arr::Array) = map(x->lookup[x], arr)
        predict(df::DataFrame, symb::Symbol) = map(x->lookup[x], df[!, symb])
        P =  typeof(predict)
        return new{P}(predict, lookup)
    end
end
"""
    ## Float Encoder
    ### Description
     Float/Label Encodes an array.\n
      --------------------\n
    ### Input
      OneHotEncoder()\n
      --------------------\n
     ### Output
     encoder :: A Lathe Preprocesser object.
     ---------------------\n
     ### Functions
     Preprocesser.predict(xt) :: Returns an ordinally encoded xt.\n
       """
mutable struct FloatEncoder{P} <: Encoder
    predict::P
    function FloatEncoder()
        predict(array::Array) = _floatencode(array)
        predict(df::DataFrame, symb::Symbol) = _floatencoder(df[!, symb])
        P = typeof(predict)
        return new{P}(predict)
    end
end


function _floatencode(array)
    encoded_array = []
    for dim in array
        newnumber = 0
        for char in dim
            newnumber += Float64(char)
        end
        append!(encoded_array, newnumber)
    end
    return(encoded_array)
end
