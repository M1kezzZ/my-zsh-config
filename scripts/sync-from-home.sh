#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

copy_file() {
  local source_path="$1"
  local target_path="$2"
  if [[ -f "$source_path" ]]; then
    cp "$source_path" "$target_path"
  fi
}

sync_dir() {
  local source_dir="$1"
  local target_dir="$2"

  if [[ -d "$source_dir" ]]; then
    rsync -a --delete --exclude '.DS_Store' --exclude '*.toml-[0-9]*' "$source_dir/" "$target_dir/"
  fi
}

copy_file "$HOME/.zshrc" "$ROOT_DIR/.zshrc"
copy_file "$HOME/.zprofile" "$ROOT_DIR/.zprofile"
copy_file "$HOME/.zimrc" "$ROOT_DIR/.zimrc"
copy_file "$HOME/.profile" "$ROOT_DIR/.profile"
copy_file "$HOME/.tmux.conf" "$ROOT_DIR/.tmux.conf"
copy_file "$HOME/.p10k.zsh" "$ROOT_DIR/.p10k.zsh"
copy_file "$HOME/.config/starship.toml" "$ROOT_DIR/starship.toml"

mkdir -p "$ROOT_DIR/atuin" "$ROOT_DIR/bat" "$ROOT_DIR/fastfetch" "$ROOT_DIR/kitty" "$ROOT_DIR/neovide" "$ROOT_DIR/nvim" "$ROOT_DIR/yazi"

sync_dir "$HOME/.config/atuin" "$ROOT_DIR/atuin"
sync_dir "$HOME/.config/bat" "$ROOT_DIR/bat"
sync_dir "$HOME/.config/fastfetch" "$ROOT_DIR/fastfetch"
sync_dir "$HOME/.config/kitty" "$ROOT_DIR/kitty"
sync_dir "$HOME/.config/neovide" "$ROOT_DIR/neovide"
sync_dir "$HOME/.config/nvim" "$ROOT_DIR/nvim"
sync_dir "$HOME/.config/yazi" "$ROOT_DIR/yazi"

rm -rf "$ROOT_DIR/.zim"

printf 'Repo synced from %s\n' "$HOME"
