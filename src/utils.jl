function repeat_items(arr::AbstractArray,repeatcount::Int)
    collect(Iterators.flatten([repeat([a],repeatcount) for a in arr]))
end