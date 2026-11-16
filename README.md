# OAuth2 Proxy on Railway

Railway template for [OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) **v7.15.6**. It puts a Google, GitHub, Microsoft Entra ID or any OpenID Connect login in front of a service that already runs in your Railway project.

## What it deploys

One service, built from this repo's `Dockerfile`:

- `FROM quay.io/oauth2-proxy/oauth2-proxy:v7.15.6-alpine@sha256:398b6e2ee5b8c9d61ae8f099236568b9eae9cdc28f5645542bb1e03d57d477ed` (the official image, pinned by digest)
- `start.sh`: a small wrapper that listens on Railway's `PORT`, sets the callback URL to `https://<public domain>/oauth2/callback`, turns on the reverse-proxy and secure-cookie settings, and refuses to start if a required setting is missing.

Sessions live in encrypted cookies, so the service keeps no data and needs no volume. Health check: `/ping`.

## Variables

| Variable | Default | What it is |
|---|---|---|
| `OAUTH2_PROXY_UPSTREAMS` | (you set it) | The service to protect, over the private network, e.g. `http://${{web.RAILWAY_PRIVATE_DOMAIN}}:${{web.PORT}}` |
| `OAUTH2_PROXY_PROVIDER` | `google` | `google`, `github`, `entra-id`, `gitlab`, `oidc`, ... |
| `OAUTH2_PROXY_CLIENT_ID` | (you set it) | OAuth client ID from your identity provider |
| `OAUTH2_PROXY_CLIENT_SECRET` | (you set it) | OAuth client secret |
| `OAUTH2_PROXY_EMAIL_DOMAINS` | (you set it) | Allowed email domains, comma-separated (`example.com`). `*` allows any account the provider signs in |
| `OAUTH2_PROXY_OIDC_ISSUER_URL` | empty | Only for `oidc` and similar providers |
| `OAUTH2_PROXY_COOKIE_SECRET` | `${{secret(32)}}` | Generated cookie encryption key |
| `PORT` | `4180` | Port the proxy listens on |

Register this callback URL with your provider: `https://YOUR-DOMAIN/oauth2/callback`. Any other [OAuth2 Proxy setting](https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview) can be added as an `OAUTH2_PROXY_*` variable.

## Updates

When this repo's `main` changes (for example a new OAuth2 Proxy version), Railway shows an "update available" notice on projects deployed from the template, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first: breaking changes are listed at the top of each entry.
