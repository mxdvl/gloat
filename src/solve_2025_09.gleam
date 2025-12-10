import gleam/bool
import gleam/int
import gleam/list
import gleam/order
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
  order.break_tie(
    int.compare(right.area, left.area),
    int.compare(right.south_east.y, left.south_east.y),
  )
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
  |> list.map(fn(rectangle) { rectangle.area })
  |> list.first
  |> result.unwrap(-1)
}

type Edge {
  Horizontal(y: Int, west: Int, east: Int)
  Vertical(x: Int, north: Int, south: Int)
}

pub fn part_two(input: String) -> Int {
  let red_tiles =
    input
    |> parse

  let edges =
    red_tiles
    |> list.append(red_tiles |> list.take(1))
    |> list.window_by_2
    |> list.flat_map(fn(pair) {
      let #(first, second) = pair
      case
        [first.x, second.x] |> list.unique |> list.sort(int.compare),
        [first.y, second.y] |> list.unique |> list.sort(int.compare)
      {
        [west, east], [y] -> [Horizontal(y:, west:, east:)]
        [x], [north, south] -> [Vertical(x:, north:, south:)]
        _, _ -> []
      }
    })

  red_tiles
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
  |> list.find(does_not_intersect(_, edges))
  |> result.map(fn(rectangle) { rectangle.area })
  |> result.unwrap(-1)
}

fn does_not_intersect(rectangle: Rectangle, edges: List(Edge)) {
  // echo rectangle
  intersects(rectangle, edges) |> bool.negate
}

fn intersects(rectangle: Rectangle, edges: List(Edge)) {
  edges
  |> list.any(fn(edge) {
    // echo edge
    case edge {
      Horizontal(y:, west:, east:) -> {
        // ┣━━━┫    no
        //   ┌───┐
        // ┣━┿┫  │  yes
        //   │   │
        //   │┣━┫│  yes
        //   │   │
        // ┣━┿━━━┿┫ yes
        //   │   │
        //   │   ┣┫ no
        //   └───┘
        True
        && rectangle.north_west.y < y
        && y < rectangle.south_east.y
        && { west < rectangle.south_east.x && rectangle.north_west.x < east }
      }
      Vertical(x:, north:, south:) -> {
        True
        && rectangle.north_west.x < x
        && x < rectangle.south_east.x
        && { north < rectangle.south_east.y && rectangle.north_west.y < south }
      }
    }
    // |> echo
  })
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
