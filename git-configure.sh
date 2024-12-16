#!/usr/bin/bash

git config --global user.name "paulbknhs"
git config --global user.email "dev@paulbknhs.de"
git config --global init.defaultBranch "main"
git config --global core.editor "nvim"

git remote set-url origin --push git@github.com:paulbknhs/arch2go.git
