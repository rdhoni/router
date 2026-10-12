# 🚀 MbahRouter

<p align="center">
  <b>High-Performance Universal AI Multi-Provider Proxy, Load Balancer, Token Saver & Web Management Center</b>
</p>

<p align="center">
  <a href="https://github.com/rdhoni/router/releases/tag/latest"><img src="https://img.shields.io/badge/Release-Latest-blue.svg?style=flat-square" alt="Release Latest"></a>
  <a href="https://github.com/rdhoni/router/releases/tag/latest"><img src="https://img.shields.io/badge/Architecture-AMD64%20%7C%20ARM64-success.svg?style=flat-square" alt="Architecture"></a>
  <a href="https://golang.org"><img src="https://img.shields.io/badge/Go-1.26+-00ADD8.svg?style=flat-square" alt="Go Version"></a>
  <a href="#-akses-web-management-dashboard"><img src="https://img.shields.io/badge/Web%20UI-Embedded-orange.svg?style=flat-square" alt="Web UI Embedded"></a>
  <a href="#-lisensi"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat-square" alt="License"></a>
</p>

---

## 📖 Tentang MbahRouter

**MbahRouter** adalah server gateway dan proxy AI universal berkecepatan tinggi yang dirancang untuk VPS Linux. MbahRouter menerjemahkan berbagai protokol AI (OpenAI, Anthropic Claude, Google Gemini / AI Studio / Vertex, OpenAI Codex, Antigravity, Kimi, Qoder, Grok/xAI, Cline, Kiro, OpenCode, Freebuff, dan provider lainnya) ke dalam endpoint API standar yang kompatibel dengan berbagai AI IDE dan coding client.

Semua fitur termasuk **Web Management Center (CPAMC)** sudah tertanam (**embedded**) langsung ke dalam binary executable tunggal—sehingga Anda **tidak memerlukan Node.js, NPM, atau web server tambahan** untuk menjalankannya di VPS!

---

## ✨ Fitur Unggulan

- 🌐 **Multi-Provider AI Gateway**: Akses multi-akun untuk Claude, Codex, Gemini, Antigravity, Grok, Kimi, Qoder, dan provider OpenAI-compatible lainnya.
- 🖥️ **Embedded Web Management Dashboard**: Dashboard visual bawaan di port `8317` (`/` dan `/management`) untuk mengelola kredensial akun, model aliases, dan pengaturan.
- ⚡ **In-Process Token Savers**: Mengurangi konsumsi token secara otomatis melalui kompresi context pintar (**RTK**, **Caveman**, **Ponytail**, dan **Snip request densifier**).
- 🔄 **Auto OAuth Token Refresh**: Pembaharuan token OAuth otomatis dengan dukungan kustomisasi **Browser User-Agent** dan **HTTP Headers** per-provider.
- ⚖️ **Multi-Account Load Balancing**: Rotasi akun otomatis dengan round-robin untuk mendistribusikan beban dan menghindari rate-limit.
- 🩺 **Health Inspection & Diagnostics**: Pemeriksaan konektivitas akun dan pengujian model langsung dari dashboard.
- 🚀 **Ultra Ringan & Portabel**: Binary mandiri (single binary) untuk Linux AMD64 (x86_64) dan Linux ARM64 (aarch64).

---

## 📥 Download Binary Rilis Terbaru

Binary rilis selalu diperbarui secara otomatis dan dapat langsung diunduh dari [GitHub Releases](https://github.com/rdhoni/router/releases/tag/latest):

| Arsitektur | Target Perangkat / VPS | URL Unduhan Langsung |
| :--- | :--- | :--- |
| **Linux AMD64** | Intel / AMD VPS (Ubuntu, Debian, CentOS, Rocky Linux, dll.) | [`server-linux-amd64`](https://github.com/rdhoni/router/releases/download/latest/server-linux-amd64) |
| **Linux ARM64** | Oracle Cloud Ampere, AWS Graviton, Raspberry Pi 4/5 (64-bit) | [`server-linux-arm64`](https://github.com/rdhoni/router/releases/download/latest/server-linux-arm64) |

---

## ⚡ Panduan Instalasi Cepat (Quick Start)

### Metode 1: One-Line Installer (Otomatis)

Jalankan perintah ini di terminal VPS Anda:

```bash
curl -sSL https://raw.githubusercontent.com/rdhoni/router/main/install.sh | bash
```

Skrip ini akan secara otomatis:
1. Mendeteksi arsitektur prosesor VPS Anda (AMD64 atau ARM64).
2. Mengunduh binary rilis terbaru ke `/usr/local/bin/mbahrouter`.
3. Menyiapkan template konfigurasi `/etc/mbahrouter/config.yaml`.
4. Memberikan instruksi untuk menjalankan server.

---

### Metode 2: Unduh Manual (Manual Download)

#### Untuk Linux AMD64 (Standar x86_64):
```bash
# 1. Unduh binary
curl -L -o mbahrouter https://github.com/rdhoni/router/releases/download/latest/server-linux-amd64

# 2. Berikan izin eksekusi
chmod +x mbahrouter

# 3. Unduh contoh konfigurasi
curl -sSL -o config.yaml https://raw.githubusercontent.com/rdhoni/router/main/config.example.yaml

# 4. Jalankan MbahRouter
./mbahrouter --config config.yaml
```

#### Untuk Linux ARM64 (Oracle Cloud Ampere / AWS Graviton):
```bash
# 1. Unduh binary
curl -L -o mbahrouter https://github.com/rdhoni/router/releases/download/latest/server-linux-arm64

# 2. Berikan izin eksekusi
chmod +x mbahrouter

# 3. Unduh contoh konfigurasi
curl -sSL -o config.yaml https://raw.githubusercontent.com/rdhoni/router/main/config.example.yaml

# 4. Jalankan MbahRouter
./mbahrouter --config config.yaml
```

---

## ⚙️ Konfigurasi (`config.yaml`)

Buat file konfigurasi bernama `config.yaml` di direktori yang sama atau gunakan template [config.example.yaml](config.example.yaml):

```yaml
# Host bind interface. "" berarti mendengarkan semua antarmuka (0.0.0.0 / IPv4 + IPv6).
host: ""

# Port server
port: 8317

# Pengaturan Remote Management & Dashboard Web UI
remote-management:
  allow-remote: true
  secret-key: "password-rahasia-dashboard-anda"  # Ganti dengan password login yang aman!
  disable-control-panel: false

# Direktori tempat file kredensial/akun disimpan
auth-dir: "auths"

# Kunci API yang digunakan oleh client (Cursor, Claude Code, Cline, cURL, dll.)
api-keys:
  - "sk-mbahrouter-secret-key-1"
  - "sk-mbahrouter-secret-key-2"

# Aktifkan log debug jika diperlukan
debug: false
```

> [!TIP]
> **Mode Database Murni (PostgreSQL)**:
> Jika Anda tidak ingin menggunakan penyimpanan file lokal, MbahRouter mendukung database PostgreSQL secara penuh. Cukup atur environment variable sebelum menjalankan binary:
> ```bash
> export PGSTORE_ENABLED=true
> export PGSTORE_DSN="postgres://user:password@localhost:5432/mbahrouter?sslmode=disable"
> ```

---

## 🖥️ Akses Web Management Dashboard

Setelah MbahRouter berjalan, buka browser di komputer/ponsel Anda:

```text
http://<IP-VPS-ANDA>:8317/
```

1. Masukkan **Secret Key** yang Anda atur di bagian `remote-management.secret-key` pada `config.yaml`.
2. Setelah login, Anda dapat:
   - **Menambahkan Akun AI**: Login via OAuth atau unggah file JSON kredensial (Claude, Codex, Antigravity, Grok, Gemini, dll.).
   - **Pengaturan Global Provider**: Mengatur kustomisasi **Browser User-Agent** dan **Kustom HTTP Headers** untuk masing-masing provider autentikasi.
   - **OAuth Token Refresh**: Memantau pembaharuan otomatis token akses secara berkala.
   - **Health Inspection**: Memeriksa status kesehatan dan latensi koneksi ke masing-masing provider.
   - **Model Fallback & Aliasing**: Memetakan model panggilan ke model upstream tertentu.

---

## 🔌 Integrasi ke Client AI & AI IDE

MbahRouter menyediakan endpoint standar yang kompatibel dengan berbagai client:

### 1. Cursor / Windsurf / NextChat / Chatbox (OpenAI Compatible)
- **Base URL / Endpoint**: `http://<IP-VPS-ANDA>:8317/v1`
- **API Key**: Gunakan salah satu key dari daftar `api-keys` pada `config.yaml` (misal: `sk-mbahrouter-secret-key-1`).
- **Model**: Pilih model sesuai akun yang tersedia (misal: `gpt-4o`, `claude-3-7-sonnet`, `gemini-2.5-pro`).

### 2. Claude Code CLI
Atur environment variable sebelum menjalankan `claude`:
```bash
export ANTHROPIC_BASE_URL="http://<IP-VPS-ANDA>:8317"
export ANTHROPIC_API_KEY="sk-mbahrouter-secret-key-1"
claude
```

### 3. Cline / Roo Code / Continue (VS Code Extension)
- **Provider**: OpenAI Compatible
- **Base URL**: `http://<IP-VPS-ANDA>:8317/v1`
- **API Key**: `sk-mbahrouter-secret-key-1`

### 4. Contoh Pengujian cURL (Chat Completions)
```bash
curl http://<IP-VPS-ANDA>:8317/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-mbahrouter-secret-key-1" \
  -d '{
    "model": "gpt-4o",
    "messages": [
      {"role": "user", "content": "Halo MbahRouter!"}
    ]
  }'
```

---

## 🛠️ Menjalankan sebagai Background Service (Systemd)

Agar MbahRouter berjalan otomatis di latar belakang dan restart saat VPS reboot, konfigurasikan systemd service:

### 1. Buat file service:
```bash
sudo nano /etc/systemd/system/mbahrouter.service
```

### 2. Isi dengan konfigurasi berikut:
```ini
[Unit]
Description=MbahRouter AI Proxy Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/mbahrouter
ExecStart=/usr/local/bin/mbahrouter --config /etc/mbahrouter/config.yaml
Restart=always
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

### 3. Aktifkan dan jalankan service:
```bash
# Reload daemon
sudo systemctl daemon-reload

# Aktifkan autostart saat boot dan jalankan sekarang
sudo systemctl enable --now mbahrouter

# Cek status service
sudo systemctl status mbahrouter
```

### 4. Melihat log realtime:
```bash
sudo journalctl -u mbahrouter -f
```

---

## 🛡️ Firewall & Keamanan VPS

Pastikan port `8317` terbuka di firewall VPS Anda:

```bash
# Untuk UFW (Ubuntu/Debian)
sudo ufw allow 8317/tcp

# Untuk Firewalld (CentOS/AlmaLinux/Rocky)
sudo firewall-cmd --permanent --add-port=8317/tcp
sudo firewall-cmd --reload
```

> [!WARNING]
> Jangan lupa untuk mengizinkan port `8317` pada **Security Group / Ingress Rules** di provider cloud Anda (seperti Oracle Cloud, AWS, GCP, DigitalOcean, atau Linode).

---

## 🎛️ Command-Line Flags (CLI Options)

| Flag | Deskripsi | Default |
| :--- | :--- | :--- |
| `--config <path>` | Menentukan jalur ke file konfigurasi YAML | `config.yaml` |
| `--standalone` | Menjalankan server dalam mode standalone | `false` |
| `--tui` | Menjalankan dengan antarmuka Terminal UI (Bubbletea) | `false` |
| `--local-model` | Menonaktifkan pembaruan otomatis registry model dari remote | `false` |
| `--no-browser` | Jangan membuka browser otomatis saat proses OAuth | `false` |
| `--oauth-callback-port <port>` | Port lokal untuk callback redirect OAuth | Otomatis |

---

## ❓ FAQ & Troubleshooting

<details>
<summary><b>1. Dashboard tidak bisa diakses dari browser luar (Connection Refused / Timeout)?</b></summary>
Pastikan:
1. `host: ""` diatur pada `config.yaml` (bukan `127.0.0.1`).
2. `remote-management.allow-remote: true` diaktifkan.
3. Port `8317` telah dibuka di UFW dan Security Group/VPC Cloud Console Anda.
</details>

<details>
<summary><b>2. Bagaimana cara menghemat token dengan Token Saver?</b></summary>
Token Savers (RTK, Caveman, Ponytail, Snip) sudah terintegrasi dan aktif secara otomatis. Jika ada request yang membutuhkan pesan asli tanpa kompresi, client cukup menambahkan header HTTP:
<code>X-MbahRouter-Token-Saver: off</code>
</details>

<details>
<summary><b>3. Bagaimana cara memperbarui MbahRouter ke versi terbaru?</b></summary>
Cukup unduh binary rilis terbaru dari <a href="https://github.com/rdhoni/router/releases/tag/latest">GitHub Releases</a>, gantikan file binary lama, lalu restart service:
<pre><code>sudo systemctl restart mbahrouter</code></pre>
</details>

<details>
<summary><b>4. Error "open /etc/mbahrouter/provider-credentials.db: permission denied"?</b></summary>
Penyebab: Binary dijalankan oleh pengguna biasa (non-root) yang belum memiliki izin tulis ke direktori sistem <code>/etc/mbahrouter/</code>. MbahRouter memerlukan izin tulis untuk database konfigurasi dan data usage-keeper.
<br><br>
Solusi cepat (berikan kepemilikan folder ke user Anda):
<pre><code>sudo chown -R $USER:$USER /etc/mbahrouter
sudo chmod -R 775 /etc/mbahrouter</code></pre>
Atau jalankan melalui systemd service (otomatis berjalan sebagai service daemon):
<pre><code>sudo systemctl enable --now mbahrouter</code></pre>
</details>


---

## 📄 Lisensi

Didistribusikan di bawah lisensi MIT.
Dikembangkan dan dikelola oleh [@rdhoni](https://github.com/rdhoni).