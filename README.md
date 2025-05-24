# 👚 Shell Scripts by Thomas

A curated collection of modular, reliable shell scripts for system administration, backups, password generation, and VM management. Designed for minimalism, clarity, and real-world use.

---

## 📦 Structure

```bash
.
├── userlib.sh              # Reusable library: password & user creation
├── add-user.sh             # Interactive script to add new Linux users
├── backup-home.sh          # Backup my home folder every week
├── clear-template.sh       # Clean my VM fresh templates
├── find-max-mtu.sh         # To figure out the MTU of a connection
├── fonts-cycle.sh          # Easily cycle through my favorite fonts on Kitty
├── fonts-test.sh           # Test every Nerd Font with Kitty
├── link-env.sh             # Link my dotfiles when refreshing a system
├── ozone-wayland.sh        # Change app to launch in wayland mode
├── password-generator.sh   # Generates strong passwords using userlib
├── win-vm-backup.sh        # Backup my Windows 11 VMs keeping unique ids
├── win-vm-restore.sh       # Restore from my Windows 11 VM backups
```

---

## 🔧 Highlights

### ✅ Modular design
- Core logic lives in `userlib.sh`
- Scripts can source and reuse functions easily

### ✅ Safe defaults
- Passwords auto-generated with secure, sensible rules
- TPM and NVRAM preserved for VM activation

### ✅ Prompts over assumptions
- Scripts ask only what’s needed
- Supports optional YAML input for automation (`add-user.sh`)

---

## 📘 Usage

### Create a user

```bash
./add-user.sh              # interactive
./add-user.sh user.yml     # optional YAML input
```

### Generate a password

```bash
./password-generator.sh
```

### Backup a VM (preserves activation)

```bash
./vm-backup.sh             # prompts for VM name
```

### Restore a backed-up VM

```bash
./vm-restore.sh            # prompts for VM name
```

---

## 🛡 Requirements

- `bash`
- `virsh`, `qemu-img` (for VM scripts)
- `sudo` privileges where needed

---

## 🔐 Philosophy

No bloat. No magic. Just portable, functional shell tools that do what they say.

---

