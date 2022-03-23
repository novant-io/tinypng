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
    if (args.size != 3 && args.size != 4)
    {
      echo("usage: fan tinypng --key <api_key> [options] <file_or_dir>
            options
              --dry-run  Display compression results without overwritng file")
      return -1
    }

    // verify key
    if (args[0] != "--key") return abort("invalid argument: ${args.first}")
    key := args[1]

    // check for options
    aix := 2
    dry := false
    if (args[2] == "--dry-run") { aix++; dry=true }

    // verify file
    file := args[aix].toUri.toFile
    if (!file.exists) return abort("file not found: ${file}")

    // compress
    TinyPng(key).compress(file, ["dryRun":dry])
    return 0
  }

  ** Print message to stderr and return non-zero.
  private Int abort(Str msg)
  {
    Env.cur.err.printLine(msg)
    return -1
  }
}
