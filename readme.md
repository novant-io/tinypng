# TinyPNG for Fantom

Fantom API and command line tool for compressing PNG image files using the
[TinyPNG](https://tinypng.com) Web API.

Note a developer API key is required, which you can get for free on the
TinyPNG website.

## Installation

Install into your current Fantom repo using `fanr`:

    $ fanr install tinypng

## Usage

A simple command line tool is included:

    usage: fan tinypng --key <api_key> <input> <output>

Example:

    $ fan tinypng --key <api_key> foo.png bar.png
    compress
      foo.png -> bar.png [57KB -> 15KB, -73.68%, -42KB]
    done!

## API Usage

To use compression from Fantom, use `TinyPng.compress` with your API key and
input and output files:

```fantom
TinyPng(key).compress(input, output)
```