# BASH-WORK

A collection of Bash scripts for Linux system administration and security tasks. Built and tested for Kali Linux, using only core Bash and standard `*nix` utilities — no external dependencies.

⚠️ **Disclaimer:** These scripts are for educational purposes and authorized testing only. Only run the port scanner against systems you own or have explicit permission to test. Unauthorized scanning or monitoring of systems you don't control may be illegal.

---

## 📦 autobackup.sh

Creates a timestamped `.zip` backup of a target directory and automatically prunes old backups, keeping only the 5 most recent.

**Usage:**
```bash
./autobackup.sh /path/to/folder
```

**What it does:**
- Zips the target directory into `./backups/backup_<timestamp>.zip`
- Deletes older backups beyond the 5 most recent

---

## 🔍 portscanner.sh

A lightweight TCP port scanner using Bash's built-in `/dev/tcp` — no `nmap` or other tools required.

**Usage:**
```bash
./portscanner.sh <target_ip> <start_port> <end_port>
```

**Example:**
```bash
./portscanner.sh 192.168.1.1 20 100
```

**What it does:**
- Attempts a TCP connection to each port in the given range
- Prints which ports are open

---

## 🖥️ systeminfo.sh

Generates a one-time system report with key host details.

**Usage:**
```bash
./systeminfo.sh
```

**What it captures:**
- Hostname and OS version
- IP address(es)
- RAM usage
- Disk space usage

Output is saved to a timestamped file: `system_report_<timestamp>.txt`

---

## 📊 systeminfomonitor.sh

Continuously logs currently logged-in users at regular intervals until stopped.

**Usage:**
```bash
./systeminfomonitor.sh
```
Press `Ctrl+C` to stop.

**What it does:**
- Logs active user sessions (via `who`) every 5 seconds
- Appends entries with timestamps to `user_activity.log`

---

## Requirements

- Bash shell (Linux/Kali recommended)
- Standard utilities: `zip`, `who`, `ip`, `free`, `df`

## License

For educational use. Use responsibly and only on systems you own or are authorized to test.
