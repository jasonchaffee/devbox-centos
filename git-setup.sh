#!/bin/sh

git config --global core.editor vim
git config --global push.default simple
git config --global core.excludesfile ~/.gitignore
git config --global color.ui true
git config --global user.name "${USER_NAME}"
git config --global user.email ${USER_EMAIL}
