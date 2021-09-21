#!/bin/bash
#================================
# Purpose: shortcut for apt debian applications manager 
#
# History
# --------
# 2021/09/21	Billy	Init
#=======================================================

echo "
apt is debian applications manager app

1) Refresh all - \"sudo apt update\"
2) Check for packages that can be upgrade - \"apt list --upgradable\"
3) install libreoffice - \" sudo apt install libreoffice \"

enter choice : "
read choice

case $choice in
1) sudo apt update ;;
2) apt list --upgradable ;;
3) sudo apt install libreoffice ;;
*)
esac
