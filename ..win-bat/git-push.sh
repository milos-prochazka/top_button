#!/bin/sh
cd ..
if [[ $# -eq 0 ]] ; then
    echo Syntax: git-push ""message""
    exit 0
fi

dart-format ./ 2
dart-prep --enable-all ./
git add --all
git commit --all -m $1
git push origin master --force
pause
git gc
git gc --aggressive
git prune
goto end
