#<----Mean---->
"""
    ## Mean
    ### Description
      Returns the mean of an array.\n
      --------------------\n
    ### Input
      mean(x)\n
      --------------------\n
      #### Positional Arguments
      Array{Any} - x:: Array to obtain the mean of.
      --------------------\n
     ### Output
     mu:: The mean of the provided array.
       """
mean(x) = sum(x) / length(x)
#<----Median---->
"""
      Calculates the median (numerical center) of a given array.\n
      --------------------\n
      array = [5,10,15]\n
      median = Lathe.stats.median(array)\n
      println(median)\n
        10
       """
function median(array)
    n = length(array)
    half = n / 2
    current = 1
    sorted = sort!(array,rev = false)
    median = 0
    for i in sorted
        if current >= half
            median = i
        else
        current = current + 1
    end
    end
    return(median)
end
#<----Mode---->
"""
      Gives the digit most common in a given array\n
      --------------------\n
      array = [5,10,15,15,10,5,10]\n
      mode = Lathe.stats.mode(array)\n
      println(mode)\n
        10
       """
function mode(array)
    m = findmax(array)
    return(m)
end
#<----Variance---->
"""
      Gives the variance of an array..\n
      --------------------\n
      array = [5,10,15]\n
      variance = Lathe.stats.variance(array)\n
       """
function variance(array)
    me = mean(array)
    sq = sum(array) - me
    squared_mean = sq ^ 2
    return(squared_mean)
end
#<----Confidence Intervals---->
"""
      Returns the confidence intervals of given data.\n
      --------------------\n
      array = [5,10,15]\n
      confidence = .98\n
      low, high = Lathe.stats.confints(array,confidence)\n
      --------------------\n
      PARAMETERS\n
      confidence: Confidence is a float percentage representing the level of
      confidence required in your test. The confidence metric is used
      exclusively for calculating the interval.
       """
function confints(data, confidence=.95)
    mean = stats.mean(data)
    std = std(data)
    stderr = ste(data)
#    interval = stderr * scs.t.ppf((1 + confidence) / 2.0, n-1)
#    return (mean-interval, mean+interval)
end
#<----Standard Error---->
@doc """
      Calculates the Standard Error of an array.\n
      --------------------\n
      array = [5,10,15]\n
      ste = Lathe.stats.standarderror(array)"""
function ste(data)
    std = std(data)
    sample = length(data)
    ste = (std/sqrt(sample))
    return(ste)
end
#<----Standard Deviation---->
"""
      Calculates the Standard Deviation of a given array.\n
      --------------------\n
      array = [5,10,15]\n
      std = Lathe.stats.std(array)\n
       """
function std(array3)
    m = mean(array3)
    [i = (i-m) ^ 2 for i in array3]
    m = mean(array3)
    try
        m = sqrt(m)
    catch
        m = sqrt(Complex(m))
    end
    return(m)
end
#<----Quartiles---->
# - First
"""
      Returns the point in an array located at 25 percent of the sorted data.\n
      --------------------\n
      array = [5,10,15]\n
      q1 = Lathe.stats.firstquar(array)\n
       """
function q1(array)
    m = median(array)
    q1 = array * .5
    return(q1)
end
# - Third
"""
      Returns the point in an array located at 75 percent of the sorted data.\n
      --------------------\n
      array = [5,10,15]\n
      q2 = Lathe.stats.secondquar(array)\n
       """
function q3(array)
    q = median(array)
    q3 = q * 1.5
    return(q3)
end
# <---- Rank ---->
"""
      Ranks indices in an array based on quantitative weight (count of the
      numbers) and returns a new array of the ranks of each column. This
      function is made primarily for the Wilcox Rank-Sum test.\n
      --------------------\n
      array = [5,10,15]\n
      q2 = Lathe.stats.secondquar(array)\n
       """
function getranks(array,rev = false)
    sortedar = sort(array,rev=rev)
    num = 1
    list = []
    for i in sortedar
        append!(list,i)
        num = num + 1
    end
    return(list)
end
"""
    ## Factorials
    ### Description
      Calculates the factorial of a number.\n
      --------------------\n
    ### Input
      fact(n)\n
      --------------------\n
      #### Positional Arguments
      Int64 - n:: The number for the factorial.\n
      --------------------\n
     ### Output
     f:: Factorial of n
       """
function fact(n)
    if n == 1
        return(1)
    else
        return n * fact(n-1)
    end
end

is_prime(n) = φ(n) == n - 1
