# Fix: Persistent Browser Logins Across Desktop Environments and Window Managers

This document explains why **Brave Browser** and **Zen Browser** were logging you out whenever you switched between desktop environments (e.g., **GNOME**, **KDE Plasma**, and **Niri**), and the exact technical fixes applied to prevent this from ever happening again.

---

## 1. Root Cause Analysis

### Why Brave Was Logging You Out

1. **Chromium's Dynamic Keyring Backend (`--password-store=detect`):**
   - By default, Chromium-based browsers (including Brave) detect which desktop environment is running (`XDG_CURRENT_DESKTOP`) to determine where to store the master encryption key used for passwords and cookies.
   - **In GNOME:** Brave detects GNOME and queries **GNOME Keyring** (`gnome-libsecret`) via D-Bus.
   - **In KDE Plasma:** Brave detects KDE and queries **KWallet** (`kwallet6`/`kwallet5`) via D-Bus.
   - **In Niri:** Niri sets `XDG_CURRENT_DESKTOP="niri"`. Chromium does not recognize Niri as GNOME or KDE, falling back to basic/local storage or failing if the portal daemon isn't responsive.

2. **The Decryption Failure Cascade (`v11` Cookie Wiping):**
   - On Linux, Chromium stores cookies encrypted with AES inside `~/.config/BraveSoftware/Brave-Browser-Nightly/Default/Cookies`, prefixing values with `v11`.
   - When you log into websites (Google, GitHub, Discord, Twitter, etc.) in GNOME, your session cookies are encrypted with **GNOME Keyring's master key**.
   - When you log out and switch into KDE Plasma, Brave queries **KWallet**. KWallet provides a completely different key (or none at all).
   - Brave attempts to decrypt your cookies with the wrong key. Decryption fails.
   - **Chromium's built-in safeguard treats decryption failure as cookie corruption and automatically discards/purges the invalid cookies.**
   - Switching back to GNOME or into Niri causes the exact same failure in reverse, logging you out every single time you change environments.

3. **Desktop Entry Bypassing Flags:**
   - The desktop entry `/usr/share/applications/com.brave.Browser.nightly.desktop` executed `/usr/bin/brave-browser-nightly`, which bypassed `/usr/bin/brave-nightly` and did not load user flag configuration files (`brave-nightly-flags.conf`).

---

### Why Zen Browser Was Logging You Out

1. **Profile Mismatch in `profiles.ini` (Split / Ghost Profiles):**
   - Zen Browser (Firefox-based) uses `~/.config/zen/profiles.ini` and `installs.ini` to manage user profiles.
   - Your profile configuration had three entries:
     - `m7z8kf5u.Default Profile`: An empty, unused profile with **zero cookies and zero logins**.
     - `n9bpzq5j.Default (release)`: An older profile backup.
     - `rerf6ewk.Default (release)-1`: Your actual active profile containing **all 112 cookies, history, bookmarks, and extensions**.
   - In `profiles.ini`, the generic fallback directive `Default=1` was pointing to `m7z8kf5u.Default Profile` (the empty profile), while only the installation-hash section pointed to `rerf6ewk.Default (release)-1`.
   - When launching Zen from different environments, launchers, terminal commands (`zen-browser`), or opening links from external applications, Zen fell back to the profile marked `Default=1`.
   - As a result, Zen opened the blank profile, giving the appearance of having been completely logged out of every website.

2. **Session Termination & File Locks on Logout:**
   - When switching window managers without closing the browser first, the session manager or display manager abruptly terminates running processes.
   - SQLite WAL write-ahead log files (`cookies.sqlite-wal`) and profile lock files (`.parentlock`) left in an uncommitted state could cause Firefox/Zen to prompt to create a new profile or trigger session recovery failures on the subsequent login.

3. **Missing D-Bus & Keyring Environment in Niri:**
   - In Niri (`50-startup.kdl`), environment variables like `WAYLAND_DISPLAY`, `DISPLAY`, and `XDG_CURRENT_DESKTOP` were not being exported to systemd user services or D-Bus activation environments, which caused desktop portal calls and secret service daemons to fail or desync.

---

## 2. Changes Applied

### For Brave Browser

1. **Unified Password Store Across All Environments:**
   - Created `/home/saksham/.config/brave-nightly-flags.conf` and `/home/saksham/.config/brave-flags.conf`:
     ```text
     --password-store=basic
     ```
   - This instructs Brave to use a local, deterministic master key for its `os_crypt` engine rather than querying KWallet in Plasma or GNOME Keyring in GNOME. The key remains identical regardless of DE or WM.

2. **High-Priority Wrapper Scripts:**
   - Created `/home/saksham/.local/bin/brave-nightly` (and symlinks for `brave-browser-nightly`, `brave`, and `brave-browser`):
     - Automatically parses `~/.config/brave-nightly-flags.conf`.
     - Guarantees that `--password-store=basic` is passed to the browser binary on every execution.
     - Because `~/.local/bin` precedes `/usr/bin` in your `PATH`, any invocation from terminal or scripts uses this wrapper.

3. **Desktop Entry Overrides:**
   - Created user-level desktop entries in `~/.local/share/applications/`:
     - `brave-browser-nightly.desktop`
     - `com.brave.Browser.nightly.desktop`
   - Both point directly to `/home/saksham/.local/bin/brave-nightly %U`.
   - Package manager updates via `pacman` or `yay` will not overwrite these overrides.

---

### For Zen Browser

1. **Consolidated `profiles.ini`:**
   - Cleaned and updated `~/.config/zen/profiles.ini` (with a timestamped backup created):
     - Configured `rerf6ewk.Default (release)-1` (your active profile with all your data) as `Default=1`.
     - Linked `[Install15B76BAA26BA15E7]` to `rerf6ewk.Default (release)-1`.
     - Removed the empty dummy profile.
   - Any launch of Zen—whether through the app launcher, terminal, or via an external link click—will now resolve to your actual profile.

2. **Persistent Cookie & Session Rules (`user.js`):**
   - Created `/home/saksham/.config/zen/rerf6ewk.Default (release)-1/user.js`:
     ```javascript
     // Restore previous session tabs and windows automatically
     user_pref("browser.startup.page", 3);
     user_pref("browser.sessionstore.resume_from_crash", true);

     // Ensure cookies and active sessions are NEVER cleared automatically on shutdown
     user_pref("privacy.clearOnShutdown.cookies", false);
     user_pref("privacy.clearOnShutdown.sessions", false);
     user_pref("privacy.clearOnShutdown.offlineApps", false);
     user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

     // Keep cookies until they naturally expire
     user_pref("network.cookie.lifetimePolicy", 0);
     ```

3. **CLI Wrappers & Executables:**
   - Created `/home/saksham/.local/bin/zen` and `/home/saksham/.local/bin/zen-browser` pointing directly to `/opt/zen-browser-bin/zen-bin`.
   - You can now launch Zen directly from any terminal or runner using `zen` or `zen-browser`.

---

### For System & Window Manager Integration

1. **Niri Environment & Keyring Synchronization:**
   - Updated `/home/saksham/.config/niri/config.d/50-startup.kdl`:
     ```kdl
     // Export environment into systemd user session and D-Bus
     spawn-at-startup "bash" "-c" "dbus-update-activation-environment --systemd --all && systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_MENU_PREFIX && kbuildsycoca6 2>/dev/null || true"

     // Ensure GNOME Keyring daemon / Secret Service is running
     spawn-at-startup "bash" "-c" "/usr/bin/gnome-keyring-daemon --start --components=secrets,pkcs11 2>/dev/null || true"
     ```
   - Validated configuration using `niri validate` (passed).

2. **MIME Association Clean-up:**
   - Corrected `/home/saksham/.config/mimeapps.list` so `text/html`, `text/xml`, and `application/xhtml+xml` map to installed browsers (`brave-browser-nightly.desktop` / `zen.desktop`) rather than missing `firefox.desktop`.

---

## 3. What to Expect & Next Steps

1. **Brave Browser (One-Time Login):**
   - Because your previous session cookies in Brave were encrypted using keys from GNOME Keyring / KWallet, switching to `--password-store=basic` means you will need to **log into your accounts in Brave one final time**.
   - After this one-time login, your sessions are encrypted using the basic store and **will persist seamlessly when switching between GNOME, KDE Plasma, Niri, or any other window manager**.

2. **Zen Browser:**
   - All your tabs, history, logins, and extensions are loaded from your active profile.
   - Zen will now consistently launch into this profile regardless of which DE or runner triggers it.
   - For best results, close your browser windows before logging out or switching sessions to allow SQLite WAL files to flush cleanly.
