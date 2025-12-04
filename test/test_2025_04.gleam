import gleam/string
import solve_2025_04

const input = "
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_04.part_one
  assert result == 13
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_04.part_two
  assert result == 43
}
