PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/syno/bin:/usr/syno/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin"
umask 022
#This fixes the backspace when telnetting in.
#if [ "$TERM" != "linux" ]; then
#        stty erase
#fi
export PATH
HOME=/root
export HOME
TERM=${TERM:-cons25}
export TERM
PAGER=more
export PAGER
PS1="`hostname -s`> "
alias dir="ls -al"

#debug_Aaron on 10/05/2006 for rtorrent
export COLUMNS=111
export LINES=35
