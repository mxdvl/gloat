import gleam/bool
import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn part_one(input: String) -> Int {
  let farm = parse(input)

  use #(width, height, #(zero, one, two, three, four, five)) <- list.count(
    farm.regions,
  )

  let area = width * height

  let unpacked =
    [
      zero,
      one,
      two,
      three,
      four,
      five,
    ]
    |> list.map(int.multiply(_, 9))
    |> int.sum

  use <- bool.guard(area >= unpacked, True)

  let packed =
    [
      farm.presents.0 * zero,
      farm.presents.1 * one,
      farm.presents.2 * two,
      farm.presents.3 * three,
      farm.presents.4 * four,
      farm.presents.5 * five,
    ]
    |> int.sum

  use <- bool.guard(area < packed, False)

  panic as "This is not a solved mathematical problem…"
}

pub fn part_two(_: String) -> Int {
  24
}

type Farm {
  Farm(
    presents: #(Int, Int, Int, Int, Int, Int),
    regions: List(#(Int, Int, #(Int, Int, Int, Int, Int, Int))),
  )
}

fn parse(input: String) -> Farm {
  let is_sharp = fn(character: String) {
    string.compare(character, "#") == order.Eq
  }
  case string.split(input |> string.trim, "\n\n") {
    [zero, one, two, three, four, five, rest] -> {
      let zero = zero |> string.to_graphemes |> list.count(is_sharp)
      let one = one |> string.to_graphemes |> list.count(is_sharp)
      let two = two |> string.to_graphemes |> list.count(is_sharp)
      let three = three |> string.to_graphemes |> list.count(is_sharp)
      let four = four |> string.to_graphemes |> list.count(is_sharp)
      let five = five |> string.to_graphemes |> list.count(is_sharp)

      let presents = #(zero, one, two, three, four, five)
      let regions =
        rest
        |> string.split("\n")
        |> list.flat_map(fn(line) {
          case string.split_once(line, ": ") {
            Ok(#(start, end)) -> {
              case
                start |> string.trim |> string.split("x") |> list.map(int.parse),
                end |> string.trim |> string.split(" ") |> list.map(int.parse)
              {
                [Ok(width), Ok(height)],
                  [Ok(zero), Ok(one), Ok(two), Ok(three), Ok(four), Ok(five)]
                -> [
                  #(width, height, #(zero, one, two, three, four, five)),
                ]
                _, _ -> []
              }
            }
            Error(_) -> []
          }
        })
      Farm(presents:, regions:)
    }
    _ -> panic as "invalid"
  }
}
