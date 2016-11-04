#!/bin/sh

TIME=$(date +"%Y%m%d%H%M%S")
LOCAL_BRANCH=$TIME
REMOTE_BRANCH=origin/master
PREV_BRANCH=

################################################################################
## function 
################################################################################
function printUsage() {
    echo "#########################################################"
    echo "You must specify tagname by -t option."
    echo "You might specify remote branch name by -b option."
    echo "If you want to annotated tag, please specifiy -a option."
    echo "[usage] sh $0 -t [TAGNAME]"
    echo "[usage] sh $0 -t [TAGNAME] -b [REMOTE_BRANCH]" 
    echo "[usage] sh $0 -a -t [TAGNAME] -b [REMOTE_BRANCH]"
    echo "#########################################################"
}

function getCurrentBranch {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    if [ "$inside_git_repo" ]; then
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        PREV_BRANCH="${ref#refs/heads/}"
    fi
}

################################################################################
## main
################################################################################
while  [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -t|--tag)
            TAGNAME="$2"
            shift
            ;;
        -b|--branch)
            REMOTE_BRANCH="$2"
            shift
            ;;
        -a|--annotated)
            OPTION="-a"
            ;;
        -h|--help)
            printUsage
            exit 1
            ;;
        *)
            ;;
    esac
shift
done

if [ -z $TAGNAME ]; then
    printUsage
    exit 1
fi

getCurrentBranch

TAGNAME=$TAGNAME-$TIME

echo git fetch -p origin
git fetch -p origin
echo git checkout -b $TIME $REMOTE_BRANCH
git checkout -b $TIME $REMOTE_BRANCH

echo git tag $OPTION $TAGNAME
git tag $OPTION -m "$TAGNAME" $TAGNAME

echo git push origin $TAGNAME
git push origin $TAGNAME

if [ -z $PREV_BRANCH ]; then
    PREV_BRANCH="master"
fi

git checkout $PREV_BRANCH
git branch -D $TIME

echo "### $TAGNAME Created."
