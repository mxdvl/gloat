import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/set
import gleam/string

type Box {
  Box(x: Int, y: Int, z: Int)
}

type Connection {
  Connection(a: Box, b: Box, distance: Int)
}

fn distance(a: Box, b: Box) {
  0.0
  +. { int.power(a.x - b.x, 2.0) |> result.unwrap(0.0) }
  +. { int.power(a.y - b.y, 2.0) |> result.unwrap(0.0) }
  +. { int.power(a.z - b.z, 2.0) |> result.unwrap(0.0) }
  |> float.power(0.5)
  |> result.unwrap(-1.0)
  |> float.truncate
}

fn with_distance(pair: #(Box, Box)) {
  let #(a, b) = pair
  let distance = distance(a, b)
  Connection(a:, b:, distance:)
}

fn compare(a: Connection, b: Connection) {
  int.compare(a.distance, b.distance)
}

fn intersects(set: set.Set(Box), a: Box, b: Box) {
  set.contains(set, a) || set.contains(set, b)
}

pub fn part_one(input: String) -> Int {
  let length = case string.length(input) < 300 {
    True -> 10
    False -> 1000
  }

  input
  |> parse
  |> list.combination_pairs
  |> list.map(with_distance)
  |> list.sort(compare)
  |> list.take(length)
  |> list.fold([], fn(circuits: List(set.Set(Box)), connection) {
    let Connection(a:, b:, ..) = connection
    let #(overlapping, disjoint) =
      circuits
      |> list.partition(intersects(_, a, b))

    [
      overlapping
        |> list.fold(set.from_list([a, b]), set.union),
      ..disjoint
    ]
  })
  // |> echo
  |> list.map(set.size)
  |> list.sort(int.compare)
  |> list.reverse
  |> list.take(3)
  |> int.product
}

pub fn part_two(input: String) -> Int {
  let points =
    input
    |> parse
  let size = list.length(points)

  input
  |> parse
  |> list.combination_pairs
  |> list.map(with_distance)
  |> list.sort(compare)
  |> list.fold_until(#([], -1), fn(accumulator, connection) {
    let #(circuits, _) = accumulator
    let Connection(a:, b:, ..) = connection
    let #(overlapping, disjoint) =
      circuits
      |> list.partition(intersects(_, a, b))
    let joined =
      overlapping
      |> list.fold(set.from_list([a, b]), set.union)

    case set.size(joined) >= size {
      True -> list.Stop(#([], int.multiply(a.x, b.x)))
      False -> list.Continue(#([joined, ..disjoint], -1))
    }
  })
  |> pair.second
}

fn parse(input: String) -> List(Box) {
  use line <- list.flat_map(string.split(input, "\n"))
  case line |> string.split(",") |> list.map(int.parse) {
    [Ok(x), Ok(y), Ok(z)] -> [Box(x:, y:, z:)]
    _ -> []
  }
}
