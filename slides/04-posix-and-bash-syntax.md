---
title: 'Introduction to Linux: **POSIX and Bash Syntax**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
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

POSIX vs Bash
===

POSIX is a standard, Bash is a shell implementation

- `/bin/sh` -> POSIX-compliant shell
- `/bin/bash` -> Bash-specific features, not always POSIX

<!-- pause -->

> On Fedora, `/bin/sh` is a symlink to `/bin/bash`, but other distros like Debian ship more minimal shells like `dash`

<!-- pause -->

**POSIX standard includes:**

- Standard shell syntax (`if`, `while`, `for`, `case`)
- Conditionals (`[ ... ]`, with `=`, `-f`, `-n`, etc.)
- Variables and expansions
- Redirection
- Command substitution

<!-- pause -->

Bash adds arrays, enhanced conditionals (`[[ ... ]]`) and some more syntax.

<!-- pause -->

> The `shellcheck` utility allows linting your shell script.
> It determines the correct shell syntax using the **shebang**.

<!-- end_slide -->

Shebang
===

<!-- column_layout: [4, 2] -->

<!-- column: 0 -->

# How-to

- The **shebang** line tells the system *which interpreter* should execute the script.
- Must appear as the first line of the script
- Starts with `#!` followed by the interpreter path
- Allows running `./script` instead of `bash ./script`
  - Ensures correct interpreter is used even if no file extension is present
  - Don't forget to `chmod +x ./script` (details in the permissions lecture)

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

<!-- pause -->

> 💡 Tip: Using `/usr/bin/env` makes your script more portable across systems (`/bin/sh` is a special case as it is required by the POSIX standard). Use of `#!/bin/bash`, `#!/usr/bin/python` etc. is discouraged.

> More advanced: Watch the first minutes of https://media.ccc.de/v/all-systems-go-2026-440-binfmtbpf (especially p. 13-14)

<!-- end_slide -->

POSIX Variables
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

```bash {1-3|5-7|10|12-14} +line_numbers
# Assign a variable. Use quotes to include spaces
name=Alice
fullname="Bob the builder"

# Use a variable with $ or use brackets to define the start and end of variables
echo "Hello $name"
echo "${name}.lastname@example.com"

# Read-only
readonly pi=3.14

# Per command vs global environment variables
foo=bar mylocalscript
export PATH="/usr/local/bin:$PATH"
```

> Note: Every variable is a string

> Be careful with special variables like `PATH` and `PS1`

<!-- pause -->

<!-- column: 1 -->

```sh +exec +line_numbers
readonly name=Bob
fullname="$name the builder"
# Variables are replaced in double quotes
echo "Fullname: $fullname"
# But not in single quotes:
message='$name is a nice name!'
echo $message
# readonly cannot be changed
name="Beep 🤖"
```

<!-- reset_layout -->

<!-- pause -->

> Variable scoping: local variables inside functions vs global outside.

> Using `export` allows variables to be used by other processes launched from the current session.

<!-- end_slide -->

POSIX Conditionals
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# If-else logic

The `if` statement runs commands conditionally based on exit status. Do not forget spaces around `[` and `]`.

```bash
# hint: Do not use this in prod :)
if [ "$USER" = "root" ]; then
    echo "Welcome, root user!"
elif [ "$USER" = "admin" ]; then
    echo "Hello, admin."
else
    echo "Access denied."
fi

# negation works with != or ! in beginning
if [ ! "$USER" = "root" ]; then echo "No!"; fi
if ! grep MyText myfile.txt; then echo Nope; fi
```

<!-- pause -->

Concatenation (`if ...; then` is optional)

```bash
[ "$USER" = "root" ] || [ "$USER" = "admin" ] && echo "Woohoo"
```

<!-- column: 1 -->

<!-- pause -->

# Common test conditions

| Operator | Meaning                       | Example             |
| -------- | ----------------------------- | ------------------- |
| `-e`     | Path exists                   | `[ -e "$file" ]`    |
| `-f`     | Regular file exists           | `[ -f "$file" ]`    |
| `-d`     | Directory exists              | `[ -d "$dir" ]`     |
| `-r`     | Path is readable              | `[ -r "$file" ]`    |
| `-w`     | Path is writable              | `[ -w "$file" ]`    |
| `-x`     | Path is executable/searchable | `[ -x "$file" ]`    |
| `-s`     | File exists and is non-empty  | `[ -s "$file" ]`    |
| `-L`     | Path is a symbolic link       | `[ -L "$file" ]`    |
| `-z`     | String is empty               | `[ -z "$var" ]`     |
| `-n`     | String is non-empty           | `[ -n "$var" ]`     |
| `=`      | Strings are equal             | `[ "$a" = "$b" ]`   |
| `!=`     | Strings are different         | `[ "$a" != "$b" ]`  |
| `-eq`    | Integers are equal            | `[ "$a" -eq "$b" ]` |
| `-ne`    | Integers are not equal        | `[ "$a" -ne "$b" ]` |
| `-lt`    | Less than                     | `[ "$a" -lt "$b" ]` |
| `-le`    | Less than or equal            | `[ "$a" -le "$b" ]` |
| `-gt`    | Greater than                  | `[ "$a" -gt "$b" ]` |
| `-ge`    | Greater than or equal         | `[ "$a" -ge "$b" ]` |

See `man test` for more details

Instead of a test condition, you can also just check the return code of any command

<!-- end_slide -->

Bash-Specific Conditionals
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

# Safer comparison

Bash's `[[ ... ]]` supports safer string comparisons (`==`) that prevent word splitting or path name expansion and logical operators.

```bash
if [[ "$USER" == "root" ]]; then
    echo "Welcome, root user!"
elif [[ "$USER" == admin* ]]; then
    echo "Hello, admin."
else
    echo "Access denied."
fi

[[ "$USER" != "admin" ]] && echo "no!"
```

<!-- pause -->

Combine tests using `&&` and `||`:

```bash
if [[ -f "$file" && -r "$file" ]]; then
    echo "File exists and is readable."
fi
```

<!-- column: 1 -->

<!-- pause -->

## Regex matching

Use `=~` to match a POSIX extended regular expression (`man 7 regex`).

`BASH_REMATCH` is an array: `[0]` holds the whole match, `[1]`, `[2]`, ... the capture groups.

```bash +exec
input=abc123
if [[ "$input" =~ [0-9]+ ]]; then
    echo "Found number: $BASH_REMATCH"
else
    echo "Invalid input."
fi
```

<!-- end_slide -->

Arithmetic
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

# Bash

Bash supports `(( ... ))` for arithmetic comparisons.

A nonzero arithmetic result means success.

```bash +exec
count="50"
if (( count > 10 && count < 100 )); then
    echo "Count is in range."
fi

if (( count % 2 == 0 )); then
    echo "Even number."
fi

((count++))
echo Count: $count

(( "1" > 2 )) || echo false
```

<!-- pause -->

<!-- column: 1 -->

# POSIX

POSIX only supports arithmetic via `$(( ... ))`.

Results are passed as string (no exit code).

```sh +exec
# in POSIX, numbers must not be quoted!
echo $(( 1 + 2 ))
echo -n $(( 1 > 2 )) && echo '->yes'
echo -n $(( 1 < 2 )) && echo '->yes'

counter=0
# POSIX-compliant increment
counter=$(( counter + 1 ))
echo Counter: $counter
```

> ❓ How do we check `$(( 1 > 2 ))` in POSIX?

<!-- reset_layout -->

<!-- end_slide -->

Selections
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# POSIX Case statement

`case` compares a value against multiple patterns

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

<!-- column: 1 -->

<!-- pause -->

# Bash Select

```bash
select choice in "foo" "bar" "foobar"; do
    echo "choice: $choice, reply: $REPLY"
    break
done
```

<!-- pause -->

## Combining select and case

```bash
PS3="Choose an option: "
select choice in "Date" "List" "Quit"; do
    case $REPLY in
        1) date ;;
        2) ls -l ;;
        3) echo "Goodbye!"; break ;;
        *) echo "Invalid choice." ;;
    esac
done
```

> `select` uses `PS3` instead of `PS1`.

<!--     reset_layout -->

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
