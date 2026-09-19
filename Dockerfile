ARG CADDY_VERSION

FROM caddy:${CADDY_VERSION}-builder AS builder

ARG PROXY_VERSION
ARG CLOUDFLARE_VERSION
ARG CLOUDFLARE_IP_VERSION

RUN xcaddy build "${CADDY_VERSION}" \
    --with "github.com/lucaslorentz/caddy-docker-proxy/v2@${PROXY_VERSION}" \
    --with "github.com/caddy-dns/cloudflare@${CLOUDFLARE_VERSION}" \
    --with "github.com/WeidiDeng/caddy-cloudflare-ip@${CLOUDFLARE_IP_VERSION}"

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN caddy version \
    && caddy list-modules | grep -q "dns.providers.cloudflare" \
    && caddy list-modules | grep -q "docker_proxy" \
    && caddy list-modules | grep -q "http.ip_sources.cloudflare"

CMD ["caddy", "docker-proxy"]
