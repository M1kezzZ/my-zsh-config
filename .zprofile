emulate sh
[ -f "$HOME/.profile" ] && source "$HOME/.profile"
emulate zsh

if [[ "${LANG:-}" == "C.UTF-8" ]]; then
  export LANG="en_AU.UTF-8"
fi

if [[ "${LC_CTYPE:-}" == "C.UTF-8" ]]; then
  export LC_CTYPE="en_AU.UTF-8"
fi

if [[ "${LC_ALL:-}" == "C.UTF-8" ]]; then
  unset LC_ALL
fi

path_prepend_if_exists() {
  [ -d "$1" ] || return
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

path_prepend_if_exists "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
path_prepend_if_exists "/Applications/Postgres.app/Contents/Versions/latest/bin"

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
path_prepend_if_exists "$PYENV_ROOT/bin"

export PATH

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
