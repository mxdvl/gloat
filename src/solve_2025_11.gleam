import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub fn part_one(input: String) -> Int {
  let graph = parse(input)

  let start = graph |> dict.get("you") |> result.unwrap(set.new())
  count_paths(graph, start, "out")
}

fn count_paths(
  graph: Dict(String, Set(String)),
  to_visit: Set(String),
  end: String,
) {
  use accumulator, node <- set.fold(to_visit, 0)
  accumulator
  + case node == end {
    True -> 1
    False ->
      count_paths(
        graph,
        graph |> dict.get(node) |> result.unwrap(set.new()),
        end,
      )
  }
}

pub fn part_two(input: String) -> Int {
  let graph = parse(input)

  let start = graph |> dict.get("svr") |> result.unwrap(set.new())
  count_paths_along(graph, start, "out", set.from_list(["svr"]))
}

fn count_paths_along(
  graph: Dict(String, Set(String)),
  to_visit: Set(String),
  end: String,
  seen: Set(String),
) {
  use accumulator, node <- set.fold(to_visit, 0)
  accumulator
  + case node == end {
    True -> {
      case set.contains(seen, "dac"), set.contains(seen, "fft") {
        True, True -> 1
        _, _ -> 0
      }
    }
    False ->
      count_paths_along(
        graph,
        graph |> dict.get(node) |> result.unwrap(set.new()),
        end,
        seen |> set.insert(node),
      )
  }
}

fn parse(input: String) -> Dict(String, Set(String)) {
  use graph, line <- list.fold(string.split(input, "\n"), dict.new())
  case line |> string.split_once(": ") {
    Ok(#(from, to)) -> {
      graph
      |> dict.insert(
        from,
        to |> string.split(" ") |> list.map(string.trim) |> set.from_list,
      )
    }
    Error(_) -> graph
  }
}
