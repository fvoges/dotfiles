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
  BREW_PREFIX=$(brew --prefix)

  PATH="${BREW_PREFIX}/opt/python/libexec/bin:${PATH//${BREW_PREFIX}\/libexec\/bin:}"
  PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH//${BREW_PREFIX}\/libexec\/gnubin:}"
  PATH="${BREW_PREFIX}/opt/python@3/bin:${PATH}"
  MANPATH="${BREW_PREFIX}/libexec/gnuman:$MANPATH"

  test -f "${BREW_PREFIX}/etc/bash_completion" && source "${BREW_PREFIX}/etc/bash_completion"
else
  PATH="${PATH//\/usr\/local\/bin:}:/usr/local/bin"
  PATH="${PATH//\/usr\/local\/sbin:}:/usr/local/sbin"
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


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

GPG_TTY=$(tty)
export GPG_TTY

export HISTCONTROL="ignoreboth"
export HISTSIZE="-1"
export HISTIGNORE="rm -rf*:cd:ll:ls:clear:pwd:[bf]g"

