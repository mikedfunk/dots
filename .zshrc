#!/usr/bin/env zsh
# vim: set foldmethod=marker ft=zsh:

# https://unix.stackexchange.com/a/608921
# export GPG_TTY=$(tty)
export GPG_TTY=$TTY

export XDG_RUNTIME_DIR="$TMPDIR"
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache

# p10k instant prompt (must be first) {{{
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# P10k is installed as a ZSH plugin.
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
# }}}

# Paths {{{

# set up homebrew env vars and paths
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"

# when CDing from anywhere, this will add the configured path to the
# completions always. Why would I want to do this ever? It just looks like a
# bug and gets in the way.
# cdpath=(
#   $HOME/Code
#   $cdpath
# )

# de-dupe these paths
typeset -U path fpath manpath

export fpath=(
  $HOME/.docker/completions
  ${fpath:-}
)

# https://github.com/denisidoro/navi
# export navipath=(
#   $HOME/.navi
#   ${navipath:-}
# )

# export infopath=(
#   $(brew --prefix)/share/info
#   /usr/share/info
#   ${infopath:-}
# )

# export manpath=(
#   $(brew --prefix)/share/man
#   /usr/share/man
#   ${manpath:-}
# )

export path=(
  # $(brew --prefix mysql-client@8.0)/bin
  # $(brew --prefix git)/share/git-core/contrib/git-jump
  # kubectl plugin manager (plugins will be installed to this bin)
  # "${KREW_ROOT:-$HOME/.krew}"/bin
  # $HOME/.yarn/bin
  $HOME/.docker/bin
  # to install groovy-language-server
  # $(brew --prefix openjdk@17)/bin
  # my own scripts
  $HOME/.bin
  # global ruby gems
  $HOME/bin
  # global python pip packages (also lazyman)
  # $(python -m site --user-base)/bin
  # $HOME/.emacs.d/bin
  # /Applications/Docker.app/Contents/Resources/bin
  # homebrew doesn't like to link curl
  # $(brew --prefix)/opt/curl/bin
  # rust cargo packages
  $HOME/.cargo/bin
  # golang packages
  "$GOPATH"/bin
  # $HOME/go/bin
  # golang executables
  # $(brew --prefix)/opt/go/libexec/bin
  # $HOME/.composer/vendor/bin
  # $([ -f $HOME/.asdf/shims/gem ] && $HOME/.asdf/shims/gem env home)
  # /usr/{bin,sbin}
  # /{bin,sbin}
  # $(brew --prefix)/opt/icu4c/{bin,sbin}
  # add gnu coreutils before path... this seems a bit heavy-handed :/
  # $(brew --prefix)/opt/coreutils/libexec/gnubin
  $HOME/.spicetify
  ${path:-}
)
# }}}

# zsh {{{

# https://github.com/mattmc3/ez-compinit?tab=readme-ov-file#how-do-i-customize-it
# cache completion sources
# DON'T FORGET if you add a completion source to comment this out or it won't show up for a day!!
# NOTE: cache file is at ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump by default (and I don't currently change it)
# zstyle ':plugin:ez-compinit' 'use-cache' 'yes'
# }}}

# zinit (installs if missing) {{{
ZINIT_HOME="$XDG_DATA_HOME"/zinit/zinit.git
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz compinit
compinit

zinit wait lucid depth"1" light-mode for \
    Aloxaf/fzf-tab \
    atinit"zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    OMZP::vi-mode \
    blockf atpull'zinit creinstall -q .' zsh-users/zsh-completions \
    mfaerevaag/wd

zinit depth"1" light-mode for \
    romkatv/powerlevel10k \
    mroth/evalcache
# }}}

# source additional files and env vars {{{

source "$HOME"/.p10k.zsh 2>/dev/null

# xdg-ninja (move configs to proper locations) {{{

export AKAMAI_CLI_HOME="$XDG_CONFIG_HOME"/akamai
export AKAMAI_EDGERC="$XDG_CONFIG_HOME"/akamai/.edgerc
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_ECR_CACHE_DIR="$XDG_CACHE_HOME"/aws/ecr
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME"/homebrew/Brewfile
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export KUBECACHEDIR="$XDG_CACHE_HOME"/kube/cache
export KUBECONFIG="$XDG_CONFIG_HOME"/kube/config
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export MYCLI_HISTFILE="$XDG_DATA_HOME"/mycli/history
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NVM_DIR="$XDG_DATA_HOME"/nvm
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export PSPG_CONF="$XDG_CONFIG_HOME"/pspg/.pspgconf
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME"/solargraph
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export TMUXP_CONFIGDIR="$XDG_CONFIG_HOME"/tmuxp
export WEZTERM_CONFIG_FILE="$XDG_CONFIG_HOME"/wezterm/config.lua

# }}}

# https://unix.stackexchange.com/a/302418/287898
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder#usage
export ZSH_ALIAS_FINDER_AUTOMATIC=true

# disable weird highlighting of pasted text
# https://old.reddit.com/r/zsh/comments/c160o2/command_line_pasted_text/erbg6hy/
zle_highlight=('paste:none')

# weird, this should have already been done :/
builtin setopt aliases

# for newsboat
# export BROWSER="open %u"
unset BROWSER
export FLOX_DISABLE_METRICS=true

export DOCKER_CLI_HINTS=false

# default is 60
export COMPOSE_HTTP_TIMEOUT=120

# for ctop:
export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"

# https://github.com/ollama/ollama/issues/7762#issuecomment-2489192027
export OLLAMA_NUM_PARALLEL=1

export DEVPOD_HOME="$XDG_CONFIG_HOME"/devpod

export ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME"/evalcache

export AQUA_GLOBAL_CONFIG="$XDG_CONFIG_HOME"/aquaproj-aqua/aqua.yaml

export ZK_NOTEBOOK_DIR="$HOME/Notes"
export BAT_THEME="TwoDark"
# use `gO` to open a quickfix with a table of contents!
(( $+commands[nvim] )) && export MANPAGER='nvim +Man!'
source "$HOME"/.private_vars.sh 2>/dev/null
# [ -f $(brew --prefix)/etc/grc.zsh ] && source "$(brew --prefix)/etc/grc.zsh" # generic colorizer

_evalcache mise activate zsh 2>/dev/null

# https://github.com/variadico/noti/blob/master/docs/noti.md#environment
export NOTI_NSUSER_SOUNDNAME="Hero"

# https://pre-commit.com/#cli
export PRE_COMMIT_COLOR="always"

export PSQL_PAGER="pspg --clipboard-app=3"

set PLANTUML_LIMIT_SIZE=8192

export HOMEBREW_NO_ANALYTICS=1

# Ignore calls to docker login or logout and pretend they succeeded
export AWS_ECR_IGNORE_CREDS_STORAGE=true

export COMPOSER_MEMORY_LIMIT=-1

export EDITOR=nvim
export VIEWER="bat --paging=always"
export LANG=en_US.UTF-8

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
export JIRA_DEFAULT_ACTION='dashboard'

# ssh {{{
# disable autossh port monitoring and use ServerAliveInterval and
# ServerAliveCountMax instead.
# https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
export AUTOSSH_PORT=0

# https://infosec.mozilla.org/guidelines/openssh#openssh-client (med slow)
# add all keys stored in keychain if they haven't been added yet
# ssh-add --apple-use-keychain --apple-load-keychain ~/.ssh/keys/* 2>/dev/null
# Start async background job
{
  if ! ssh-add -l &>/dev/null; then
    ssh-add --apple-use-keychain --apple-load-keychain ~/.ssh/keys/* &>/dev/null
  fi
} &!
# }}}

# gpg {{{
# https://unix.stackexchange.com/a/608921
export PINENTRY_USER_DATA="USE_CURSES=1"
# }}}

# fzf {{{
export FZF_DEFAULT_OPTS="--multi"
export FZF_DEFAULT_COMMAND='ag --files-with-matches --skip-vcs-ignores -g ""'
# }}}

# }}}

# completion {{{
# adding a completion? Check here, it may already be there https://carapace-sh.github.io/carapace-bin/completers.html
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
# this might interfere with fzf-tab https://github.com/orgs/carapace-sh/discussions/2596
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
{ source <(carapace _carapace) } 2>/dev/null

_evalcache acli completion zsh 2>/dev/null
_evalcache devpod completion zsh 2>/dev/null
# }}}

# functions and aliases {{{

# misc {{{
# alias info="info --vi-keys" # info -> pinfo is like top -> htop
alias pinfo="pinfo --rcfile=$XDG_CONFIG_HOME/pinfo/pinforc"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias updatedb="/usr/libexec/locate.updatedb" # remember to sudo
alias be="bundle exec"
alias ccusage="npx -y ccusage@latest"
alias mycli="mycli --defaults-group-suffix=_mycli --prompt=' \h  '" # prompt config option stopped working :/
(( $+commands[kubecolor] )) && alias kubectl=kubecolor && compdef kubecolor=kubectl
alias k="kubectl"
compdef k="kubectl"
alias pspg="pspg --clipboard-app=3"
compdef git-spice="gs"

alias acli-login="echo $JIRA_USER_API_KEY | acli jira auth login --site $JIRA_SITE --email $JIRA_USER_EMAIL --token"

# Public: pass the current ssh alias. Used by my promptline theme and .screenrc to show the alias in the PS1.
# servers don't like anything *-256color so I need to use screen via ssh
ssh () { env TERM=screen LC_SSH_ALIAS=$1 /usr/bin/ssh $@; }
autossh () { LC_SSH_ALIAS=$1 autossh $@; }
compdef autossh="ssh"

# https://www.youtube.com/watch?v=Wl7CDe9jsuo&feature=youtu.be
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir="mkdir -vp"

cd () { builtin cd "$@" && ls -F -A -G; } # auto ls on cd
alias ..="cd .."
alias ...="cd ../.."
alias du="grc --colour=auto /usr/bin/du"

# https://github.com/sharkdp/vivid/issues/25#issuecomment-450423306
(( $+commands[eza] )) && alias ls="eza"

alias ll='ls -lhA --classify=auto'
# phpx() { php -d xdebug.start_with_request=yes -dxdebug.mode=debug,develop -dxdebug.client_port=${XDEBUG_PORT:-9003} $@; }
alias work="tmuxinator start work"
alias home="tmuxinator start home"

alias rmf='rm -rf'
compdef rmf="rm"

mkcd() { mkdir $1 && cd $1; }
compdef mkcd="mkdir"

alias src="source ~/.zshrc"
alias jobs="jobs -l"

alias pso="ps -o pid,command"
alias art="php artisan"

# alias pc="phing -logger phing.listener.DefaultLogger"
# compdef pc="phing"
#
# alias pg="phing"
# compdef pg="phing"

alias news="BROWSER='open %u' newsboat"

k9s () {
    defaults read -g AppleInterfaceStyle &>/dev/null
    local skin_file=$([ $? -eq 0 ] && echo "$XDG_CONFIG_HOME"/k9s/skins/skin_dark.yaml || echo "$XDG_CONFIG_HOME"/k9s/skins/skin_light.yaml)
    command cp "$skin_file" "$XDG_CONFIG_HOME"/k9s/skins/skin.yaml
    command k9s $@
}

alias y="yadm"
compdef y="yadm"
alias upgrades="yadm bootstrap"

save-dotfiles () { yadm encrypt && yadm add -u && yadm ci -m ${1:-working} && yadm ps; }
alias save-notes="wd notes && git add -A && git commit -am 'working' && git push"
alias save-queries"wd queries && git add -A && git commit -am 'working' && git push"

alias journal="zk journal"
alias notes="zk edit --interactive"
alias tmux-layout="tmux display-message -p \"#{window_layout}\""

# fuzzy wd
wf () { wd $(wd list | gsed '1d' | fzf | gsed -E 's/^ +(\w+).*$/\1/'); }

# ls colors by default
export CLICOLOR=1

# pretty-print PATH with line breaks
pretty-path () { tr : '\n' <<<"$PATH"; }

alias multitail="multitail -F $XDG_CONFIG_HOME/multitail/multitail.conf"
# }}}

# phpunit {{{
alias pu="phpunitnotify"

# phpunit coverage
puc-html() { pu --coverage-html=./coverage $@ && open coverage/index.html; }
alias puc='pu --coverage-cobertura="coverage/cobertura.xml"'
alias puf="pu --filter="

# phpunit watch
puw() {
    noglob ag -l -g \
        '(application|library|src|app|tests|spec|domain|adapter)/.*\.php' \
        | entr -c \
        noti --message "✅ ${PWD##*/} PHPUnit tests passed" \
        php \
        -dmemory_limit=2048M \
        -ddisplay_errors=on \
        -dxdebug.mode=off \
        ./vendor/bin/phpunit \
        --colors=always \
        $@
}

# phpunit coverage watch
pucw() {
    noglob ag -l -g \
        '(application|library|src|app|tests|spec|domain|adapter)/.*\.php' \
        | entr -cr \
        php \
        -dmemory_limit=2048M \
        -ddisplay_errors=on \
        -dxdebug.mode=coverage \
        ./vendor/bin/phpunit \
        --colors=always \
        --coverage-cobertura="coverage/cobertura.xml" \
        $@
}
# }}}

# composer {{{
alias c="composer"
compdef c="composer"
# }}}

# git {{{
alias g="git"
compdef g="git"
alias ts="tig status"
alias td="tig develop.."
# }}}

# go test {{{
alias gtw="noglob ag -l -g '.*\\.go' | entr -cr noti --message \"✅ Go tests passed\" go test"
# }}}

# phpspec {{{
alias psr="phpspecnotify"
alias psd="phpspec describe"
psw() {
    noglob ag -l -g '.*\.php' \
        | entr -cr \
        noti --message "✅ ${PWD##*/} PHPSpec passed" \
        php \
        -dmemory_limit=1024M \
        -ddisplay_errors=off \
        -dxdebug.mode=off \
        ./vendor/bin/phpspec run --no-interaction -vvv $@
}

# phpspec coverage
psc-html() {
    php -dxdebug.mode=coverage \
        -dmemory_limit=3G \
        ./vendor/bin/phpspec run \
        --config ./phpspec-coverage-html.yml \
        --no-interaction \
        --no-code-generation \
        -vvv \
        $@ \
        && open coverage/index.html
}
alias psc="php \
    -dxdebug.mode=coverage \
    -dmemory_limit=2G \
    ./vendor/bin/phpspec run \
    --config ./phpspec-coverage.yml \
    --no-interaction \
    --no-code-generation \
    -vvv"

pscw() {
    noglob ag -l -g '.*\.php' \
        | entr -cr \
        noti --message "✅ ${PWD##*/} PHPSpec passed and converage generated" \
        php \
        -dmemory_limit=1024M \
        -ddisplay_errors=off \
        -dxdebug.mode=off \
        ./vendor/bin/phpspec run --no-interaction --config ./phpspec-coverage.yml -vvv
}
# }}}

# pytest {{{
alias ptw="noglob ag -l -g '.*\\.py' | entr -cr noti --message \"✅ PyTest passed\" pytest"
# }}}

# pip {{{
# why is this so hard (to update all dependencies and store new versions in requirements.txt)?
alias pipu="pip-review --local --auto"
# }}}

# neovim {{{
alias v="nvim"
compdef v="nvim"

alias vim="nvim"
compdef vim="nvim"
# }}}

# phpunit {{{

phpunitnotify() {
    # php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    # autoloader is failing :(
    phpdbg -qrr -dmemory_limit=4096M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "✅ PHPUnit tests passed" ||
        noti --message "❌ PHPUnit tests failed"
}

phpspecnotify() {
    php \
        -dmemory_limit=2048M \
        -ddisplay_errors=on \
        -dxdebug.mode=off \
        ./vendor/bin/phpspec run "${@}"
    [[ $? == 0 ]] && noti --message "✅ Specs passed" ||
        noti --message "❌ Specs failed"
}

pux() {
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "✅ PHPUnit tests passed" || noti --message "❌ PHPUnit tests failed"
}
# }}}

# }}}

# source more files {{{
source "$HOME/.saatchirc" 2>/dev/null
# ensure the tmux term exists, otherwise some stuff like ncurses apps (e.g. tig) might break. This is very fast.
tic -x "$HOME/.support/tmux-256color.terminfo" &>/dev/null
tic -x "$HOME/.support/tmux.terminfo" &>/dev/null
# source "$HOME"/.fzf.zsh 2>/dev/null # fuzzy finder - installed via yadm bootstrap (still from homebrew)
_evalcache fzf --zsh

# https://github.com/romkatv/powerlevel10k#does-powerlevel10k-always-render-exactly-the-same-prompt-as-powerlevel9k-given-the-same-config
ZLE_RPROMPT_INDENT=0
# }}}

# zsh options {{{
# https://hachyderm.io/@vonheikemen/109367664475938652 (fast)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol
PROMPT_EOL_MARK=''
# }}}

# zsh plugins config {{{

# fzf-tab {{{
# https://github.com/Aloxaf/fzf-tab#configure
(( $+commands[enable-fzf-tab] )) && enable-fzf-tab

# https://github.com/Aloxaf/fzf-tab/issues/32#issuecomment-1519639800
zstyle ':fzf-tab:*' query-string ''
# }}}

# zsh-autocomplete {{{
# so chatty
zstyle ':autocomplete:*:no-matches-yet' message ''
zstyle ':autocomplete:*:too-many-matches' message ''
zstyle ':autocomplete:*:no-matches-at-all' message ''
# turn off fzf bindings
zstyle ':autocomplete:*' fuzzy-search off
# }}}

# zsh-autosuggest {{{
# https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy (this prevents me from typing more e.g. `php artisan ...`!)
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# fix problem with zsh autosuggest color getting overwritten somewhere
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# }}}

# zsh-notify {{{
# https://gist.github.com/marzocchi/14c47a49643389029a2026b4d4fec7ae
zstyle ':notify:*' error-icon "http://getdrawings.com/free-icon/x-mark-icon-57.png"
zstyle ':notify:*' error-title "❌ in #{time_elapsed}"
zstyle ':notify:*' error-sound 'Sosumi'
zstyle ':notify:*' success-icon "https://cdn1.iconfinder.com/data/icons/color-bold-style/21/34-512.png"
zstyle ':notify:*' success-title "✅ in #{time_elapsed}"
zstyle ':notify:*' success-sound 'default'
# }}}

# zsh-vi-mode {{{
ZVM_CURSOR_STYLE_ENABLED=false
# }}}

zinit cdreplay -q

# }}}
