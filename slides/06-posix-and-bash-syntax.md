---
title: 'Introduction to Linux: **POSIX and Bash Syntax**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

POSIX vs Bash
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# Goal of this lecture

- Learn core Bash scripting syntax
- Understand differences between POSIX and Bash-specific features

# Why?

- Scripts need to run reliably across different shells
- Core syntax knowledge is the foundation for writing scripts

<!-- column: 1 -->

# Use Cases:

- Portable automation scripts
- Configuration and setup scripts
- Writing reusable shell functions

<!-- end_slide -->

Shebang
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

# How-to

- The **shebang** line tells the system *which interpreter* should execute the script.
- Must appear as the first line of the script
- Starts with #! followed by the interpreter path
- Allows running `./script` instead of `bash ./script`
  - Ensures correct interpreter is used even if no file extension is present

<!-- column: 1 -->

# Examples

```bash
#!/bin/sh
```

```bash
#!/bin/bash
```

```bash
#!/usr/bin/env bash
```

```bash
#!/usr/bin/env python3
```

<!-- reset_layout -->

> 💡 Tip: Using `/usr/bin/env` makes your script more portable across systems (`/bin/sh` is a special case as it is required by the POSIX standard).

<!-- end_slide -->

Variables
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

```bash
# Assign
name=Alice
# Use quotes to include spaces
fullname="Bob the builder"

# Use
echo "Hello $name"
# Brackets define the start and end of variables
echo "${name}.lastname@example.com"

# Read-only
readonly pi=3.14

# Environment variable
export PATH="/usr/local/bin:$PATH"
```

<!-- pause -->

<!-- column: 1 -->

```bash +exec
name=Bob
fullname="$name the builder"
# Variables are replace in double quotes
echo "Fullname: $fullname"
# But not in single quotes:
message='$name is a nice name!'
echo $message
```

<!-- reset_layout -->

<!-- pause -->

> Variable scoping: local variables inside functions vs global outside.

> Using `export` allows variables to be used by other processes launched from the current session.

<!-- end_slide -->

Conditionals
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# If-else logic

- The `if` statement runs commands conditionally based on exit status

```bash
# hint: Do not use this in prod :)
if [ "$USER" = "root" ]; then
  echo "Welcome, root user!"
elif [ "$USER" = "admin" ]; then
  echo "Hello, admin."
else
  echo "Access denied."
fi
```

> Tip: Prefer `[[ ... ]]` for Bash-specific scripting, it is safer for strings.

<!-- column: 1 -->

# Case statement

- `case` compares a value against multiple patterns

```bash
case "$arg" in
  start)
    echo "Starting service..."
    ;;
  stop)
    echo "Stopping service..."
    ;;
  restart|reload)
    echo "Restarting service..."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
```

<!-- reset_layout -->

<!-- end_slide -->

Functions in Bash
===

# Functions allow reusable blocks of code

- Functions improve code clarity and reduce repetition.
- Bash allows further syntax to define functions but this way is POSIX compliant, hence more portable

```bash
# Define a function
greet() {
  echo "Hello, $1"
}

# Call a function
greet "Alice"

# Functions can return status codes
check_file() {
  # in POSIX, just run the command without [[ ]]
  [[ -f "$1" ]]
}
```

> `$1` is the first parameter passed to a function or shell script

<!-- end_slide -->

Loops: for and while
===

Loops automate repetitive tasks.

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# For Loop

```bash +exec
# Loop over files
for file in *.md; do
  echo "File: $file"
done

# Iterate over numbers (set notation)
for i in {1..5}; do
  echo "Number $i"
done
```

<!-- column: 1 -->

# While Loop

```bash +exec
counter=1
# POSIX uses single or no brackets, but supports less operators
while [[ $counter -le 5 ]]; do
  echo "Count $counter"
  ((counter++))
done
```

<!-- end_slide -->

Globbing
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Globbing (Filename Expansion)

- Globbing lets you match filenames using wildcards:

| Pattern  | Matches                          |
| -------- | -------------------------------- |
| `*`      | Any string, including empty      |
| `?`      | Any single character             |
| `[abc]`  | Any one of the listed characters |
| `[!abc]` | Any character not listed         |

<!-- column: 1 -->

# Example:

```bash
# List all .txt files
ls *.txt

# List files starting with a or b
ls [ab]*.txt
```

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
