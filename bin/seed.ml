module Pattern = Game_of_life.Pattern
module Grid = Game_of_life.Grid

let random_grid (config : Config.config) =
  Random.self_init ();
  Grid.init config.width config.height config.behaviour (fun _x _y ->
      if Random.float 1.0 < config.random_alive_chance then Grid.Alive
      else Grid.Dead)

let pattern_grid pattern (config : Config.config) =
  Pattern.place pattern config.pattern_margin config.pattern_margin
    (Grid.create config.width config.height config.behaviour)

let start_grid (config : Config.config) =
  match Pattern.of_name config.pattern with
  | Some pattern -> pattern_grid pattern config
  | None -> random_grid config
