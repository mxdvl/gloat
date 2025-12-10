import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part_one(input: String) -> Int {
  use accumulator, indicator <- list.fold(parse(input), 0)
  echo indicator
  accumulator + press(indicator, 1)
}

fn press(indicator: Indicator, presses: Int) {
  let max = indicator.buttons |> list.length

  case
    list.combinations(indicator.buttons, presses)
    |> list.find(fn(buttons) {
      // echo #(indicator.diagram |> format, buttons, buttons |> list.map(format))
      indicator.diagram == list.fold(buttons, 0, int.bitwise_exclusive_or)
    })
  {
    Ok(buttons) -> {
      buttons |> list.each(display)
      display(indicator.diagram)
      presses
    }
    Error(_) if presses > max -> {
      echo "Something awful happened"
      0
    }
    Error(_) -> press(indicator, presses + 1)
  }
}

pub fn part_two(input: String) -> Int {
  // echo parse(input)
  -1
}

type Indicator {
  Indicator(diagram: Int, buttons: List(Int), joltage: List(Int))
}

fn parse(input: String) -> List(Indicator) {
  use line <- list.flat_map(string.split(input, "\n"))
  let parts = line |> string.split(" ")

  case
    parts |> list.flat_map(strip(#("[", "]"), _)),
    parts |> list.flat_map(strip(#("(", ")"), _)),
    parts |> list.flat_map(strip(#("{", "}"), _))
  {
    [diagram], [_, ..] as buttons, [joltage] -> {
      let diagram =
        diagram
        |> string.replace(".", "0")
        |> string.replace("#", "1")
        |> string.reverse
        |> int.base_parse(2)
        |> result.unwrap(-1)
      let buttons =
        buttons
        |> list.map(fn(button) {
          let digits =
            button
            |> string.split(",")
            |> list.flat_map(digitise)
          // |> echo
          use accumulator, position <- list.fold(digits, 0)
          let mask =
            int.power(2, int.to_float(position))
            |> result.unwrap(-1.0)
            |> float.truncate
          // echo #(position, mask |> int.to_base2)
          int.bitwise_or(accumulator, mask)
        })
      let joltage = joltage |> string.split(",") |> list.flat_map(digitise)
      [Indicator(diagram:, buttons:, joltage:)]
    }
    _, _, _ -> []
  }
  // todo
  //
}

/// Could be made generic with `parser: fn(String) -> Result(a, b)`
fn digitise(value: String) {
  case int.parse(value) {
    Ok(digit) -> [digit]
    Error(_) -> []
  }
}

/// Makes a bitmask easy to view and debug
/// - `0000000001` ← 1
/// - `0000000011` ← 3
/// - `0000101010` ← 42
fn format(value: Int) {
  value |> int.to_base2 |> string.pad_start(10, "0")
}

fn display(value: Int) {
  echo #(format(value), value)
  value
}

fn strip(sides: #(String, String), part: String) -> List(String) {
  let #(prefix, suffix) = sides
  case part |> string.starts_with(prefix) && part |> string.ends_with(suffix) {
    True -> [
      part
      |> string.drop_start(string.length(prefix))
      |> string.drop_end(string.length(suffix)),
    ]
    False -> []
  }
}
