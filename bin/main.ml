module Grid = Game_of_life.Grid

let behaviour_from_env () = match Option.map String.lowercase_ascii (Sys.getenv_opt "WRAP_EDGES") with
        | Some "false" -> Grid.Strict
        | _ -> Grid.Wrap

let behaviour = Grid.describe_grid_behaviour (behaviour_from_env ())
let () = print_endline behaviour 
