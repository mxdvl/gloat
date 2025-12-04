import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  use accumulator, digits <- list.fold(parse(input), 0)
  let length = list.length(digits)
  let #(tens, ones) = {
    use #(left, right), digit, index <- list.index_fold(digits, #(0, 0))
    // echo #(left, right, " – ", digit, index, length)
    case digit {
      digit if digit > left && index + 1 < length -> #(digit, -1)
      digit if digit > right -> #(left, digit)
      _ -> #(left, right)
    }
  }
  // echo digits
  // echo #(tens, ones, tens * 10 + ones)
  accumulator + tens * 10 + ones
}

pub fn part_two(input: String) -> Int {
  use accumulator, digits <- list.fold(parse(input), 0)

  let padding = list.length(digits) - 12

  light_up([], digits |> list.take(padding), digits |> list.drop(padding))
  |> list.fold(0, fn(accumulator, joltage) { accumulator * 10 + joltage })
  |> int.add(accumulator)
}

/// recursively move items from rightmost to leftmost lists
///
/// ```
/// [] [2,2,3,1] [2,2]
///     │ │ │ │ ┌─┘ │  pop right into middle
/// [] [2,2,3,1,2] [2]
///         │ │ │   │  drop middle below max (3)
///        [3,1,2] [2]
///  ┌──────┘ └┬┘   │
///  │    ┌────┘    │  pop middle into right
///  │   ┌┴┐   ┌────┘
/// [3] [1,2] [2]      recurse with new state
///  │   │ │ ┌─┘
/// [3] [1,2,2] []
///  │     │ │         drop middle below max (2)
/// [3]   [2,2] []
///  │ ┌───┘ │         pop middle into right
///  │ │   ┌─┘
/// [3,2] [2] []       end as right is empty
/// ```
fn light_up(left: List(Int), middle: List(Int), right: List(Int)) -> List(Int) {
  case right {
    [] -> left
    [next, ..padding] -> {
      let candidates = list.append(middle, [next])
      let max = candidates |> list.max(int.compare) |> result.unwrap(0)
      let candidates =
        list.drop_while(candidates, fn(battery) { battery < max })
      case candidates {
        [max, ..rest] -> light_up(list.append(left, [max]), rest, padding)
        _ -> []
      }
    }
  }
}

fn parse(input: String) -> List(List(Int)) {
  use line <- list.map(string.split(string.trim(input), "\n"))
  use grapheme <- list.flat_map(string.to_graphemes(line))
  case int.parse(grapheme) {
    Ok(digit) -> [digit]
    Error(_) -> []
  }
}
