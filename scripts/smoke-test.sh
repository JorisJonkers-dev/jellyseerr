#!/usr/bin/env bash
# Starts the image restricted (uid 1000, a read-only root, every capability dropped), with only the
# paths the Project mounts writable, and waits until it serves.
# Usage: scripts/smoke-test.sh <jellyseerr-image>
set -euo pipefail
owned='uid=1000,gid=1000'

cleanup() { docker rm -f smoke-jellyseerr >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup

docker run -d --name smoke-jellyseerr --read-only --cap-drop ALL \
  --tmpfs "/tmp:$owned,mode=1777" --tmpfs "/app/config:$owned" "$1" >/dev/null

# seerr's Alpine base carries busybox wget, not curl.
served=false
for _ in $(seq 1 60); do
  if docker exec smoke-jellyseerr wget -q -O /dev/null http://127.0.0.1:5055/api/v1/settings/public 2>/dev/null; then
    served=true
    break
  fi
  if [ "$(docker inspect -f '{{.State.Running}}' smoke-jellyseerr)" != true ]; then
    docker logs smoke-jellyseerr 2>&1 | tail -30
    echo "jellyseerr exited before it served" >&2
    exit 1
  fi
  sleep 3
done
[ "$served" = true ] || { docker logs smoke-jellyseerr 2>&1 | tail -30; echo "jellyseerr never served" >&2; exit 1; }
others=$(docker top smoke-jellyseerr -eo pid,uid | tail -n +2 | awk '$2 != 1000')
[ -z "$others" ] || { echo "jellyseerr runs a process as another uid: $others" >&2; exit 1; }
echo "jellyseerr serves /api/v1/settings/public as uid 1000"
echo "smoke test passed"
