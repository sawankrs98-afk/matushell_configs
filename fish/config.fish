################## Fish Settings ##################

# PATH
fish_add_path -g -p $HOME/bin $HOME/.local/bin /usr/local/bin

# Default terminal
if not set -q TERMINAL
    set -gx TERMINAL foot
end

################### APP CONFIG ####################

# FZF setup
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline --color=16"
set -gx FZF_CTRL_T_OPTS "--preview '[ -d {} ] && ls -C {} | head -20 || cat {} | head -100'"

# Yazi setup
set -gx YAZI_CONFIG_HOME "$HOME/.config/yazi"

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	command rm -f -- "$tmp"
end

# Zoxide setup
set -gx _ZO_FZF_OPTS "--height 40% --layout=reverse --border"

#################### ALIASES ######################

# With eza
alias l="eza --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias ll="eza -lah --icons --git"
alias lt="eza --tree --icons"

# Reload alias
alias rel="source ~/.config/fish/config.fish"

# Edit profile alias
alias ep="\$EDITOR ~/.config/fish/config.fish"

# Alias for git
alias ga="git add ."
alias gs="git status"
alias gp="git push"
alias grm="git rm -rf --cached ."
alias gcom="git commit -m"
alias gcomam="git commit --amend --no-edit"
alias gundo="git reset --soft HEAD~1"
alias gclean="git clean -fdx"
alias glog="git log --graph --oneline --decorate"
alias lg="lazygit"

################## INTERACTIVE ####################

if status is-interactive
    # Terminal color sequences
    cat ~/.cache/matugen/sequences.txt 2>/dev/null

    # FZF shell integration
    if command -q fzf
        fzf --fish | source
    end

    # Zoxide shell integration
    if command -q zoxide
        zoxide init fish --cmd z | source
    end

    # Greeting: Matushell banner + Fastfetch
    function fish_greeting
        # Clear the screen
        clear

        # Run the Welcome Banner ONLY once per session
        if not set -q SESSION_INITIALIZED
            set -gx SESSION_INITIALIZED 1
            if test (tput cols) -ge 110; and command -q figlet
                set -l padding "    "
                set -l banner (figlet -f smslant "Matushell" | sed "s/^/$padding/")
                for line in $banner
                    if string match -rq '\S' -- "$line"
                        printf '\e[36m%s\e[0m\n' "$line"
                    end
                end
            end
        end

        # Run Fastfetch EVERY time (if the window isn't tiny)
        if test (tput cols) -ge 90; and test "$TERM_PROGRAM" != "vscode"; and command -q fastfetch
            fastfetch
        end
    end
end

# kimi-code
fish_add_path -g "/home/kuro/.kimi-code/bin"
