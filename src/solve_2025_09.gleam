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

pub fn part_two(input: String) -> Int {
  let tiles =
    input
    |> parse

  let edges =
    tiles
    |> list.append(tiles |> list.take(1))
    |> list.window_by_2
    |> list.flat_map(fn(pair) {
      let #(first, second) = pair
      case first.y == second.y {
        True -> [
          Edge(
            first.y,
            int.min(first.x, second.x),
            int.max(first.x, second.x),
            first.x > second.x,
          ),
        ]
        False -> []
      }
    })
  // |> echo

  tiles
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
  // |> list.filter(fn(rectangle) { rectangle.area < max_area })
  // |> echo
  |> list.find(inside(_, edges))
  |> result.map(fn(rectangle) { rectangle.area })
  |> result.unwrap(-1)
}

type Edge {
  Edge(y: Int, west: Int, east: Int, eastward: Bool)
}

/// Generate all points along the perimeter of the rectangle
fn perimeter(rectangle: Rectangle) -> List(Tile) {
  let Rectangle(north_west:, south_east:, ..) = rectangle

  list.new()
  |> list.append(
    list.range(north_west.x, south_east.x)
    |> list.flat_map(fn(x) { [Tile(x, north_west.y), Tile(x, south_east.y)] }),
  )
  |> list.append(
    list.range(north_west.y, south_east.y)
    |> list.flat_map(fn(y) { [Tile(north_west.x, y), Tile(south_east.x, y)] }),
  )
  |> list.unique
  // |> list.shuffle // potential speedup?
}

fn inside(rectangle: Rectangle, edges: List(Edge)) -> Bool {
  let Rectangle(north_west:, south_east:, ..) = rectangle
  let relevant_edges =
    edges
    |> list.filter(fn(edge) {
      edge.y > north_west.y
      && edge.west <= south_east.x
      && edge.east >= north_west.x
    })

  // echo #(rectangle, relevant_edges |> list.length)
  rectangle |> perimeter |> list.all(point_inside(relevant_edges, _))
}

/// Check if a point is inside the polygon using horizontal ray casting
fn point_inside(edges: List(Edge), tile: Tile) -> Bool {
  edges
  |> list.flat_map(fn(edge) {
    case edge.y >= tile.y && edge.west <= tile.x && tile.x <= edge.east {
      True -> [
        case edge.eastward {
          True -> 1
          False -> -1
        },
      ]
      False -> []
    }
  })
  |> int.sum
  |> nonzero
}

fn nonzero(n: Int) -> Bool {
  n != 0
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
