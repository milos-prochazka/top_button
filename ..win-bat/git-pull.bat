cd ..
archname=${PWD##*/}  
git archive -o "$archname-%date%-%time%".zip HEAD
exit 0
git stash push -m "git pull - %date% %time%"
git checkout master
git fetch origin master
git rebase -i origin/master
git pull
rem test