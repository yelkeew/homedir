#
#
#

import os
import sys
import subprocess

repoServer = 'aftyum'
repoRoot = '/opt/yum'

client = 'aftbuild-64'


def runSshCommand(server, cmdString):
    '''Run a command on the server via SSH.'''

    ssh = subprocess.Popen(["ssh", "%s" % server, cmdString],
                           shell = False,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()

    if result == []:
        error = ssh.stderr.readlines()
        print "ERROR: %s" % error
        return None
    else:
        return result


def getAvailablePackages(yumServer, yumRootDir):
    '''List available packages, per repository, on the Yum server.'''

    findRepoDirsCmd = 'find %s -mindepth 1 -maxdepth 1 -exec basename {} \;' % repoRoot

    repoDirList = runSshCommand(yumServer, findRepoDirsCmd)
    if not repoDirList:
        print 'ERROR: couldn\'t get list of repositories on server'
        sys.exit(1)

    listPackagesCmd = 'find %s -type f -name "*.rpm" -exec basename {} ".rpm" \;'

    allPackages = {}

    for d in repoDirList:
        repoName = d.strip()
        print '   repo: %s' % repoName
        packages = runSshCommand(yumServer, listPackagesCmd % (os.path.join(yumRootDir, repoName)))
        if not packages:
            print 'ERROR: couldn\'t list packages for repo "%s"' % repoName
            sys.exit(2)
        allPackages[repoName] = sorted([p.strip() for p in packages])

    return allPackages


def getInstalledPackages(client):
    '''List installed packages on the client.'''

    packages = runSshCommand(client, 'rpm -qa')
    if not packages:
        print 'ERROR: couldn\'t get installed packages for client "%s"' % client
        sys.exit(3)

    return sorted([p.strip() for p in packages])


if __name__ == '__main__':
    print 'Listing available packages...'
    repoPackages = getAvailablePackages(repoServer, repoRoot)
    #print repoPackages

    print 'Listing installed packages...'
    installed = getInstalledPackages(client)
    #print installed

    print 'Comparing installed against available...'
    for pkg in installed:
        #print '\n   checking for %s' % pkg
        found = False
        for repoName in repoPackages:
            #print '      check in %s' % repoName
            pkgList = repoPackages[repoName]
            if pkg in pkgList:
                found = True
                print '    %-60s%s' % (pkg, repoName)
                break
        if not found:
            print '!!! NOT FOUND: %s' % pkg
