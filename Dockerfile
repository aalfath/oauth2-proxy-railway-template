# OAuth2 Proxy for Railway: official image, pinned by version and digest.
FROM quay.io/oauth2-proxy/oauth2-proxy:v7.15.6-alpine@sha256:398b6e2ee5b8c9d61ae8f099236568b9eae9cdc28f5645542bb1e03d57d477ed

COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh

ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
