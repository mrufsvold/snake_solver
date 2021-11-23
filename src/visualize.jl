using Pkg
Pkg.activate(".")
using Revise
using Gtk
c = @GtkCanvas()
set_gtk_property!(c,:expand,true)
b = GtkBox(:h)
push!(b,c)
set_gtk_property!(b,:expand,c,true)
win = GtkWindow(b, "Snake")
grid_size = 5

test_snake = [
    [1,5],
    [2,2],
    [4,4],
    [0,0],
    [5,5]
]
function create_window()
    @guarded draw(c) do widget
        ctx = getgc(c)
        h = height(c)
        w = width(c)
        # Paint background black
        rectangle(ctx, 0, 0, w, h)
        set_source_rgb(ctx, 0, 0, 0)
        fill(ctx)
    end
    showall(win)
end

create_window()

function add_snake()
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
        for node in test_snake
            rectangle(ctx, (node[1] - 1)*cell_edge_length + border_width, (node[2]-1)*cell_edge_length + border_width, cell_edge_length, cell_edge_length)
            set_source_rgb(ctx, 1, 1, 1)
            fill(ctx)
        end
    end
    showall(win)
end

add_snake()