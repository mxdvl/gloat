import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  let #(left, right) =
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
    |> list.unzip()

  list.zip(list.sort(left, int.compare), list.sort(right, int.compare))
  |> list.fold(0, fn(accumulator, pair) {
    let #(l, r) = pair
    accumulator + int.absolute_value(l - r)
  })
}

pub fn part_two(input: String) -> Int {
  let #(left, right) =
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
    |> list.unzip()

  list.fold(left, 0, fn(accumulator, int) {
    list.filter(right, fn(item) { item == int })
    |> list.length
    |> int.multiply(int)
    |> int.add(accumulator)
  })
}
