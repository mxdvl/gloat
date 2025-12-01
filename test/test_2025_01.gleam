import gleam/string
import solve_2025_01

const input = "
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_01.part_one
  assert result == 3
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_01.part_two
  assert result == 6
}
