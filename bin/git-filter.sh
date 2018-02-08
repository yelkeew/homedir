#!/bin/bash

# echo ""
# echo "**********************************************************************"
# echo "env ="
# export
# echo "**********************************************************************"

# GIT_AUTHOR_DATE="@1351168763 -0400"
# GIT_AUTHOR_EMAIL="dan.weekley@nteligen.com"
# GIT_AUTHOR_NAME="Dan Weekley"
# GIT_COMMIT="ddb6bdd1194424e71ca80f97c09aefeb68a972b0"
# GIT_COMMITTER_DATE="@1351168763 -0400"
# GIT_COMMITTER_EMAIL="dan.weekley@nteligen.com"
# GIT_COMMITTER_NAME="Dan Weekley"
# GIT_DIR="/home/dw/scm/test-repo/.git"
# GIT_INDEX_FILE="/home/dw/scm/test-repo/.git-rewrite/t/../index"
# GIT_WORK_TREE="."

REGEX='.*\.rpm$'
TRACKING_FILE=".tig"

if [ -n "${GIT_COMMIT}" ]; then
    echo ""
    FILES="$(git show --pretty=format: --name-only ${GIT_COMMIT})"
#    for f in ${FILES}; do
#        echo " -   $f"
#    done

    RPMS=""
    for f in ${FILES}; do
        if [[ "${f}" =~ ${REGEX} ]]; then
            RPMS="${RPMS} ${f}"
        fi
    done

    if [ -n "${RPMS}" ]; then
        echo ""
        echo "Add RPMs to tracking file:"
        for r in ${RPMS}; do
            echo "  - $r"
        done

        # Add RPMs to the tracking file
        if [ ! -f "${TRACKING_FILE}" ]; then
            echo "Create tracking file"
            touch "${TRACKING_FILE}"
        else
            echo "Append to tracking file"
            echo "**********************************************************************"
            echo "                          ORIG TRACKING                               "
            echo ""
            cat ${TRACKING_FILE}
            echo "**********************************************************************"
        fi

        for r in ${RPMS}; do
            echo "$r" >> "${GIT_WORK_TREE}/${TRACKING_FILE}"
        done

        echo "**********************************************************************"
        echo "                          NEW TRACKING                                "
        echo ""
        cat ${TRACKING_FILE}
        echo "**********************************************************************"

        TRACKING_BLOB=$(git hash-object -w "${TRACKING_FILE}")
        git update-index --add --cacheinfo 100644 ${TRACKING_BLOB} ${TRACKING_FILE}
        #git add ${TRACKING_FILE}
        echo ""

    fi

fi
