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

  ** Compress the given file or directory.  If a directory
  ** is given, all png files in directory will be compressed.
  Void compress(File source, Str:Obj opts := [:])
  {
    // sanity check
    if (!source.exists) throw ArgErr("File not found: ${source.osPath}")

    if (opts["dryRun"] == true) echo("compress [dry run]")
    else echo("compress")

    // comrpess
    files := resolve(source)
    files.each |f| { compressFile(f, opts) }

    echo("done!")
  }

  ** Resolve source into File[]
  private File[] resolve(File source)
  {
    if (source.isDir == false) return [source]
    return source.listFiles.findAll |f| { f.ext == "png" }
  }

  ** Compress file.
  private Void compressFile(File source, Str:Obj opts)
  {
    Env.cur.out.print("  ${source.osPath}...  ").flush

    // read source file
    sbuf := source.readAllBuf
    slen := sbuf.size
    smd5 := sbuf.toDigest("MD5").toHex
    // echo("  input  size=${sbuf.size} hash=${smd5}")

    // compress
    cbuf := doReqCompress(sbuf)
    clen := cbuf.size
    cmd5 := cbuf.toDigest("MD5").toHex
    // echo("  output size=${cbuf.size} hash=${cmd5}")

    // TODO: this does not appear to ever happen; always get a reduction
    // // short-circuit if no change
    // if (smd5 == cmd5)
    // {
    //   echo("(no change)")
    //   return
    // }

    // print compression results
    diff := slen - clen
    cper := (diff.toFloat / slen.toFloat * 100f).toLocale("0.00")
    sloc := slen.toLocale("B")
    cloc := clen.toLocale("B")
    dloc := diff.toLocale("B")
    echo("${sloc} -> ${cloc} (-${cper}%, -${dloc})")

    // replace file
    if (opts["dryRun"] != true) source.out.writeBuf(cbuf).sync.close
  }

  ** Send file to tinypng and download result.
  private Buf doReqCompress(Buf source)
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
