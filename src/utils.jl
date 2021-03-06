using YAML

config = YAML.load_file("config.yml")

function get_grid_size()
    gs = get(config, "grid_size", 10)
    gs % 2 == 0 ? gs : gs + 1 #Grid sizes need to be even
end

function repeat_items(arr::AbstractArray,repeatcount::Int)
    collect(Iterators.flatten([repeat([a],repeatcount) for a in arr]))
end
