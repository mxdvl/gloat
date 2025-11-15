import argv
import gleam/int
import gleam/io
import simplifile
import solve_2024_01

pub fn main() -> Nil {
  case argv.load().arguments {
    ["2024", "1"] ->
      display(
        "src/input_2024_01.txt",
        solve_2024_01.part_one,
        solve_2024_01.part_two,
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
      io.println("Results for 2024 Day 1:")
      io.println("Part one: " <> one(content) |> int.to_string())
      io.println("Part two: " <> two(content) |> int.to_string())
    }
    Error(_) -> io.print("Failed to read input file")
  }
}
