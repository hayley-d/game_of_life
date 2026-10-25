    type cell = Alive | Dead
    type grid_behaviour = Wrap | Strict
    type grid = {
        width: int;
        height: int;
        behaviour: grid_behaviour;
        cells: cell array array;
    }

    let create width height behaviour = 
        let cells = Array.make_matrix height width Dead in
        { width; height; behaviour; cells; }
 
    let width grid = grid.width

    let height grid = grid.height

    let get grid x y =
        if x >= 0 && y >= 0 && x < grid.width && y < grid.height then grid.cells.(y).(x) else Dead

    let set grid x y cell = 
        if x < 0 || y < 0 || x >= grid.width || y >= grid.height  then failwith "index out of bounds" else
        let new_cells = Array.map Array.copy grid.cells in
            new_cells.(y).(x) <- cell; 
        { grid with cells = new_cells }

    let wrap_coordinate value size = ((value mod size) + size) mod size

    let neighbour_offsets = [ (-1,-1); (0,-1); (1,-1); (-1,0); (1,0); (-1,1); (0,1); (1,1) ]

    let neighbour grid x y =
    match grid.behaviour with
    | Strict -> get grid x y
    | Wrap -> get grid (wrap_coordinate x grid.width) (wrap_coordinate y grid.height)

    let count_neighbours grid x y =
        List.fold_left
            (fun count (dx, dy) -> 
                match neighbour grid (x + dx) (y + dy) with
                | Alive -> count + 1
                | Dead -> count)
            0 neighbour_offsets

    let next_cell cell neighbours = 
        match cell, neighbours with
        | Alive, (2 | 3) -> Alive
        | Dead, 3 -> Alive
        | _ -> Dead

    let step grid = 
        let cells = 
            Array.init grid.height (fun y ->
                Array.init grid.width (fun x -> 
                    next_cell grid.cells.(y).(x) (count_neighbours grid x y)))
        in
        { grid with cells }
        

    let equal grid_a grid_b =
        grid_a = grid_b

    let describe_grid_behaviour behaviour = match behaviour with
        | Wrap -> "wrap"
        | Strict -> "no wrap"
