import gleam/list
import gleam/set
import gleam/string

type Point {
  Point(x: Int, y: Int)
}

const adjacencies = [
  Point(-1, -1),
  Point(0, -1),
  Point(1, -1),
  Point(-1, 0),
  Point(1, 0),
  Point(-1, 1),
  Point(0, 1),
  Point(1, 1),
]

pub fn part_one(input: String) -> Int {
  let adjacencies = set.from_list(adjacencies)
  let set = parse(input)
  use accumulator, point <- set.fold(set, 0)
  let rolls =
    adjacencies
    |> set.map(fn(delta) { Point(point.x + delta.x, point.y + delta.y) })
    |> set.intersection(set)
    |> set.size

  // echo #(point, rolls)

  case rolls < 4 {
    True -> accumulator + 1
    False -> accumulator
  }
}

pub fn part_two(input: String) -> Int {
  -1
}

fn parse(input: String) -> set.Set(Point) {
  let lines = input |> string.trim |> string.split("\n")
  {
    use line, y <- list.index_map(lines)
    use grapheme, x <- list.index_map(string.to_graphemes(line))
    case grapheme {
      "@" -> Point(x:, y:)
      _ -> Point(-1, -1)
    }
  }
  |> list.flatten
  |> set.from_list
  |> set.difference(set.from_list([Point(-1, -1)]))
}
