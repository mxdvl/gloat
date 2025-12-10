import gleam/string
import solve_2025_10

const input = "
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_10.part_one
  assert result == 7
}

pub fn part_two_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_10.part_two
  assert result == -1
}
