import argv
import gleam/int
import gleam/io
import gleam/string
import simplifile
import solve_2024_01
import solve_2024_02
import solve_2025_01

pub fn main() -> Nil {
  case argv.load().arguments {
    ["2024", "1"] ->
      display(#(2024, 1), solve_2024_01.part_one, solve_2024_01.part_two)
    ["2024", "2"] ->
      display(#(2024, 2), solve_2024_02.part_one, solve_2024_02.part_two)
    ["2024", day] -> io.print("No solution for 2024 day " <> day)
    ["2025", "1"] ->
      display(#(2025, 1), solve_2025_01.part_one, solve_2025_01.part_two)
    ["2025", _] -> io.print("No solutions for 2025")
    _ -> io.print("Please provide the following arguments: <year> <day>")
  }
}

fn display(
  pair: #(Int, Int),
  one: fn(String) -> Int,
  two: fn(String) -> Int,
) -> Nil {
  let #(year, day) = pair
  case
    simplifile.read(
      "src/solve_"
      <> year |> int.to_string
      <> "_"
      <> day |> int.to_string |> string.pad_start(2, "0")
      <> ".txt",
    )
  {
    Ok(content) -> {
      io.println(
        "\nResults for "
        <> year |> int.to_string
        <> ", day "
        <> day |> int.to_string
        <> ":",
      )
      io.println("- part one " <> one(content) |> int.to_string)
      io.println("- part two " <> two(content) |> int.to_string)
    }
    Error(_) -> io.print("Failed to read input file")
  }
}
