---
title: 'Introduction to Linux: **Services and Remote Access**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

System Services and Remote Systems
===

# Goal of this Lecture

- How to run persistent, scheduled and background services
- How to inspect logs, analyze failures & perform troubleshooting
- How to securely connect to remote systems
- How Linux manages networking and DNS
- How to sandbox services with systemd

<!-- pause -->

# Why?

- 90 % of infrastructure runs on headless Linux servers
- You must control systems without a GUI, even during incidents
- Understanding services & logs is key for:
  - intrusion detection
  - forensic analysis
  - disaster recovery

<!-- end_slide -->

systemd: Service Management
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Start/Stop/Enable

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
# hard restart (drop connections)
sudo systemctl restart nginx
# or soft reload (keep connections)
sudo systemctl reload nginx
```

<!-- pause -->

Shortcuts:

```bash
# combine start and enable
systemctl [enable|disable] --now ...
# show logs (new since systemd 258)
systemctl [start|stop|restart] -v ...
```

<!-- column: 1 -->

<!-- pause -->

Check status

```bash
systemctl status sshd
systemctl status --user pipewire
```

<!-- pause -->

List failed services

```bash
systemctl list-units --failed
```

<!-- pause -->

Analyze boot time

```bash
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
```

<!-- end_slide -->

systemd: Service Unit Basics
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Example: `/etc/systemd/system/example.service`

```dotenv
[Unit]
Description=Example App

[Service]
ExecStart=/usr/local/bin/app
Restart=always
User=appuser

[Install]
#WantedBy=graphical.target    # GUI ready
#WantedBy=multi-user.target   # CLI ready
WantedBy=default.target       # GUI or CLI
#WantedBy=network.target      # network ready
```

<!-- column: 1 -->

<!-- pause -->

# User vs System scope

- system: `/etc/systemd/system/`
- user: `~/.config/systemd/user/`

<!-- pause -->

Enable and run

```bash
sudo systemctl [--user] daemon-reload
sudo systemctl [--user] enable --now example.service
```

<!-- pause -->

Dependencies

```dotenv
[Unit]
# start serviceA when starting serviceB.
Requires=serviceA.service
# ensure serviceA is fully started.
After=serviceA.service
```

<!-- end_slide -->

journalctl: Viewing Logs
===

System log viewer (replaces many legacy tools like `dmesg` and `/var/log/*`)

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Basic usage

```bash
journalctl -u sshd.service
journalctl -b    # since boot
journalctl -b  1 # since first boot
journalctl -b -1 # since last boot
journalctl -f    # live follow
# commonly used: eXplain, End, Follow
journalctl [--user] -xefu <unit>
```

<!-- column: 1 -->

<!-- pause -->

Filter by user

```bash
journalctl _UID=1000
```

<!-- pause -->

```bash
# equivalent to sudo dmesg --ctime
sudo journalctl -ke
# equivalent to
# sudo cat /var/log/audit/audit.log
sudo journalctl -t audit \
    --no-pager --output=cat
```

<!-- end_slide -->

SSH: Server, Keys and Permissions
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Server config: `/etc/ssh/sshd_config`

```bash
PasswordAuthentication no
PermitRootLogin no
Port 22
```

<!-- pause -->

Apply changes

```bash
sudo sshd -t # ensure valid config!
sudo systemctl reload sshd  # keep sessions
sudo systemctl restart sshd # drop sessions
```

<!-- pause -->

Generate and copy key pair

```bash
ssh-keygen -t ed25519 -C "you@hostname"
ssh-copy-id user@host
```

<!-- column: 1 -->

<!-- pause -->

Permissions matter!

| File                     | Permissions |
| ------------------------ | ----------- |
| `~/.ssh`                 | `700`       |
| `~/.ssh/authorized_keys` | `600`       |
| `~/.ssh/id_*`            | `600`       |

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

<!-- pause -->

`~/.ssh/authorized_keys` holds the public keys that are authorized to log in as the given user.

`ssh-copy-id` is a shortcut for running e.g.

```bash
echo "ssh-ed25519 AAAA.... mypubkey" \
    >> ~/.ssh/authorized_keys
```

<!-- pause -->

> Use SSH key authentication over passwords!

<!-- end_slide -->

SSH: Jump Hosts and Port Forwarding
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Jump Hosts (ProxyJump)

For hosts only reachable via another host

```bash
ssh -J user@jump.example.com user@target
```

<!-- pause -->

Permanent config: `~/.ssh/config`

```
Host internal
    HostName 10.0.0.5
    ProxyJump jump.example.com
```

```bash
ssh internal
```

<!-- column: 1 -->

<!-- pause -->

# Port Forwarding

Local: expose a remote service locally

```bash
ssh -L 8080:localhost:80 user@host
```

<!-- pause -->

Remote: expose your local service remotely

```bash
ssh -R 2222:localhost:22 user@host
```

<!-- pause -->

SOCKS5 proxy: full encrypted tunnel

```bash
ssh -D 1080 user@host
```

<!-- end_slide -->

tmux: Terminal Multiplexing
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

Persistent sessions which survive disconnects

- Split terminal into panes
- Shared sessions for teamwork

<!-- pause -->

Basic usage

```bash
tmux                 # start
tmux ls              # list sessions
tmux attach -t <id>  # reattach
```

<!-- column: 1 -->

<!-- pause -->

Basic keys (press `Ctrl+B` first)

| Action             | Keys  |
| ------------------ | ----- |
| Split vertically   | `%`   |
| Split horizontally | `"`   |
| New window         | `c`   |
| Switch windows     | `0-9` |
| Detach session     | `d`   |

<!-- reset_layout -->

<!-- pause -->

Activate mouse mode by pressing `Ctrl+B` and `:` then entering `set -g mouse on`.

<!-- end_slide -->

Networking
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

# Modern

- `NetworkManager.service` (e.g. on Fedora)
  - `nmcli`/`nmtui` on the CLI
- `systemd-networkd.service`
  - Relies on config files
  - More suitable for servers

<!-- pause -->

# Traditional

- `networking.service` (e.g. Debian)
  - Uses `/etc/network/interfaces`

<!-- pause -->

# Ubuntu

- Netplan abstraction layer
  - NetworkManager for GUI
  - systemd-networkd for server

<!-- column: 1-->

<!-- pause -->

# Universal

IP command is universal, but not persistent

```bash
# Address Add
ip a a 192.168.7.42 dev enp0s1
# Address Delete
ip a d 192.168.7.42 dev enp0s1
```

<!-- pause -->

# Naming

- Traditional names: `eth0`, `eth1`, ...
- `systemd` naming scheme (enp0s1):
  - `en` = Ethernet, `wl` = Wi-Fi
  - `s` = slot, `u` = port
  - `man systemd.net-naming-scheme`

<!-- end_slide -->

DNS
===

<!-- column_layout: [2,3] -->

<!-- column: 0-->

# Traditional `/etc/resolv.conf`

Plain text file storing DNS servers and search domains:

```
nameserver 1.1.1.1
search example.com
```

- Managed manually or by scripts
  - e.g. `ifup`/`dhclient`
- Applications read it directly

<!-- column: 1-->

<!-- pause -->

# `systemd-resolved`

- `systemd` service providing DNS resolution
- `resolvectl status`
- Maintains its own dynamic DNS configuration
- `/etc/resolv.conf` is usually a **symlink** to
  - `/run/systemd/resolve/stub-resolv.conf`
    - uses 127.0.0.53 as local DNS stub
  - Or `/run/systemd/resolve/resolv.conf`
    - full configuration
- Benefits:
  - Support multiple interfaces with different DNS
  - Provides caching

<!-- reset_layout -->

<!-- pause -->

**Key Difference:**\
`/etc/resolv.conf` is **static**, whereas `systemd-resolved` is a **dynamic DNS resolver** that updates `/etc/resolv.conf` or provides a local stub for applications.

<!-- end_slide -->

Scheduled Tasks
===

<!-- column_layout: [4,4] -->

<!-- column: 0-->

# Traditional: Cron

```bash
crontab -e # edit
crontab -l # list
```

```
┌─────── minute (0 - 59)
│ ┌─────── hour (0 - 23)
│ │ ┌─────── day of month (1 - 31)
│ │ │ ┌─────── month (1 - 12)
│ │ │ │ ┌─────── day of week (0 - 7)
│ │ │ │ │            (Sunday=0 or 7)
* * * * *  command_to_run
```

<!-- pause -->

**Q**: How do we define a nightly backup job at 4 AM?

<!-- pause -->

**A**: `0 4 * * * backup.sh`

<!-- column: 1-->

<!-- pause -->

# Modern: systemd timers

- Name indicates which service to start
  - `foo.timer` triggers `foo.service`
- e.g. `/etc/systemd/system/myservice.timer`

```dotenv
[Unit]
Description=Runs myservice.service
[Timer]
# Run 5min after system has booted
OnBootSec=5m
# Run every hour
OnCalendar=hourly
[Install]
WantedBy=timers.target
```

```bash
systemctl list-timers
```

<!-- reset_layout -->

<!-- pause -->

> Preference: systemd timers -> better logging, dependency handling, boot triggers

<!-- end_slide -->

Hardening Services: `systemd-analyze security`
===

Services often run as root with full system access. `systemd` can sandbox them without changing the application.

```bash
# exposure overview of all running services
systemd-analyze security
# detailed report for a single unit
systemd-analyze security sshd.service
```

<!-- pause -->

- Each setting contributes to an **exposure level** from 0.0 (safe) to 10.0 (UNSAFE)
- ✓ = restricted, ✗ = exposed
- The score is a hint, not a guarantee: e.g. `sshd` legitimately needs a lot of access

<!-- end_slide -->

Hardening Services: Directives
===

<!-- column_layout: [3, 4] -->

<!-- column: 0 -->

Add to the `[Service]` section

```dotenv
[Service]
DynamicUser=yes
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
CapabilityBoundingSet=
RestrictAddressFamilies=AF_INET AF_INET6
SystemCallFilter=@system-service
```

<!-- column: 1 -->

<!-- pause -->

| Directive                 | Effect                           |
| ------------------------- | -------------------------------- |
| `DynamicUser`             | Temporary unprivileged user      |
| `NoNewPrivileges`         | Blocks `setuid` escalation       |
| `ProtectSystem=strict`    | File system is read-only         |
| `ProtectHome`             | `/home` is inaccessible          |
| `PrivateTmp`              | Own, isolated `/tmp`             |
| `CapabilityBoundingSet=`  | Drops all capabilities           |
| `RestrictAddressFamilies` | Limits socket types              |
| `SystemCallFilter`        | Allow-list of syscalls (seccomp) |

<!-- reset_layout -->

<!-- pause -->

> Use `systemctl edit <unit>` to add hardening via a drop-in without touching the vendor unit file.

<!-- end_slide -->

Exercise
===

1. List the exposure of all services: `systemd-analyze security`
2. Find the most exposed service and inspect it: `systemd-analyze security <unit>`

<!-- pause -->

3. Create a service `/etc/systemd/system/hello.service` which runs `/usr/bin/sleep 600`
4. Check its score with `systemd-analyze security hello.service`

<!-- pause -->

5. Add hardening directives with `systemctl edit hello.service` until the score drops below 3.0
6. Restart the unit, then check `systemctl status hello` and `journalctl -u hello`

<!-- pause -->

Bonus: Try the directives ad hoc without a unit file

```bash
systemd-run -p ProtectSystem=strict -p PrivateTmp=yes --pty bash
```

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
