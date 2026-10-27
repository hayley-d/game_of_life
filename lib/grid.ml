type cell = Alive | Dead
type grid_behaviour = Wrap | Strict

type grid = {
  width : int;
  height : int;
  behaviour : grid_behaviour;
  cells : cell array array;
}

let create width height behaviour =
  let cells = Array.make_matrix height width Dead in
  { width; height; behaviour; cells }

let width grid = grid.width
let height grid = grid.height

let get grid x y =
  if x >= 0 && y >= 0 && x < grid.width && y < grid.height then
    grid.cells.(y).(x)
  else Dead

let set grid x y cell =
  if x < 0 || y < 0 || x >= grid.width || y >= grid.height then
    failwith "index out of bounds"
  else
    let new_cells = Array.map Array.copy grid.cells in
    new_cells.(y).(x) <- cell;
    { grid with cells = new_cells }

let wrap_coordinate value size = ((value mod size) + size) mod size

let neighbour_offsets =
  [ (-1, -1); (0, -1); (1, -1); (-1, 0); (1, 0); (-1, 1); (0, 1); (1, 1) ]

let neighbour grid x y =
  match grid.behaviour with
  | Strict -> get grid x y
  | Wrap ->
      get grid (wrap_coordinate x grid.width) (wrap_coordinate y grid.height)

let on_edge grid x y =
  x = 0 || y = 0 || x = grid.width - 1 || y = grid.height - 1

let count_neighbours grid x y =
  let is_on_edge = on_edge grid x y in
  let count = ref 0 in
  for dy = -1 to 1 do
    for dx = -1 to 1 do
      if not (dx = 0 && dy = 0) then
        let cell =
          if is_on_edge then neighbour grid (x + dx) (y + dy)
          else grid.cells.(y + dy).(x + dx)
        in
        match cell with Alive -> incr count | Dead -> ()
    done
  done;
  !count

let next_cell cell neighbours =
  match (cell, neighbours) with
  | Alive, (2 | 3) -> Alive
  | Dead, 3 -> Alive
  | _ -> Dead

let check_same_size source destination =
  if source.width <> destination.width || source.height <> destination.height
  then invalid_arg "step_into: grids must be the same size"

let step_rows source destination first_row last_row =
  for y = first_row to last_row do
    for x = 0 to source.width - 1 do
      destination.cells.(y).(x) <-
        next_cell source.cells.(y).(x) (count_neighbours source x y)
    done
  done

let step_into source destination =
  check_same_size source destination;
  step_rows source destination 0 (source.height - 1)

let step grid =
  let next_grid = create grid.width grid.height grid.behaviour in
  step_into grid next_grid;
  next_grid

let parallel_step_into domain_count source destination =
  if domain_count < 1 then
    invalid_arg "parallel_step_into: need at least 1 domain";
  check_same_size source destination;
  let rows_per_domain = (source.height + domain_count - 1) / domain_count in
  let spawn_worker index =
    let first_row = index * rows_per_domain in
    let last_row = min (first_row + rows_per_domain - 1) (source.height - 1) in
    Domain.spawn (fun () -> step_rows source destination first_row last_row)
  in
  let workers = List.init domain_count spawn_worker in
  List.iter Domain.join workers

let equal grid_a grid_b = grid_a = grid_b

let describe_grid_behaviour behaviour =
  match behaviour with Wrap -> "wrap" | Strict -> "no wrap"

let init width height behaviour cell_at =
  let cells =
    Array.init height (fun y -> Array.init width (fun x -> cell_at x y))
  in
  { width; height; behaviour; cells }
