import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn part_one(input: String) -> Int {
  input
  |> parse
  |> list.count(safe_report)
}

pub fn part_two(input: String) -> Int {
  input
  |> parse
  |> list.count(fn(report) {
    [
      report,
      ..list.flat_map(report, fn(_) {
        list.index_map(report, fn(_, index) { drop_from_list(report, index) })
      })
    ]
    |> list.any(safe_report)
  })
}

fn parse(input: String) -> List(List(Int)) {
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
}

fn safe_report(report: List(Int)) {
  let levels = list.window_by_2(report)
  case levels {
    [#(first, second), ..] ->
      list.all(levels, safe(_, int.compare(first, second)))
    _ -> False
  }
}

fn safe(pair: #(Int, Int), order: order.Order) -> Bool {
  let #(left, right) = pair
  let difference = int.absolute_value(left - right)
  1 <= difference && difference <= 3 && order == int.compare(left, right)
}

fn drop_from_list(list: List(t), index: Int) -> List(t) {
  list.append(list.take(list, index), list.drop(list, index + 1))
}
