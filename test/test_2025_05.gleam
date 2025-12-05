import gleam/string
import solve_2025_05

const input = "
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_05.part_one
  assert result == 3
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_05.part_two
  assert result == 14
}
