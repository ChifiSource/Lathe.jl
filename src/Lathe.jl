#===============================
<-----------Lathe.jl----------->
~~~~~~ 0.1.7 "ButterBall" ~~~~~~
Programmed by Emmett Boudreau
    <emmett@emmettboudreau.com>
        <http://emmettboudreau.com>
MIT General Open Source License
    (V 3.0.0)
        Free for Modification and
        Redistribution
=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=|
         CONTRIBUTORS
=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=|
        ~ emmettgb
        ~ stefanches7
        ~ PallHaraldsson
/><><><><><><><><><><><><><><><><\
Thank you for your forks!
<-----------Lathe.jl----------->
38d8eb38-e7b1-11e9-0012-376b6c802672
#[deps]
DataFrames.jl
Random.jl
================================#
@doc """
# Lathe.jl 0.1.6 Butterball
## Easily ML
38d8eb38-e7b1-11e9-0012-376b6c802672

### [contributors]
- emmettgb
- stefanches7
- PallHaraldsson
### [deps]
- DataFrames.jl
- Random.jl
- Distributions.jl
### Modules
**Use ?(Module) for more information!**
- stats
- preprocess
- models
       """
module Lathe
#
# <------- DEPS ----->
using DataFrames
using Random
# <------- DEPS ----->
#
# <------- PARTS ----->
include("Stats.jl")
include("Models.jl")
include("Preprocess.jl")
# <------- PARTS ----->
#
end
