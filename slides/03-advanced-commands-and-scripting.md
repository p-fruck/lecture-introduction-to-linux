---
title: "Introduction to Linux: **Advanced Commands**"
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
- ssh-keygen (add form to collect pubkeys for vm)
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
