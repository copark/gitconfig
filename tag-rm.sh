#!/bin/sh

#####################################################
# 현재 버전은 qa 로 시작하는  tag만 삭제하도록 한다.
#####################################################
REMOVE_TAG=qa/
MASTER_BRANCH=origin/master
TAGNAME=$REMOVE_TAG

#####################################################
## Function
#####################################################
function rmTag() {
    name=$1
    if [[ ! $name =~ .*"refs/tags/".* ]] || [[ $name =~ .*"^{}".* ]]; then
        return 0
    fi

    realname="${name/refs\/tags\/}"
    echo "CAUTION: REMOVE TAGNAME IS " $realname

    echo git tag -d $realname
    git tag -d $realname
    echo git push origin :$realname
    git push origin :$realname
    echo $realname
}

#####################################################

# ONLY ALLOW REMOVE qa branch
if [[ ! $TAGNAME == *"$REMOVE_TAG"* ]]; then
    echo "NOT ALLOWD REMOTE $TAGNAME"
    exit 1
fi

# git reset --hard $MASTER_BRANCH
TAG_LIST=$(git ls-remote -q -t | grep $TAGNAME)
for name in $TAG_LIST; do
    rmTag $name
done

echo "JOBS DONE."
