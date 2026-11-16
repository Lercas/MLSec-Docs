#!/usr/bin/env bash
# Install a pinned Linux CI binary using an independently approved checksum.
set -euo pipefail
target="${1:?usage: install-opa.sh /absolute/new/binary/path}"
expected="${OPA_SHA256:?set the approved SHA-256 for OPA 1.22.4 linux amd64 static}"
[[ "$expected" =~ ^[a-f0-9]{64}$ ]] || { echo 'Invalid OPA_SHA256' >&2; exit 2; }
[[ "$target" = /* && ! -e "$target" && ! -L "$target" ]] || { echo 'Target must be a new absolute file path, not a symlink' >&2; exit 2; }
curl --fail --silent --show-error --location \
  https://github.com/open-policy-agent/opa/releases/download/v1.22.4/opa_linux_amd64_static \
  --output "$target"
printf '%s  %s\n' "$expected" "$target" | sha256sum --check --status
chmod 700 "$target"
"$target" version
