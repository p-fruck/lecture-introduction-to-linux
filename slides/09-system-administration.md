---
title: 'Introduction to Linux: **System Administration**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim.yml
---

System Administration
===

# Goal of this Lecture

- How to inspect and analyze system logs
- How Linux manages networking, DNS, and scheduled tasks
- How disks are mounted and how init systems differ
- Basics of SELinux and Linux firewalls for enhanced security

# Why?

- Servers need to be monitored, debugged, and secured without a GUI
- Understanding logs, networking, and init systems is key for:
  - troubleshooting
  - security hardening
  - reliable system operation

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

**Key Difference:**\
`/etc/resolv.conf` is **static**, whereas `systemd-resolved` is a **dynamic DNS resolver** that updates `/etc/resolv.conf` or provides a local stub for applications.

<!-- end_slide -->

Common services: Scheduled Tasks
===

<!-- column_layout: [3,4] -->

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

<!-- column: 1-->

# Modern: systemd timers

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

Alternative init systems
===

| Init System      | Service File / Directory Location  | Enable/Start Command               |
| ---------------- | ---------------------------------- | ---------------------------------- |
| **SysVinit**     | `/etc/init.d/<service>` and        | `sudo update-rc.d sshd defaults`   |
|                  | symlinks in `/etc/rc*.d/`          | `/etc/init.d/sshd start`           |
| **BusyBox init** | `/etc/init.d/<service>`            | `/etc/init.d/sshd start`           |
| **OpenRC**       | `/etc/init.d/<service>`            | `rc-service sshd start`            |
|                  | `/etc/runlevels/<level>/`          |                                    |
| **s6-rc**        | `/etc/s6-rc/source/<service>/`     | `s6-rc -u change sshd`             |
|                  | or `/service/<service>/`           |                                    |
| **runit**        | `/etc/sv/<service>/` (definitions) | `ln -s /etc/sv/sshd /var/service/` |
|                  | `/var/service/` (active)           |                                    |

- SysVinit is the traditional runlevel-based init using shell scripts
- BusyBox init is a minimal SysV-style variant for embedded systems
- OpenRC is a modern dependency-aware script-based init with parallel startup
- runit is a fast three-stage init with built-in service supervision
- s6/s6-rc provides a highly modular, reliability-focused supervision framework ideal for minimal and containerized systems

> Use `ps [aux] | grep ' 1 '` to determine your init system (PID 1)

<!-- end_slide -->

SELinux Basics
===

<!-- column_layout: [3, 4] -->

<!-- column: 0 -->

Mandatory Access Control (MAC)

- Adds security labels (contexts) to files processes and ports

```bash
# show context
ls -Z
ps -eZ
# get/set SELinux state
getenforce
setenforce {0,1}
```

<!-- column: 1 -->

List and change file context / service port

```bash
sudo semanage fcontext -l
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# -m = modify, -a = append
sudo semanage port -m -t ssh_port_t -p tcp 2222
sudo semanage port -l
```

<!-- reset_layout -->

> SELinux denies access → Check logs with `sudo journalctl -t setroubleshoot` or use `audit2allow`

> If you see `setenforce 0` in installation instructions, choose a different product

<!-- end_slide -->

Linux Firewall Tools
===

<!-- column_layout: [2, 2] -->

<!-- column: 0 -->

# iptables

- Traditional Linux firewall
- Works at the packet-filtering level
- Different commands for IPv4/IPv6
  - Complex structure & rules
- `iptables -L -v -n [-t {nat,mangle}]`
- `ip6tables -L -v -n [-t {nat,mangle}]`
- `iptables-save; ip6tables-save`

# nftables

- Successor to iptables
- Single framework for IPv4, IPv6, ARP, and bridge filtering
- Uses concise syntax; replaces multiple iptables commands
- `nft list ruleset`

<!-- column: 1 -->

# ufw

- Stands for "Uncomplicated Firewall"
- Front-end for iptables/nftables
- Simple CLI for managing rules
- Mostly used on Ubuntu/Debian
- `ufw status verbose`

# firewalld

- Dynamic firewall manager for Linux
- Zones define network trust levels
- Works with nftables back-end
- More complex & capable than `ufw`
- Common on RHEL/Fedora
- `sudo firewall-cmd --list-all`

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
