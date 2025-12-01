---
title: "Introduction to Linux: **System Services and Remote Systems**"
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

System Services and Remote Systems
===

# Goal of this Lecture
- How to securely connect to remote systems
- How to run persistent and background services
- How to inspect logs, analyze failures & perform troubleshooting
- How Linux manages networking, DNS, and scheduled tasks
- Basics of SELinux for enhanced security

# Why?

- 90 % of infrastructure runs on headless Linux servers
- You must control systems without a GUI, even during incidents
- Understanding services & logs is key for:
  - intrusion detection
  - forensic analysis
  - disaster recovery

<!-- end_slide -->


SSH: Secure Remote Access
===

- Stands for **s**ecure **sh**ell
- Encrypted remote shell & file transfer
- Works on all major platforms
- Uses client-server model
  - Server: `sshd`
  - Client: `ssh`

Basic usage

```bash
ssh <user>@<host>
```

Common options

```bash
ssh -p 2222 user@host         # custom port
ssh -i ~/.ssh/id_ed25519 host # use specific key
```

<!-- end_slide -->


SSH Server Configuration
===

Config file: `/etc/ssh/sshd_config`
<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

Common security-relevant options

```bash
# disable password login
PasswordAuthentication no
# prevent direct root login
PermitRootLogin no
# change port binding if needed
Port 22
```

<!-- column: 1 -->
Apply config changes

```bash
sudo sshd -t # ensure valid config!
# soft reload, keep existing connections
sudo systemctl reload sshd
# hard restart, drop existing connections
sudo systemctl restart sshd
# show status
sudo systemctl status sshd
```

<!-- reset_layout -->

> Use SSH key authentication over passwords!

<!-- end_slide -->


SSH Key Authentication
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

Generate key pair

```bash
ssh-keygen -t ed25519 -C "you@hostname"
```

Copy to server

```bash
ssh-copy-id user@host
```

or modify `authorized_keys` manually.

<!-- column: 1 -->

Permissions matter!

| File                     | Required Permissions |
| ------------------------ | -------------------- |
| `~/.ssh`                 | `700`                |
| `~/.ssh/authorized_keys` | `600`                |
| `~/.ssh/id_*`            | `600`                |

Fix

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

<!-- end_slide -->


SSH Jumphosts (ProxyJump)
===

Used when a host is only reachable via another host.

```bash
ssh -J user@jumphost user@target
```

Permanent config: `~/.ssh/config`

```
Host internal
    HostName 10.0.0.5
    ProxyJump bastion
```

Then

```bash
ssh internal
```

<!-- end_slide -->


SSH Port Forwarding
===

Local Forwarding: Expose a remote service locally

```bash
ssh -L 8080:localhost:80 user@host
```

Remote Forwarding: Expose your local service to remote system

```bash
ssh -R 2222:localhost:22 user@host
```

SOCKS5 Proxy: Full encrypted tunnel

```bash
ssh -D 1080 user@host
```

<!-- end_slide -->


tmux:  Terminal Multiplexing
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

- Persistent sessions which survive disconnects
- Split terminal into panes
- Shared sessions for teamwork

Basic usage

```bash
tmux                 # start
tmux ls              # list sessions
tmux attach -t <id>  # reattach
```

<!-- column: 1 -->

Basic keys (press `Ctrl+B` first)

| Action              | Keys  |
| ------------------- | ----- |
| Split vertically    | `%`   |
| Split horizontally  | `"`   |
| New window          | `c`   |
| Switch windows      | `0-9` |
| Detach session      | `d`   |

<!-- reset_layout -->

Activate mouse mode by pressing `Ctrl+B` and `:` then entering `set -g mouse on`.
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

Shotcuts:

```bash
# combine start and enable
systemctl [enable|disable] --now ...
# show logs (new since systemd 258)
systemctl [start|stop|restart] -v ... 
```

<!-- column: 1 -->

Check status

```bash
systemctl status sshd
systemctl status --user pipewire
```

List failed services

```bash
systemctl list-units --failed
```

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
WantedBy=default.target      # GUI or CLI
#WantedBy=network.target  # network ready
```

<!-- column: 1 -->
# User vs System scope

- system: `/etc/systemd/system/`
- user: `~/.config/systemd/user/`

Enable and run

```bash
sudo systemctl [--user] daemon-reload
sudo systemctl [--user] enable --now example.service
```

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
Filter by user

```bash
journalctl _UID=1000
```

```bash
# equivalent to sudo dmesg --ctime
sudo journalctl -ke
# equivalent to
# sudo cat /var/log/audit/audit.log
sudo journalctl -t audit \
  --no-pager --output=cat
```


<!-- end_slide -->

Common services: Networking
===

<!-- column_layout: [1,1] -->
<!-- column: 0-->

# Modern

- `NetworkManager.service` (e.g. on Fedora)
  - `nmcli`/`nmtui` on the CLI
- `systemd-networkd.service`
  - Relies on config files
  - More suitable for servers

# Traditional
- `networking.service` (e.g. Debian)
  - Uses `/etc/network/interfaces`

# Ubuntu
- Netplan abstraction layer
  - NetworkManager for GUI
  - systemd-network for server

<!-- column: 1-->

# Universal

IP command is universal, but not persistent

```bash
# Address Add
ip a a 192.168.7.42 dev enp0s1
# Address Delete
ip a d 192.168.7.42 dev enp0s1
```

# Naming

- Traditional names: `eth0`, `eth1`, ...
- Systemd naming scheme (enp0s1):
  - `en` = Ethernet, `wl` = WiFi
  - `s` = slot, `u` = port
  - `man systemd.net-naming-scheme`

<!-- end_slide -->

Common services: DNS
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
  - e.g. ifup/dhclient
- Applications read it directly

<!-- column: 1-->
# `systemd-resolved`

- Systemd service providing DNS resolution
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

**Key Difference:**  
`/etc/resolv.conf` is **static**, whereas `systemd-resolved` is a **dynamic DNS resolver** that updates `/etc/resolv.conf` or provides a local stub for applications.

<!-- end_slide -->


Common services: Scheduled Tasks
===
<!-- column_layout: [1,1] -->
<!-- column: 0-->

# Traditional: Cron

- Simple to read/write
- Hard to gather logs
```bash
crontab -e # edit
crontab -l # list
```

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 7)
│ │ │ │ │                  (Sunday=0 or 7)
* * * * *  command_to_run
```
<!-- column: 1-->
# Modern: systemd timers

Timer unit
- Name indicates which service to start
- e.g. `/etc/systemd/system/myservice.timer`

```dotenv
[Unit]
Description=Runs the unit named myservice.service

[Timer]
# Run 5min after system has booted
OnBootSec=5m
# Run every hours
OnCalendar=hourly
```

<!-- reset_layout -->
> Preference: **systemd-timers** → better logging, dependency handling, boot triggers

<!-- end_slide -->

Common services: Disk mounting
===

<!-- column_layout: [1,1] -->
<!-- column: 0-->
## What is `/etc/fstab`

- Plain text configuration file defining **filesystems to mount at boot**.
```dotenv
/dev/sda1  /      ext4  defaults  0 1
/dev/sdb1  /data  ext4  defaults  0 2
```

- Traditionally used by `mount -a` during boot or manually with `mount`.


<!-- column: 1-->
## How systemd uses `/etc/fstab`

- Systemd automatically **generates mount units** for every entry in `/etc/fstab`.
- Each filesystem becomes a unit like:
  - /boot -> boot.mount
  - /tmp -> tmp.mount
  - /mnt/data -> mnt-data.mount
- Benefits:
  - Parallelized mounting (faster)
  - Dependency tracking, e.g.
    network-mounted filesystems, `After=`, `Requires=`

<!-- reset_layout -->

**Takeaway:**  
- `/etc/fstab` is still the **source of truth for mounts**, but systemd **turns entries into units** for smarter, faster, and more reliable boot-time mounting.

<!-- end_slide -->

SELinux Basics
===

<!-- column_layout: [1, 1] -->
<!-- column: 0 -->

- Mandatory Access Control (MAC)
- Adds security labels (contexts) to
  - files
  - processes
  - ports

Show context

```bash
ls -Z
ps -eZ
```

<!-- column: 1 -->

Change context

```bash
sudo chcon -t httpd_sys_content_t /var/www/html/index.html
```

Check allowed labels

```bash
sudo semanage fcontext -l
```

<!-- reset_layout -->

> If SELinux denies access → check logs with `sudo journalctl -t setroubleshoot`

<!-- end_slide -->


Recap: Legacy vs Modern Tools
===

| Category     | Legacy Tool           | systemd Alternative       |
| ------------ | --------------------- | ------------------------- |
| Service mgmt | SysV init scripts     | systemctl                 |
| Logs         | `/var/log/*`, `dmesg` | journalctl                |
| Cronjobs     | cron                  | systemd timers            |
| Networking   | ifupdown              | networkd / NetworkManager |

> systemd aims to unify the Linux ecosystem
