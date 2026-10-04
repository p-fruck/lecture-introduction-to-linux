---
title: 'Introduction to Linux: **Core Commands**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
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
| `echo`  | Print given arguments or variables          | `echo $PATH`, `echo -n text without newline`                        |
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

| Command   | Description                         | Useful Flags / Examples |
| --------- | ----------------------------------- | ----------------------- |
| `history` | Show command history                | `!42` rerun command #42 |
| `!!`      | Run the same command again          |                         |
| key: `↑`  | Select last commands                |                         |
| key: `⇥`  | Autocomplete command/directory/file |                         |
| key: `^r` | Reverse Search                      |                         |

> `^r` is the terminal notation for Ctrl+r

<!-- end_slide -->

Utilities
===

| Command   | Description                              | Useful Flags / Examples |
| --------- | ---------------------------------------- | ----------------------- |
| `man`     | Show **man**ual pages                    | `man ls`                |
| `tldr`    | Shorter command descriptions             | `tldr ls`               |
|           | (**t**oo **l**ong **d**idn't **r**ead)   |                         |
| `alias`   | Define shortcuts                         | `alias ll="ls -l"`      |
| `unalias` | Removes defined shortcuts                | `unalias ll`            |
| `command` | Executes a command without aliases, etc. | `command ls`            |
| `watch`   | Repeat a command periodically            | `watch -n .5 ls -l`     |

> `watch` cannot resolve aliases
> To fix: `alias watch="watch "` or `watch -n .5 bash -ic ls`

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
