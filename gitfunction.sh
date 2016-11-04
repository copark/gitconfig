#!/bin/sh

# download source - git clone 
# work in local directory and push remote server - git add , git commit,  git  push 
# make branch - git checkout -b <branch>
# switch branch - git checkout <branch>, git checkout master
# remove branch - git branch -d <branch>
# revert - git checkout -- <file>


# initalize alias must be call in bashrc
function git_init {
    git config --global core.whitespace cr-at-eol
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status -s
    git config --global alias.diff diff --word-diff
    git config --global alias.dc diff --cached
    git config --global alias.last "log -1 HEAD"
    git config --global alias.timeline "log --oneline --graph --decorate"
    git config --global alias.rvt "checkout HEAD ."
    git config --global alias.lg "log --all --oneline --decorate --graph"
    git config --global alias.fc fetch -p
    git config --global core.editor /usr/bin/vim
}

# show tracked all files
function git_files {
    git ls-files
}

function git_files_stage {
    git ls-files --stage
}

function git_tag {
    git tag -a $1
}

# show untracked all files
function git_untracked {
    git ls-files --other --exclude-standard
}

# checkout HEAD first
function git_update_force {
    git checkout HEAD .
}

# remove untracked file
function git_cleanup {
    git clean -f -d
}

# show last log message
function git_last {
    git init
    git last
}

# show all timeline log
function git_timeline {
    git_init
    git timeline
}

# add 
function git_add {
    git add $1
}

function git_unadd {
    git rm --cached $1
}

# add branch
function git_add_branch {
    git branch $1
}

# switch branch
function git_switch_branch {
    git checkout $1
}

# remove local branch
function git_remove_branch {
    git branch -D $1
}

function git_track {
    git checkout --track -b $1 $2
}

function git_stash_drop {
    git stash drop stash@{$1}
}

function git_remove_branch {
    git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}
