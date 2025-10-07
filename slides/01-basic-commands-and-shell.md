---
title: "Introduction to Linux: **Basic Commands and Shell**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

Coreutils & Command-Line Tools
===

# Goal of this lecture
  - Learn the basic Linux command-line tools
  - Understand what they do and when to use them
  - Practice with useful flags

# Why?
  - Mastering the CLI -> faster, more precise, automatable workflows
  - Essential for sysadmin, security, development work (and the upcoming semesters)

<!-- end_slide -->

Navigating the File System
===

| Command | Description                                 | Useful Flags / Examples                                             |
| ------- | ------------------------------------------- | ------------------------------------------------------------------- |
| `pwd`   | **P**rint current **w**orking **d**irectory |                                                                     |
| `ls`    | **L**i**s**t directory contents             | `-l` long format, `-a` show hidden files, `-h` human-readable sizes |
| `cd`    | **C**hange **d**irectory                    | `cd -` go back to previous directory                                |
| `tree`  | Show directory structure                    | `-L 2` limit depth, `-a` show hidden files                          |

💡 Paths can be chained :)

<!-- pause -->

> `ranger`, `lf`, `mc`, `yazi` are terminal file managers

<!-- end_slide -->

File Manipulation
===

| Command | Description                          | Useful Flags / Examples                              |
| ------- | ------------------------------------ | ---------------------------------------------------- |
| `cp`    | **C**o**p**y files/directories       | `-r` recursive, `-i` interactive (confirm overwrite) |
| `mv`    | **M**o**v**e/rename files            | `-i` confirm overwrite                               |
| `rm`    | **R**e**m**ove files                 | `-r` recursive, `-i` confirm, `-f` force             |
| `mkdir` | Create (**m**a**k**e) **dir**ectory  | `-p` create parent dirs if missing                   |
| `touch` | Create empty file / update timestamp |                                                      |

⚠️ **Danger Zone:** `rm -rf /` will erase **everything** - don't run this!

<!-- end_slide -->

Improve Your Workflow
===

| Command   | Description                              | Useful Flags / Examples  |
| --------- | ---------------------------------------- | ------------------------ |
| `history` | Show command history                     | `!42` rerun command #42  |
| `!!`      | Run the same command again               |                          |
| key: `↑`  | Select last commands                     |                          |
| key: `⇥`  | Autocomplete command/directory/file      |                          |
| key: `^r` | Reverse Search                           |                          |

> `^r` is the terminal notation for Ctrl+r

<!-- end_slide -->

Utilities
===

| Command   | Description                              | Useful Flags / Examples  |
| --------- | ---------------------------------------- | ------------------------ |
| `man`     | Show **man**ual pages                    | `man ls`                 |
| `tldr`    | Shorter command descriptions             | `tldr ls`                |
|           | (**t**oo **l**ong **d**idn't **r**ead)   |                          |
| `alias`   | Define shortcuts                         | `alias ll="ls -l"`       |
| `unalias` | Removes defined shortcuts                | `unalias ll`             |
| `command` | Executes a command without aliases, etc. | `command ls`             |
| `watch`   | Repeat a command periodically            | `watch -n .5 ls -l`      |

> `watch` cannot resolve aliases
> To fix: `alias watch="watch "` or `watch -n .5 bash -ic ls`

<!-- end_slide -->

Viewing Files
===

| Command | Description                      | Useful Flags / Examples                         |
| ------- | -------------------------------- | ----------------------------------------------- |
| `cat`   | Show file contents               | `cat file.txt`                                  |
| `tac`   | Reverse `cat`                    | `tac file.txt`                                  |
| `less`  | View file page by page           | `/text` search forward, `?text` search backward |
| `more`  | More primitive pager than `less` |                                                 |
| `head`  | Show first lines of file         | `-n 20` show first 20 lines                     |
| `tail`  | Show last lines of file          | `-f` follow file (useful for logs)              |
| `wc`    | Count lines, words, or bytes     | `-l` lines, `-w` words, `-c` characters         |

<!-- end_slide -->

Finding Files & Text
===

| Command   | Description                     | Useful Flags / Examples                   |
| --------- | ------------------------------- | ----------------------------------------- |
| `find`    | Search for files                | `find /etc -type f -name "*.conf"`        |
| `locate`  | Search files via prebuilt index | `updatedb` updates index                  |
| `grep`    | Search inside files             | `-i` ignore case, `-r` recursive,         |
|           |                                 | `-n` show line numbers, `-v` invert match |
| `ripgrep` | Recursive `grep` on steroids :) | `rg -i searchterm`                        |
| `which`   | Show full path of command       | `which ls`                                |
| `fzf`     | Interactive fuzzy search        |                                           |

<!-- end_slide -->

System Info
===

| Command        | Description                   | Useful Flags / Examples              |
| -------------- | ----------------------------- | ------------------------------------ |
| `uname`        | Show system info              | `-a` all details                     |
| `uptime`       | Show uptime & load average    |                                      |
| `lsblk`        | List block devices            | `--fs` shows file system type        |
| `df`           | Show disk usage               | `-h` human-readable sizes            |
| `du`           | Show space used by files/dirs | `-sh` summarize directory size       |
| `free`         | Show memory usage             | `-h` human-readable                  |
| `ps`           | Show process informations     | `ps aux` lists all running processes |
| `top` / `htop` | Show running processes        | Interactive tools                    |

<!-- pause -->

> `btop` and bottom (`btm`) are advanced terminal task managers

> "Mission Center" is a great GUI app!

<!-- end_slide -->

Archiving & Compression
===

| Command             | Description         | Useful Flags / Examples                                                           |
| ------------------- | ------------------- | --------------------------------------------------------------------------------- |
| `tar`               | Archive files       | `tar -czvf file.tar.gz dir/` (**c**reate + g**z**ip + ***v***erbose + ***f***ile) |
|                     |                     | `tar -xzvf file.tar.gz` (e**x**tract + g**z**ip + ***v***erbose + ***f***ile)     |
| `gzip` / `gunzip`   | Compress/decompress | `gunzip --keep archive.gz`                                                        |
| `bzip2` / `bunzip2` | Compress/decompress | `bunzip2 --keep archive.bz2`                                                      |
| `xz` / `unxz`       | Compress/decompress | `unxz --keep archive.xz`                                                          |
| `zip` / `unzip`     | Compress/decompress | `unzip archive.zip`                                                               |

<!-- pause -->

![xkcd 1168](../assets/xkdc-1168.png)

> https://xkcd.com/1168/

<!-- end_slide -->

Networking Basics
===

| Command              | Description               | Useful Flags / Examples                 |
| -------------------- | ------------------------- | --------------------------------------- |
| `ping`               | Test connectivity         | `ping -c 4 dhbw.de`                     |
| `mtr` / `traceroute` | Print route packets trace | `mtr dhbw.de`                           |
| `curl`               | Transfer data from URLs   | `-I` headers only, `-L` follow redirect |
|                      |                           | `-X` change HTTP method, `-O` save file |
| `wget`               | Download files from web   | `-r` recursive download                 |
| `ss` / `netstat`     | Show network connections  | `ss -tulpn` show listening ports        |
| `dig` / `nslookup`   | DNS queries               | `dig A example.com`                     |

<!-- end_slide -->

Exercise
===

# Installation of `lf` (https://github.com/gokcehan/lf) within the Terminal

- Download latest `lf-linux-amd64.tar.gz` via wget/curl
- Extract the archive
- Copy `lf` binary to your user `PATH`
- Run `lf` to navigate your home directory

Time: 10 minutes

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
