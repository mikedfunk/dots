#!/usr/bin/env zsh
# zsh config
# vim: set foldmethod=marker ft=zsh:

# notes {{{
# https://code.joejag.com/2014/why-zsh.html
# https://til.hashrocket.com/posts/alk38eeu8r-use-fc-to-fix-commands-in-the-shell
# ctrl-z won't work? remove ~/.zsh/log/jog.lock
# This is documented with tomdoc.sh style https://github.com/tests-always-included/tomdoc.sh
#
# https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/#a-note-on-profiling-with-zsh%2Fzprof
# zmodload zsh/zprof

# Want to use docker build cloud? `docker buildx use cloud-mikedfunk-mybuilder`.
# This sets it for the current session _only_ to ensure you don't build with
# cloud when you dont need a ferrari.
# }}}

# p10k instant prompt (must be first) {{{
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# https://unix.stackexchange.com/a/608921
# export GPG_TTY=$(tty)
export GPG_TTY=$TTY
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#
# P10k is installed as a ZSH plugin.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# speed up omz {{{
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
DISABLE_MAGIC_FUNCTIONS=true
DISABLE_COMPFIX=true
# zstyle ':omz:update' mode disabled
# }}}

# helper functions {{{

# Internal: Whether a command is available
_has() {
    type "$1" &>/dev/null
}

# timezsh() {
#   shell=${1-$SHELL}
#   for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
# }

# colors {{{
# local BLACK="$(tput setaf 0)"
# local RED="$(tput setaf 1)"
local GREEN="$(tput setaf 2)"
local YELLOW="$(tput setaf 3)"
local BLUE="$(tput setaf 4)"
# local PINK="$(tput setaf 5)"
# local CYAN="$(tput setaf 6)"
# local WHITE="$(tput setaf 7)"
local NORMAL="$(tput sgr0)"
# local MAC_REMOVE_ANSI='gsed "s/\x1b\[[0-9;]*m//g"'
# local LINUX_REMOVE_ANSI='sed \"s/\x1b\[[0-9;]*m//g\"'
local UNDERLINE="$(tput smul)"
# }}}

# }}}

# Paths {{{

# set up homebrew env vars and paths
eval "$(/opt/homebrew/bin/brew shellenv)"

# when CDing from anywhere, this will add the configured path to the
# completions always. Why would I want to do this ever? It just looks like a
# bug and gets in the way.
# cdpath=(
#   $HOME/Code
#   $cdpath
# )

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
  $(brew --prefix mysql-client@8.0)/bin
  $(brew --prefix git)/share/git-core/contrib/git-jump
  # kubectl plugin manager (plugins will be installed to this bin)
  # "${KREW_ROOT:-$HOME/.krew}"/bin
  # $HOME/.yarn/bin
  $HOME/.docker/bin
  # to install groovy-language-server
  $(brew --prefix openjdk@17)/bin
  # my own scripts
  $HOME/.bin
  # global ruby gems
  $HOME/bin
  # global python pip packages (also lazyman)
  $(python -m site --user-base)/bin
  # emacs
  # $HOME/.emacs.d/bin
  # /Applications/Docker.app/Contents/Resources/bin
  # (homebrew is already covered by the eval above)
  # wtf homebrew? this is too far down the list!
  # $(brew --prefix)/{bin,sbin}
  # homebrew doesn't like to link curl
  $(brew --prefix)/opt/curl/bin
  # rust cargo packages
  $HOME/.cargo/bin
  # golang packages
  "$GOPATH"/bin
  # $HOME/go/bin
  # golang executables
  # $(brew --prefix)/opt/go/libexec/bin
  # $HOME/.{pl,nod,py}env/bin # these will be set up by shell integration
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
# If I don't do this I get "compdef undefined"
# moved below plugins for zsh-users/zsh-completions to be happy
# autoload -Uz compinit
# compinit

# https://www.justingarrison.com/blog/2020-05-28-shell-shortcuts/
bindkey '^q' push-line-or-edit
# https://github.com/getantidote/use-omz?tab=readme-ov-file#differences
# ^ Oh-My-Zsh by default checks the security of directories in fpath when running compinit. This feature can cause slower performance, and can be disabled by setting ZSH_DISABLE_COMPFIX=true
ZSH_DISABLE_COMPFIX=true

# https://github.com/mattmc3/ez-compinit?tab=readme-ov-file#how-do-i-customize-it
# cache completion sources
# DON'T FORGET if you add a completion source to comment this out or it won't show up for a day!!
# NOTE: cache file is at ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump by default (and I don't currently change it)
zstyle ':plugin:ez-compinit' 'use-cache' 'yes'
# }}}

# load antidote zsh plugins (#slow) {{{

if brew list | grep --quiet antidote; then
    source $(brew --prefix antidote)/share/antidote/antidote.zsh

    if [ -z "$ZSH" ] && ( antidote list | grep --quiet ohmyzsh/ohmyzsh ); then
        # make oh-my-zsh plugins work with antidote
        ZSH=$(antidote path ohmyzsh/ohmyzsh)
    fi

    antidote load
fi
# zsh plugins are in ~/.zsh_plugins.txt
# }}}

# source additional files and env vars {{{
# for newsboat
# export BROWSER="open %u"
unset BROWSER
export FLOX_DISABLE_METRICS=true
export DOCKER_CLI_HINTS=false
# for ctop:
export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"

# This will break automatic clipboard transfer between neovim and the system
# but it will allow sharing your clipboard over ssh with a remote server.
# export SSH_TTY=$TTY

# export AIDER_MODEL="anthropic/claude-3-5-haiku-latest" # Faster and cheaper. Can hit token limit.
# export AIDER_MODEL="anthropic/claude-3-7-sonnet-latest" # capable of returning diffs, apparently less likely to hit token limit
# export AIDER_MODEL="anthropic/claude-3-opus-latest"
# export AIDER_MODEL="gemini/gemini-2.0-flash" # gemini free fast model
# export AIDER_MODEL="ollama/llama3.1:8b"
# export AIDER_GITIGNORE="False" # use .aiderignore instead so I can add more/less
# export AIDER_SHOW_MODEL_WARNINGS=false
# export AIDER_YES_ALWAYS=true
# export AIDER_CONFIG_FILE="$HOME/.config/aider/.aider.conf.yml"
# export AIDER_AUTO_COMMITS=false
# export AIDER_READ=AGENTS.md
# export AIDER_READ=CONTEXT.md

export OLLAMA_API_BASE=http://127.0.0.1:11434 # for aider
# https://github.com/ollama/ollama/issues/7762#issuecomment-2489192027
export OLLAMA_NUM_PARALLEL=1

# use latest versions of all plugins (if anything breaks, turn this off and sync packages)
# currently indentline is breaking
export ZK_NOTEBOOK_DIR="$HOME/Notes"
# _has bat && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="TwoDark"
# use `gO` to open a quickfox with a table of contents!
# _has nvim && export MANPAGER='nvim +colo\ base16-heetch +Man!'
_has nvim && export MANPAGER='nvim +Man!'
# _has nvim && export MANPAGER='nvim -u NONE +Man!'

# https://cmichel.io/fixing-cpp-compilation-bugs-for-the-mac-os-catalina-upgrade/
# This was needed to install lsp-ai via cargo
# export CPLUS_INCLUDE_PATH="$(brew --prefix llvm)/include/c++/v1:$(xcrun --show-sdk-path)/usr/include"
# export LIBRARY_PATH="$LIBRARY_PATH:$(xcrun --show-sdk-path)/usr/lib"

export XDG_RUNTIME_DIR="$TMPDIR"
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache
# export LUNARVIM_RUNTIME_DIR="$HOME/.local/share/lunarvim"

export WEZTERM_CONFIG_FILE="$XDG_CONFIG_HOME"/wezterm/config.lua
export COMPOSE_HTTP_TIMEOUT=120 # default is 60
export ZSH_ALIAS_FINDER_AUTOMATIC=true # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder#usage
[ -f "$HOME"/.private_vars.sh ] && source "$HOME"/.private_vars.sh
[ -f $(brew --prefix)/etc/grc.zsh ] && source "$(brew --prefix)/etc/grc.zsh" # generic colorizer
# [ -f $(brew --prefix)/etc/openssl/cert.pem ] && export SSL_CERT_FILE=$(brew --prefix)/etc/openssl/cert.pem # https://github.com/google/google-api-ruby-client/issues/235#issuecomment-169956795
# [ -d "$HOME/.zsh/completion" ] && find "$HOME/.zsh/completion" | while read f; do source "$f"; done

export AKAMAI_EDGERC="$XDG_CONFIG_HOME"/akamai/.edgerc

# cod: error: server returned error: Binary was compiled with 'CGO_ENABLED=0', go-sqlite3 requires cgo to work. This is a stub
# ( antidote list | grep --quiet dim-an/cod ) && source $(antidote path dim-an/cod)/cod.plugin.zsh

# evaluated startup commands {{{
# _has mutagen && mutagen daemon start
# _has direnv && _evalcache direnv hook zsh # (evalcache version)
# _has pkgx && source <(pkgx --shellcode)
# _has aicommits && aicommits config set OPENAI_KEY="$OPENAI_API_KEY"
# #slow
# _has hub && _evalcache hub alias -s # alias git to hub with completion intact
_has mise && _evalcache mise activate zsh

# https://python-poetry.org/docs/managing-environments/#bash-csh-zsh
_has poetry && _evalcache poetry env activate

# https://github.com/trapd00r/LS_COLORS
local dircolors_cmd="$(brew --prefix coreutils)/libexec/gnubin/dircolors"
local dircolors_file="$HOME"/.dircolors
[[ -e "$dircolors_cmd" && -f "$dircolors_file" ]] && _evalcache "$dircolors_cmd" -b "$dircolors_file"
# }}}

export LC_CTYPE=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
export LC_ALL=en_US.UTF-8 # https://unix.stackexchange.com/a/302418/287898
# https://github.com/variadico/noti/blob/master/docs/noti.md#environment
export NOTI_NSUSER_SOUNDNAME="Hero"
# don't notify when these die after being "long-running processes"
export AUTO_NTFY_DONE_IGNORE=(
    ctop
    htop
    less
    man
    screen
    tig
    tmux
    ts
    v
    vim
    y
    yadm
)
# colorize less... I get weird indentations all over the place with this
# https://www.reddit.com/r/linux/comments/b5n1l5/whats_your_favorite_cli_tool_nobody_knows_about/ejex2pm/
# export LESSOPEN="| $(brew --prefix)/opt/source-highlight/bin/src-hilite-lesspipe.sh %s"
# alias less="less -R"
# lessc () { rougify highlight $@ | \less -R -M }
export GITWEB_PROJECTROOT="$HOME"/Code
export PRE_COMMIT_COLOR="always" # https://pre-commit.com/#cli
export PSQL_PAGER="pspg --clipboard-app=3"

set PLANTUML_LIMIT_SIZE=8192

# to install groovy-language-server
# export CPPFLAGS="-I$(brew --prefix openjdk@17)/include"

# [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh" # this seems to conflict with direnv. Direnv seems to wipe the PATH changes this applies.
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh # To customize prompt, run `p10k configure` (NOT within tmux) or edit ~/.p10k.zsh. P10k is installed as a ZSH plugin.

# [[ -f $(brew --prefix virtualenvwrapper)/bin/virtualenvwrapper.sh ]] && source $(brew --prefix virtualenvwrapper)/bin/virtualenvwrapper.sh
builtin setopt aliases # weird, this should have already been done :/

# _has starship && _evalcache starship init zsh

# https://github.com/denisidoro/navi/blob/master/docs/installation.md#installing-the-shell-widget
# _has navi && _evalcache navi widget zsh

# export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX="YES"
# [[ -f "$HOME"/.iterm2_shell_integration.zsh ]] && source "$HOME"/.iterm2_shell_integration.zsh

export HOMEBREW_NO_ANALYTICS=1

# Ignore calls to docker login or logout and pretend they succeeded
export AWS_ECR_IGNORE_CREDS_STORAGE=true

# xdg-ninja (move configs to proper locations) {{{

# export ANDROID_HOME="$XDG_DATA_HOME"/android
# export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
# export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# export TERMINFO="$XDG_DATA_HOME"/terminfo
# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
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

# }}}
# _has inshellisense && inshellisense --shell zsh # check this later - right now it sucks but they are rewriting it

# disable weird highlighting of pasted text
# https://old.reddit.com/r/zsh/comments/c160o2/command_line_pasted_text/erbg6hy/
zle_highlight=('paste:none')

# ssh {{{
# disable autossh port monitoring and use ServerAliveInterval and
# ServerAliveCountMax instead.
# https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
export AUTOSSH_PORT=0

# https://infosec.mozilla.org/guidelines/openssh#openssh-client (med slow)
ssh-add --apple-use-keychain --apple-load-keychain ~/.ssh/keys/* 2>/dev/null # add all keys stored in keychain if they haven't been added yet
# ssh-add -c -K -A 2>/dev/null # add all keys stored in keychain if they haven't been added yet
# [c] confirm password on use
# [K] store/use password with macos keychain
# [A] add all identities stored in keychain. Therefore, before this is useful, you'll need to add each key to the ssh agent at least once.
# }}}

# gpg {{{
# enable gpg passwords in the terminal
# make gpg prompt for a password
# https://unix.stackexchange.com/a/608921
# export GPG_TTY=$(tty)
export PINENTRY_USER_DATA="USE_CURSES=1"
# }}}

# fzf {{{
export FZF_DEFAULT_OPTS="--multi"
export FZF_DEFAULT_COMMAND='ag --files-with-matches --skip-vcs-ignores -g ""'
# }}}

# }}}

# completion {{{
# moved here for zsh-users/zsh-completions
# this can be commented out due to https://github.com/mattmc3/ez-compinit
# autoload -Uz compinit
# compinit

# zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
# compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# [ -f "$(brew --prefix)"/share/google-cloud-sdk/path.zsh.inc ] && source "$(brew --prefix)"/share/google-cloud-sdk/path.zsh.inc
# [ -f "$(brew --prefix)"/share/google-cloud-sdk/completion.zsh.inc ] && source "$(brew --prefix)"/share/google-cloud-sdk/completion.zsh.inc

# _has kubectl && _evalcache kubectl completion zsh
# _has algolia && _evalcache algolia completion zsh
# _has poetry && source <(poetry completions zsh) # python virtualenv and sane dependency management (breaks)
# _has stern && source <(stern --completion=zsh) # unfortunately I still get no completion. cod works better for this.

# https://github.com/machinshin/dotfiles/blob/master/.zshrc#L159-L160
# Complete the hosts and - last but not least - the remote directories.
#  $ scp file username@<TAB><TAB>:/<TAB>
# zstyle ':completion:*:(ssh|scp|sftp|sshrc|autossh|sshfs):*' hosts $hosts
# zstyle ':completion:*:(ssh|scp|sftp|sshrc|autossh|sshfs):*' users $users

# _has akamai && _evalcache akamai --zsh
# [ -f $(brew --prefix git-spice)/bin/gs ] && _evalcache $(brew --prefix git-spice)/bin/gs shell completion zsh

# carapace is that go cobra auto completion lib (fast)
if _has carapace; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
    # this might interfere with fzf-tab https://github.com/orgs/carapace-sh/discussions/2596
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi

# }}}

# functions and aliases {{{

# misc {{{
# alias info="info --vi-keys" # info -> pinfo is like top -> htop
alias pinfo='pinfo --rcfile=$XDG_CONFIG_HOME/pinfo/pinforc'
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias updatedb="/usr/libexec/locate.updatedb" # remember to sudo
alias be="bundle exec"
alias ccusage="npx -y ccusage@latest"
alias mycli="mycli --defaults-group-suffix=_mycli --prompt=' \h  '" # prompt config option stopped working :/
_has kubecolor && alias kubectl=kubecolor && compdef kubecolor=kubectl
alias k="kubectl"
compdef k="kubectl"
alias pspg="pspg --clipboard-app=3"
# use git-spice without conflicting cli. gs is already used by ghostscript, which is a dependency of imagemagick
# ^moved to ~/.bin/git-spice
# gsp() { $(brew --prefix git-spice)/bin/gs $@; }
# compdef gsp="gs"
compdef git-spice="gs"

# Public: pass the current ssh alias. Used by my promptline theme and .screenrc to show the alias in the PS1.
# servers don't like anything *-256color so I need to use screen via ssh
ssh () { env TERM=screen LC_SSH_ALIAS=$1 /usr/bin/ssh $@; }
autossh () { LC_SSH_ALIAS=$1 $(brew --prefix)/bin/autossh $@; }
compdef autossh="ssh"

# https://www.youtube.com/watch?v=Wl7CDe9jsuo&feature=youtu.be
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir="mkdir -vp"

# mysql-web-server () {
#     ( docker ps | grep -q dbgate ) && return
#     docker run --rm --detach -ti --name=dbgate-instance \
#         --publish 8001:3000 \
#         --env SHELL_CONNECTION='1' \
#         dbgate/dbgate
# }

# tip: curl ping.gg to set up a pingdom-style alert
shorten-url () { curl -s http://tinyurl.com/api-create.php?url=$1; }

cd () { builtin cd "$@" && ls -F -A -G; } # auto ls on cd
alias ..="cd .."
alias ...="cd ../.."
# _has lsd && alias ls="lsd" # fancy ls augmentation (disabled because it's missing flags that ls _has >:(  )
alias du="grc --colour=auto /usr/bin/du"
# https://github.com/sharkdp/vivid/issues/25#issuecomment-450423306
# _has gls && alias ls="gls --color"
_has eza && alias ls="eza"
# alias ll='ls -lhGFA'
alias ll='ls -lhA --classify=auto'
phpx() { php -d xdebug.start_with_request=yes -dxdebug.mode=debug,develop -dxdebug.client_port=${XDEBUG_PORT:-9003} $@; }
alias work="tmuxinator start work"
alias home="tmuxinator start home"
alias rmf='rm -rf'
compdef rmf="rm"
mkcd () { mkdir $1 && cd $1; }
compdef mkcd="mkdir"
alias src="source ~/.zshrc"
alias jobs="jobs -l"
# alias k="k --no-vcs"
alias pso="ps -o pid,command"
# alias add-keys="ssh-add -K ~/.ssh/keys/githubkey ~/.ssh/keys/bitbucketkey ~/.ssh/keys/saatchiartkey"
alias art="php artisan"
alias pc="phing -logger phing.listener.DefaultLogger"
compdef pc="phing"
alias pg="phing"
compdef pg="phing"
alias news="BROWSER='open %u' newsboat"

k9s () {
    defaults read -g AppleInterfaceStyle &>/dev/null
    local skin_file=$([ $? -eq 0 ] && echo "$XDG_CONFIG_HOME/k9s/skins/skin_dark.yaml" || echo "$XDG_CONFIG_HOME/k9s/skins/skin_light.yaml")
    command cp "$skin_file" "$XDG_CONFIG_HOME/k9s/skins/skin.yaml"
    command k9s $@
}

alias y="yadm"
compdef y="yadm"
alias upgrades="yadm bootstrap"

save-dotfiles () { yadm encrypt && yadm add -u && yadm ci -m ${1:-working} && yadm ps; }
alias save-notes="wd notes && git add -A && git commit -am 'working' && git push"
alias save-queries"wd queries && git add -A && git commit -am 'working' && git push"

# alias sdx="save-dotfiles && exit"
# save-dotfiles-without-encryption () { yadm add -u && yadm ci -m ${1:-working} && yadm ps; }
# alias notes="joplin"
# alias notes="npx --no-install joplin"
# alias notes="wd notes && [ -f $(date +%Y-%m-%d).md ] && zk edit $(date +%Y-%m-%d) || zk new --id $(date +%Y-%m-%d) --title $(date +%Y-%m-%d)"
alias journal="zk journal"
# alias journals="zk edit journals --interactive"
# alias search-notes="zk list --match "
alias notes="zk edit --interactive"
# alias save-notes="cd $HOME/Notes && git add . && git commit -am 'working' && git push"
# alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc" # javascript repl for testing javascript wonkiness
# alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude vendor" # enhanced interactive disk usage command
alias tmux-layout="tmux display-message -p \"#{window_layout}\""
# fuzzy wd
wf () { wd $(wd list | gsed '1d' | fzf | gsed -E 's/^ +(\w+).*$/\1/'); }

export CLICOLOR=1 # ls colors by default

# pretty-print PATH with line breaks
pretty-path () { tr : '\n' <<<"$PATH"; }
# alias vit="vim +TW" # until vit gets its act together
# alias tree="alder" # colorized tree from npm (I colorize tree with "lsd" now so this is not needed)
# https://unix.stackexchange.com/a/293608/287898
# alias mc="mc --nosubshell --xterm"
alias multitail="multitail -F $XDG_CONFIG_HOME/multitail/multitail.conf"
# }}}

# games {{{
alias play-starwars="telnet towel.blinkenlights.nl" # :)
# alias play-gameboy="telnet gameboy.live 1989" # not working any more :(
alias play-nethack="ssh nethack@alt.org" # :)
alias play-chess="telnet freechess.org" # :)
alias play-aardwolf="telnet aardmud.org" # :)
alias play-tron="ssh sshtron.zachlatta.com" # :)
alias play-zork="zork" # :)
alias play-mume="telnet mume.org 4242" # :)
alias play-alter-aeon="telnet alteraeon.com 23" # :)
# }}}

# suffix aliases {{{
# https://unix.stackexchange.com/questions/354960/zsh-suffix-alias-alternative-in-bash
# NOTE: This breaks php-language-server.php
# alias -s css=vim
# alias -s html=vim
# alias -s js=vim
# alias -s json=vim
# alias -s jsx=vim
# alias -s markdown=vim
# alias -s md=vim
# alias -s phar=php
# alias -s php=vim
# alias -s phtml=vim
# alias -s rb=vim
# alias -s scss=vim
# alias -s txt=vim
# alias -s xml=vim
# alias -s xql=vim
# alias -s yaml=vim
# alias -s yml=vim
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
export COMPOSER_MEMORY_LIMIT=-1
alias c="composer"
compdef c="composer"
# alias cda="composer dump-autoload"
# alias cu="composer update"
# alias ci="composer install --prefer-dist"
# alias cr="composer require"
# alias crd="composer require --dev"
# alias crs="composer run-script"
# }}}

# git {{{
alias g="git"
compdef g="git"
# grt() { cd `g root`; }
# alias cdg="grt"
# alias standup="tig --since='2 days ago' --author='Mike Funk' --no-merges"
# Experimenting with using taskwarrior for this instead
# alias t="tig"
alias ts="tig status"
alias td="tig develop.."
# alias tm="tig master.."
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
psc-html() { php -dxdebug.mode=coverage -dmemory_limit=3G ./vendor/bin/phpspec run --config ./phpspec-coverage-html.yml --no-interaction --no-code-generation -vvv $@ && open coverage/index.html; }
alias psc="php -dxdebug.mode=coverage -dmemory_limit=2G ./vendor/bin/phpspec run --config ./phpspec-coverage.yml --no-interaction --no-code-generation -vvv"
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
# this version will also add dependencies of dependencies to your ~/requirements.txt which is a huge downside, not worth it
# alias pipu="pip list --outdated | cut -d' ' -f1 | xargs pip install --upgrade"
# use a better wrapper tool
alias pipu="pip-review --local --auto"
# }}}

# taskwarrior {{{
# note: this conflicts with tig
# alias t="task"
# alias tl="task list"
# alias ta="task add"
# }}}

# neovim {{{
alias v="nvim"
compdef v="nvim"
alias vim="nvim"
compdef vim="nvim"
export EDITOR=nvim # aww yeah
# useful for mc
export VIEWER="bat --paging=always"
export LANG=en_US.UTF-8
# KEYTIMEOUT=1 # no vim delay entering normal mode (but breaks fzf-git)
# }}}

# docker {{{

alias docker-restart="osascript -e 'quit app \"Docker\"' && open -a Docker"

# wrap docker status with color and underline in header
# docker-stats() {
#     docker stats --format "table ${GREEN}{{.Name}}\t${YELLOW}{{.CPUPerc}}\t${BLUE}{{.MemPerc}}" | sed -E -e "s/(NAME.*)/${UNDERLINE}\1${NORMAL}/"
# }
# }}}

# phpunit {{{

# Public: runs phpunit and uses noti to show the results
phpunitnotify() {
    # xdebug-off > /dev/null
    # php -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    # autoloader is failing :(
    phpdbg -qrr -dmemory_limit=4096M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "✅ PHPUnit tests passed" ||
        noti --message "❌ PHPUnit tests failed"
    # xdebug-on > /dev/null
}

# but why
# alias magento-phpunit="pu -c dev/tests/unit/phpunit.xml.dist"

# Public: runs phpspec run and uses noti to show the results
phpspecnotify() {
    # xdebug-off > /dev/null
    # phpdbg -qrr -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    php \
        -dmemory_limit=2048M \
        -ddisplay_errors=on \
        -dxdebug.mode=off \
        ./vendor/bin/phpspec run "${@}"
    # php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9015 -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpspec run "${@}"
    [[ $? == 0 ]] && noti --message "✅ Specs passed" ||
        noti --message "❌ Specs failed"
    # xdebug-on > /dev/null
}

# Public: phpunit with xdebug turned on
pux() {
    # xdebug-off 2> /dev/null
    phpx -dmemory_limit=2048M -ddisplay_errors=on ./vendor/bin/phpunit --colors "${@}"
    [[ $? == 0 ]] && noti --message "✅ PHPUnit tests passed" || noti --message "❌ PHPUnit tests failed"
    # xdebug-on > /dev/null
}
# }}}

# xdebug {{{
# xdebug-off() {
#     local -r ini_file=$(find $(mise where php-brew)/conf.d -name "*xdebug.ini")
#     [ -n $ini_file ] && mv ${ini_file}{,_OLD}
# }
#
# xdebug-on() {
#     local ini_file=$(find $(mise where php-brew)/conf.d -name "*xdebug.ini_OLD")
#     [ -z $ini_file ] && return
#     ini_file=$(echo ${ini_file} | sed s/_OLD//)
#     mv ${ini_file}{_OLD,}
# }
# }}}

# }}}

# source more files {{{
[ -e "$HOME/.saatchirc" ] && source "$HOME/.saatchirc"
# [ -e "$HOME/.toafrc" ] && source "$HOME/.toafrc"
# ensure the tmux term exists, otherwise some stuff like ncurses apps (e.g. tig) might break. This is very fast.
[ -f "$HOME/.support/tmux-256color.terminfo" ] && tic -x "$HOME/.support/tmux-256color.terminfo" &>/dev/null
[ -f "$HOME/.support/tmux.terminfo" ] && tic -x "$HOME/.support/tmux.terminfo" &>/dev/null
[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh # fuzzy finder - installed via yadm bootstrap (still from homebrew)
# https://github.com/romkatv/powerlevel10k#does-powerlevel10k-always-render-exactly-the-same-prompt-as-powerlevel9k-given-the-same-config
ZLE_RPROMPT_INDENT=0
# _has cod && source <(cod init $$ zsh) # does not work well on arm64
# [ -f $(brew --prefix asdf)/libexec/asdf.sh ] && source $(brew --prefix asdf)/libexec/asdf.sh # https://github.com/asdf-vm/asdf/issues/1104
# }}}

# zsh options {{{
setopt bang_hist # this was disabled by vanilli.zsh

# fuzzy completion: cd ~/Cde -> ~/Code (fast)
# https://superuser.com/a/815317
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# https://mastodon.social/@vonheikemen@hachyderm.io/109367664531721862 (fast)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol
PROMPT_EOL_MARK=''

# cdr {{{
# https://github.com/willghatch/zsh-cdr/blob/master/cdr.plugin.zsh
# this also enables zsh-autocomplete recent directories `cdr <Tab>`
# if [[ -z "$ZSH_CDR_DIR" ]]; then
#     ZSH_CDR_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-cdr
# fi
#
# mkdir -p $ZSH_CDR_DIR
# autoload -Uz chpwd_recent_dirs cdr
# autoload -U add-zsh-hook
# add-zsh-hook chpwd chpwd_recent_dirs
# zstyle ':chpwd:*' recent-dirs-file $ZSH_CDR_DIR/recent-dirs
# zstyle ':chpwd:*' recent-dirs-max 1000
# # fall through to cd
# zstyle ':chpwd:*' recent-dirs-default yes
# }}}

# }}}

# zsh plugins config {{{

# fzf-tab {{{
_has enable-fzf-tab && enable-fzf-tab
# https://github.com/Aloxaf/fzf-tab#configure

# https://github.com/Aloxaf/fzf-tab/issues/32#issuecomment-1519639800
zstyle ':fzf-tab:*' query-string ''

# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
_has ftb-tmux-popup && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# }}}

# powerlevel10k {{{
# https://getantidote.github.io/usage#plugins-file
autoload -Uz promptinit && promptinit && prompt powerlevel10k
# }}}

# zsh-autocomplete {{{
# so chatty
zstyle ':autocomplete:*:no-matches-yet' message ''
zstyle ':autocomplete:*:too-many-matches' message ''
zstyle ':autocomplete:*:no-matches-at-all' message ''
# turn off fzf bindings
zstyle ':autocomplete:*' fuzzy-search off

# zstyle ':autocomplete:*' fzf-completion yes
# }}}

# zsh-autosuggest {{{
export ZSH_AUTOSUGGEST_STRATEGY=(history completion) # https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy (this prevents me from typing more e.g. `php artisan ...`!)
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# fix problem with zsh autosuggest color getting overwritten somewhere
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# }}}

# zsh-notify {{{
# https://gist.github.com/marzocchi/14c47a49643389029a2026b4d4fec7ae
# zstyle ':notify:*' error-icon "https://media3.giphy.com/media/10ECejNtM1GyRy/200_s.gif"
zstyle ':notify:*' error-icon "http://getdrawings.com/free-icon/x-mark-icon-57.png"
zstyle ':notify:*' error-title "❌ in #{time_elapsed}"
zstyle ':notify:*' error-sound 'Sosumi'
# zstyle ':notify:*' success-icon "https://s-media-cache-ak0.pinimg.com/564x/b5/5a/18/b55a1805f5650495a74202279036ecd2.jpg"
zstyle ':notify:*' success-icon "https://cdn1.iconfinder.com/data/icons/color-bold-style/21/34-512.png"
zstyle ':notify:*' success-title "✅ in #{time_elapsed}"
zstyle ':notify:*' success-sound 'default'

# zstyle ':notify:*' blacklist-regex 'v|lvim|vim'
# }}}

# acli/jira {{{
# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
export JIRA_DEFAULT_ACTION='dashboard'

alias acli-login="echo $JIRA_USER_API_KEY | acli jira auth login --site $JIRA_SITE --email $JIRA_USER_EMAIL --token"
_has acli && _evalcache acli completion zsh
# }}}

# zsh-vi-mode {{{
ZVM_CURSOR_STYLE_ENABLED=false
# }}}

# }}}
