#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[install] %s\n' "$1"
}

ensure_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This installer currently supports macOS only.\n' >&2
    exit 1
  fi
}

load_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi
}

install_homebrew() {
  if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  load_homebrew
}

link_path() {
  local source_path="$1"
  local target_path="$2"
  local current_link=""
  local backup_target=""

  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" ]]; then
    current_link="$(readlink "$target_path")"
    if [[ "$current_link" == "$source_path" ]]; then
      log "Already linked: $target_path"
      return
    fi
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_target="$BACKUP_DIR/${target_path#$HOME/}"
    mkdir -p "$(dirname "$backup_target")"
    mv "$target_path" "$backup_target"
    log "Backed up $target_path -> $backup_target"
  fi

  ln -sfn "$source_path" "$target_path"
  log "Linked $target_path"
}

bootstrap_zim() {
  if [[ ! -e "$HOME/.zim/zimfw.zsh" ]]; then
    log "Bootstrapping zimfw"
    mkdir -p "$HOME/.zim"
    curl -fsSL -o "$HOME/.zim/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi

  TERM=xterm-256color zsh -ic exit >/dev/null 2>&1 || true
}

bootstrap_tmux() {
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi

  if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
  fi
}

configure_git_delta() {
  log "Configuring git-delta"
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global delta.side-by-side true
  git config --global merge.conflictstyle zdiff3
  git config --global diff.colorMoved default
}

build_bat_cache() {
  if command -v bat >/dev/null 2>&1; then
    bat cache --build >/dev/null 2>&1 || true
  fi
}

install_dotfiles() {
  link_path "$ROOT_DIR/.zshrc" "$HOME/.zshrc"
  link_path "$ROOT_DIR/.zprofile" "$HOME/.zprofile"
  link_path "$ROOT_DIR/.zimrc" "$HOME/.zimrc"
  link_path "$ROOT_DIR/.profile" "$HOME/.profile"
  link_path "$ROOT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  link_path "$ROOT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

  link_path "$ROOT_DIR/starship.toml" "$HOME/.config/starship.toml"
  link_path "$ROOT_DIR/atuin" "$HOME/.config/atuin"
  link_path "$ROOT_DIR/bat" "$HOME/.config/bat"
  link_path "$ROOT_DIR/fastfetch" "$HOME/.config/fastfetch"
  link_path "$ROOT_DIR/kitty" "$HOME/.config/kitty"
  link_path "$ROOT_DIR/neovide" "$HOME/.config/neovide"
  link_path "$ROOT_DIR/nvim" "$HOME/.config/nvim"
  link_path "$ROOT_DIR/yazi" "$HOME/.config/yazi"
}

main() {
  ensure_macos
  install_homebrew

  log "Installing packages from Brewfile"
  brew tap homebrew/cask-fonts >/dev/null
  brew bundle --file "$ROOT_DIR/Brewfile"

  install_dotfiles
  bootstrap_zim
  bootstrap_tmux
  configure_git_delta
  build_bat_cache

  log "Done. Restart the terminal or run: exec zsh"
  if [[ -d "$BACKUP_DIR" ]]; then
    log "Backups saved in $BACKUP_DIR"
  fi
}

main "$@"
