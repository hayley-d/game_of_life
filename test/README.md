# Game of Life
Conway's Game of Life in OCaml.

## Run
```bash
opam install . --deps-only
dune exec game_of_life
```

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


