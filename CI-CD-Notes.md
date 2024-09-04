### Git Hooks Categories

1. Client-Side Hooks - executed on commiter's computer.
   ( Commit , Email Workflow Hooks and Merge,rebase,rewrite and clearning repo)

2. Server-Side Hooks - executed on servers that are used to receive pushes.
   ( Pre-receive, Post-receive , Update )


### Set Up the Production Server Post-Receive Hook

      sudo apt-get update
      sudo apt-get install apache2

      sudo chown -R `whoami`:`id -gn` /var/www/task-management

  - Go to /var/www/

        mkdir ~/proj
        cd ~/proj
        git init --bare
     
   - Create Hook
     
         nano hooks/post-receive

      Copy This

         #!/bin/bash
          # Bare repository directory.
          GIT_DIR="/var/www/proj"
          # Target directory.
          TARGET="/var/www/task-management"
          while read oldrev newrev ref
          do
          BRANCH=$(git rev-parse --symbolic --abbrev-ref $ref)
          if [[ $BRANCH == "main" ]]; then
              echo "Push received! Deploying branch: ${BRANCH}..."
              # deploy to our target directory.
              git --work-tree=$TARGET --git-dir=$GIT_DIR checkout -f $BRANCH
          else
              echo "Not main branch. Skipping."
          fi
          done

  - Make Script Executable

          chmod +x hooks/post-receive
       
       
