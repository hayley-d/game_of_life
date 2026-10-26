module Grid = Game_of_life.Grid
module Pattern = Game_of_life.Pattern

let clear_screen = "\027[2J\027[H"
let config = Config.load ()

let rec run grid generation =
  print_string clear_screen;
  print_string (Render.to_string grid);
  Printf.printf "Generation: %d\n" generation;
  flush stdout;
  Unix.sleepf config.seconds_between_generations;
  run (Grid.step grid) (generation + 1)

let random_grid () =
  Random.self_init ();
  Grid.init config.width config.height config.behaviour (fun _x _y ->
      if Random.float 1.0 < config.random_alive_chance then Grid.Alive
      else Grid.Dead)

let pattern_grid pattern =
  Pattern.place pattern config.pattern_margin config.pattern_margin
    (Grid.create config.width config.height config.behaviour)

let start_grid () =
  match Pattern.of_name config.pattern with
  | Some pattern -> pattern_grid pattern
  | None -> random_grid ()

let () = run (start_grid ()) 0
