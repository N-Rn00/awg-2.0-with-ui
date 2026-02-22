# AmneziaWG 2.0 Server with Web UI

<div align="center">

![AmneziaWG](https://img.shields.io/badge/AmneziaWG-2.0-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![License](https://img.shields.io/badge/License-MIT-green)

Production-ready AmneziaWG 2.0 VPN server with modern web management interface.

[Features](#-features) • [Quick Start](#-quick-start) • [Configuration](#-configuration) • [Usage](#-usage)

</div>

---

## ✨ Features

- 🔐 **Full AmneziaWG 2.0 Support** - All obfuscation parameters (S1-S4, H1-H4, I1-I5, Jc/Jmin/Jmax)
- 🌐 **Web Management UI** - Easy client management with QR codes
- 🐳 **Docker-based** - Clean two-container architecture
- 🚀 **Userspace Mode** - No kernel module required
- 📱 **Mobile Ready** - QR codes for instant client setup
- 🔧 **Fully Configurable** - All parameters via environment variables

## 🏗️ Architecture

```
┌─────────────────┐     ┌──────────────┐
│   awg-server    │────▶│    awg-ui    │
│  (VPN Server)   │     │  (Web UI)    │
└─────────────────┘     └──────────────┘
         │                      │
         └──────────┬───────────┘
                    ▼
              Shared Network
           & Config Storage
```

Two optimized containers:
- **awg-server**: Minimal AmneziaWG VPN server
- **awg-ui**: Web interface with management tools

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Linux server with public IP
- Ports 443/UDP and 51821/TCP available

### Installation

```bash
# 1. Clone repository
git clone https://github.com/yourusername/awg-v2.git
cd awg-v2

# 2. Create configuration
cp .env.example .env
nano .env  # Edit with your settings

# 3. Generate password hash
docker run --rm node:20-alpine sh -c \
  "npm install bcryptjs && node -e \"console.log(require('bcryptjs').hashSync('YOUR_PASSWORD', 12))\""

# 4. Start services
docker-compose up -d --build
```

That's it! 🎉

## ⚙️ Configuration

Edit `.env` file:

```env
# Server settings
WG_HOST=your.server.ip        # Server IP or domain
WG_PORT=443                    # VPN port (UDP)
PORT=51821                     # Web UI port (TCP)
PASSWORD_HASH='$2a$12$...'    # bcrypt hash

# AWG 1.5 parameters
JC=5                           # Junk packet count
JMIN=50                        # Min junk size
JMAX=1000                      # Max junk size
S1=83                          # Init packet junk size
S2=111                         # Response packet junk size
H1=1634716843                  # Header 1
H2=1948862386                  # Header 2
H3=1386309140                  # Header 3
H4=128735623                   # Header 4

# AWG 2.0 NEW parameters
S3=33                          # Underload packet junk size
S4=6                           # Transport packet junk size
I1=                            # Init concealment (auto-generated if empty)
I2=                            # Response concealment
I3=                            # Underload concealment
I4=                            # Transport concealment  
I5=                            # Cookie concealment
```

### Password Generation

```bash
# Method 1: Using Docker
docker run --rm node:20-alpine sh -c \
  "npm install bcryptjs && node -e \"console.log(require('bcryptjs').hashSync('mypassword', 12))\""

# Method 2: Using online tool (less secure)
# Visit https://bcrypt-generator.com
```

## 📖 Usage

### Start/Stop

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Rebuild after changes
docker-compose up -d --build --force-recreate
```

### Access Web UI

Open in browser: `http://YOUR_SERVER_IP:51821`

Default credentials: password from `.env` PASSWORD_HASH

### Manage Clients

1. Login to Web UI
2. Click "New Client" button
3. Scan QR code with AmneziaVPN app
4. Or download `.conf` file

### Check Status

```bash
# View AWG interface
docker exec awg-ui awg show awg0

# View config
docker exec awg-ui cat /etc/amnezia/amneziawg/awg0.conf

# View server logs
docker logs awg-server

# View UI logs
docker logs awg-ui
```

## 🔧 Advanced Configuration

### Change VPN Port

```bash
# Edit .env
WG_PORT=53  # Use DNS port to bypass firewalls

# Recreate containers
docker-compose up -d --force-recreate
```

### Custom AWG Parameters

Generate random parameters for better obfuscation:

```bash
# Random hex string for I1-I5 (32-128 bytes)
openssl rand -hex 64

# Random integer for H1-H4
echo $((RANDOM * RANDOM))

# Random junk size for S1-S4 (15-150)
echo $((15 + RANDOM % 135))
```

### Backup/Restore

```bash
# Backup configs
tar -czf awg-backup.tar.gz awg-data/

# Restore configs
tar -xzf awg-backup.tar.gz
docker-compose restart
```

## 🛡️ Security Notes

- Change default password immediately
- Use strong, unique password
- Keep AWG parameters secret
- Regularly update Docker images
- Use firewall to restrict Web UI access
- Consider putting Web UI behind reverse proxy with HTTPS

## ⚠️ Important

**Use AmneziaVPN Client for connections!**

Regular WireGuard clients don't support AWG 2.0 parameters (S3, S4, I1-I5) and won't connect.

Download AmneziaVPN:
- 🍎 [iOS](https://apps.apple.com/app/amneziavpn/id1600529900)
- 🤖 [Android](https://play.google.com/store/apps/details?id=org.amnezia.vpn)
- 🪟 [Windows](https://github.com/amnezia-vpn/amnezia-client/releases)
- 🐧 [Linux](https://github.com/amnezia-vpn/amnezia-client/releases)
- 🍏 [macOS](https://github.com/amnezia-vpn/amnezia-client/releases)

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [AmneziaVPN](https://github.com/amnezia-vpn) - AmneziaWG protocol
- [wg-easy](https://github.com/wg-easy/wg-easy) - Original Web UI
- [awg-easy](https://github.com/gennadykataev/awg-easy) - AWG fork of wg-easy

## 📧 Support

- 🐛 [Report Bug](https://github.com/yourusername/awg-v2/issues)
- 💡 [Request Feature](https://github.com/yourusername/awg-v2/issues)
- 💬 [Discussions](https://github.com/yourusername/awg-v2/discussions)

---

<div align="center">

Made with ❤️ for privacy and freedom

⭐ Star this repo if you find it useful!

</div>
