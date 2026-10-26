module Grid = Game_of_life.Grid

let cell_to_string cell = 
    match cell with
        | Grid.Alive -> "# "
        | Grid.Dead -> ". "

let to_string grid = 
    let buffer = Buffer.create 1024 in
    for y = 0 to Grid.height grid - 1 do
        for x = 0 to Grid.width grid - 1 do
            Buffer.add_string buffer (cell_to_string (Grid.get grid x y))
        done;
        Buffer.add_char buffer '\n'
    done;
    Buffer.contents buffer
