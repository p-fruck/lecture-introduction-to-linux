---
title: "Introduction to Linux: **Shell Scripting**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

ToDo!!!
===

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

Handy Tools
===

| Command | Description                         | Useful Flags / Examples  |
| ------- | ----------------------------------- | ------------------------ |
| `date`  | Show/set system date and time       | `date +"%Y-%m-%d %H:%M"` |
| `time`  | Measure execution time of a command | `time ls -l`             |
| `echo`  | Print text or variables to terminal | echo "Hello, world!"     |

<!-- end_slide -->

Overview
===

<!-- column_layout: [3, 3] -->
<!-- column: 0 -->
# Goal of this lecture

- Introduction to shell scripting

# Why?

- Automate repetitive tasks
- Improve/speedup personal workflow
<!-- column: 1 -->

# Use Cases:
- Backup scripts
- Deployment automation
- Log parsing and monitoring
- System maintenance tasks


<!-- end_slide -->

Concatenating Commands
===

<!-- column_layout: [3, 3] -->
<!-- column: 0 -->
The POSIX standard allows chaining commands in multiple ways:

```bash +exec
# Sequential execution: next command runs regardless of previous
false; echo Hello 1
true; echo Hello 2

# Conditional execution: run next only if previous succeeds
true && echo Hello 3

# Conditional execution: run next only if previous fails
false || echo Hello 4

# Run commands in sub-group
true && (false; echo Hello 5)
```

<!-- pause -->
```bash
# Command substition: Cat all files in current directory recursively
cat $(find . -type f)
```

<!-- column: 1 -->
<!-- pause -->
Every command in Bash returns an **exit code** (`$?`) indicating success or failure.

```bash
ls /tmp
echo "Exit code of ls: $?"

grep "foo" file.txt
echo "Exit code of grep: $?"
```

<!-- pause -->
```bash +exec
true
echo Output of true: $?

false
echo Output of false: $?
```

<!-- end_slide -->

File Descriptors
===

<!-- column_layout: [3, 3] -->
<!-- column: 0 -->
# File descriptors (FDs) are used to manage input/output streams:

```bash
# Redirect stdout to a file (overwrite content)
echo "Hello" > output.txt

# Append stdout to a file
echo "Hello 2" >> output.txt

# Redirect stderr to hide messages
ls non_existing_file 2> /dev/null

# Redirect both stdout and stderr
command &> combined.txt

# Create custom FD and write to it
exec 3> output.txt
echo "Hello, World!" >&3
exec 3>&- # Close the FD

# Bash feature: Use command output as file input
diff <(ls first) <(ls second)
```

- `0` → stdin
- `1` → stdout
- `2` → stderr
- Custom FDs start at 3.

<!-- column: 1 -->
<!-- pause -->

# Writing to a file without an editor

```bash
cat > newfile.txt <<EOF
this
is
the
content
of my
textfile
EOF
```

> Instead of `<<EOF`, you can use `cat > newfile.txt` and hit ^C to stop writing to the file

<!-- end_slide -->

POSIX vs Bash
===

- `/bin/sh` → POSIX-compliant shell
- `/bin/bash` → Bash-specific features, not always POSIX

> On Fedora, `/bin/sh` is a symlink to `/bin/bash`, but other distros like Debian ship more minimal shells like `dash`

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

> The `shellcheck` utility allows linting your shell script.
> It determines the correct shell syntax using the shebang

<!-- end_slide -->

Shebang
===

<!-- column_layout: [3, 3] -->
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

> 💡 Tip: Using /usr/bin/env makes your script more portable across systems (`/bin/sh` is a special case as it is required by the POSIX standard).

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

> Variable scoping: local variables inside functions vs global outside.

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

| Pattern | Matches |
|---------|---------|
| `*`     | Any string, including empty |
| `?`     | Any single character |
| `[abc]` | Any one of the listed characters |
| `[!abc]`| Any character not listed |

<!-- column: 1 -->
# Example:

```bash
# List all .txt files
ls *.txt

# List files starting with a or b
ls [ab]*.txt
```
  
<!-- end_slide -->

Word Splitting
===

<!-- column_layout: [3, 3] -->
<!-- column: 0 -->
```bash +exec
files="file1.txt file2.txt file3.txt"

# Unquoted: splits into words
for f in $files; do
    echo "File: $f"
done
```
  

<!-- column: 1 -->
```bash +exec
files="file1.txt file2.txt file3.txt"

# Quoted: treated as single string
for f in "$files"; do
    echo "File: $f"
done
```

<!-- reset_layout-->

<!-- pause -->
> Again, `shellcheck` to the rescue :)

<!-- end_slide -->


Error Handling
===

Bash scripts often need strict error handling:

```bash
#!/usr/bin/env bash
set -xeuo pipefail

# -x : show commands as executed
# -e : exit immediately on error
# -u : error on unset variables
# -o pipefail : pipeline fails if any command fails
```

This ensures predictable, safe scripts and easier debugging.

<!-- pause -->
> This could have saved Kyoto University multiple terabytes of valuable research data: https://www.youtube.com/watch?v=Nkm8BuMc4sQ
> 6:05 shows why the difference between `mv` and `cp` can be very important!

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
