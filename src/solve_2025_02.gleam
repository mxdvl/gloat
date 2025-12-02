import gleam/int
import gleam/list
import gleam/string

pub fn part_one(input: String) -> Int {
  use accumulator, x <- list.fold(parse(input), 0)
  let string = int.to_string(x)

  case string.length(string) {
    length if length % 2 == 0 -> {
      let half = length / 2
      case string.drop_start(string, half) == string.drop_end(string, half) {
        True -> accumulator + x
        False -> accumulator
      }
    }
    _ -> accumulator
  }
}

fn parse(input: String) -> List(Int) {
  use line <- list.flat_map(string.split(input, ","))
  case list.map(string.split(line, "-"), int.parse) {
    [Ok(left), Ok(right)] -> list.range(left, right)
    _ -> []
  }
}
