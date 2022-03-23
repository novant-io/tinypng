//
// Copyright (c) 2022, Novant LLC
// Licensed under the MIT License
//
// History:
//   22 Mar 2022  Andy Frank  Creation
//

using web
using util

**
** Comples LESS source files into CSS output files.
**
class TinyPng
{
  ** Create a new TinyPng instance with given API key.
  new make(Str apiKey) { this.apiKey = apiKey }

  ** Compress the given 'input' file and write result to 'output'
  Void compress(File input, File output, Str:Obj opts := [:])
  {
    // sanity check
    if (!input.exists) throw ArgErr("input not found: ${input.osPath}")

    // compress
    echo("compress")
    doCompress(input, output, opts)
    echo("done!")
  }

  ** Compress file.
  private Void doCompress(File input, File output, Str:Obj opts)
  {
    Env.cur.out.print("  ${input.osPath} -> ${output.osPath} ").flush

    // read input file
    sbuf := input.readAllBuf
    slen := sbuf.size

    // compress
    cbuf := doApiCompress(sbuf)
    clen := cbuf.size

    // write output
    output.out.writeBuf(cbuf).sync.close

    // print compression results
    diff := slen - clen
    cper := (diff.toFloat / slen.toFloat * 100f).toLocale("0.00")
    sloc := slen.toLocale("B")
    cloc := clen.toLocale("B")
    dloc := diff.toLocale("B")
    echo("[${sloc} -> ${cloc}, -${cper}%, -${dloc}]")
  }

  ** Send file to tinypng and download result.
  private Buf doApiCompress(Buf source)
  {
    // post source content
    wc := WebClient(`https://api.tinify.com/shrink`)
    wc.authBasic("api", apiKey)
    wc.reqHeaders["Content-Length"] = source.size.toStr
    wc.reqMethod = "POST"
    wc.writeReq
    wc.reqOut.writeBuf(source).close

    // get file location
    wc.readRes
    map := (Map)JsonInStream(wc.resIn).readJson
    uri := (map["output"] as Map).get("url").toStr.toUri

    // download file
    return WebClient(uri).getBuf
  }

  private const Str apiKey
}
