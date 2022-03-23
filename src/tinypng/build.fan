#! /usr/bin/env fan

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "tinypng"
    summary = "TinyPng image compression API for Fantom"
    version = Version("0.2")
    meta = [
      "org.name":     "Novant",
      "org.uri":      "https://novant.io/",
      "license.name": "MIT",
      "vcs.name":     "Git",
      "vcs.uri":      "https://github.com/novant-io/tinypng"
    ]
    depends = ["sys 1.0", "util 1.0", "web 1.0"]
    resDirs = [`doc/`]
    srcDirs = [`fan/`]
    docApi  = true
    docSrc  = true
  }
}
