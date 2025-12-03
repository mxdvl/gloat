import gleam/int
import gleam/list
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
  -1
}

fn parse(input: String) -> List(List(Int)) {
  use line <- list.map(string.split(string.trim(input), "\n"))
  use grapheme <- list.flat_map(string.to_graphemes(line))
  case int.parse(grapheme) {
    Ok(digit) -> [digit]
    Error(_) -> []
  }
}
