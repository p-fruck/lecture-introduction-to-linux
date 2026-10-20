---
title: 'Introduction to Linux: **Shell Basics**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

Shell Basics
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

Useful (scripting) tools
===

| Tool            | Description                                 | Example Command                 |
| --------------- | ------------------------------------------- | ------------------------------- |
| `sed`           | Manipulate text (in place)                  | `sed -i 's/old/new/g' file.txt` |
| `basename`      | Extracts the file name from a path.         | `basename /path/to/file.txt`    |
| `dirname`       | Extracts the directory part of a file path. | `dirname /path/to/file.txt`     |
| `sort` / `uniq` | Sorts lines and removes duplicate lines.    | `sort file.txt \| uniq`         |
| `base64`        | Encodes and decodes data in Base64 format.  | `echo "text" \| base64`         |
| `jq` / `yq`     | Parse and format JSON/YAML data.            | `cat file.json \| jq .`         |
| `yq`            | Parses and formats YAML data.               | `cat file.yml \| yq eval .`     |
| `date`          | Show/set system date and time.              | `date -d @1730502000`           |
| `time`          | Measure execution time of a command         | `time ls -l`                    |
| `diff/delta`    | Show difference between two files           | `delta first.txt second.txt`    |

<!-- pause -->

> If no `jq` is installed: `cat file.json | python3 -m json.tool` might help

<!-- pause -->

> ⚠️ `uniq` only works with sorted input, always use `<command> | sort | uniq` to avoid mistakes

<!-- end_slide -->

Exit Codes
===

On Linux, every command returns an **exit code** (`$?`) indicating success or failure.

An exit code is always in the range `0-255`.

Only 0 indicates success, every other exit code indicates a failure.

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

```bash +exec
true
echo Output of true: $?

false
echo Output of false: $?
```

<!-- column: 1 -->

<!-- pause -->

```bash
ls /tmp
echo "Exit code of ls: $?"

grep "foo" file.txt
echo "Exit code of grep: $?"
```

<!-- pause -->

> The `exit` command can be used to quit an interactive shell

> See `man errno` or `man sysexits.h` for common C exit codes

<!-- end_slide -->

Concatenating Commands
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

The POSIX standard allows chaining commands in multiple ways:

```bash +exec +id:chaining
# Sequential execution: commands runs regardless of result
false; echo Hello 1
true; echo Hello 2

# Conditional execution: run next only if previous succeeds
true && echo Hello 3

# Conditional execution: run next only if previous fails
false || echo Hello 4

# Run commands in sub-group
true && (false; echo Hello 5)
```

```bash  +exec +id:wc
# Command substition: Cat all files in current directory recursively
wc -l $(find . -type f)
```

<!-- column: 1 -->

<!-- snippet_output: chaining -->

<!-- snippet_output: wc -->

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

<!-- column: 1 -->

# File descriptor IDs

- `0` → stdin
- `1` → stdout
- `2` → stderr
- Custom FDs start at 3.

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

Pipes
===

<!-- column_layout: [2, 3] -->

<!-- column: 0 -->

The output of one command can be piped into another command to work with it (instead of a file):

```bash +exec
ls / | grep bin
```

<!-- pause -->

Pipes only capture stdin:

```bash +exec
ls /root/ | grep --only Perm
```

<!-- column: 1 -->

<!-- pause -->

File descriptors to the rescue!

```bash +exec
ls /root/ 2>&1 | grep --only Perm
```

<!-- pause -->

Infinite piping possible!

```bash
curl https://api.github.com/users/p-fruck/keys 2>/dev/null | jq .[0].key | tr -d '"' | ssh-keygen -lf -
```

> Note: `-f -` means `--file: stdin` and reads the input from the pipe

```bash
# spying on our students on the remote system
last | grep '^s26' | cut -d ' ' -f 1 | sort | uniq | wc -l
```

<!-- end_slide -->

Persisting Configuration
===

# How it works

- Previous settings like `alias` are set on per-session basis
- All shells support configuring persistent settings using configs
- On Bash: `~/.bash_profile` and `~/.bashrc` are used
  - They load further files from `~/.bashrc.d/*`
  - Other shells like ZSH provide e.g. `~/.zshrc`
- System-wide config is provided via `/etc/profile`, `/etc/bashrc` and `/etc/profile.d/*.sh`
- Config files are just shell scripts
- You can load them manually by running `source script.sh` or `. script.sh`

<!-- pause -->

## Differences

| Feature           | `~/.bash_profile` & `/etc/profile`     | `~/.bashrc` & `/etc/bashrc`              |
| ----------------- | -------------------------------------- | ---------------------------------------- |
| **Type of Shell** | Login shells                           | Non-login interactive shells             |
| **When executed** | At login (e.g., SSH, virtual terminal) | For every new interactive terminal       |
| **Common Use**    | Environment variables, session setup   | Aliases, functions, interactive settings |

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
