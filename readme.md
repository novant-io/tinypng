# TinyPng for Fantom

Fantom API and command line tool for compressing PNG image files using the
[TinyPng](https://tinypng.com) Web API.

Note a developer API key is required, which you can get for free on the
TinyPng website.

## Installation

Install into your current Fantom repo using 'fanr':

    $ fanr install tinypng

## Usage

A simple command line tool is included:

    usage: fan tinypng --key <api_key> [options] <file_or_dir>
    options
      --dry-run  Display compression results without overwritng file

Example:

    $ fan tinypng --key {api_key} foo.png
    compress
      foo.png...  57KB -> 15KB (-73.68%, -42KB)
    done!

By default the compressed file will replace the source image. Use the
`dry-run` option to see compression stats without modifying original.


## API Usage

    TinyPng(key).compress(file)