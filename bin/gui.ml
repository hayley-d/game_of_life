module Grid = Game_of_life.Grid

let cell_size = 12
let config = Config.load ()

type state = { grid : Grid.grid; time_since_step : float; paused : bool }

let draw_grid grid =
  for y = 0 to Grid.height grid - 1 do
    for x = 0 to Grid.width grid - 1 do
      let colour =
        match Grid.get grid x y with
        | Grid.Alive -> Config.alive_colour
        | Grid.Dead -> Config.dead_colour
      in
      Raylib.draw_rectangle (x * cell_size) (y * cell_size)
        (cell_size - Config.gap_between_cells)
        (cell_size - Config.gap_between_cells)
        colour
    done
  done

let opposite cell =
  match cell with Grid.Alive -> Grid.Dead | Grid.Dead -> Grid.Alive

let inside_grid grid x y =
  x >= 0 && y >= 0 && x < Grid.width grid && y < Grid.height grid

let toggle_cell_under_mouse grid =
  let x = Raylib.get_mouse_x () / cell_size in
  let y = Raylib.get_mouse_y () / cell_size in
  if inside_grid grid x y then Grid.set grid x y (opposite (Grid.get grid x y))
  else grid

let handle_input state =
  if Raylib.is_mouse_button_pressed Raylib.MouseButton.Left then
    { state with grid = toggle_cell_under_mouse state.grid }
  else if Raylib.is_key_pressed Raylib.Key.Space then
    { state with paused = not state.paused }
  else if Raylib.is_key_pressed Raylib.Key.N then
    { state with grid = Grid.step state.grid }
  else if Raylib.is_key_pressed Raylib.Key.R then
    { state with grid = Seed.random_grid config }
  else if Raylib.is_key_pressed Raylib.Key.C then
    {
      state with
      grid = Grid.create config.width config.height config.behaviour;
    }
  else state

let advance state =
  if state.paused then state
  else
    let time_since_step = state.time_since_step +. Raylib.get_frame_time () in
    if time_since_step >= config.seconds_between_generations then
      { state with grid = Grid.step state.grid; time_since_step = 0.0 }
    else { state with time_since_step }

let draw state =
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.black;
  draw_grid state.grid;
  if state.paused then Raylib.draw_text "PAUSED" 10 10 20 Raylib.Color.raywhite;
  Raylib.end_drawing ()

let rec run state =
  if Raylib.window_should_close () then ()
  else begin
    draw state;
    run (advance (handle_input state))
  end

let () =
  Raylib.init_window (config.width * cell_size)
    (config.height * cell_size)
    "Game of Life";
  Raylib.set_target_fps 60;
  run { grid = Seed.start_grid config; time_since_step = 0.0; paused = false };
  Raylib.close_window ()
