---
title: "Introduction to Linux: **Overview**"
author: Philipp Fruck & Pius Walter
---

Introduction
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# About us

- Pius & Philipp
- Studied CS back in 2019
- First time lecture this year
  - We need your feedback!

<!-- column: 1 -->

# About you

Quickly introduce yourself:

- Who are you?
- Which Operating Systems did you use previously
  - Windows, MacOS, Linux? Or only mobile devices?

<!-- end_slide -->

Organizational
===

- 5 lectures between 2 and 4.5 hours
- Mostly hands-on
  - You'll need your own Linux system
- Introduction into Linux system components
  - Installation
  - Basic & advanced terminal commands
  - Building applications and containers
- Practical lab work submissions
  

<!-- end_slide -->

What is Linux?
===

<!-- column_layout: [1, 2] -->


<!-- column: 0 -->

![image:width:80%](../assets/gnu-linux-meme.jpg)


<!-- column: 1 -->

![image:width:100%](../assets/linux-usecases.png)

<!-- reset_layout -->

> https://img.devrant.com/devrant/rant/r_1578772_VbG6J.jpg | Icons by flaticon.com

<!-- end_slide -->

Advantages of Linux
===

- Runs (almost) everywhere
  - From low-power to high performance computing
- Open Source
- Customizable
- Free of charge

<!-- end_slide -->

Components of a Linux system
===

|Component           |Example             | Description |
|--------------------|-------             | ----------- |
|Bootloader          |grub, systemd-boot  | Starts the system |
|Kernel              |Linux               | Interfaces with hardware |
|Init System         |systemd / openrc    | Launches all other programs |
|Display Server      |X11, Wayland        | Renders the graphical |
||                                        | user interface (GUI)|
|Display Manager     |GDM, LightDM        | Graphical login screen |
|Desktop Environment |Gnome, KDE, XFCE    | Defines how your GUI looks like |
|GUI app libraries   | GTK, QT, Electron  | Allows building GUI apps with |
||                                        | different look and feel|
| Security Module    | SELinux, AppArmor  | Enhanced security regulation |

<!-- end_slide -->

What is a Linux Distribution?
===

- Windows, MacOS, etc. only have a single OS with different Versions
  - Windows 10, Windows 11, ...
- Linux has a much greater varierty of system components
  - Different Desktops, different init systems, different apps
- A Linux Distro bundles certain components together:
  - Different kernel versions, different desktops, different package repositories
- Distros are opinionated
  - Software selection based on certain preferences
  - Some distros only ship open source software components (Debian, Fedora)
  - Some distros compile everything from source (Gentoo)
  - Different out-of-the-box security configuration (SELinux, AppArmor, Firewall frontends)
  - Different package managers and package formats
  - Desktop vs Server focus
  - etc ...
  
<!-- end_slide -->

Which Linux Distros are there?
===

https://upload.wikimedia.org/wikipedia/commons/1/1b/Linux_Distribution_Timeline.svg

A couple to point out:

- Slackware is one of the oldest distros, but nowadays almost obsolete
- Debian is a very stable (mostly server) distro which focuses on free software (community driven)
- Ubuntu is a newcomer friendly distro based on Debian, owned by Canonical
- Fedora is a community driven distro that focuses on modern software and security
- ArchLinux, community driven, focuses on customization and has bleeding edge software
- Gentoo is a source based distro --> software is compiled locally
- NixOS is a declaratively configurable distro
- RedHat and SUSE offer Enterprise Linux
  - Alma and Rocky are community editions of RedHat Enterprise Linux (RHEL)
- Kali / ParrotOS are targeted towards pentesting/security auditing (no daily-driving)
- Alpine is a minimal Linux distro focusing on minimal overhead (e.g. resource-constraint hardware/containers)

<!-- end_slide -->

Which Linux Distros are there?
===

![image:width:50%](../assets/arch-bathroom.jpeg)

<!-- end_slide -->

Package Managers
===

- A **package manager** installs, updates, and removes software
- Keeps track of dependencies (software that other software needs)
- Different distros use different package managers and package formats:

| Distro Family     | Package Manager               | Package Format |
| ----------------- | ----------------------------- | -------------- |
| Debian / Ubuntu   | `apt` / `dpkg`                | `.deb`         |
| Fedora / RHEL     | `dnf` / `yum`                 | `.rpm`         |
| Arch Linux        | `pacman`                      | `.pkg.tar.zst` |
| Alpine Linux      | `apk`                         | `.apk`         |
| NixOS             | `nix`                         | store paths    |
| Universal formats | `flatpak`, `snap`, `appimage` | portable       |

> Most package managers can update the entire system with a single command!

<!-- end_slide -->

Linux filesystem explained
===


```bash
/
├── bin -> usr/bin
├── boot
├── dev
├── etc
├── home  # contains user directories
├── lib -> usr/lib
├── lib64 -> usr/lib64
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin
├── srv
├── sys
├── tmp
├── usr
└── var
```

<!-- end_slide -->

Drivers on Linux
===

- Drivers allow the **kernel** to talk to hardware
- Most drivers are included in the Linux kernel!
- Plug & Play is common:
  - Network adapters, USB devices, webcams usually work out of the box
- Exceptions:
  - Some GPUs (e.g., Nvidia) have proprietary drivers
  - Some Wi-Fi chipsets require extra firmware
- Tools to check drivers:
  - `lspci`, `lsusb` -> list devices
  - `lsmod` -> list kernel modules (drivers)
  - `dmesg` -> check system log for driver messages

<!-- end_slide -->

How do I install my own distro?
===
<!-- end_slide -->


 Thank you for your attention!

 Don't forget the feedback
