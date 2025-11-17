import gleam/int
import gleam/list
import gleam/order
import gleam/string
import gleam/yielder

pub fn part_one(input: String) -> Int {
  input
  |> parse
  |> list.count(safe_report)
}

pub fn part_two(input: String) -> Int {
  input
  |> parse
  |> list.count(fn(report) {
    yielder.unfold(list.length(report), fn(index) {
      case index {
        -1 -> yielder.Done
        _ -> yielder.Next(drop_from_list(report, index), index - 1)
      }
    })
    |> yielder.any(safe_report)
  })
}

fn parse(input: String) -> List(List(Int)) {
  use line <- list.map(string.split(input, "\n"))
  use item <- list.flat_map(string.split(line, " "))
  case int.base_parse(item, 10) {
    Ok(value) -> [value]
    Error(_) -> []
  }
}

fn safe_report(report: List(Int)) {
  case report {
    [first, second, ..] ->
      list.window_by_2(report)
      |> list.all(safe(_, int.compare(first, second)))
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
