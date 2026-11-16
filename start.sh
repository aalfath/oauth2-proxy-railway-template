#!/bin/sh
# Railway wrapper for OAuth2 Proxy: fills in the settings Railway can derive,
# then hands over to the official binary. Every value can be overridden with
# a service variable of the same name.
set -eu

# Listen on Railway's PORT.
export OAUTH2_PROXY_HTTP_ADDRESS="${OAUTH2_PROXY_HTTP_ADDRESS:-0.0.0.0:${PORT:-4180}}"

# Callback on this service's public Railway domain (or a custom one you set).
if [ -z "${OAUTH2_PROXY_REDIRECT_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export OAUTH2_PROXY_REDIRECT_URL="https://${RAILWAY_PUBLIC_DOMAIN}/oauth2/callback"
fi

# Railway terminates TLS in front of the service.
export OAUTH2_PROXY_REVERSE_PROXY="${OAUTH2_PROXY_REVERSE_PROXY:-true}"
export OAUTH2_PROXY_COOKIE_SECURE="${OAUTH2_PROXY_COOKIE_SECURE:-true}"

# Pass the signed-in user to the upstream and keep health checks out of the logs.
export OAUTH2_PROXY_PASS_USER_HEADERS="${OAUTH2_PROXY_PASS_USER_HEADERS:-true}"
export OAUTH2_PROXY_SET_XAUTHREQUEST="${OAUTH2_PROXY_SET_XAUTHREQUEST:-true}"
export OAUTH2_PROXY_SILENCE_PING_LOGGING="${OAUTH2_PROXY_SILENCE_PING_LOGGING:-true}"

# Refuse to start without the settings that make it safe.
missing=""
for v in OAUTH2_PROXY_PROVIDER OAUTH2_PROXY_CLIENT_ID OAUTH2_PROXY_CLIENT_SECRET \
         OAUTH2_PROXY_COOKIE_SECRET OAUTH2_PROXY_UPSTREAMS OAUTH2_PROXY_EMAIL_DOMAINS; do
  eval "val=\${$v:-}"
  [ -n "$val" ] || missing="$missing $v"
done
if [ -n "$missing" ]; then
  echo "oauth2-proxy: missing required variables:$missing" >&2
  exit 1
fi

exec /bin/oauth2-proxy "$@"
