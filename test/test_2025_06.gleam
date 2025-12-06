import gleam/string
import solve_2025_06

const input = "
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_06.part_one
  assert result == 4_277_556
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_06.part_two
  assert result == 3_263_827
}
