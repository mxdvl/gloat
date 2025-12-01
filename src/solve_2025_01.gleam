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

/// very inspired by @hunkyjimpjorps’s
/// [solution](https://github.com/hunkyjimpjorps/AdventOfCode/blob/1686f7c23521/gleam/aoc2025/src/aoc_2025/day_1.gleam#L20-L28)
/// and insight in using scan + whether the dial points to 0
pub fn part_two(input: String) -> Int {
  input
  |> parse
  |> list.prepend(0)
  |> list.scan(50, int.add)
  |> list.window_by_2
  |> list.fold(0, fn(accumulator, pair) {
    let #(from, to) = pair
    list.range(from, to)
    |> list.drop(1)
    |> echo
    |> list.count(fn(position) { position % 100 == 0 })
    |> int.add(accumulator)
  })
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
