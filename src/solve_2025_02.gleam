import gleam/int
import gleam/list
import gleam/set
import gleam/string

pub fn part_one(input: String) -> Int {
  let invalids =
    list.range(1, 9)
    |> list.map(int.multiply(_, 11))
    |> list.append(list.range(10, 99) |> list.map(int.multiply(_, 101)))
    |> list.append(list.range(100, 999) |> list.map(int.multiply(_, 1001)))
    |> list.append(list.range(1000, 9999) |> list.map(int.multiply(_, 10_001)))
    |> list.append(
      list.range(10_000, 99_999) |> list.map(int.multiply(_, 100_001)),
    )
    |> set.from_list

  use accumulator, id <- list.fold(parse(input), 0)
  case invalids |> set.contains(id) {
    True -> accumulator + id
    False -> accumulator
  }
}

pub fn part_two(input: String) -> Int {
  // let max = parse(input) |> list.fold(0, int.max)
  // echo #("max", max, int.to_string(max) |> string.length)

  let invalids = list.range(2, 10) |> list.flat_map(invalids) |> set.from_list

  use accumulator, id <- list.fold(parse(input), 0)
  case invalids |> set.contains(id) {
    True -> accumulator + id
    False -> accumulator
  }
}

fn invalids(length: Int) {
  case length {
    1 -> []
    2 -> list.range(1, 9) |> list.map(int.multiply(_, 11))
    3 -> list.range(1, 9) |> list.map(int.multiply(_, 111))
    4 ->
      list.range(1, 9)
      |> list.map(int.multiply(_, 1111))
      |> list.append(list.range(10, 99) |> list.map(int.multiply(_, 101)))
    5 -> list.range(1, 9) |> list.map(int.multiply(_, 11_111))
    6 ->
      list.range(1, 9)
      |> list.map(int.multiply(_, 111_111))
      |> list.append(list.range(10, 99) |> list.map(int.multiply(_, 10_101)))
      |> list.append(list.range(100, 999) |> list.map(int.multiply(_, 1001)))
    7 -> list.range(1, 9) |> list.map(int.multiply(_, 1_111_111))
    8 ->
      list.range(1, 9)
      |> list.map(int.multiply(_, 11_111_111))
      |> list.append(list.range(10, 99) |> list.map(int.multiply(_, 1_010_101)))
      |> list.append(
        list.range(1000, 9999) |> list.map(int.multiply(_, 10_001)),
      )
    9 ->
      list.range(1, 9)
      |> list.map(int.multiply(_, 111_111_111))
      |> list.append(
        list.range(100, 999) |> list.map(int.multiply(_, 1_001_001)),
      )
    10 ->
      list.range(1, 9)
      |> list.map(int.multiply(_, 1_111_111_111))
      |> list.append(
        list.range(10, 99) |> list.map(int.multiply(_, 101_010_101)),
      )
      |> list.append(
        list.range(10_000, 99_999) |> list.map(int.multiply(_, 100_001)),
      )
    11 -> list.range(1, 9) |> list.map(int.multiply(_, 11_111_111_111))
    _ -> []
  }
}

fn parse(input: String) -> List(Int) {
  use line <- list.flat_map(string.split(input, ","))
  case list.map(string.split(line, "-"), int.parse) {
    [Ok(left), Ok(right)] -> list.range(left, right)
    _ -> []
  }
}
