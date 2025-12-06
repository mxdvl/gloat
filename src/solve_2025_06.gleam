import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/string

type Problem {
  Problem(operation: fn(Int, Int) -> Int, numbers: List(Int))
}

pub fn part_one(input: String) -> Int {
  let parse = fn(input: String) -> List(Problem) {
    let assert Ok(re) = regexp.from_string(" +")

    let problems =
      input
      |> string.trim
      |> string.split("\n")
      |> list.map(fn(line) {
        line
        |> string.replace(" ", "")
        |> string.trim
        |> regexp.split(re, _)
        |> list.map(string.trim)
      })
      |> list.transpose

    use problem <- list.flat_map(problems)

    let to_numbers = fn(strings: List(String)) -> List(Int) {
      use string <- list.flat_map(strings)
      case int.parse(string) {
        Ok(number) -> [number]
        Error(_) -> []
      }
    }

    case problem |> list.reverse {
      ["+", ..rest] -> [Problem(int.add, to_numbers(rest))]
      ["*", ..rest] -> [Problem(int.multiply, to_numbers(rest))]
      _ -> []
    }
  }

  use accumulator, problem <- list.fold(parse(input), 0)
  case list.reduce(problem.numbers, problem.operation) {
    Ok(solution) -> accumulator + solution
    Error(_) -> accumulator
  }
}

pub fn part_two(input: String) -> Int {
  // let assert Ok(re) = regexp.from_string("[  ]+")

  let parse = fn(input: String) -> List(Problem) {
    let columns =
      input
      |> string.split("\n")
      |> list.map(string.to_graphemes)
      |> list.transpose
      |> list.reverse

    let #(problems, _) = {
      use accumulator: #(List(Problem), List(Int)), column <- list.fold(
        columns,
        #([], []),
      )
      let #(problems, numbers) = accumulator

      let val =
        string.join(column, "") |> string.replace(" ", "") |> string.trim

      let operation = case
        val |> string.ends_with("+"),
        val |> string.ends_with("*")
      {
        True, _ -> Ok(int.add)
        _, True -> Ok(int.multiply)
        False, False -> Error(Nil)
      }

      let number =
        val
        |> string.replace("+", "")
        |> string.replace("*", "")
        |> string.trim
        |> int.parse

      case operation, number {
        Ok(operation), Ok(number) -> #(
          [Problem(operation, [number, ..numbers]), ..problems],
          [],
        )
        Error(_), Ok(number) -> #(problems, [number, ..numbers])
        _, _ -> accumulator
      }
    }
    problems
  }

  use accumulator, problem <- list.fold(parse(input), 0)
  case list.reduce(problem.numbers, problem.operation) {
    Ok(solution) -> accumulator + solution
    Error(_) -> accumulator
  }
}
