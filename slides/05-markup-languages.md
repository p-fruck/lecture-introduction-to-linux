---
title: "Introduction to Linux: **Markup Languages**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

Markup Languages
===

# Goal of this Lecture
- Introduce markup languages and show their importance
- Understand how tables are written in Markdown, Typst, and LaTeX
- Learn how bibliographies work in LaTeX (incl. Zotero & Better BibTeX)
- Explore Pandoc and its document-conversion capabilities
- Know the role of LaTeX distributions (e.g., TeX Live)
- Compare the differences between pdfLaTeX and XeLaTeX

# Why?

- Tables and citations are essential for academic writing
- Pandoc is a key tool in modern documentation workflows
- Understanding LaTeX distributions helps with installing and debugging
- Choosing the right LaTeX engine improves compatibility and output quality

<!-- end_slide -->


Overview
===

<!-- column_layout: [3, 2] -->
<!-- column: 0 -->

# What Are Markup Languages?

- Text-based systems for structuring and formatting documents
- Human-readable
- Convert into other formats (HTML, PDF, slides, ...)
- Today taking a look on
  - Markdown
  - Typst
  - LaTeX

# Advantages

- Easier consistent formatting compared to Word, etc.
- Similar to programming languages
- Version control using Git

<!-- column: 1 -->

# Markdown  

- Simple & lightweight
- Great for documentation, READMEs, notes

# Typst

- New declarative typesetting
- Fast, modern, clear syntax

# LaTeX

- Powerful scientific typesetting
- Industry standard for math-heavy work

<!-- reset_layout -->

## When To Use What?

- **Markdown**: documentation, blogs, lightweight notes
- **Typst**: structured documents, reports, modern workflows
- **LaTeX**: heavy mathematics, academic papers, journals

<!-- end_slide -->


LaTeX vs. Typst
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# LaTeX: Classic Typesetting

LaTeX is extremely powerful but more verbose

- 40+ years of tooling
- Academic gold standard
- Mature packages
- Verbose syntax
- Large installation

A "simple" LaTeX document snippet

```latex
\documentclass{article} % You can also use report, book, etc.

% Optional packages
\usepackage[utf8]{inputenc}   % For UTF-8 encoding
\usepackage{amsmath, amssymb} % For math symbols

\title{My LaTeX Document}
\author{Your Name}
\date{December 2, 2025}  % Or use \today for current date

\begin{document}
...
\end{document}
```

<!-- column: 1 -->

# Typst: A Modern Alternative

Typst is very fast and modern

- Engine is written in Rust
- Consists of a single static binary
- Much easier setup than LaTeX
- Syntax is a wild mix - some like it, we don't
- Built-in styling system
- Still a young ecosystem

A simple Typst document setup

```typst
#set page(size: "A4", margin: 2cm)
#set title["My Typst Document"]
#set author["Your Name"]
#set date[2025-12-02]
```

# Markdown

- Simple syntax with minimal markup
- Raw text is clean and easy to read without rendering
- Can be converted to HTML, PDF, slides, and many other formats
- Widely supported, e.g., in GitHub, documentation, blogs, notes, etc.
- Writers can concentrate on writing instead of formatting
- Can include tables, code blocks, math, images, links, and more with minimal effort

<!-- end_slide -->


Markdown Structure
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```markdown
# Level 1 Heading

This is an introductory paragraph under a level-1 heading.

## Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list
- Apples
- Bananas

Here is an ordered list
1. First step
2. Second step

And finally, a nested list
- Programming languages
  - Rust
  - Python
```

<!-- column: 1 -->

# Level 1 Heading

This is an introductory paragraph under a level-1 heading.

## Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list
- Apples
- Bananas

Here is an ordered list
1. First step
2. Second step

And finally, a nested list
- Programming languages
  - Rust
  - Python

<!-- end_slide -->


Typst Structure
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```markdown
= Level 1 Heading

This is an introductory paragraph under a level-1 heading.

== Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list
- Apples
- Bananas

Here is an ordered list
1. First step
2. Second step

And finally, a nested list
- Programming languages
  - Rust
  - Python
```

<!-- column: 1 -->

```typst +render
= Level 1 Heading

This is an introductory paragraph under a level-1 heading.

== Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list 
- Apples
- Bananas

Here is an ordered list 
1. First step
2. Second step

And finally, a nested list
- Programming languages
  - Rust
  - Python
```

<!-- end_slide -->


LaTeX Structure
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```latex
\section{Level 1 Heading}
This is an introductory paragraph under a level-1 heading.

\subsection{Level 2 Heading}
More detailed section text goes here.

Here is a simple unordered list
\begin{itemize}
  \item Apples
  \item Bananas
\end{itemize}

Here is an ordered list
\begin{enumerate}
  \item First step
  \item Second step
\end{enumerate}

And finally, a nested list
\begin{itemize}
  \item Programming Languages
    \begin{itemize}
      \item Rust
      \item Python
    \end{itemize}
\end{itemize}
```

<!-- column: 1 -->

```latex +render
\section{Level 1 Heading}
This is an introductory paragraph under a level-1 heading.

\subsection{Level 2 Heading}
More detailed section text goes here.

Here is a simple unordered list
\begin{itemize}
  \item Apples
  \item Bananas
\end{itemize}

Here is an ordered list
\begin{enumerate}
  \item First step
  \item Second step
\end{enumerate}

And finally, a nested list
\begin{itemize}
  \item Programming Languages
    \begin{itemize}
      \item Rust
      \item Python
    \end{itemize}
\end{itemize}
```

<!-- end_slide -->


Markdown Formatting
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```markdown
**Bold text**

__Also bold text__

*Italic text*

_Also italic text_

~~Strikethrough~~

<u>Underlined text</u>
<!-- Not standard, but supported in many Markdown renderers -->

[Link example](https://example.com)

Line<br>break
<!-- Not standard, but supported in many Markdown renderers -->
```

<!-- column: 1 -->

**Bold text**

__Also bold text__

*Italic text*

_Also italic text_

~~Strikethrough~~

\<u\>Underlined text\</u\>

\<!-- Not standard, but supported in many Markdown renderers --\>

[Link example](https://example.com)

Line\<br\>break

\<!-- Not standard, but supported in many Markdown renderers --\>

<!-- reset_layout -->

> Italic text cannot be displayed in this presentation due to the font used!

<!-- end_slide -->


Typst Formatting
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```typst
#text(weight: "bold")[Bold text]

_Italic text_ \
#emph[Italic text]

#strike[Strikethrough]

#underline[Underlined text]

#link("https://example.com")[Link example]

Line\ break
```

<!-- column: 1 -->

```typst +render +width:70%
#text(weight: "bold")[Bold text]

_Italic text_ \
#emph[Italic text]

#strike[Strikethrough]

#underline[Underlined text]

#link("https://example.com")[Link example]

Line\ break
```

<!-- end_slide -->


LaTeX Formatting
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```latex
\textbf{text}

\textit{Italic text}\\
\emph{Italic text}

% requires \usepackage{ulem}
\sout{Strikethrough}

\underline{Underlined text}

% requires \usepackage{hyperref}
\href{https://example.com}{Link example}

Line\\break
```

<!-- column: 1 -->

```latex +render +width:60%
\textbf{text}

\textit{Italic text}\\
\emph{Italic text}

% requires \usepackage{ulem}
\sout{Strikethrough}

\underline{Underlined text}

% requires \usepackage{hyperref}
\href{https://example.com}{Link example}

Line\\break
```

<!-- end_slide -->


Mathematical Formulas
===

<!-- column_layout: [2, 1, 2] -->
<!-- column: 0 -->

# Typst

```typst
$
frac(a^2, 2)
$

$
vec(1, 2, delim: "[")
$

$
mat(1, 2; 3, 4)
$

$
mat(..#range(1, 5).chunks(2))
$

$
lim_x =
    op("lim", limits: #true)_x
$
```

<!-- column: 1 -->

```typst +render
$
frac(a^2, 2)
$

$
vec(1, 2, delim: "[")
$

$
mat(1, 2; 3, 4)
$

$
mat(..#range(1, 5).chunks(2))
$

$
lim_x =
    op("lim", limits: #true)_x
$
```

<!-- column: 2 -->

# LaTeX

```latex
\[
\frac{a^{2}}{2}
\]

\[
\begin{bmatrix}
1 \\ 2
\end{bmatrix}
\]

\[
\begin{pmatrix}
1 & 2 \\3 & 4
\end{pmatrix}
\]

\[
\begin{pmatrix}
1 & 2 \\3 & 4
\end{pmatrix}
\]

\[
\lim_{x} = \operatorname{lim}_{x}
\]
```

<!-- end_slide -->


Tables
===

<!-- column_layout: [1, 1, 1] -->
<!-- column: 0 -->

# Markdown

* Very simple table syntax
* Limited styling in pure Markdown
* Extended features depend on renderer (GitHub, Pandoc, etc.)

```markdown
| **Name** | **Age** | **City** |
|:---------|:-------:|---------:|
| Alice    | 23      | Ulm      |
| Bob      | 21      | Mannheim |
```

> http://markdowntable.com

<!-- column: 1 -->

# Typst

* Built-in table type
* Very clean syntax
* Supports alignment, styling, table headers

```typst
#table(
  columns: 3,
  align: (left, center, right),
  [*Name*], [*Age*], [City],
  [Alice], [23], [Ulm],
  [Bob], [21], [Mannheim],
)
```

<!-- column: 2 -->

# LaTeX

* Very flexible
* Requires the `tabular` environment
* Use `booktabs` for nicer tables

```latex
\begin{tabular}{l c r}
  \hline
  Name & Age & City \\
  \hline
  Alice & 23 & Ulm \\
  Bob   & 21 & Mannheim \\
  \hline
\end{tabular}
```

> https://www.tablesgenerator.com/latex_tables

<!-- reset_layout -->
<!-- column_layout: [1, 1, 1] -->
<!-- column: 0 -->

| **Name** | **Age** | **City** |
|:---------|:-------:|---------:|
| Alice    | 23      | Ulm      |
| Bob      | 21      | Mannheim |

<!-- column: 1 -->

```typst +render
#table(
  columns: 3,
  align: (left, center, right),
  [*Name*], [*Age*], [City],
  [Alice], [23], [Ulm],
  [Bob], [21], [Mannheim],
)
```

<!-- column: 2 -->

```latex +render
\begin{tabular}{l c r}
  \hline
  Name & Age & City \\
  \hline
  Alice & 23 & Ulm \\
  Bob   & 21 & Mannheim \\
  \hline
\end{tabular}
```

<!-- end_slide -->


Bibliography in LaTeX
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# Basics

- Managed using BibTeX or BibLaTeX
- Bibliography stored in `.bib` files
- Common fields:
  - `author`, `title`, `year`, `journal`, `url`, ...
- Citation commands
  - `\cite{key}`
  - `\parencite{key}` (BibLaTeX)
  - `\textcite{key}` (BibLaTeX)

<!-- column: 1 -->

The `.bib` file (bibliography database file)

```bib
@book{knuth1998,
  author = {Donald E. Knuth},
  year = {1998},
  title = {The {\TeX} Book},
  publisher = {Addison-Wesley Professional}
}
```

Import the package `biblatex` and add the bibliography database file

```latex
\usepackage[backend=biber,style=authoryear]{biblatex}
\addbibresource{refs.bib}
```

Use the references in the document

```latex
According to \textcite{knuth1998}, ...
```

<!-- end_slide -->


Managing the Bibliography
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# Zotero

- Free reference manager
- Automatic metadata scraping from PDFs and websites
- Plugins for Word, LibreOffice and Firefox
- Stores references, notes, PDFs in a central library

Why use it?

- Easy to organise references
- Sync across devices
- Works extremely well with LaTeX

<!-- column: 1 -->

# Better BibTeX (BBT)

- Zotero plugin for LaTeX users
- Adds
  - Better BibTeX keys (e.g., `AuthorYearTitle`)
  - Automatic `.bib` export
  - Auto-updating `.bib` on save
- Perfect toolchain for LaTeX writing

<!-- end_slide -->


LaTeX Distributions
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# What Is a LaTeX Distribution?

- Bundle of
  - LaTeX engine (pdfTeX, XeTeX, LuaTeX, ...)
  - Thousands of packages
  - Fonts
  - Documentation tools
- Needed to compile `.tex` files

# Common Distributions

- TeX Live
  - Cross-platform (Linux, macOS, Windows)
  - Very complete
  - Package manager: `tlmgr`
- MiKTeX
  - Windows-focused
  - Installs missing packages automatically
- MacTeX
  - macOS version of TeX Live
  - Large but well-integrated

<!-- column: 1 -->

# TeX Live Features

- Industry-standard distribution
- Updated yearly (`TeX Live YYYY`)
- Includes:
  - LaTeX kernel
  - BibLaTeX/Biber
  - AMS packages
  - Graphics and font packages
  - Many engines: `pdftex`, `xetex`, `luatex`

# Package Management

```bash
tlmgr install package
tlmgr update --self
tlmgr update --all
```

# Why TeX Live?

- Best support on Linux
- Most reproducible environment
- Works perfectly with CI/CD pipelines

<!-- end_slide -->


Building a LaTeX project
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# pdfLaTeX

- Oldest and most stable
- Produces compact PDFs
- Limited font support (only Type 1 fonts by default)
- UTF-8 works but sometimes tricky
- Best for:
  - Scientific papers
  - Documents without special typography

# latexmk

- Wrapper around multiple LaTeX compilers
- Automates repeated runs (e.g. bibliography, ToC)

# latexdiff

- Highlight diff between documents (with git)
- `latexdiff-vc --pdf --flatten -r <commit1> [-r <commit2>] main.tex`

<!-- column: 1 -->

# XeLaTeX

- Modern engine
- Full Unicode support
- Can use system fonts (e.g., Arial, Fira Code)
- Better for multilingual documents
- Slightly slower than pdfLaTeX
- Ideal for:
  - CVs
  - Design-heavy documents
  - Anything requiring custom fonts

```latex
\usepackage{fontspec}
\setmainfont{Fira Sans}
```

<!-- end_slide -->


Pandoc
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# What Is Pandoc?

- The Swiss-army knife of document conversion
- Converts between almost any formats
- Popular in technical documentation

# What Can It Do?

- Markdown -> PDF (via LaTeX or Typst)
- Markdown -> HTML/Slides
- LaTeX -> Markdown
- Word -> Markdown
- Typst -> PDF

<!-- column: 1 -->
```bash
pandoc notes.md -o notes.pdf
pandoc file.tex -o file.md
```

# Why It's Useful

- Automates formatting
- Great for reproducible documents
- Works nicely in CI pipelines
- Robust tool for long-term documentation workflows

<!-- end_slide -->

Pandoc
===
<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# Markdown -> PDF via LaTeX

```bash
pandoc report.md \
  --from markdown \
  --to pdf \
  --pdf-engine=pdflatex \
  -o report.pdf
```

> Real world example using a LaTeX template!

# Markdown -> Typst

```bash
pandoc slides.md -t typst -o slides.typ
```

<!-- column: 1 -->

# Filters & Extensions

- Pandoc has **filters** for modifying AST
- Example: convert latex math to images, handle citations, code-block highlighting
- Zotero -> Pandoc works via Citeproc

```bash
pandoc paper.md \
  --citeproc \
  --bibliography=refs.bib \
  -o paper.pdf
```

<!-- end_slide -->


Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
