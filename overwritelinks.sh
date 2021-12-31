#!/bin/bash

# Find the script dir
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

RCFILES="bashrc minttyrc vimrc vim muttrc mutt screenrc tmux.conf gemrc ackrc gitconfig"

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
ERROR="${IN}${BK}${FR}Error  :${CL}"

function overwrite_link() {
  SOURCE="$1"
  FILE="$2"

  if [ ! -h ~/.${FILE} ]
  then
    echo -e "${WARNING} ~/.${FILE} is not a symlink already. Skipping it." 2> /dev/stderr
    return 1
  fi
  echo -e "${INFO} Creating symlink ~/.${FILE} => ${SOURCE}/${FILE}"
  ln -sfn ${SOURCE}/${FILE} ~/.${FILE}
  return $?
}

function do_it() {
  if [ $# != 1 ]
  then
    echo -e "${ERROR} Expected 1 argument. Got $#"
    exit 1
  fi

  RCFILES="$1"
  count=0

  for f in ${RCFILES}
  do
    overwrite_link ${SRCDIR} $f
    test $? == 0 && let count++
  done

  echo -e "${INFO} Files modified: ${count}"
}

echo -e "${WARNING} You're about to replace the following symlinks: ~/.${RCFILES// /, ~\/.}"
echo -e "${INFO} The script will only replace symlinks. It will not touch files or directories."
echo -en "${INFO} Do you want to proceed (yes/NO)? "
read -n 1 ANSWER
echo
case ${ANSWER} in
  y|Y)
    do_it "${RCFILES}"
    ;;
  *)
    echo -e "${ERROR} Cancelled"
    ;;
esac


