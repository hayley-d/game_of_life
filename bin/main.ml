module Grid = Game_of_life.Grid

let clear_screen = "\027[2J\027[H"
let config = Config.load ()

let rec run grid generation =
  print_string clear_screen;
  print_string (Render.to_string grid);
  Printf.printf "Generation: %d\n" generation;
  flush stdout;
  Unix.sleepf config.seconds_between_generations;
  run (Grid.step grid) (generation + 1)

let () = run (Seed.start_grid config) 0
