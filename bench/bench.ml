module Grid = Game_of_life.Grid

let grid_size = 1000
let generations = 100
let alive_chance = 0.2
let random_seed = 42
let domain_count = Domain.recommended_domain_count ()

let random_cell _x _y =
  if Random.float 1.0 < alive_chance then Grid.Alive else Grid.Dead

let rec step_n current spare remaining =
  if remaining = 0 then current
  else begin
    Grid.parallel_step_into domain_count current spare;
    step_n spare current (remaining - 1)
  end

let () =
  Random.init random_seed;
  let grid = Grid.init grid_size grid_size Grid.Wrap random_cell in
  let spare = Grid.create grid_size grid_size Grid.Wrap in
  let start_bytes = Gc.allocated_bytes () in
  let start_time = Unix.gettimeofday () in
  let _final_grid = step_n grid spare generations in
  let elapsed_seconds = Unix.gettimeofday () -. start_time in
  let megabytes_per_generation =
    (Gc.allocated_bytes () -. start_bytes)
    /. 1_000_000.0 /. float_of_int generations
  in
  let milliseconds_per_generation =
    elapsed_seconds *. 1000.0 /. float_of_int generations
  in
  Printf.printf "%d generations on a %dx%d grid\n" generations grid_size
    grid_size;
  Printf.printf "total: %.2f s\n" elapsed_seconds;
  Printf.printf "per generation: %.2f ms\n" milliseconds_per_generation;
  Printf.printf "allocated per generation: %.1f MB\n" megabytes_per_generation
