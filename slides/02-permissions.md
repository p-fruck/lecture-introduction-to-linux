---
title: "Introduction to Linux: **Users and Permissions**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
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

Exercise
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->
# Create a file and experiment:
  - `touch test.txt`
  - `chmod 644 test.txt`
  - `chmod u+x test.txt`

# Create a shared directory:
  - `mkdir shared`
  - `chmod 1777 shared`
  - Try adding/removing files as different users

<!-- column: 1 -->

# Check special permissions:
  - `ls -l /usr/bin/passwd`

💡 Always check with `ls -l` after changing permissions!

# Optional
  - Create a new user
  - Add it to a group

Check how the `/etc/shadow`, `/etc/passwd` and `/etc/groups` change!

<!-- reset_layout -->

<!-- column_layout: [1, 1, 1] -->
<!-- column: 1 -->
**Time: 10 minutes**

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
