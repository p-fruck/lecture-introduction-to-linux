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
- Understand Linux Capabilities as a safer alternative to full root access

# Why?

- Classic permissions are often not granular enough
- Minimizing granted privileges reduces the security impact of bugs and exploits

<!-- end_slide -->

Elevating Privileges
===

| Command            | Description                  | Useful Flags / Examples                   |
| ------------------ | ---------------------------- | ----------------------------------------- |
| `su`               | Switch shell to another user |                                           |
| `sudo` / `sudo-rs` | Run command as root          | `sudo -i` open interactive root shell     |
|                    |                              | `sudo !!` runs the last command with sudo |
| `run0`             | Like `sudo` but uses Polkit  |                                           |

> The `/etc/sudoers` file contains the configuration and the behaviour of the `sudo` command
> Use `sudo visudo` to make changes (syntax check and lock of the sudoers file)

> `run0` allows enhanced system protection
> `run0 --property=ProtectSystem=strict --property=ReadWritePaths=/tmp touch /tmp/1`

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

<!-- end_slide -->

Linux Capabilities
===

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

- Overview: The Five Capability Sets in Linux

| Set             | Meaning                                                                              |
| --------------- | ------------------------------------------------------------------------------------ |
| Permitted (P)   | This is the list of all privileges a process is allowed to have.                     |
|                 | Anything not on this list can never be obtained by the process.                      |
| Effective (E)   | The privileges that are currently active. Only these are checked by the kernel when, |
|                 | for example, a program tries to access port 80 or modify system files.               |
| Inheritable (I) | The privileges that can be passed on to a child process (after `exec()`).            |
|                 | This allows a program to give another program certain privileges.                    |
| Bounding (B)    | This is the maximum limit of all possible privileges. Once a privilege is removed,   |
|                 | it is permanently gone, even root cannot bring it back.                              |
| Ambient (A)     | Newer addition (since kernel 4.3): privileges that are automatically retained when   |
|                 | starting a new program, if the program is not `setuid` and the privilege is present  |
|                 | in both `P` and `I`. Used, for example, by containers or systemd.                    |

<!-- end_slide -->

Linux Capabilities
===

View capabilities

```bash
getcap /usr/bin/arping
```

Set or remove capabilities

```bash
sudo setcap cap_net_raw+ep /usr/bin/arping
```

- Revocation limitation
  - Once a process has a capability, the kernel cannot revoke it mid-execution
  - You must terminate or restart the process to remove privileges

<!-- pause -->

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

<!-- column_layout: [1, 1, 1] -->

<!-- column: 1 -->

**Time: 15 minutes**

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
