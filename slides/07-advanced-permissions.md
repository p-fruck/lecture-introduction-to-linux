---
title: 'Introduction to Linux: **Advanced Permissions**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

Advanced Permissions
===

# Goal of this lecture

- Learn how to safely elevate privileges
- Understand fine-grained access control beyond classic permissions (ACLs)
- Understand Linux capabilities as a safer alternative to full root access

# Why?

- Classic permissions are often not granular enough
- Minimizing granted privileges reduces the security impact of bugs and exploits

<!-- end_slide -->

sudo
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Security

- `sudo` is typically a setuid root binary
- Runs with effective UID 0, regardless of the invoking user's privileges
- Part of the system's trusted computing base
- Vulnerabilities can lead to local privilege escalation
- Overly permissive rules can effectively grant unrestricted root access

<!-- column: 1 -->

<!-- pause -->

# Configuration

- `/etc/sudoers` and `/etc/sudoers.d/`
- Defines who can execute what, as which user
- `visudo`: syntax checking and file locking
  - Use `sudo visudo` when editing!

```sh
# who  where=(as_whom:as_group)  options: cmd
# Allow wheel group to execute any command
%wheel  ALL=(ALL:ALL) ALL
# Allow command execution without password
%wheel  ALL=(ALL:ALL) NOPASSWD: ALL
```

<!-- reset_layout-->

<!-- pause -->

<!-- column_layout: [5, 3] -->

<!-- column: 0 -->

`sudo-rs`: Rust implementation of sudo

- Memory safety reduces certain risks, but does not eliminate privilege-escalation risk
- Shipped by Ubuntu by default as of 25.10 / 26.04 LTS
- Not 1:1 compatible with original `sudo`!

<!-- column: 1 -->

<!-- pause -->

**Q**: Which permission does this rule grant? `ALL=(ALL:ALL) /usr/bin/vim /etc/groups`

<!-- pause -->

- Read and write the file as root
- But also: shell via `:sh`
  - ⚠️ Privilege escalation

<!-- end_slide -->

run0
===

`run0` is the systemd (>=256) native privilege escalation tool. It uses `polkit` instead of `setuid`.

<!-- column_layout: [1, 1] -->

<!-- pause -->

<!-- column: 0 -->

# Basic usage

Similar to `sudo`, but you might need `--via-shell`

```sh
run0 id
run0 -u daemon id
run0 printenv PATH
run0 --via-shell printenv PATH
```

<!-- column: 1 -->

<!-- pause -->

# Sandboxing

```sh
# read-only except /tmp
run0 --property=ProtectSystem=strict \
    --property=ReadWritePaths=/tmp \
    touch /tmp/1
# Hide /home
run0 --property=ProtectHome=true ls /home
cd /tmp && !!
```

<!-- reset_layout -->

<!-- pause -->

> `run0` does not automatically make commands safe. The actual isolation depends on the systemd properties applied.

<!-- end_slide -->

Access Control Lists (ACLs)
===

**Problem**: Traditional permissions only allow control for a single **owner**, **group** and **others**

**Solution**: Access Control Lists (ACLs) let you define per-user or per-group permissions

<!-- pause -->

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

```bash
# Show ACLs
$ getfacl secret.txt
# Add a new user permission
$ setfacl -m u:bob:r secret.txt
# Remove an ACL entry
$ setfacl -x u:bob secret.txt
# Notice the little + sign in ls -l
$ ls -l secret.txt
-rw-r--r--+ 1 demo demo 0 Nov 10 16:19 secret.txt
```

<!-- pause -->

<!-- column: 1 -->

```bash
$ getfacl secret.txt
# file: secret.txt
# owner: alice
# group: staff
user::rw-
user:bob:r--
group::r--
mask::r--
other::---
```

<!-- pause -->

<!-- reset_layout -->

**Default ACLs**: If set on directories, ACLs apply to all new files inside: `setfacl -d -m u:bob:rw project/`

💡 ACLs offer fine-grained control -> especially useful for multi-user servers.

Still, they are rather hidden and rarely used.

<!-- end_slide -->

Linux Capabilities
===

**Problem**: `setuid root` gives full root privileges -> too powerful

**Solution**: **Linux Capabilities** split root privileges into fine-grained pieces

- Each process can get **only** the privileges it needs

<!-- pause -->

| Example Capability     | What it Allows                            | Example command                 |
| ---------------------- | ----------------------------------------- | ------------------------------- |
| `CAP_NET_ADMIN`        | Manage network interfaces, routing tables | `ip link set eth0 down`         |
| `CAP_NET_RAW`          | Use raw and packet sockets                | `ping 1.1`                      |
| `CAP_SYS_ADMIN`        | "Catch-all" - system-wide administration  | `mount /dev/sda /mnt`           |
| `CAP_DAC_OVERRIDE`     | Bypass file read/write permission checks  | `cat /root/secret.txt`          |
| `CAP_SYS_TIME`         | Change the system clock                   | `date -s "2026-11-10 12:00:00"` |
| `CAP_NET_BIND_SERVICE` | Bind to ports < 1024                      | `python3 -m http.server 80`     |

<!-- pause -->

> As always: See `man capabilities` for details

<!-- end_slide -->

Overview: The Five Capability Sets in Linux
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**Permitted (P)**

This is the list of all privileges a process is allowed to have.
Anything not on this list can never be obtained by the process.

<!-- pause -->

**Effective (E)**

The privileges that are currently active.
Only these are checked by the kernel when, e.g., a program tries to access port 80 or modify system files.

<!-- pause -->

**Inheritable (I)**

The privileges that can be passed on to a child process (after `exec()`).
This allows a program to give another program certain privileges.

<!-- column: 1 -->

<!-- pause -->

**Bounding (B)**

This is the maximum limit of all possible privileges.
Once a privilege is removed, it is permanently gone, even root cannot bring it back.

<!-- pause -->

**Ambient (A)**

Newer addition (since kernel 4.3): privileges that are automatically retained when starting a new program, if the program is not `setuid` and the privilege is present in both `P` and `I`.
Used, for example, by containers or systemd.

<!-- end_slide -->

Linux Capabilities
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# View capabilities

```sh
getcap /usr/bin/arping
```

# Set or remove capabilities

```sh
# add effective + permitted net raw capability
run0 setcap cap_net_raw+ep /usr/bin/arping
# remove net raw again
run0 setcap cap_net_raw-ep /usr/bin/arping
# remove all capabilities
run0 setcap -r /usr/bin/arping
```

<!-- column: 1 -->

<!-- pause -->

# Interactively

`capsh` can interactively set/drop permissions

```sh
run0 capsh --drop=cap_net_bind_service -- \
    -c 'python3 -m http.server 80'
```

<!-- pause -->

# Revocation limitation

- Once a process has a capability, the kernel cannot revoke it mid-execution
- You must terminate or restart the process to remove privileges
  - Fun fact: This is different on BSD

<!-- pause -->

<!-- reset_layout -->

> More about ACLs and Linux Capabilities: https://media.ccc.de/v/why2025-192-linux-permissions-and-hardening

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

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
