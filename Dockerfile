# Multi-stage build for custom Caddy with plugins
FROM docker.io/golang:alpine AS builder

# Install git and ca-certificates
RUN apk add --no-cache git ca-certificates

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build custom Caddy with plugins !! ADD YOUR PLUGIN LINKS HERE !!
RUN xcaddy build \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddy-dns/cloudflare

# Production stage
FROM docker.io/alpine:latest

# Install ca-certificates for HTTPS and create caddy user
RUN apk --no-cache add ca-certificates tzdata && \
    addgroup -g 1000 -S caddy && \
    adduser -u 1000 -D -S -G caddy caddy

# Copy the custom caddy binary
COPY --from=builder /go/caddy /usr/bin/caddy

# Create necessary directories with proper ownership
RUN mkdir -p /etc/caddy /var/lib/caddy /var/log/caddy && \
    chown -R caddy:caddy /etc/caddy /var/lib/caddy /var/log/caddy

# Set proper permissions
RUN chmod 755 /usr/bin/caddy

# Expose ports
EXPOSE 80 443 2019

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD caddy version || exit 1

# Set working directory
WORKDIR /etc/caddy

# Switch to caddy user
USER caddy

# Default command
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]