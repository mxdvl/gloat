import gleam/string
import solve_2024_02

const input = "
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim()
    |> solve_2024_02.part_one()
  assert result == 2
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim()
    |> solve_2024_02.part_two()
  assert result == 4
}
