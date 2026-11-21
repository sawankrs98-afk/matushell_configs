# Wi-Fi Hotspot Setup & Internet Sharing Guide

## 1. Summary of What Was Done

### A. Diagnosed Hotspot Inability to Turn On (5 GHz Issue)
- **Problem**: When attempting to start a 5 GHz hotspot (`band a`), NetworkManager / `wpa_supplicant` repeatedly failed with `Failed to start AP functionality`.
- **Root Cause**: The Wi-Fi adapter (Realtek RTL8852BE, driver `rtw89_8852be`) was initialized in the default Linux World regulatory domain (`country 00: DFS-UNSET`). Under `country 00`, Linux cfg80211 enforces a strict `NO-IR` (**No Initiate Radiation**) flag across all 5 GHz frequencies. The kernel refuses to let an Access Point transmit beacons without an established country code.
- **Fix Applied**: 
  - Ran `sudo iw reg set IN` to set the regulatory domain to India (unlocking 5 GHz channels 36–48 and 149–165).
  - Made the country code permanent across reboots in `/etc/conf.d/wireless-regdom` (`WIRELESS_REGDOM="IN"`).

---

### B. Cleaned Old Hotspot Entries & Created High-Speed Profile
- **Targeted Deletion**: Filtered all NetworkManager profiles and deleted only existing Access Point (`mode: ap`) connections. Saved client Wi-Fi networks (e.g. `prajwal-hotspot`, `GARVIT 2007`, etc.) and ethernet were left completely untouched.
- **New Hotspot Profile**: Created a fresh profile named `saksham` with maximum throughput settings:
  - **SSID**: `saksham`
  - **Password**: `123456789`
  - **Band**: 5 GHz (`band a`)
  - **Channel**: 36 (5180 MHz)
  - **Channel Width**: 80 MHz (VHT80 / up to 1200 Mbps theoretical PHY rate)
  - **Security**: WPA2-PSK (AES-CCMP)
  - **IP Method**: `ipv4.method shared` (allocates `10.42.0.1/24` with built-in DHCP/DNS service)

---

### C. Diagnosed & Fixed "Connected, No Internet" on Client Phone
When your phone connected to `saksham`, it received IP `10.42.0.138` and could reach the local DNS server (`10.42.0.1:53`), but had no outbound internet connection.

#### Root Causes:
1. **Kernel IPv4 Forwarding Disabled**: 
   The kernel variable `/proc/sys/net/ipv4/ip_forward` was set to `0`. Without IP forwarding, the Linux kernel drops all packets that client devices try to route through your PC to your ethernet connection (`enp0s13f0u1c2`).
2. **Firewalld Missing Outbound NAT / Masquerade**:
   Your system uses `firewalld` (active with nftables backend). 
   - `wlan0` is placed into the `nm-shared` zone.
   - `enp0s13f0u1c2` (ethernet) is in the `public` zone.
   - By default, firewalld does not masquerade (NAT) traffic leaving `public`, nor does it permit forwarding from `nm-shared` to `public`.
3. **Kernel Update Pending Reboot**:
   Your Arch Linux system recently upgraded the kernel from `7.2.7-arch1-1` to `7.2.8-arch1-1`. Because `/lib/modules/7.2.7-arch1-1` was replaced on disk, the running kernel could not dynamically load the `nft_masq` module into the live firewall session.

#### Fixes Configured:
1. **Permanent Firewalld Rules Applied**:
   - Enabled forwarding on hotspot zone: `firewall-cmd --permanent --zone=nm-shared --add-forward`
   - Enabled NAT masquerading on internet zone: `firewall-cmd --permanent --zone=public --add-masquerade`
2. **Permanent Connection Forwarding Flag**:
   - Configured `nmcli connection modify saksham ipv4.forwarding yes`.

---

## 2. Final Step to Enable Internet Sharing

To permanently enable IP forwarding in the kernel and cleanly initialize the firewall with the updated kernel:

### Step 1: Enable IP Forwarding Permanently
Run this command in your terminal:
```bash
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/30-ipforward.conf
sudo sysctl -p /etc/sysctl.d/30-ipforward.conf
```

### Step 2: Reboot Your System
```bash
sudo reboot
```

### Why a reboot is required:
Because your package manager upgraded the Linux kernel from `7.2.7` to `7.2.8` an hour ago, rebooting boots your PC into `7.2.8`, allowing `firewalld` and `nftables` to automatically load all NAT masquerading modules at startup. Once rebooted, your phone will have full, high-speed internet access through the hotspot.

---

## 3. Quick Reference Commands

- **Start Hotspot**:
  ```bash
  nmcli connection up saksham
  ```

- **Stop Hotspot**:
  ```bash
  nmcli connection down saksham
  ```

- **Check Hotspot & Device Status**:
  ```bash
  iw dev wlan0 info
  ```

- **View Connected Devices (Phones/Laptops)**:
  ```bash
  ip neigh show dev wlan0
  ```
