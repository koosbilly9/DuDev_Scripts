#!/bin/bash

# Purpose: Tools Menu for common git actions

# 2021/09/09   Billy 	Create

if [ $# == 1 ] 
then
choice=$1
else
echo "
GIT TOOLS
==========
Git working normal (1,2,3)
---------------------------
1) Stage\'s all changed files before commit : \" git add . \"
2) commits staged files : \" git commit -m \" new Commit message \"
3) push commit to repo : \" git push \"
4) Show last 5 commits: \" git log -n 5 \"
Git General
------------
10) Git Version : \"git --Version \"
Git Remote 
-----------
100) Verify remote : \"git remote -v\"
101) Change Remote : \"git remote set-url origin <url> \"
Git settings
------------
200) Display git settings : \" git config --list \"
201) Display git settings with location filename: \" git config --list --show-origin\"
Git Branches
-------------
300) Show local branches : \" git branch \"
301) show remote branches : \" git branch -r \"
302) Show all branches : \" git branch -a \"
Git commits
------------
400) show commits : \" git log \" 
Git detail
-----------
500) show detail of current commit : \" git show \"
Git working trouble shoot
--------------------------
700) Move all committed and changed files to a new branch : \" git checkout -b \"
"

echo " Enter choice : \c" 
read choice
fi

case $choice in
1) git add . ;;
2) echo " Enter the git commit message ? ";
     read gitCommitMess ;
     git commit -m "$gitCommitMess" ;;
3) git push ;;
4) git log -n 5 ;;
10) git --version ;; 
100) git remote -v ;;
101) echo " Edit command and run \"git remote set-url origin <url> \"" ;;
200) git config --list ;;
201) git config --list --show-origin ;;
300) git branch ;;
301) git branch -r ;;
302) git branch -a ;;
400) git log ;;
500) git show ;;

     
*) echo "You guys home !" ;;
esac
