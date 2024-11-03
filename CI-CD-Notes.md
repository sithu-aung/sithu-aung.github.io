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

  -      ssh -i /Users/dev/Desktop/Dev/devssh root@170.64.231.139

  -     git remote add production root@170.64.231.139:proj

  - In case of SSH config

         chmod 600 /Users/dev/Desktop/Dev/devssh
           eval "$(ssh-agent -s)"
           ssh-add /Users/dev/Desktop/Dev/devssh


    -----------------------------------------------------
    # Setting Up Git Hooks for Deployment

## Server-Side Setup

1. **Update and Install Apache2:**
   ```bash
   sudo apt-get update
   sudo apt-get install apache2
   ```

2. **Set Permissions:**
   Change ownership of the directory where your application will be deployed:
   ```bash
   sudo chown -R `whoami`:`id -gn` /var/www/task-management
   ```

3. **Create a Bare Git Repository:**
   Navigate to the directory where you want to store your Git repository and initialize a bare repository:
   ```bash
   mkdir ~/proj
   cd ~/proj
   git init --bare
   ```

4. **Create a Post-Receive Hook:**
   Navigate to the hooks directory and create a `post-receive` hook:
   ```bash
   cd hooks
   nano post-receive
   ```

   Add the following script to the `post-receive` file:
   ```bash
   #!/bin/bash
   while read oldrev newrev ref
   do
       if [[ $ref =~ .*/main$ ]]; then
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
   ```

5. **Make the Hook Executable:**
   ```bash
   chmod +x post-receive
   ```

## Client-Side Setup

1. **SSH into the Server:**
   Use SSH to connect to your server:
   ```bash
   ssh -i /path/to/your/private/key root@your.server.ip
   ```

2. **Add a Remote Repository:**
   On your local machine, add the server as a remote repository:
   ```bash
   git remote add production root@your.server.ip:proj
   ```

3. **Configure SSH (if necessary):**
   Ensure your SSH key has the correct permissions and is added to the SSH agent:
   ```bash
   chmod 600 /path/to/your/private/key
   eval "$(ssh-agent -s)"
   ssh-add /path/to/your/private/key
   ```

## Deployment

- To deploy your code, push to the `main` branch of the `production` remote:
  ```bash
  git push production main
  ```

> **Note:** Replace `/path/to/your/private/key` and `your.server.ip` with your actual SSH key path and server IP address.

    
       
       
