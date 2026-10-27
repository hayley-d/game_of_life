# Game of Life
Conway's Game of Life in OCaml.

## Run TUI
```bash
opam install . --deps-only
dune exec game_of_life
```

## Run GUI
```bash
opam install . --deps-only
dune exec game_of_life_gui
```

| Input | Does |
|---|---|
| Left click | Toggle a cell |
| Space | Pause / resume |
| N | Step once |
| R | Random grid |
| C | Clear |

## Configuration
Set these as environment variables or in a `.env` file (see `.env.example`)
| Variable | Default | Meaning |
|---|---|---|
| `PATTERN` | `random` | `random`, `glider`, `blinker`, `pulsar`, `gun` |
| `WIDTH` | `60` | Grid width in cells |
| `HEIGHT` | `30` | Grid height in cells |
| `WRAP_EDGES` | `true` | `false` makes edges dead instead of wrapping |
| `SECONDS_BETWEEN_GENERATIONS` | `0.1` | Animation speed |
| `RANDOM_ALIVE_CHANCE` | `0.3` | Share of cells alive in a random grid |
| `PATTERN_MARGIN` | `1` | Distance of the pattern from the top-left corner |

Invalid or missing values will fallback to the default

## Benchmark Results

100 generations on a 1000×1000 wrapping grid, `--profile release`.

| Change | ms / generation | MB / generation |
|---|---|---|
| Start | 36 | 64 |
| Loop instead of closure | 29 | 8 |
| Inner-cell fast path | 18 | 8 |
| Double buffering | 17 | 0.1 |
| Parallel (10 cores) | ~4 | 0.0 |
