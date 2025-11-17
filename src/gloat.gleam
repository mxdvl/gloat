import argv
import gleam/int
import gleam/io
import simplifile
import solve_2024_01
import solve_2024_02

pub fn main() -> Nil {
  case argv.load().arguments {
    ["2024", "1"] ->
      display(
        "src/solve_2024_01.txt",
        solve_2024_01.part_one,
        solve_2024_01.part_two,
      )
    ["2024", "2"] ->
      display(
        "src/solve_2024_02.txt",
        solve_2024_02.part_one,
        solve_2024_02.part_two,
      )
    _ -> io.print("Please provide a year and day")
  }
}

fn display(
  filepath: String,
  one: fn(String) -> Int,
  two: fn(String) -> Int,
) -> Nil {
  case simplifile.read(filepath) {
    Ok(content) -> {
      io.println("Results for " <> filepath <> ":")
      io.println("Part one: " <> one(content) |> int.to_string())
      io.println("Part two: " <> two(content) |> int.to_string())
    }
    Error(_) -> io.print("Failed to read input file")
  }
}
