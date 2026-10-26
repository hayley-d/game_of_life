type pattern = (int * int) list

let live_character = '#'

let live_cells_in_row y row =
  List.filter_map
    (fun x -> if row.[x] = live_character then Some (x, y) else None)
    (List.init (String.length row) (fun x -> x))

let from_picture rows = List.concat (List.mapi live_cells_in_row rows)
let glider = from_picture [ ".#."; "..#"; "###" ]
let blinker = from_picture [ "###" ]

let pulsar =
  from_picture
    [
      "..###...###..";
      ".............";
      "#....#.#....#";
      "#....#.#....#";
      "#....#.#....#";
      "..###...###..";
      ".............";
      "..###...###..";
      "#....#.#....#";
      "#....#.#....#";
      "#....#.#....#";
      ".............";
      "..###...###..";
    ]

let glider_gun =
  from_picture
    [
      "........................#...........";
      "......................#.#...........";
      "............##......##............##";
      "...........#...#....##............##";
      "##........#.....#...##..............";
      "##........#...#.##....#.#...........";
      "..........#.....#.......#...........";
      "...........#...#....................";
      "............##......................";
    ]

let named_patterns =
  [
    ("glider", glider);
    ("blinker", blinker);
    ("pulsar", pulsar);
    ("gun", glider_gun);
    ("glider-gun", glider_gun);
  ]

let of_name name = List.assoc_opt (String.lowercase_ascii name) named_patterns
let pattern_names = List.map fst named_patterns

let place pattern offset_x offset_y grid =
  List.fold_left
    (fun grid (x, y) -> Grid.set grid (x + offset_x) (y + offset_y) Grid.Alive)
    grid pattern
