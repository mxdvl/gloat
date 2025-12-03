import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  use accumulator, x <- list.fold(parse(input), 0)
  let string = int.to_string(x)

  case string.length(string) {
    length if length % 2 == 0 -> {
      let half = length / 2
      case int.power(10, int.to_float(half)) |> result.map(float.truncate) {
        Ok(modulus) -> {
          let left = x % modulus
          let right = x / modulus
          case left == right {
            True -> accumulator + x
            False -> accumulator
          }
        }
        _ -> accumulator
      }
    }
    _ -> accumulator
  }
}

pub fn part_two(input: String) -> Int {
  use accumulator, x <- list.fold(parse(input), 0)
  case valid("", int.to_string(x)) {
    True -> accumulator + x
    False -> accumulator
  }
}

fn valid(head: String, tail: String) -> Bool {
  case string.pop_grapheme(tail) {
    Ok(#(next, rest)) -> {
      let repeatable = string.concat([head, next])
      let repeat = string.length(rest) / string.length(repeatable)
      case repeat > 0 && string.repeat(repeatable, repeat) == rest {
        True -> {
          // echo #(repeatable, rest, repeat)
          True
        }
        False -> {
          valid(repeatable, rest)
        }
      }
    }
    Error(_) -> False
  }
}

fn parse(input: String) -> List(Int) {
  use line <- list.flat_map(string.split(input, ","))
  case list.map(string.split(line, "-"), int.parse) {
    [Ok(left), Ok(right)] -> list.range(left, right)
    _ -> []
  }
}
