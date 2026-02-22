# Stage 1: Get AWG binaries
FROM --platform=linux/amd64 amneziavpn/amneziawg-go:latest AS awg-binaries

# Stage 2: Get wg-easy UI
FROM --platform=linux/amd64 ghcr.io/gennadykataev/awg-easy:latest AS wg-easy

# Stage 3: Combine everything
FROM --platform=linux/amd64 node:20-alpine

# Install dependencies
RUN apk add --no-cache bash iptables ip6tables dumb-init

# Copy AWG binaries
COPY --from=awg-binaries /usr/bin/amneziawg-go /usr/bin/amneziawg-go
COPY --from=awg-binaries /usr/bin/awg /usr/bin/awg
COPY --from=awg-binaries /usr/bin/awg-quick /usr/bin/awg-quick

# Create symlinks
RUN ln -sf /usr/bin/awg /usr/bin/wg &&     ln -sf /usr/bin/awg-quick /usr/bin/wg-quick

# Copy wg-easy app
COPY --from=wg-easy /app /app

# Ensure node_modules are present
RUN cd /app && npm install --production --no-optional 2>/dev/null || true

# Apply patches for AWG 2.0
COPY config.js /app/config.js
COPY wireguard-patch.sh /tmp/patch.sh
RUN chmod +x /tmp/patch.sh && WG_CONFIG_NAME=awg0 /tmp/patch.sh && rm /tmp/patch.sh

# Create directories
RUN mkdir -p /etc/amnezia/amneziawg /etc/wireguard

# Environment variables
ENV WG_QUICK_USERSPACE_IMPLEMENTATION=amneziawg-go
ENV WG_SUDO=
ENV NODE_ENV=production

# Copy combined entrypoint
COPY entrypoint-with-ui.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8443/udp 51822/tcp

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
