import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/regex
import gleam/result.{try}
import gleam/string_tree
import simplifile

pub fn parse_file(path: String) {
  simplifile.read(path)
}

// pub fn solve_input(input: String, total: Int) {
//   use padstart <- option.map(case input {
//     "mul(" <> rest -> Some(rest)
//     _ -> None
//   })

//   string_tree.is_empty

//   use firstarg <- option.map(case padstart {
//     rest <> "," -> Some(rest)
//     _ -> None
//   })

//   padstart
// }

pub fn solve_file(path: String) {
  use input <- option.map(
    parse_file(path)
    |> option.from_result(),
  )

  use reg <- option.map(
    regex.compile(
      "mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\)",
      regex.Options(False, False),
    )
    |> option.from_result(),
  )

  let result =
    regex.scan(reg, input)
    |> list.fold(#(0, True), fn(acc, match) {
      case match.content {
        "do()" -> #(acc.0, True)
        "don't()" -> #(acc.0, False)
        _ -> {
          case acc.1 {
            True -> {
              let match_numbers =
                match.submatches
                |> list.map(fn(submatch) {
                  case submatch {
                    Some(s) -> option.from_result(int.parse(s))
                    None -> None
                  }
                })
              case match_numbers {
                [Some(x), Some(y)] -> #(acc.0 + x * y, acc.1)
                _ -> acc
              }
            }
            False -> acc
          }
        }
      }
    })

  result
}
