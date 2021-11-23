using YAML

config = YAML.load_file("config.yml")

function get_grid_size()
    get(config, "grid_size", 3)
end
function repeat_items(arr::AbstractArray,repeatcount::Int)
    collect(Iterators.flatten([repeat([a],repeatcount) for a in arr]))
end
