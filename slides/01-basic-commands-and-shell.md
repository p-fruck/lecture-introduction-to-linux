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

Exercise 1
===

# Installation of `lf` (https://github.com/gokcehan/lf) within the Terminal

- Download latest `lf-linux-amd64.tar.gz` via wget/curl
- Extract the archive
- Copy `lf` binary to your user `PATH`
- Run `lf` to navigate your home directory

Time: 10 minutes

<!-- end_slide -->

Group Management
===

| Command                 | Description                | Useful Flags / Examples       |
| ----------------------- | -------------------------- | ----------------------------- |
| `id`                    | Show user/group IDs        |                               |
| `groups`                | Show groups you belong to  |                               |
| `groupadd` / `groupdel` | Add/delete a group         | `groupadd --system groupname` |
| `groupmod`              | Modify a group             |                               |

<!-- end_slide -->

User Management
===

| Command                 | Description                     | Useful Flags / Examples             |
| ----------------------- | ------------------------------- | ----------------------------------- |
| `whoami`                | Show current user               |                                     |
| `who`                   | Show logged-in users            |                                     |
| `useradd` / `userdel`   | Add/delete a user               | `useradd --no-create-home service`  |
| `usermod`               | Modify a user                   | `usermod -aG secondarygroup myuser` |
|                         | (Re-authenticate after changes) | `usermod -g primarygroup myuser`    |
| `adduser` / `deluser`   | Add/delete a user interactively | Convenience wrappers                |

> Relevant system files:
> `/etc/passwd`, `/etc/shadow`, `/etc/group`

<!-- end_slide -->

File Permissions & Ownership
===

- Linux permissions control **who** can **read**, **write**, or **execute** files
- Each file/directory has:
  - Owner (user)
  - Group (collection of users)
  - Other (everyone else)
- Three basic permission types:
  - `r` = read
  - `w` = write
  - `x` = execute (or enter directory)

<!-- end_slide -->

Permission Model
===

```bash
ls -l
-rwxr-xr--  1 alice staff 1234 Oct  5 10:00 script.sh
```

- First character: `-` = file, `d` = directory, `l` = symlink
- Next 9 characters -> permissions:
  - User (owner): `rwx`
  - Group: `r-x`
  - Other: `r--`
- Meaning:
  - Alice can read, write, execute
  - Staff group can read, execute
  - Everyone else can only read

<!-- end_slide -->

Changing Permissions
===

# Symbolic Mode

- `+` -> add
- `-` -> remove
- `=` -> set exactly (replacing existing permissions)

```bash
chmod u+x file.sh    # add execute for user
chmod g-w file.txt   # remove write for group
chmod o=r file.log   # set read only for others
```

# Numeric (Octal) Mode

- Each permission is defined by a number: `r=4`, `w=2`, `x=1`
- Add them up gives combined permissions:  `7=rwx`, `6=rw-`, `5=r-x`, `4=r--`, `3=-wx`, `2=-w-`, `1=--x`, `0=---`

```bash
chmod 755 script.sh  # rwx for user, r-x for group, r-x for others
chmod 644 file.txt   # rw- for user, r-- for group & others
```

<!-- end_slide -->

Special Permissions
===

- Setuid (s): run program as file owner
  - Example: `/usr/bin/passwd` (runs as root)
  - Risky -> should be minimal
- Setgid (s): run program with group's permissions
  - On directories: new files inherit group
- Sticky Bit (t): only owner can delete own files in directory
  - Common on `/tmp`

```bash
chmod 4755 program   # setuid
chmod 2775 shared/   # setgid on directory
chmod 1777 /tmp      # sticky bit
```

<!-- end_slide -->

Managing File Permissions & Ownership
===

| Command | Description                      | Useful Flags / Examples                    |
| ------- | -------------------------------- | ------------------------------------------ |
| `ls -l` | Show permissions and ownership   |                                            |
| `chmod` | Change file permissions          | `chmod 644 file.txt`, `chmod +x script.sh` |
| `chown` | Change owner                     | `chown user:group file.txt`                |
| `umask` | Show/set default permission mask | `umask 0077` (default `0022`)              |

Permissions refresher: `r`=read, `w`=write, `x`=execute, `r=4`, `w=2`, `x=1`

<!-- end_slide -->

Elevating Privileges
===
| Command             | Description                  | Useful Flags / Examples                   |
| ------------------- | ---------------------------- | ----------------------------------------- |
| `su`                | Switch shell to another user |                                           |
| `sudo` / `sudo-rs`  | Run command as root          | `sudo -i` open interactive root shell     |
|                     |                              | `sudo !!` runs the last command with sudo |
| `run0`              | Like `sudo` but uses Polkit  |                                           |

> The `/etc/sudoers` file contains the configuration and the behaviour of the `sudo` command
> Use `sudo visudo` to make changes (syntax check and lock of the sudoers file)

> `run0` allows enhanced system protection
> `run0 --property=ProtectSystem=strict --property=ReadWritePaths=/tmp touch /tmp/1`

<!-- end_slide -->

Exercise 2
===

# Create a file and experiment:
  - `touch test.txt`
  - `chmod 644 test.txt`
  - `chmod u+x test.txt`

# Create a shared directory:
  - `mkdir shared`
  - `chmod 1777 shared`
  - Try adding/removing files as different users

# Check special permissions:
  - `ls -l /usr/bin/passwd`

💡 Always check with `ls -l` after changing permissions!

Time: 10 minutes

<!-- end_slide -->

Other Handy Tools
===

| Command | Description                         | Useful Flags / Examples  |
| ------- | ----------------------------------- | ------------------------ |
| `date`  | Show/set system date and time       | `date +"%Y-%m-%d %H:%M"` |
| `time`  | Measure execution time of a command | `time ls -l`             |
| `echo`  | Print text or variables to terminal | echo "Hello, world!"     |

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
