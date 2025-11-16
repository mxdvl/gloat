import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn part_one(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.filter(fn(line) {
    let levels =
      string.split(line, " ")
      |> list.flat_map(fn(item) {
        case int.base_parse(item, 10) {
          Ok(value) -> [value]
          Error(_) -> []
        }
      })
      |> list.window_by_2()

    case levels {
      [#(first, second), ..] ->
        levels
        |> list.all(safe(_, int.compare(first, second)))
      _ -> False
    }
  })
  |> list.length()
}

pub fn part_two(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.flat_map(fn(item) {
      case int.base_parse(item, 10) {
        Ok(value) -> [value]
        Error(_) -> []
      }
    })
  })
  |> list.filter(fn(report) {
    [
      report,
      ..list.flat_map(report, fn(_) {
        list.index_map(report, fn(_, index) { drop_from_list(report, index) })
      })
    ]
    |> list.any(fn(comination) {
      let levels = list.window_by_2(comination)
      case levels {
        [#(first, second), ..] ->
          levels
          |> list.all(safe(_, int.compare(first, second)))
        _ -> False
      }
    })
  })
  |> list.length()
}

fn safe(pair: #(Int, Int), order: order.Order) -> Bool {
  let #(left, right) = pair
  let difference = int.absolute_value(left - right)
  1 <= difference && difference <= 3 && order == int.compare(left, right)
}

fn drop_from_list(list: List(t), index: Int) -> List(t) {
  list.append(list.take(list, index), list.drop(list, index + 1))
}
