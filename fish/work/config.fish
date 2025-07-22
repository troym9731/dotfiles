###
# Path
###

set -gx PATH $PATH /usr/local/bin
set -gx PATH $PATH /usr/bin
set -gx PATH $PATH /bin
set -gx PATH $PATH /usr/sbin
set -gx PATH $PATH /sbin
set -gx PATH $PATH $HOME/.local/bin

###
# Editor
###

set -gx EDITOR vi

###
# Colors
###

set fish_color_normal normal
set fish_color_command green
set fish_color_param f2cdcd
set fish_color_keyword f38ba8
set fish_color_quote yellow
set fish_color_redirection magenta
set fish_color_end fab387
set fish_color_comment white
set fish_color_error red
set fish_color_gray 6c7086
set fish_color_selection --background=313244
set fish_color_search_match --background=313244
set fish_color_option green
set fish_color_operator magenta
set fish_color_escape eba0ac
set fish_color_autosuggestion 6c7086
set fish_color_cancel red
set fish_color_cwd yellow
set fish_color_user cyan
set fish_color_host blue
set fish_color_host_remote green
set fish_color_status red
set fish_pager_color_progress 6c7086
set fish_pager_color_prefix magenta
set fish_pager_color_completion normal
set fish_pager_color_description 6c7086
set fish_color_valid_path normal

###
# Keybinds
###

bind ctrl-c __fish_cancel_commandline

###
# Aliases
###

alias ls='ls -G'
alias la='ls -lAh'
alias gpsup='git push --set-upstream origin HEAD'
alias ggpush='git push origin HEAD'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gst='git status'
alias gstl='git stash list'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gds='git diff --staged'
alias gcm='git checkout master'
alias gf='git fetch'
alias gco='git checkout'
alias ghprvw='gh pr view --web'
alias ghrvw='gh repo view --web'
alias ghieaddme='gh issue edit --add-assignee @me'
alias v='nvim'
alias vd='date +"v%y.%m.%d"'

###
# Dev Scripts sourcing
###

# set -gx DEV_SCRIPTS_DIR ~/instinct/dev_scripts
# source $DEV_SCRIPTS_DIR/init_dev_scripts.sh
# set -gx PATH $PATH $DEV_SCRIPTS_DIR/scripts

# 1Password and Docker ssh agent compatibility
set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

###
# fzf
###

# Change the default fzf command to use fd
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --no-ignore --exclude .git"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
fzf --fish | source

###
# Mise
###

mise activate fish | source

###
# Zoxide
###

zoxide init fish | source

###
# Starship
###

starship init fish | source

# Final environment variables
set -gx WS_GITHUB_TOKEN (gh auth token)
set -gx ELIXIR_ERL_OPTIONS "-kernel shell_history enabled"
source ~/.config/.env.fish
