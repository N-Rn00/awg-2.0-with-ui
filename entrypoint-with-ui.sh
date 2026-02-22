#!/bin/bash
set -e

echo "=== AmneziaWG 2.0 + Web UI ==="
echo ""

# Get AWG parameters from environment or use defaults
JC=${JC:-5}
JMIN=${JMIN:-50}
JMAX=${JMAX:-1000}
S1=${S1:-83}
S2=${S2:-111}
H1=${H1:-1634716843}
H2=${H2:-1948862386}
H3=${H3:-1386309140}
H4=${H4:-128735623}
S3=${S3:-33}
S4=${S4:-6}
I1=${I1:-a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6}
I2=${I2:-f1e2d3c4b5a6f7e8d9c0b1a2f3e4d5c6b7a8f9e0d1c2b3a4f5e6d7c8b9a0f1e2d3c4b5a6f7e8d9c0b1a2f3e4d5c6}
I3=${I3:-1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d}
I4=${I4:-6f7e8d9c0b1a2f3e4d5c6b7a8f9e0d1c2b3a4f5e6d7c8b9a0f1e2d3c4b5a6f7e8d9c0b1a2f3e4d5c6b7a8f9e0d1c}
I5=${I5:-c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6}

WG_PORT=${WG_PORT:-443}

# Determine outbound interface (from env or auto-detect)
if [ -n "$WAN_INTERFACE" ]; then
    OUTBOUND_IFACE="$WAN_INTERFACE"
    echo "Using configured interface: $OUTBOUND_IFACE"
else
    OUTBOUND_IFACE=$(ip route | grep default | head -1 | awk '{print $5}')
    echo "Auto-detected interface: $OUTBOUND_IFACE"
fi

# Проверяем наличие конфига
CONFIG_PATH=/etc/amnezia/amneziawg/awg0.conf
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Creating default config at $CONFIG_PATH..."

    # Генерируем приватный ключ
    PRIVKEY=$(wg genkey)
else
    # Config exists - fix interface if it changed
    echo "Checking existing config for interface updates..."
    sed -i "s/-o eth[0-9]\+/-o $OUTBOUND_IFACE/g" "$CONFIG_PATH"
    echo "Interface in config updated to: $OUTBOUND_IFACE"
fi

if [ ! -f "$CONFIG_PATH" ]; then

    cat > "$CONFIG_PATH" << CONFEOF
[Interface]
Address = 10.8.0.1/24
ListenPort = $WG_PORT
PrivateKey = $PRIVKEY
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $OUTBOUND_IFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $OUTBOUND_IFACE -j MASQUERADE

# AWG parameters
Jc = $JC
Jmin = $JMIN
Jmax = $JMAX
S1 = $S1
S2 = $S2
H1 = $H1
H2 = $H2
H3 = $H3
H4 = $H4
S3 = $S3
S4 = $S4
I1 = $I1
I2 = $I2
I3 = $I3
I4 = $I4
I5 = $I5
CONFEOF

    echo "Config created successfully!"
fi

echo ""
echo "Starting AmneziaWG on port $WG_PORT..."
awg-quick up awg0

echo ""
echo "AmneziaWG started successfully!"
awg show awg0

echo ""
echo "Starting Web UI on port ${PORT:-51821}..."
cd /app
exec node server.js
