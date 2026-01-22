#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   USERS="ubuntu root" /root/happy-autostart/install.sh
#   /root/happy-autostart/install.sh ubuntu root

UNIT_DIR="/etc/systemd/system"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/units"

USERS="${USERS:-${*:-}}"
if [[ -z "${USERS}" ]]; then
  echo "Usage: USERS=\"user1 user2\" $0   or   $0 user1 user2" >&2
  exit 1
fi

install -d -m 0755 /etc/happy-autostart

for user in ${USERS}; do
  home_dir=$(getent passwd "$user" | cut -d: -f6)
  if [[ -z "${home_dir}" ]]; then
    echo "User not found: ${user}" >&2
    exit 1
  fi
  cat > "/etc/happy-autostart/${user}.env" <<ENV
HOME=${home_dir}
USER=${user}
HAPPY_HOME_DIR=${home_dir}/.happy
ENV
  chmod 0644 "/etc/happy-autostart/${user}.env"

done

install -m 0644 "$SRC_DIR/happy-daemon@.service" "$UNIT_DIR/happy-daemon@.service"
install -m 0644 "$SRC_DIR/happy-codex@.service" "$UNIT_DIR/happy-codex@.service"
install -m 0644 "$SRC_DIR/happy-claude@.service" "$UNIT_DIR/happy-claude@.service"

systemctl daemon-reload

for user in ${USERS}; do
  systemctl enable "happy-daemon@${user}" "happy-codex@${user}" "happy-claude@${user}"
  systemctl restart "happy-daemon@${user}" "happy-codex@${user}" "happy-claude@${user}"

done
