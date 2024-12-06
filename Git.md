Git

Concurrent Versions System(CVS) - 1986 by Walter F.Tichy at Purdue University  and at 1990 released public. Does not include integrity check , data can become corrupted

CVS successor - Subversion (SVN) - 2000



Git vs Other VCS - version control systems ( Subversion ,Perforce and friends included) = The way Git thinks about its data.

Other thinks information  as set of files and the changes made to each file over time - delta-based version control

Git thinks of its data as a series of snapshots of a miniature filesystem.  == Stream of snapshots

Take a snapshot of all files and stores a reference to that snapshot,
If no changes to file , don’t store the reference again

Git stored on local copy and con do nearly everything while offline , others CVS can’t do

Everything in Git is checksummed before it is stored and is referred by that checksum - meanings impossible to change file contents without Git knowing about that - SHA-1 hash

Three main states

1. Modified - changed in local
2. Staged    - marked modified file in its current version to go into next commit snapshot
3. Committed - data is safely stored in your local database

Author and Committer. The author is the person who originally wrote the work, whereas the committer is the person who last applied the work.

Two types of Tags - lightweight and annotated

Lightweight - like a branch that doesn’t change - just a pointer to a specific commit

Annotated  - stored as full objects in the Git database

Aliases ( for shortcut to command)

Branching - the killer feature set Git apart in the VCS community.

Useful Commands

* git config --list --show-origin
* git config —global user.name “username”
* git config —global user.email “useremail”
* git status ( for tracking files)
* git log ( for commit history)
* git log --pretty=format:"%h - %an, %ar : %s"
* git log —pretty=format:”%h %s” —graph
* git log —since=2.weeks
* git log --pretty="%h - %s" --author='Junio C Hamano' --since="2008-10-01" \   --before="2008-11-01" --no-merges -- t/
* git commit —amend (for undoing or overriding first commit)
* git reset Head file_name (unstaging a staged file) 
* git checkout -- file_name ( unmodifying modified file)
* git restore —staged file_name (for unstage) ( instead of reset from V2.23.0 onwards)
* git restore file_name ( to discard)
* git remote -v (for showing remotes)
* git remote add pb https://github.com/test
* git fetch (only download data to local - but does not merge)
* git remote show origin (for inspecting a remote)
* git remote rename pb paul (renaming)
* git remote remove paul (removing)
* git tag -a v1.4 -m “Version 1.4” (creating annotated tag)
* git tag v1.4-lw(creating lightweight tag)
* git tag -a v1.2 commit_hash
* git push origin <tagname> (for sharing tag to shared server) 
* git config —global alias.co checkout
* git config —global alias.br branch
* git config —global alias.ci commit
* git config —global alias.st status
* git branch testing(create new branch)
* git checkout testing(switching to existing branch)
* git branch -d testing(deleting branch)
* git merge testing ( merge to current checkout branch)
* git mergetool (for visual merging)
* git branch —merged/—no-merged
* git branch —move bad-branch-name corrected-branch-name( rename local first)
* git push —set-upstream origin corrected-branch-name( push to remote)
* git branch —move master main ( rename master to main in local first)
* git push —set-upstream origin main
* git push origin —delete master(have done all tasks)


### Connecting To Github Vis SSH

ssh - keygen -t ed25519 -C "your_email@gmail.com"
ls ~/.ssh/
pb < ~/.ssh/<YOUR KEY>.pub


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


Useful Commands

* git config --list --show-origin
* git config —global user.name “username”
* git config —global user.email “useremail”
* git status ( for tracking files)
* git log ( for commit history)
* git log --pretty=format:"%h - %an, %ar : %s"
* git log —pretty=format:”%h %s” —graph
* git log —since=2.weeks
* git log --pretty="%h - %s" --author='Junio C Hamano' --since="2008-10-01" \   --before="2008-11-01" --no-merges -- t/
* git commit —amend (for undoing or overriding first commit)
* git reset Head file_name (unstaging a staged file) 
* git checkout -- file_name ( unmodifying modified file)
* git restore —staged file_name (for unstage) ( instead of reset from V2.23.0 onwards)
* git restore file_name ( to discard)
* git remote -v (for showing remotes)
* git remote add pb https://github.com/test
* git fetch (only download data to local - but does not merge)
* git remote show origin (for inspecting a remote)
* git remote rename pb paul (renaming)
* git remote remove paul (removing)
* git tag -a v1.4 -m “Version 1.4” (creating annotated tag)
* git tag v1.4-lw(creating lightweight tag)
* git tag -a v1.2 commit_hash
* git push origin <tagname> (for sharing tag to shared server) 
* git config —global alias.co checkout
* git config —global alias.br branch
* git config —global alias.ci commit
* git config —global alias.st status
* git branch testing(create new branch)
* git checkout testing(switching to existing branch)
* git branch -d testing(deleting branch)
* git merge testing ( merge to current checkout branch)
* git mergetool (for visual merging)
* git branch —merged/—no-merged
* git branch —move bad-branch-name corrected-branch-name( rename local first)
* git push —set-upstream origin corrected-branch-name( push to remote)
* git branch —move master main ( rename master to main in local first)
* git push —set-upstream origin main
* git push origin —delete master(have done all tasks)






