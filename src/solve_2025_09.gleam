import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Tile {
  Tile(x: Int, y: Int)
}

type Rectangle {
  Rectangle(south_west: Tile, north_east: Tile, area: Int)
}

fn area(south_west: Tile, north_east: Tile) {
  let dx = north_east.x - south_west.x |> int.absolute_value |> int.add(1)
  let dy = north_east.y - south_west.y |> int.absolute_value |> int.add(1)
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
    let #(south_west, north_east) = pair
    let area = area(south_west, north_east)
    Rectangle(south_west:, north_east:, area:)
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
