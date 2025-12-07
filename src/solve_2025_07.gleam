import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub fn part_one(input: String) -> Int {
  let #(beams, splitters) =
    input |> parse |> list.partition(fn(p) { p.1 == Beam })

  let beams = beams |> list.map(pair.first)
  let splitters = splitters |> list.map(pair.first)

  propagate(beams, splitters, 0)
}

fn propagate(beams: List(Point), splitters: List(Point), splits: Int) -> Int {
  case splitters {
    [] -> splits
    splitters -> {
      let y =
        beams
        |> list.map(fn(beam) { beam.y })
        |> list.fold(0, int.max)

      let #(next_splitters, remaining_splitters) =
        splitters |> list.partition(fn(point) { point.y <= y + 1 })

      let #(beams, splitted) = {
        use #(beams, splitted), beam <- list.fold(beams, #([], 0))
        case list.any(next_splitters, fn(splitter) { beam.x == splitter.x }) {
          True -> #(
            [
              Point(beam.x - 1, beam.y + 1),
              Point(beam.x + 1, beam.y + 1),
              ..beams
            ],
            splitted + 1,
          )
          False -> #([Point(beam.x, beam.y + 1), ..beams], splitted)
        }
      }

      propagate(beams |> list.unique, remaining_splitters, splits + splitted)
    }
  }
}

pub fn part_two(input: String) -> Int {
  let #(beams, splitters) =
    input
    |> parse
    |> list.partition(fn(p) { p.1 == Beam })

  let beams =
    beams
    |> list.map(pair.first)
    |> list.map(fn(beam) { #(beam.x, 1) })
    |> dict.from_list

  let max =
    splitters
    |> list.map(pair.first)
    |> list.map(fn(p) { p.y })
    |> list.fold(0, int.max)

  let splitters =
    list.range(1, max)
    |> list.map(fn(y) {
      splitters
      |> list.map(pair.first)
      |> list.flat_map(fn(splitter) {
        case splitter.y == y {
          True -> [splitter.x]
          False -> []
        }
      })
      |> set.from_list
    })

  quantum_propagate(beams, splitters)
}

fn quantum_propagate(beams: Dict(Int, Int), splitters: List(Set(Int))) -> Int {
  case splitters {
    [] -> beams |> dict.values |> list.fold(0, int.add)
    [splitters, ..remaining_splitters] -> {
      let beams = {
        use accumulator, x, states <- dict.fold(beams, dict.new())
        case splitters |> set.contains(x) {
          True ->
            accumulator
            |> dict.upsert(x - 1, fn(val) {
              case val {
                Some(val) -> val + states
                None -> states
              }
            })
            |> dict.upsert(x + 1, fn(val) {
              case val {
                Some(val) -> val + states
                None -> states
              }
            })
          False ->
            accumulator
            |> dict.upsert(x, fn(val) {
              case val {
                Some(val) -> val + states
                None -> states
              }
            })
        }
      }
      echo #(beams, splitters)
      quantum_propagate(beams, remaining_splitters)
    }
  }
}

type Teleportation {
  Beam
  Splitter
}

type Point {
  Point(x: Int, y: Int)
}

fn parse(input: String) -> List(#(Point, Teleportation)) {
  let lines = input |> string.trim |> string.split("\n")
  {
    use line, y <- list.index_map(lines)
    use grapheme, x <- list.index_map(string.to_graphemes(line))
    case grapheme {
      "S" -> Ok(#(Point(x:, y:), Beam))
      "^" -> Ok(#(Point(x:, y:), Splitter))
      _ -> Error(Nil)
    }
  }
  |> list.flatten
  |> result.values
}
