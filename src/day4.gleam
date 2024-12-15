import gleam/dict
import gleam/function
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

pub fn extend_from_point(
  p: #(Int, Int),
  d: #(Int, Int),
  length: Int,
) -> List(#(Int, Int)) {
  list.map(list.range(0, length - 1), fn(i) { #(p.0 + d.0 * i, p.1 + d.1 * i) })
}

pub fn parse_file(path: String) {
  simplifile.read(path)
}

pub fn solve_file(path: String) {
  use input <- option.map(
    parse_file(path)
    |> option.from_result(),
  )

  let lines = string.split(input, "\n") |> list.map(string.to_graphemes)

  let char_lookup =
    lines
    |> list.index_map(fn(line, y) {
      line |> list.index_map(fn(char, x) { #(#(x, y), char) })
    })
    |> list.flatten()
    |> dict.from_list()

  let ds = [
    #(-1, -1),
    #(0, -1),
    #(1, -1),
    #(-1, 0),
    #(1, 0),
    #(-1, 1),
    #(0, 1),
    #(1, 1),
  ]

  dict.keys(char_lookup)
  |> list.fold(0, fn(acc, p) {
    let matches =
      list.map(ds, extend_from_point(p, _, 4))
      |> list.fold(0, fn(acc, points) {
        let chars =
          points
          |> list.map(dict.get(char_lookup, _))
          |> list.map(result.unwrap(_, ""))

        let char_matches =
          chars
          |> list.index_map(fn(char, i) {
            case char, i {
              "X", 0 -> True
              "M", 1 -> True
              "A", 2 -> True
              "S", 3 -> True
              _, _ -> False
            }
          })
        let is_match = char_matches |> list.all(function.identity)

        case is_match {
          True -> acc + 1
          False -> acc
        }
      })

    acc + matches
  })
  // |> list.map(fn(d) { io.debug(d) })
}

// ()
// 

pub fn solve_file_2(path: String) {
  use input <- option.map(
    parse_file(path)
    |> option.from_result(),
  )

  let lines = string.split(input, "\n") |> list.map(string.to_graphemes)

  let char_lookup =
    lines
    |> list.index_map(fn(line, y) {
      line |> list.index_map(fn(char, x) { #(#(x, y), char) })
    })
    |> list.flatten()
    |> dict.from_list()

  let ds = [#(-1, -1), #(1, -1), #(-1, 1), #(1, 1)]

  let final_result =
    dict.keys(char_lookup)
    |> list.fold(0, fn(acc, p) {
      let lines =
        list.map(ds, fn(d) { extend_from_point(#(p.0 - d.0, p.1 - d.1), d, 3) })

      let matches =
        lines
        |> list.fold(0, fn(acc, points) {
          let chars =
            points
            |> list.map(dict.get(char_lookup, _))
            |> list.map(result.unwrap(_, ""))

          io.debug(points)
          io.debug(chars)

          case chars |> list.contains("") {
            True -> 0
            False -> {
              let char_matches =
                chars
                |> list.index_map(fn(char, i) {
                  case char, i {
                    "M", 0 -> True
                    "A", 1 -> True
                    "S", 2 -> True
                    _, _ -> False
                  }
                })

              1
            }
          }
        })

      case matches == 2 {
        True -> acc + 1
        False -> acc
      }

      acc + matches
    })

  io.debug(final_result)
  // |> list.map(fn(d) { io.debug(d) })
}
// ()
// 
