---
title: "Introduction to Linux: **Scripting in Practice**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
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

Editors
===

<!-- column_layout: [3, 3] -->
<!-- column: 0 -->

## Basics
- Instead of graphical tools like VSCode, we can also use text-based editors
- Today, `nano` and `vim` are the most common editors
- `nano` is a bit simpler and shows the required keyboard shortcuts
- `vim` is more advanced and allows faster editing, but is more complex!
    - Command driven: `:wq` to **w**rite and **q**uit
    - Use `/` to search (like in less)
    - Press `i` for insert mode, `v` for visual mode, `ESC` to go back to regular mode

<!-- column: 1 -->
![image:width:100%](../assets/exit-vim.png)
<!-- reset_layout -->
# Advanced
- Nowadays, there are more modern editors that support the Language Server Protocol (LSP)
  - If you want a really advanced text editor, have a look at `helix` or `neovim`

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
Useful (scripting) tools
===

| Tool           | Description                                | Example Command|
|----------------|--------------------------------------------|-----------------------------|
| `sed`          | Manipulate text (in place)                 | `sed -i 's/old/new/g' file.txt`|
| `basename`     | Extracts the file name from a path.        | `basename /path/to/file.txt`|
| `dirname`      | Extracts the directory part of a file path.| `dirname /path/to/file.txt` |
| `sort` / `uniq`| Sorts lines and removes duplicate lines.   | `sort file.txt \| uniq`     |
| `base64`       | Encodes and decodes data in Base64 format. | `echo "text" \| base64`     |
| `jq` / `yq`    | Parse and format JSON/YAML data.           | `cat file.json \| jq .`     |
| `yq`           | Parses and formats YAML data.              | `cat file.yml \| yq eval .` |
| `date`         | Show/set system date and time.             | `date -d @1730502000`       |
| `time`         | Measure execution time of a command        | `time ls -l`                |
| `diff/delta`   | Show difference between two files          | `delta first.txt second.txt`|

> If no `jq` is installed: `cat file.json | python3 -m json.tool` might help

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
