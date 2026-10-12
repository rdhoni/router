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
        echo -e "Silakan build dari source atau gunakan arsitektur AMD64 / ARM64."
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/rdhoni/router/releases/download/latest/${BINARY_NAME}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
CONFIG_DIR="${CONFIG_DIR:-/etc/mbahrouter}"
BIN_PATH="${INSTALL_DIR}/mbahrouter"

# Check root / sudo permission if installing to system directories
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo -e "${YELLOW}[WARN] Berjalan tanpa root dan sudo tidak tersedia.${RESET}"
        INSTALL_DIR="$(pwd)"
        CONFIG_DIR="$(pwd)"
        BIN_PATH="${INSTALL_DIR}/mbahrouter"
    fi
fi

echo -e "${GREEN}✓ Terdeteksi arsitektur:${RESET} ${BOLD}${ARCH}${RESET} -> ${BINARY_NAME}"
echo -e "${BLUE} Mengunduh binary MbahRouter...${RESET}"
echo -e "  Sumber: ${DOWNLOAD_URL}"

TMP_BIN=$(mktemp)
curl -fL --progress-bar -o "$TMP_BIN" "$DOWNLOAD_URL"

echo -e "${GREEN}✓ Menginstal binary ke ${BIN_PATH}...${RESET}"
$SUDO mkdir -p "$INSTALL_DIR"
$SUDO mv "$TMP_BIN" "$BIN_PATH"
$SUDO chmod +x "$BIN_PATH"

# Setup config template
$SUDO mkdir -p "$CONFIG_DIR"
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
auth-dir: "auths"
api-keys:
  - "sk-mbahrouter-secret"
debug: false
EOF
    fi
    echo -e "${GREEN}✓ File konfigurasi dibuat di:${RESET} ${CONFIG_DIR}/config.yaml"
else
    echo -e "${YELLOW}ℹ File konfigurasi sudah ada di:${RESET} ${CONFIG_DIR}/config.yaml"
fi

echo -e "\n${GREEN}${BOLD}✓ Instalasi MbahRouter Berhasil!${RESET}"
echo -e "------------------------------------------------------"
echo -e "Jalankan server secara langsung:"
echo -e "  ${BOLD}${BIN_PATH} --config ${CONFIG_DIR}/config.yaml${RESET}"
echo -e "\nAkses Web Management Panel:"
echo -e "  ${BOLD}http://<IP-VPS-ANDA>:8317/${RESET}"
echo -e "------------------------------------------------------\n"
