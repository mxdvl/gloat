import gleam/string
import solve_2025_11

const input = "
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
"

pub fn part_one_test() {
  let result =
    input
    |> string.trim
    |> solve_2025_11.part_one
  assert result == 5
}

const second_input = "
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
"

pub fn part_two_test() {
  let result =
    second_input
    |> string.trim
    |> solve_2025_11.part_two
  assert result == 2
}
