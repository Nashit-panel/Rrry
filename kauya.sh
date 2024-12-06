#!/bin/bash
# Navigate to the Pterodactyl directory
cd /var/www/pterodactyl || exit
# Download the all_in_one.zip file
wget https://github.com/Nashit-panel/Pterodactyl-installer/raw/refs/heads/main/all_in_one.zip
# Rename the downloaded file to release.zip
mv all_in_one.zip release.zip && unzip release.zip && rm -r resources/scripts/routers/ServerElements.tsx
# Install Node Version Manager (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# Load NVM without opening a new shell
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Install Node.js version 16.16.0
nvm install 16.16.0
# Install Yarn globally using npm
npm install -g yarn
# Run Yarn to install dependencies
yarn
# Navigate to the scripts/routers directory
cd resources/scripts/routers || exit
# Remove the existing routes.ts file
rm -r routes.ts
# Download the updated routes.ts file
wget https://github.com/Nashit-panel/Pterodactyl-installer/raw/refs/heads/main/routes.ts
# Return to the Pterodactyl directory
cd /var/www/pterodactyl || exit
# Run the fyrehost installer
npx fyrehostinstaller@latest 

# Build the production assets
yarn add sanitize-html@2.7.3 @types/sanitize-html@2.6.2 && yarn build:production
# Clear Laravel cached files
php artisan view:clear
php artisan route:clear
php artisan config:clear
php artisan optimize:clear
# Adjust permissions for the Pterodactyl directory
cd /var/www || exit
chmod -R 755 pterodactyl/*
