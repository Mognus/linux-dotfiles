# GPG Secrets

Encrypted secrets live in `~/.local/share/secrets/` (permissions: `700`).

## Encrypt

```bash
echo "SECRET" | gpg --symmetric --armor -o ~/.local/share/secrets/name.gpg
# or a file:
gpg --symmetric --armor -o ~/.local/share/secrets/name.gpg ~/path/to/file
```

GPG asks for a passphrase interactively — enter it twice.

## Decrypt

```bash
gpg -d ~/.local/share/secrets/name.gpg
```

gpg-agent caches the passphrase for ~10 minutes. To force re-prompt:

```bash
gpgconf --reload gpg-agent
```

## Current Secrets

| File | Contents |
|------|----------|
| `<service>.gpg` | ... |

## Use in Scripts

```bash
# e.g. pass mullvad account number directly to CLI
mullvad account login $(gpg -d ~/.local/share/secrets/mullvad.gpg)
```

## GPG Keyserver

If a key import fails, try:

```bash
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEY-ID>
```
