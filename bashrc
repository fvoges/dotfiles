# ex: set et sw=2 ts=2 filetype=sh:
# This will normally be the backup of the default .bashrc

PATH="${PATH//$HOME\/.rbenv\/shims:}"

test -f ~/.bashrc.local && source ~/.bashrc.local

export EDITOR=vim

alias l="ls -F"
alias ls="ls --color=auto"
alias ll="ls -al"
alias vi="vim"
alias h="history"
alias psu="ps -fu $USER"
alias be="bundle exec"
alias tf='terraform'
alias tfyolo='terraform apply -auto-approve'

test -f /etc/bash_completion && source /etc/bash_completion

test -d /opt/homebrew && PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Mac OS X
if [ "$(uname -s)" == "Darwin" ]
then
  which -s brew
  if [ $? -eq 0 ]
  then
    BREW_PREFIX=$(brew --prefix)

    # Homebrew (/usr/local) should be first so we can override system tools
    PATH="/usr/local/bin:${PATH//\/usr\/local\/bin:}"
    PATH="/usr/local/sbin:${PATH//\/usr\/local\/sbin:}"

    # coreutils should be first
    PATH="${BREW_PREFIX}/opt/python/libexec/bin:${PATH//${BREW_PREFIX}\/libexec\/bin:}"
    PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH//${BREW_PREFIX}\/libexec\/gnubin:}"

    test -d "${BREW_PREFIX}/opt/python@3/bin" && PATH="${BREW_PREFIX}/opt/python@3/bin:${PATH}"

    MANPATH="${BREW_PREFIX}/libexec/gnuman:$MANPATH"

    # old bash-completion
    test -f "${BREW_PREFIX}/etc/bash_completion" && source "${BREW_PREFIX}/etc/bash_completion"
    # new bash-completion (for bash version >=4)
    test -f "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" && source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
else
  which brew >& /dev/null
  if [ $? -eq 0 ]
  then
    BREW_PREFIX=$(brew --prefix)
    [[ -r "${BREW_PREFIX}}/etc/profile.d/bash_completion.sh" ]] && . "${BREW_PREFIX}}/etc/profile.d/bash_completion.sh"
  fi

  PATH="${PATH//\/usr\/local\/bin:}:/usr/local/bin"
  PATH="${PATH//\/usr\/local\/sbin:}:/usr/local/sbin"
fi

# autocomplete for all the hashicorp tools
test -x /usr/local/bin/boundary && complete -C /usr/local/bin/boundary boundary 2>&1 /dev/null
test -x /usr/local/bin/consul && complete -C /usr/local/bin/consul consul 2>&1 /dev/null
test -x /usr/local/bin/nomad && complete -C /usr/local/bin/nomad nomad 2>&1 /dev/null
# test -x /usr/local/bin/packer && complete -C /usr/local/bin/packer packer 2>&1 /dev/null
test -x /usr/local/bin/terraform && complete -C /usr/local/bin/terraform terraform 2>&1 /dev/null
# test -x /usr/local/bin/vagrant && complete -C /usr/local/bin/vagrant vagrant 2>&1 /dev/null
test -x /usr/local/bin/vault && complete -C /usr/local/bin/vault vault 2>&1 /dev/null
test -x /usr/local/bin/waypoint && complete -C /usr/local/bin/waypoint waypoint 2>&1 /dev/null

PATH="${PATH//:$HOME\/bin}:$HOME/bin"

test -d "${HOME}/.rbenv" && PATH="${PATH}:${HOME}/.rbenv/bin"

# Check for rbenv
if which rbenv >& /dev/null
then
  eval "$(rbenv init -)"
fi

case "$SHELL" in
  */bash)
    # Change the window title of X terminals
    case ${TERM} in
      xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
        ;;
      screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
        ;;
    esac

    if [[ ${EUID} == 0 ]] ; then
      PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
      PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
    fi
  ;;
esac

SSH_ENV=$HOME/.ssh/environment

function start_agent {
  echo "Initialising new SSH agent..."
  ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
  echo succeeded
  chmod 600 ${SSH_ENV}
  . ${SSH_ENV} >& /dev/null
  ssh-add;
}

if [ -t 0 ]
then
  # Check if $HOME/.ssh exists before starting ssh-agent
  if [ -d $HOME/.ssh -a -f  $HOME/.ssh/start_ssh_agent ]
  then
    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
      . ${SSH_ENV} >& /dev/null
      #ps ${SSH_AGENT_PID} doesnt work under cywgin
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ >& /dev/null || {
      start_agent;
    }
    else
      start_agent;
    fi
  fi
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

if [ -f  ~/.bash-git-prompt/gitprompt.sh ]
then
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_SHOW_UPSTREAM=1
  GIT_PROMPT_THEME=Solarized
  GIT_PROMPT_THEME=Single_line_Solarized
  source ~/.bash-git-prompt/gitprompt.sh
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

GPG_TTY=$(tty)
export GPG_TTY

export HISTCONTROL="ignoreboth"
export HISTSIZE="1000000"
export HISTIGNORE="rm -rf*:cd:ll:ls:clear:pwd:[bf]g"
export HISTTIMEFORMAT="%F %T "


# for COMPLETION in /usr/local/etc/bash_completion.d/*
# do
# echo $COMPLETION
#   source $COMPLETION
# done

test -f /usr/local/etc/bash_completion.d/git-completion.bash && source /usr/local/etc/bash_completion.d/git-completion.bash

# Check for kubectl
if which kubectl >& /dev/null
then
  # from: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
  alias k=kubectl
  alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
  alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

  complete -o default -F __start_kubectl k
fi
alias myip='curl -s "https://api.ipify.org";echo'
alias whatsmyip='curl ifconfig.me;echo'

if type -p exa >& /dev/null
then
  export EXA_ICONS_AUTO=1
  alias ls='exa'
  alias la='ls -laa'
elif type -p eza >& /dev/null
then
  export EZA_ICONS_AUTO=1
  alias ls='eza'
  alias la='ls -laa'
fi

type -p bat >& /dev/null  && alias cat='bat'
#type -p zoxide >& /dev/null && eval "$(zoxide init --cmd cd bash)"

test -f ~/.do_token && export DIGITALOCEAN_TOKEN="$(cat ~/.do_token)"
test -f ~/.tailscale_env && source ~/.tailscale_env
