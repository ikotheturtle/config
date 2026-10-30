# Load custom aliases
source "$HOME/.config/aliases"

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"
export VI_MODE_ESC_INSERT="jk" && plug "zap-zsh/vim"
plug "Aloxaf/fzf-tab"
plug "zap-zsh/fzf"
plug "wintermi/zsh-starship"

# No delay vim mode goes brrr
export KEYTIMEOUT=1

# go to project
fp() {
    local project_dir
    project_dir=$(fd '^\.git$' ~/ /storage /docker \
        --hidden \
        --no-ignore \
        --type d \
        --prune \
        --exclude '.cache' \
        --exclude 'node_modules' \
        --exclude '.local' \
        2>/dev/null --exec echo {//} | fzf --height 50% --layout=reverse --border)

    if [ -n "$project_dir" ]; then
        cd "$project_dir"
        zle && zle reset-prompt
    fi
}

# pass
pass-fzf() {
    local target
    target=$(find ~/.password-store -name "*.gpg" | sed "s|${HOME}/.password-store/||; s|.gpg$||" | fzf)

    if [ -n "$target" ]; then
        if pass "$target" | grep -q "^otpauth://"; then
            pass otp -c "$target"
        else
            pass -c "$target"
        fi
    fi
}

# Copy file contents to clipboard
cpc() {
    if (( $# != 1 )); then
        echo "Usage: cpc <file>"
        return 1
    fi

    if [[ ! -f "$1" || ! -r "$1" ]]; then
        echo "Error: file not found or not readable: $1"
        return 1
    fi

    wl-copy < "$1" && echo "Copied contents of: $1"
}

mkdir() {
    command mkdir -p "$@"
}

# Zsh widget wrapper
fp-widget() { fp; }
pass-fzf-widget() { pass-fzf; }
zle -N fp-widget
zle -N pass-fzf

bindkey '^g' fp-widget
bindkey '^p' pass-fzf

# Ctrl + Backspace: delete previous word
bindkey '^H' backward-kill-word
bindkey '^W' backward-kill-word

eval "$(fnm env --use-on-cd --shell zsh)"
# Load and initialise completion system
autoload -Uz compinit
compinit

# go binaries
export PATH="$HOME/go/bin:$PATH"

# pnpm binaries
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
