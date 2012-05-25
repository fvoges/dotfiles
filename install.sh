#!/bin/bash
# Taken from https://github.com/brantb/dotfiles/blob/master/install.sh

# Run this from the dotfiles dir
DOTFILES=`pwd`

# bash
test -f ~/.bashrc && mv ~/.bashrc ~/.bashrc.local 2> /dev/null
ln -sfn $DOTFILES/bashrc ~/.bashrc
touch ~/.bashrc.local

# vim
mv ~/.vimrc ~/.vimrc.old 2> /dev/null
mv ~/.vim ~/.vim.old 2> /dev/null
ln -s $DOTFILES/vimrc ~/.vimrc
ln -s $DOTFILES/vim ~/.vim

# screen
mv ~/.screenrc ~/.screenrc.old 2> /dev/null
ln -s $DOTFILES/screenrc ~/.screenrc

# tmux
#mv ~/.tmux.conf ~/.tmux.conf.old 2> /dev/null
#ln -s $DOTFILES/tmux.conf ~/.tmux.conf

# dircolors
#mv ~/.dir_colors ~/.dir_colors.old 2> /dev/null
#ln -s $DOTFILES/dircolors/dircolors.ansi-dark ~/.dir_colors

#git submodule update --init


