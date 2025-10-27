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

Linux Capabilities
===

<!-- column_layout: [2, 1] -->
<!-- column: 0 -->

- **Problem**: `setuid root` gives full root privileges -> too powerful
- **Solution**: *Linux Capabilities* split root privileges into fine-grained pieces
  - Each process can get *only* the privileges it needs

| Example Capability     | What it Allows                            |
| ---------------------- | ----------------------------------------- |
| `CAP_NET_ADMIN`        | Manage network interfaces, routing tables |
| `CAP_SYS_ADMIN`        | "Catch-all" - system-wide administration  |
| `CAP_DAC_OVERRIDE`     | Bypass file read/write permission checks  |
| `CAP_SYS_TIME`         | Change the system clock                   |
| `CAP_NET_BIND_SERVICE` | Bind to ports < 1024                      |

<!-- column: 1 -->

View capabilities:
```bash
getcap /usr/bin/arping
```

Set or remove capabilities:
```bash
sudo setcap cap_net_raw+ep /usr/bin/arping
```

<!-- reset_layout -->

- Revocation limitation
  - Once a process has a capability, the kernel cannot revoke it mid-execution
  - You must terminate or restart the process to remove privileges

<!-- end_slide -->

Access Control Lists (ACLs)
===

- **Problem**: Traditional permissions only allow control for *owner*, *group*, *others*
- **Solution**: Access Control Lists (ACLs) let you define per-user or per-group permissions

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

```bash
# Show ACLs
getfacl secret.txt

# Add a new user permission
setfacl -m u:bob:r secret.txt

# Remove an ACL entry
setfacl -x u:bob secret.txt
```

<!-- column: 1 -->

```bash
# file: secret.txt
# owner: alice
# group: staff
user::rw-
user:bob:r--
group::r--
mask::r--
other::---
```

<!-- reset_layout -->

- **Default ACLs**: can be set on directories to apply to new files inside

```bash
setfacl -d -m u:bob:rw project/
```

💡 ACLs offer fine-grained control -> especially useful for multi-user servers.

<!-- pause -->

> More about Linux Capabilities and ACLs: https://media.ccc.de/v/why2025-192-linux-permissions-and-hardening

<!-- end_slide -->

Exercise
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

# Capabilities

Let's use `/usr/bin/tar` as an example:

1. Check if it currently has any capabilities
2. Give it a test capability (`CAP_DAC_READ_SEARCH`)
```bash
sudo setcap cap_dac_read_search+ep /usr/bin/tar
getcap /usr/bin/tar
```
3. Try reading a file you normally couldn't (as non-root)
```bash
tar -cvf /tmp/test.tar /tmp/rootfile.txt
```
4. ⚠️ **Important**: Remove the capability again with `sudo setcap -r /usr/bin/tar`
5. What could go wrong if tools like `tar` permanently kept this capability?

<!-- column: 1 -->

# Access Control Lists

1. Create a file and set restrictive permissions
```bash
touch project.txt
chmod 600 project.txt
```
2. Add read access for another user (replace `<user>`)
```bash
sudo setfacl -m u:<user>:r project.txt
getfacl project.txt
```
3. Verify that `<user>` can now read the file even though group/others cannot.
4. Remove the ACL entry again
```bash
sudo setfacl -x u:<user> project.txt
```

<!-- reset_layout -->

<!-- column_layout: [1, 1, 1] -->
<!-- column: 1 -->

**Time: 15 minutes**

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
