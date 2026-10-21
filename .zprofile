# Recover terminals launched from a deleted working directory.
if ! /bin/pwd -P >/dev/null 2>&1; then builtin cd -- "$HOME"; fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
