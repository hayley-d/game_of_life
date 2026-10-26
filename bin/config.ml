module Grid = Game_of_life.Grid
module Pattern = Game_of_life.Pattern

type config = {
  width : int;
  height : int;
  random_alive_chance : float;
  seconds_between_generations : float;
  pattern_margin : int;
  behaviour : Grid.grid_behaviour;
  pattern : string;
}

let default_width = 60
let default_height = 30
let default_seconds_between_generations = 0.1
let default_random_alive_chance = 0.3
let default_pattern_margin = 1
let default_pattern = "random"

let read_int name default =
  match Sys.getenv_opt name with
  | Some value -> Option.value (int_of_string_opt value) ~default
  | None -> default

let read_float name default =
  match Sys.getenv_opt name with
  | Some value -> Option.value (float_of_string_opt value) ~default
  | None -> default

let read_behaviour () =
  match Option.map String.lowercase_ascii (Sys.getenv_opt "WRAP_EDGES") with
  | Some "false" -> Grid.Strict
  | _ -> Grid.Wrap

let read_pattern () =
  match Option.map String.lowercase_ascii (Sys.getenv_opt "PATTERN") with
  | Some name when name = "random" || List.mem name Pattern.pattern_names ->
      name
  | _ -> default_pattern

let load () =
  Dotenv.export ();
  {
    behaviour = read_behaviour ();
    width = read_int "WIDTH" default_width;
    height = read_int "HEIGHT" default_height;
    seconds_between_generations =
      read_float "SECONDS_BETWEEN_GENERATIONS"
        default_seconds_between_generations;
    random_alive_chance =
      read_float "RANDOM_ALIVE_CHANCE" default_random_alive_chance;
    pattern_margin = read_int "PATTERN_MARGIN" default_pattern_margin;
    pattern = read_pattern ();
  }
