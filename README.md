# Introduction to Linux

This repo holds the material for the lecture "Introduction to Linux".
This lecture covers 24 SWS which evaluates to 22 lecture hours (each 45 min) or 16.5 h.

## Slides

All slides are located in the [slides](slides) folder and written using [presenterm](https://github.com/mfontanini/presenterm).
To rendern the slides, install presenterm.
For slides containing images, a terminal emulator like [kitty or foot](https://mfontanini.github.io/presenterm/features/images.html) must be used.
Typst and pandoc are required if typst and LaTeX should be rendered, [see docs](https://mfontanini.github.io/presenterm/features/code/latex.html).

Code blocks can be executed using `ctrl+e` if the `-x` flag is passed to presenterm.
`just` adds this flag by default, so you can run `just present slides/cli.md` to show the slide.

## Development

All markdown files are formatted using [mdformat](https://github.com/executablebooks/mdformat).
A [custom plugin](https://github.com/p-fruck/mdformat-presenterm) is used to ensure compatibility with presenterm.
The pre-commit hooks can be used for automatic formatting.
The hooks are checked upon merge requests using [prek](https://github.com/j178/prek).
