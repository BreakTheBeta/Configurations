# New Mac checklist

## 1. Core install and shell

- [ ] Run the README bootstrap. Keep `~/Projects/Configurations` in place: dotfiles point to it.
- [ ] Open a new login shell (`exec zsh -l`), check `echo $EDITOR`, `z --help`, and `nvim --version`.
- [ ] Install Neovim plugins: `nvim --headless '+PlugInstall --sync' +qall`. Run `:PlugStatus`, then `:TSUpdate` in Neovim. Plugin commits were captured from the old laptop so its `nvim-treesitter.configs` API remains available. Parser downloads still depend on upstream availability. Full plugin installation was not run during the audit.
- [ ] Set Git identity in `~/.gitconfig.local` using `git config --file ~/.gitconfig.local user.name 'YOUR NAME'` and `git config --file ~/.gitconfig.local user.email 'YOUR EMAIL'`.
- [ ] Review `config/zshrc.local.example` and privately restore needed work aliases. Oh My Zsh loads once; optional tools are guarded. The live shell's `gp` ultimately meant `git push`, and that is preserved. The source laptop also had a work-specific `_hashme` completion inside zsh-vi-mode; migrate it privately if still needed.

## 2. Alacritty, font and tmux

- [ ] Install Alacritty manually from [the project's releases](https://github.com/alacritty/alacritty/releases). The source laptop ran **0.15.0** ([matching release](https://github.com/alacritty/alacritty/releases/tag/v0.15.0)); choose that for the closest match or review config migration when installing a newer version. The Homebrew cask is disabled as of this audit for failing Gatekeeper checks, so it is deliberately absent from the Brewfile. Follow macOS's explicit Open Anyway flow in Privacy & Security only after checking the downloaded artifact's source; no blanket quarantine removal is scripted.
- [ ] Confirm `DejaVuSansM Nerd Font Mono` exists in Font Book. The core Brewfile installs `font-dejavu-sans-mono-nerd-font`. Terminal font size is 12, opacity 0.83, initial dimensions 168×42, and padding 2×0.
- [ ] Open Alacritty, start `tmux new -s main`. `Ctrl-F` is the prefix; prefix `v` splits left/right, `s` splits top/bottom, `h/j/k/l` move, `H/J/K/L` resize. Mouse is on, windows/panes start at 1, terminal type ends up `screen-256color` as on the old machine.
- [ ] Check Alacritty's `Ctrl-Shift-T` creates a tmux window and `Ctrl-Shift-W` kills a pane; Ctrl-Tab / Ctrl-Shift-Tab cycle windows. Ctrl-Shift-H/J/K/L move panes; Ctrl-Shift-arrow resizes. Ctrl-left/right move by words. Cmd-W is intentionally disabled in Alacritty.
- [ ] Run prefix `I` (capital i) once if TPM reports missing plugins. Bootstrap clones TPM and tmux-sensible, the two enabled plugins. tmux-colortag existed on disk but was commented out, so it is not enabled.

## 3. Keyboard and macOS feel

- [ ] Preview then apply `python3 scripts/configure.py macos --apply`; log out/in to activate preferences. Captured values include Dark appearance, key repeat 2, initial delay 15, press-and-hold off, automatic period substitution off, tiny Dock icons (16), Finder icon view, bottom-right hot corner value 14 (Quick Note), disabled input-source switch shortcuts and the recorded symbolic hotkeys. Other defaults are left to macOS.
- [ ] Set **Australian** as the keyboard input source. Region/language/display resolution should be chosen for the new machine rather than importing hardware IDs.
- [ ] In System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys, select each keyboard and reproduce its mapping. The generic keyboard on the source laptop had **Caps Lock → Escape**. The external keyboard with USB vendor/product **5426/534** also had **left Command ↔ left Option**, **right Command ↔ right Option**, and **Caps Lock → Escape**. The 13/61664 device only had identity mappings. The exact old mappings are recorded in `inventory/keyboard-modifiers.json`; do not copy the old ByHost UUID or assume a new keyboard has the same device ID.
- [ ] Set “Press 🌐 key to” to **Do Nothing** (`AppleFnUsageType = 0`) so Fn remains available to Handy. Confirm Caps Lock and external-keyboard modifier behaviour in a text field.
- [ ] Karabiner was installed, but its captured selected profile contains no remapping rules. Install/apply that optional profile only if wanted; the useful modifier remaps above came from macOS, not Karabiner. Grant its requested Input Monitoring/driver permissions if using it.
- [ ] The trackpad had tap-to-click **off**, secondary click **on**, three-finger drag **off**, and normal pinch/rotate/Space gestures. Re-select those in Trackpad/Accessibility if needed. Do not import device-specific calibration values.

## 4. Window switching and positioning

- [ ] Install **Based AltTab** (the ad-free fork, not upstream AltTab), following [forks.md](forks.md), and Rectangle from the core Brewfile. Quit both and apply `python3 scripts/configure.py apps --apply`.
- [ ] Grant AltTab Accessibility and Screen Recording permissions; grant Rectangle Accessibility. Open both and verify with multiple windows.
- [ ] AltTab has zero display delay, small appearance settings, and the recorded **Command hold** shortcut. The recorded second “next window” shortcut is Tab. Other unset controls inherit the pinned fork's defaults; inspect its Shortcuts panel and test Cmd-Tab. Archived ShortcutRecorder data in its plist is intentional shortcut data, with no license or telemetry export.
- [ ] In Rectangle, verify **Ctrl-Option-H** = left half and **Ctrl-Option-L** = right half. `toggleTodo` is Ctrl-Option-B and `reflowTodo` is Ctrl-Option-N; these depend on support in the installed Rectangle version. The source ran Rectangle 0.69; current Homebrew versions may add or rename features.
- [ ] Enable Rectangle launch at login (captured preference) and AltTab start at login. The old laptop had a user launch agent for AltTab; an example is in `config/apps/alttab-launchagent.example`. Prefer the app's own startup setting. If that does not create a working login item, copy the example to `~/Library/LaunchAgents/com.lwouis.alt-tab-macos.plist` and run `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.lwouis.alt-tab-macos.plist`. Use one startup mechanism and verify after logging out/in.

## 5. Handy dictation

- [ ] Install Handy (core Brewfile); source version is **0.9.8**. Quit it and apply `python3 scripts/configure.py handy --apply`.
- [ ] Open it and finish onboarding, grant **Microphone** and **Accessibility**, and download/select its **turbo** model. The recipe does not copy model files or pretend a model download has completed.
- [ ] Confirm English transcription, en-AU UI, **Fn toggle** recording, Escape cancel, Ctrl-V paste method, bottom live overlay, no audio feedback, no automatic submit, start hidden and autostart enabled. Press Fn, speak, press Fn again, and verify text appears in the focused editor. Post-processing is disabled; no API keys/prompts are copied.

## 6. Tailscale and T3 Code Fold

- [ ] Core bootstrap installs **tailscale-app**, the standalone GUI variant matching bundle ID `io.tailscale.ipn.macsys` (source version 1.92.3). Do not also install the `tailscale` daemon formula or the App Store variant. Follow [Tailscale's variant guidance](https://tailscale.com/docs/concepts/macos-variants) if switching variants.
- [ ] Launch Tailscale, allow the system/network extension and VPN configuration, log into the existing tailnet, approve the new device if required, and enable launch at login. Re-select any exit node/routes/DNS settings deliberately. No node keys, addresses, tailnet identities or VPN state are published here.
- [ ] Check `'/Applications/Tailscale.app/Contents/MacOS/Tailscale' status`. Set up its CLI integration from app settings if desired. A successful app install alone does not prove tailnet connectivity.
- [ ] Install **T3 Code Fold** from the personal fork, not upstream Homebrew; follow [forks.md](forks.md). Before its first launch, apply `python3 scripts/configure.py t3 --apply` from Terminal. For a later restore, quit desktop **and stop background servers** first; do not run a restore from an agent inside T3.
- [ ] Complete T3 onboarding, authenticate provider CLIs, and recreate Connections using the new device/credentials. Reconnect remote environments over the tailnet through T3's normal connection flow. Do not reuse old pairing tokens or copy its connection catalog.
- [ ] Check Vim mode, comfortable chat width, stacked diffs, interface/prompt/code/terminal sizes 16/14/13/12, animations at 0 ms, notifications off and green backdrop. Captured keybindings include Cmd-J terminal and Cmd-Shift-J preview. Desktop window bounds and browser profiles are intentionally not migrated.

## 7. Editors, accounts and validation

- [ ] Quit Code, Cursor and Zed; apply `python3 scripts/configure.py editors --apply`. This replaces their settings and keybindings after backing up existing files. VS Code's obsolete `zsh_cline` profile was replaced with ordinary zsh; the old keybindings files' malformed comment header was repaired while preserving bindings.
- [ ] Install captured extension IDs: `while IFS= read -r ext; do code --install-extension "$ext"; done < config/editors/code-extensions.txt`, and the equivalent using `cursor` / `cursor-extensions.txt`. If CLIs are absent, enable “Install … command in PATH” from each editor. Do not reuse the old `/usr/local/bin/code` symlink: it pointed into a temporary App Translocation directory. Removed/private extensions may need manual replacement.
- [ ] Authenticate GitHub (`gh auth login`), configure SSH keys, sign into Bitwarden, browsers and other chosen apps. The audit found stale local `gh` credentials; do not copy them.
- [ ] Install/sign into providers used in T3. Codex is in the core Brewfile; run `codex login` ([official instructions](https://developers.openai.com/codex/cli)). Optionally apply the minimal Codex model preferences; project trust, plugin caches and credentials are not copied. Claude Code was installed globally via npm; install it using its current [official instructions](https://code.claude.com/docs/en/setup), then `claude auth login`. Cursor's agent CLI is a separate install from the editor: [official CLI](https://cursor.com/cli), then `agent login`.
- [ ] Run `./scripts/doctor.sh`. It reports missing dependencies/logins without printing credential files. Then log out/in and test app startup, terminal shortcuts, keyboard remaps, window snapping, dictation and remote T3 access. These hands-on checks cover permissions and state that dotfiles cannot reproduce.
