#!/bin/sh
cd ..
CURRENTDATE=`date +"%Y-%m-%d %T"`
git stash push -m "git pull - $CURRENTDATE"
git checkout master
git fetch origin master
git rebase -i origin/master
git pull
