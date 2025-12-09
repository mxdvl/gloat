import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Tile {
  Tile(x: Int, y: Int)
}

type Rectangle {
  Rectangle(north_west: Tile, south_east: Tile, area: Int)
}

fn area(north_west: Tile, south_east: Tile) {
  let dx = south_east.x - north_west.x |> int.add(1)
  let dy = south_east.y - north_west.y |> int.add(1)
  dx * dy
}

fn compare(left: Rectangle, right: Rectangle) {
  int.compare(left.area, right.area)
}

pub fn part_one(input: String) -> Int {
  input
  |> parse
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(first, second) = pair
    let north_west =
      Tile(int.min(first.x, second.x), int.min(first.y, second.y))
    let south_east =
      Tile(int.max(first.x, second.x), int.max(first.y, second.y))
    let area = area(north_west, south_east)
    Rectangle(north_west:, south_east:, area:)
  })
  |> list.sort(compare)
  // |> echo
  |> list.reverse
  |> list.map(fn(rectangle) { rectangle.area })
  |> list.first
  |> result.unwrap(-1)
}

pub fn part_two(input: String) -> Int {
  // echo parse(input)
  -1
}

fn parse(input: String) -> List(Tile) {
  use line <- list.flat_map(input |> string.trim |> string.split("\n"))
  case
    line |> string.split(",") |> list.map(string.trim) |> list.map(int.parse)
  {
    [Ok(x), Ok(y)] -> [Tile(x:, y:)]
    _ -> [] |> echo |> list.take(0)
  }
}
