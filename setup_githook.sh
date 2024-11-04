#!/bin/bash

echo "Starting Git hook setup..."

# Prompt user for the project path
read -p "Enter the project path: " PROJECT_PATH

# Update and install Apache2
echo "Updating package list and installing Apache2..."
sudo apt-get update
sudo apt-get install -y apache2
echo "Apache2 installation complete."

# Set permissions for the deployment directory
echo "Setting permissions for the deployment directory: $PROJECT_PATH"
sudo chown -R $(whoami):$(id -gn) $PROJECT_PATH
echo "Permissions set for $PROJECT_PATH."

# Create a bare Git repository
REPO_DIR="$HOME/proj"
echo "Creating a bare Git repository at $REPO_DIR..."
mkdir -p $REPO_DIR
cd $REPO_DIR
git init --bare
echo "Bare Git repository created."

# Create the post-receive hook
HOOK_FILE="hooks/post-receive"
echo "Creating post-receive hook at $HOOK_FILE..."
cat << EOF > $HOOK_FILE
#!/bin/bash
while read oldrev newrev ref
do
    if [[ \$ref =~ .*/main$ ]]; then
        echo "Main ref received. Deploying main branch to production..."
        if git --work-tree=$PROJECT_PATH --git-dir=$REPO_DIR checkout -f main; then
            echo "Deployment successful."
        else
            echo "Deployment failed. Please check if the 'main' branch exists and has commits."
        fi
    else
        echo "Ref \$ref successfully received. Doing nothing: only the main branch may be deployed on this server."
    fi
done
EOF

# Make the post-receive hook executable
echo "Making the post-receive hook executable..."
chmod +x $HOOK_FILE
echo "Post-receive hook is now executable."

echo "Git hook setup complete. You can now push to the 'main' branch to deploy."
