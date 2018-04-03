# .bashrc

##########################################################################################
#
#
#                          Environment exports
#
#
##########################################################################################
# Set up a multi-line, color prompt
### export PS1='\[\033[0;34m\]\u\[\033[0m\]@\[\033[0;31m\]\h\[\033[0m\] [${PWD}]\n \! \$ '
# Following is a two-line, red/blue prompt good for light backgrounds
### export PS1='\[\033[0;34m\]\u\[\033[0m\]@\[\033[0;31m\]\h\[\033[0m\] \w\n \! \$ '
# Following is a two-line, green/yellow prompt good for dark backgrounds
### export PS1='\[\033[0;32m\]\u@\h\[\033[0m\] \[\033[0;33m\]\w\[\033[0m\]\n \! \$ '

# Use PROMPT_COMMAND to get some status variables into command line prompt
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"

BOLD="\[\033[1m\]"
OFF="\[\033[0m\]"


function my_prompt
{
    # Check for error return code from previous command
    local ERR_VAL=$?
    local RC=""
    if [ "${ERR_VAL}" -ne 0 ]; then
        RC="[${ERR_VAL}] "
    fi

   # Current Git branch, if CWD is in a Git repository
   local GIT=""
   if git rev-parse --git-dir > /dev/null 2>&1; then
       GIT="[$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')] "
   fi

#   # Check for change-root environment
#   local CHROOT=""
#   if [ -f /.chroot ]; then
#       CHROOT_VER="$(awk '/^VERSION/ {print $2}' < /.chroot)"
#       CHROOT="*CHROOT ${CHROOT_VER}* "
#   fi

    # Check for running Vagrant VirtualBox VM
    local VM_RUNNING=""
    if [ -f ./.vagrant/machines/default/virtualbox/id ]; then
        VM_RUNNING="VM:stopped "
        if $(VBoxManage list runningvms | grep -q $(cat ./.vagrant/machines/default/virtualbox/id)); then
          VM_RUNNING="VM:running "  
        fi
    fi

    ### Print line of underscores above prompt to separate from previous command's output
    # Get length of printable characters in prompt
    #PRINTABLE="${RC_STR}${USER}@${HOSTNAME%%.*} ${PWD} ${GIT_STR} ${CHROOT_STR}"
    #printf "%${#PRINTABLE}s\n" | tr " " "_"  # print horizontal line just above prompt

    ### Enhanced history logging/recall
    #local HIST_NUM=$((${HISTCMD} - 1))
    #local LAST_CMD=$(fc -n -l ${HIST_NUM} ${HIST_NUM} | sed -e 's/^[ \t]*//')
    #echo -e "\nLAST=\"${LAST_CMD}\"\n"

    local ERR_STR="${BOLD}${MAGENTA}${RC}${OFF}"
    local HOST_STR="${GREEN}${USER}@${HOSTNAME%%.*}${OFF}"
    local PWD_STR="${YELLOW}${PWD}${OFF}"
    local GIT_STR="${GIT}"
    local CHROOT_STR=""
#   local CHROOT_STR="${RED}${CHROOT}${OFF}"
    local VM_STR="${WHITE}${VM_RUNNING}${OFF}"

    PS1="${ERR_STR}${HOST_STR} ${PWD_STR} ${GIT_STR}${CHROOT_STR}${VM_STR}\n \! \$ "
}
export PROMPT_COMMAND=my_prompt

# 12/10/2012 -- This appears to interfere with command entry & history scrollback
#               for multi-line commands.
#
# BASH_VERSION_PARTS="$(echo ${BASH_VERSION} | awk 'BEGIN {FS="."} {print $1, $2}')"
# BASH_VERSION_MAJ=$(echo ${BASH_VERSION_PARTS} | cut -d ' ' -f1)
# BASH_VERSION_MIN=$(echo ${BASH_VERSION_PARTS} | cut -d ' ' -f2)
#
# # Showing command in window title bar only works in Bash v3.11 & newer
# SHOW_COMMAND=0
# case "${BASH_VERSION_MAJ}" in
#     3)
#         if [ "${BASH_VERSION_MIN}" -gt "1" ]; then
#             SHOW_COMMAND=1
#         fi
#         ;;
#     [4-9])
#         SHOW_COMMAND=1
#         ;;
#     *)
#         ;;
# esac
#
#
# # dw 11/16/2012 -- Originally from: http://mg.pov.lt/blog/bash-prompt.html
# if [ "${SHOW_COMMAND}" -eq "1" ]; then
#     # If this is an xterm set the title to user@host:dir
#     case "${TERM}" in
#         xterm*|rxvt*|screen)
#             # Show the currently running command in the terminal title:
#             # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
#             show_command_in_title_bar ()
#             {
#                 case "$BASH_COMMAND" in
#                     *\033]0*)
#                         # The command is trying to set the title bar as well;
#                         # this is most likely the execution of $PROMPT_COMMAND.
#                         # In any case nested escapes confuse the terminal, so don't
#                         # output them.
#                         ;;
#                     *)
#                         if [ "${BASH_COMMAND}" != "${PROMPT_COMMAND}" ]; then
#                             CMD="${BASH_COMMAND}"
#                             echo -ne "\033]0;${USER}@${HOSTNAME}: ${BASH_COMMAND}\007"
#                         fi
#                         ;;
#                 esac
#             }
#             trap show_command_in_title_bar DEBUG
#             ;;
#         *)
#             ;;
#     esac
# fi


# Pretty-up the history output
export HISTSIZE=1000000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="[ %a, %m/%d/%Y %H:%M:%S ] "

# Bash history ignore options
#  - duplicated commands
#  - checking return value of last command, aliased through '?'
#  - history delete commands, aliased through 'hd'
#  - history tail commands, aliased through 'ht'
#  - list current directory contents, aliased through 'd'
#  - view tree of remembered directories, aliased through 't'
#  - show mounted filesystems, aliased through 'm'
#  - cd -, through '-' function
#  - exit from Bash
export HISTIGNORE="&:\?:hd*:ht:t:d:m:-:exit"

MY_EDITOR="${HOME}/bin/ecn"

# Set the visual editor, required by svn & p4
export VISUAL="${MY_EDITOR}"
export EDITOR="${MY_EDITOR}"
export ALTERNATE_EDITOR="${MY_EDITOR}"

# Set up cscope to use my Python 'ecn.py' script
export CSCOPE_EDITOR="${HOME}/bin/cscope-editor"
export CSCOPE_LINEFLAG="--line %s"
export CSCOPE_LINEFLAG_AFTER_FILE="yes"

# Set diff & merge utilities
export DIFF="kdiff3"
export MERGE="kdiff3"

# Set the location of my ".indent.pro" file
export INDENT_PROFILE="${HOME}/.indent.pro"

# Enable colorizing matches in grep output
export GREP_COLOR='00;34'

# Set the `man' pager - keeps man text on screen after exiting program
export MANPAGER='less -iFRSX'

##########################################################################################
#
#
#                          User specific aliases and functions
#
#
##########################################################################################

# Import bash aliases
export ALIASRC="${HOME}/.aliases"
if [ -f ${ALIASRC} ]; then
	. ${ALIASRC}
fi

export FUNCRC="${HOME}/.functions"
if [ -f ${FUNCRC} ]; then
    . ${FUNCRC}
fi

# Shell file/directory coloring
if [ -f ~/.dircolors ]; then
    eval `dircolors ~/.dircolors` > /dev/null
fi

##########################################################################################
#
#
#                          Shell configuration
#
#
##########################################################################################

### # Load xmodmap to configure keyboard customizations
### xmodmap ~/.xmodmap

# Set hard/soft limits on coredumps to unlimited
ulimit -c unlimited

# Add directories to PATH
pathmunge ${HOME}/bin

# Add windows executable links to end of PATH so that Cygwin versions and scripts are
# picked up first
if [ "CYGWIN_NT-10.0" == "$(uname)" ]; then
    if [ -d ${HOME}/bin/windows ]; then
        pathmunge ${HOME}/bin/windows after
    fi
fi

export PATH

# Check to see if this is an SSH session; if so, don't attempt to start
# screen, synergy, etc.
if [ -z "${SSH_TTY}" ]; then

    # Determine whether to start Synergy server
    if [ -f ${HOME}/.synergy.conf -a -x /usr/bin/synergys ]; then
        SYN_PID=$(/usr/sbin/pidof synergys)
        if [ -z "${SYN_PID}" ]; then
            synergys -d WARNING  # No log messages below WARNING level
        fi
    fi

    # Determine whether to start tmux
    DO_SCREEN=1

    # Skip if not on a character device TTY
    if [ ! -c "$(/usr/bin/tty)" ]; then
        DO_SCREEN=0
    fi

    # Skip if running from change root environment
    if [ -f /.chroot ]; then
        DO_SCREEN=0
    fi

    # Skip if STY/SCREEN is defined -- screen/tmux is already running
    if [ -n "${STY}" ]; then
        DO_SCREEN=0
    fi

    if [ 1 == ${DO_SCREEN} ]; then
        # Make sure /var/run/screen exists
        if [ ! -d /var/run/screen ]; then
            sudo mkdir -p /var/run/screen
            sudo chmod 0777 /var/run/screen
        fi

        screen 
    fi
else

    # This is an SSH session, so make sure DISPLAY is set up correctly
    export DISPLAY="$(echo $SSH_CLIENT | awk '{print $1}'):0.0"

fi  # SSH_TTY

cd $HOME

