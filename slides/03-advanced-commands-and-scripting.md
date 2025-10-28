---
title: "Introduction to Linux: **Advanced Commands and Scripting**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

- SELinux context: chcon, ls -Z / stat
- diff, delta
- fg, bg
- tmux
- script
- editors?
- bash scripting
  - exit codes, `$?`
  - sed
  - functions, loops
  - variables, substitution
  - command concatenation
  - set options (set -xeu pipefail)
  - shebang (/usr/bin/env bash), posix
  - File descriptors
  - `&&`, `||`
  - `>/dev/null`, `2>&1`
  - basename
  - dirname
  - sort / uniq
  - base64
  - jq / yq / python3 -m json.tool
- openssl

Other Handy Tools
===

| Command | Description                         | Useful Flags / Examples  |
| ------- | ----------------------------------- | ------------------------ |
| `date`  | Show/set system date and time       | `date +"%Y-%m-%d %H:%M"` |
| `time`  | Measure execution time of a command | `time ls -l`             |
| `echo`  | Print text or variables to terminal | echo "Hello, world!"     |

<!-- end_slide -->

Concatenating Commands
===


POSIX allows chaining commands in multiple ways:

```bash
# Sequential execution: next command runs regardless of previous
command1; command2

# Conditional execution: run next only if previous succeeds
command1 && command2

# Conditional execution: run next only if previous fails
command1 || command2

# Group commands in a subshell
(command1; command2)
````


<!-- end_slide -->

File Descriptors
===

File descriptors are used to manage input/output streams:

```bash
# Redirect stdout to a file
echo "Hello" > output.txt

# Redirect stderr to a file
ls non_existing_file 2> errors.txt

# Redirect both stdout and stderr
command &> combined.txt

# Read from a file descriptor
exec 3< input.txt
read -u 3 line
```

* `0` → stdin
* `1` → stdout
* `2` → stderr
  Custom FDs start at 3.

<!-- end_slide -->

Functions in Bash
===

Functions allow reusable blocks of code:

```bash
# Define a function
greet() {
  echo "Hello, $1"
}

# Call a function
greet "Alice"

# Functions can return status codes
check_file() {
  [[ -f "$1" ]]
}
```

Functions improve code clarity and reduce repetition.

<!-- end_slide -->

Loops: for and while
===
<!-- column_layout: [3, 3] -->
<!-- column: 0 -->
# For Loop

```bash
for i in {1..5}; do
  echo "Number $i"
done
```

```bash +exec
for i in {1..5}; do
  echo "Number $i"
done
```


```
# Loop over files
for file in *.txt; do
  echo "File: $file"
done
```

<!-- column: 1 -->
# While Loop

```bash
counter=1
# POSIX uses single brackets, but supports less operators
while [[ $counter -le 5 ]]; do
  echo "Count $counter"
  ((counter++))
done
```

Loops automate repetitive tasks.

<!-- end_slide -->

POSIX vs Bash
===

- `/bin/sh` → POSIX-compliant shell
- `/bin/bash` → Bash-specific features, not always POSIX

```bash
# POSIX (works in /bin/sh)
echo "Hello"

# Bash extension (won't work in pure POSIX sh)
[[ -f file.txt ]] && echo "Exists"
```

**POSIX standard includes:**

- Basic syntax (`if`, `while`, `for`, `case`)
- Variables and expansions
- Redirection
- Command substitution

Bash adds arrays, `[[ ]]`, process substitution, and more.

<!-- end_slide -->

Variables
===

```bash
# Assign
name="Alice"

# Use
echo "Hello $name"

# Read-only
readonly pi=3.14

# Environment variable
export PATH="/usr/local/bin:$PATH"
```

Variable scoping: local variables inside functions vs global outside.

<!-- end_slide -->

Error Handling
===

Bash scripts often need strict error handling:

```bash
#!/bin/bash
set -xeuo pipefail

# -x : show commands as executed
# -e : exit immediately on error
# -u : error on unset variables
# -o pipefail : pipeline fails if any command fails
```

This ensures predictable, safe scripts and easier debugging.

<!-- end_slide -->

Summary
===

- Commands can be concatenated (`; && ||`)
- File descriptors handle input/output streams
- Functions organize reusable code
- Loops (`for`, `while`) automate tasks
- `/bin/sh` is POSIX, `/bin/bash` adds extra features
- Variables can be local, global, or environment
- Error handling via `set -xeuo pipefail`

