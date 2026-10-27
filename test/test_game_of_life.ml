open Game_of_life

let grid_with_live width height edges live_cells =
  List.fold_left
    (fun grid (x, y) -> Grid.set grid x y Grid.Alive)
    (Grid.create width height edges)
    live_cells

let rec step_n n grid = if n = 0 then grid else step_n (n - 1) (Grid.step grid)

let check name condition =
  if condition then print_endline ("PASS: " ^ name)
  else failwith ("FAIL: " ^ name)

let () =
  let start = grid_with_live 5 5 Grid.Strict [ (2, 2) ] in
  let expected = Grid.create 5 5 Grid.Strict in
  check "lonely cell dies" (Grid.equal (Grid.step start) expected);
  let start2 =
    grid_with_live 5 5 Grid.Strict [ (1, 1); (1, 2); (2, 1); (2, 2) ]
  in
  check "block is still" (Grid.equal (Grid.step start2) start2);
  let start3 = grid_with_live 5 5 Grid.Strict [ (1, 2); (2, 2); (3, 2) ] in
  let expected3 = grid_with_live 5 5 Grid.Strict [ (2, 1); (2, 2); (2, 3) ] in
  check "blinker flips" (Grid.equal (Grid.step start3) expected3);
  check "blinker flips back" (Grid.equal (Grid.step expected3) start3);
  let start4 =
    grid_with_live 5 5 Grid.Strict [ (1, 0); (2, 1); (0, 2); (1, 2); (2, 2) ]
  in
  let expected4 =
    grid_with_live 5 5 Grid.Strict [ (2, 1); (3, 2); (1, 3); (2, 3); (3, 3) ]
  in
  check "glider moves diagonally after 4 steps"
    (Grid.equal (step_n 4 start4) expected4);
  let mixed_start =
    Grid.init 50 40 Grid.Wrap (fun x y ->
        if ((x * 7) + (y * 13)) mod 5 = 0 then Grid.Alive else Grid.Dead)
  in
  let parallel_result = Grid.create 50 40 Grid.Wrap in
  Grid.parallel_step_into 3 mixed_start parallel_result;
  check "parallel step matches step"
    (Grid.equal parallel_result (Grid.step mixed_start))
