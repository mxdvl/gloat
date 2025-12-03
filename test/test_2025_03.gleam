import gleam/string
import solve_2025_03

const input = "
987654321111111
811111111111119
234234234234278
818181911112111
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_03.part_one
  assert result == 357
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_03.part_two
  assert result == -1
}
