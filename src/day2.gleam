import gleam/bool
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/result.{try}
import gleam/string
import simplifile

pub fn parse_file(path: String) {
  use file <- try(simplifile.read(path))
  Ok(
    string.split(file, "\n")
    |> list.map(fn(line) {
      string.split(line, " ")
      |> list.map(int.parse)
      |> list.map(result.unwrap(_, 0))
    }),
  )
}

fn check_levels(levels: List(Int)) {
  let diffs =
    list.window_by_2(levels)
    |> list.map(fn(x) { x.0 - x.1 })

  let any_increased = list.any(diffs, fn(x) { x > 0 })
  let any_decreased = list.any(diffs, fn(x) { x < 0 })
  let all_diffs_inside_bounds =
    diffs
    |> list.map(int.absolute_value)
    |> list.all(fn(x) { x >= 1 && x <= 3 })

  bool.exclusive_or(any_increased, any_decreased) && all_diffs_inside_bounds
}

pub fn solve_part_1(input: List(List(Int))) {
  input
  |> list.map(check_levels)
  |> list.map(bool.to_int)
  |> int.sum()
}

pub fn solve_part_2(input: List(List(Int))) {
  input
  |> list.map(fn(levels) {
    let indicies = list.range(0, list.length(levels))
    let indexed_levels = list.zip(indicies, levels)

    list.map(indicies, fn(i) {
      indexed_levels
      |> list.filter(fn(x) { x.0 != i })
      |> list.map(fn(x) { x.1 })
      |> check_levels
    })
    |> list.any(function.identity)
  })
  |> list.map(bool.to_int)
  |> int.sum()
}

pub fn solve_file(path: String) {
  use input <- try(parse_file(path))
  io.debug(solve_part_1(input))
  io.debug(solve_part_2(input))
  Ok(0)
}
