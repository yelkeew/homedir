################################################################################
#
# Python script to handle multple input combinations of file and line number
# with the possible existence of a change-root environment and open the file
# at the optionally specified line number in an editor
#
# Author: Dan Weekley <weekley@pobox.com>
# Date: 15 Nov 2012
#
################################################################################
import os
import sys
import pwd

if 2 > len(sys.argv):
    print 'Usage: %s <fname-arg(s)>' % os.path.splitext(os.path.basename(sys.argv[0]))[0]
    sys.exit(0)

editor = 'emacsclient'
user = os.getenv('USER')
home = os.getenv('HOME')
emacsDir = os.path.join(home, 'emacs')

################################################################################
# Handle chroot environments
# Inside the chroot, we look for a /.chroot file that tells us where the
# change-root environment exists on the host system.
curDir = os.getcwd()
chrootHome = ''
while not chrootHome and not curDir == '/':
    curDir = os.path.normpath(os.path.join(curDir, '..'))
    chrootFile = os.path.join(curDir, '.chroot')
    if os.path.exists(chrootFile):
        cf = open(chrootFile)
        for line in cf:
            if line.startswith('ROOT:'):
                parts = line.split(':')
                chrootHome = parts[-1].strip()
                break
        if not chrootHome:
            print 'ERROR: couldn\'t parse "ROOT" field in "/.chroot" file'
            sys.exit(1)

################################################################################
# Split up the filename & trailing line number (if present)
#
# Example use case:
#  $ grep -R -n "foo" \*.c
#  src/bar.c:135:    val = foo(args);
#  src/foo.c:27:int foo(char *args)
#
# Using the mouse cursor, select either result.
# Type "ecn " and then paste the entire selection as arguments.
# Split the args into <filename>:<line-number>:<don't-care>
# Open file at specified location.
#
# Also handles the the simpler case where there is no colon-separated
# parameters after the filename, i.e., only one field.
#
# Finally, handle the case of manually-entered <filename> <line-number>
# separated by space(s).
#
# If opening an absoulte path from within a chroot environment, prepend
# the chroot path to the filename to get the true path to the file for
# the host's filesystem.  This also attemtps to handle the bind mounts
# mentioned above.

inputs = sys.argv[1:]

# Handle special case of single numeric argument, which is presumed
# to be an index into the find-results file -- output from the 'ffg'
# function in ~/.functions
if 2 == len(sys.argv):
    if sys.argv[1].isdigit():
        if not os.path.isfile(os.path.join(os.getcwd(), sys.argv[1])):
            f = open(os.path.join(home, 'tmp/find-results.txt'))
            if not f:
                print 'ERROR: couldn\'t open find-results file'
                sys.exit(1)

            number = int(sys.argv[1])
            line = f.readlines()[number - 1]
            f.close()
            if not line:
                print 'ERROR: no line %d in find-results file' % number
                sys.exit(1)

            try:
                inputs = [line.split()[1]]
            except IndexError:
                print 'ERROR: invalid format for find-results line - %s' % line
                sys.exit(1)

fname = inputs[0]
lnum = ''
if 1 < len(inputs):
    lnum = inputs[1]
else:
    fnameParts = fname.split(':')
    fname = fnameParts[0]
    if 1 < len(fnameParts):
        lnum = fnameParts[1]

#print 'chrootHome = %s' % chrootHome
#print 'fname = %s' % fname

if chrootHome and fname.startswith('/') and not fname.startswith('/home/'):
    fname = chrootHome + fname

if lnum:
    fnameArg = '+%s %s' % (lnum, fname)
else:
    fnameArg = fname

################################################################################
# Detect if this script is launched as "ecn.py", in which case we tell Emacs
# not to wait for the user to "finish" the buffer (C-x #).  This behavior
# requires something like the following:
# $HOME/bin/ecn        ### this script
# $HOME/bin/ec -> ecn  ### symlink
noWaitArg = ''
if os.path.basename(sys.argv[0]) == 'ecn.py':
    noWaitArg = ' -n'  # Use leading space for cleaner looking editArgs below

################################################################################
# Use a custom server socket.
# This allows calling `ecn' from a chroot environment where
# /tmp is different between the system running Emacs and the
# chroot system executing `emacsclient'.  Relies on a bind mount
# for the user's home directory, e.g.,
#    proc     /home/chroot/aft6.3-x86_64/proc proc    rw,relatime     0 0
#    sysfs    /home/chroot/aft6.3-x86_64/sys sysfs    rw,relatime     0 0
#    /dev     /home/chroot/aft6.3-x86_64/dev none     bind
#    /tmp     /home/chroot/aft6.3-x86_64/tmp none     bind
#    /home    /home/chroot/aft6.3-x86_64/home none    bind
#    /media   /home/chroot/aft6.3-x86_64/media none   bind
#    devpts   /home/chroot/aft6.3-x86_64/dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
serverSocket = ''
tmpPath = os.path.join(emacsDir, 'server-socket-dir', 'server')
if os.path.exists(tmpPath):
    serverSocket = tmpPath
else:
    try:
        uid = pwd.getpwnam(user).pw_uid
    except KeyError, e:
        print 'ERROR: couldn\'t get UID for user "%s"' % user
        sys.exit(1)

    tmpPath = '/tmp/emacs/%d/server' % uid
    os.path.exists(tmpPath)
    serverSocket = tmpPath

if not serverSocket:
    print 'ERROR: couldn\'t find Emacs server socket'
    sys.exit(2)

# emacsclient -s <server-socket> [-n] [+<lnum>] <fname>
editArgs = '%s -s %s%s %s' % (editor, serverSocket, noWaitArg, fnameArg)
#print editArgs

os.execvp(editor, editArgs.split())
