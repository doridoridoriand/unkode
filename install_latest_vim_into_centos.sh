#!/bin/bash

cd $HOME;

sudo yum -y update;
sudo yum install -y git gcc ncurses-devel;

git clone https://github.com/vim/vim.git

cd ~/vim;
make;
sudo make install;
