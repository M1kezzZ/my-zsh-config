# my-zsh-config

这是我自己的 macOS terminal / shell 配置仓库。

目标很简单：

- 新 Mac 可以直接从 GitHub 拉下来并一键安装
- 本机上的 `zsh`、`kitty`、`tmux`、`neovim`、`yazi` 配置统一收口
- 平时如果我在 `~` 或 `~/.config` 里改了配置，也能快速同步回 repo

## 现在包含什么

- `zsh` + `zimfw`
- `starship` prompt
- `fzf-tab` + `zoxide`
- `direnv`
- `atuin`
- `kitty`
- `tmux`
- `neovim` + `neovide`
- `yazi`
- `bat`
- `fastfetch`
- `git-delta`

## 新 Mac 安装

直接运行：

```bash
git clone https://github.com/M1kezzZ/my-zsh-config.git ~/my-zsh-config
cd ~/my-zsh-config
./install.sh
exec zsh
```

## `install.sh` 会做什么

- 自动安装 Homebrew
- 根据 `Brewfile` 安装我常用的 terminal 工具和 app
- 备份当前机器上已有的 dotfiles 到 `~/.dotfiles-backup/<timestamp>/`
- 把 repo 里的配置文件软链接到 `~` 和 `~/.config`
- 自动 bootstrap `zimfw`
- 自动安装 tmux TPM plugins
- 自动把 `git-delta` 设成 Git 默认 diff pager
- 自动重建 `bat` cache

## 仓库结构

- 根目录 dotfiles:
  - `.zshrc`
  - `.zprofile`
  - `.zimrc`
  - `.tmux.conf`
  - `.profile`
- app 配置目录:
  - `nvim`
  - `yazi`
  - `kitty`
  - `neovide`
  - `bat`
  - `fastfetch`
  - `atuin`
- prompt 配置:
  - `starship.toml`
- 安装与同步脚本:
  - `install.sh`
  - `scripts/sync-from-home.sh`

## 日常维护

如果当前机器已经通过 `install.sh` 链接到这个 repo，那么平时直接改 repo 里的文件就行。

如果我是在 `~/.zshrc` 或 `~/.config/...` 里直接改的，也可以同步回 repo：

```bash
cd ~/my-zsh-config
./scripts/sync-from-home.sh
git status
```

## 当前配置的一些约定

- 现在实际启用的 prompt 是 `starship`
- `.p10k.zsh` 只是旧配置备份，当前不启用
- `conda` 改成 lazy-load，减少 shell 启动时间
- `atuin` 默认启用，但默认不自动 sync
- `direnv` 已接入，项目目录里可以直接用 `direnv allow`
- `fastfetch` 已配置好，可以直接运行 `ff`

## 推荐安装后的检查

```bash
ff
tmux
nvim
yazi
git diff
```

## 想重新应用 repo 配置

```bash
cd ~/my-zsh-config
./install.sh
```
