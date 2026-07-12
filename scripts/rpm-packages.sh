#!/bin/bash

set -euxo pipefail

# don’t need openh264 as flatpaks are used for everything
rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo

# hardware:
# intel cpu/igpu
# intel audio
# intel wifi/bt
# realtek ethernet

# remove firmware
# don’t put drivers that would be removed irregardless of hardware here
remove_drivers=(
"amd-gpu-firmware"
"amd-ucode-firmware"
"atheros-firmware"
"brcmfmac-firmware"
"cirrus-audio-firmware"
"mt7xxx-firmware"
"nvidia-gpu-firmware"
"nxpwireless-firmware"
"qcom-wwan-firmware"
"tiwilink-firmware"
)

# everything else to remove
remove_misc=(
"WALinuxAgent-udev"
"chunkah"
"rpm-ostree*"
"clevis*"
"console-login-helper-messages*"
"qemu-user-static*"
)

dnf rm -y \
${remove_drivers[@]} \
${remove_misc[@]}

dnf swap --allowerasing -y \
fedora-release-identity-basic \
fedora-release-identity-silverblue

dnf swap --allowerasing -y \
glibc-minimal-langpack \
glibc-langpack-en

dnf up -y fedora-release-identity-silverblue glibc-langpack-en

# dnf group info gnome-desktop
# printer drivers are installed separately
# some dependencies are also excluded as they will be pulled in anyway
# dnf group info desktop-accessibility
# no brltty
gnome_desktop=(
"at-spi2-atk"
"at-spi2-core"
"orca"
"speech-dispatcher"
"gdm"
"gnome-control-center"
"gnome-initial-setup"
"gnome-session-wayland-session"
"gnome-settings-daemon"
"gnome-shell"
"gnome-software"
"nautilus"
"ModemManager"
"NetworkManager-adsl"
"NetworkManager-openconnect-gnome"
"NetworkManager-openvpn-gnome"
"NetworkManager-ppp"
"NetworkManager-ssh-gnome"
"NetworkManager-vpnc-gnome"
"NetworkManager-wwan"
"fprintd-pam"
"glib-networking"
"glycin-thumbnailer"
"gnome-backgrounds"
"gnome-bluetooth"
"gnome-browser-connector"
"gnome-color-manager"
"gnome-disk-utility"
"gnome-remote-desktop"
"gnome-user-docs"
"gnome-user-share"
"gst-thumbnailers"
"gvfs-afc"
"gvfs-afp"
"gvfs-archive"
"gvfs-fuse"
"gvfs-goa"
"gvfs-gphoto2"
"gvfs-mtp"
"gvfs-smb"
"librsvg2"
"libsane-hpaio"
"localsearch"
"mesa-dri-drivers"
"mesa-libEGL"
"rygel"
"systemd-oomd-defaults"
"tinysparql"
"vte-profile"
"xdg-desktop-portal"
"xdg-desktop-portal-gnome"
"xdg-desktop-portal-gtk"
"xdg-user-dirs-gtk"
"tuned-ppd"
)

# dnf group info hardware-support
# put hardware-specific drivers here
# no drivers that would be installed regardless of host
hardware_support=(
"intel-audio-firmware"
"intel-gpu-firmware"
"intel-vsc-firmware"
"intel-lpmd"
"iwlwifi-mvm-firmware"
"realtek-firmware"
"libva-intel-media-driver"
"intel-mediasdk"
"intel-vpl-gpu-rt"
)

# dnf group info multimedia
multimedia=(
"alsa-sof-firmware"
"alsa-ucm"
"alsa-utils"
"gstreamer1-plugins-bad-free"
"gstreamer1-plugins-good"
"pipewire-alsa"
"pipewire-config-raop"
"pipewire-gstreamer"
"pipewire-pulseaudio"
"pipewire-utils"
"wireplumber"
)

# dnf group info printing
# also printer-driver-brlaser ptouch-driver
# the actual group is included in the ‘groups’ array below
printing=(
"c2esp"
"dymo-cups-drivers"
"printer-driver-brlaser"
"ptouch-driver"
"splix"
"cups-filters-driverless"
"sane-backends-drivers-cameras"
"sane-backends-drivers-scanners"
)

# dnf group info container-management
container_management=(
"podman"
"flatpak"
"toolbox"
)

# dnf group info input-methods
# only ibus, except ibus-table-chinese-cangjie
# also ibus-gtk3 ibus-gtk4
input_methods=(
"ibus-anthy"
"ibus-hangul"
"ibus-libpinyin"
"ibus-m17n"
"ibus-typing-booster"
"ibus-setup"
"ibus-gtk3"
"ibus-gtk4"
)

# misc
# forge.fedoraproject.org/atomic-desktops/config/src/branch/main/silverblue-common.yaml
# also some weak dependencies
misc=(
"tailscale"
"rsms-inter-vf-fonts"
"adobe-source-serif-pro-fonts"
"google-noto-emoji-fonts"
"fuse-overlayfs"
"hfsplus-tools"
"gnupg2-scdaemon"
"pinentry-gnome3"
"papers-thumbnailer"
"papers-previewer"
"totem-video-thumbnailer"
"mesa-vulkan-drivers"
"avahi-tools"
"bolt"
"exiv2"
"wl-clipboard"
"xdg-utils"
)

# all mandatory and default:
# dnf group info networkmanager-submodules
# dnf group info fonts
groups=(
"@printing"
"@networkmanager-submodules"
"@fonts"
)

# dnf group info core
# most of mandatory and default
core=(
"audit"
"bash"
"coreutils"
"curl"
"dnf5"
"e2fsprogs"
"filesystem"
"glibc"
"hostname"
"iproute"
"iputils"
"kbd"
"less"
"man-db"
"ncurses"
"openssh-clients"
"openssh-server"
"policycoreutils"
"procps-ng"
"rootfiles"
"rpm"
"selinux-policy-targeted"
"setup"
"shadow-utils"
"sssd-common"
"sssd-kcm"
"sudo"
"systemd"
"util-linux"
"NetworkManager"
"firewalld"
"fwupd"
"plymouth"
"prefixdevname"
"systemd-resolved"
)

# dnf group info standard
# selective
standard=(
"cifs-utils"
"compsize"
"cyrus-sasl-plain"
"iptstate"
"man-pages"
"mtr"
"passwdqc"
"pciutils"
"realmd"
"rsync"
"time"
)

# dnf group info workstation-product
# selective
workstation=(
"pam_afs_session"
"plymouth-system-theme"
"thermald"
"uresourced"
)

# exclude
exclude=(
"-x PackageKit"
"-x PackageKit-glib"
"-x braille-printer-app"
"-x cpp"
"-x edk2-shell-x64"
"-x hunspell-en"
"-x hunspell-en-AU"
"-x hunspell-en-CA"
"-x initscripts-service"
"-x libwnck3"
"-x gnome-software-fedora-langpacks"
"-x gnome-software-rpm-ostree"
"-x gnome-tour"
"-x liberation-mono-fonts"
"-x gdouros-symbola-fonts"
"-x julietaula-montserrat-fonts"
"-x kernel-tools"
"-x python3-perf"
"-x qemu-kvm-core"
"-x qemu-device-*"
)

dnf in -y \
${gnome_desktop[@]} \
${hardware_support[@]} \
${multimedia[@]} \
${printing[@]} \
${container_management[@]} \
${input_methods[@]} \
${misc[@]} \
${core[@]} \
${standard[@]} \
${workstation[@]} \
${groups[@]} \
${exclude[@]}

# for testing in a virtual machine
#dnf in -y @guest-agents @guest-desktop-agents

dnf clean all
