#!/bin/sh

git config --global core.editor vim
git config --global core.excludesfile ~/.gitignore
git config --global color.ui true
git config --global color.interactive true
git config --global color.status true
git config --global color.branch true
git config --global color.diff true
git config --global push.default simple

if [ "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi

if [ "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

