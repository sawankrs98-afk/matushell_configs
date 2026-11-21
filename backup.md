
  Here is the complete migration checklist, backup plan, and package list to transition smoothly from your current NixOS setup to Arch Linux without losing any of your data,
  configurations, or chat history.
  ──────
  ## 1. What & How to Backup (Before Wiping NixOS)
  You have ~23 GB of essential personal data, configurations, and projects across your home directory.
  ### A. Backing Up Antigravity Chats & AI Data (~/.gemini)

  Antigravity stores all chat logs, conversation summaries, session artifacts, and skills in ~/.gemini:

  • Transcripts & Artifacts: ~/.gemini/antigravity-cli/brain/
  • Session States: ~/.gemini/antigravity-cli/conversations/
  • Conversation Database: ~/.gemini/antigravity-cli/conversation_summaries.db
  • CLI History & Config: ~/.gemini/antigravity-cli/history.jsonl and ~/.gemini/config/

  Backup command:
    # Creates a compressed archive of all your Antigravity chats and skills (~1.4 GB)
    tar -czvf ~/antigravity_backup.tar.gz -C "$HOME" .gemini
  (On your new Arch install, simply extracting this back to ~/.gemini will restore every single chat and artifact).
  ──────
  ### B. MariaDB / MySQL Database (hospital_bed_db)

  Your system is currently running MariaDB with your database hospital_bed_db. Export it before wiping:
    # Dump all databases to a SQL script
    sudo mysqldump -u root -proot --all-databases > ~/mariadb_all_dbs_backup.sql
  ──────
  ### C. SSH Keys & Git Identity

    tar -czvf ~/ssh_git_backup.tar.gz -C "$HOME" .ssh .gitconfig
  ──────
  ### D. Desktop Dotfiles & Tool Configs (~/.config)

  Your key configs (Hyprland, Niri, iNiR, Kitty, Foot, Fish, Fastfetch, Matugen, Vesktop, etc.):
    tar -czvf ~/dotfiles_config_backup.tar.gz -C "$HOME" .config
  ──────
  ### E. Projects, Repositories & Documents

  Make sure to copy these folders to your external backup drive / USB:
  • ~/Documents (~4.2 GB)
  • ~/Pictures (~12 GB — wallpapers & screenshots)
  • ~/study-material & ~/leetcode
  • Git repositories: ~/matushell-hyprland, ~/dynamic-you, ~/inir, ~/caelestia-reference, ~/nix
  • Browser bookmarks: ~/brave_bookmarks.html and ~/brave_bookmarks_recovery

  │ Tip
  │ All-In-One Backup Script to an External Drive (e.g. /run/media/.../backup):
  │ 
  │   BACKUP_DIR="/path/to/your/external/usb/backup"
  │   mkdir -p "$BACKUP_DIR"
  │   
  │   # 1. Antigravity Chats
  │   tar -czf "$BACKUP_DIR/antigravity_backup.tar.gz" -C "$HOME" .gemini
  │   # 2. Database
  │   sudo mysqldump -u root -proot --all-databases > "$BACKUP_DIR/mariadb_backup.sql"
  │   # 3. Dotfiles & SSH
  │   tar -czf "$BACKUP_DIR/dotfiles_backup.tar.gz" -C "$HOME" .config .ssh .gitconfig
  │   # 4. Personal Projects & Media
  │   rsync -avh --progress ~/Pictures ~/Documents ~/study-material ~/leetcode ~/matushell-hyprland ~/dynamic-you ~/inir "$BACKUP_DIR/"
  ──────
  ## 2. Complete Arch Linux Package List
  On Arch, install an AUR helper first (yay or paru):

    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si
  ### A. Desktop Environments, Compositors & Window Managers
  • Hyprland Stack:
    sudo pacman -S hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland waybar rofi-wayland fuzzel cliphist wl-clipboard grim slurp swappy wlogout brightnessctl
    playerctl libnotify
    yay -S hyprpicker

  • Niri Stack & Shells (iNiR / DynamicYou / Matushell):
    sudo pacman -S xwayland-satellite cava jq bc imagemagick wlsunset wtype ydotool upower ffmpeg yt-dlp swaylock swayidle easyeffects
    yay -S niri matugen-bin awww gowall-bin wf-recorder libqalculate quickshell-git
  • Display Manager (SDDM) & KDE Plasma:
    sudo pacman -S sddm plasma-desktop qtsvg qt6-multimedia qt6-virtualkeyboard
    yay -S sddm-astronaut-theme

  ──────
  ### B. AI Tools & Google Antigravity
  • Antigravity GUI & CLI:
    yay -S antigravity antigravity-cli

  ──────
  ### C. Web Browsers

    sudo pacman -S firefox
    yay -S zen-browser-bin brave-bin helium-browser-bin
  ──────
  ### D. Editors & IDEs
    sudo pacman -S helix kate
    yay -S visual-studio-code-bin zed rstudio-desktop-bin
  ──────
  ### E. Terminals, Shell & Utilities

    sudo pacman -S fish starship kitty foot alacritty fastfetch btop libreoffice-fresh qbittorrent obsidian filelight
  ──────
  ### F. Programming Languages & Compilers

  • C / C++:
    sudo pacman -S gcc clang gdb lldb cmake ninja make bear valgrind pkgconf zlib openssl libffi
  • Rust:
    sudo pacman -S rustup
    rustup default stable
    rustup component add rust-analyzer clippy rustfmt

  • Java:
    sudo pacman -S jdk21-openjdk maven gradle
  • Python:
    sudo pacman -S python python-pip python-virtualenv python-pytest ipython uv

  ──────
  ### G. Media & Entertainment
    sudo pacman -S vlc haruna mgba-qt
    yay -S spotify vesktop-bin ani-cli ani-skip mov-cli
  ──────
  ### H. System Daemons & Networking

    # Sound & Audio
    sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber pavucontrol

    # Bluetooth
    sudo pacman -S bluez bluez-utils

    # Database & VPN
    sudo pacman -S mariadb tailscale
    yay -S cloudflare-warp-bin
  ──────
  ### I. Typography & Fonts

    sudo pacman -S ttf-inter ttf-nerd-fonts-symbols
    yay -S ttf-mononoki-nerd
  ──────
  ## 3. Post-Install Setup on Arch Linux

  Once packages are installed on your fresh Arch system:

  1. Restore Your Antigravity Chats:
    tar -xzvf antigravity_backup.tar.gz -C "$HOME"

  2. Restore Dotfiles & SSH:
    tar -xzvf dotfiles_backup.tar.gz -C "$HOME"
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

  3. Restore MariaDB Database:
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo systemctl enable --now mariadb
    sudo mysql < mariadb_backup.sql

  4. Enable Essential Services:
    sudo systemctl enable --now sddm
    sudo systemctl enable --now NetworkManager
    sudo systemctl enable --now bluetooth
    sudo systemctl enable --now warp-svc
    sudo systemctl enable --now tailscaled

  5. Set Fish as Default Shell:
    chsh -s $(which fish)