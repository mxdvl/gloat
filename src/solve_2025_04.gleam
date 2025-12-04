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
  let set = parse(input)
  use accumulator, point <- set.fold(set, 0)
  case movable(set, point) {
    True -> accumulator + 1
    False -> accumulator
  }
}

pub fn part_two(input: String) -> Int {
  let initial = parse(input)
  let final = forklift(initial)
  set.difference(initial, final) |> set.size
}

/// keep removing rolls until they are all too dense
fn forklift(set: set.Set(Point)) -> set.Set(Point) {
  let moved = {
    use accumulator, point <- set.fold(set, set.new())
    case movable(set, point) {
      True -> accumulator |> set.insert(point)
      False -> accumulator
    }
  }

  case set.size(moved) {
    0 -> set
    _ -> forklift(set.difference(set, moved))
  }
}

fn movable(set: set.Set(Point), point: Point) -> Bool {
  let rolls =
    adjacencies
    |> list.map(fn(delta) { Point(point.x + delta.x, point.y + delta.y) })
    |> set.from_list
    |> set.intersection(set)
    |> set.size

  rolls < 4
}

fn parse(input: String) -> set.Set(Point) {
  let decoy = Point(-1, -1)
  let lines = input |> string.trim |> string.split("\n")
  {
    use line, y <- list.index_map(lines)
    use grapheme, x <- list.index_map(string.to_graphemes(line))
    case grapheme {
      "@" -> Point(x:, y:)
      _ -> decoy
    }
  }
  |> list.flatten
  |> set.from_list
  |> set.difference(set.from_list([decoy]))
}
