import gleam/int
import gleam/list
import gleam/order
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

type Battery {
  Battery(joltage: Int, index: Int)
}

pub fn part_two(input: String) -> Int {
  use accumulator, digits <- list.fold(parse(input), 0)

  let sorted =
    digits
    |> list.index_map(Battery)
    |> list.sort(fn(left, right) {
      order.break_tie(
        in: int.compare(right.joltage, left.joltage),
        with: int.compare(left.index, right.index),
      )
    })
  // |> echo

  let added =
    filler([], sorted, 12, list.length(sorted))
    |> echo
    |> list.fold(0, fn(accumulator, battery) {
      accumulator * 10 + battery.joltage
    })
    |> echo

  accumulator + added
}

fn filler(
  so_far: List(Battery),
  left_to_check: List(Battery),
  banks_to_fill: Int,
  length: Int,
) -> List(Battery) {
  case banks_to_fill {
    0 -> so_far
    _ -> {
      case
        left_to_check
        |> list.find(fn(battery) { battery.index + banks_to_fill <= length })
      {
        Ok(battery) -> {
          let left_to_check =
            list.filter(left_to_check, fn(b) { b.index > battery.index })
          echo #(battery, banks_to_fill - 1, length, so_far)
          echo left_to_check
          filler(
            list.append(so_far, [battery]),
            left_to_check,
            banks_to_fill - 1,
            length,
          )
        }
        Error(_) -> []
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
