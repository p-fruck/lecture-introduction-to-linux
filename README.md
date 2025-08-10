# Introduction to Linux

This repo holds the material for the lecture "Introduction to Linux".
This lecture covers 24 SWS which evaluates to 22 lecture hours (each 45 min) or 16.5 h.

## Content

The following content should be included in the lecture:

1. Overview
  - Introdution of lecturers, ask students about experience with different OSes.
  - Which Linux Distros are there?
    - Alpine
    - Distros using `.deb` packages (Debian, Ubuntu, Mint, Pos!OS)
    - Distros using `.rpm` packages (Fedora, RHEL, Alma, SUSE)
    - Other distros (Arch, Gentoo)
    - Image based distros (Fedora Aomic, MicroOS, ParticleOS)
  - Package managers
    - apt, dnf (yum), apk, pacman, rpm-ostree, transactional-update
    - Universal packages: Flatpak, snap, Appimage
  - Basic components:
    - Bootloader (grub, systemd)
    - Linux kernel
    - init system (systemd, OpenRC)
    - User Space (getty, dbus, polkit, sudo)
    - Display Server (X11, Wayland)
    - Display Manager (GDM, SDDM, LightDM)
    - Desktop Environment (Gnome, KDE, XFCE, ...) or Windows Manager (i3, Sway)
    - Applications (GTK, Qt, Electron)
  - Networking basics
    - ip command
    - `/etc/network/interfaces`, NetworkManager, systemd-networkd, netplan
    - Firewall: iptables/nftables, `ufw`, `firewalld`
    - Local network DHBW?
  - Drivers
  - Filesystem:
    - /etc, /bin, /var, /root, /home, ...
    - ext4, btrfs, fat, exfat, ntfs, zsh
    - XDG_BASE_DIR (XDG_RUNTIME_DIR), ~/.config, ...
2. Coreutils++
  - Intro to coreutils and other useful command line tools
    - File system: cd, ls, pwd, cp, mv, rm, lsblk, mount, touch
    - Working with text: echo, more|less, head|tail, cat, grep, ripgrep, sed, base64, cut, awk
    - System: env, whoami, date, lsblk, mount, uname, `/etc/os-release`, ps, ss/netstat
    - find, curl, wget, tmux, xdg-open, git
    - remote servers: ssh, scp
      - SSH keys (ed25519, sk)
      - SSH forwarding: `-R/-L`
      - /etc/ssh/sshd_config
  - Working with bash, pipes & redirects, variables, nested commands
    - for, while, if, set
  - Permissions:
    - Ownership, users + groups (chown, chmod)
    - SELinux Context (chcon, ls -laZ)
    - Elevation: sudo, systemd run0
  - chroot: Transition to Containers
3. Editors
  - nano/vim
  - helix, LSPs
4. Containers
  - Intro to containerization
  - Process + Network Namespaces, isolation
  - OCI containers
  - Podman vs Docker (client/server architecture)
  - Rootless vs Rootfull containers
    - subuids, root inside and outside container
  - Containerfiles, volume mounts
  - compose files?
5. Writing
  - Markdown
  - groff/troff?
  - LaTeX
  - Typst

## Tasks
- Setup own Linux distro (Baremetal/VM/Dual Boot)
- Perform filtering on csv files (cat, grep, cut, awk)
- Bash scripting, pipe redirection
- Curling a remote server, get question, post answer
- Building custom Containerfile
- Write something with latex/types, submissions with markdown?
