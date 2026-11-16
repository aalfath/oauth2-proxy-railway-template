# Changelog

Each entry is a version of this Railway template. Breaking changes are listed first.

## 7.15.6 (2026-11-16)

- First release: OAuth2 Proxy v7.15.6 (`quay.io/oauth2-proxy/oauth2-proxy:v7.15.6-alpine`, pinned by digest).
- Listens on Railway's `PORT`, derives the callback URL from the service's public domain, health check on `/ping`.
- Sessions live in encrypted cookies, so the service is stateless and needs no volume.
