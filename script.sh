#!/bin/bash
# ============================================================
# Setup — Arch Linux + Hyprland (100% Wayland)
# ============================================================
# Requisitos previos:
#   - Sistema Arch instalado con usuario creado
#   - yay instalado (se verifica al inicio)
#   - Conexión a internet activa
# ============================================================

set -euo pipefail   # salir en error, variable no definida o pipe rota

# ─────────────────────────────────────────────
# COLORES
# ─────────────────────────────────────────────
GREEN='\033[38;2;0;191;126m'
BLUE='\033[38;2;4;92;224m'
RED='\033[38;2;255;23;68m'
YELLOW='\033[38;2;252;249;73m'
NC='\033[0m'

info()    { echo -e "${BLUE}  $*${NC}"; }
ok()      { echo -e "${GREEN}✓ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠ $*${NC}"; }
error()   { echo -e "${RED}✗ $*${NC}"; exit 1; }
section() { echo -e "\n${BLUE}════════════════════════════════════════${NC}"; \
            echo -e "${BLUE}  $*${NC}"; \
            echo -e "${BLUE}════════════════════════════════════════${NC}\n"; }

# ─────────────────────────────────────────────
# VERIFICAR YAY
# ─────────────────────────────────────────────
section "Verificando requisitos"

if ! command -v yay &>/dev/null; then
    warn "yay no está instalado. Instálalo primero:"
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
fi
ok "yay disponible"

if ! ping -c1 archlinux.org &>/dev/null; then
    error "Sin conexión a internet"
fi
ok "Conexión a internet activa"

# ─────────────────────────────────────────────
# ACTUALIZAR SISTEMA
# ─────────────────────────────────────────────
section "Actualizando sistema"
sudo pacman -Syu --noconfirm
ok "Sistema actualizado"

# ─────────────────────────────────────────────
# PAQUETES DEL SISTEMA — repos oficiales
# ─────────────────────────────────────────────
section "Instalando paquetes base y herramientas"

PACMAN_PKGS=(
    # Herramientas de compilación y desarrollo base
    base-devel
    git
    curl
    wget
    unzip
    gcc
    cmake
    pkgconf
    openssl
    usbutils
    uwsm

    # Lenguajes de programación
    rust
    go
    python
    pyright
    ruff
    python-pylint
    jdk-openjdk

    # Gestores de paquetes Node
    pnpm
    fnm

    # Herramientas modernas de terminal (reemplazan las clásicas)
    ripgrep       # reemplaza grep
    bat           # reemplaza cat
    fd            # reemplaza find
    eza           # reemplaza ls
    dust          # reemplaza du
    bottom        # reemplaza htop/top
    starship      # prompt
    fastfetch     # info del sistema
    yazi          # explorador de archivos en terminal
    helix         # editor modal moderno
	  glow          # render de markdown en la terminal
    wine          # emualdor de programas para windows 
	  wine-gecko
 
    # Editores adicionales
    nano          # editor básico en terminal
    vim           # editor modal clásico

    # Fuentes y configuración de fuentes
    fontconfig

    # Sistema y red
    openssh
    network-manager-applet
    lxqt-policykit
    nftables
    uv            # reemplaza pip+virtualenv para Python moderno
    xdg-utils       # utilidades estándar XDG (abrir archivos, URLs, etc)
    xdg-user-dirs   # crea directorios estándar del usuario
    smartmontools   # monitorización de salud del disco (S.M.A.R.T)
    cryptsetup      # cifrado de disco LUKS
    lvm2            # gestor de volúmenes lógicos

    # Seguridad
    lynis
    rkhunter

    # Contenedores
    podman
    podman-compose

    # Terminal gráfica
    alacritty

    # Wayland — compositor y herramientas
    hyprland
    hyprpaper
    waybar
    rofi-wayland
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt6-wayland
    wl-clipboard     # portapapeles Wayland (reemplaza xclip)
    cliphist         # historial de portapapeles Wayland
    swww             # wallpapers animados Wayland (reemplaza feh)
    dunst            # notificaciones (compatible Wayland)
    brightnessctl
    pavucontrol
    acpi
    wayland            # protocolo de display moderno
    wayland-protocols  # protocolos extendidos de Wayland
    grim               # captura de pantalla Wayland
    slurp              # selección de región en pantalla
	iw                 # herramienta moderna para gestión WiFi de bajo nivel

    # Audio — PipeWire stack completo
    pipewire
    pipewire-pulse
    wireplumber

    # Aplicaciones gráficas
    mpv
    imv
    nemo
    keepassxc
    firefox
    obsidian
    nvim
    strawberry       # reproductor de música
    libreoffice-still
    evince

    # Configurador de apariencia
    nwg-look

    # Compresión
    p7zip

    # Shell
    zsh
)

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "Paquetes base instalados"

# ─────────────────────────────────────────────
# PAQUETES AUR
# ─────────────────────────────────────────────
section "Instalando paquetes AUR"

AUR_PKGS=(
    rofi-wayland          # lanzador nativo Wayland (reemplaza rofi X11)
    hyprlock              # pantalla de bloqueo Wayland
    hypridle              # gestor de inactividad
    grimblast-git         # screenshots para Hyprland
    hyprpicker            # selector de color Wayland
    bibata-cursor-theme   # tema de cursor
    ttf-hack-nerd
    ttf-jetbrains-mono-nerd
    ttf-iosevka-nerd
    ttf-firacode-nerd
    brave-bin
    luv-icon-theme
    oranchelo-icon-theme
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"
ok "Paquetes AUR instalados"

# ─────────────────────────────────────────────
# CREAR DIRECTORIOS
# ─────────────────────────────────────────────
section "Creando estructura de directorios"

mkdir -p \
    ~/.config/alacritty \
    ~/.config/hypr \
    ~/.config/hypr/scripts \
    ~/.config/waybar/scripts \
    ~/.config/rofi \
    ~/.config/helix \
    ~/.config/helix/themes \
    ~/.config/fastfetch \
    ~/.local/share/fonts \
    ~/Scripts \
    ~/Imágenes/screenshots \
    ~/Wallpapers \
    ~/.config/bin

ok "Directorios creados"

# ─────────────────────────────────────────────
# INSTALAR OH MY ZSH
# ─────────────────────────────────────────────
# NOTA: se instala ANTES de escribir .zshrc para que
# KEEP_ZSHRC=yes preserve el archivo que escribiremos después
# ─────────────────────────────────────────────
section "Instalando Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # RUNZSH=no  → no lanza zsh al terminar (evita colgar el script)
    # KEEP_ZSHRC=yes → no sobreescribe .zshrc (lo escribimos nosotros después)
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh instalado"
else
    warn "Oh My Zsh ya está instalado — omitiendo"
fi

# ─────────────────────────────────────────────
# PLUGINS DE ZSH
# ─────────────────────────────────────────────
section "Instalando plugins de Zsh"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_plugin() {
    local name="$1"
    local url="$2"
    local dir="$3"
    if [ ! -d "$dir" ]; then
        git clone --depth=1 "$url" "$dir"
        ok "$name instalado"
    else
        warn "$name ya existe — omitiendo"
    fi
}

install_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

install_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

install_plugin "fast-syntax-highlighting" \
    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" \
    "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting"

install_plugin "zsh-autocomplete" \
    "https://github.com/marlonrichert/zsh-autocomplete.git" \
    "${ZSH_CUSTOM}/plugins/zsh-autocomplete"

# ─────────────────────────────────────────────
# CAMBIAR SHELL A ZSH
# ─────────────────────────────────────────────
section "Configurando Zsh como shell por defecto"

ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH"
    ok "Shell cambiado a Zsh (efectivo al cerrar sesión)"
else
    warn "Zsh ya es el shell por defecto"
fi

# ─────────────────────────────────────────────
# INSTALAR NODE.JS VIA FNM
# ─────────────────────────────────────────────
#section "Instalando Node.js LTS via fnm"

#if command -v fnm &>/dev/null; then
#    export FNM_DIR="${FNM_DIR:-$HOME/.local/share/fnm}"
#    eval "$(fnm env)"
#    fnm install --lts
#    fnm use --lts
#    ok "Node.js instalado: $(node --version 2>/dev/null || echo 'requiere reiniciar shell')"
#else
#    warn "fnm no encontrado — Node.js no instalado"
#fi

# ─────────────────────────────────────────────
# ACTUALIZAR CACHÉ DE FUENTES
# ─────────────────────────────────────────────
section "Actualizando caché de fuentes"
fc-cache -fv > /dev/null 2>&1
ok "Caché de fuentes actualizado"

# ════════════════════════════════════════════════════════════
# ARCHIVOS DE CONFIGURACIÓN
# ════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# STARSHIP
# ─────────────────────────────────────────────
section "Escribiendo configuración de Starship"

cat > ~/.config/starship.toml << 'STARSHIP_EOF'
# ================================================
# STARSHIP - Configuración Moderna v5
# ================================================
palette = "themes"

format = """
[](bold custom_violet)\
$os\
$localip\
[  ](bold blue)\
[ ](bold vino)\
[ ](bold custom_orange)\
$username\
$directory\
$git_branch\
$git_commit\
$git_state\
$git_metrics\
$git_status\
$package\
$bun\
$golang\
$rust\
$nodejs\
$python\
$php\
$java\
$lua\
$ruby\
$c\
$custom\
$docker_context\
$container\
$kubernetes\
$terraform\
$aws\
$line_break\
$jobs\
[](bold purple)[$character](bold italic lime_green) """

right_format = """
$memory_usage\
$cmd_duration\
$shell\
$status\
"""
# ════════════════════════════════════════════════
# USUARIO Y NOMBRE DEL HOST
# ════════════════════════════════════════════════
[localip]
ssh_only = false
format = "[󰒍 $localipv4]($style)"
style = "bold fg:text_two"
disabled = false 

[username] 
format = "[$user ]($style)"
style_user = "italic fg:custom_sudo_red bg:None"
style_root = "italic bold fg:custom_sudo_red" 
show_always = true

[hostname] 
ssh_only = false
format = "[ $hostname ]($style)"
style = "italic fg:text_two bg:None"
ssh_symbol = "󰣀 SSH » "  # Indicador visual cuando estás en SSH
trim_at = "."

# Variables de entorno para información adicional
[env_var.SSH_CONNECTION]
format = "[ 󰒍 REMOTE]($style) "
style = "bold bg:red fg:yellow"
variable = "SSH_CONNECTION"
default = ""

# Símbolo del prompt diferente para root
[character]
success_symbol = "[ ](bold blue_sky)"
error_symbol = "[ ](bold red)"
vimcmd_symbol = "[ ](bold magenta)"
vimcmd_replace_one_symbol = "[ ](bold purple)"
vimcmd_replace_symbol = "[ ](bold purple)"
vimcmd_visual_symbol = "[ ](bold yellow)"

# ════════════════════════════════════════════════
# SISTEMA OPERATIVO
# ════════════════════════════════════════════════

[os]
format = "[$symbol](bold bg:None fg:dark_brown)"
disabled = false

[os.symbols]
Alpine = " "
AlmaLinux = " "
Amazon = " "
Android = " "
Arch = "󰣇 "
Artix = " "
CentOS = " "
Debian = " " 
Fedora = " "
FreeBSD = " "
Garuda = "󰛓 "
Gentoo = "󰣨 "
Kali = " "
Linux = " "
Macos = " "
Manjaro = " "
Mint = "󰣭 "
NixOS = " "
OpenBSD = "󰈺 "
openSUSE = " "
Pop = " "
Raspbian = " "
Redhat = "󱄛 "
RedHatEnterprise = "󱄛 "
RockyLinux = " "
SUSE = "  "
Ubuntu = "󰕈 "
Unknown = " "
Windows = "󰍲 "

# ════════════════════════════════════════════════
# DIRECTORIO
# ════════════════════════════════════════════════

[directory]
format = "[(bold purple)$path ](bold custom_green)[$read_only]($read_only_style)"
style = "italic fg:blue"
read_only = "󰦝 "
read_only_style = "fg:magenta"
truncation_length = 4
truncate_to_repo = true
truncation_symbol = "󱦟 "
home_symbol = " "

[directory.substitutions]
"/" = "/"
"Documentos" = "Documentos 󱪙 "
"Desktop" = "Desktop 󱪙 "
"Documents" = "Documents 󱪙 "
"Descargas" = "Descargas   "
"Downloads" = "Downloads   "
"Música" = "Musica 󰋌 "
"Músic" = "Music 󰋌 "
"Imágenes" = "Imágenes  " 
"Wallpapers" = "Wallpapers 󰸉 " 
"Vídeos" = "Vídeos 󰍫 "
"Proyectos" = "Proyectos 󰲋 "
"Code" = " Codigos 󱃖 "
"Scripts" = "Scripts 󰯂 "
".config" = "Configuracion  "

# ════════════════════════════════════════════════
# GIT - Sistema completo
# ════════════════════════════════════════════════

[git_branch]
format = "[󰊢 on $branch(:$remote_branch)]($style) "
style = "italic fg:green_alacrity"
symbol = " 󰊢 "

[git_commit]
format = "[\\($hash$tag\\)]($style) "
style = "inverted fg:green_alacrity"
only_detached = true
tag_disabled = false
tag_symbol = " 󰓹 "

[git_state]
format = "[󰊢 $state($progress_current/$progress_total)] "
style = "bold inverted fg:yellow"
rebase = " REBASING"
merge = " MERGING"
revert = "󰌥 REVERTING"
cherry_pick = " CHERRY-PICKING"
bisect = " BISECTING"

[git_status]
format = '([$all_status$ahead_behind]($style))'
style = "italic fg:yellow"
conflicted = "󱃞 conflicted"
ahead = " ahead ${count} "
behind = " behind ${count} "
diverged = " diverged ${ahead_count}⇣${behind_count} "
untracked = "󰺴 untracked ${count} "
stashed = " stashed ${count} "
modified = " modified ${count} "
staged = " staged ${count} "
renamed = " renamed ${count} "
deleted = "󰗨 deleted ${count} "

[git_metrics]
format = "([ +$added ]($added_style))([-$deleted ]($deleted_style))"
added_style = "italic fg:green_alacrity"
deleted_style = "italic fg:red"
disabled = false

# ════════════════════════════════════════════════
# LENGUAJES DE PROGRAMACIÓN
# ════════════════════════════════════════════════

[rust]
format = "[ in $symbol$version]($style)"
style = "bold fg:orange"
symbol = "󱘗 "

[bun]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:custom_light_red"
detect_files = ["bun.lock"]
detect_extensions = ["ts", "tsx"]

[nodejs]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:green "

[python]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:yellow"
pyenv_version_name = true
detect_extensions = ["py"]
detect_files = ["requirements.txt", ".python-version", "pyproject.toml"]

[php]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:purple"

[java]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:custom_java_red"

[golang]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:blue_sky"

[lua]
format = "[ in $symbol$version]($style)"
symbol = " "
style = "bold fg:medium_gray"

[custom.sh]
command = "bash --version | head -n1 | awk '{print $4}' | cut -d'(' -f1"
format = "[ in $symbol$output]($style)"
symbol = " "
style = "bold fg:custom_light_red"
when = "ls *.sh 2>/dev/null"

[ruby]
format = "[in $symbol$version]"
symbol = " "
style = "bold fg:red"
detect_extensions = ["rb"]
detect_files = ["Gemfile", ".ruby-version"]

[c]
format = "[in $symbol$version]"
symbol = " "
style = "bold fg:blue"
detect_extensions = ["c", "h", "cpp"]

# ════════════════════════════════════════════════
# GESTORES DE PAQUETES
# ════════════════════════════════════════════════

[package]
format = "[is $symbol$version ]($style)"
symbol = "󰏖 "
style = "italic fg:cyan"

# ════════════════════════════════════════════════
# CONTENEDORES & INFRAESTRUCTURA
# ════════════════════════════════════════════════

#[docker_context]
#format = "[in $symbol$version]($style)"
#symbol = "  "
#style = "bold fg:blue_sky"
#only_with_files = false
#disabled = false

[custom.dockerfiles]
command = "docker --version | awk '{print $3}' | tr -d ','"
when = "test -f Dockerfile || test -f docker-compose.yml || test -f docker-compose.yaml || test -f .dockerignore || test -f compose.yml || test -f compose.yaml "
format = "[ in $symbol$output]($style)"
symbol = "  "
style = "bold fg:blue_sky"


[container]
format = "[ in $symbol \\[$name\\]]"
symbol = "  "
style = "bold fg:magenta"

[kubernetes]
format = "[ in 󱃾 $context \\($namespace\\)"
style = "bold fg:cyan"
disabled = false

[terraform]
format = "[in $symbol$workspace]"
symbol = "󱁢 "
style = "bold fg:purple "

# ════════════════════════════════════════════════
# RENDIMIENTO
# ════════════════════════════════════════════════

[cmd_duration]
format = "[ took $duration ]($style)"
style = "italic fg:yellow"
min_time = 500
show_milliseconds = true

[jobs]
format = "[ $symbol$number ]($style)"
symbol = " "
style = "bold blue"
number_threshold = 1
symbol_threshold = 1

[memory_usage]
format = "[in $symbol$ram_pct]($style)"
symbol = "󰍛 "
style = "magenta"
threshold = 75
disabled = false

# ════════════════════════════════════════════════
# ESTADO DEL SISTEMA
# ════════════════════════════════════════════════

[status]
format = "[$symbol$status($signal_name)]($style)"
symbol = "  "
success_symbol = "  "
success_style = "fg:green_alacrity"
not_executable_symbol = "  "
not_found_symbol = " 󱙔 "
sigint_symbol = " 󰟾 "
signal_symbol = "  "
disabled = false

[sudo]
format = "[as $symbol]"
symbol = "  "
style = "bold italic red"
disabled = false

[battery]
format = "[$symbol$percentage]($style) "
disabled = false

[[battery.display]]
threshold = 10
style = "bold red"
charging_symbol = " 󱊥 "
discharging_symbol = " 󰂎 "

[[battery.display]]
threshold = 30
style = "bold yellow"
discharging_symbol = " 󰁼 "

[[battery.display]]
threshold = 100
style = "bold green"
discharging_symbol = " 󰁹 "

# ════════════════════════════════════════════════
# EXTRAS
# ════════════════════════════════════════════════

[time]
format = "[at $time]"
style = "bold green"
disabled = true
time_format = "%T"

[line_break]
disabled = false

[shell]
format = "[$indicator]"
bash_indicator = "bsh"
fish_indicator = "fsh"
zsh_indicator = "zsh"
powershell_indicator = "psh"
style = "bold custom_magenta"
disabled = true

[shlvl]
format = "[$symbol$shlvl]"
symbol = "↕️"
style = "bold custom_yellow"
threshold = 2
disabled = false

# ════════════════════════════════════════════════
# 🎨 PALETA DE COLORES PERSONALIZADA
# IMPORTANTE: Debe estar AL FINAL del archivo
# Los nombres deben ser en minúsculas con guiones bajos
# ════════════════════════════════════════════════

[palettes.themes]
# Colores personalizados de tu config original
custom_pink = "#ff79c6"
custom_purple = "#400191"
custom_red = "#ff1744"
custom_lavender = "#9d80c2"
custom_deep_purple = "#400181"
custom_gray = "#262324"
custom_green = "#00bf7e"
custom_dark_green = "#112e22"
custom_yellow = "#fcf949"
custom_brown = "#331301"
custom_orange = "#ff6e40"
custom_blue = "#045ce0"
custom_aqua = "#00add8"
custom_dark_red = "#c90202"
custom_light_red = "#faafbd"
custom_dark_blue = "#1b0d2e"
custom_cyan = "#0db7ed"
custom_magenta = "#ff00ff"
custom_violet = "#5c0691"
custom_aws_color = "#ff9900"
custom_light_pink = "#fbbbc6"
custom_dark_purple = "#8892bf"
custom_java_red = "#FF1023"
custom_sudo_red = "#ed0543"
custom_battery_green = "#02E358"

# Colores estándar adicionales
blue_sky = "#1E90FF"
cyan = "#00CED1"
indigo = "#1C247F"
deep_purple = "#301B94"
blue = "#1047A3"
teal_sky = "#14B8A6"
dark_gray = "#4A4A4A"
light_gray = "#A9A9A9"
medium_gray = "#6B7280"
sky_gray = "#212121"
pink = "#EC4899"
magenta = "#ff00ff"
coral = "#ff8ba7"
text_one = "#33272a"
red_sky = "#EF4444"
orange = "#FC6F03"
red = "#B61D1E"
green = "#4ADE80"
green_alacrity = "#02E358"
lime_green = "#84CC16"
dark_green = "#1F5F21"
yellow_green = "#BEF264"
teal = "#034E3F"
olive = "#81771A"
purple = "#4A158D"
sky_purple = "#0f0e17"
text_two = "#ff8906"
lavender = "#A78BFA"
yellow = "#FBBF24"
amber = "#EE811A"
dark_brown = "#078080"

STARSHIP_EOF

ok "Starship configurado"

# ─────────────────────────────────────────────
# HYPRLAND
# ─────────────────────────────────────────────
section "Escribiendo configuración de Hyprland"

cat > ~/.config/hypr/hyprland.conf << 'EOF'
# ─────────────────────────────────────────────
#  MONITOR
# ─────────────────────────────────────────────
# Cambia "eDP-1" por el monitor real (usa `hyprctl monitors` para verlo)
monitor=,preferred,auto,1

# ─────────────────────────────────────────────
#  AUTOSTART
# ─────────────────────────────────────────────
exec-once = waybar
exec-once = hyprpaper
exec-once = lxqt-policykit-agent
exec-once = dunst
exec-once = hypridle
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

exec = gsettings set org.gnome.desktop.interface gtk-theme "Manhattan-Dark"
# ─────────────────────────────────────────────
#  VARIABLES DE ENTORNO
# ─────────────────────────────────────────────
env = XCURSOR_SIZE,20
env = XCURSOR_THEME,Bibata-Modern-Classic
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = GTK_THEME,Manhattan

# ─────────────────────────────────────────────
#  APARIENCIA GENERAL
# ─────────────────────────────────────────────
general {
    gaps_in = 3
    gaps_out = 5
    
    border_size = 0 
 
    # Colores 
    col.active_border   = rgb(cf09f7) 
    col.inactive_border = rgb(313244)

    layout = dwindle
    allow_tearing = false
}

# ─────────────────────────────────────────────
#  DECORACIÓN (esquinas, blur, sombras)
# ─────────────────────────────────────────────
decoration {
    rounding = 3

    blur {
        enabled = true
        size = 2
        passes = 2
        new_optimizations = true
        xray = false
        noise = 0.02
        contrast = 5
        brightness = 0.3
        popups = true
    }


    active_opacity   = 0.97
    inactive_opacity = 0.8 
    fullscreen_opacity = 1 

    dim_inactive = true
    dim_strength = 0.8
}

# ─────────────────────────────────────────────
#  ANIMACIONES
# ─────────────────────────────────────────────
animations {
    enabled = true

    bezier = myBezier,  0.05, 0.9, 0.1, 1.05
    bezier = smoothOut,  0.36, 0, 0.66, -0.56
    bezier = smoothIn,   0.25, 1, 0.5, 1
    bezier = overshot,   0.13, 0.99, 0.29, 1.1
    bezier = linear,     0.0, 0.0, 1.0, 1.0

    animation = windows,     1, 4,  overshot,  slide
    animation = windowsOut,  1, 3,  smoothOut, slide
    animation = windowsMove, 1, 3,  smoothIn,  slide
    animation = border,      1, 8, default
    animation = borderangle, 1, 26, linear,    loop
    animation = fade,        1, 4,  smoothIn
    animation = fadeOut,     1, 3,  smoothOut
    animation = workspaces,  1, 5,  overshot,  slidevert
}

# ─────────────────────────────────────────────
#  LAYOUT DWINDLE (similar a i3)
# ─────────────────────────────────────────────
dwindle {
    pseudotile = true
    preserve_split = true
    smart_split = true
    smart_resizing = true
}

# ─────────────────────────────────────────────
#  INPUT
# ─────────────────────────────────────────────
input {
    kb_layout = latam          # Cambia a tu layout: us, es, latam...
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    sensitivity = 0

    touchpad {
        natural_scroll = true
        disable_while_typing = true
        tap-to-click = true
        scroll_factor = 0.8
    }
}

# ─────────────────────────────────────────────
#  GESTOS (touchpad)
# ─────────────────────────────────────────────
gestures {
    workspace_swipe_distance = 300
    workspace_swipe_invert = true
    workspace_swipe_min_speed_to_force = 30
    workspace_swipe_cancel_ratio = 0.5
}

# ─────────────────────────────────────────────
#  MISCELÁNEOS
# ─────────────────────────────────────────────
misc {
    force_default_wallpaper = 0
    disable_hyprland_logo = true
    disable_splash_rendering = true
    animate_manual_resizes = true
    animate_mouse_windowdragging = true
    enable_swallow = true
    swallow_regex = ^(alacritty|kitty|foot)$
    focus_on_activate = true
    vfr = true
}

# ─────────────────────────────────────────────
#  KEYBINDINGS
# ─────────────────────────────────────────────
$mod = SUPER

# Apps principales
bind = $mod, Return,      exec, alacritty
bind = $mod, D,           exec, rofi -show drun
bind = $mod, E,           exec, nemo
bind = $mod, W,           exec, firefox
bind = $mod, B,           exec, brave
bind = $mod SHIFT, S,     exec, grimblast copysave area ~/Imágenes/screenshots/$(date +%Y%m%d_%H%M%S).png       # screenshot region
bind = $mod ,Print,       exec, grimblast copysave screen ~/Imágenes/screenshots/$(date +%Y%m%d_%H%M%S).png    # screenshot full
bind = $mod SHIFT, C,     exec, hyprpicker -a             # color picker

# Control de ventanas (igual que i3)
bind = $mod, Q,           killactive
bind = $mod SHIFT, Q,     exit
bind = $mod, F,           fullscreen
bind = $mod SHIFT, F,     togglefloating
bind = $mod, P,           pseudo
bind = $mod, J,           togglesplit
bind = $mod, L,           exec, libreoffice
bind = $mod, U,           exec, strawberry

bind = $mod, X,             exec, hyprlock
bind = $mod, M, exec, alacritty --class yazi -e yazi
bind = $mod, K, exec, ~/.config/hypr/scripts/yazi-helix.sh

# Power menu
bind = $mod SHIFT, E,     exec, ~/.config/wofi/powermenu.sh

# Foco entre ventanas (hjkl o flechas)
bind = $mod, left,        movefocus, l
bind = $mod, right,       movefocus, r
bind = $mod, up,          movefocus, u
bind = $mod, down,        movefocus, d
bind = $mod, H,           movefocus, l
bind = $mod, L,           movefocus, r
bind = $mod, K,           movefocus, u
bind = $mod, J,           movefocus, d

# Mover ventanas
bind = $mod SHIFT, left,  movewindow, l
bind = $mod SHIFT, right, movewindow, r
bind = $mod SHIFT, up,    movewindow, u
bind = $mod SHIFT, down,  movewindow, d
bind = $mod SHIFT, H,     movewindow, l
bind = $mod SHIFT, L,     movewindow, r
bind = $mod SHIFT, K,     movewindow, u
bind = $mod SHIFT, J,     movewindow, d

# Redimensionar ventanas
binde = $mod CTRL, left,     resizeactive, -40 0
binde = $mod CTRL, right,     resizeactive,  40 0
binde = $mod CTRL, up,     resizeactive, 0 -40
binde = $mod CTRL, down,     resizeactive, 0  40

# Workspaces 1-9
bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod, 6, workspace, 6
bind = $mod, 7, workspace, 7
bind = $mod, 8, workspace, 8
bind = $mod, 9, workspace, 9
bind = $mod, 0, workspace, 10

# Mover ventana a workspace
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
bind = $mod SHIFT, 6, movetoworkspace, 6
bind = $mod SHIFT, 7, movetoworkspace, 7
bind = $mod SHIFT, 8, movetoworkspace, 8
bind = $mod SHIFT, 9, movetoworkspace, 9
bind = $mod SHIFT, 0, movetoworkspace, 10

# Scroll por workspaces
bind = $mod, mouse_down, workspace, e+1
bind = $mod, mouse_up,   workspace, e-1

# Mouse drag
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow

# Media keys
bind = , XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86MonBrightnessUp,   exec, brightnessctl set 5%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# ─────────────────────────────────────────────
#  REGLAS DE VENTANAS (
# ─────────────────────────────────────────────

# Flotación
windowrule = float on, match:class pavucontrol
windowrule = float on, match:class nm-connection-editor
windowrule = float on, match:title Picture-in-Picture
windowrule = float on, match:title Open File
windowrule = float on, match:title Save File

# Tamaño y posición (se pueden combinar en una sola línea)
windowrule = size 800 500, match:class pavucontrol
windowrule = center on, match:class pavucontrol

# Opacidad (formato: activa inactive)
windowrule = opacity 0.90 0.90, match:class alacritty
windowrule = opacity 0.95 1, match:class thunar

# Reglas de yaxi 
windowrule = float on, match:class yazi
windowrule = size 80% 80%, match:class yazi
windowrule = center on, match:class yazi
EOF

ok "hyprland.conf escrito"

# ─────────────────────────────────────────────
# HYPRLAND SCRIPTS
# ─────────────────────────────────────────────
cat > ~/.config/hypr/scripts/yazi-helix.sh << 'EOF'
#!/bin/bash
HELIX_PID=$(pgrep -x helix | head -1)
if [ -n "$HELIX_PID" ]; then
    HELIX_CWD=$(readlink -f /proc/$HELIX_PID/cwd)
    alacritty --class yazi -e bash -c "cd '$HELIX_CWD' && yazi"
else
    alacritty --class yazi -e yazi
fi
EOF
chmod +x ~/.config/hypr/scripts/yazi-helix.sh

# ─────────────────────────────────────────────
# HYPRPAPER — formato correcto
# ─────────────────────────────────────────────
cat > ~/.config/hypr/hyprpaper.conf << 'EOF'
preload = ~/Wallpapers/wallpaper.png
wallpaper = ,~/Wallpapers/wallpaper.png
splash = false
EOF

# ─────────────────────────────────────────────
# HYPRIDLE
# ─────────────────────────────────────────────
cat > ~/.config/hypr/hypridle.conf << 'EOF'
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

# Bajar brillo a los 3 min
listener {
    timeout = 180
    on-timeout = brightnessctl -s set 20%
    on-resume = brightnessctl -r
}

# Apagar pantalla a los 5 min
listener {
    timeout = 300
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}

# Bloquear a los 10 min
listener {
    timeout = 600
    on-timeout = loginctl lock-session
}

# Suspender a los 30 min
listener {
    timeout = 1800
    on-timeout = systemctl suspend
}
EOF

# ─────────────────────────────────────────────
# HYPRLOCK
# ─────────────────────────────────────────────
cat > ~/.config/hypr/hyprlock.conf << 'EOF'
# hyprlock.conf
# ─────────────────────────────────────────────
general {
    disable_loading_bar = true
    grace = 2
    hide_cursor = true
    no_fade_in = false
}

background {
    monitor =
    color = rgba(1e1e2eee)
    blur_passes = 3
    blur_size = 5
    brightness = 0.8
    contrast = 0.8
}

input-field {
    monitor =
    size = 280, 52
    outline_thickness = 2
    dots_size = 0.33
    dots_spacing = 0.15
    dots_center = true
    outer_color = rgba(89b4facc)
    inner_color = rgba(1e1e2ecc)
    font_color  = rgb(cdd6f4)
    fade_on_empty = true
    placeholder_text = <i>Contraseña...</i>
    position = 0, -120
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "<b>$(date +"%H:%M:%S")</b>"
    color = rgba(89b4faee)
    font_size = 50
    font_family = JetBrainsMono Nerd Font Bold
    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:60000] echo "$(date +"%A, %d de %B de %Y")"
    color = rgba(cdd6f4cc)
    font_size = 18
    font_family = JetBrainsMono Nerd Font
    position = 0, 0
    halign = center
    valign = center
}
EOF

ok "Configuraciones de Hyprland escritas"

# ─────────────────────────────────────────────
# WAYBAR
# ─────────────────────────────────────────────
section "Escribiendo configuración de Waybar"

cat > ~/.config/waybar/config.jsonc << 'EOF'
{
  "layer": "top",
  "position": "top",
  "height": 32,
  "spacing": 2,
  "margin-top": 2,
  "margin-left": 6,
  "margin-right": 6,

  "modules-left": [
    "custom/logo",
    "clock",
    "network#interface",
    "cpu",
    "memory"
  ],

  "modules-center": ["hyprland/workspaces"],

  "modules-right": [
    "disk",
    "temperature",
    "battery",
    "pulseaudio",
    "custom/powermenu"
  ],

  // ─── LEFT ───────────────────────────────────────────

  "custom/logo": {
    "format": "",
    "tooltip": false
  },

  "hyprland/workspaces": {
    "format": "{icon}",
    "on-click": "activate",
    "on-scroll-up": "hyprctl dispatch workspace e+1",
    "on-scroll-down": "hyprctl dispatch workspace e-1",
    "format-icons": {
      "1": "󰲠",
      "2": "󰲢",
      "3": "󰲤",
      "4": "󰲦",
      "5": "󰲨",
      "6": "󰲪",
      "7": "󰲬",
      "8": "󰲮",
      "9": "󰲰",
      "10": "󰿬",
      "urgent": "",
      "active": "󰊠",
      "default": "○"
    },
    "persistent-workspaces": {
      "*": [1, 2, 3]
    }
  },

  "hyprland/window": {
    "format": "󰖯  {}",
    "max-length": 40,
    "separate-outputs": true,
    "rewrite": {
      "(.*) — Mozilla Firefox": "󰈹 $1",
      "(.*) - Visual Studio Code": " $1",
      "(.*)Alacritty(.*)": " Terminal"
    }
  },

  // ─── CENTER ─────────────────────────────────────────

  "clock": {
    "interval": 1,
    "format": "󰅐 {:%H:%M}",
    "format-alt": "󰃭 {:%A, %d %B %Y}",
    "tooltip-format": "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>",
    "on-click": "toggle-format"
  },

  // ─── RIGHT ──────────────────────────────────────────

  "custom/ssh": {
    "exec": "~/.config/waybar/scripts/ssh_monitor.sh",
    "interval": 5,
    "format": "{}",
    "tooltip": true,
    "return-type": "json"
  },

  "network#interface": {
    "format-ethernet": "󰈀 {ifname}",
    "format-wifi": "󰖩 {ifname}",
    "format-disconnected": "󰖪 ----",
    "tooltip-format-ethernet": "Interfaz: {ifname}\nIP: {ipaddr}/{cidr}\nGateway: {gwaddr}",
    "tooltip-format-wifi": "SSID: {essid}\nIP: {ipaddr}/{cidr}\nSeñal: {signalStrength}%\nFrecuencia: {frequency} GHz",
    "on-click": "nm-connection-editor"
  },

  "network#speed": {
    "format-ethernet": "{bandwidthUpBytes} {bandwidthDownBytes}",
    "format-wifi": "{bandwidthUpBytes} {bandwidthDownBytes}",
    "format-disconnected": "",
    "interval": 2,
    "tooltip": false
  },

  "cpu": {
    "interval": 2,
    "format": "󰍛 {usage}%",
    "format-alt": "󰍛 {avg_frequency} GHz",
    "on-click": "alacritty -e btop",
    "tooltip-format": "Uso: {usage}%\nFrecuencia: {avg_frequency} GHz\nCarga: {load}",
    "states": {
      "warning": 70,
      "critical": 90
    }
  },

  "memory": {
    "interval": 2,
    "format": "󰾆 {used:0.1f}G/{total:0.1f}G",
    "format-alt": "󰾆 {percentage}%",
    "on-click": "alacritty -e btop",
    "tooltip-format": "RAM: {used:0.1f} / {total:0.1f} GiB ({percentage}%)\nSwap: {swapUsed:0.1f} / {swapTotal:0.1f} GiB",
    "states": {
      "warning": 70,
      "critical": 90
    }
  },

  "disk": {
    "interval": 30,
    "format": "󰋊 {specific_used:0.0f}G/{specific_total:0.0f}G",
    "unit": "GB",
    "path": "/",
    "on-click": "alacritty -e df -h",
    "tooltip-format": "Ruta: {path}\nUsado: {specific_used:0.0f}G ({percentage_used}%)\nLibre: {specific_free:0.0f}G\nTotal: {specific_total:0.0f}G",
    "states": {
      "warning": 70,
      "critical": 90
    }
  },

  "temperature": {
    "critical-threshold": 80,
    "interval": 4,
    "format": "{icon} {temperatureC}°C",
    "format-critical": "󰈸 {temperatureC}°C",
    "format-icons": ["󱃃", "󰔏", "󱃂"],
    "tooltip-format": "Temperatura: {temperatureC}°C"
  },

  "battery": {
    "interval": 30,
    "states": {
      "good": 95,
      "warning": 30,
      "critical": 15
    },
    "format": "{icon} {capacity}%",
    "format-charging": "󰂄 {capacity}%",
    "format-plugged": "󰚥 {capacity}%",
    "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
    "tooltip-format": "{timeTo}\nCiclos de carga: {cycles}"
  },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰝟 {volume}%",
    "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +5%",
    "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -5%",
    "on-click": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
    "format-icons": {
      "default": ["󰕿", "󰖀", "󰕾"]
    },
    "tooltip-format": "Volumen: {volume}%"
  },

  "custom/powermenu": {
    "format": " ",
    "on-click": "~/.config/rofi/powermenu.sh",
    "tooltip": false
  }
}
EOF

# ─────────────────────────────────────────────
# WAYBAR STYLE
# ─────────────────────────────────────────────
cat > ~/.config/waybar/style.css << 'EOF'
/* ═══════════════════════════════════════════
   WAYBAR 
   ═══════════════════════════════════════════ */

@define-color base   #0c001c;
@define-color mantle #181825;
@define-color crust  #11111b;
@define-color tooltip #0c001c;
@define-color tooltip-b #ed0543;

@define-color text     #cdd6f4;
@define-color subtext0 #a6adc8;
@define-color subtext1 #bac2de;

@define-color surface0 #313244;
@define-color surface1 #45475a;
@define-color surface2 #585b70;

@define-color overlay0 #6c7086;
@define-color overlay1 #7f849c;
@define-color overlay2 #9399b2;

@define-color blue     #045ce0;
@define-color lavender #A78BFA;
@define-color sapphire #1C247F;
@define-color sky      #1E90FF;
@define-color teal     #14B8A6;
@define-color green    #02E358;
@define-color yellow   #FBBF24;
@define-color orange #fc6f03;
@define-color peach    #ff8ba7;
@define-color maroon   #33272a;
@define-color red      #FF1023;
@define-color mauve    #4e182c;
@define-color pink     #EC4899;
@define-color flamingo #ff00ff;
@define-color rosewater #ffd6d1;
@define-color sudo #ed0543;
@define-color mor #4f0ea3;
@define-color violet #5c0691;

/* ─────── GLOBAL ─────── */
* {
  font-family: "JetBrainsMono Nerd Font", "Noto Sans", sans-serif;
  border: none;
  border-radius: 0;
  min-height: 0;
  margin: 0.2px;
  padding: 0;
}

window#waybar {
  background: transparent;
}

/* ─────── LEFT y CENTER: bloque unificado ─────── */
.modules-left {
  background: transparent;
  border-radius: 10px;
  padding: 1px 2px;
  margin: 0.5px 1px;
}

.modules-center {
  background: alpha(@base, 0.85);
  padding: 1px 2px;
  border-radius: 10px;
  margin: 0.5px 2px;
}

/* ─────── RIGHT: contenedor transparente, cada módulo es su propio bloque ─────── */
.modules-right {
  background: transparent;
  border: none;
  padding: 0;
  margin: 0.5px 1px;
}

/* ─────── Módulos del RIGHT: cada uno es una píldora separada ─────── */
#custom-ssh,
#cpu,
#memory,
#disk,
#temperature,
#battery,
#pulseaudio,
#clock,
#custom-powermenu {
  font-size: 11px;
  font-weight: bold;
  background: alpha(@base, 0.85);
  border-radius: 10px;
  padding: 0.5px 10px;
  color: @text;
}

/* ─────── Network: interface + speed pegados como 1 bloque ─────── */
#network.interface {
  background: alpha(@teal, 0.85);
  font-size: 11px;
  font-weight: bold;
  border-radius: 10px;
  padding: 0.5px 10px;
  margin: 2px 1px;
  color: @maroon;
}

#network.speed {
  background: alpha(@lavender, 0.85);
  border-radius: 10px;
  padding: 2px 10px 2px 6px;
  margin: 2px 1px;
  color: @maroon;
}

/* ─────── LOGO ─────── */
#custom-logo {
  font-size: 22px;
  color: @orange;
  padding-left: 8px;
  padding-right: 8px;
}

/* ─────── WORKSPACES ─────── */
#workspaces button {
  font-size: 17px;
  padding: 0.5px 6px;
  color: @violet;
  background: transparent;
  border-radius: 8px;
  margin: 2px 1px;
  transition: all 0.2s ease;
}

#workspaces button:hover {
  color: @red;
}

#workspaces button.active {
  font-size: 16px;
  color: @red;
}

#workspaces button.urgent {
  color: @red;
  border: 1px solid alpha(@red, 0.5);
}

/* ─────── WINDOW TITLE ─────── */
#window {
  color: @subtext1;
  font-style: italic;
}

/* ─────── CLOCK ─────── */
#clock {
  background: @sky;
  color: @mauve;
  border-radius: 10px;
}

/* ─────── SSH MONITOR ─────── */
#custom-ssh.connected {
  color: @maroon;
  background: alpha(@green, 0.85);
  border-radius: 10px;
}

#custom-ssh.disconnected {
  background: alpha(@lavender, 0.85);
  color: @maroon;
  border-radius: 10px;
}

/* ─────── NETWORK ─────── */
#network {
  color: @sky;
}

#network.disconnected {
  background: alpha(@red, 0.85);
  color: @rosewater;
}

/* ─────── CPU ─────── */
#cpu {
  color: @lavender;
  background: alpha(@violet, 0.85);
}

#cpu.warning {
  background: alpha(@orange, 0.85);
  color: @maroon;
}

#cpu.critical {
  background: alpha(@red, 0.85);
  color: @peach;
  animation: blink 1s infinite;
}

/* ─────── MEMORY ─────── */
#memory {
  background: alpha(@teal, 0.85);
  color: @mauve;
}

#memory.warning {
  background: alpha(@orange, 0.85);
  color: @mauve;
}

#memory.critical {
  background: alpha(@red, 0.85);
  color: @peach;
}

/* ─────── DISK ─────── */
#disk {
  background: alpha(@sapphire, 0.85);
  color: @lavender;
}

#disk.warning {
  background: alpha(@yellow, 0.85);
  color: @maroon;
}

#disk.critical {
  background: alpha(@red, 0.85);
  color: @peach;
}

/* ─────── TEMPERATURE ─────── */
#temperature {
  background: alpha(@flamingo, 0.85);
  color: @base;
}

#temperature.critical {
  background: alpha(@red, 0.85);
  color: @peach;
  animation: blink 0.8s infinite;
}

/* ─────── BATTERY ─────── */
#battery {
  color: @green;
}

#battery.warning {
  color: @yellow;
}

#battery.critical {
  color: @red;
}

#battery.charging {
  color: @teal;
}

#pulseaudio {
  background: alpha(@teal, 0.85);
  border-radius: 10px;
  padding: 2px 10px;
  color: @base;
}

#pulseaudio.muted {
  background: alpha(@yellow, 0.85);
  color: @maroon;
}

/* ─────── POWER MENU ─────── */
#custom-powermenu {
  color: @base;
  background: alpha(@mor, 0.85);
  font-size: 16px;
  padding: 0 12px;
  border-radius: 10px;
  transition: all 0.2s;
  margin: 2px 3px;
}

#custom-powermenu:hover {
  color: @peach;
  background: alpha(@red, 0.85);
}

/* ─────── TOOLTIPS ─────── */
tooltip {
  background: @tooltip;
  border: 1px solid alpha(@tooltip-b, 0.8);
  border-radius: 10px;
  color: @tooltip-b;
  padding: 6px;
}

tooltip label {
  color: @tooltip-b;
}

/* ─────── ANIMACIÓN BLINK ─────── */
@keyframes blink {
  to {
    opacity: 0.4;
  }
}
EOF

# ─────────────────────────────────────────────
# WAYBAR SSH MONITOR SCRIPT
# ─────────────────────────────────────────────
cat > ~/.config/waybar/scripts/ssh_monitor.sh << 'EOF'
#!/bin/bash
SSH_CONNECTIONS=$(ss -tp 2>/dev/null | grep ':ssh\|:22' | grep ESTAB)

if [ -z "$SSH_CONNECTIONS" ]; then
    echo '{"text":"","class":"disconnected","tooltip":"Sin conexiones SSH activas"}'
    exit 0
fi

IPS=()
while IFS= read -r line; do
    IP=$(echo "$line" | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
    [ -n "$IP" ] && IPS+=("$IP")
done <<< "$SSH_CONNECTIONS"

UNIQUE_IPS=($(printf '%s\n' "${IPS[@]}" | sort -u))
COUNT=${#UNIQUE_IPS[@]}

if [ "$COUNT" -eq 0 ]; then
    echo '{"text":"","class":"disconnected","tooltip":"Sin conexiones SSH activas"}'
elif [ "$COUNT" -eq 1 ]; then
    IP="${UNIQUE_IPS[0]}"
    echo "{\"text\":\"󰣀  SSH: ${IP}\",\"class\":\"connected\",\"tooltip\":\"Conectado a: ${IP}\"}"
else
    TOOLTIP="Conexiones SSH activas:\n$(printf '• %s\n' "${UNIQUE_IPS[@]}")"
    echo "{\"text\":\"󰣀  SSH: ${COUNT} sesiones\",\"class\":\"connected\",\"tooltip\":\"${TOOLTIP}\"}"
fi
EOF
chmod +x ~/.config/waybar/scripts/ssh_monitor.sh

ok "Waybar configurado"

# ─────────────────────────────────────────────
# ROFI
# ─────────────────────────────────────────────
rofi -dump-config > ~/.config/rofi/config.rasi

section "Escribiendo configuración de rofi"

cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    show-icons: true;
    icon-theme: "Oranchelo";
    font: "JetBrainsMono Nerd Font 12";
}

@theme "~/.config/rofi/theme.rasi"
EOF

cat > ~/.config/rofi/powermenu.rasi << 'EOF'
* {
    background-color:   #0c001c;
    border-color:       #ed0543;
    text-color:         #ec72f9;
    font:               "JetBrainsMono Nerd Font 12";
}

window {
    width:              250px;
    border:             1px;
    border-radius:      14px;
    padding:            10px;
}

mainbox {
    spacing:            0;
    padding:            0;
}

inputbar {
    enabled:            false;
}

prompt {
    enabled:            false;
}

listview {
    columns:            1;
    lines:              5;
    spacing:            4px;
    padding:            0;
    fixed-height:       false;
}

element {
    padding:            8px 3px;
    border-radius:      8px;
    margin:             0;
}

element selected {
    border:             2px;
    border-color:       #ed0543;

}
EOF

cat > ~/.config/rofi/powermenu.sh << 'EOF'
#!/bin/bash
LOCK=" Bloquear"
LOGOUT="󰈉 Cerrar sesión"
SUSPEND="󱙱 Suspender"
REBOOT="󱐢 Reiniciar"
SHUTDOWN=" Apagar"

CHOSEN=$(printf "$LOCK\n$LOGOUT\n$SUSPEND\n$REBOOT\n$SHUTDOWN" \
    | rofi -dmenu \
        -p "Power" \
        -theme ~/.config/rofi/powermenu.rasi)

case "$CHOSEN" in
    "$LOCK")     hyprlock ;;
    "$LOGOUT")   hyprctl dispatch exit ;;
    "$SUSPEND")  systemctl suspend ;;
    "$REBOOT")   systemctl reboot ;;
    "$SHUTDOWN") systemctl poweroff ;;
esac
EOF

chmod u+x ~/.config/rofi/powermenu.sh

cat > ~/.config/rofi/theme.rasi << 'EOF'
* {
    background-color:   #0c001c;
    border-color:       #ed0543;
    text-color:         #ec72f9;
    font:               "JetBrainsMono Nerd Font 12";
}

window {
    width:              600px;
    border:             1px;
    border-radius:      14px;
    padding:            20px;
}

mainbox {
    spacing:            10px;
}

inputbar {
    padding:            8px 14px;
    border-radius:      10px;
    border:             1px;
    border-color:       #ed0543;
}

listview {
    columns:            3;
    lines:              3;
    spacing:            8px;
    icon-size:          40;
}

element {
    padding:            10px;
    border-radius:      10px;
    orientation:        vertical;
}

element selected {
    border:             1px;
    border-color:       #ed0543;
    text-color:         #89b4fa;
}

element-icon {
    size:               32px;
    horizontal-align:   0.5;
}

element-text {
    horizontal-align:   0.5;
    margin:             6px 0 0;
}

prompt {
    enabled: false;
    text-color: #cba6f7;
}
EOF

ok "Rofi configurado"

# ─────────────────────────────────────────────
# ALACRITTY
# ─────────────────────────────────────────────
section "Escribiendo configuración de Alacritty"

cat > ~/.config/alacritty/alacritty.toml << 'EOF'
[window]
opacity = 0.9
startup_mode = "Maximized"
blur = true
decorations = "none"  
dynamic_padding = false
title = "wolverin"

[window.padding]
x = 0 
y = 0

[font]
size = 12.0

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[font.bold]
family = "JetBrainsMono Nerd Font"
style = "Bold"

[font.italic]
family = "JetBrainsMono Nerd Font"
style = "Italic"

[font.offset]
y = 1

[cursor.style]
shape = "Underline"

[cursor]
blink_interval = 500
blink_timeout = 0
unfocused_hollow = true

[terminal.shell]
program = "/bin/zsh"

[colors.primary]
background = "0x0c001c"
foreground = "0x1E90FF"

[colors.cursor]
text = "0x14B8A6"
cursor = "0xff79c6"

[colors.normal]
black   = "0x262324"
red     = "0xed0543"
green   = "0x02E358"
yellow  = "0xFBBF24"
blue    = "0x1047A3"
magenta = "0xff00ff"
cyan    = "0x00ced1"
white   = "0xfaafbd"

[[keyboard.bindings]]
key = "V"
mods = "Control|Shift"
action = "Paste"

[[keyboard.bindings]]
key = "C"
mods = "Control|Shift"
action = "Copy"

[[keyboard.bindings]]
key = "N"
mods = "Control|Shift"
action = "SpawnNewInstance"

[[keyboard.bindings]]
key = "F11"
action = "ToggleFullscreen"

[[keyboard.bindings]]
key = "F12"
action = "ToggleFullscreen"

[scrolling]
history = 10000
multiplier = 3
EOF

ok "Alacritty configurado"

# ─────────────────────────────────────────────
# ZSHRC
# ─────────────────────────────────────────────
section "Escribiendo .zshrc"

cat > ~/.zshrc << 'ZSHRC_EOF'
# ============================================
# CONFIGURACIÓN ZSH
# ============================================

export _JAVA_AWT_WM_NONREPARENTING=1

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

CASE_SENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh

# ============================================
# STARSHIP PROMPT
# ============================================
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# ============================================
# ALIASES MODERNOS
# ============================================
alias cat='bat'
alias catn='bat --style=popacity = 0.9
[font]
size = 12.0

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[font.bold]
family = "JetBrainsMono Nerd Font"
style = "Bold"

[font.italic]
family = "JetBrainsMono Nerd Font"
style = "Italic"

[font.offset]
y = 1

[cursor.style]
shape = "Underline"

[cursor]
blink_interval = 500
blink_timeout = 0
unfocused_hollow = true

[terminal.shell]
program = "/bin/zsh"

[colors.primary]
background = "0x1d1826"
foreground = "0x1E90FF"

[colors.cursor]
text = "0x14B8A6"
cursor = "0xff79c6"

[colors.normal]
black   = "0x262324"
red     = "0xed0543"
green   = "0x02E358"
yellow  = "0xFBBF24"
blue    = "0x1047A3"
magenta = "0xff00ff"
cyan    = "0x00ced1"
white   = "0xfaafbd"

[[keyboard.bindings]]
key = "V"
mods = "Control|Shift"
action = "Paste"

[[keyboard.bindings]]
key = "C"
mods = "Control|Shift"
action = "Copy"

[[keyboard.bindings]]
key = "N"
mods = "Control|Shift"
action = "SpawnNewInstance"

[[keyboard.bindings]]
key = "F11"
action = "ToggleFullscreen"

[[keyboard.bindings]]
key = "F12"
action = "ToggleFullscreen"

[scrolling]
history = 10000
multiplier = 3
lain'
alias find='fd'
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias tree='eza --tree --level=2 --icons'
alias du='dust -r'
alias top='btm'
alias htop='btm'
alias grep='rg'

# ============================================
# HISTORY
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt histignorealldups sharehistory

# ============================================
# EDITOR
# ============================================
export EDITOR='helix'
export VISUAL='helix'

# ============================================
# PNPM
# ============================================
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ============================================
# GO
# ============================================
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# ============================================
# RUST / CARGO
# ============================================
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ============================================
# WAYLAND
# ============================================
export MOZ_ENABLE_WAYLAND=1
export MOZ_WAYLAND_USE_VAAPI=1

alias hx='helix'
ZSHRC_EOF

ok ".zshrc escrito"

# ─────────────────────────────────────────────
# HELIX — config.toml
# ─────────────────────────────────────────────
section "Escribiendo configuración de Helix"

cat > ~/.config/helix/config.toml << 'CONFIG_EOF'
theme = "floria"

[editor]
line-number = "relative"
mouse = true
middle-click-paste = true
scroll-lines = 3
scrolloff = 8
cursorline = true
cursorcolumn = false
auto-completion = true
auto-format = true
auto-save = false
idle-timeout = 250
completion-timeout = 250
preview-completion-insert = true
completion-trigger-len = 2
completion-replace = false
auto-info = true
true-color = true
undercurl = true
color-modes = true
text-width = 100
default-line-ending = "lf"
insert-final-newline = true
popup-border = "all"
indent-heuristic = "hybrid"
clipboard-provider = "wayland"

[editor.statusline]
left = ["mode", "spinner", "file-name", "read-only-indicator", "file-modification-indicator"]
center = ["version-control"]
right = ["diagnostics", "selections", "register", "position", "file-encoding"]
separator = "│"
mode.normal = "NORMAL"
mode.insert = "INSERT"
mode.select = "SELECT"

[editor.lsp]
enable = true
display-messages = true
auto-signature-help = true
display-inlay-hints = true
display-signature-help-docs = true
snippets = true
goto-reference-include-declaration = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = false
follow-symlinks = true
deduplicate-links = true
parents = true
ignore = true
git-ignore = true
git-global = true
git-exclude = true
max-depth = 6

[editor.auto-pairs]
'(' = ')'
'{' = '}'
'[' = ']'
'"' = '"'
'`' = '`'
'<' = '>'

[editor.search]
smart-case = true
wrap-around = true

[editor.whitespace]
render = "all"
characters = { space = " ", nbsp = " ", tab = " ", newline = " ", tabpad = " " }

[editor.indent-guides]
render = true
character = "┊"
skip-levels = 1

[editor.gutters]
layout = ["diff", "diagnostics", "line-numbers", "spacer"]

[editor.gutters.line-numbers]
min-width = 3

[editor.soft-wrap]
enable = true
max-wrap = 25
max-indent-retain = 40
wrap-indicator = "↪ "

[keys.normal]
C-d = "half_page_down"
C-u = "half_page_up"
C-f = "page_down"
C-b = "page_up"
C-p = "file_picker"
C-s = ":w"
C-q = ":q"
space.s = "symbol_picker"
space.S = "workspace_symbol_picker"
"[" = "goto_prev_diag"
"]" = "goto_next_diag"
space.d = "diagnostics_picker"
space.g.s = ":sh git status"
space.g.l = ":sh git log --oneline -10"
space.g.d = ":sh git diff"
space.g.b = ":sh git blame %"
space.l.a = "code_action"
space.l.r = "rename_symbol"
space.l.f = "format_selections"
space.l.h = "hover"
space.r.c = ":sh cargo check"
space.r.b = ":sh cargo build"
space.r.r = ":sh cargo run"
space.r.t = ":sh cargo test"
space.r.f = ":sh cargo fmt"
space.r.l = ":sh cargo clippy"
C-w.v = "vsplit"
C-w.s = "hsplit"
C-w.q = "wclose"
C-w.o = "wonly"
C-w.h = "jump_view_left"
C-w.j = "jump_view_down"
C-w.k = "jump_view_up"
C-w.l = "jump_view_right"
space.f.f = "file_picker"
space.f.g = "global_search"
space.f.b = "buffer_picker"
space.y = ":clipboard-yank"
space.p = ":clipboard-paste-after"
space.P = ":clipboard-paste-before"

[keys.insert]
j.k = "normal_mode"
C-space = "completion"
C-h = "move_char_left"
C-l = "move_char_right"

[keys.select]
C-d = "half_page_down"
C-u = "half_page_up"
CONFIG_EOF

ok "Helix config.toml escrito"

# ─────────────────────────────────────────────
# HELIX — languages.toml (íntegro del original)
# ─────────────────────────────────────────────
cat > ~/.config/helix/languages.toml << 'LANG_EOF'
[language-server.rust-analyzer]
command = "rust-analyzer"

[language-server.rust-analyzer.config]
checkOnSave = true
check = { command = "clippy", features = "all" }
cargo = { allFeatures = true, loadOutDirsFromCheck = true }
procMacro = { enable = true }
diagnostics = { enable = true, experimental = { enable = true } }

[language-server.rust-analyzer.config.inlayHints]
bindingModeHints.enable = true
chainingHints.enable = true
closingBraceHints.minLines = 10
closureReturnTypeHints.enable = "with_block"
discriminantHints.enable = "fieldless"
expressionAdjustmentHints.enable = "reborrow"
implicitDrops.enable = true
lifetimeElisionHints.enable = "skip_trivial"
lifetimeElisionHints.useParameterNames = true
maxLength = 25
parameterHints.enable = true
reborrowHints.enable = "mutable"
renderColons = true
typeHints.enable = true
typeHints.hideClosureInitialization = false
typeHints.hideNamedConstructor = false

[language-server.pylsp]
command = "pylsp"

[language-server.pylsp.config.pylsp.plugins]
pycodestyle.enabled = false
mccabe.enabled = false
pyflakes.enabled = true
pylint.enabled = true
black.enabled = true
ruff.enabled = true

[language-server.pyright]
command = "pyright-langserver"
args = ["--stdio"]

[language-server.typescript-language-server]
command = "typescript-language-server"
args = ["--stdio"]

[language-server.typescript-language-server.config]
hostInfo = "helix"

[language-server.typescript-language-server.config.completions]
completeFunctionCalls = true

[language-server.eslint]
command = "vscode-eslint-language-server"
args = ["--stdio"]

[language-server.eslint.config]
validate = "on"
run = "onType"

[language-server.eslint.config.codeActionsOnSave]
mode = "all"
"source.fixAll.eslint" = true

[language-server.gopls]
command = "gopls"

[language-server.gopls.config.gopls]
staticcheck = true
gofumpt = true

[language-server.gopls.config.gopls.analyses]
unusedparams = true
shadow = true

[language-server.gopls.config.gopls.hints]
assignVariableTypes = true
compositeLiteralFields = true
constantValues = true
functionTypeParameters = true
parameterNames = true
rangeVariableTypes = true

[language-server.clangd]
command = "clangd"
args = ["--background-index", "--clang-tidy", "--completion-style=detailed"]

[language-server.jdtls]
command = "jdtls"

[language-server.vscode-html-language-server]
command = "vscode-html-language-server"
args = ["--stdio"]

[language-server.vscode-html-language-server.config]
provideFormatter = true

[language-server.vscode-css-language-server]
command = "vscode-css-language-server"
args = ["--stdio"]

[language-server.vscode-css-language-server.config]
provideFormatter = true

[language-server.vscode-json-language-server]
command = "vscode-json-language-server"
args = ["--stdio"]

[language-server.vscode-json-language-server.config]
provideFormatter = true

[language-server.tailwindcss-ls]
command = "tailwindcss-language-server"
args = ["--stdio"]

[language-server.svelteserver]
command = "svelteserver"
args = ["--stdio"]

[language-server.astro-ls]
command = "astro-ls"
args = ["--stdio"]

[language-server.astro-ls.config]
environment = "node"

[language-server.bash-language-server]
command = "bash-language-server"
args = ["start"]

[language-server.docker-langserver]
command = "docker-langserver"
args = ["--stdio"]

[language-server.yaml-language-server]
command = "yaml-language-server"
args = ["--stdio"]

[language-server.taplo]
command = "taplo"
args = ["lsp", "stdio"]

[language-server.marksman]
command = "marksman"
args = ["server"]

[[language]]
name = "rust"
scope = "source.rust"
file-types = ["rs"]
roots = ["Cargo.toml", "Cargo.lock"]
auto-format = true
language-servers = ["rust-analyzer"]
indent = { tab-width = 4, unit = "    " }

[language.formatter]
command = "rustfmt"
args = ["--edition", "2021"]

[[language]]
name = "toml"
scope = "source.toml"
file-types = ["toml", "Cargo.lock"]
language-servers = ["taplo"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[[language]]
name = "python"
scope = "source.python"
file-types = ["py", "pyi", "py3", "pyw"]
shebangs = ["python"]
roots = ["pyproject.toml", "setup.py", "poetry.lock", "pyrightconfig.json"]
language-servers = ["pyright", "pylsp"]
indent = { tab-width = 4, unit = "    " }
auto-format = true

[language.formatter]
command = "black"
args = ["--quiet", "-"]

[[language]]
name = "javascript"
scope = "source.js"
file-types = ["js", "mjs", "cjs"]
shebangs = ["node"]
roots = ["package.json", "tsconfig.json"]
language-servers = ["typescript-language-server", "eslint"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[language.formatter]
command = "prettier"
args = ["--parser", "typescript"]

[[language]]
name = "typescript"
scope = "source.ts"
file-types = ["ts", "mts", "cts"]
roots = ["package.json", "tsconfig.json"]
language-servers = ["typescript-language-server", "eslint"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[language.formatter]
command = "prettier"
args = ["--parser", "typescript"]

[[language]]
name = "tsx"
scope = "source.tsx"
file-types = ["tsx"]
roots = ["package.json", "tsconfig.json"]
language-servers = ["typescript-language-server", "eslint", "tailwindcss-ls"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[language.formatter]
command = "prettier"
args = ["--parser", "typescript"]

[[language]]
name = "jsx"
scope = "source.jsx"
file-types = ["jsx"]
roots = ["package.json", "tsconfig.json"]
language-servers = ["typescript-language-server", "eslint"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[language.formatter]
command = "prettier"
args = ["--parser", "typescript"]

[[language]]
name = "go"
scope = "source.go"
file-types = ["go"]
roots = ["go.mod", "go.work"]
auto-format = true
language-servers = ["gopls"]
indent = { tab-width = 4, unit = "\t" }

[language.formatter]
command = "gofumpt"

[[language]]
name = "c"
scope = "source.c"
file-types = ["c", "h"]
language-servers = ["clangd"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[[language]]
name = "cpp"
scope = "source.cpp"
file-types = ["cc", "hh", "c++", "cpp", "hpp", "h", "ipp", "tpp", "cxx", "hxx"]
language-servers = ["clangd"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[[language]]
name = "java"
scope = "source.java"
file-types = ["java"]
roots = ["pom.xml", "build.gradle", "build.gradle.kts"]
language-servers = ["jdtls"]
indent = { tab-width = 4, unit = "    " }

[[language]]
name = "html"
scope = "text.html.basic"
file-types = ["html", "htm", "shtml", "xhtml"]
language-servers = ["vscode-html-language-server"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[language.formatter]
command = "prettier"
args = ["--parser", "html"]

[[language]]
name = "css"
scope = "source.css"
file-types = ["css", "scss"]
language-servers = ["vscode-css-language-server", "tailwindcss-ls"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[language.formatter]
command = "prettier"
args = ["--parser", "css"]

[[language]]
name = "svelte"
scope = "source.svelte"
file-types = ["svelte"]
roots = ["package.json", "svelte.config.js"]
language-servers = ["svelteserver", "tailwindcss-ls"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[language.formatter]
command = "prettier"
args = ["--plugin", "prettier-plugin-svelte", "--parser", "svelte"]

[[language]]
name = "astro"
scope = "source.astro"
file-types = ["astro"]
roots = ["package.json", "astro.config.mjs"]
language-servers = ["astro-ls"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[[language]]
name = "bash"
scope = "source.bash"
file-types = ["sh", "bash", "zsh", ".bashrc", ".zshrc", ".bash_profile", ".zprofile"]
shebangs = ["sh", "bash", "zsh"]
language-servers = ["bash-language-server"]
indent = { tab-width = 2, unit = "  " }

[[language]]
name = "dockerfile"
scope = "source.dockerfile"
file-types = ["dockerfile", "Dockerfile", "Containerfile"]
language-servers = ["docker-langserver"]
indent = { tab-width = 2, unit = "  " }

[[language]]
name = "yaml"
scope = "source.yaml"
file-types = ["yml", "yaml"]
language-servers = ["yaml-language-server"]
indent = { tab-width = 2, unit = "  " }
auto-format = true

[[language]]
name = "json"
scope = "source.json"
file-types = ["json", "jsonc", "arb", "ipynb", "geojson", "webmanifest"]
language-servers = ["vscode-json-language-server"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[language.formatter]
command = "prettier"
args = ["--parser", "json"]

[[language]]
name = "markdown"
scope = "source.md"
file-types = ["md", "markdown", "mkd", "mdwn", "mdown"]
roots = [".marksman.toml"]
language-servers = ["marksman"]
indent = { tab-width = 2, unit = "  " }
LANG_EOF

ok "Helix languages.toml escrito"

# ─────────────────────────────────────────────
# HELIX — tema floria
# ─────────────────────────────────────────────
cat > ~/.config/helix/themes/floria.toml << 'THEMES_EOF'
"comment"                    = { fg = "comment", modifiers = ["italic"] }
"string"                     = { fg = "yellow" }
"string.regexp"              = { fg = "bright_yellow" }
"string.special"             = { fg = "bright_yellow", modifiers = ["italic"] }
"character"                  = { fg = "yellow" }
"character.special"          = { fg = "cyan", modifiers = ["bold"] }
"constant"                   = { fg = "purple", modifiers = ["bold"] }
"constant.builtin"           = { fg = "purple", modifiers = ["bold"] }
"constant.character.escape"  = { fg = "cyan", modifiers = ["bold"] }
"constant.numeric"           = { fg = "purple", modifiers = ["bold"] }
"number"                     = { fg = "purple", modifiers = ["bold"] }
"boolean"                    = { fg = "purple", modifiers = ["bold", "italic"] }
"function"                   = { fg = "green", modifiers = ["bold", "italic"] }
"function.builtin"           = { fg = "green", modifiers = ["bold"] }
"function.method"            = { fg = "green", modifiers = ["bold", "italic"] }
"function.macro"             = { fg = "green", modifiers = ["italic"] }
"function.special"           = { fg = "green", modifiers = ["bold"] }
"variable"                   = { fg = "fg" }
"variable.builtin"           = { fg = "purple", modifiers = ["italic"] }
"variable.parameter"         = { fg = "orange", modifiers = ["italic"] }
"variable.other.member"      = { fg = "fg", modifiers = ["italic"] }
"keyword"                    = { fg = "pink", modifiers = ["bold"] }
"keyword.control"            = { fg = "pink", modifiers = ["bold"] }
"keyword.control.conditional" = { fg = "pink", modifiers = ["bold"] }
"keyword.control.return"     = { fg = "pink", modifiers = ["bold"] }
"keyword.control.import"     = { fg = "orange" }
"keyword.operator"           = { fg = "pink" }
"keyword.directive"          = { fg = "orange" }
"keyword.function"           = { fg = "pink", modifiers = ["bold"] }
"keyword.storage"            = { fg = "cyan", modifiers = ["italic"] }
"keyword.storage.type"       = { fg = "cyan", modifiers = ["bold"] }
"keyword.storage.modifier"   = { fg = "cyan", modifiers = ["italic"] }
"operator"                   = { fg = "pink" }
"type"                       = { fg = "cyan", modifiers = ["bold"] }
"type.builtin"               = { fg = "cyan", modifiers = ["bold", "italic"] }
"type.enum.variant"          = { fg = "cyan" }
"type.parameter"             = { fg = "cyan", modifiers = ["italic"] }
"constructor"                = { fg = "cyan", modifiers = ["bold"] }
"namespace"                  = { fg = "orange" }
"module"                     = { fg = "orange" }
"attribute"                  = { fg = "green", modifiers = ["italic"] }
"attribute.builtin"          = { fg = "green" }
"special"                    = { fg = "pink", modifiers = ["bold"] }
"label"                      = { fg = "orange" }
"property"                   = { fg = "fg", modifiers = ["italic"] }
"punctuation"                = { fg = "fg" }
"punctuation.delimiter"      = { fg = "fg" }
"punctuation.bracket"        = { fg = "fg" }
"punctuation.special"        = { fg = "pink", modifiers = ["bold"] }
"tag"                        = { fg = "pink", modifiers = ["bold"] }
"tag.builtin"                = { fg = "pink" }
"tag.attribute"              = { fg = "green", modifiers = ["italic"] }
"tag.delimiter"              = { fg = "fg" }
"escape"                     = { fg = "cyan", modifiers = ["bold"] }
"markup.heading"             = { fg = "purple", modifiers = ["bold"] }
"markup.heading.1"           = { fg = "purple", modifiers = ["bold", "underlined"] }
"markup.heading.2"           = { fg = "cyan", modifiers = ["bold"] }
"markup.heading.3"           = { fg = "green", modifiers = ["bold"] }
"markup.heading.4"           = { fg = "yellow", modifiers = ["bold"] }
"markup.heading.5"           = { fg = "orange", modifiers = ["bold"] }
"markup.heading.6"           = { fg = "pink" }
"markup.bold"                = { modifiers = ["bold"] }
"markup.italic"              = { modifiers = ["italic"] }
"markup.strikethrough"       = { modifiers = ["crossed_out"] }
"markup.link.url"            = { fg = "cyan", modifiers = ["underlined"] }
"markup.link.text"           = { fg = "orange", modifiers = ["bold"] }
"markup.link.label"          = { fg = "orange" }
"markup.raw"                 = { fg = "green" }
"markup.raw.inline"          = { fg = "green" }
"markup.raw.block"           = { fg = "green" }
"markup.list"                = { fg = "pink" }
"markup.quote"               = { fg = "comment", modifiers = ["italic"] }
"ui.background"              = { bg = "bg" }
"ui.background.separator"    = { fg = "gutter" }
"ui.text"                    = { fg = "fg" }
"ui.text.inactive"           = { fg = "comment" }
"ui.text.info"               = { fg = "cyan" }
"ui.cursor"                  = { fg = "bg", bg = "fg" }
"ui.cursor.normal"           = { fg = "bg", bg = "fg" }
"ui.cursor.insert"           = { fg = "bg", bg = "pink" }
"ui.cursor.select"           = { fg = "bg", bg = "purple" }
"ui.cursor.primary"          = { fg = "bg", bg = "fg" }
"ui.cursor.primary.normal"   = { fg = "bg", bg = "fg" }
"ui.cursor.primary.insert"   = { fg = "bg", bg = "pink" }
"ui.cursor.primary.select"   = { fg = "bg", bg = "purple" }
"ui.cursor.match"            = { fg = "bg", bg = "yellow" }
"ui.cursorline"              = { bg = "cursorline" }
"ui.cursorline.primary"      = { bg = "cursorline" }
"ui.selection"               = { bg = "selection" }
"ui.selection.primary"       = { bg = "selection" }
"ui.linenr"                  = { fg = "gutter" }
"ui.linenr.selected"         = { fg = "yellow", modifiers = ["bold"] }
"ui.statusline"              = { fg = "fg", bg = "menu" }
"ui.statusline.inactive"     = { fg = "comment", bg = "menu" }
"ui.statusline.normal"       = { fg = "bg", bg = "green", modifiers = ["bold"] }
"ui.statusline.insert"       = { fg = "bg", bg = "pink", modifiers = ["bold"] }
"ui.statusline.select"       = { fg = "bg", bg = "purple", modifiers = ["bold"] }
"ui.statusline.separator"    = { fg = "gutter" }
"ui.popup"                   = { fg = "fg", bg = "menu" }
"ui.popup.info"              = { fg = "cyan", bg = "menu" }
"ui.window"                  = { fg = "gutter" }
"ui.help"                    = { fg = "fg", bg = "menu" }
"ui.menu"                    = { fg = "fg", bg = "menu" }
"ui.menu.selected"           = { fg = "bg", bg = "cyan", modifiers = ["bold"] }
"ui.menu.scroll"             = { fg = "comment" }
"ui.virtual.ruler"           = { bg = "cursorline" }
"ui.virtual.whitespace"      = { fg = "gutter" }
"ui.virtual.indent-guide"    = { fg = "gutter" }
"ui.virtual.inlay-hint"      = { fg = "comment", modifiers = ["italic"] }
"ui.virtual.inlay-hint.parameter" = { fg = "orange", modifiers = ["italic"] }
"ui.virtual.inlay-hint.type" = { fg = "cyan", modifiers = ["italic"] }
"ui.virtual.jump-label"      = { fg = "pink", modifiers = ["bold"] }
"ui.highlight"               = { bg = "selection" }
"ui.highlight.frameline"     = { bg = "cursorline" }
"diagnostic.error"           = { underline = { style = "curl", color = "red" } }
"diagnostic.warning"         = { underline = { style = "curl", color = "yellow" } }
"diagnostic.info"            = { underline = { style = "curl", color = "cyan" } }
"diagnostic.hint"            = { underline = { style = "curl", color = "green" } }
"diagnostic.unnecessary"     = { modifiers = ["dim"] }
"diagnostic.deprecated"      = { modifiers = ["crossed_out"] }
"error"                      = { fg = "red" }
"warning"                    = { fg = "yellow" }
"info"                       = { fg = "cyan" }
"hint"                       = { fg = "green" }
"diff.plus"                  = { fg = "green" }
"diff.minus"                 = { fg = "red" }
"diff.delta"                 = { fg = "yellow" }
"diff.plus.gutter"           = { fg = "green" }
"diff.minus.gutter"          = { fg = "red" }
"diff.delta.gutter"          = { fg = "yellow" }

[palette]
bg            = "#050510"
fg            = "#faafbd"
menu          = "#0a0818"
selection     = "#1a143d"
cursorline    = "#0f0a28"
gutter        = "#3d2f5c"
pink          = "#ff0099"
green         = "#00ff77"
cyan          = "#00ddff"
yellow        = "#ffcc00"
purple        = "#aa00ff"
orange        = "#ff7733"
red           = "#ff0055"
comment       = "#6b5a8f"
bright_yellow = "#ffdd33"
THEMES_EOF

ok "Tema floria de Helix escrito"

# ─────────────────────────────────────────────
# HELIX — install_lsp.sh
# ─────────────────────────────────────────────
cat > ~/.config/helix/install_lsp.sh << 'INSTALL_EOF'
#!/bin/bash
# Instalador de Language Servers para Helix — Arch Linux
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${BLUE}==> $1${NC}"; }
ok()      { echo -e "${GREEN}✓ $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠ $1${NC}"; }
has()     { command -v "$1" >/dev/null 2>&1; }

# ── Rust ─────────────────────────────────────
info "Rust Language Server"
if has cargo; then
    sudo pacman -S --needed --noconfirm rust-analyzer rustfmt
    has cargo-expand || cargo install cargo-expand
    has cargo-watch  || cargo install cargo-watch
    ok "rust-analyzer, rustfmt instalados"
else
    warn "Rust no encontrado: sudo pacman -S rust"
fi

# ── Python ───────────────────────────────────
info "Python Language Servers"
if has python3; then
    sudo pacman -S --needed --noconfirm \
        python-lsp-server \
        python-black \
        python-pyflakes \
        python-pylint
    yay -S --needed --noconfirm pyright
    ok "pylsp, pyright, black instalados"
else
    warn "Python no encontrado: sudo pacman -S python"
fi

# ── Node / TypeScript ─────────────────────────
info "TypeScript / JavaScript Language Servers"
if has pnpm; then
    pnpm add -g \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        eslint \
        prettier \
        @tailwindcss/language-server \
        svelte-language-server \
        "@astrojs/language-server" \
        bash-language-server \
        dockerfile-language-server-nodejs \
        yaml-language-server \
        marksman
    ok "TypeScript, ESLint, Prettier, Tailwind, Svelte, Astro, Bash, Docker, YAML, Marksman instalados"
else
    warn "pnpm no disponible"
fi

# ── Go ───────────────────────────────────────
info "Go Language Server"
if has go; then
    go install golang.org/x/tools/gopls@latest
    go install mvdan.cc/gofumpt@latest
    ok "gopls, gofumpt instalados"
else
    warn "go no encontrado: sudo pacman -S go"
fi

# ── C / C++ ──────────────────────────────────
info "C/C++ Language Server"
if has clangd; then
    ok "clangd ya instalado"
else
    sudo pacman -S --needed --noconfirm clang
    ok "clangd instalado via clang"
fi

# ── Java ─────────────────────────────────────
info "Java Language Server"
if has jdtls; then
    ok "jdtls ya instalado"
else
    yay -S --needed --noconfirm jdtls
    ok "jdtls instalado"
fi

# ── TOML ─────────────────────────────────────
info "TOML Language Server"
sudo pacman -S --needed --noconfirm taplo
ok "taplo instalado"

# ── Verificación final ────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "  Verificación de Language Servers"
echo "════════════════════════════════════════"

check() {
    if has "$1"; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${YELLOW}✗${NC} $2 — no encontrado"
    fi
}

check rust-analyzer          "Rust (rust-analyzer)"
check pylsp                  "Python (pylsp)"
check pyright                "Python (pyright)"
check typescript-language-server "TypeScript/JavaScript"
check gopls                  "Go"
check clangd                 "C/C++"
check jdtls                  "Java"
check bash-language-server   "Bash"
check docker-langserver      "Docker"
check yaml-language-server   "YAML"
check taplo                  "TOML"
check marksman               "Markdown"
check rustfmt                "Rust (rustfmt)"
check black                  "Python (black)"
check prettier               "JavaScript/TypeScript/CSS/HTML"
check gofumpt                "Go (gofumpt)"
INSTALL_EOF

chmod +x ~/.config/helix/install_lsp.sh

ok "install_lsp.sh escrito"

# ─────────────────────────────────────────────
# EJECUTAR INSTALL LSP
# ─────────────────────────────────────────────
section "Instalando Language Servers para Helix"
bash ~/.config/helix/install_lsp.sh

# ─────────────────────────────────────────────
# DESCARGAR TEMAS
# ─────────────────────────────────────────────
# Clona el repo de temas de archcraft 
git clone https://github.com/archcraft-os/archcraft-themes.git 
cd archcraft-themes 

# Copia el tema GTK a tu carpeta de temas 
cp -r archcraft-gtk-theme-manhattan/files/Manhattan ~/.themes/

cd ~

gsettings set org.gnome.desktop.interface gtk-theme "Manhattan"

# ─────────────────────────────────────────────
# CONFIGURACION DE FASTFETCH
# ─────────────────────────────────────────────
fastfetch --gen-config

cat > ~/.config/fastfetch/config.jsonc << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "logo": {
    "source": "~/.config/fastfetch/logo.txt",
    "width": 2,
    "height": 2,
    "color": {
      "1": "#ff6e40",
      "2": "#ed0543",
      "3": "#0db7ed"
    }
  },
  "display": {
    "separator": " "
  },
  "modules": [
    "title",
    {
      "type": "separator",
      "string": "─────────────────"
    },
    {
      "type": "os",
      "key": " ",
      "keyColor": "#ee811a",
      "outputColor": "#ee811a"
    },
    {
      "type": "host",
      "key": " ",
      "keyColor": "#ef4444",
      "outputColor": "#ef4444"
    },
    {
      "type": "kernel",
      "key": " ",
      "keyColor": "#4ade80",
      "outputColor": "#4ade80"
    },
    {
      "type": "packages",
      "key": "󰏖 ",
      "keyColor": "#1e90ff",
      "outputColor": "#1e90ff"
    },
    {
      "type": "shell",
      "key": " ",
      "keyColor": "#5c0691",
      "outputColor": "#5c0691"
    },
    {
      "type": "wm",
      "key": "󰡖 ",
      "keyColor": "#ff79c6",
      "outputColor": "#ff79c6"
    },
    {
      "type": "icons",
      "key": " ",
      "keyColor": "#fcf949",
      "outputColor": "#fcf949"
    },
    {
      "type": "font",
      "key": "󰛖 ",
      "keyColor": "#9d80c2",
      "outputColor": "#9d80c2"
    },
    {
      "type": "terminal",
      "key": " ",
      "keyColor": "#00bf7e",
      "outputColor": "#00bf7e"
    },
    {
      "type": "cpu",
      "key": " ",
      "keyColor": "#ff9900",
      "outputColor": "#ff9900"
    },
    {
      "type": "memory",
      "key": " ",
      "keyColor": "#ff00ff",
      "outputColor": "#ff00ff"
    },
    {
      "type": "localip",
      "key": "󰩟 ",
      "keyColor": "#14b8a6",
      "outputColor": "#14b8a6"
    },
    {
      "type": "locale",
      "key": " ",
      "keyColor": "#4a4a4a",
      "outputColor": "#4a4a4a"
    }
  ]
}
EOF
cat > ~/.config/fastfetch/logo.txt << 'EOF'




 $3/===============================================\
 $1|| $2  __ _         _            _               $1||
 $1|| $2 / _| |___ _ _(_)__ _ _ __ | |__ _ _ __ _   $1||
 $1|| $2|  _| / _ \ '_| / _` | '  \| '_ \ '_/ _` |  $1||
 $1|| $2|_| |_\___/_| |_\__,_|_|_|_|_.__/_| \__,_|  $1||
 $1||                                             ||
 $3\===============================================/



EOF

# ─────────────────────────────────────────────
# HABILITAR SERVICIOS
# ─────────────────────────────────────────────
section "Habilitando servicios del sistema"

sudo systemctl enable nftables
ok "nftables habilitado"

systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || \
    warn "PipeWire: se habilitará al iniciar sesión gráfica"

# ─────────────────────────────────────────────
# INICIO AUTOMÁTICO DESDE TTY
# ─────────────────────────────────────────────
section "Configurando inicio automático de Hyprland desde TTY"

PROFILE_FILE="$HOME/.zprofile"
if ! grep -q "exec Hyprland" "$PROFILE_FILE" 2>/dev/null; then
    cat >> "$PROFILE_FILE" << 'PROFILE_EOF'

# Iniciar Hyprland automáticamente en TTY1
if [ -z "$WAYLAND_DISPLAY"] && [ "$XDG_VTNR" -eq 1 ]; then
	exec uwsm start hyprland-uwsm.desktop 
fi
PROFILE_EOF
    ok "Inicio automático de Hyprland añadido a .zprofile"
else
    warn "Inicio automático ya configurado en .zprofile"
fi

# ─────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────
echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup completado${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""
echo -e "Próximos pasos:"
echo -e "  1. Coloca un wallpaper en ${YELLOW}~/Wallpapers/wallpaper.png${NC}"
echo -e "  2. Ejecuta ${YELLOW}hyprctl monitors${NC} y ajusta el monitor en hyprland.conf"
echo -e "  3. Cierra sesión y vuelve a entrar para que Zsh sea el shell activo"
echo -e "  4. Desde TTY1 Hyprland arrancará automáticamente"
echo ""
echo -e "${YELLOW}Recuerda:${NC} Nunca ejecutes scripts de internet sin leerlos primero."
echo ""
