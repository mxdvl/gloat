import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

pub fn part_one(input: String) -> Int {
  let #(ranges, ingredients) = parse(input)
  use ingredient <- list.count(ingredients)
  use range <- list.any(ranges)
  range.from <= ingredient && ingredient <= range.to
}

pub fn part_two(input: String) -> Int {
  let #(ranges, _) = parse(input)

  // this crashes!! :(
  // let ingredients = {
  //   use accumulator, range <- list.fold(ranges, set.new())
  //   let ingredients = list.range(range.from, range.to) |> set.from_list
  //   // echo #(range, size)
  //   accumulator |> set.union(ingredients)
  // }
  // set.size(ingredients)

  -1
}

type Range {
  Range(from: Int, to: Int)
}

fn parse(input: String) -> #(List(Range), List(Int)) {
  case input |> string.trim |> string.split_once("\n\n") {
    Ok(#(ranges, ingredients)) -> {
      let ranges =
        string.split(ranges, "\n")
        |> list.flat_map(fn(line) {
          case
            line
            |> string.split_once("-")
            |> result.map(fn(pair) { #(int.parse(pair.0), int.parse(pair.1)) })
          {
            Ok(#(Ok(from), Ok(to))) -> {
              [Range(from, to)]
            }
            _ -> []
          }
        })

      let ingredients =
        string.split(ingredients, "\n")
        |> list.flat_map(fn(line) {
          case int.parse(line) {
            Ok(ingredient) -> [ingredient]
            _ -> []
          }
        })

      #(ranges, ingredients)
    }
    Error(_) -> #([], [])
  }
}
