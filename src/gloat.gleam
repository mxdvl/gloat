import argv
import gleam/io

pub fn main() -> Nil {
  case argv.load().arguments {
    ["2024", "1"] -> io.println("Running Advent of Code 2024 Day 1")
    _ -> io.print("Please provide a year and day")
  }
}
