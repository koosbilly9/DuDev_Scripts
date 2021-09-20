#!/bin/bash
#====================
#Purpose : do a unix command each day
#
# History
#--------
#
#2021/09/20   Billy   Init
#
#=======================================

echo " Todays command 
-- display man page - :q to exit man page
1) grep 
enter choice : \c "
read choice

case $choice in
1) man grep ;;
*) echo "ah ah aah "
esac


