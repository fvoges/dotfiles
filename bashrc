# ex: set et sw=2 ts=2 filetype=sh:
# This will normally be the backup of the default .bashrc

PATH="${PATH//$HOME\/.rbenv\/shims:}"

test -f ~/.bashrc.local && source ~/.bashrc.local

export EDITOR=vim

alias ls="ls --color=auto"
alias ll="ls -al"
alias vi="vim"
alias h="history"
alias psu="ps -fu $USER"
alias be="bundle exec"

# Mac OS X
if [ "$(uname -s)" == "Darwin" ]
then
  if [ -d /opt/boxen ]
  then
    # Include Boxen environment (if present)
    test -f /opt/boxen/env.sh && source /opt/boxen/env.sh

    PATH="/opt/boxen/homebrew/bin:${PATH//\/opt\/boxen\/homebrew\/bin:}"
  fi

  # Homebrew should be first so we can override system tools
  PATH="/usr/local/bin:${PATH//\/usr\/local\/bin:}"
  PATH="/usr/local/sbin:${PATH//\/usr\/local\/sbin:}"

  # coreutils should be first
  COREUTILS_PREFIX=$(brew --prefix)
  PATH="${COREUTILS_PREFIX}/opt/coreutils/libexec/gnubin:${PATH//${COREUTILS_PREFIX}\/libexec\/gnubin:}"
  MANPATH="${COREUTILS_PREFIX}/libexec/gnuman:$MANPATH"

  HOMEBREW_PREFIX=$(brew --prefix)
  test -f "${HOMEBREW_PREFIX}/etc/bash_completion" && source "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

PATH="${PATH//:$HOME\/bin}:$HOME/bin"

# Check for rbenv
if which rbenv >& /dev/null
then
  eval "$(rbenv init -)"
fi

case "$SHELL" in
  */bin/bash)
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
