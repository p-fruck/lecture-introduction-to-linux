---
title: 'Introduction to Linux: **Scripting in Practice**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

Scripting
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# Goal of this lecture

- Learn practical scripting pitfalls and best practices
- Get familiar with editors and process/job control

# Why?

- Real-world scripts must handle errors and edge cases safely
- Editors and job control are daily tools for any Linux user

<!-- column: 1 -->

# Use Cases:

- Writing robust, production-ready scripts
- Managing long-running or background tasks
- Editing files directly on remote servers

<!-- end_slide -->

Functions in Bash
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

# Functions allow reusable blocks of code

- Functions improve code clarity and reduce repetition.
- Parameters passed to a function or script are accessed via `$1`, `$2`, ...
  - `$0` is the invoked executable (remember C's `argv[0]`?)
  - `$#` shows the parameter count
  - `$@` shows all parameters
  - `shift` drops the first n parameters (by default 1)

```sh +exec
#!/bin/sh
myfunc() {
    echo "Hello from $0"
    echo "$# args: $@"
    echo "First: $1" ; shift ; echo "New first: $1"
}
myfunc foo bar
```

<!-- column: 1 -->

<!-- pause -->

```bash {3-10|13-17|1-99} +exec +line_numbers
#!/usr/bin/env bash

# the function keyword only exists in bash
function add() {
    echo $(( $1 + $2 ))
}

# Functions can return plaintext
sum=$(add 3 5)
echo "Sum = $sum"

# And functions can return status codes
check_file() {
    [ -f "$1" ]
}

check_file ../README.md && echo Exists!
```

<!-- end_slide -->

Loops: for and while
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# POSIX for loop

```sh +exec
# Iterate over numbers
for i in 0 1 2 3 4 5 6 7 8 9 10; do
    echo -n "$i "
done
echo
# Loop over files (pipe output into head)
for file in *.md; do
    echo "File: $file"
done | head -n 5
```

<!-- column: 1 -->

<!-- pause -->

# Bash set notation

While not strictly related to for loops `bash` also supports set notation:

```bash +exec
echo {1..10}
echo {A..C}{1..3}
for i in {1..10}; do echo -n $i,; done
```

<!-- pause -->

<!-- end_slide -->

While Loop
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# POSIX compliant

```sh +exec
#!/bin/sh
counter=1
while [ $counter -le 5 ]; do
    echo "Count $counter"
    counter=$((counter+1))
done
```

<!-- column: 1 -->

# Bash specific

```bash +exec
#!/usr/bin/env bash
counter=1
while (( counter <= 5 )); do
    echo "Count $counter"
    ((counter++))
done
```

<!-- end_slide -->

Word Splitting
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

```sh +exec
files="file1.txt file2.txt file3.txt"

# Unquoted: splits into words
for f in $files; do
    echo "File: $f"
done
```

<!-- column: 1 -->

<!-- pause -->

```sh +exec
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

Shell scripts often need strict error handling:

<!-- column_layout: [2, 3] -->

<!-- column: 0 -->

```bash
#!/usr/bin/env bash
set -xeuo pipefail
```

This ensures predictable, safe scripts and easier debugging.

<!-- column: 1 -->

- `-x` : optional: show commands as e**x**ecuted, great for pipelines, debugging, ...
  - Uses `PS4` environment variable as prompt
- `-e` : **e**xit immediately on error
- `-u` : error on **u**nset variables
- `-o pipefail` : **pipe**line **fail**s if any command in the chain fails
  - only exists in bash and newer versions of POSIX

<!-- reset_layout-->

<!-- pause -->

> This could have saved Kyoto University multiple terabytes of valuable research data: https://www.youtube.com/watch?v=Nkm8BuMc4sQ
> 6:05 shows why the difference between `mv` and `cp` can be very important!

<!-- end_slide -->

TODO
===

- Useful commands:
  - `read` (`-p`) for interactive stuff
  - Tempfiles with `mktmp`
  - `trap`?? -> For Trap, explain signals first (dedicated slides, reference Ctrl+C)
  - `env` command -> should be in variables section (last slide) already
  - Show use of `eval` -> Note that `eval` is evil

<!-- end_slide -->

Processes and Job Control
===

# Key Commands

| Command  | Description                              | Example Usage                          |
| -------- | ---------------------------------------- | -------------------------------------- |
| `&`      | Run a command in the background          | `./long_running_command &`             |
| `Ctrl+Z` | Pause (suspend) a running process        | Press `Ctrl+Z` while running a command |
| `bg`     | Move a stopped job to the background     | `bg %1` (background job 1)             |
| `fg`     | Bring a background job to the foreground | `fg %3` (foreground job 3)             |
| `jobs`   | List all background jobs                 | `jobs`                                 |

# Examples

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

```bash
# Run a command in the background
$ long_running_task &
[1] 12345  # Job 1, PID 12345

# Suspend the process with Ctrl+Z
$ ^Z
[2]+ Stopped              long_running_task

# list background jobs
$ jobs
[1]-  Running                    long_running_task
[2]+  Stopped                    long_running_task
```

<!-- column: 1 -->

```bash
# Move the suspended process to the background
$ bg
[1]+ 12345 long_running_task &

# Bring the process to the foreground
$ fg
long_running_task

# Bring the second background process in the foreground
$ fg %3
other_task
```

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
