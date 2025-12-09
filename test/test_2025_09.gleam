import gleam/string
import solve_2025_09

const input = "
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_09.part_one
  assert result == 50
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_09.part_two
  assert result == 24
}
