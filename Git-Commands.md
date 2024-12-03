# Git Commands

https://www.youtube.com/watch?v=aolI_Rz0ZqY&t=581s

### Porcelain (82)

44 main commands  ( add , commit , push , pull , … )
11 manipulators   ( config, reflag, replace, ... )
17 interrogators  ( blame, fsck, rerere, … )
10 interactions   ( send-email, p4, svn, … )

### Plumbing(63)

19 manipulators     (apply, commit-tree, update-ref, …)
21 interrogators    (cat-file, for-each-ref, … )
5  syncing          (fetch-pack, send-pack, … )
18 internal         (check-after, sh-i18n, … )

### Total - 145

### Old but Goldies

git config --global alias.co checkout
git blam -L 12,20 path/to/file
git blame -w -C -C -C 
(-w ignore whitespace)
(-C detect lines moved or copied in the same commit)
(-C or the commit that created the file)
(-C or any commit of all time)
git log -S 
git reflog
git config --global rerere.enabled true ( Reuse Recorded Resolution )

### New stuff

git branch | head -5
git branch --column | git config --global column.ui auto
git config --global column.ui auto
git config --global branch.sort -commiterdate
git branch

git push --force-with-lease ( force push with first conflict check )

### Signing commits with SSH
git config gpg.format ssh
git config user.signkey ~/.ssh/key.pub
git commit -s

git maintainance start (make git process fast by running garbase collector by cron)

Big Repo - Window - 
### for commit-graph
git config --global fetch.writeCommitGraph true

### filesystem monitor
git config core.untrackedcache true
git config core.fsmonitor true

### Partial Clone
git clone --filter=blob:none
git clone --filter=tree:0

### Monorepo stuff

sparse-checkout

git sparse-checkout set build base

### Switch and Restore

since checkout is not only checking out , but doing other stuffs,

git switch branch
git switch -c new_branch (creating new branch) == git checkout new_branch
git restore file.txt == git checkout file.txt
git retore -p file.txt == git checkout -p file.txt

Hooks (28)

- applypatch-msg
- pre-applypatch
- post-applypatch
- pre-commit
- pre-merge-commit
- commit-msg
- post-commit
- pref-rebase
- post-checkout
- post-merge
- pre-push
- pre-receive
- update
- proc-receive
- post-receive
- post-update
- reference-transaction
- push-to-checkout
- sendemail-validate
- fsmonitor-watchman
- p4-changelist
- p4-prepare-changelist
- p4-post-changelist
- p4-pre-submit
- post-index-change

Useful Hooks(11)

### Commit Stuff
- pref-commit
- prepare-commit-msg
- commit-msg
- post-commit

### Rewriting Stuff
- pre-rebase
- post-rewrite

### Merging Stuff
- post-merge
- pre-merge-commit

Switching/Pushing Stuff
- post-checkout
- reference-transaction
- pre-push

Packages - pre-commit & husky










