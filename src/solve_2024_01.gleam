import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  let pairs =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.flat_map(fn(line) {
      line
      |> string.trim()
      |> string.split_once("   ")
      |> result.map(fn(tuple) {
        let #(left, right) = tuple
        case int.base_parse(left, 10), int.base_parse(right, 10) {
          Ok(l), Ok(r) -> [#(l, r)]
          _, _ -> []
        }
      })
      |> result.unwrap([])
    })

  echo pairs

  list.length(pairs)
}
