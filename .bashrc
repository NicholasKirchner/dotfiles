#!/bin/sh

# Test for interactive shell and abort if not interactive
if [[ $- != *i* ]]; then
    return
fi

shopt -s checkwinsize

# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Programs
export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -t -a ""'
export PAGER="less"
export BROWSER="/Applications/Firefox.app/Contents/MacOS/firefox"
export SHELL="/opt/local/bin/bash"
export SAGE_ROOT="/Applications/Sage.app/Contents/Resources/sage"
export SAGE_DATA="$SAGE_ROOT/data/"
export VCPROMPT_FORMAT="%n:%b%m%u"

# Set prompt format.  Show the following, in this order:
# Last command successful (yellow :) for good, red X( for bad),
# num. jobs running, user@host (red for root, green otherwise),
# working directory in purple, version control info in yellow.
# Note: needed the \[ \] escape sequences around the color directives
# to correct word-wrap problem.

TERM_PROMPT_1=\
"\`if [ \$? = 0 ]; \
then echo \[\e[0\;33m\]:\)\[\e[m\]; \
else echo \[\e[0\;31m\]X\(\[\e[m\]; fi\` \
(\j)-\
\`if [ \$(id -u) -eq 0 ]; \
then echo \(\[\e[0\;31m\]\u@\h\[\e[m\]\); \
else echo \(\[\e[0\;32m\]\u@\h\[\e[m\]\); fi\`-\
(\[\e[0;35m\]\w\[\e[m\])-\
(\[\e[0;33m\]\$(vcprompt)\[\e[m\])\n$ "

#Old code for setting GUI window titles.  Josh Triplett suggests using
#PS1 rather than PROMPT_COMMAND.

#case $TERM in
#    xterm*|rxvt|Eterm|eterm)
#        PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}\007"'
#        ;;
#    screen)
#        PROMPT_COMMAND='echo -ne "\033_${PWD/$HOME/~}\033\\"'
#        ;;
#esac

#Title the GUI windows, if have GUI terminal
case $TERM in
    xterm*|rxvt|Eterm|eterm)
        PS1="\[\e]0;\W\a\]$TERM_PROMPT_1"
        ;;
    *)
        PS1="$TERM_PROMPT_1"
        ;;
esac

export PS1
export TERM_PROMPT_1

# Function to change terminal GUI titles
function term_title () {
    PS1="\[\e]0;$@\a\]$TERM_PROMPT_1"
}

# Set path so that MacPorts comes before built-in stuff
# insert /opt/local/libexec/gnubin for gnu tools.

export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:\
/usr/local/sbin:usr/local/lib:/usr/texbin:$PATH:~/bin"

export MANPATH="/opt/local/share/man:$MANPATH"

alias emacsd="/Applications/Emacs.app/Contents/MacOS/Emacs --daemon"
alias emacsc="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias sage="$SAGE_ROOT/sage"

# Load RVM
source ~/.rvm/scripts/rvm

# Notes: the --norc $PATH resides in .MacOSX/environment.plist
#        the /etc/paths is only activated for a login shell.

#Further notes: running sudo changes to bash 3.2.  Resolution: Set
#SHELL to "/opt/local/bin/bash"

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
