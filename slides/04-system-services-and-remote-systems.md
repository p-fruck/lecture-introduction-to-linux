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

Common security-relevant options

```bash
PasswordAuthentication no    # disable password login
PermitRootLogin no           # prevent direct root login
Port 22                      # change port binding if needed
```

Apply config changes

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```

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

Check status

```bash
systemctl status sshd
systemctl status --user pipewire
```

Start/Stop/Enable

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
```

<!-- column: 1 -->

List failed services

```bash
systemctl list-units --failed
```

Analyze boot time

```bash
systemd-analyze
systemd-analyze blame
```

User vs System scope

- system: `/etc/systemd/system/`
- user: `~/.config/systemd/user/`

<!-- end_slide -->


systemd: Service Unit Basics
===

Example: `/etc/systemd/system/example.service`

```ini
[Unit]
Description=Example App

[Service]
ExecStart=/usr/local/bin/app
Restart=always
User=appuser

[Install]
WantedBy=multi-user.target
```

Enable and run

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now example.service
```

<!-- end_slide -->


journalctl: Viewing Logs
===

System log viewer (replaces many legacy tools like `dmesg` and `/var/log/*`)

Basic usage

```bash
journalctl -u sshd.service
journalctl -b              # since boot
journalctl -f              # live follow
```

Filter by user

```bash
journalctl _UID=1000
```

Show persistent logs

```bash
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal
```

<!-- end_slide -->


Networking & System Configuration Tools
===

| Tool                    | Purpose                           |
| ----------------------- | --------------------------------- |
| `/etc/fstab`            | Filesystem auto-mounting          |
| `systemd-resolved`      | DNS configuration                 |
| `systemd-networkd`      | Network config on servers         |
| NetworkManager          | GUI/network automation on laptops |
| `nmcli`                 | CLI for NetworkManager            |
| `cron` / systemd timers | Scheduled tasks                   |

Check network config

```bash
ip a
nmcli device show
resolvectl status
```

Mount example

```bash
sudo mount -a
```

<!-- end_slide -->


systemd Timers vs Cron
===

Recommended Modern Replacement: systemd timers

Timer unit

```ini
[Timer]
OnBootSec=5m
OnCalendar=hourly
```

Traditional cron

```bash
crontab -e
*/30 * * * * /usr/local/script.sh
```

> Preference: **systemd-timers** → better logging, dependency handling, boot triggers

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
