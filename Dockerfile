ARG CADDY_VERSION

FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build "${CADDY_VERSION}" \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare \
	--with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN caddy version \
    && caddy list-modules | grep -q "dns.providers.cloudflare"

CMD ["caddy", "docker-proxy"]
