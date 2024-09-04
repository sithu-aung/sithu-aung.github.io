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
         while read oldrev newrev ref
         do
             if [[ $ref =~ .*/main$ ]];
             then
                 echo "Main ref received. Deploying main branch to production..."
                 if git --work-tree=/var/www/task-management --git-dir=$HOME/proj checkout -f main; then
                     echo "Deployment successful."
                 else
                     echo "Deployment failed. Please check if the 'main' branch exists and has commits."
                 fi
             else
                 echo "Ref $ref successfully received. Doing nothing: only the main branch may be deployed on this server."
             fi
         done

  - Make Script Executable

          chmod +x hooks/post-receive

  - On Client Side

        ssh -i /Users/dev/Desktop/Dev/devssh root@170.64.231.139

    
       
       
