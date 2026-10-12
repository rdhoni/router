#!/usr/bin/env bash
# ==============================================================================
# MbahRouter Installer Script for Linux VPS (AMD64 & ARM64)
# Repository: https://github.com/rdhoni/router
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BLUE}${BOLD}======================================================${RESET}"
echo -e "${BLUE}${BOLD}           MbahRouter Installer for Linux             ${RESET}"
echo -e "${BLUE}${BOLD}======================================================${RESET}"

# 1. Detect Architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64)
        BINARY_NAME="server-linux-amd64"
        ;;
    aarch64|arm64)
        BINARY_NAME="server-linux-arm64"
        ;;
    *)
        echo -e "${RED}[ERROR] Arsitektur '$ARCH' tidak didukung secara otomatis.${RESET}"
        echo -e "Silakan gunakan arsitektur AMD64 (x86_64) atau ARM64 (aarch64)."
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/rdhoni/router/releases/download/latest/${BINARY_NAME}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
CONFIG_DIR="${CONFIG_DIR:-/etc/mbahrouter}"
BIN_PATH="${INSTALL_DIR}/mbahrouter"

# Check root / sudo permission
SUDO=""
REAL_USER="$(id -un)"
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
        REAL_USER="${SUDO_USER:-$(id -un)}"
    else
        echo -e "${YELLOW}[WARN] Berjalan tanpa root dan sudo tidak tersedia.${RESET}"
        INSTALL_DIR="$(pwd)"
        CONFIG_DIR="$(pwd)/mbahrouter-config"
        BIN_PATH="${INSTALL_DIR}/mbahrouter"
    fi
else
    REAL_USER="${SUDO_USER:-root}"
fi
REAL_GROUP="$(id -gn "$REAL_USER" 2>/dev/null || echo "$REAL_USER")"

echo -e "${GREEN}✓ Terdeteksi arsitektur:${RESET} ${BOLD}${ARCH}${RESET} -> ${BINARY_NAME}"
echo -e "${BLUE} Mengunduh binary MbahRouter...${RESET}"
echo -e "  Sumber: ${DOWNLOAD_URL}"

TMP_BIN=$(mktemp)
curl -fL --progress-bar -o "$TMP_BIN" "$DOWNLOAD_URL"

echo -e "${GREEN}✓ Menginstal binary ke ${BIN_PATH}...${RESET}"
$SUDO mkdir -p "$INSTALL_DIR"
$SUDO mv "$TMP_BIN" "$BIN_PATH"
$SUDO chmod +x "$BIN_PATH"

# Setup config template & auths directory
$SUDO mkdir -p "$CONFIG_DIR"
$SUDO mkdir -p "${CONFIG_DIR}/auths"

if [ ! -f "${CONFIG_DIR}/config.yaml" ]; then
    echo -e "${BLUE} Mengunduh template config.example.yaml...${RESET}"
    TMP_CFG=$(mktemp)
    if curl -sSL -f -o "$TMP_CFG" "https://raw.githubusercontent.com/rdhoni/router/main/config.example.yaml"; then
        $SUDO mv "$TMP_CFG" "${CONFIG_DIR}/config.yaml"
    else
        rm -f "$TMP_CFG"
        echo -e "${YELLOW} Membuat config.yaml default minimal...${RESET}"
        $SUDO tee "${CONFIG_DIR}/config.yaml" >/dev/null << 'EOF'
host: ""
port: 8317
remote-management:
  allow-remote: true
  secret-key: "changeme123"
  disable-control-panel: false
auth-dir: "/etc/mbahrouter/auths"
api-keys:
  - "sk-mbahrouter-secret"
debug: false
EOF
    fi
    echo -e "${GREEN}✓ File konfigurasi dibuat di:${RESET} ${CONFIG_DIR}/config.yaml"
else
    echo -e "${YELLOW}ℹ File konfigurasi sudah ada di:${RESET} ${CONFIG_DIR}/config.yaml"
fi

# Set proper ownership & permissions on CONFIG_DIR so runtime can write SQLite db & auths
if [ -n "$SUDO" ] || [ "$(id -u)" -eq 0 ]; then
    $SUDO chown -R "${REAL_USER}:${REAL_GROUP}" "$CONFIG_DIR"
    $SUDO chmod -R 775 "$CONFIG_DIR"
fi

# Optional Systemd Service Setup
if command -v systemctl >/dev/null 2>&1 && [ -d "/etc/systemd/system" ]; then
    SERVICE_FILE="/etc/systemd/system/mbahrouter.service"
    $SUDO tee "$SERVICE_FILE" >/dev/null << EOF
[Unit]
Description=MbahRouter AI Multi-Provider Proxy Service
After=network.target

[Service]
Type=simple
User=${REAL_USER}
WorkingDirectory=${CONFIG_DIR}
ExecStart=${BIN_PATH} --config ${CONFIG_DIR}/config.yaml
Restart=always
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
    $SUDO systemctl daemon-reload 2>/dev/null || true
    echo -e "${GREEN}✓ Systemd service disiapkan di:${RESET} ${SERVICE_FILE}"
fi

echo -e "\n${GREEN}${BOLD}✓ Instalasi MbahRouter Berhasil!${RESET}"
echo -e "------------------------------------------------------"
echo -e "Opsi 1: Jalankan sebagai Background Service (Direkomendasikan):"
echo -e "  ${BOLD}sudo systemctl enable --now mbahrouter${RESET}"
echo -e "  Cek status : ${BOLD}sudo systemctl status mbahrouter${RESET}"
echo -e "  Cek log    : ${BOLD}sudo journalctl -u mbahrouter -f${RESET}"
echo -e ""
echo -e "Opsi 2: Jalankan manual di foreground:"
echo -e "  ${BOLD}${BIN_PATH} --config ${CONFIG_DIR}/config.yaml${RESET}"
echo -e ""
echo -e "Akses Web Management Dashboard:"
echo -e "  ${BOLD}http://<IP-VPS-ANDA>:8317/${RESET}"
echo -e "------------------------------------------------------\n"
