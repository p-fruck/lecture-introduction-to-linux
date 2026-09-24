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

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
