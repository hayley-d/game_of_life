type cell = Alive | Dead
type grid_behaviour = Wrap | Strict
type grid

val create : int -> int -> grid_behaviour -> grid
val width : grid -> int
val height : grid -> int
val get : grid -> int -> int -> cell
val set : grid -> int -> int -> cell -> grid
val step : grid -> grid
val equal : grid -> grid -> bool
val describe_grid_behaviour : grid_behaviour -> string
val init : int -> int -> grid_behaviour -> (int -> int -> cell) -> grid
val step_into : grid -> grid -> unit
val parallel_step_into : int -> grid -> grid -> unit
