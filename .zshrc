# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

if [[ "${LANG:-}" == "C.UTF-8" ]]; then
  export LANG="en_AU.UTF-8"
fi

if [[ "${LC_CTYPE:-}" == "C.UTF-8" ]]; then
  export LC_CTYPE="en_AU.UTF-8"
fi

if [[ "${LC_ALL:-}" == "C.UTF-8" ]]; then
  unset LC_ALL
fi

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

if [[ -e ${ZDOTDIR:-${HOME}}/.zcompdump.zwc ]]; then
  chmod u+w ${ZDOTDIR:-${HOME}}/.zcompdump.zwc 2>/dev/null || true
fi

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install
# ----------------------------------------------------------------------------------------------------------------------------------
path_prepend_if_exists() {
  [[ -d "$1" ]] || return
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

command_exists() {
  (( ${+commands[$1]} ))
}

export EDITOR="${EDITOR:-cursor}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less -R}"
export BAT_THEME="${BAT_THEME:-Visual Studio Dark+}"

if command_exists starship; then
  eval "$(starship init zsh)"
fi

if command_exists eza; then
  alias ld='eza -lDh --icons'
  alias ldt='eza -lh --icons --git --tree --level=3'
  alias lf='eza -lfh --icons --git'
  alias lh='eza -dlh .* --icons --git --group-directories-first'
  alias la='eza -alh --icons --git --sort=size --group-directories-first'
  alias ls='eza -lh --icons --git --color=always --sort=size --group-directories-first'
  alias lt='eza -alh --icons --git --sort=modified'
fi

command_exists lazygit && alias lg='lazygit'
command_exists nvim && alias v='nvim'
command_exists nvim && alias vim='nvim'
command_exists neovide && alias nv='neovide --title-hidden'
command_exists neovide && alias nvide='neovide --title-hidden'
command_exists fastfetch && alias ff='fastfetch'
alias reload-shell='exec zsh'

if [[ -d "$HOME/.sdkman" ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
path_prepend_if_exists "$PYENV_ROOT/bin"
if command_exists pyenv; then
  eval "$(pyenv init - zsh)"
fi

for conda_root in "$HOME/miniconda3" "$HOME/anaconda3" "/opt/miniconda3" "/opt/anaconda3"; do
  if [[ -d "$conda_root" ]]; then
    export CONDA_ROOT="$conda_root"
    break
  fi
done
unset conda_root

if [[ -n "${CONDA_ROOT:-}" ]]; then
  export CONDA_AUTO_ACTIVATE_BASE=false
  path_prepend_if_exists "$CONDA_ROOT/condabin"
  if [[ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]]; then
    conda() {
      unset -f conda
      source "$CONDA_ROOT/etc/profile.d/conda.sh"
      conda "$@"
    }
  fi
fi

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

if command_exists bat; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
fi

if command_exists brew && command_exists fzf && [[ -t 0 ]] && [[ -t 1 ]]; then
  FZF_BASE="$(brew --prefix fzf 2>/dev/null)"
  if [[ -f "$FZF_BASE/shell/key-bindings.zsh" ]]; then
    source "$FZF_BASE/shell/key-bindings.zsh"
  fi
  unset FZF_BASE
fi

if command_exists direnv; then
  eval "$(direnv hook zsh)"
fi

if command_exists atuin; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# fzf-tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

yy() {
  command_exists yazi || return 127
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if [[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
  source "$HOME/.openclaw/completions/openclaw.zsh"
fi
