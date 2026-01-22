# Happy Autostart (systemd templates)

A minimal, shareable autostart bundle for **Happy** sessions on Linux using systemd templates.
It starts the Happy daemon plus `happy` (Claude) and `happy codex` at boot for any list of users.

## What it installs

Templated units:
- `happy-daemon@.service`
- `happy-claude@.service`
- `happy-codex@.service`

Per-user env files:
- `/etc/happy-autostart/<user>.env`

## Install

```
# enable for specific users
USERS="ubuntu root" ./install.sh

# or
./install.sh ubuntu root
```

## Verify

```
systemctl status happy-daemon@ubuntu
systemctl status happy-claude@ubuntu
systemctl status happy-codex@ubuntu
```

## Uninstall (disable autostart)

```
USERS="ubuntu root" bash -c '
  for u in $USERS; do
    systemctl disable --now happy-daemon@${u} happy-claude@${u} happy-codex@${u}
    rm -f /etc/happy-autostart/${u}.env
  done
'
```

## Notes

- Requires `happy` installed at `/usr/local/bin/happy` and `happy-daemon-ensure` at `/usr/local/bin/happy-daemon-ensure`.
- The units are template-based, so no per-user unit files are duplicated.
- To add another user, just rerun `install.sh` with that user in `USERS`.

## Files

```
units/happy-daemon@.service
units/happy-claude@.service
units/happy-codex@.service
install.sh
```

## License

MIT
