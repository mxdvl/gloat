import gleam/string
import solve_2024_01

pub fn part_one_test() {
  let input =
    "
3   4
4   3
2   5
1   3
3   9
3   3
"
    |> string.trim()
  assert solve_2024_01.part_one(input) == 11
}

pub fn part_two_test() {
  let input =
    "
3   4
4   3
2   5
1   3
3   9
3   3
"
    |> string.trim()
  assert solve_2024_01.part_two(input) == 31
}
