# Private migration and keeping the recipe current

The public recipe rebuilds the environment; it is not a backup of personal data. Keep an encrypted Time Machine or equivalent private backup of the old Mac before retiring it. Keep the recovery key/password separately and test that the backup can be read.

## Restore or reauthenticate privately

- SSH/GPG keys and `~/.ssh/config`: transfer through an encrypted channel or generate new keys and enrol them. Restore owner-only permissions (`chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/config` and private keys), use the macOS keychain intentionally, and test access. Never put keys in this repo.
- Work shell aliases, project paths, `_hashme` completions, private module hosts, Git URL rewrites and cloud credential paths: review the old `.zshrc` / `.gitconfig` backup and put only needed settings into `~/.zshrc.local` / `~/.gitconfig.local`. The public bootstrap replaces those main files after backing them up. Work repositories and tools must be cloned/rebuilt separately.
- Cloud/kube/VPN accounts: log into gcloud, Docker registries and other providers again; obtain kubeconfigs through the normal organization process. The recipe excludes `~/.aws`, `~/.kube`, gcloud credentials, registry credentials and VPN state.
- Tailscale: enrol the new Mac as its own node, approve it, then verify access. Do not clone the old node identity. Retire the old device through the account admin flow when ready.
- Browsers, Bitwarden, purchased apps, Steam, editor account sync and password/passkey stores: use the relevant account or encrypted migration flow. Never export browser storage/cookies to Git.
- T3/provider history: the recipe intentionally creates fresh runtime state. For history migration, use the application's supported backup/export/restore path. If taking a filesystem backup, stop all T3 processes first and back up the **whole required state consistently**, including SQLite WAL sidecars when present, to encrypted storage. Do not copy a live `.sqlite` file on its own or test against live `~/.t3/userdata`. Secrets, connection catalogs, Clerk tokens and server owner identity need private handling and may require reauthentication/re-pairing even after restore.
- Codex/Claude: log in again. Only a minimal Codex model/effort starting point is public; trusted project directories, installed plugin identities/state, histories, sessions, auth files and databases are omitted. Reinstall chosen public/custom skills from their original sources after reviewing them. System-provided skills belong to the tool installation. Claude's “always thinking” preference was enabled on the old machine; its permission-prompt bypass is deliberately not copied into a fresh setup.
- Handy: download its model; recordings, transcription history, post-processing providers/API keys and custom vocabulary are private. The recipe restores only the selected public behaviour settings.
- Databases, Docker volumes, Obsidian vaults, notes, documents, local models, IDE workspaces and app licences are personal data; restore/export separately. Do not use this config repo as their storage.

## Refreshing the recipe

Change the managed file and review `git diff` before publishing. For plist preferences, export locally and copy only the keys whose behaviour you intend to preserve; never commit a whole unexplained preference domain. Update source pins only after testing the fork/plugin change. Keep previous recipe commits available for older laptop builds.

To refresh software lists, capture `brew leaves`, `brew list --versions` and app bundle metadata; review for private taps or URLs before committing. Do not use a recursive home-directory sync, whole T3/Codex exports, or `git add ~`. `.gitignore` is a convenience, not proof that a file is safe to publish.

Backups made by `configure.py` can contain your old private settings; they stay under `~/.config-backups` outside the repository. Keep that directory private and include it only in encrypted personal backups.
