import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  input
  |> parse
  |> count_zeros
  |> pair.second
}

pub fn part_two(input: String) -> Int {
  let rotations = parse(input)
  let #(_, seen) = {
    use accumulator, rotation <- list.fold(rotations, #(50, 0))
    let #(previous, seen) = accumulator
    echo #(previous, seen, rotation, rotation / 100)
    // const via_zero = ???
    #({ previous + rotation } % 100, seen + { rotation / 100 })
  }

  seen
}

fn count_zeros(numbers: List(Int)) -> #(Int, Int) {
  use accumulator, rotation <- list.fold(numbers, #(50, 0))
  let #(previous, seen) = accumulator
  case { previous + rotation } % 100 {
    0 -> #(0, seen + 1)
    next -> #(next, seen)
  }
}

fn parse(input: String) -> List(Int) {
  use line <- list.flat_map(string.split(input, "\n"))
  let value = case line {
    "L" <> rotations -> int.parse(rotations) |> result.map(int.negate)
    "R" <> rotations -> int.parse(rotations)
    _ -> Error(Nil)
  }
  case value {
    Ok(v) -> [v]
    Error(_) -> []
  }
}

fn rotate(value: Int, cycle: Int) -> #(Int, Int) {
  case value % cycle {
    value if value < 0 -> #(value % cycle, value / cycle)
    _ -> #(value, 0)
  }
}
