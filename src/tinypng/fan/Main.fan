//
// Copyright (c) 2022, Novant LLC
// Licensed under the MIT License
//
// History:
//   22 Mar 2022  Andy Frank  Creation
//

**
** Command line utility for TinyPng.
**
class Main
{
  ** Entry-point.
  Int main()
  {
    // check args
    args := Env.cur.args
    if (args.size != 4)
    {
      echo("usage: fan tinypng --key <api_key> <input> <output>")
      return -1
    }

    // verify key
    if (args[0] != "--key") return abort("invalid argument: ${args.first}")
    key := args[1]

    // verify input
    input  := args[2].toUri.toFile
    output := args[3].toUri.toFile
    if (!input.exists) return abort("file not found: ${input}")

    // compress
    TinyPng(key).compress(input, output)
    return 0
  }

  ** Print message to stderr and return non-zero.
  private Int abort(Str msg)
  {
    Env.cur.err.printLine(msg)
    return -1
  }
}
