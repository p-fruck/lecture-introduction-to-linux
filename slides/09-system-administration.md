---
title: 'Introduction to Linux: **System Administration**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

System Administration
===

# Goal of this Lecture

- How storage is organized: partitions, filesystems and mounting
- How to protect data at rest: LUKS, TPM2 and measured boot
- How to snapshot, update and roll back a system
- Mandatory access control and firewalls as additional layers

<!-- pause -->

# Why?

- Lost disks and laptops are a common source of data leaks
- Updates are the most effective security measure, but they can break systems
- Snapshots turn risky changes into reversible ones

<!-- end_slide -->

Block Devices, Partitions and Filesystems
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

```bash
lsblk -f              # devices, FS, UUIDs
sudo fdisk -l         # partition tables
sudo blkid            # UUIDs and types
findmnt               # mounted filesystems
df -hT                # usage and FS type
```

<!-- pause -->

Layers (bottom to top)

1. Disk (`/dev/nvme0n1`)
2. Partition table (GPT) and partitions
3. Optional: LUKS, LVM, RAID
4. Filesystem
5. Mount point

<!-- column: 1 -->

<!-- pause -->

Typical UEFI layout

| Partition | Content                      |
| --------- | ---------------------------- |
| ESP       | FAT32, `/boot/efi`, loader   |
| `/boot`   | Kernel, initramfs (optional) |
| root      | Encrypted ext4/btrfs/xfs     |

<!-- reset_layout -->

<!-- pause -->

> Always refer to disks by **UUID** or **label**: `/dev/sdX` names can change between boots.

<!-- end_slide -->

Common Filesystems
===

| Filesystem | Typical use                  | Notable features                              |
| ---------- | ---------------------------- | --------------------------------------------- |
| **ext4**   | Default on Debian/Ubuntu     | Stable, simple, journaling                    |
| **xfs**    | Default on RHEL, large files | High performance, cannot be shrunk            |
| **btrfs**  | Fedora, openSUSE             | Snapshots, subvolumes, checksums, compression |
| **zfs**    | Storage servers, BSD         | Snapshots, RAID, out-of-tree on Linux         |
| **vfat**   | ESP, USB sticks              | No permissions, universal compatibility       |
| **tmpfs**  | `/tmp`, `/run`               | Lives in RAM                                  |

<!-- pause -->

```bash
sudo mkfs.ext4 -L data /dev/sdb1   # ⚠️ destroys existing data
sudo mount /dev/sdb1 /mnt
sudo umount /mnt
```

<!-- end_slide -->

Mounting at Boot: `/etc/fstab`
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

## What is `/etc/fstab`

- Plain text configuration file defining **filesystems to mount at boot**

```dotenv
# <device>   <mount> <type> <options>  <dump> <fsck>
UUID=1a2b…   /       ext4   defaults   0      1
UUID=3c4d…   /data   ext4   noatime    0      2
```

<!-- pause -->

- Test before rebooting!

```bash
sudo mount -a
sudo systemctl daemon-reload
```

<!-- column: 1-->

<!-- pause -->

## How systemd uses `/etc/fstab`

- Systemd **generates mount units** for every entry
  - `/boot` → `boot.mount`
  - `/mnt/data` → `mnt-data.mount`
- Benefits:
  - Parallelized mounting (faster)
  - Dependency tracking, e.g. network filesystems

<!-- reset_layout -->

<!-- pause -->

> A broken `fstab` entry can drop the system into emergency mode. Use `nofail` for non-essential disks.

<!-- end_slide -->

Full Disk Encryption: LUKS
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

**Problem**: Anyone with physical access can read an unencrypted disk.

**Solution**: **LUKS** (dm-crypt) encrypts a block device. The filesystem lives *inside* the encrypted container.

<!-- pause -->

```bash
sudo cryptsetup luksFormat /dev/sdb1   # ⚠️ wipes data
sudo cryptsetup open /dev/sdb1 secret
sudo mkfs.ext4 /dev/mapper/secret
sudo mount /dev/mapper/secret /mnt
sudo cryptsetup close secret
```

<!-- column: 1-->

<!-- pause -->

Unlock at boot: `/etc/crypttab`

```dotenv
# <name>  <device>     <keyfile> <options>
secret    UUID=5e6f…   none      luks
```

Then use `/dev/mapper/secret` in `/etc/fstab`

<!-- pause -->

- Multiple key slots: passphrase, recovery key, FIDO2, TPM2
- `sudo cryptsetup luksDump /dev/sdb1`
- Root filesystem: unlocked by the **initramfs** before the system starts

<!-- end_slide -->

TPM2 and Measured Boot
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

**TPM**: Tamper-resistant chip on the mainboard (or in firmware)

- Stores secrets and can **seal** them to a system state
- Contains **PCRs** (Platform Configuration Registers)
  - Can only be *extended*: `PCR = hash(PCR || new value)`

<!-- pause -->

**Measured boot**: every stage measures the next one before running it

1. Firmware → PCR 0, 2
2. Secure Boot state and keys → PCR 7
3. Boot loader / kernel (UKI) → PCR 4, 11

<!-- column: 1-->

<!-- pause -->

Inspect

```bash
systemd-analyze pcrs
sudo tpm2_pcrread sha256
systemd-cryptenroll --tpm2-device=list
```

<!-- pause -->

Enroll the TPM as an additional LUKS key

```bash
sudo systemd-cryptenroll \
    --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3
```

```dotenv
# /etc/crypttab
root UUID=… none tpm2-device=auto
```

<!-- reset_layout -->

<!-- pause -->

> The TPM only releases the key if the PCR values match → modified boot chain = no automatic unlock.

<!-- end_slide -->

systemd-pcrlock
===

**Problem**: Binding to PCR 7 only trusts the Secure Boot *keys*. Binding to PCR 4 directly breaks on every kernel or bootloader update.

<!-- pause -->

**Solution**: `systemd-pcrlock` builds a **policy** from the boot event log and known-good components.

<!-- column_layout: [1,1] -->

<!-- column: 0-->

```bash
# show measured events
systemd-pcrlock log
# create/update the policy
sudo systemd-pcrlock make-policy
# use the policy for a LUKS volume
sudo systemd-cryptenroll /dev/nvme0n1p3 \
    --tpm2-device=auto \
    --tpm2-pcrlock=/var/lib/systemd/pcrlock.json
```

<!-- column: 1-->

<!-- pause -->

- Policy is stored in the TPM (NV index), not only on disk
- Updates re-generate the policy (`systemd-pcrlock.service`)
- Always keep a **recovery key**:

```bash
sudo systemd-cryptenroll --recovery-key /dev/nvme0n1p3
```

<!-- reset_layout -->

<!-- pause -->

> ⚠️ A TPM does not protect against a running, logged-in system. Combine it with a PIN or strong login if the device can be stolen while on.

<!-- end_slide -->

Snapshots with btrfs
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

**Copy-on-write (CoW)** filesystem: snapshots are instant and initially take no extra space.

- **Subvolume**: independently mountable directory tree
- **Snapshot**: subvolume created from another subvolume

```bash
sudo btrfs subvolume list /
sudo btrfs subvolume create /data
```

<!-- pause -->

```bash
# read-only snapshot
sudo btrfs subvolume snapshot -r \
    /home /.snapshots/home-$(date +%F)
sudo btrfs subvolume delete /.snapshots/home-2026-11-17
```

<!-- column: 1-->

<!-- pause -->

Typical Fedora layout (`/etc/fstab`)

```dotenv
UUID=… /     btrfs subvol=root,compress=zstd:1 0 0
UUID=… /home btrfs subvol=home,compress=zstd:1 0 0
```

<!-- pause -->

Tooling

- `snapper`, `timeshift`: automatic snapshots + rollback
- openSUSE: snapshot before and after each package transaction
- `btrfs send | btrfs receive`: incremental backups
- `cp --reflink`: instant file copies

<!-- reset_layout -->

<!-- pause -->

> ⚠️ Snapshots on the same disk are **not a backup**.

<!-- end_slide -->

System Updates
===

<!-- column_layout: [1,1] -->

<!-- column: 0-->

# Packages

```bash
sudo apt update && sudo apt upgrade     # Debian/Ubuntu
sudo dnf upgrade --refresh              # Fedora/RHEL
sudo pacman -Syu                        # Arch
```

<!-- pause -->

# Firmware: LVFS

**Linux Vendor Firmware Service**: vendors publish firmware (BIOS, SSD, docking stations) which `fwupd` installs.

```bash
fwupdmgr refresh
fwupdmgr get-devices
fwupdmgr get-updates
fwupdmgr update
```

<!-- column: 1-->

<!-- pause -->

# Safer update strategies

- **Snapshot first**, then update, roll back on failure
- **Image-based/atomic** systems: new system image is written beside the old one
  - Fedora Atomic/Silverblue: `rpm-ostree`, `bootc`
  - NixOS: `nixos-rebuild switch --rollback`
- Boot menu keeps the previous version

<!-- reset_layout -->

<!-- pause -->

> Firmware updates can change TPM measurements → re-seal (`systemd-pcrlock make-policy`) or have the recovery key ready.

<!-- end_slide -->

Mandatory Access Control: SELinux
===

<!-- column_layout: [3, 4] -->

<!-- column: 0 -->

Adds security labels (contexts) to files, processes and ports

```bash
# show context
ls -Z
ps -eZ
# get/set SELinux state
getenforce
setenforce {0,1}
```

<!-- column: 1 -->

<!-- pause -->

List and change file context / service port

```bash
sudo semanage fcontext -l
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# -m = modify, -a = append
sudo semanage port -m -t ssh_port_t -p tcp 2222
sudo semanage port -l
```

<!-- reset_layout -->

<!-- pause -->

> SELinux denies access → Check logs with `sudo journalctl -t setroubleshoot` or use `audit2allow`

<!-- pause -->

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

<!-- pause -->

# nftables

- Successor to iptables
- Single framework for IPv4, IPv6, ARP, and bridge filtering
- Uses concise syntax; replaces multiple iptables commands
- `nft list ruleset`

<!-- column: 1 -->

<!-- pause -->

# ufw

- Stands for "Uncomplicated Firewall"
- Front-end for iptables/nftables
- Simple CLI for managing rules
- Mostly used on Ubuntu/Debian
- `ufw status verbose`

<!-- pause -->

# firewalld

- Dynamic firewall manager for Linux
- Zones define network trust levels
- Works with nftables back-end
- More complex & capable than `ufw`
- Common on RHEL/Fedora
- `sudo firewall-cmd --list-all`

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

<!-- pause -->

- SysVinit is the traditional runlevel-based init using shell scripts
- BusyBox init is a minimal SysV-style variant for embedded systems
- OpenRC is a modern dependency-aware script-based init with parallel startup
- runit is a fast three-stage init with built-in service supervision
- s6/s6-rc provides a highly modular, reliability-focused supervision framework ideal for minimal and containerized systems

<!-- pause -->

> Use `ps [aux] | grep ' 1 '` to determine your init system (PID 1)

<!-- end_slide -->

Exercise
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

# Filesystems and LUKS

Use a loop file instead of a real disk:

```bash
truncate -s 256M disk.img
sudo cryptsetup luksFormat disk.img
sudo cryptsetup open disk.img lab
sudo mkfs.btrfs /dev/mapper/lab
sudo mount /dev/mapper/lab /mnt
```

1. Find the UUID with `sudo blkid disk.img`
2. Write a matching `crypttab` entry (do **not** install it)

<!-- column: 1 -->

# Snapshots

```bash
sudo btrfs subvolume create /mnt/data
echo v1 | sudo tee /mnt/data/file
sudo btrfs subvolume snapshot -r /mnt/data /mnt/snap1
echo v2 | sudo tee /mnt/data/file
```

1. Compare `/mnt/data/file` and `/mnt/snap1/file`
2. Delete the snapshot
3. Clean up: `umount`, `cryptsetup close lab`, `rm disk.img`

<!-- reset_layout -->

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
