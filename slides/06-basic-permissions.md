---
title: 'Introduction to Linux: **Basic Permissions**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

Users and Permissions
===

# Goal of this lecture

- Understand how to manage users/groups on Linux
- Understand how Linux handles permissions
- Understand potential security risks of wrong file permissions

# Why?

- In Linux "everything is a file", so we have to care about the files permission!

<!-- end_slide -->

Switching users
===

| Command | Description                       | Useful Flags / Examples               |
| ------- | --------------------------------- | ------------------------------------- |
| `su`    | Switch shell to another user      |                                       |
| `sudo`  | **Su**peruser **do**...           | `sudo mycommand` run command as root  |
|         | **S**ubstitute **u**ser **do**... | `sudo -i` open interactive root shell |
|         |                                   | `sudo -u sshd id`                     |

In most cases you will want to become the root user.

Many ways to elevate: `sudo -i`, `sudo su`, `su root`.

> Note: `su root` requires your root password while `sudo -i` requires your sudo password!

<!-- end_slide -->

Group Management
===

| Command                 | Description               | Useful Flags / Examples       |
| ----------------------- | ------------------------- | ----------------------------- |
| `id`                    | Show user/group IDs       |                               |
| `groups`                | Show groups you belong to |                               |
| `groupadd` / `groupdel` | Add/delete a group        | `groupadd --system groupname` |
| `groupmod`              | Modify a group            |                               |

<!-- pause -->

Each group is assigned a unique group ID (GID):

- `0`: The `root` group
- `1-999`: System groups
- `>=1000`: User groups

For more restrictions, see `grep GID /etc/login.defs` and `cat /proc/sys/kernel/ngroups_max`

<!-- end_slide -->

User Management
===

| Command               | Description                     | Useful Flags / Examples             |
| --------------------- | ------------------------------- | ----------------------------------- |
| `whoami`              | Show current user               |                                     |
| `who`                 | Show logged-in users            |                                     |
| `useradd` / `userdel` | Add/delete a user               | `useradd --no-create-home service`  |
| `usermod`             | Modify a user                   | `usermod -aG secondarygroup myuser` |
|                       | (Re-authenticate after changes) | `usermod -g primarygroup myuser`    |
| `adduser` / `deluser` | Add/delete a user interactively | Convenience wrappers                |

<!-- pause -->

Similar to group management: user ID (UID) `0` is `root`, `1-999` are system users and `>=1000` are regular users.

Further restrictions: `grep UID /etc/login.defs`

<!-- end_slide -->

Exercise
===

A simple recap:

1. Create user `foo`
2. Create group `bar`
3. Add user `foo` to group `bar`

<!-- end_slide -->

Storing User Information
===

There are multiple files storing information about users/groups. One example is the `/etc/passwd`:

<!-- column_layout: [3, 1] -->

<!-- column: 0 -->

```
alice:x:1000:1000:Alice:/home/alice:/bin/bash
```

Originally, the second field contained the hashed password, but for user ID lookups to work `/etc/passwd` must be readable by all users!

**Solution**: `/etc/shadow`, only readable by root.

<!-- column: 1 -->

| Field    | Value         |
| -------- | ------------- |
| Username | `alice`       |
| Password | x             |
| UID      | 1000          |
| GID      | 1000          |
| GECOS    | Alice         |
| Home     | `/home/alice` |
| Shell    | `/bin/bash`   |

<!-- reset_layout -->

<!-- pause -->

______________________________________________________________________

Group information is stored in `/etc/group` and `/etc/gshadow`. See also `man 5 shadow` / `man 5 group` / `man 5 passwd`.

Setting `/sbin/nologin` as the users default shell disabled login for a certain user (at least interactively).

**Advanced**: Try `sudo su daemon` vs `sudo -u daemon bash`.

<!-- end_slide -->

File Permissions & Ownership
===

Permissions control **who** can **read**, **write**, or **execute** files

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Each file/directory has permissions for:

- Owner (user)
- Group (collection of users)
- Other (everyone else)

<!-- column: 1 -->

Three basic permission types:

- `r` = read
- `w` = write
- `x` = execute (or enter directory)

<!-- end_slide -->

Permission Model
===

<!-- column_layout: [5, 3] -->

<!-- column: 0 -->

We already know how to display permissions. Now let's learn how to interpret them.

```bash
$ ls -l
-rwxr-xr--  1 alice staff 1234 Oct  5 10:00 script.sh
# perms links owner group size date & time  filename
```

<!-- column: 1 -->

# Understanding Permissions

What does `-rwxr-xr--` mean?

- First character:
  - `-` = file,
  - `d` = directory,
  - `l` = symlink
- Next 9 characters (permissions):
  - User (owner): `rwx`
  - Group: `r-x`
  - Other: `r--`

<!-- reset_layout -->

**Q**: Who has which permissions on the above script?

<!-- pause -->

- Owner (`alice`) can read, write, execute
- Group (`staff`) can read, execute
- Everyone else can only read

<!-- end_slide -->

Changing Permissions
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Symbolic Mode

- `+` -> add
- `-` -> remove
- `=` -> set exactly (replacing existing permissions)

```bash
# add execute for user
chmod u+x file.sh
# remove write for group
chmod g-w file.txt
# set read only for others
chmod o=r file.log
```

<!-- column: 1 -->

<!-- pause -->

# Numeric (Octal) Mode

Each permission is defined by a number:

`r=4`, `w=2`, `x=1`

Add them up to combine permissions:

`7=rwx`, `6=rw-`, `5=r-x`, `4=r--`, `3=-wx`, `2=-w-`, `1=--x`, `0=---`

```bash
# rwx for user, r-x for group, r-x for others
chmod 755 script.sh
# rw- for user, r-- for group & others
chmod 644 file.txt
```

<!-- reset_layout -->

<!-- pause -->

Think before use! Do not blindly use `chmod 777`!

<!-- end_slide -->

Special Permissions
===

<!-- column_layout: [3, 2] -->

<!-- column: 0 -->

- Setuid: run program as file owner instead of current user
  - Example: `/usr/bin/passwd` (runs as root)
  - Check yourself: `ls -l /usr/bin/passwd`
  - Risky -> use carefully!
- Setgid: run program with effective GID of the file's group
  - On directories: new files inherit group
- Sticky Bit: users can only delete or rename files if they own the file or directory
  - Common on `/tmp`

```bash
chmod 4755 program   # setuid
chmod 2775 shared/   # setgid on directory
chmod 1777 /tmp      # sticky bit
```

<!-- column: 1 -->

Special characters instead of `x`:

- Lowercase: Execute granted
- Uppercase: Execute not granted

| Permission   | Meaning               |
| ------------ | --------------------- |
| `-rwsr-xr-x` | User `s`: Setuid      |
| `-rwxr-sr-x` | Group `s`: Setgid     |
| `drwxr-sr-x` | Setgid directory      |
| `drwxrwxrwt` | Other `t`: Sticky bit |

<!-- end_slide -->

Managing File Permissions & Ownership
===

| Command | Description                      | Useful Flags / Examples                                        |
| ------- | -------------------------------- | -------------------------------------------------------------- |
| `ls`    | Show permissions and ownership   | `ls -l`, `ls -ln`                                              |
| `stat`  | Show file/directory details      | `stat -c '%a %n' file.txt`                                     |
| `chmod` | Change file permissions          | `chmod 644 file.txt`, `chmod +x script.sh`, `chmod -R 700 dir` |
| `chown` | Change owner/group               | `chown user:group file.txt`, `chown user -R directory`         |
| `umask` | Show/set default permission mask | `umask 0077` (default `0022`)                                  |

<!-- pause -->

`umask` explained:

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

```
          New File          New Directory
Default:  666  rw-rw-rw-    777  rwxrwxrwx
Umask:    022  ----w--w-    022  ----w--w-
          --------------    -----------
Result:   644  rw-r--r--    755  rwxr-xr-x
```

<!-- column: 1 -->

**Q**: What does `umask 0077` do?

<!-- pause -->

Newly created files can only be read and written by the owner.

> `umask` only affects the current session. If you want to keep a custom `umask`, add it to your `~/.bashrc`

<!-- end_slide -->

Exercise
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Create a file and experiment

- Show and change your `umask`
  - Create new files (e.g. `touch myfile`) and compare permissions for different `umask`s
- Change file ownership with `chown foo:bar myfile`
  - Check which permissions are still available to your user

<!-- column: 1 -->

# Use sticky directory

- The `/tmp` folder is created as sticky directory
  - `sudo mkdir /tmp`
  - `chmod 1777 /tmp`
- Try adding/removing files/directories as different users. Who can add/remove files?

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
