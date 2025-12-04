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

fn light_up(
  banks: List(Int),
  batteries: List(Int),
  padding: List(Int),
) -> List(Int) {
  case padding {
    [] -> banks
    [next, ..padding] -> {
      let candidates = list.append(batteries, [next])
      let max = candidates |> list.max(int.compare) |> result.unwrap(0)
      let candidates =
        list.drop_while(candidates, fn(battery) { battery < max })
      case candidates {
        [max, ..rest] -> light_up(list.append(banks, [max]), rest, padding)
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
