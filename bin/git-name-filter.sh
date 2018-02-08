#!/bin/bash -ex

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


git filter-branch --env-filter '
if [ -n "${GIT_AUTHOR_NAME}" ]; then
    case "${GIT_AUTHOR_NAME}" in
        "AFT Test user")
            NAME="Todd Last"
            ;;
        "Dan Hood")
            NAME="Daniel J. Hood"
            ;;
        djhood)
            NAME="Daniel J. Hood"
            ;;
        dschloss)
            NAME="David Schloss"
            ;;
        jchab)
            NAME="Jessie Chab"
            ;;
        jekarol)
            NAME="Joseph Karolchik"
            ;;
        johnson)
            NAME="Kirk Johnson"
            ;;
        ljohnson)
            NAME="Lynn Vigliante Johnson"
            ;;
        "Lynn Johnson")
            NAME="Lynn Vigliante Johnson"
            ;;
        marefin)
            NAME="Mollick Arefin"
            ;;
        npatrick)
            NAME="Norm Patrick"
            ;;
        pblack)
            NAME="Phil Black-Knight"
            ;;
        "Phil Black")
            NAME="Phil Black-Knight"
            ;;
        reedc)
            NAME="Collin Reed"
            ;;
        rhaggerty)
            NAME="Ryan Haggerty"
            ;;
        root)
            NAME="Todd Last"
            ;;
        rwissmann)
            NAME="Rob Wissmann"
            ;;
        smikolyski)
            NAME="Scott Mikolyski"
            ;;
        "test user")
            NAME="Todd Last"
            ;;
        tlast)
            NAME="Todd Last"
            ;;
        *)
            NAME="${GIT_AUTHOR_NAME}"
            ;;
    esac

    export GIT_AUTHOR_NAME="${NAME}"

fi
'
