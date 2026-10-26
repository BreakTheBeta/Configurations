# Personal app forks

These are part of the setup. Installing upstream AltTab or upstream T3 Code changes behaviour. `inventory/forks.json` records the exact local source commits observed on the old laptop. Neither checkout had tracked modifications; T3's `release-assets/` directory was untracked. The source revision is evidence of the checkout, not proof that the installed binary was built from it.

Preview `python3 scripts/checkout-forks.py`, then append `--apply` to clone both into `~/Projects`. Existing directories are preserved without checkout/reset/pull. Clones use HTTPS so initial setup does not need SSH keys. They are detached at the recorded commit; make a branch deliberately before development.

## AltTab

**Install Based AltTab: [BreakTheBeta/based-alttab](https://github.com/BreakTheBeta/based-alttab), branch `based`.** It's AltTab 11.10.1 with every paid-feature restriction, Pro badge, upgrade/support prompt and the updater removed: no ads, no nags. Don't install upstream AltTab or the Homebrew cask instead. Pinned commit: `e811fc54` (“Based AltTab: remove paid-feature restrictions and promotions”). The bundle ID is unchanged (`com.lwouis.alt-tab-macos`), so existing preferences carry over. The older `master` branch (11.1.0 with a `BASED=1` build flag, commit `eb25838e`) is superseded.

Install full Xcode, open it once, accept its licence and install requested platform components. Point Command Line Tools at it if necessary (`sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`). Then test and build an optimized release without the original developer's signing certificate:

```sh
cd ~/Projects/alt-tab-macos
bash ai/test.sh
SCHEME=Release CONFIGURATION=Release bash ai/build.sh \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= \
  'OTHER_CODE_SIGN_FLAGS=--timestamp=none' build
```

Use a local self-signed identity instead of `-` if you have one; macOS then keeps Accessibility/Screen Recording grants across rebuilds. The expected product is `DerivedData/Build/Products/Release/AltTab.app`; confirm it exists and inspect its signature (`codesign -dv PATH`) before installation. Quit the existing AltTab first, back it up if present, and copy the built app to `/Applications/AltTab.app`. Local signing changes can require granting Accessibility/Screen Recording again. Never copy signing certificates or a populated `config/local.xcconfig` into this public config repo.

This build has no in-app updater, and the exported app preferences disable upstream automatic checks, so nothing replaces it. To update, rebase `based` onto a newer upstream release, rebuild and reinstall deliberately.

## T3 Code Fold

Repository: [BreakTheBeta/T3codefold](https://github.com/BreakTheBeta/T3codefold). Audited source commit: `8d48a1ec8` (“fix(release): resolve catalog versions in Fold runtime packages”). Installed desktop: `T3 Code (Beta).app`, version `0.4.5-preview.20261018.1`, bundle ID `com.t3tools.t3code`.

Prefer a macOS arm64/universal DMG from [the fork's releases](https://github.com/BreakTheBeta/T3codefold/releases) that contains the desired changes. macOS artifacts are not guaranteed on every release. Do not use the stale 0.1.3 DMGs found in the old checkout's `release-assets/` merely because they exist locally. Do not install upstream's Homebrew package as a replacement.

If an appropriate macOS artifact is absent, the audited checkout declares Node `^24.13.1`, pnpm `11.10.0`, and uses Vite+ (`vp`). With full Xcode and optional build dependencies installed:

```sh
# Run in a shell where nvm is loaded by the captured .zshrc.
nvm install 24.13.1
nvm use 24.13.1
brew install rustup cmake
rustup-init -y --no-modify-path
# Follow the fork README to install Vite+; review the installer before running it:
# https://viteplus.dev/guide/ (the audited README uses https://vite.plus)
cd ~/Projects/t3code-fold-voice
vp i
vp run dist:desktop:dmg:arm64
```

The fork release workflow uses Rust 1.95.0; if the default Rust toolchain fails, install it and use the same version (`rustup toolchain install 1.95.0`, then `rustup override set 1.95.0` in the checkout). Consult the pinned checkout's README and build-script help if build tooling changes. Use the resulting DMG reported by the build, then drag the app to Applications. Unsigned local builds require deliberate macOS approval and do not gain signed automatic updates by copying a config file. The build is a manual step and was not run during this audit.

Only `client-settings.json`, `keybindings.json` and `settings.json` are restored to `~/.t3/userdata`. This does not migrate threads, projects, connections, server identity, provider accounts, browser logins, keys or databases. Start fresh or follow the private backup procedure separately. Never start a test server against a live T3 home.
