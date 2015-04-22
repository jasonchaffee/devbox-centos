#!/bin/sh

git config --global core.editor vim
git config --global core.excludesfile ~/.gitignore
git config --global color.ui true
git config --global push.default simple
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email ${GIT_USER_EMAIL}
