---
title: 'Introduction to Linux: **Scripting**'
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

Asking for Input
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

Besides parameters, scripts can also ask the user questions at runtime:

```bash
#!/usr/bin/env bash
read -r -p "Your name: " name
echo "Hello, $name!"
```

<!-- column: 1 -->

<!-- pause -->

`read` stores a line of input in a variable:

- `-p` : show a **p**rompt
- `-r` : **r**aw, do not interpret backslashes (almost always what you want)
- `-s` : **s**ilent, do not echo the input (e.g., for passwords)

<!-- end_slide -->

for Loop
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

Playing with Fire: Strings as Code
===

`eval` takes a string and executes it as a shell command:

```bash +exec
cmd="echo Hello from eval"
eval "$cmd"
```

<!-- pause -->

Imagine a script that asks for an IP address and pings it. Everything in the string is interpreted, including things you did not intend:

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

```bash +exec
# Intended use
ip="127.0.0.1"
eval "ping -c 1 -q $ip"
```

<!-- column: 1 -->

<!-- pause -->

```bash +exec
# "Creative" user input
ip="127.0.0.1; whoami; hostname"
eval "ping -c 1 -q $ip"
```

<!-- reset_layout-->

<!-- pause -->

> eval is evil!

- Never use `eval` with user input or any data you do not fully control
- In most cases there is a safer alternative (arrays, functions, `"$@"`, ...)

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

Temporary Files
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

Scripts often need a place for intermediate results. `mktemp` creates one safely:

```bash +exec
tmp=$(mktemp)
echo "scratch data" > "$tmp"
echo "Created $tmp"
cat "$tmp"
rm "$tmp"
```

<!-- column: 1 -->

<!-- pause -->

- Creates a file with a unique, unpredictable name (default in `/tmp`)
- `mktemp -d` creates a temporary **d**irectory
- Never hardcode names like `/tmp/myscript.tmp`: collisions and security issues
- Remember to clean up afterwards, more on that in a moment

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

Signals
===

Signals are small messages the kernel (or other processes) send to a process.

When you press `Ctrl+C` or `Ctrl+Z`, the terminal sends a signal to the running process.

| Signal    | Nr. | Typical trigger / use                   | Default action              |
| --------- | --- | --------------------------------------- | --------------------------- |
| `SIGINT`  | 2   | `Ctrl+C`                                | Terminate                   |
| `SIGTSTP` | 20  | `Ctrl+Z` (used by job control)          | Stop (suspend)              |
| `SIGCONT` | 18  | `bg` / `fg`                             | Continue a stopped process  |
| `SIGHUP`  | 1   | Terminal was closed                     | Terminate                   |
| `SIGTERM` | 15  | `kill PID` (default), polite "please quit" | Terminate                |
| `SIGKILL` | 9   | `kill -9 PID`                           | Terminate, cannot be caught |

<!-- pause -->

```bash
$ kill -l            # list all signals
$ kill -TERM 12345   # ask process 12345 to terminate
$ kill -9 12345      # force kill, process gets no chance to clean up
```

<!-- end_slide -->

Cleaning Up on Exit
===

`trap` runs a command when the shell receives a signal, so a script can react to e.g., `Ctrl+C`:

```bash +exec
#!/usr/bin/env bash
tmp=$(mktemp)

# EXIT: special pseudo-signal, runs whenever the script ends
trap 'echo "Cleaning up $tmp"; rm -f "$tmp"' EXIT
# INT: Ctrl+C
trap 'echo "Interrupted!"; exit 130' INT

echo "working..." > "$tmp"
cat "$tmp"
```

<!-- pause -->

- Typical use: remove temporary files, release locks, stop child processes
- `SIGKILL` (and `SIGSTOP`) cannot be trapped
- `trap - INT` resets a trap to the default behaviour

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
