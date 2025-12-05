import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  let #(ranges, ingredients) = parse(input)
  use ingredient <- list.count(ingredients)
  use range <- list.any(ranges)
  range.from <= ingredient && ingredient <= range.to
}

pub fn part_two(input: String) -> Int {
  let #(ranges, _) = parse(input)

  let compare = fn(left: Range, right: Range) {
    int.compare(left.from, right.from)
  }

  let sorted = ranges |> list.sort(compare)

  let merged = {
    use accumulator: List(Range), range <- list.fold(sorted, [])
    let #(overlapping, excluded) =
      accumulator
      |> list.partition(overlaps(range, _))
    let from =
      overlapping
      |> list.map(fn(range) { range.from })
      |> list.fold(range.from, int.min)
    let to =
      overlapping
      |> list.map(fn(range) { range.to })
      |> list.fold(range.to, int.max)

    [Range(from:, to:), ..excluded]
    |> list.sort(compare)
  }

  use accumulator, range <- list.fold(merged, 0)
  let size = range.to - range.from + 1
  // echo #(range, size)
  accumulator + size
}

type Range {
  Range(from: Int, to: Int)
}

/// checks whether two inclusive ranges overlap
/// ```
/// ├───┤
///     ├────┤
///
///   ├──┤
/// ├──────┤
///
/// ├──┤
///  ├──────┤
///```
fn overlaps(left: Range, right: Range) {
  { left.from <= right.from && right.from <= left.to }
  || { right.from <= left.from && left.from <= right.to }
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
