using Pkg
Pkg.activate(".")
using Revise
using Gtk
import YAML
includet("utils.jl")
includet("structures.jl")

# Setup display window
c = @GtkCanvas()
set_gtk_property!(c,:expand,true)
b = GtkBox(:h)
push!(b,c)
set_gtk_property!(b,:expand,c,true)
win = GtkWindow(b, "Snake")
grid_size = get_grid_size()

function draw_window(snake::AbstractVector{Node}, apple::Node)
    @guarded draw(c) do widget
        ctx = getgc(c)
        h = height(c)
        w = width(c)
        # Get shorter edge
        size = min(h,w)
        # Paint Outer Background for Border
        rectangle(ctx, 0, 0, w, h)
        set_source_rgb(ctx, .5, .5, .5)
        fill(ctx)
        # Paint Background Black
        border_width = size/100
        rectangle(ctx, border_width, border_width, size-(border_width*2), size-(border_width*2))
        set_source_rgb(ctx, 0, 0, 0)
        fill(ctx)

        #Get size for snake nodes
        cell_edge_length = (size-(border_width*2)) / grid_size
        # Paint snake nodes
        for node in snake
            rectangle(ctx, (node.col - 1)*cell_edge_length + border_width, (node.row-1)*cell_edge_length + border_width, cell_edge_length, cell_edge_length)
            set_source_rgb(ctx, 1, 1, 1)
            fill(ctx)
        end
        # Paint apple
        rectangle(ctx, (apple.col - 1)*cell_edge_length + border_width, (apple.row - 1)*cell_edge_length + border_width, cell_edge_length, cell_edge_length)
        set_source_rgb(ctx, 1, 0, 0)
        fill(ctx)
    end
    showall(win)
end

# draw_window(test_snake1, test_apple)
# draw_window(test_snake2, test_apple)