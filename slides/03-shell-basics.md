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

Pipes
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

The output of one command can be piped into another command to work with it (instead of a file):

```bash +exec
ls / | grep --only root
```

<!-- column: 1 -->

<!-- pause -->

Pipes only capture stdin:

```bash +exec
ls /root/ | grep --only Perm
```

<!-- pause -->

File descriptors to the rescue!

```bash +exec
ls /root/ 2>&1 | grep --only Perm
```

<!-- pause -->

<!-- reset_layout -->

Infinite piping possible!

```bash
curl https://api.github.com/users/p-fruck/keys 2>/dev/null | jq .[0].key | tr -d '"' | ssh-keygen -lf -
```

> Note: `-f -` means `--file: stdin` and reads the input from the pipe

<!-- end_slide -->

Persisting Configuration
===

## How it works

- Previous settings (`alias`, `umask`, etc.) are set on per-session basis
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

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
