---
title: "Introduction to Linux: **Markup Languages**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

Overview
===

# TODO
- Tables
- Bibliography (Zotero + better bibtex)
- pandoc, markdown conversion
- Offensive Security Report

<!-- column_layout: [3,2] -->
<!-- column: 0 -->
# What Are Markup Languages?

- Text-based systems for structuring and formatting documents  
- Human-readable  
- Convert into other formats (HTML, PDF, slides, …)
- Today:
  - Markdown
  - Typst
  - LaTeX

# Advantages
- Easier consistent formatting compared to word etc
- Similar to programming languages
- Version control using git

<!-- column: 1 -->

# Markdown  
Simple + lightweight.  
Great for documentation, READMEs, notes.

# Typst  
New declarative typesetting.  
Fast, modern, clear syntax.

# LaTeX  
Powerful scientific typesetting.  
Industry standard for math-heavy work.

## When To Use What?

* **Markdown**: documentation, blogs, lightweight notes
* **Typst**: structured documents, reports, modern workflows
* **LaTeX**: heavy mathematics, academic papers, journals


<!-- end_slide -->


LaTeX: Classic Typesetting
===

LaTeX is extremely powerful but more verbose.

- 40+ years of tooling
- Academic gold standard
- Mature packages
- Verbose syntax
- Large installation

A simple LaTeX document snippet:

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

<!-- end_slide -->

Typst: A modern alternative
===

- Fast, modern engine
- Consists of a single static binary
- Much easier setup than LaTeX
- Syntax is a wild mix - some like it, I don't
- Built-in styling system
- Still a young ecosystem

Simple document setup:

```typst
#set page(size: "A4", margin: 2cm)
#set title["My Typst Document"]
#set author["Your Name"]
#set date[2025-12-02]
```

<!-- end_slide -->

Markdown
===


- Simple syntax with minimal markup.

- Raw text is clean and easy to read without rendering.

- Can be converted to HTML, PDF, slides, and many other formats.

- Widely supported, e.g. in GitHub, documentation, blogs, notes, and more.

- Writers can concentrate on writing instead of formatting.

- Can include tables, code blocks, math, images, links, and more with minimal effort.
<!-- end_slide -->

Markdown structure
===

<!-- column_layout: [1,1] -->
<!-- column: 0 -->
```markdown
# Level 1 Heading

This is an introductory paragraph under a level-1 heading.

## Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list:
- Apples
- Bananas

Here is an ordered list:
1. First step
2. Second step

And finally, a nested list:
- Programming languages
  - Rust
  - Python
```

<!-- column: 1 -->
# Level 1 Heading

This is an introductory paragraph under a level-1 heading.

## Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list:
- Apples
- Bananas

Here is an ordered list:
1. First step
2. Second step

And finally, a nested list:
- Programming languages
  - Rust
  - Python

<!-- end_slide -->

Typst structure
===

<!-- column_layout: [1,1] -->
<!-- column: 0 -->
```markdown
= Level 1 Heading

This is an introductory paragraph under a level-1 heading.

== Level 2 Heading

More detailed section text goes here.

Here is a simple unordered list:
- Apples
- Bananas

Here is an ordered list:
1. First step
2. Second step

And finally, a nested list:
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

Here is a simple unordered list:

- Apples
- Bananas

Here is an ordered list:

1. First step
2. Second step

And finally, a nested list:

- Programming languages
  - Rust
  - Python
```

<!-- end_slide -->

LaTeX structure
===

<!-- column_layout: [1,1] -->
<!-- column: 0 -->
```latex
\section{Level 1 Heading}
This is an introductory paragraph under a level-1 heading.

\subsection{Level 2 Heading}
More detailed section text goes here.

Here is a simple unordered list:
\begin{itemize}
  \item Apples
  \item Bananas
\end{itemize}

Here is an ordered list:
\begin{enumerate}
  \item First step
  \item Second step
\end{enumerate}

And finally, a nested list:
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

Here is a simple unordered list:
\begin{itemize}
  \item Apples
  \item Bananas
\end{itemize}

Here is an ordered list:
\begin{enumerate}
  \item First step
  \item Second step
\end{enumerate}

And finally, a nested list:
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

<!-- column_layout: [1,1] -->
<!-- column: 0 -->
```markdown
**Bold text**

*Italic text*

~~Strikethrough~~

<u>Underlined text</u>
<!-- Not standard, but supported in many Markdown renderers -->

[Link example](https://example.com)

Line<br>break
<!-- Not standard, but supported in many Markdown renderers -->
```

<!-- column: 1 -->
**Bold text**

*Italic text*

~~Strikethrough~~

\<u\>Underlined text\</u\>

\<!-- Not standard, but supported in many Markdown renderers --\>

[Link example](https://example.com)

Line\<br\>break

\<!-- Not standard, but supported in many Markdown renderers --\>
<!-- end_slide -->

Typst Formatting
===

<!-- column_layout: [1,1] -->
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

<!-- column_layout: [1,1] -->
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
\textbf{Bold text}

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

Mathematical formulas
===

<!-- column_layout: [2,1,2] -->
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

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
