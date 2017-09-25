#!/bin/bash

# Find the script dir
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

# ANSI COLOR CODES

CL="\e[0m"
BO="\e[1m"
UN="\e[4m"
BL="\e[5m"
IN="\e[7m"
HI="\e[8m"
RE="\e[27m"

FK="\e[30m"
FR="\e[31m"
FG="\e[32m"
FY="\e[33m"
FB="\e[34m"
FP="\e[35m"
FC="\e[36m"
FW="\e[37m"

BK="\e[40m"
BR="\e[41m"
BG="\e[42m"
BY="\e[43m"
BB="\e[44m"
BP="\e[45m"
BC="\e[46m"
BW="\e[47m"

WARNING="${IN}${FY}${BK}Warning:${CL}"
INFO="${IN}${BK}${FG}Info   :${CL}"

function create_link() {
  SOURCE="$1"
  FILE="$2"
  SUFFIX="$3"

  if [ -h ~/.${FILE} ]
  then
    echo -e "${WARNING} ~/.${FILE} is a symlink already. Skipping it" 2> /dev/stderr
    return 1
  fi
  if [ -f ~/.${FILE} -o -d ~/.${FILE} ]
  then
    if [ -e ~/.${FILE}.${SUFFIX} ]
    then
      echo -e "${WARNING} ~/.${FILE}.${SUFFIX} already exists. Skipping ~/.${FILE}" 2> /dev/stderr
      return 1
    fi
    echo -e "${INFO} Renaming ~/.${FILE} => ~/.${FILE}.${SUFFIX}"
    mv ~/.${FILE}{,.${SUFFIX}}
  fi
  echo -e "${INFO} Creating symlink ${SOURCE}/${FILE} => ~/.${FILE}"
  ln -sfn ${SOURCE}/${FILE} ~/.${FILE}
  return $?
}

count=0

# bash
create_link ${SRCDIR} bashrc local
test $? == 0 && let count++

# mintty (Cygwin)
create_link ${SRCDIR} minttyrc local
test $? == 0 && let count++

# vim
create_link ${SRCDIR} vimrc pre-rcfiles
test $? == 0 && let count++
create_link ${SRCDIR} vim pre-rcfiles
test $? == 0 && let count++

# screenc
create_link ${SRCDIR} screenrc pre-rcfiles
test $? == 0 && let count++

# tmux
create_link ${SRCDIR} tmux.conf pre-rcfiles
test $? == 0 && let count++

# gemrc
create_link ${SRCDIR} gemrc pre-rcfiles
test $? == 0 && let count++

# ackrc
create_link ${SRCDIR} ackrc pre-rcfiles
test $? == 0 && let count++

# gitconfig
create_link ${SRCDIR} gitconfig pre-rcfiles
test $? == 0 && let count++
test -f ~/.gitconfig.local || touch ~/.gitconfig.local

echo -e "${INFO} Files modified: ${count}"

